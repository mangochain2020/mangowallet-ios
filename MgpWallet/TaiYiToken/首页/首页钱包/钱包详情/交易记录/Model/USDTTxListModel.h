//
//  USDTTxListModel.h
//  TaiYiToken
//
//  Created by 张元一 on 2019/4/28.
//  Copyright © 2019 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/*
 {
 "address": "1EXoDusjGwvnjZUyKkxZ4UHEf77z6A5S4P",
 "pages": 3,
 "transactions": [
 {
 "amount": "0.00000100",
 "block": 342733,
 "blockhash": "000000000000000014a6858e7da93606ffe624331a2f295732c8c9499ffa1025",
 "blocktime": 1423503818,
 "confirmations": 176424,
 "divisible": true,
 "fee": "0.00001000",
 "ismine": false,
 "positioninblock": 1569,
 "propertyid": 1,
 "propertyname": "Omni",
 "sendingaddress": "1F9jCeixNbK6GEkdQFq1ejkbJjAGwVVVqG",
 "txid": "318fb016144f3dadb16acf39cd7e00089b808418f1c4b343926af55882824966",
 "type": "Send To Owners",
 "type_int": 3,
 "valid": true,
 "version": 0
 },
 {
 "additional records": "..."
 }
 ]
 }*/

@class USDTTxListData;
@interface USDTTxListModel : NSObject
@property (nonatomic, strong) NSString * address;
@property (nonatomic, assign) NSInteger pages;
@property (nonatomic, strong) NSArray <USDTTxListData *>* transactions;
@end


@interface USDTTxListData : NSObject
@property (nonatomic, strong) NSString * additionalrecords;
@property (nonatomic, strong) NSString * amount;
@property (nonatomic, assign) NSInteger block;
@property (nonatomic, strong) NSString * blockhash;
@property (nonatomic, assign) NSInteger blocktime;
@property (nonatomic, assign) NSInteger confirmations;
@property (nonatomic, assign) BOOL divisible;
@property (nonatomic, strong) NSString * fee;
@property (nonatomic, assign) BOOL ismine;
@property (nonatomic, assign) NSInteger positioninblock;
@property (nonatomic, assign) NSInteger propertyid;
@property (nonatomic, strong) NSString * propertyname;
@property (nonatomic, strong) NSString * sendingaddress;
@property (nonatomic, strong) NSString * txid;
@property (nonatomic, strong) NSString * type;
@property (nonatomic, assign) NSInteger type_int;
@property (nonatomic, assign) BOOL valid;
@property (nonatomic, assign) NSInteger version;

@end

NS_ASSUME_NONNULL_END
