//
//  BTCBlockChainListModel.m
//  TaiYiToken
//
//  Created by 张元一 on 2018/12/6.
//  Copyright © 2018 admin. All rights reserved.
//

#import "BTCBlockChainListModel.h"

@implementation BTCBlockChainListModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
             @"txs":[Tx class]
             };
}

@end

@implementation Tx
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
             @"inputs":[Input class],
             @"outputs":[Output class]
             };
}
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    
    return @{@"outputs":@"out",
             @"hashs":@"hash"
            };
}

@end

@implementation Input
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
             @"prev_out":[PrevOut class]
             };
}
@end

@implementation Output

@end

@implementation PrevOut
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
             @"spending_outpoints":[SpendingOutpoint class]
             };
}
@end

@implementation SpendingOutpoint

@end
