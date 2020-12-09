//
//  HuobiSymbolsModel.h
//  TaiYiToken
//
//  Created by 张元一 on 2019/3/11.
//  Copyright © 2019 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class HuobiSymbolsDetail,HuobiSymbolsData;
@interface HuobiSymbolsModel : HuobiNetBaseModel
@property (nonatomic, strong) HuobiSymbolsData * data;
@end

@interface HuobiSymbolsData : NSObject
@property (nonatomic, strong) NSArray <HuobiSymbolsDetail *>* btc;
@property (nonatomic, strong) NSArray <HuobiSymbolsDetail *>* eth;
@property (nonatomic, strong) NSArray <HuobiSymbolsDetail *>* ht;
//@property (nonatomic, strong) NSArray <HuobiSymbolsDetail *>* husd;
@property (nonatomic, strong) NSArray <HuobiSymbolsDetail *>* usdt;
@end


@interface HuobiSymbolsDetail : NSObject
@property (nonatomic, strong) NSDecimalNumber * close;
@property (nonatomic, assign) NSInteger precision;
@property (nonatomic, copy) NSString * symbol;
@end



NS_ASSUME_NONNULL_END
