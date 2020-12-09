//
//  HuobiManager.m
//  TaiYiToken
//
//  Created by 张元一 on 2019/3/8.
//  Copyright © 2019 admin. All rights reserved.
//

#import "HuobiManager.h"
#define HuobiBaseURL @"http://159.138.5.245:8088/market"
#define HuobiBanance @"/api/huobideal/balance"
#define HuobiDepth @"/api/huobideal/depth"
#define HuobiOrderNow @"/api/huobideal/orderNow"
#define HuobiSymbols @"/api/huobideal/symbols"
#define HuobiCreateOrder @"/api/huobideal/createOrder"
#define HuobiCancelOrder @"/api/huobideal/cancelOrder"


@implementation HuobiManager

/*
 huobi api
 获取火币账户余额
 */
+(void)HuobiGetBalanceCompletionHandler:(void (^)(id responseObj, NSError *error))handler{
    NSString *path = [NSString stringWithFormat:@"%@%@",HuobiBaseURL,HuobiBanance];
    NSString *timestamp = [NetManager getNowTimeTimestamp];
    NSDictionary *dic = @{@"apiKey":[CreateAll GetHuobiAPIKey],
                          @"apiSecret":[CreateAll GetHuobiAPISecret],
                          @"timestamp":timestamp
                          };
    NSString *sign = [NetManager signParams:dic];
    NSDictionary *params = @{@"apiKey":[CreateAll GetHuobiAPIKey],
                             @"apiSecret":[CreateAll GetHuobiAPISecret],
                             @"timestamp":timestamp,
                             @"sign":sign
                             };
    [self POSTSetHeader:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
        if(!error){
            NSDictionary *responseDic = ((NSData *)repsonseObj).jsonValueDecoded;
            !handler ?:handler(responseDic,error);
        }else{
            NSError *err = [NSError ErrorWithTitle:@"查询余额失败" Code:333001];
            !handler ?:handler(nil,err);
        }
    }];
}

/*
 huobi api
 获取币种深度
 symbol  例 usdtbtc
 */
+(void)HuobiGetDepthSymbol:(NSString *)symbol Depth:(NSInteger)type CompletionHandler:(void (^)(id responseObj, NSError *error))handler{
    NSString *path = [NSString stringWithFormat:@"%@%@",HuobiBaseURL,HuobiDepth];
    NSString *timestamp = [NetManager getNowTimeTimestamp];
    NSString *typestr = [NSString stringWithFormat:@"step%ld",type];
    NSDictionary *dic = @{
                          @"type":typestr,
                          @"symbol":symbol,
                          @"timestamp":timestamp
                          };
    NSString *sign = [NetManager signParams:dic];
    NSDictionary *params = @{
                             @"timestamp":timestamp,
                             @"type":typestr,
                             @"symbol":symbol,
                             @"sign":sign
                             };
    [self GET:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
        if(!error){
            !handler ?:handler(repsonseObj,error);
        }else{
            NSError *err = [NSError ErrorWithTitle:@"获取币种深度失败" Code:333002];
            !handler ?:handler(nil,err);
        }
    }];
}

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
+(void)HuobiGetOrderSymbol:(NSString *)symbol OrderStates:(HUOBI_Order_States)states CompletionHandler:(void (^)(id responseObj, NSError *error))handler{
    NSString *path = [NSString stringWithFormat:@"%@%@",HuobiBaseURL,HuobiOrderNow];
    NSString *timestamp = [NetManager getNowTimeTimestamp];
    NSString *statesstr;
    if (states >= 0 && states < 5) {
        statesstr = [@[@"submitted",@"partial-filled",@"partial-canceled",@"filled",@"canceled"] objectAtIndex:states];
    }
    NSDictionary *dic;
    if ([VALIDATE_STRING(statesstr) isEqualToString:@""]) {
        statesstr = @"partial-filled,partial-canceled,filled,canceled";
    }
    dic = @{@"apiKey":[CreateAll GetHuobiAPIKey],
            @"apiSecret":[CreateAll GetHuobiAPISecret],
            @"symbol":symbol,
            @"states":VALIDATE_STRING(statesstr),
            @"timestamp":timestamp
            };
    NSString *sign = [NetManager signParams:dic];
    NSMutableDictionary *params = [@{@"apiKey":[CreateAll GetHuobiAPIKey],
                             @"apiSecret":[CreateAll GetHuobiAPISecret],
                             @"timestamp":timestamp,
                             @"symbol":symbol,
                             @"sign":sign
                             } mutableCopy];
    [VALIDATE_STRING(statesstr) isEqualToString:@""]?:[params setValue:VALIDATE_STRING(statesstr) forKey:@"states"];
    [self POSTSetHeader:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
        if(!error){
            NSDictionary *responseDic = ((NSData *)repsonseObj).jsonValueDecoded;
            !handler ?:handler(responseDic,error);
        }else{
            NSError *err = [NSError ErrorWithTitle:@"获取当前委托失败" Code:333003];
            !handler ?:handler(nil,err);
        }
    }];
}

