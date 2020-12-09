//
//  LHWalletViewController.m
//  TaiYiToken
//
//  Created by mac on 2020/8/12.
//  Copyright © 2020 admin. All rights reserved.
//

#import "LHWalletViewController.h"
#import "LHSendTransactionViewController.h"
#import "LHMyExcitationTableViewCell.h"

@interface LHWalletViewController ()

@property(weak, nonatomic) IBOutlet UITableView *tableView;
@property(weak, nonatomic) IBOutlet UIButton *tiquButton;
@property(weak, nonatomic) IBOutlet UILabel *balance;
@property(weak, nonatomic) IBOutlet UILabel *balanceValue;
@property(weak, nonatomic) IBOutlet UILabel *titelText;
@property(weak, nonatomic) IBOutlet UIView *headerView;
@property(weak, nonatomic) IBOutlet UILabel *frozenBalance;

@property(strong, nonatomic) NSMutableArray *listArray;

@end

@implementation LHWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"我的MGP激励", nil);
    [self.tiquButton setTitle:NSLocalizedString(@"收益提取", nil) forState:UIControlStateNormal];
    self.titelText.text = NSLocalizedString(@"我的余额(MGP)", nil);;
    self.tableView.tableFooterView = [UIView new];
    
    self.tableView.mj_header = [DCHomeRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(upRecData)];
    [self.tableView.mj_header beginRefreshing];
    
}

/// 加载数据
- (void)upRecData{
    self.listArray = [NSMutableArray array];
    [[MGPHttpRequest shareManager]post:@"/order/miningOrderIncome" paramters:@{@"address":[MGPHttpRequest shareManager].curretWallet.address,@"limit":@"50",@"page":@"1"} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
        if ([responseObj[@"code"] intValue] == 0) {
            
            for (NSDictionary *dic in [responseObj[@"data"]objectForKey:@"list"]) {
                [self.listArray addObject:dic];
            }
//            self.balanceValue.text = [NSString stringWithFormat:@"≈$%@",[responseObj[@"data"]objectForKey:@"balanceValue"]];
            
            self.balanceValue.text = [NSString stringWithFormat:@"≈%@%.2f",[CreateAll GetCurrentCurrency].symbol,([[CreateAll GetCurrentCurrency].price doubleValue] * [[responseObj[@"data"]objectForKey:@"balanceValue"] doubleValue])];
            
            self.balance.text = [responseObj[@"data"]objectForKey:@"balance"];
            self.frozenBalance.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"冻结", nil),[responseObj[@"data"]objectForKey:@"lockMoney"]];
            
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }];
    
}

- (IBAction)miningIndexClick:(id)sender {
    //跳转抵押页面
//    [self performSegueWithIdentifier:@"LHSendTransactionViewController" sender:nil];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.listArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LHMyExcitationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LHMyExcitationTableViewCellIndex" forIndexPath:indexPath];
    
    NSDictionary *dic = self.listArray[indexPath.row];
    NSString *money = dic[@"money"];
    cell.money.text = [money doubleValue] > 0.0 ? [NSString stringWithFormat:@"+%@",money] : money;
    cell.createTime.text = dic[@"createTime"];
    cell.channelName.text = [NSString stringWithFormat:@"%@(%@)",dic[@"typeName"],dic[@"orderLevelName"]];
    cell.channelImage.image = [money doubleValue] > 0.0 ? [UIImage imageNamed:@"MiningindexIn"] : [UIImage imageNamed:@"MiningindexOut"];

    return cell;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.destinationViewController isKindOfClass:[LHSendTransactionViewController class]]) {
        LHSendTransactionViewController *vc = segue.destinationViewController;
        vc.sendType = extractMio;
    }
    
    
}


@end
