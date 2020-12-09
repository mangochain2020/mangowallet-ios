//
//  DCOrderDetailTableViewController.m
//  TaiYiToken
//
//  Created by mac on 2020/8/26.
//  Copyright © 2020 admin. All rights reserved.
//

#import "DCOrderDetailTableViewController.h"

@interface DCOrderDetailTableViewController ()
/* 订单状态 */
@property (weak, nonatomic) IBOutlet UILabel *orderState;

/* 地址 */
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userPhone;
@property (weak, nonatomic) IBOutlet UILabel *userAdress;
@property (weak, nonatomic) IBOutlet UILabel *adressLabel;

/* 商品 */
@property (weak, nonatomic) IBOutlet UIImageView *shopIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *shopTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopChoseLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopBuyCount;

/* 订单信息 */
@property (weak, nonatomic) IBOutlet UILabel *orderInfo;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;
@property (weak, nonatomic) IBOutlet UILabel *createTime;
@property (weak, nonatomic) IBOutlet UILabel *orderId;
@property (weak, nonatomic) IBOutlet UILabel *hashLabel;
@property (weak, nonatomic) IBOutlet UILabel *courier;

/* 按钮 */
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation DCOrderDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"订单详情", nil);
    DataItem *orderModel = self.orderModel.data[self.row];
    self.button.hidden = YES;
    
    if (self.isManagement) {//卖家
        if (orderModel.order.payStatus == 0) {
            if (orderModel.order.isDeliver == 0) {
                self.orderState.text = NSLocalizedString(@"待发货", nil);
            }else if(orderModel.order.isDeliver == 1){
                self.orderState.text = NSLocalizedString(@"发货中", nil);
            }else if(orderModel.order.isDeliver == 2){
                self.orderState.text = NSLocalizedString(@"交易完成", nil);
            }
        }else if (orderModel.order.payStatus == 1){
            self.orderState.text = NSLocalizedString(@"入账中", nil);
        }else if (orderModel.order.payStatus == 2){
            self.orderState.text = NSLocalizedString(@"买家支付失败", nil);
        }else if (orderModel.order.payStatus == 3){
            self.orderState.text = NSLocalizedString(@"退款中", nil);
        }else if (orderModel.order.payStatus == 4){
            self.orderState.text = NSLocalizedString(@"已退款", nil);
        }else if (orderModel.order.payStatus == 5){
            self.orderState.text = NSLocalizedString(@"退款失败", nil);
        }else if (orderModel.order.payStatus == 6){
            self.orderState.text = NSLocalizedString(@"买家取消订单", nil);
        }else if (orderModel.order.payStatus == 7){
            self.orderState.text = NSLocalizedString(@"待买家支付", nil);
        }
    }else{//买家
        if (orderModel.order.payStatus == 0) {
            if (orderModel.order.isDeliver == 0) {
                self.orderState.text = NSLocalizedString(@"待发货", nil);
            }else if(orderModel.order.isDeliver == 1){
                self.orderState.text = NSLocalizedString(@"发货中", nil);
            }else if(orderModel.order.isDeliver == 2){
                self.orderState.text = NSLocalizedString(@"交易完成", nil);
            }
        }else if (orderModel.order.payStatus == 1){
            self.orderState.text = NSLocalizedString(@"入账中", nil);
        }else if (orderModel.order.payStatus == 2){
            self.orderState.text = NSLocalizedString(@"支付失败", nil);
        }else if (orderModel.order.payStatus == 3){
            self.orderState.text = NSLocalizedString(@"退款中", nil);
        }else if (orderModel.order.payStatus == 4){
            self.orderState.text = NSLocalizedString(@"已退款", nil);
        }else if (orderModel.order.payStatus == 5){
            self.orderState.text = NSLocalizedString(@"退款失败", nil);
        }else if (orderModel.order.payStatus == 6){
            self.orderState.text = NSLocalizedString(@"取消订单", nil);
        }else if (orderModel.order.payStatus == 7){
            self.orderState.text = NSLocalizedString(@"待支付", nil);
        }
    }
    
    
    self.userName.text = orderModel.order.appStoreUserDelivery[@"userName"];
    self.userPhone.text = orderModel.order.appStoreUserDelivery[@"phone"]; 
    self.userAdress.text = [NSString stringWithFormat:@"%@ %@",orderModel.order.appStoreUserDelivery[@"city"],orderModel.order.appStoreUserDelivery[@"detailedAddress"]];
    self.adressLabel.text = NSLocalizedString(@"地址", nil);


    NSArray *arr = orderModel.pro.image_url;
    [_shopIconImageView sd_setImageWithURL:[NSURL URLWithString:arr.firstObject]];
    _shopChoseLabel.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"规格", nil),orderModel.pro.storeType];
    _shopTitleLabel.text = orderModel.pro.storeName;
    _msgLabel.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"订单备注:", nil),VALIDATE_STRING(orderModel.order.buyMark)];
   
    _shopBuyCount.text = [NSString stringWithFormat:@"x%ld",(long)orderModel.order.totalNum];
    _shopMoneyLabel.text = [NSString stringWithFormat:@"%@:%@%.2f",NSLocalizedString(@"价格", nil),[CreateAll GetCurrentCurrency].symbol,([[CreateAll GetCurrentCurrency].price doubleValue] * orderModel.pro.price)];
       
    self.orderInfo.text = NSLocalizedString(@"订单信息", nil);
    _createTime.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"创建时间", nil),orderModel.order.createTime];
    _orderId.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"订单编号", nil),VALIDATE_STRING(orderModel.order.orderId)];
    _hashLabel.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"支付哈希", nil),VALIDATE_STRING(orderModel.order.hashStr)];
    _courier.text = [NSString stringWithFormat:@"%@:%@",VALIDATE_STRING(orderModel.order.appStoreUserDelivery[@"company"]),VALIDATE_STRING(orderModel.order.num)];


    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row >= 6 && indexPath.row < 9) {
        DataItem *orderModel = self.orderModel.data[self.row];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        if (indexPath.row == 6 && VALIDATE_STRING(orderModel.order.orderId)) {
            pasteboard.string = VALIDATE_STRING(orderModel.order.orderId);
            [self.view showMsg:[NSString stringWithFormat:@"\"%@\" %@",pasteboard.string, NSLocalizedString(@"已复制", nil)]];

        }else if (indexPath.row == 7 && VALIDATE_STRING(orderModel.order.hashStr)){
            pasteboard.string = VALIDATE_STRING(orderModel.order.hashStr);
            [self.view showMsg:[NSString stringWithFormat:@"\"%@\" %@",pasteboard.string, NSLocalizedString(@"已复制", nil)]];

        }else if (indexPath.row == 8 && VALIDATE_STRING(orderModel.order.num)){
            pasteboard.string = VALIDATE_STRING(orderModel.order.num);
            [self.view showMsg:[NSString stringWithFormat:@"\"%@\" %@",pasteboard.string, NSLocalizedString(@"已复制", nil)]];

        }
    }

    
    
    
}
#pragma mark - Table view data source

/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}
*/
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
