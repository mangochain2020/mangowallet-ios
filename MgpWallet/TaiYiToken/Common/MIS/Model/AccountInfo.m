//
//  HTTPRequestManager.h
//  TaiYiToken
//
//  Created by Frued on 2018/10/25.
//  Copyright © 2018 admin. All rights reserved.
//

#import "AccountInfo.h"

@implementation CPU

@end

@implementation NET

@end

@implementation Resources

@end

@interface Auth () <YYModel>
@end

@implementation Auth

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"keys":[Key class]};
}

@end

@implementation Key

@end

@implementation Permission

@end

@implementation VoterInfo

@end

@implementation RefundRequest

@end

@implementation SelfDelegatedBandwidth

@end

@interface AccountInfo () <YYModel>
@end

@implementation AccountInfo

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"permissions":[Permission class],@"voter_info":[VoterInfo class]
             ,@"cpu_limit":[CPU class],@"net_limit":[NET class]
             ,@"total_resources":[Resources class],@"refund_request":[RefundRequest class],
             @"self_delegated_bandwidth":[SelfDelegatedBandwidth class]
             };
}

@end
