//
//  EthereumLocalTx.h
//  realmDemo
//
//  Created by mac on 2020/9/24.
//  Copyright © 2020 mac. All rights reserved.
//

#import "RLMObject.h"
#import "TokenModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface EthereumLocalTx : RLMObject

@property NSString *ID;
@property NSString *txHash;
@property TokenModel *token;
@property NSString *form;
@property NSString *to;
@property NSString *value;
@property NSString *gasPrice;
@property NSString *gasLimit;
@property NSDate *date;
@property NSData *data;
@property NSString *statusValue;
@property NSString *network;

@end

NS_ASSUME_NONNULL_END
