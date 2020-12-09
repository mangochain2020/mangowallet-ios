//
//  MarketProfitModel.h
//  TaiYiToken
//
//  Created by 张元一 on 2018/11/8.
//  Copyright © 2018 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MarketProfitModel : NSObject
@property (nonatomic, assign) CGFloat btcChangePrice;
@property (nonatomic, assign) CGFloat btcChangeRate;
@property (nonatomic, assign) CGFloat eosChangePrice;
@property (nonatomic, assign) CGFloat eosChangeRate;
@property (nonatomic, assign) CGFloat ethChangePrice;
@property (nonatomic, assign) CGFloat ethChangeRate;
@property (nonatomic, assign) CGFloat mgpChangePrice;
@property (nonatomic, assign) CGFloat mgpChangeRate;
@end

NS_ASSUME_NONNULL_END
