//
//  ETHPendingRecordModel.h
//  TaiYiToken
//
//  Created by 张元一 on 2018/12/4.
//  Copyright © 2018 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class Result;
@interface ETHPendingRecordModel : NSObject
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString * jsonrpc;
@property (nonatomic, strong) Result * result;
@end

@interface Result : NSObject
@property (nonatomic, strong) NSString * blockHash;
@property (nonatomic, strong) NSString * blockNumber;
@property (nonatomic, strong) NSString * from;
@property (nonatomic, strong) NSString * gas;
@property (nonatomic, strong) NSString * gasPrice;
@property (nonatomic, strong) NSString * hash;
@property (nonatomic, strong) NSString * input;
@property (nonatomic, assign) NSInteger nonce;
@property (nonatomic, strong) NSString * r;
@property (nonatomic, strong) NSString * s;
@property (nonatomic, strong) NSString * to;
@property (nonatomic, strong) NSString * transactionIndex;
@property (nonatomic, strong) NSString * v;
@property (nonatomic, strong) NSString * value;
@end

NS_ASSUME_NONNULL_END
