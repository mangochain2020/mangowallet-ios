//
//  BTCUTXOModel.h
//  TaiYiToken
//
//  Created by admin on 2018/9/11.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTCUTXOModel : NSObject
@property (nonatomic, strong) NSString * address;
@property (nonatomic, assign) CGFloat amount;
@property (nonatomic, assign) NSInteger confirmations;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, assign) NSInteger satoshis;
@property (nonatomic, strong) NSString * scriptPubKey;
@property (nonatomic, strong) NSString * txid;
@property (nonatomic, assign) NSInteger vout;
@property (nonatomic, assign) NSInteger ts;
@end
