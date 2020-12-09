//
//  HuobiSymbolsModel.m
//  TaiYiToken
//
//  Created by 张元一 on 2019/3/11.
//  Copyright © 2019 admin. All rights reserved.
//

#import "HuobiSymbolsModel.h"

@implementation HuobiSymbolsModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
             @"data":[HuobiSymbolsData class]
             };
}
@end

@implementation HuobiSymbolsData
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
             @"btc":[HuobiSymbolsDetail class],
             @"eth":[HuobiSymbolsDetail class],
             @"ht":[HuobiSymbolsDetail class],
             @"husd":[HuobiSymbolsDetail class],
             @"usdt":[HuobiSymbolsDetail class]
             };
}
@end

@implementation HuobiSymbolsDetail

@end

