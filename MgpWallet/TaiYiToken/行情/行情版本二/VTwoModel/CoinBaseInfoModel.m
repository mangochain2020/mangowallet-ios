//
//  CoinBaseInfoModel.m
//  TaiYiToken
//
//  Created by 张元一 on 2018/11/22.
//  Copyright © 2018 admin. All rights reserved.
//

#import "CoinBaseInfoModel.h"

@implementation CoinBaseInfoModel
- (void)setValue:(id)value forKey:(NSString *)key{
    if (value == NULL || value == [NSNull null]) {
        [self setValue:nil forKey:key];
    }
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"klineData" : [KlineDataModel class],
             @"exchangeItems" : [ExchangeItem class]};
}
@end

@implementation KlineDataModel
- (void)setValue:(id)value forKey:(NSString *)key{
    if (value == NULL || value == [NSNull null]) {
        [self setValue:nil forKey:key];
    }
}
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    
    return @{@"ID":@"id"
             };
}
@end

@implementation ExchangeItem
- (void)setValue:(id)value forKey:(NSString *)key{
    if (value == NULL || value == [NSNull null]) {
        [self setValue:nil forKey:key];
    }
}

@end
