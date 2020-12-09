//
//  EthereumLocalTx.m
//  realmDemo
//
//  Created by mac on 2020/9/24.
//  Copyright © 2020 mac. All rights reserved.
//

#import "EthereumLocalTx.h"

@implementation EthereumLocalTx

/** 设置主键 */
//+ (NSString *)primaryKey{
//    return @"ID";
//}
//需要添加索引的属性
+ (NSArray *)indexedProperties {
    return @[@"txHash"];
}

//默认属性值
+ (NSDictionary *)defaultPropertyValues {
    if (@available(iOS 13.0, *)) {
        return @{@"date":[NSDate now]};
    } else {
        // Fallback on earlier versions
        return @{@"date":[NSDate date]};
    }
}

@end
