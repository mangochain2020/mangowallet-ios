//
//  MyThemeTableViewController.m
//  TaiYiToken
//
//  Created by mac on 2020/10/19.
//  Copyright © 2020 admin. All rights reserved.
//

#import "MyThemeTableViewController.h"
#import "LHMyExcitationTableViewCell.h"
#import "ThemeVoteDetailViewController.h"
#import "LHSendThemeViewController.h"
#import "ThemeVoteTableViewCell.h"

@interface MyThemeTableViewController ()
{
    int page;
}
@property(strong, nonatomic) NSMutableArray *listArray;
@property (nonatomic, weak) XFDialogFrame *dialogView;
@property (copy,nonatomic)NSString *themeMoney;
@property(strong, nonatomic) NSNumber *currencyBalance; //当前余额

@end

@implementation MyThemeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"我的方案", nil);
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = 110;
    self.tableView.mj_header = [DCHomeRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(upRecData)];
    [self.tableView.mj_header beginRefreshing];
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 100, 0)];
    WEAKSELF
    [self.tableView addFooterRefresh:^{
        page += 1;
        [weakSelf loadData];

    }];
    //创建组队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_group_t group = dispatch_group_create();
    if (![[MGPHttpRequest shareManager].curretWallet.walletName isEqualToString:@"MGP_"]) {
       //组任务1
        dispatch_group_enter(group);//
        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *name = [[MGPHttpRequest shareManager].curretWallet.walletName componentsSeparatedByString:@"_"].lastObject;
            NSDictionary *dic = @{@"account_name":name};
            [[HTTPRequestManager shareMgpManager] post:eos_get_account paramters:dic success:^(BOOL isSuccess, id responseObject) {
                dispatch_group_leave(group);

                if (isSuccess) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSString *balancestr = [(NSDictionary *)responseObject objectForKey:@"core_liquid_balance"];
                        NSString *valuestring = [balancestr componentsSeparatedByString:@" "].firstObject;
                        double balance = valuestring.doubleValue;
                        self.currencyBalance = @(balance);
                        
                    });
                    
                }
            } failure:^(NSError *error) {
                
            } superView:self.view showFaliureDescription:YES];
        });
        //组任务2
        dispatch_group_enter(group);//
        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[MGPHttpRequest shareManager]post:@"/voteTheme/getSchemeMoney" paramters:@{@"address":[MGPHttpRequest shareManager].curretWallet.address} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
                dispatch_group_leave(group);

                if ([responseObj[@"code"]intValue] == 0) {
                    self.themeMoney = [NSString stringWithFormat:@"%.f",[responseObj[@"data"]doubleValue]];
                    
                }
            }];
            
        });
        
        //二个网络请求都完成统一处理
        dispatch_group_notify(group, queue, ^{
            dispatch_async(dispatch_get_main_queue(), ^{

                if (self.currencyBalance.doubleValue < self.themeMoney.doubleValue) {
                    [self.view showMsg:NSLocalizedString(@"账户余额不足，无法发布方案", nil)];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }
            });
            
        });
        
    }
    
}



