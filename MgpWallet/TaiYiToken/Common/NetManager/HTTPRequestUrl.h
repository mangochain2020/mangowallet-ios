//
//  HTTPRequestManager.h
//  TaiYiToken
//
//  Created by Frued on 2018/10/25.
//  Copyright © 2018 admin. All rights reserved.
//

#ifndef HTTPRequestUrl_h
#define HTTPRequestUrl_h

/** 获取账号信息 **/
#define eos_get_account @"v1/chain/get_account"
/** 获取当前最新的区块号 **/
#define eos_get_info @"v1/chain/get_info"
/** 获取当前区块详情 **/
#define eos_get_block @"v1/chain/get_block"
/** 获取公钥 **/
#define eos_get_required_keys @"v1/chain/get_required_keys"
/** 提交区块 **/
#define eos_push_transaction @"v1/chain/push_transaction"
/** 调用将一组交易提交到链上 **/
#define eos_push_transactions @"v1/chain/push_transactions"
/** add **/
#define eos_abi_bin_to_json @"v1/chain/abi_bin_to_json"
/** 获取行动码 **/
#define eos_abi_json_to_bin @"v1/chain/abi_json_to_bin"
/** get_code **/
#define eos_get_table_rows @"v1/chain/get_table_rows"
/** get_code **/
#define eos_get_code @"v1/chain/get_code"
/** get_raw_code_and_abi **/
#define eos_get_raw_code_and_abi @"v1/chain/get_raw_code_and_abi"
/** get_currency_stats **/
#define eos_get_currency_stats @"v1/chain/get_currency_stats"
/** get_producers **/
#define eos_get_producers @"v1/chain/get_producers"
/** push_block **/
#define eos_push_block @"v1/chain/push_block"
/** 获取余额 **/
#define eos_get_currency_balance @"v1/chain/get_currency_balance"



/** 获取交易记录 **/
#define eos_get_actions @"v1/history/get_actions"
/** get_transaction **/
#define eos_get_transaction @"v1/history/get_transaction"
/** get_key_accounts **/
#define eos_get_key_accounts @"v1/history/get_key_accounts"
/** get_controlled_accounts **/
#define eos_get_controlled_accounts @"v1/history/get_controlled_accounts"



//++++



// eosmonitor actions
#define eosmonitor(account,action,page,pagesize) [NSString stringWithFormat:@"actions?name=%@&account=%@&page=%@&per_page=%@",action,account,page,pagesize]

#define eos_get_transfer @"transfer"


// eosmonitor API
#define eos_get_transaction_action(transaction_id) [NSString stringWithFormat:@"transactions/%@/actions",transaction_id]


#endif /* HTTPRequestUrl_h */
//https://api.eosmonitor.io/v1/transactions/<transaction_id>/actions
