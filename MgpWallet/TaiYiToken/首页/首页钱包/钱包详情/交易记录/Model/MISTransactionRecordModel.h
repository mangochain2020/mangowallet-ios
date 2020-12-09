//
//  MISTransactionRecordModel.h
//  TaiYiToken
//
//  Created by 张元一 on 2018/10/26.
//  Copyright © 2018 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class ActionTrace,Receipt,Act,ActData,Authorization;

@interface MISTransactionRecordModel : NSObject
@property (nonatomic, assign) NSInteger account_action_seq;
@property (nonatomic, strong) ActionTrace * action_trace;
@property (nonatomic, assign) NSInteger block_num;
@property (nonatomic, strong) NSString * block_time;
@property (nonatomic, assign) NSInteger global_action_seq;
@end

@interface ActionTrace : NSObject
@property (nonatomic, strong) NSArray * account_ram_deltas;
@property (nonatomic, strong) Act * act;
@property (nonatomic, assign) NSInteger block_num;
@property (nonatomic, strong) NSString * block_time;
@property (nonatomic, strong) NSString * console;
@property (nonatomic, assign) BOOL context_free;
@property (nonatomic, assign) NSInteger elapsed;
@property (nonatomic, strong) NSObject * except;
@property (nonatomic, strong) NSArray <ActionTrace *>* inline_traces;
@property (nonatomic, strong) NSObject * producer_block_id;
@property (nonatomic, strong) Receipt * receipt;
@property (nonatomic, strong) NSString * trx_id;

@end

@interface Receipt : NSObject
@property (nonatomic, assign) NSInteger abi_sequence;
@property (nonatomic, strong) NSString * act_digest;
@property (nonatomic, strong) NSArray * auth_sequence;
@property (nonatomic, assign) NSInteger code_sequence;
@property (nonatomic, assign) NSInteger global_sequence;
@property (nonatomic, strong) NSString * receiver;
@property (nonatomic, assign) NSInteger recv_sequence;
@end


@interface Act : NSObject

@property (nonatomic, strong) NSString * account;
@property (nonatomic, strong) NSArray * authorization;
@property (nonatomic, strong) ActData * data;
@property (nonatomic, strong) NSString * hex_data;
@property (nonatomic, strong) NSString * name;

@end

@interface ActData : NSObject

@property (nonatomic, strong) NSString * from;
@property (nonatomic, strong) NSString * to;
@property (nonatomic, strong) NSString * memo;
@property (nonatomic, strong) NSString * quantity;
@property (nonatomic, strong) NSString * unstake_cpu_quantity;
@property (nonatomic, strong) NSString * unstake_net_quantity;
@property (nonatomic, strong) NSString * stake_cpu_quantity;
@property (nonatomic, strong) NSString * stake_net_quantity;
@property (nonatomic, strong) NSString * receiver;
@property (nonatomic, strong) NSString * payer;//buy ram
@property (nonatomic, strong) NSString * quant;//buy ram
@property (nonatomic, strong) NSString * action;//sale ram
@property (nonatomic, strong) NSString * bytes;
@property (nonatomic, strong) NSString * account;
@end

@interface Authorization : NSObject

@property (nonatomic, strong) NSString * actor;
@property (nonatomic, strong) NSString * permission;

@end


NS_ASSUME_NONNULL_END
