//
//  LHStakeVoteManageTableViewController.m
//  TaiYiToken
//
//  Created by mac on 2020/11/17.
//  Copyright © 2020 admin. All rights reserved.
//

#import "LHStakeVoteManageTableViewController.h"
#import "LHStakeVoteMainTableViewCell.h"
#import "LHStakeVoteDetailTableViewController.h"
#import "LHStakeVoteAddTableViewController.h"

@interface LHStakeVoteManageTableViewController ()
{
    NSString *mgp_bpvoting;
}

@property(strong, nonatomic) NSMutableArray *listArray;
@property(assign, nonatomic) int refund_delay_sec;
@property(copy, nonatomic) NSString *rewardsStr;

@property (weak, nonatomic) IBOutlet UILabel *unclaimed_rewards;
@property (weak, nonatomic) IBOutlet UILabel *unclaimed_rewards_subtitle;
@property (weak, nonatomic) IBOutlet UIView *heaerView;


@end
//
@implementation LHStakeVoteManageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 65, 0)];
    mgp_bpvoting = [[DomainConfigManager share]getCurrentEvnDict][bpvoting];
    _unclaimed_rewards_subtitle.text = NSLocalizedString(@"待领取", nil);

    self.tableView.rowHeight = 110;
    self.tableView.tableFooterView = [UIView new];
    
    self.tableView.mj_header = [DCHomeRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(upRecData)];
    [self.tableView.mj_header beginRefreshing];
    
  
}

