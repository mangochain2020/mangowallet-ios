//
//  HuobibalanceModel.m
//  TaiYiToken
//
//  Created by 张元一 on 2019/3/11.
//  Copyright © 2019 admin. All rights reserved.
//

#import "HuobiBalanceModel.h"

@implementation HuobiBalanceModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
             @"data":[HuobiBalanceData class]
             };
}
@end

@implementation HuobiBalanceData
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
             @"data":[HuobiBalanceDetailData class]
             };
}
@end

@implementation HuobiBalanceDetailData
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
             @"list":[HuobiBalanceListObj class]
             };
}
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    
    return @{@"ID":@"id"
             };
}
@end

@implementation HuobiBalanceListObj

@end