/// 加载数据
- (void)upRecData{
    page = 1;
    self.listArray = [NSMutableArray array];
    [self loadData];
}
- (void)loadData{
    ///voteLog/getVotes
    NSString *url = _type ? @"/voteLog/getVotes" : @"/voteTheme/myTheme";
    [[MGPHttpRequest shareManager]post:url paramters:@{@"address":[MGPHttpRequest shareManager].curretWallet.address,@"page":@(page),@"limit":@"10"} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
        if ([responseObj[@"code"] intValue] == 0) {
            
            for (NSDictionary *dic in responseObj[@"data"]) {
                [self.listArray addObject:dic];
            }
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView endFooterRefresh];

    }];
    
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
    
    ThemeVoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ThemeVoteTableViewCellIndex" forIndexPath:indexPath];
    
    NSDictionary *dic = self.listArray[indexPath.row];
    cell.rank.text = [NSString stringWithFormat:@"%d",[dic[@"sort"]intValue]];
    cell.address.text =dic[@"voteTitle"];
    cell.voteTitle.text = dic[@"voteContent"];
    cell.voteNum.text = [NSString stringWithFormat:@"%.2f%%",[dic[@"rate"] floatValue]*100];
    cell.voteP.progress = [dic[@"rate"] floatValue];
    
    NSString *type = @"";
    switch ([dic[@"type"]intValue]) {
        case 0:
            type = NSLocalizedString(@"待支付", nil);
            break;
        case 1:
            type = NSLocalizedString(@"待审核", nil);

            break;
        case 2:
            type = NSLocalizedString(@"审核失败", nil);
            cell.voteTitle.text = dic[@"mark"];

            break;
        case 3:
            type = NSLocalizedString(@"投票中", nil);

            break;
        case 4:
            type = NSLocalizedString(@"投票结束", nil);

            break;
        case 5:
            type = NSLocalizedString(@"待投票", nil);

            break;
        case 6:
            type = NSLocalizedString(@"支付中", nil);

            break;
        default:
            break;
    }
    switch ([dic[@"sort"]intValue]) {
        case 1:
            cell.rank.textColor = RGB(254, 45, 70);
            break;
        case 2:
            cell.rank.textColor = RGB(255, 102, 0);

            break;
        case 3:
            cell.rank.textColor = RGB(250, 169, 14);

            break;
            
        default:
            cell.rank.textColor = RGB(145, 149, 163);

            break;
    }
    cell.voteType.text = type;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.listArray[indexPath.row];
    switch ([dic[@"type"]intValue]) {
        case 0:
        {
            if (self.currencyBalance.doubleValue < self.themeMoney.doubleValue) {
                [self.view showMsg:NSLocalizedString(@"账户余额不足，无法发布方案", nil)];
                
            }else{
                [self inputPassWorldSubmit:dic[@"voteId"]];

            }
        }
            break;
        case 2:
        {
            LHSendThemeViewController *vc = [LHSendThemeViewController new];
            vc.dic = self.listArray[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];

        }
            break;
        default:
        {
            [self performSegueWithIdentifier:@"ThemeVoteDetailViewControllerIndex" sender:nil];
            
        }
            break;
    }
    
    
    
    
    
}

- (void)inputPassWorldSubmit:(NSString *)voteId{
    
    WEAKSELF
    self.dialogView =
    [[XFDialogInput dialogWithTitle:[NSString stringWithFormat:@"支付【%@】MGP",self.themeMoney]
                                 attrs:@{
                                         XFDialogTitleViewBackgroundColor : [UIColor orangeColor],
                                         XFDialogTitleColor: [UIColor whiteColor],
                                         XFDialogLineColor: [UIColor orangeColor],
                                         XFDialogInputFields:@[
                                                 @{
                                                     XFDialogInputPlaceholderKey : NSLocalizedString(@"输入8位数以上密码", nil),
                                                     XFDialogInputTypeKey : @(UIKeyboardTypeDefault),
                                                     XFDialogInputIsPasswordKey : @(YES),
                                                     XFDialogInputPasswordEye : @{
                                                             XFDialogInputEyeOpenImage : @"ic_eye",
                                                             XFDialogInputEyeCloseImage : @"ic_eye_close"
                                                             }
                                                     },
                                                 ],
                                         XFDialogInputHintColor : [UIColor purpleColor],
                                         XFDialogInputTextColor: [UIColor orangeColor],
                                         XFDialogCommitButtonTitleColor: [UIColor orangeColor]
                                         }
                        commitCallBack:^(NSString *inputText) {
                            [weakSelf.dialogView hideWithAnimationBlock:nil];

        NSArray *arr = (NSArray *)inputText;
        NSString *pwd = arr.firstObject;
        
        NSString *amount = self.themeMoney;
        [[DCMGPWalletTool shareManager]transferAmount:amount andFrom:[MGPHttpRequest shareManager].curretWallet.address andTo:@"mgpchainvote" andMemo:[NSString stringWithFormat:@"%@,0",voteId] andPassWord:pwd completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
            
            if (responseObj) {
                NSDictionary *p = @{
                    @"hash":responseObj,
                    @"voteId":voteId,
                    @"money":amount
                };
                [[MGPHttpRequest shareManager]post:@"/voteTheme/upHash" paramters:p completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {

                    if ([responseObj[@"code"]intValue] == 0) {
                        [weakSelf.view showMsg:NSLocalizedString(@"发布成功", nil)];
                        [self.tableView.mj_header beginRefreshing];
                    }
                }];
                
            }
        }];
        
        } errorCallBack:nil] showWithAnimationBlock:nil];
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
    if ([segue.destinationViewController isKindOfClass:[ThemeVoteDetailViewController class]]) {
        ThemeVoteDetailViewController *vc = segue.destinationViewController;
        vc.dic = self.listArray[self.tableView.indexPathForSelectedRow.row];

    }
    
}


@end
