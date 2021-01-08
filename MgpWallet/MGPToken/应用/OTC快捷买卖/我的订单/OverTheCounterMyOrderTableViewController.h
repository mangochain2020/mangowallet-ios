//
//  OverTheCounterMyOrderTableViewController.h
//  TaiYiToken
//
//  Created by mac on 2020/12/29.
//  Copyright © 2020 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

//定义枚举类型
typedef enum _OverTheCounterMyOrderType {
    //卖家状态
    OverTheCounterMyOrderType_Default  = 0,//默认
    OverTheCounterMyOrderType_buy = 1,//购买的mgp
    OverTheCounterMyOrderType_sell = 2,//出售的mgp
    OverTheCounterMyOrderType_myPos = 3,//我的委托

} OverTheCounterMyOrderType;


NS_ASSUME_NONNULL_BEGIN

@interface OverTheCounterMyOrderTableViewController : UITableViewController

@property (nonatomic,assign) OverTheCounterMyOrderType myOrderType; //我的订单类型

@end

NS_ASSUME_NONNULL_END
