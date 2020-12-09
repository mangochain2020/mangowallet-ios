//
//  BTCTransactionRecordModel.h
//  TaiYiToken
//
//  Created by admin on 2018/9/17.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ScriptPubKey,ScriptSig,VIN,VOUT;
@interface BTCTransactionRecordModel : NSObject
@property (nonatomic, strong) NSString * blockhash;
@property (nonatomic, assign) NSInteger blockheight;
@property (nonatomic, assign) NSInteger blocktime;//
@property (nonatomic, assign) NSInteger confirmations;//
@property (nonatomic, assign) CGFloat fees;
@property (nonatomic, assign) NSInteger locktime;
@property (nonatomic, assign) NSInteger size;
@property (nonatomic, assign) NSInteger time;//时间 1535335261
@property (nonatomic, strong) NSString * txid;//
@property (nonatomic, assign) CGFloat valueIn;//valueIn，valueOut都是0，表示失败
@property (nonatomic, assign) CGFloat valueOut;//
@property (nonatomic, assign) NSInteger version;
@property (nonatomic, strong) NSArray <VIN *> *vin;
@property (nonatomic, strong) NSArray <VOUT *> *vout;
@property (nonatomic, assign) TranResultSelectType selectType;
@end

@interface VIN : NSObject
@property (nonatomic, strong) NSString * addr;
@property (nonatomic, strong) NSObject * doubleSpentTxID;
@property (nonatomic, assign) NSInteger n;
@property (nonatomic, strong) ScriptSig * scriptSig;
@property (nonatomic, assign) NSInteger sequence;
@property (nonatomic, strong) NSString * txid;
@property (nonatomic, assign) CGFloat value;
@property (nonatomic, assign) NSInteger valueSat;
@property (nonatomic, assign) NSInteger vout;
@end

@interface VOUT : NSObject
@property (nonatomic, assign) NSInteger n;
@property (nonatomic, strong) ScriptPubKey * scriptPubKey;
@property (nonatomic, strong) NSObject * spentHeight;
@property (nonatomic, strong) NSObject * spentIndex;
@property (nonatomic, strong) NSObject * spentTxId;
@property (nonatomic, strong) NSString * value;
@end

@interface ScriptPubKey : NSObject
@property (nonatomic, strong) NSArray * addresses;
@property (nonatomic, strong) NSString * asmm;//asm
@property (nonatomic, strong) NSString * hex;
@property (nonatomic, strong) NSString * type;
@end

@interface ScriptSig : NSObject
@property (nonatomic, strong) NSString * asmm;//asm
@property (nonatomic, strong) NSString * hex;
@end
