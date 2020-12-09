//
//  HuobiManager.h
//  TaiYiToken
//
//  Created by 张元一 on 2019/3/8.
//  Copyright © 2019 admin. All rights reserved.
//

#import "HTTPRequestManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface HuobiManager : BaseNetworking

/*
 huobi api
 获取火币账户余额
 */
+(void)HuobiGetBalanceCompletionHandler:(void (^)(id responseObj, NSError *error))handler;

/*
 huobi api
 获取币种深度
 symbol  例 usdtbtc
 */
+(void)HuobiGetDepthSymbol:(NSString *)symbol Depth:(NSInteger)type CompletionHandler:(void (^)(id responseObj, NSError *error))handler;

/*
 huobi api
 获取当前委托
 symbol    是    string    币种 例 usdtbtc
 apiKey    是    string    用户api key
 apiSecret    是    string    用户 秘钥
 states    否    string    submitted 已提交, partial-filled 部分成交, partial-canceled 部分成交撤销, filled 完全成交, canceled 已撤销
 from    否    string    起始订单ID
 size    否    string    查询记录大小
 */
+(void)HuobiGetOrderSymbol:(NSString *)symbol OrderStates:(HUOBI_Order_States)states CompletionHandler:(void (^)(id responseObj, NSError *error))handler;

/*
 huobi api
 所有币种
 */
+(void)HuobiGetSymbolsCompletionHandler:(void (^)(id responseObj, NSError *error))handler;
/*
 huobi api
 下单
 
 amount    是    string    数量
 price    否    string    价格
 symbol    是    string    币种
 type    是    string    订单类型 1、限价买入：buy-limit；2、限价卖出：sell-limit；3、市价买入：buy-market；4：市价卖出：sell-market
 */
+(void)HuobiCreateOrderAmount:(NSString *)amount Price:(NSString *)price Symbol:(NSString *)symbol Type:(HUOBI_Order_Type)type  CompletionHandler:(void (^)(id responseObj, NSError *error))handler;
/*
 huobi api
 撤销订单
 
 */
+(void)HuobiCancelOrderWithID:(NSString *)orderId CompletionHandler:(void (^)(id responseObj, NSError *error))handler;
@end

NS_ASSUME_NONNULL_END
