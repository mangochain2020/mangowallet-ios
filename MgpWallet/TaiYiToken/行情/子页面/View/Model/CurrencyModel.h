//
//  CurrencyModel.h
//  TaiYiToken
//
//  Created by Frued on 2018/8/15.
//  Copyright © 2018年 Frued. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SymbolModel;
@interface CurrencyModel : NSObject<NSCoding>
@property (nonatomic, strong) NSMutableArray <SymbolModel *>* btcMarket;
@property (nonatomic, strong) NSMutableArray <SymbolModel *>* ethMarket;
@property (nonatomic, strong) NSMutableArray <SymbolModel *>* htMarket;
@property (nonatomic, strong) NSMutableArray <SymbolModel *>* myMarket;
@property (nonatomic, strong) NSMutableArray <SymbolModel *>* usdtMarket;
@end

@interface SymbolModel : NSObject
/*
 {"symbol":"IOTA/USDT","symbolName":"埃欧塔","openPrice":0.6034,"rmbOpenPrice":null,"dollarOpenPrice":null,"closePrice":0.6709,"rmbClosePrice":4.60,"dollarClosePrice":0.67,"highPrice":0.6845,"rmbHighPrice":null,"dollarHighPrice":null,"lowPrice":0.5917,"rmbLowPrice":null,"dollarLowPrice":null,"amount":3281414.70,"count":0,"vol":null,"rmbVol":null,"dollarVol":null,"priceChange":11.19}
 */
//交易对
@property (nonatomic, copy) NSString * symbol;
//交易对名称
@property (nonatomic, copy) NSString * symbolName;
//开盘价
@property (nonatomic, assign) CGFloat openPrice;
@property (nonatomic, assign) CGFloat rmbOpenPrice;
@property (nonatomic, assign) CGFloat dollarOpenPrice;
//收盘价
@property (nonatomic, assign) CGFloat closePrice;
@property (nonatomic, assign) CGFloat rmbClosePrice;
@property (nonatomic, assign) CGFloat dollarClosePrice;
//最高价
@property (nonatomic, assign) CGFloat highPrice;
@property (nonatomic, assign) CGFloat rmbHighPrice;
@property (nonatomic, assign) CGFloat dollarHighPrice;
//最低价
@property (nonatomic, assign) CGFloat lowPrice;
@property (nonatomic, assign) CGFloat rmbLowPrice;
@property (nonatomic, assign) CGFloat dollarLowPrice;
//成交量
@property (nonatomic, assign) CGFloat amount;
//成交笔数
@property (nonatomic, assign) NSInteger count;
//成交额
@property (nonatomic, assign) CGFloat vol;
@property (nonatomic, assign) CGFloat rmbVol;
@property (nonatomic, assign) CGFloat dollarVol;
//涨跌幅
@property (nonatomic, assign) CGFloat priceChange;

@end
