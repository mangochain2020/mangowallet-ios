//
//  HuobiCreateOrderModel.m
//  TaiYiToken
//
//  Created by 张元一 on 2019/3/11.
//  Copyright © 2019 admin. All rights reserved.
//

#import "HuobiCreateOrderModel.h"

@implementation HuobiCreateOrderModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
             @"data":[HuobiCreateOrderData class]
             };
}
@end

@implementation HuobiCreateOrderData

@end
