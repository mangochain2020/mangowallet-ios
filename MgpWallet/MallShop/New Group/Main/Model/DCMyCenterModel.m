//
//  DCMyCenterModel.m
//  TaiYiToken
//
//  Created by mac on 2020/8/10.
//  Copyright © 2020 admin. All rights reserved.
//

#import "DCMyCenterModel.h"

@implementation AppUser
@end

@implementation Shop
@end

@implementation Top
@end


@implementation Down
@end

@implementation Orders
@end

@implementation DCMyCenterModel
+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"top" : @"Top",@"down":@"Down",@"orders":@"Orders",@"shop":@"Shop",@"appUser":@"AppUser"};  //前边，是属性数组的名字，后边就是类名
}

@end
