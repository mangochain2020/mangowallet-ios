//
//  OverTheCounterContactArbitersController.m
//  TaiYiToken
//
//  Created by mac on 2021/1/13.
//  Copyright © 2021 admin. All rights reserved.
//

#import "OverTheCounterContactArbitersController.h"
#import "OverTheCounterMyOrderTableViewCell.h"
#import "OverTheCounterOrderDetailMangeViewController.h"


@interface OverTheCounterContactArbitersController ()

@property(strong, nonatomic)NSMutableArray *listArray;
@property(copy, nonatomic)NSString *mgp_otcstore;

@property (weak, nonatomic) IBOutlet UISearchBar *order_sn_search;

@end

@implementation OverTheCounterContactArbitersController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    self.title = NSLocalizedString(@"OTC仲裁", nil);
    _mgp_otcstore = [[DomainConfigManager share]getCurrentEvnDict][otcstore];

    self.tableView.rowHeight = 105;
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.showsVerticalScrollIndicator = NO;

    self.tableView.mj_header = [DCHomeRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(setUpData:)];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setUpData:NO];
}
#pragma mark - 获取数据
- (void)setUpData:(BOOL)isSearch
{
    _listArray = [NSMutableArray array];

    NSDictionary *dic = [NSDictionary dictionary];
    if (isSearch) {
        NSString *order_sn = self.order_sn_search.text;
        dic = @{
            @"json": @1,
            @"code": _mgp_otcstore,
            @"scope":_mgp_otcstore,
            @"index_position":@"6",
            @"table":@"deals",
            @"key_type":@"i64",
            @"limit":@"500",
            @"lower_bound":order_sn,
            @"upper_bound":order_sn
        };
    }else{
        dic = @{
            @"json": @1,
            @"code": _mgp_otcstore,
            @"scope":_mgp_otcstore,
            @"table":@"deals",
            @"limit":@"500",
        };
    }
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
    cell.myOrderType = OverTheCounterMyOrderType_arbiters;
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
    if ([dic[@"taker_passed"]intValue] == 0 && [dic[@"closed"]intValue] == 0 && [dic[@"taker_passed_at"]isEqualToString:@"1970-01-01T00:00:00"]) {
        vc.orderDetailType = OrderDetailType_BuyerPayment_Arbiters;

    }else if ([dic[@"taker_passed"]intValue] == 1 && [dic[@"closed"]intValue] == 0 && ![dic[@"taker_passed_at"]isEqualToString:@"1970-01-01T00:00:00"]){

        vc.orderDetailType = OrderDetailType_BuyerPaid_Arbiters;
        
    }else if (timeCount >= 2 && stateCount >= 2 && [dic[@"closed"]intValue] == 1){
        vc.orderDetailType = OrderDetailType_TransactionSuccessful;
        
    }else if ([dic[@"closed"]intValue] == 1){
        vc.orderDetailType = OrderDetailType_TransactionCancel;
        
    }
    
    vc.dicData = self.listArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
    

}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [self setUpData:YES];
  
}; // called when text ends editing
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar endEditing:YES];
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
