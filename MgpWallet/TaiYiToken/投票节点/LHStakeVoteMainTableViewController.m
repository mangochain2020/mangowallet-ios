//
//  LHStakeVoteMainTableViewController.m
//  TaiYiToken
//
//  Created by mac on 2020/11/16.
//  Copyright © 2020 admin. All rights reserved.
//

#import "LHStakeVoteMainTableViewController.h"
#import "LHStakeVoteMainTableViewCell.h"
#import "LHStakeVoteManageCenterViewController.h"
#import "LHStakeVoteAddTableViewController.h"
#import "LHStakeVoteDetailTableViewController.h"
#import "LHStakeVoteManageTableViewController.h"
#import "BlockChain.h"

@interface LHStakeVoteMainTableViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    int page;
    int sort;
    int buttonY;
}
@property(strong, nonatomic) NSMutableArray *listArray;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIButton *rulesBtn;

@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *blockHight;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *titlePro;

@property(strong, nonatomic) UIButton *flowButton;
@property (weak, nonatomic) IBOutlet UIButton *titleBtn1;
@property (weak, nonatomic) IBOutlet UIButton *titleBtn2;
@property (weak, nonatomic) IBOutlet UIButton *titleBtn3;


@property(assign, nonatomic) int min_bp_list_quantity;//成为节点最低转账数
@property(assign, nonatomic) int tokenBalance;//余额


@end

@implementation LHStakeVoteMainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"StakeVote", nil);
    [self.rightBtn setTitle:NSLocalizedString(@"管理", nil) forState:UIControlStateNormal];
    [self.rulesBtn setTitle:NSLocalizedString(@"查看规则", nil) forState:UIControlStateNormal];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = 110;
    self.tableView.mj_header = [DCHomeRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(upRecData)];
    [self.tableView.mj_header beginRefreshing];
    [self setup];
    
    [self.tableView addFooterRefresh:^{
        page += 1;
        [self loadData];

    }];
    
    
}
- (IBAction)titleBtnClick:(UIButton *)sender {
    [self.titleBtn1 setTitle:NSLocalizedString(@"默认", nil) forState:UIControlStateNormal];
    [self.titleBtn2 setTitle:NSLocalizedString(@"票数", nil) forState:UIControlStateNormal];
    [self.titleBtn3 setTitle:NSLocalizedString(@"比率", nil) forState:UIControlStateNormal];

    for (UIButton *btn in @[self.titleBtn1,self.titleBtn2,self.titleBtn3]) {
        btn.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        
        [btn setTitleColor:sender == btn ? [UIColor whiteColor] : [UIColor blackColor] forState:UIControlStateNormal];
        btn.backgroundColor = sender == btn ? [UIColor blackColor] : [UIColor whiteColor];
    }
    
    if (sender == self.titleBtn1) {
        sort = 1;

        
    }else if (sender == self.titleBtn2){
        sort = 2;
        
    }else if (sender == self.titleBtn3){
        sort = 3;
    }
    [self.tableView.mj_header beginRefreshing];
  
}


- (IBAction)rightClick:(id)sender {
    BOOL isCenter = NO;
    for (NSArray *arr in self.listArray) {
        for (NSDictionary *dic in arr) {
            if ([dic[@"owner"]isEqualToString:[MGPHttpRequest shareManager].curretWallet.address]) {
                isCenter = YES;
            }
        }
    }
    isCenter = YES;

    if (isCenter) {
        LHStakeVoteManageCenterViewController *VC = [LHStakeVoteManageCenterViewController new];
        [self.navigationController pushViewController:VC animated:YES];
        
    }else{
        UIStoryboard* secondStoryboard = [UIStoryboard storyboardWithName:@"StakeVote" bundle:[NSBundle mainBundle]];
        
        LHStakeVoteManageTableViewController *vc00 = [secondStoryboard instantiateViewControllerWithIdentifier:@"LHStakeVoteManageTableViewControllerIndex"];
        vc00.title = NSLocalizedString(@"我的投票", nil);
        vc00.isNoteVC = NO;
        [self.navigationController pushViewController:vc00 animated:YES];
    }
    
    
    

}


