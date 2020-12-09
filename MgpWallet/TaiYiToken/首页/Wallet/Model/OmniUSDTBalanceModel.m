//
//  OmniUSDTBalanceModel.m
//  TaiYiToken
//
//  Created by 张元一 on 2019/4/24.
//  Copyright © 2019 admin. All rights reserved.
//

#import "OmniUSDTBalanceModel.h"

@implementation OmniUSDTBalanceModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"balance":[OmniUSDTBalanceData class]};
}
@end
@implementation OmniUSDTBalanceData

@end
