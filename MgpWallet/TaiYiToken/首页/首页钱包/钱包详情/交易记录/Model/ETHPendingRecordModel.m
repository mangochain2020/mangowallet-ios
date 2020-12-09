//
//  ETHPendingRecordModel.m
//  TaiYiToken
//
//  Created by 张元一 on 2018/12/4.
//  Copyright © 2018 admin. All rights reserved.
//

#import "ETHPendingRecordModel.h"

@implementation ETHPendingRecordModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
             @"result":[Result class]
             };
}
@end
@implementation Result

@end
