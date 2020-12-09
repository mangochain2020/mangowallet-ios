//
//  HuobiDepthModel.m
//  TaiYiToken
//
//  Created by 张元一 on 2019/3/11.
//  Copyright © 2019 admin. All rights reserved.
//

#import "HuobiDepthModel.h"

@implementation HuobiDepthModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
             @"data":[HuobiDepthData class]
             };
}
@end

@implementation HuobiDepthData
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
             @"tick":[HuobiDepthTick class]
             };
}
@end

@implementation HuobiDepthTick
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    
    return @{@"ID":@"id"
             };
}
@end

