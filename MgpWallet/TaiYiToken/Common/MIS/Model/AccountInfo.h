//
//  HTTPRequestManager.h
//  TaiYiToken
//
//  Created by Frued on 2018/10/25.
//  Copyright © 2018 admin. All rights reserved.
//


#import <Foundation/Foundation.h>
//#import "Account.h"


@interface Key : NSObject

@property (nonatomic, copy) NSString *key;
@property (nonatomic, assign) NSInteger weight;

@end


@interface Auth : NSObject

@property (nonatomic, copy) NSArray *accounts;
@property (nonatomic, copy) NSArray <Key *> *keys;
@property (nonatomic, assign) NSInteger threshold;
@property (nonatomic, copy) NSArray *waits;

@end


@interface Permission : NSObject

@property (nonatomic, copy) NSString *parent;
@property (nonatomic, copy) NSString *perm_name;
@property (nonatomic, strong) Auth *required_auth;

@end

@interface Resources :NSObject

@property (nonatomic, copy) NSString *cpu_weight;
@property (nonatomic, copy) NSString *net_weight;
@property (nonatomic, copy) NSString *owner;
@property (nonatomic, assign) NSInteger ram_bytes;

@end

@interface NET : NSObject

@property (nonatomic, assign) NSInteger available;
@property (nonatomic, assign) NSInteger max;
@property (nonatomic, assign) NSInteger used;

@end

@interface CPU : NSObject

@property (nonatomic, assign) NSInteger available;
@property (nonatomic, assign) NSInteger max;
@property (nonatomic, assign) NSInteger used;

@end

@interface VoterInfo : NSObject

@property (nonatomic, assign) NSInteger is_proxy;
@property (nonatomic, assign) CGFloat last_vote_weight;
@property (nonatomic, copy) NSString *owner;
@property (nonatomic, copy) NSArray *producers;
@property (nonatomic, assign) CGFloat proxied_vote_weight;
@property (nonatomic, copy) NSString *proxy;
@property (nonatomic, assign) NSInteger staked;//抵押
@end

@interface RefundRequest : NSObject

@property (nonatomic, copy) NSString *cpu_amount;//赎回EOS
@property (nonatomic, copy) NSString *net_amount;
@property (nonatomic, copy) NSString *owner;
@property (nonatomic, copy) NSString *request_time;

@end

@interface SelfDelegatedBandwidth : NSObject

@property (nonatomic, copy) NSString *cpu_weight;//EOS
@property (nonatomic, copy) NSString *from;
@property (nonatomic, copy) NSString *net_weight;
@property (nonatomic, copy) NSString *to;

@end

@interface AccountInfo : NSObject

@property (nonatomic, strong) NSString *account_name;
@property (nonatomic, copy) NSString *core_liquid_balance;
@property (nonatomic, strong) CPU *cpu_limit;
@property (nonatomic, assign) NSInteger cpu_weight;
@property (nonatomic, copy) NSString *created;
@property (nonatomic, assign) double head_block_num;
@property (nonatomic, copy) NSString *head_block_time;
@property (nonatomic, copy) NSString *last_code_update;
@property (nonatomic, strong) NET *net_limit;
@property (nonatomic, assign) NSInteger net_weight;
@property (nonatomic, copy) NSArray <Permission *> *permissions;
@property (nonatomic, assign) NSInteger privileged;
@property (nonatomic, assign) NSInteger ram_quota;
@property (nonatomic, assign) NSInteger ram_usage;
@property (nonatomic, strong) Resources *total_resources;
@property (nonatomic, strong)VoterInfo *voter_info;
@property (nonatomic, strong)RefundRequest *refund_request;
@property (nonatomic, strong)SelfDelegatedBandwidth *self_delegated_bandwidth;

@end
