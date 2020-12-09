
//
//  BTCUTXOModel.m
//  TaiYiToken
//
//  Created by admin on 2018/9/11.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "BTCUTXOModel.h"

@implementation BTCUTXOModel
- (void)setValue:(id)value forKey:(NSString *)key{
    if (value == NULL || value == [NSNull null]) {
        [self setValue:nil forKey:key];
    }
}
@end
