//
//  HuobiOrderNowModel.m
//  TaiYiToken
//
//  Created by 张元一 on 2019/3/11.
//  Copyright © 2019 admin. All rights reserved.
//

#import "HuobiOrderNowModel.h"

@implementation HuobiOrderNowModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
             @"data":[HuobiOrderNowData class]
             };
}
@end

@implementation HuobiOrderNowData
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
             @"data":[HuobiOrderNowArrObj class]
             };
}
@end

@implementation HuobiOrderNowArrObj
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    
    return @{@"ID":@"id"
             };
}
@end