/// 加载数据             dispatch_group_leave(group);
- (void)upRecData{
    self.listArray = [NSMutableArray array];
    if (!self.isNoteVC) {
        [self loadVoteData];
    }else{
        [self loadNoteData];
    }
}
#pragma -----------------我的投票请求接口函数---------------------------
- (void)loadVoteData{
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_group_t group = dispatch_group_create();
    //-----------------------------------votes 函数-------------------------------------------
    dispatch_group_enter(group);
    [[MGPHttpRequest shareManager]post:@"/voteNode/votes" paramters:@{@"account":[MGPHttpRequest shareManager].curretWallet.address} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
        dispatch_group_leave(group);

        if ([responseObj[@"code"]intValue] == 0) {
            NSArray *arr = (NSArray *)[responseObj[@"data"]objectForKey:@"list"];
            [self.listArray addObjectsFromArray:arr];
        }
                                
    }];
    
    /*
    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary *dic = @{
            @"json": @1,
            @"code": mgp_bpvoting,
            @"scope":mgp_bpvoting,
            @"index_position":@"2",
            @"table":@"votes",
            @"key_type":@"i64",
            @"limit":@"500",
            @"lower_bound":[MGPHttpRequest shareManager].curretWallet.address,
            @"upper_bound":[MGPHttpRequest shareManager].curretWallet.address
        };

        [[HTTPRequestManager shareMgpManager] post:eos_get_table_rows paramters:dic success:^(BOOL isSuccess, id responseObject) {

            NSLog(@"voters：%@",responseObject);
            dispatch_group_leave(group);
            if (isSuccess) {
                NSArray *arr = (NSArray *)responseObject[@"rows"];
                for (NSDictionary *p in arr) {
                    if ([p[@"unvoted_at"]isEqualToString:@"1970-01-01T00:00:00.000"]) {
                        [self.listArray insertObject:p atIndex:0];
                    }
                } 
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error);

        } superView:self.view showFaliureDescription:YES];
        
        
    });
    */
    
    //-----------------------------------voters 函数-------------------------------------------
    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSDictionary *votersDic = @{
            @"json": @1,
            @"code": mgp_bpvoting,
            @"scope":mgp_bpvoting,
            @"table":@"voters",
            @"lower_bound":[MGPHttpRequest shareManager].curretWallet.address,
            @"upper_bound":[MGPHttpRequest shareManager].curretWallet.address
        };
        [[HTTPRequestManager shareMgpManager] post:eos_get_table_rows paramters:votersDic success:^(BOOL isSuccess, id responseObject) {

            NSLog(@"voters：%@",responseObject);
            dispatch_group_leave(group);

            if (isSuccess) {
                NSArray *arr = (NSArray *)responseObject[@"rows"];
                NSDictionary *dic = arr.firstObject;
                _rewardsStr = [dic[@"unclaimed_rewards"] componentsSeparatedByString:@" "].firstObject;
            }
        } failure:^(NSError *error) {
            
        } superView:self.view showFaliureDescription:YES];
        
    });
    
    //-----------------------------------global 函数-------------------------------------------
    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[HTTPRequestManager shareMgpManager] post:eos_get_table_rows paramters:@{@"json": @1,@"code": mgp_bpvoting,@"scope":mgp_bpvoting,@"table":@"global"} success:^(BOOL isSuccess, id responseObject) {

            NSLog(@"global：%@",responseObject);
            dispatch_group_leave(group);

            if (isSuccess) {
                NSArray *arr = (NSArray *)responseObject[@"rows"];
                NSDictionary *dic = arr.firstObject;
                _refund_delay_sec = [dic[@"refund_delay_sec"] intValue];
            }
        } failure:^(NSError *error) {
            
        } superView:self.view showFaliureDescription:YES];
        
        
    });
    
    //二个网络请求都完成统一处理
    dispatch_group_notify(group, queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{

            self.unclaimed_rewards.text = _rewardsStr.length <= 0 ? @"0" : _rewardsStr;

            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];

        });
        
    });
    
}
#pragma ----------------------------------我的节点请求接口函数----------------------------------
- (void)loadNoteData{
    NSDictionary *dic = @{
        @"json": @1,
        @"code": mgp_bpvoting,
        @"scope":mgp_bpvoting,
        @"table":@"candidates",
        @"lower_bound":[MGPHttpRequest shareManager].curretWallet.address,
        @"upper_bound":[MGPHttpRequest shareManager].curretWallet.address
    };
    
    [[HTTPRequestManager shareMgpManager] post:eos_get_table_rows paramters:dic success:^(BOOL isSuccess, id responseObject) {
             
        NSLog(@"candidates:%@",responseObject);
        if (isSuccess) {
            NSArray *arr = (NSArray *)responseObject[@"rows"];
            [self.listArray addObjectsFromArray:arr];
            
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView endFooterRefresh];
            NSDictionary *dict = self.listArray.firstObject;

            _rewardsStr = [dict[@"unclaimed_rewards"] componentsSeparatedByString:@" "].firstObject;
            self.unclaimed_rewards.text = _rewardsStr.length <= 0 ? @"0" : _rewardsStr;

            
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView endFooterRefresh];
    } superView:self.view showFaliureDescription:YES];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.listArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LHStakeVoteMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LHStakeVoteMainTableViewCellIndex" forIndexPath:indexPath];

    NSDictionary *dic = self.listArray[indexPath.row];
    if (!self.isNoteVC) {
        cell.address.text = dic[@"node_name"]?:dic[@"candidate"];
        cell.reward_share.text = [NSString stringWithFormat:@"%@%.f%%",NSLocalizedString(@"获得比率", nil),(10000-[[dic objectForKey:@"share_ratio"]doubleValue])/100];
        cell.url_votes.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"节点", nil),VALIDATE_STRING([dic objectForKey:@"node_url"])];

        cell.received_votes.text = [NSString stringWithFormat:@"%@",dic[@"quantity"]];
        [cell.votesBtn setTitle:NSLocalizedString(@"撤回", nil) forState:UIControlStateNormal];

        NSDate *date = [NSDate dateFromString:dic[@"voted_at"]];
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
        NSTimeInterval time = [timeSp doubleValue];
        
        NSDate *date2=[NSDate dateWithTimeIntervalSince1970:time];
        NSDate *date3 = [date2 dateByAddingHours:8];
        NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"YYYY/MM/dd HH:mm:ss"];
        
        NSString *staartstr=[dateformatter stringFromDate:date3];
        
        BOOL isShow = [self dateDifferenceValue:[self getTimeStrWithString:staartstr]];
        cell.votesBtn.hidden = !isShow;
        
    }else{
        cell.address.text = dic[@"owner"];
        cell.reward_share.text = [NSString stringWithFormat:@"%@%.f%%",NSLocalizedString(@"投票者获得比率", nil),(10000-[dic[@"self_reward_share"] doubleValue])/100];
        cell.received_votes.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"已投", nil),dic[@"received_votes"]];

        [cell.votesBtn setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];

        cell.url_votes.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"质押", nil),dic[@"staked_votes"]];

    }
    
    
    
    
