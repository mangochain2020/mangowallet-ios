//
//  BTCBlockChainUTXOModel.h
//  TaiYiToken
//
//  Created by 张元一 on 2018/12/11.
//  Copyright © 2018 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTCBlockChainUTXOModel : NSObject
@property (nonatomic, assign) NSUInteger confirmations;
@property (nonatomic, strong) NSString * script;
@property (nonatomic, strong) NSString * tx_hash;
@property (nonatomic, strong) NSString * tx_hash_big_endian;
@property (nonatomic, assign) NSUInteger tx_index;
@property (nonatomic, assign) NSUInteger tx_output_n;
@property (nonatomic, assign) NSUInteger value;
@property (nonatomic, strong) NSString * value_hex;
@end

NS_ASSUME_NONNULL_END
