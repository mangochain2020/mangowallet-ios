//
//  ETHTransactionRecordModel.h
//  TaiYiToken
//
//  Created by admin on 2018/9/17.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ETHTransactionRecordModel : NSObject
@property (nonatomic, assign) TranResultSelectType selectType;
@property (nonatomic, strong) TransactionInfo *info;

@property (nonatomic, copy) NSString *blockHash;
@property (nonatomic, copy) NSString *blockNumber;
@property (nonatomic, copy) NSString *confirmations;
@property (nonatomic, copy) NSString *contractAddress;
@property (nonatomic, copy) NSString *cumulativeGasUsed;
@property (nonatomic, copy) NSString *gas;
@property (nonatomic, copy) NSString *gasPrice;
@property (nonatomic, copy) NSString *gasUsed;
@property (nonatomic, copy) NSString *hash;
@property (nonatomic, copy) NSString *input;
@property (nonatomic, copy) NSString *isError;
@property (nonatomic, copy) NSString *nonce;
@property (nonatomic, copy) NSString *timeStamp;
@property (nonatomic, copy) NSString *to;
@property (nonatomic, copy) NSString *from;
@property (nonatomic, copy) NSString *transactionIndex;
@property (nonatomic, copy) NSString *txreceipt_status;
@property (nonatomic, copy) NSString *value;

@end
