//
//  SymbolInfoModel.m
//  TaiYiToken
//
//  Created by admin on 2018/10/12.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "SymbolInfoModel.h"

@implementation SymbolInfoModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"kLineDataArray" : [NewklineDataModel class],
             @"symbolInfo" : [NewSymbolInfo class]};
}
- (void)setValue:(id)value forKey:(NSString *)key{
    if (value == NULL || value == [NSNull null]) {
        [self setValue:nil forKey:key];
    }
}
@end

@implementation NewSymbolInfo
- (void)setValue:(id)value forKey:(NSString *)key{
    if (value == NULL || value == [NSNull null]) {
        [self setValue:nil forKey:key];
    }
}
@end


@implementation NewklineDataModel
+(NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"id":@"ID"};
}
- (void)setValue:(id)value forKey:(NSString *)key{
    if (value == NULL || value == [NSNull null]) {
        [self setValue:nil forKey:key];
    }
}
@end
