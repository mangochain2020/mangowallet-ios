//
//  HuobiCancelOrderModel.m
//  TaiYiToken
//
//  Created by 张元一 on 2019/3/11.
//  Copyright © 2019 admin. All rights reserved.
//

#import "HuobiCancelOrderModel.h"

@implementation HuobiCancelOrderModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
             @"data":[HuobiCancelOrderData class]
             };
}
@end

@implementation HuobiCancelOrderData

@end
