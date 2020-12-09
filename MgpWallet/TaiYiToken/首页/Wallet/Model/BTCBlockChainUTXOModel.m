//
//  BTCBlockChainUTXOModel.m
//  TaiYiToken
//
//  Created by 张元一 on 2018/12/11.
//  Copyright © 2018 admin. All rights reserved.
//

#import "BTCBlockChainUTXOModel.h"

@implementation BTCBlockChainUTXOModel

- (void)setValue:(id)value forKey:(NSString *)key{
    if (value == NULL || value == [NSNull null]) {
        [self setValue:nil forKey:key];
    }
}
@end
