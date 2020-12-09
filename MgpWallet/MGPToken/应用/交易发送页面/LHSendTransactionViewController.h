//
//  LHSendTransactionViewController.h
//  TaiYiToken
//
//  Created by mac on 2020/7/28.
//  Copyright © 2020 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
//定义枚举类型
typedef enum _NewSendTransactionType {
    def  = 0,//默认普通交易
    bindMID,// 绑定mid
    earnMoney,//抵押
    redeem,//赎回
    extractMio,//mio矿机收益提取
    extractEth,//eth提取
    bindEth,//绑定eth
    bondFirst,//申请开通
    bond,//提交保证金
    vote,//投票


} NewSendTransactionType;

NS_ASSUME_NONNULL_BEGIN

@interface LHSendTransactionViewController : UITableViewController

@property (nonatomic,assign) NewSendTransactionType sendType; //操作类型
@property(copy, nonatomic) NSString *remaining; //抵押的金额


@end

NS_ASSUME_NONNULL_END
