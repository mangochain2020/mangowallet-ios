//
//  OverTheCounterOrderDetailViewController.h
//  TaiYiToken
//
//  Created by mac on 2020/12/29.
//  Copyright © 2020 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OverTheCounterTitleView.h"

//定义枚举类型
typedef enum _OverTheCounterOrderDetailType {
    //卖家状态
    OrderDetailType_Default  = 0,//默认
    OrderDetailType_PaymentSeller = 1,//向卖家付款
    OrderDetailType_WaitingSellerPass = 2,//等待卖家放行
    OrderDetailType_TransactionSuccessful  = 3,//交易成功
    OrderDetailType_TransactionCancel  = 4,//交易取消
    
    //卖家状态
    OrderDetailType_OnCommissionSale  = 5,//委托出售中
    OrderDetailType_Completed  = 6,//已完成
    OrderDetailType_BuyerPayment  = 7,//待买家付款
    OrderDetailType_BuyerPaid  = 8,//买家已付款
    OrderDetailType_Revoke  = 9,//卖家撤销

} OverTheCounterOrderDetailType;



NS_ASSUME_NONNULL_BEGIN

@interface OverTheCounterOrderDetailViewController : UIViewController

@property (nonatomic,assign) OverTheCounterOrderDetailType orderDetailType; //订单类型
@property (nonatomic,strong) NSDictionary *dicData; //数据


@property (nonatomic,assign) int orderPayType; //订单支付类型(银行卡0、支付宝1、微信2),订单类型为1、2时有效
@property (nonatomic,strong) NSDictionary *sellUserInfo; //收款人信息
@property (nonatomic,strong) NSDictionary *sellPayInfo; //收款方式信息


@property (nonatomic,strong) OverTheCounterTitleView *titleView; //订单顶部视图


@end

NS_ASSUME_NONNULL_END
