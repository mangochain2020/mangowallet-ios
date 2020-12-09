//
//  CoinBaseInfoModel.h
//  TaiYiToken
//
//  Created by 张元一 on 2018/11/22.
//  Copyright © 2018 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class KlineDataModel,ExchangeItem;
@interface CoinBaseInfoModel : NSObject
@property (nonatomic, assign) CGFloat coinBTCPrice;
@property (nonatomic, assign) CGFloat coinChangePrice;
@property (nonatomic, strong) NSString * coinChangeRate;
@property (nonatomic, strong) NSString * coinCode;
@property (nonatomic, assign) CGFloat coinDollarPrice;
@property (nonatomic, assign) CGFloat coinETHPrice;
@property (nonatomic, strong) NSString * coinLogo;
@property (nonatomic, strong) NSString * coinName;
@property (nonatomic, assign) CGFloat coinRmbPrice;
@property (nonatomic, assign) NSInteger defaultExchangeId;
@property (nonatomic, strong) NSString * defaultSymbol;
@property (nonatomic, strong) NSMutableArray <ExchangeItem *> *exchangeItems;
@property (nonatomic, assign) CGFloat highPrice;
@property (nonatomic, strong) NSMutableArray <KlineDataModel *> *klineData;
@property (nonatomic, assign) CGFloat lowPrice;
@property (nonatomic, assign) CGFloat rmbVol;
@property (nonatomic, strong) NSString * volStr;
@property (nonatomic, assign) NSInteger sortNum;
@property (nonatomic, strong) NSString * marketValue;
@end

@interface KlineDataModel : NSObject

@property (nonatomic, assign) CGFloat amount;
@property (nonatomic, assign) CGFloat closePrice;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) CGFloat fiveData;
@property (nonatomic, assign) CGFloat highPrice;
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, assign) CGFloat lowPrice;
@property (nonatomic, assign) CGFloat openPrice;
@property (nonatomic, assign) CGFloat tenData;
@property (nonatomic, assign) CGFloat thirtyData;
@property (nonatomic, assign) NSInteger vol;
@end

@interface ExchangeItem : NSObject
@property (nonatomic, assign) NSInteger exchangeId;
@property (nonatomic, strong) NSString * exchangeName;
@end
NS_ASSUME_NONNULL_END
