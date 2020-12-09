//
//  BTCBalanceModel.h
//  TaiYiToken
//
//  Created by admin on 2018/9/14.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTCBalanceModel : NSObject
@property (nonatomic, strong) NSString * addrStr;
@property (nonatomic, assign) CGFloat balance;
@property (nonatomic, assign) NSInteger balanceSat;
@property (nonatomic, assign) CGFloat totalReceived;
@property (nonatomic, assign) NSInteger totalReceivedSat;
@property (nonatomic, assign) NSInteger totalSent;
@property (nonatomic, assign) NSInteger totalSentSat;
@property (nonatomic, assign) NSInteger txApperances;
@property (nonatomic, assign) CGFloat unconfirmedBalance;
@property (nonatomic, assign) NSInteger unconfirmedBalanceSat;
@property (nonatomic, assign) NSInteger unconfirmedTxApperances;
@end
