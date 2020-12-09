//
//  DCOrderListModel.m
//  TaiYiToken
//
//  Created by mac on 2020/8/6.
//  Copyright © 2020 admin. All rights reserved.
//

#import "DCOrderListModel.h"

@implementation Pro
@end

@implementation StoreUserDelivery
@end


@implementation Order
//+ (NSDictionary *)mj_objectClassInArray {
//
//    return @{@"appStoreUserDelivery" : @"StoreUserDelivery"};  //前边，是属性数组的名字，后边就是类名
//}
@end


@implementation DataItem

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"pro" : @"Pro",@"Order":@"order"};  //前边，是属性数组的名字，后边就是类名
}

@end

@implementation DCOrderListModel


+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"data" : @"DataItem"};  //前边，是属性数组的名字，后边就是类名
}

@end