/// 加载数据
- (void)upRecData{
    page = 1;
    self.listArray = [NSMutableArray array];
    [self loadData];
}
- (void)loadData{
        
    NSString *mgp_bpvoting = [[DomainConfigManager share]getCurrentEvnDict][bpvoting];
    [[MGPHttpRequest shareManager]post:@"/voteNode/scNodeList" paramters:@{@"page":@(page),@"limit":@"20",@"sort":@(sort)} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
        if ([responseObj[@"code"]intValue] == 0) {
            NSArray *arr1 = [responseObj[@"data"]objectForKey:@"superNodeList"];
            NSArray *arr2 = [responseObj[@"data"]objectForKey:@"candidateNodeList"];
            [self.listArray addObject:arr1];
            [self.listArray addObject:arr2];
            [self.tableView reloadData];

        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView endFooterRefresh];
    }];
    
    /*
    NSDictionary *dic = @{@"json": @1,@"code": mgp_bpvoting,@"scope":mgp_bpvoting,@"table_key":@"",@"limit":@"500",@"table":@"candidates"};
    [[HTTPRequestManager shareMgpManager] post:eos_get_table_rows paramters:dic success:^(BOOL isSuccess, id responseObject) {
                
        if (isSuccess) {
            NSArray *arr = (NSArray *)responseObject[@"rows"];
            [self.listTempArray addObjectsFromArray:arr];
            [self titleBtnClick:self.titleBtn1];

            [self.tableView.mj_header endRefreshing];
            [self.tableView endFooterRefresh];
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView endFooterRefresh];
    } superView:self.view showFaliureDescription:YES];
    */
    
    //
    [[HTTPRequestManager shareMgpManager] post:eos_get_table_rows paramters:@{@"json": @1,@"code": mgp_bpvoting,@"scope":mgp_bpvoting,@"table":@"global"} success:^(BOOL isSuccess, id responseObject) {

        NSLog(@"global:%@",responseObject);

        if (isSuccess) {
            NSArray *arr = (NSArray *)responseObject[@"rows"];
            NSDictionary *dic = arr.firstObject;
            _min_bp_list_quantity = [[dic[@"min_bp_list_quantity"] componentsSeparatedByString:@" "].firstObject intValue];
            self.titleLabel.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"已投", nil),dic[@"total_voted"]];

        }
    } failure:^(NSError *error) {
        
    } superView:self.view showFaliureDescription:YES];
    
    [[HTTPRequestManager shareMgpManager] post:eos_get_currency_balance paramters:@{@"json": @1,@"code": @"eosio.token",@"account":[MGPHttpRequest shareManager].curretWallet.address,@"symbol":@"MGP"} success:^(BOOL isSuccess, id responseObject) {

        NSLog(@"%@",responseObject);
        
        if (isSuccess) {
            NSArray *temp = (NSArray *)responseObject;
            _tokenBalance = [[temp.firstObject componentsSeparatedByString:@" "].firstObject intValue];
        }
    } failure:^(NSError *error) {
        
    } superView:self.view showFaliureDescription:YES];
    
    
    [[MGPHttpRequest shareManager]post:@"/api/coinPrice" paramters:@{@"pair":@"MGP_USDT"} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
        if ([responseObj[@"code"]intValue] == 0) {
            NSLog(@"coinPrice %@",responseObj);
            self.price.text =[NSString stringWithFormat:@"%@ USDT",VALIDATE_STRING([responseObj[@"data"]objectForKey:@"price"])];
        }
                                
    }];
    

    [[HTTPRequestManager shareMgpManager] post:eos_get_info paramters:nil success:^(BOOL isSuccess, id responseObject) {
        
        if (isSuccess) {
            BlockChain *model = [BlockChain parse:responseObject];// [@"data"]

            self.blockHight.text = [NSString stringWithFormat:@"%@",model.head_block_num];

            NSLog(@"eos_get_info %@",responseObject);
        }
    } failure:^(NSError *error) {
        
        NSLog(@"URL_GET_INFO_ERROR ==== %@",error.description);
    } superView:self.view showFaliureDescription:YES];
    
    
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    NSArray *temp = self.listArray[section];
    return temp.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LHStakeVoteMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LHStakeVoteMainTableViewCellIndex" forIndexPath:indexPath];

    NSDictionary *dic = [self.listArray[indexPath.section]objectAtIndex:indexPath.row];
    cell.address.text = dic[@"node_name"];
    cell.reward_share.text = [NSString stringWithFormat:@"%@%.f%%",NSLocalizedString(@"投票者收益", nil),(10000-[dic[@"self_reward_share"] doubleValue])/100];
