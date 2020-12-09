//
//  MISTransactionRecordModel.m
//  TaiYiToken
//
//  Created by 张元一 on 2018/10/26.
//  Copyright © 2018 admin. All rights reserved.
//

#import "MISTransactionRecordModel.h"

@implementation MISTransactionRecordModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
             @"actionTrace":[ActionTrace class]
             };
}
@end


@implementation ActionTrace
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
             @"act":[Act class],
             @"receipt":[Receipt class],
             @"inline_traces" :[ActionTrace class]
             };
}
@end

@implementation Receipt

@end
@implementation Act
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
             @"data":[ActData class]
             };
}
@end
@implementation ActData

@end
@implementation Authorization

@end
