//
//  USDTTxDetailModel.h
//  TaiYiToken
//
//  Created by 张元一 on 2019/4/28.
//  Copyright © 2019 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/*{
 "amount": "6167.00000000",
 "block": 511660,
 "blockhash": "0000000000000000003f37e72e599fbdaa14396a2e9251e493f0d7d15b1fd915",
 "blocktime": 1520009505,
 "confirmations": 7499,
 "divisible": true,
 "fee": "0.00009124",
 "ismine": false,
 "positioninblock": 825,
 "propertyid": 31,
 "propertyname": "TetherUS",
 "referenceaddress": "3GyeFJmQynJWd8DeACm4cdEnZcckAtrfcN",
 "sendingaddress": "3D4r9ERiM3HSc4eC4EhcT31tXoSV96HsPg",
 "txid": "e0e3749f4855c341b5139cdcbb4c6b492fcc09c49021b8b15462872b4ba69d1b",
 "type": "Simple Send",
 "type_int": 0,
 "valid": true,
 "version": 0
 }*/
@interface USDTTxDetailModel : NSObject
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
@property (nonatomic, strong) NSString * referenceaddress;
@property (nonatomic, strong) NSString * sendingaddress;
@property (nonatomic, strong) NSString * txid;
@property (nonatomic, strong) NSString * type;
@property (nonatomic, assign) NSInteger type_int;
@property (nonatomic, assign) BOOL valid;
@property (nonatomic, assign) NSInteger version;
@end

NS_ASSUME_NONNULL_END
