//
//  BTCBalanceModel.m
//  TaiYiToken
//
//  Created by admin on 2018/9/14.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "BTCBalanceModel.h"

@implementation BTCBalanceModel
- (void)setValue:(id)value forKey:(NSString *)key{
    if (value == NULL || value == [NSNull null]) {
        [self setValue:nil forKey:key];
    }
}
@end