/*
 huobi api
 所有币种
 */
+(void)HuobiGetSymbolsCompletionHandler:(void (^)(id responseObj, NSError *error))handler{
    NSString *path = [NSString stringWithFormat:@"%@%@",HuobiBaseURL,HuobiSymbols];
    [self GET:path parameters:nil completionHandler:^(id repsonseObj, NSError *error) {
        if(!error){
//            NSDictionary *responseDic = ((NSData *)repsonseObj);
            !handler ?:handler(repsonseObj,error);
        }else{
            NSError *err = [NSError ErrorWithTitle:@"查询所有币种失败" Code:333004];
            !handler ?:handler(nil,err);
        }
    }];
    
}

/*
 huobi api
 下单
 
 amount    是    string    数量
 price    否    string    价格
 symbol    是    string    币种
 type    是    string    订单类型 1、限价买入：buy-limit；2、限价卖出：sell-limit；3、市价买入：buy-market；4：市价卖出：sell-market
 */
+(void)HuobiCreateOrderAmount:(NSString *)amount Price:(NSString *)price Symbol:(NSString *)symbol Type:(HUOBI_Order_Type)type  CompletionHandler:(void (^)(id responseObj, NSError *error))handler{
    NSString *path = [NSString stringWithFormat:@"%@%@",HuobiBaseURL,HuobiCreateOrder];
    NSString *timestamp = [NetManager getNowTimeTimestamp];
    NSString *typestr = [@[@"buy-limit",@"sell-limit",@"buy-market",@"sell-market"] objectAtIndex:type];
    
    NSMutableDictionary *dic = [@{@"apiKey":[CreateAll GetHuobiAPIKey],
                                  @"apiSecret":[CreateAll GetHuobiAPISecret],
                                  @"amount":amount,
                                  @"symbol":symbol,
                                  @"type":typestr,
                                  @"timestamp":timestamp
                                  } mutableCopy];
    if (price > 0 && ![typestr containsString:@"market"]) {
        [dic setObject:price forKey:@"price"];
    }
    NSString *sign = [NetManager signParams:dic];
    NSMutableDictionary *params = [@{@"apiKey":[CreateAll GetHuobiAPIKey],
                                     @"apiSecret":[CreateAll GetHuobiAPISecret],
                                     @"timestamp":timestamp,
                                     @"amount":amount,
                                     @"symbol":symbol,
                                     @"type":typestr,
                                     @"sign":sign
                                     } mutableCopy];
    if (price > 0 && ![typestr containsString:@"market"]) {
        [params setObject:price forKey:@"price"];
    }
    [self POSTSetHeader:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
        if(!error){
            NSDictionary *responseDic = ((NSData *)repsonseObj).jsonValueDecoded;
            !handler ?:handler(responseDic,error);
        }else{
            NSError *err = [NSError ErrorWithTitle:@"下单失败" Code:333005];
            !handler ?:handler(nil,err);
        }
    }];
}


/*
 huobi api
 撤销订单
 
 */
+(void)HuobiCancelOrderWithID:(NSString *)orderId CompletionHandler:(void (^)(id responseObj, NSError *error))handler{
    NSString *path = [NSString stringWithFormat:@"%@%@",HuobiBaseURL,HuobiCancelOrder];
    NSString *timestamp = [NetManager getNowTimeTimestamp];
    
    NSMutableDictionary *dic = [@{@"apiKey":[CreateAll GetHuobiAPIKey],
                                  @"apiSecret":[CreateAll GetHuobiAPISecret],
                                  @"orderId":VALIDATE_STRING(orderId),
                                  @"timestamp":timestamp
                                  } mutableCopy];
    NSString *sign = [NetManager signParams:dic];
    NSDictionary *params = @{@"apiKey":[CreateAll GetHuobiAPIKey],
                                      @"apiSecret":[CreateAll GetHuobiAPISecret],
                                      @"orderId":VALIDATE_STRING(orderId),
                                      @"timestamp":timestamp,
                                      @"sign":sign
                                      };
    [self POSTSetHeader:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
        if(!error){
            NSDictionary *responseDic = ((NSData *)repsonseObj).jsonValueDecoded;
            !handler ?:handler(responseDic,error);
        }else{
            NSError *err = [NSError ErrorWithTitle:@"下单失败" Code:333005];
            !handler ?:handler(nil,err);
        }
    }];
}
@end