//    cell.url_votes.text = @"";// VALIDATE_STRING(@"节点：http:ba**u.com");
    cell.votesBtn.tag = indexPath.row;
    [cell.votesBtn addTarget:self action:@selector(votesClick:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.rank.text = @"";// [NSString stringWithFormat:@"%ld",indexPath.row+1];
    switch (indexPath.row) {
        case 0:
            cell.rank.textColor = RGB(254, 45, 70);
            break;
        case 1:
            cell.rank.textColor = RGB(255, 102, 0);

            break;
        case 2:
            cell.rank.textColor = RGB(250, 169, 14);

            break;
            
        default:
            cell.rank.textColor = RGB(145, 149, 163);

            break;
    }
    
    
    
    
    

    return cell;
}
- (NSString *)getTimeStrWithString:(NSString *)str{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
    [dateFormatter setDateFormat:@"YYYY/MM/dd HH:mm:ss"]; //设定时间的格式
    NSDate *tempDate = [dateFormatter dateFromString:str];//将字符串转换为时间对象
    
    NSTimeInterval time = (long)[tempDate timeIntervalSince1970] + _refund_delay_sec;
    NSDate *detailDate=[NSDate dateWithTimeIntervalSince1970:time];
    NSString *currentDateStr = [dateFormatter stringFromDate: detailDate];
    return currentDateStr;

}
- (BOOL)dateDifferenceValue:(NSString*)date{
    NSString *time2 = date;
    // 2.将时间转换为date
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date1 = [NSDate date];
    NSDate *date2 = [formatter dateFromString:time2];
    // 3.创建日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit type = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 4.利用日历对象比较两个时间的差值
    NSDateComponents *cmps = [calendar components:type fromDate:date1 toDate:date2 options:0];
    // 5.输出结果
    NSLog(@"两个时间相差%ld年%ld月%ld日%ld小时%ld分钟%ld秒", cmps.year, cmps.month, cmps.day, cmps.hour, cmps.minute, cmps.second);
    
    return cmps.second <= 0 ? YES : NO;
}


- (void)votesClick:(UIButton *)btn{
    NSDictionary *dic = self.listArray[btn.tag];
    if (self.isNoteVC && [[dic[@"received_votes"] componentsSeparatedByString:@" "].firstObject doubleValue] > 0) {
        
        [self.view showMsg:[NSString stringWithFormat:@"%@%@%@",NSLocalizedString(@"已投票", nil),dic[@"received_votes"],NSLocalizedString(@"暂不可取消", nil)]];
        return;
    }

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"请输入密码！", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = NSLocalizedString(@"密码(8-18位字符)", nil);
        textField.secureTextEntry = YES;
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *pass = alertController.textFields.firstObject;
        
        
        if (!self.isNoteVC) {
            [[DCMGPWalletTool shareManager]contractCode:mgp_bpvoting andAction:@"unvote" andParameters:@{@"owner":VALIDATE_STRING([MGPHttpRequest shareManager].curretWallet.address),@"vote_id":dic[@"id"]} andPassWord:VALIDATE_STRING(pass.text) completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
                     
                if (responseObj) {
                    [self.view showMsg:NSLocalizedString(@"撤回成功", nil)];
                    [self.tableView.mj_header beginRefreshing];
                }
            }];
        }else{

            [[DCMGPWalletTool shareManager]contractCode:mgp_bpvoting andAction:@"delist" andParameters:@{@"issuer":VALIDATE_STRING([MGPHttpRequest shareManager].curretWallet.address)} andPassWord:VALIDATE_STRING(pass.text) completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
                     
                if (responseObj) {
                    [self.view showMsg:NSLocalizedString(@"节点取消成功", nil)];
                    [self.tableView.mj_header beginRefreshing];

                }
            }];
            
        }
        
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}

- (IBAction)claimrewardsClick:(id)sender {
    
    if ([_rewardsStr doubleValue] > 0) {
        [[DCMGPWalletTool shareManager]contractCode:mgp_bpvoting andAction:@"claimrewards" andParameters:@{@"issuer":VALIDATE_STRING([MGPHttpRequest shareManager].curretWallet.address),@"is_voter":@(!self.isNoteVC)} andPassWord:VALIDATE_STRING([[NSUserDefaults standardUserDefaults]objectForKey:PassWordText]) completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
                 
            if (responseObj) {
                [self.view showMsg:NSLocalizedString(@"奖励领取成功", nil)];
                [self.tableView.mj_header beginRefreshing];

            }
        }];
    }
    
    
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.destinationViewController isKindOfClass:[LHStakeVoteDetailTableViewController class]]) {
        LHStakeVoteDetailTableViewController *vc = segue.destinationViewController;
        //获取当前点击的cell的IndexPath
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDictionary *model = self.listArray[indexPath.row];
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:model];
        if (!self.isNoteVC) {
            dic[@"owner"] = model[@"candidate"];
        }
        vc.listArray = @[dic];
        vc.isSelfPush = self.isNoteVC;

    }
}


@end
