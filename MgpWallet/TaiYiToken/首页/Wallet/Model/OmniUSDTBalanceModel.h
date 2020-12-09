//
//  OmniUSDTBalanceModel.h
//  TaiYiToken
//
//  Created by 张元一 on 2019/4/24.
//  Copyright © 2019 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class OmniUSDTBalanceData;
@interface OmniUSDTBalanceModel : NSObject
@property (nonatomic, strong) NSArray <OmniUSDTBalanceData *>* balance;
@end
/*
 {
 "divisible": true,
 "frozen": "0",
 "id": "1",
 "pendingneg": "0",
 "pendingpos": "0",
 "reserved": "0",
 "symbol": "OMNI",
 "value": "3054147959984"
 },
 {
 "divisible": true,
 "error": false,
 "id": 0,
 "pendingneg": "0",
 "pendingpos": "0",
 "symbol": "BTC",
 "value": "214236735"
 }
 */

@interface OmniUSDTBalanceData : NSObject
@property (nonatomic, assign) BOOL divisible;
@property (nonatomic, assign) BOOL error;
@property (nonatomic, strong) NSString * frozen;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString * pendingneg;
@property (nonatomic, strong) NSString * pendingpos;
@property (nonatomic, strong) NSString * reserved;
@property (nonatomic, strong) NSString * symbol;
@property (nonatomic, strong) NSString * value;
@end

NS_ASSUME_NONNULL_END