//    cell.received_votes.text = dic[@"tallied_votes"];
    
    double d = [[dic[@"received_votes"] componentsSeparatedByString:@" "].firstObject doubleValue] + [[dic[@"staked_votes"] componentsSeparatedByString:@" "].firstObject doubleValue];
    cell.received_votes.text = [NSString stringWithFormat:@"%.4f MGP",d];

    
    
    NSString *node_url = VALIDATE_STRING(dic[@"node_url"]);

    cell.url_votes.text = node_url.length <= 0 ? @"" : [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"节点", nil),node_url];
    cell.votesLabel.text = NSLocalizedString(@"去投票", nil);
    
    cell.rank.text =indexPath.section == 0 ? [NSString stringWithFormat:@"%ld",indexPath.row+1] : @"";
    switch (indexPath.row) {
        case 0:
            cell.rank.textColor = RGB(254, 45, 70);
            cell.rank.font = [UIFont boldSystemFontOfSize:50];

            break;
        case 1:
            cell.rank.textColor = RGB(255, 102, 0);
            cell.rank.font = [UIFont boldSystemFontOfSize:45];


            break;
        case 2:
            cell.rank.textColor = RGB(250, 169, 14);
            cell.rank.font = [UIFont boldSystemFontOfSize:40];


            break;
            
        default:
            cell.rank.textColor = RGB(145, 149, 163);
            cell.rank.font = [UIFont boldSystemFontOfSize:35];

            break;
    }
    
    return cell;
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return section == 0 ? NSLocalizedString(@"超级节点", nil) : NSLocalizedString(@"候选节点", nil);
}

//显示每组的头部标题有多高

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSArray *temp = self.listArray[section];
    return temp.count <= 0 ? 0 : 30;

}

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
        
        //获取当前点击的cell的IndexPath
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDictionary *model = [self.listArray[indexPath.section]objectAtIndex:indexPath.row];
        LHStakeVoteDetailTableViewController *vc = segue.destinationViewController;
        vc.listArray = @[model];

    }
}



-(void)setup
{
    
//  添加悬浮按钮
    _flowButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _flowButton.frame = CGRectMake(0, 0, 150, 40);
    _flowButton.center = CGPointMake(ScreenW/2, ScreenH - SafeAreaBottomHeight - _flowButton.frame.size.height*2-20);
    [_flowButton setTitle:NSLocalizedString(@"成为节点", nil) forState:UIControlStateNormal];
    [_flowButton addTarget:self action:@selector(sendClick:) forControlEvents:UIControlEventTouchUpInside];
    _flowButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _flowButton.layer.masksToBounds = YES;
    _flowButton.layer.cornerRadius = _flowButton.frame.size.height/2;

    [self.tableView addSubview:_flowButton];
    [self.tableView bringSubviewToFront:_flowButton];
    buttonY=(int)_flowButton.frame.origin.y;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
   _flowButton.frame = CGRectMake(_flowButton.frame.origin.x, buttonY+self.tableView.contentOffset.y , _flowButton.frame.size.width, _flowButton.frame.size.height);
}
- (void)sendClick:(UIButton *)btn {
    if (_tokenBalance < _min_bp_list_quantity) {
        [self.view showMsg:[NSString stringWithFormat:@"%@%d MGP",NSLocalizedString(@"当前钱包余额不足", nil),_min_bp_list_quantity]];

    }else{
        LHStakeVoteAddTableViewController *vc = [LHStakeVoteAddTableViewController new];
        vc.min_bp_list_quantity = _min_bp_list_quantity;
        [self.navigationController pushViewController:vc animated:YES];
    }

}


@end

