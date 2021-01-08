//
//  OverTheCounterMyOrderTableViewController.m
//  TaiYiToken
//
//  Created by mac on 2020/12/29.
//  Copyright © 2020 admin. All rights reserved.
//

#import "OverTheCounterMyOrderTableViewController.h"
#import "OverTheCounterMyOrderTableViewCell.h"
#import "OverTheCounterOrderDetailMangeViewController.h"

@interface OverTheCounterMyOrderTableViewController ()

@property(strong, nonatomic)NSMutableArray *listArray;

@end

@implementation OverTheCounterMyOrderTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = 105;
   self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
   self.tableView.showsVerticalScrollIndicator = NO;
   [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 65, 0)];

   self.tableView.mj_header = [DCHomeRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(setUpData)];
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setUpData];
}

#pragma mark - 获取数据 
- (void)setUpData
{
    _listArray = [NSMutableArray array];
    
    NSString *mgp_otcstore = [[DomainConfigManager share]getCurrentEvnDict][otcstore];

    switch (self.myOrderType) {
        case OverTheCounterMyOrderType_buy:
        case OverTheCounterMyOrderType_sell:
        {
            NSString *index_position = self.myOrderType == OverTheCounterMyOrderType_sell ? @"3" : @"4";

            NSDictionary *dic = @{
                @"json": @1,
                @"code": mgp_otcstore,
                @"scope":mgp_otcstore,
                @"index_position":index_position,
                @"table":@"deals",
                @"key_type":@"i64",
                @"limit":@"500",
                @"lower_bound":[MGPHttpRequest shareManager].curretWallet.address,
                @"upper_bound":[MGPHttpRequest shareManager].curretWallet.address
            };
            
            [[HTTPRequestManager shareMgpManager] post:eos_get_table_rows paramters:dic success:^(BOOL isSuccess, id responseObject) {

                if (isSuccess) {
                    NSArray *arr = (NSArray *)responseObject[@"rows"];
                    [self.listArray addObjectsFromArray:[[arr reverseObjectEnumerator] allObjects]];
                    [self.tableView.mj_header endRefreshing];
                    [self.tableView reloadData];
                }
                NSLog(@"%@",responseObject);

            } failure:^(NSError *error) {
                [self.tableView.mj_header endRefreshing];
            } superView:self.view showFaliureDescription:YES];
        }
            break;
        case OverTheCounterMyOrderType_myPos:
        {
            NSDictionary *dic = @{
                @"json": @1,
                @"code": mgp_otcstore,
                @"scope":mgp_otcstore,
                @"index_position":@"3",
                @"table":@"selorders",
                @"key_type":@"i64",
                @"limit":@"500",
                @"lower_bound":[MGPHttpRequest shareManager].curretWallet.address,
                @"upper_bound":[MGPHttpRequest shareManager].curretWallet.address
            };
            
            [[HTTPRequestManager shareMgpManager] post:eos_get_table_rows paramters:dic success:^(BOOL isSuccess, id responseObject) {

                if (isSuccess) {
                    NSArray *arr = (NSArray *)responseObject[@"rows"];
                    [self.listArray addObjectsFromArray:[[arr reverseObjectEnumerator] allObjects]];
                    [self.tableView.mj_header endRefreshing];
                    [self.tableView reloadData];
                }
                NSLog(@"%@",_listArray);

            } failure:^(NSError *error) {
                [self.tableView.mj_header endRefreshing];
            } superView:self.view showFaliureDescription:YES];
        }
            break;
        default:
            break;
    }
    
    
    
    
    
    
    
    
    
    
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
    OverTheCounterMyOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OverTheCounterMyOrderTableViewCellIndex" forIndexPath:indexPath];
    
    cell.myOrderType = self.myOrderType;
    cell.dic = self.listArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = self.listArray[indexPath.row];

    OverTheCounterOrderDetailMangeViewController *vc = [OverTheCounterOrderDetailMangeViewController new];
    int timeCount = 0;
    for (NSString *timeStr in @[dic[@"taker_passed_at"],dic[@"maker_passed_at"],dic[@"arbiter_passed_at"]]) {
        if (![timeStr isEqualToString:@"1970-01-01T00:00:00"]) {
            timeCount++;
        }
    }
    int stateCount = 0;
    for (NSString *timeStr in @[dic[@"taker_passed"],dic[@"maker_passed"],dic[@"arbiter_passed"]]) {
        if (![timeStr isEqualToString:@"0"]) {
            stateCount++;
        }
    }
    
    
    
    switch (self.myOrderType) {
        case OverTheCounterMyOrderType_buy:
        case OverTheCounterMyOrderType_sell:

            if ([dic[@"taker_passed"]intValue] == 0 && [dic[@"closed"]intValue] == 0 && [dic[@"taker_passed_at"]isEqualToString:@"1970-01-01T00:00:00"]) {
                vc.orderDetailType = self.myOrderType == OverTheCounterMyOrderType_buy ? OrderDetailType_PaymentSeller : OrderDetailType_BuyerPayment;

            }else if ([dic[@"taker_passed"]intValue] == 1 && [dic[@"closed"]intValue] == 0 && ![dic[@"taker_passed_at"]isEqualToString:@"1970-01-01T00:00:00"]){

                vc.orderDetailType = self.myOrderType == OverTheCounterMyOrderType_buy ? OrderDetailType_WaitingSellerPass : OrderDetailType_BuyerPaid;
                
            }else if (timeCount >= 2 && stateCount >= 2 && [dic[@"closed"]intValue] == 1){
                vc.orderDetailType = OrderDetailType_TransactionSuccessful;
                
            }else if ([dic[@"closed"]intValue] == 1){
                vc.orderDetailType = OrderDetailType_TransactionCancel;
                
            }
            break;
        case OverTheCounterMyOrderType_myPos:
        {
            //委托订单是否已关闭
            if ([dic[@"closed"]boolValue]) {
                
                NSString *quantity_string = [dic[@"quantity"] componentsSeparatedByString:@" "].firstObject;
                NSString *fufilled_quantity_string = [dic[@"fulfilled_quantity"] componentsSeparatedByString:@" "].firstObject;
                //判断是出售完关闭还是主动撤回的
                vc.orderDetailType = fufilled_quantity_string.doubleValue >= quantity_string.doubleValue ? OrderDetailType_Completed : OrderDetailType_Revoke;
                
            }else{
                //出售中
                vc.orderDetailType = OrderDetailType_OnCommissionSale;
            }
        }
            break;
        default:
            break;
    }
    vc.dicData = self.listArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
    

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
