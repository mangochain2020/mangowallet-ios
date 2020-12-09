//
//  LHMiningIndexViewController.m
//  TaiYiToken
//
//  Created by mac on 2020/8/12.
//  Copyright © 2020 admin. All rights reserved.
//

#import "LHMiningIndexViewController.h"

@interface LHMiningIndexViewController ()

@property(weak, nonatomic) IBOutlet UILabel *money;
@property(weak, nonatomic) IBOutlet UITableView *tableView;
@property(weak, nonatomic) IBOutlet UILabel *subTitle;

@property(strong, nonatomic) NSMutableArray *listArray;


@end

@implementation LHMiningIndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"挖矿指数", nil);
    self.subTitle.text = NSLocalizedString(@"说明：当指数变为0时，订单将自动关闭", nil);
    self.tableView.tableFooterView = [UIView new];
    
    self.tableView.mj_header = [DCHomeRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(upRecData)];
    [self.tableView.mj_header beginRefreshing];
}

/// 加载数据
- (void)upRecData{
    self.listArray = [NSMutableArray array];
    [[MGPHttpRequest shareManager]post:@"/user/indexMarkIndex" paramters:@{@"address":[MGPHttpRequest shareManager].curretWallet.address,@"limit":@"50",@"page":@"1"} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
        if ([responseObj[@"code"] intValue] == 0) {
            
            for (NSDictionary *dic in [responseObj[@"data"]objectForKey:@"list"]) {
                [self.listArray addObject:dic];
            }
//            self.money.text = [responseObj[@"data"]objectForKey:@"num"];
            self.money.text = [NSString stringWithFormat:@"%@%.2f",[CreateAll GetCurrentCurrency].symbol,([[CreateAll GetCurrentCurrency].price doubleValue] * [[responseObj[@"data"]objectForKey:@"num"]doubleValue])];
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }];
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.listArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tabelViewCellIndex" forIndexPath:indexPath];
    
    NSDictionary *dic = self.listArray[indexPath.row];
    UILabel *leftLabel = [cell.contentView viewWithTag:2020031101];
    UILabel *rightLabel = [cell.contentView viewWithTag:2020031102];

    leftLabel.text = dic[@"createTime"];
//    NSString *num = dic[@"num"];
    NSString *num = [NSString stringWithFormat:@"%.2f",([[CreateAll GetCurrentCurrency].price doubleValue] * [dic[@"num"]doubleValue])];
    rightLabel.text = [num doubleValue] > 0.0 ? [NSString stringWithFormat:@"+%@",num] : num;
    cell.backgroundColor = (indexPath.row % 2 == 0) ? [UIColor groupTableViewBackgroundColor] : [UIColor whiteColor];
    

    

    return cell;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
