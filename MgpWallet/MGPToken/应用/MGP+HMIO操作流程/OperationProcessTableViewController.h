//
//  OperationProcessTableViewController.h
//  TaiYiToken
//
//  Created by mac on 2020/9/23.
//  Copyright © 2020 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
//定义枚举类型
typedef enum _OperationProcessType {
    transferDef  = 0,//默认
    transferHMIO_First,//抵押转HMIO第一次
    transferHMIO_Two,//抵押转HMIO第二次
    transferHMIO_USDT,//电商支付

} OperationProcessType;

@interface OperationProcessTableViewController : UITableViewController

@property (nonatomic,assign) OperationProcessType transferType; //操作类型

@property (copy,nonatomic)NSString *num;

//抵押参数
@property (copy,nonatomic)NSString *payId;
@property (copy,nonatomic)NSString *moneyType;

//电商支付参数
@property (copy,nonatomic)NSString *usdtAdd;
@property (copy,nonatomic)NSString *orderId;


@end

NS_ASSUME_NONNULL_END
