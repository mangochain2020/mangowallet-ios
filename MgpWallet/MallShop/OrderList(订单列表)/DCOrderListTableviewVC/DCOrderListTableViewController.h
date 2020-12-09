//
//  DCOrderListTableViewController.h
//  TaiYiToken
//
//  Created by mac on 2020/8/6.
//  Copyright © 2020 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

/**卖家
 0，所有订单
 1，入账中
 2，待发货
 3，待收货
 4，完成
 5，退货退款
 6,
 7，待付款

 */
typedef NS_ENUM(NSInteger, OrderBuyerRequestType) {
    
    HYOrderBuyerRequestAll = 0,
    HYOrderBuyerRequestAccount,
    HYOrderBuyerRequestWaitSend,
    HYOrderBuyerRequestAlreadySend,
    HYOrderBuyerRequestFirist,
    HYOrderBuyerRequestReturn,
    HYOrderBuyerRequestTemp,
    HYOrderBuyerRequestWaitPay,


};

NS_ASSUME_NONNULL_BEGIN

@interface DCOrderListTableViewController : UITableViewController

@property (nonatomic, assign) OrderBuyerRequestType buyerRequestType;
@property (assign, nonatomic)BOOL isManagement; //是否商家进来的订单列表


@end

NS_ASSUME_NONNULL_END
