//
//  SAMKeyChainEasy.m
//  AdMoProduct
//
//  Created by Frued on 2018/7/27.
//  Copyright © 2018年 Frued. All rights reserved.
//

#import "SAMKeyChainEasy.h"

@implementation SAMKeyChainEasy
+(void)deleteAllKeyChainAcct{
    NSArray *arr = [SAMKeychain allAccounts];
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       @autoreleasepool {
           NSDictionary *dic = obj;
           [SAMKeychain deletePasswordForService:PRODUCT_BUNDLE_ID account:dic[@"acct"]];
        }
    }];
}
@end
