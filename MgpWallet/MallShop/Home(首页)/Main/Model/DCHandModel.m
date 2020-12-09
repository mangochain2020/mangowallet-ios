//
//  DCGridItem.m
//  CDDMall
//
//  Created by apple on 2017/6/6.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import "DCHandModel.h"

/*
@implementation ProListItem
@end


@implementation HotListItem

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"proList" : @"ProListItem"};  //前边，是属性数组的名字，后边就是类名
}
@end


@implementation CategoryListItem
@end


@implementation Notice
@end

@implementation DCHandModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"categoryList" : @"CategoryListItem",@"hotList":@"HotListItem",@"Notice":@"notice"};  //前边，是属性数组的名字，后边就是类名
}

@end
*/

@implementation ProList
+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"list" : @"ProListItem"};  //前边，是属性数组的名字，后边就是类名
}
@end

@implementation Hot
+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"list" : @"ProListItem"};  //前边，是属性数组的名字，后边就是类名
}
@end

@implementation CateListItem
@end


@implementation DCHandModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"cateList" : @"CateListItem",@"proList":@"ProList",@"hot":@"Hot"};  //前边，是属性数组的名字，后边就是类名
}

@end

