//
//  NSObject+Parse.m
//  Day10_PodDemo
//
//  Created by tarena on 16/9/12.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "NSObject+Parse.h"

@implementation NSObject (Parse)

+ (id)parse:(id)json{
    if ([json isKindOfClass:[NSArray class]]) {
        //参数1:数组中的元素类型
        return [NSArray modelArrayWithClass:[self class] json:json];
    }
    if ([json isKindOfClass:[NSDictionary class]]) {
        //YYModel提供的JSON字典转 类对象的方法
        return [self modelWithJSON:json];
    }
    return json;
}

@end
