//
//  BTCTransactionRecordModel.m
//  TaiYiToken
//
//  Created by admin on 2018/9/17.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "BTCTransactionRecordModel.h"

@implementation BTCTransactionRecordModel
+(NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"vin":@"VIN",@"vout":@"VOUT"};
}

@end


@implementation VIN
+(NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"scriptSig":@"ScriptSig"};
}

@end

@implementation VOUT
+(NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"scriptPubKey":@"ScriptPubKey"};
}

@end



@implementation ScriptPubKey
+(NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"asm":@"asmm"};
}
@end

@implementation ScriptSig
+(NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"asm":@"asmm"};
}
@end
