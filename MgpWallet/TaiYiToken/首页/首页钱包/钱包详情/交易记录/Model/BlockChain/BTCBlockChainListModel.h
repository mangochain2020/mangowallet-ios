//
//  BTCBlockChainListModel.h
//  TaiYiToken
//
//  Created by 张元一 on 2018/12/6.
//  Copyright © 2018 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class Tx,Input,Output,PrevOut,SpendingOutpoint;

@interface BTCBlockChainListModel : NSObject
//@property (nonatomic, strong) NSArray * addresses;
//@property (nonatomic, strong) Info * info;
//@property (nonatomic, assign) BOOL recommendIncludeFee;
@property (nonatomic, strong) NSMutableArray <Tx *>* txs;

//@property (nonatomic, strong) Wallet * wallet;
@end


/*
 "hash":"394202024b2b7c63a1fa0b88d3a30fc5250b4e44ebc381ce1965eff36ffe2500",
 "ver":1,
 "vin_sz":1,
 "vout_sz":2,
 "size":225,
 "weight":900,
 "fee":7910,
 "relayed_by":"0.0.0.0",
 "lock_time":0,
 "tx_index":395090772,
 "double_spend":false,
 "result":-47910,
 "balance":2090,
 "time":1544059045,
 "block_height":552710,
 "block_index":1735263,
 */
@interface Tx : NSObject
@property (nonatomic, assign) TranResultSelectType selectType;
@property (nonatomic, strong) NSString * hashs;
@property (nonatomic, assign) NSInteger ver;
@property (nonatomic, assign) NSInteger vin_sz;
@property (nonatomic, assign) NSInteger vout_sz;
@property (nonatomic, assign) NSInteger size;
@property (nonatomic, assign) NSInteger weight;
@property (nonatomic, assign) NSInteger fee;
@property (nonatomic, strong) NSString * relayed_by;
@property (nonatomic, assign) NSInteger lock_time;
@property (nonatomic, assign) NSInteger tx_index;
@property (nonatomic, assign) BOOL double_spend;
@property (nonatomic, assign) NSInteger result;
@property (nonatomic, assign) NSInteger balance;
@property (nonatomic, assign) NSInteger time;
@property (nonatomic, assign) NSInteger block_height;
@property (nonatomic, assign) NSInteger block_index;
@property (nonatomic, strong) NSArray <Input *>* inputs;
@property (nonatomic, strong) NSArray <Output *>* outputs;
@end

/*
 "prev_out":Object{...},
 "sequence":4294967295,
"script":"473044022023a463c4cece3734261ea1a2cbfff52932631cbf05defebabad429d62254e790022001d7d823d074ebfa4ca06751f12d76174088bf610c9ac4f24705562c2802e876812102a6533f20852db9cd8eb34cd8387aa7a2bca88c9d78c828dacc274a4d7a818cea",
 "witness":""
 */

@interface Input : NSObject
@property (nonatomic, strong) PrevOut * prev_out;
@property (nonatomic, strong) NSString * script;
@property (nonatomic, assign) NSInteger sequence;
@property (nonatomic, strong) NSString * witness;
@end


/*
 "value":40000,
 "tx_index":395090772,
 "n":0,
 "spent":false,
 "script":"76a914939e9bf4929611da68d8c4886cb879e06997d26188ac",
 "type":0,
 "addr":"1ETYLZTGJj2tU9FqfD29XAfKwbgW2skPYf"
 */
@interface Output : NSObject
@property (nonatomic, strong) NSString * addr;
@property (nonatomic, assign) NSInteger n;
@property (nonatomic, strong) NSString * script;
@property (nonatomic, assign) BOOL spent;
@property (nonatomic, assign) NSInteger tx_index;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger value;
@end

/*
 "value":50000,
 "tx_index":394901139,
 "n":0,
 "spent":true,
 "spending_outpoints":[
 {
 "tx_index":395090772,
 "n":0
 }
 ],
 "script":"76a914212611c0de2c3e8ea73e798a42443fc4aa919c1e88ac",
 "type":0,
 "addr":"142GuSEsHohfSu9DXTZn8thnJd8GNXV4o5"
 */
@interface PrevOut : NSObject
@property (nonatomic, strong) NSString * addr;
@property (nonatomic, assign) NSInteger n;
@property (nonatomic, strong) NSString * script;
@property (nonatomic, strong) NSArray <SpendingOutpoint *>* spending_outpoints;
@property (nonatomic, assign) BOOL spent;
@property (nonatomic, assign) NSInteger tx_index;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger value;
@end

@interface SpendingOutpoint : NSObject
@property (nonatomic, assign) NSInteger n;
@property (nonatomic, assign) NSInteger tx_index;
@end

//@interface Wallet : NSObject
//@property (nonatomic, assign) NSInteger finalBalance;
//@property (nonatomic, assign) NSInteger nTx;
//@property (nonatomic, assign) NSInteger nTxFiltered;
//@property (nonatomic, assign) NSInteger totalReceived;
//@property (nonatomic, assign) NSInteger totalSent;
//@end

//@interface Info : NSObject
//
//@property (nonatomic, assign) CGFloat conversion;
//@property (nonatomic, strong) LatestBlock * latestBlock;
//@property (nonatomic, assign) NSInteger nconnected;
//@property (nonatomic, strong) SymbolBtc * symbolBtc;
//@property (nonatomic, strong) SymbolBtc * symbolLocal;
//@end

//@interface SymbolBtc : NSObject
//
//@property (nonatomic, strong) NSString * code;
//@property (nonatomic, assign) CGFloat conversion;
//@property (nonatomic, assign) BOOL local;
//@property (nonatomic, strong) NSString * name;
//@property (nonatomic, strong) NSString * symbol;
//@property (nonatomic, assign) BOOL symbolAppearsAfter;
//@end

//@interface LatestBlock : NSObject
//
//@property (nonatomic, assign) NSInteger blockIndex;
//@property (nonatomic, strong) NSString * hash;
//@property (nonatomic, assign) NSInteger height;
//@property (nonatomic, assign) NSInteger time;
//@end

//@interface Addresse : NSObject
//
//@property (nonatomic, assign) NSInteger accountIndex;
//@property (nonatomic, strong) NSString * address;
//@property (nonatomic, assign) NSInteger changeIndex;
//@property (nonatomic, assign) NSInteger finalBalance;
//@property (nonatomic, assign) NSInteger nTx;
//@property (nonatomic, assign) NSInteger totalReceived;
//@property (nonatomic, assign) NSInteger totalSent;
//@end
NS_ASSUME_NONNULL_END
