//
//  DCOrderListTableViewController.m
//  TaiYiToken
//
//  Created by mac on 2020/8/6.
//  Copyright © 2020 admin. All rights reserved.
//

#import "DCOrderListTableViewController.h"
#import "DCOrderListTableViewCell.h"
#import "DCOrderListModel.h"
#import "DCOrderDetailTableViewController.h"

static NSString *const DCOrderListTableViewCellID = @"DCOrderListTableViewCell";

@interface DCOrderListTableViewController ()

@property(strong, nonatomic)DCOrderListModel *orderListModel;
@property (nonatomic, assign) double currency;
@property (nonatomic, strong) NSArray *tempArr;


@end

@implementation DCOrderListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DCOrderListTableViewCell class]) bundle:nil] forCellReuseIdentifier:DCOrderListTableViewCellID];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 65, 0)];

    self.tableView.mj_header = [DCHomeRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(setUpData)];
    [self.tableView.mj_header beginRefreshing];
    
        
    
    
}
#pragma mark - 获取数据
- (void)setUpData{
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_group_t group = dispatch_group_create();
   
    
    if ((self.buyerRequestType == HYOrderBuyerRequestWaitPay || self.buyerRequestType == HYOrderBuyerRequestAll) && _isManagement == NO) {
        dispatch_group_enter(group);//
        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [[MGPHttpRequest shareManager]post:@"/api/coinPrice" paramters:@{@"pair":@"MGP_USDT"} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
                dispatch_group_leave(group);
                if ([responseObj[@"code"]intValue] == 0) {
                   _currency = ((NSString *)VALIDATE_STRING([responseObj[@"data"] objectForKey:@"price"])).doubleValue;

                }
            }];
        });

    }
    
    dispatch_group_enter(group);//
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        NSString *path = self.isManagement ? @"/appStoreOrder/getOutOrder" : @"/appStoreOrder/getOrder";
        [[MGPHttpRequest shareManager]post:path paramters:@{@"address":[MGPHttpRequest shareManager].curretWallet.address,@"type":@(_buyerRequestType)} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
            dispatch_group_leave(group);
            if ([responseObj[@"code"]intValue] == 0) {
                self.tempArr = responseObj[@"data"];
            }
            self.orderListModel = [DCOrderListModel mj_objectWithKeyValues:responseObj];
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
        }];
    });
    //二个网络请求都完成统一处理
    dispatch_group_notify(group, queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{

            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];

        });
        
    });
    
    
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return self.orderListModel.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DCOrderListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DCOrderListTableViewCellID forIndexPath:indexPath];
    cell.orderModel = self.orderListModel.data[indexPath.section];
    cell.isManagement = self.isManagement;
    cell.currency = self.currency;
    cell.collectionBlock = ^{
        [self.tableView.mj_header beginRefreshing];
    };
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIStoryboard* secondStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    DCOrderDetailTableViewController *secondNavigationController = [secondStoryboard instantiateViewControllerWithIdentifier:@"DCOrderDetailTableViewControllerIndex"];
    secondNavigationController.orderModel = self.orderListModel;
    secondNavigationController.row = indexPath.section;
    secondNavigationController.isManagement = self.isManagement;
    
    NSDictionary *dic = self.tempArr[indexPath.section];
    secondNavigationController.tempDic = [dic[@"order"]objectForKey:@"appStoreUserDelivery"];
    [self.navigationController pushViewController:secondNavigationController animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DataItem *orderModel = self.orderListModel.data[indexPath.section];

    if (self.isManagement) {//卖家
        if (orderModel.order.payStatus == 0) {
            if (orderModel.order.isDeliver == 0) {
                return 180;
            }
        }else if (orderModel.order.payStatus == 1){
            if ([orderModel.order.pay intValue] != 1) {
                return 180;
            }
        }
    }else{//买家
        if (orderModel.order.payStatus == 0) {
            if(orderModel.order.isDeliver == 1){
                return 180;
            }
        }else if (orderModel.order.payStatus == 7){
            return 180;
        }
    }
    return 140;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
