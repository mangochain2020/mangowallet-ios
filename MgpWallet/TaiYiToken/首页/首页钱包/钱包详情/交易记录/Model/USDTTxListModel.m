//
//  USDTTxListModel.m
//  TaiYiToken
//
//  Created by 张元一 on 2019/4/28.
//  Copyright © 2019 admin. All rights reserved.
//

#import "USDTTxListModel.h"

@implementation USDTTxListModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
             @"transactions":[USDTTxListData class]
             };
}
@end

@implementation USDTTxListData

@end
