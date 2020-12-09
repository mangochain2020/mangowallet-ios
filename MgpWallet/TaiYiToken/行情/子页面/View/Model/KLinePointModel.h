//
//  KLinePointModel.h
//  TaiYiToken
//
//  Created by Frued on 2018/8/16.
//  Copyright © 2018年 Frued. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CoinBaseInfo,SymbolInfo,klineData;

@interface KLinePointModel : NSObject<NSCoding>
/*
 {  "symbolInfo":
           {"symbol":"EOS/ETH","symbolName":null,"openPrice":0.01877499,"rmbOpenPrice":36.67,"dollarOpenPrice":5.35,"closePrice":0.01879188,"rmbClosePrice":36.70,"dollarClosePrice":5.36,"highPrice":0.018995,"rmbHighPrice":37.10,"dollarHighPrice":5.41,"lowPrice":0.018628,"rmbLowPrice":36.38,"dollarLowPrice":5.31,"amount":2524934.77,"count":12233,"vol":47014.455058591055,"rmbVol":91814016.67,"dollarVol":13401940.56,"priceChange":0.09},
 
     "coinBaseInfo":
           {"summary":"EOS (Enterprise Operation System)是由 Block.one公司主导开发的一种全新的基于区块链智能合约平台，旨在为高性能分布式应用提供底层区块链平台服务。EOS 项目的目标是实现一个类似操作系统的支撑分布式应用程序的区块链架构。该架构可以提供账户，身份认证，数据库，异步通信以及可在数以万计的 CPU/GPU群集上进行程序调度和并行运算。EOS最终可以支持每秒执行数百万个交易，同时普通用户执行智能合约无需支付使用费用。",
             "publishTime":"2017/7/2",
             "circulateVolume":"5.36亿",
             "consensusMechanism":"",
             "projectType":"",
             "crowdfundingPrice":"--",
             "fullName":"Enterprise Operation System（EOS）",
             "projectTeam":"",
             "projectValuation":"",
             "whitePaper":"<a href=\"https://github.com/EOSIO/Documentation/blob/master/zh-CN/TechnicalWhitePaper.md\" target=\"_blank\">https://github.com/EOSIO/Documentation/blob/master/zh-CN/TechnicalWhitePaper.md</a>",
             "financingHistory":"",
             "technicalCharacteristics":"",
             "blockQuery":"<a href=\"https://etherscan.io/token/EOS\" target=\"_blank\">https://etherscan.io/token/EOS</a>",
             "projectConsultant":"",
             "officialWebsite":"<a href=\"https://eos.io/\" target=\"_blank\">https://eos.io/</a>",
             "projectPosition":"",
             "application":"","projectProgress":"","publishVolume":"10亿","icoprogress":""
         },
    "rmbMarketValue":"36720.29亿",
    "klineData":[{"id":"1535422200","open":0.018790380000000000,"rmbOpenPrice":36.70,"dollarOpenPrice":5.36,"close":0.01879188,"rmbClosePrice":36.70,"dollarClosePrice":5.36,"low":0.018790380000000000,"rmbLowPrice":36.70,"dollarLowPrice":5.36,"high":0.018795720000000000,"rmbHighPrice":36.71,"dollarHighPrice":5.36,"amount":8.770000000000000000,"rmbAmount":17126.84,"dollarAmount":2499.98,"vol":0.164836339400000000000000000000000000,"rmbVol":321.91,"dollarVol":46.99,"count":6,"fiveData":0,"rmbFiveData":0.00,"dollarFiveData":0.00,"fifteenData":0,"rmbFifteenData":0.00,"dollarFifteenData":0.00,"thirtyData":0,"rmbThirtyData":0.00,"dollarThirtyData":0.00}]
 }
 */

@property (nonatomic, strong) CoinBaseInfo * coinBaseInfo;
@property (nonatomic, strong) NSMutableArray <klineData *> * klineData;
@property (nonatomic, copy) NSString * rmbMarketValue;
@property (nonatomic, strong) NSString * dollarMarketValue;
@property (nonatomic, strong) SymbolInfo * symbolInfo;
@end

/*
 CoinBaseInfo
 */
@interface CoinBaseInfo : NSObject
//简介
@property (nonatomic, copy) NSString * summary;
//发行时间
@property (nonatomic, copy) NSString * publishTime;
//流通总量
@property (nonatomic, copy) NSString * circulateVolume;
@property (nonatomic, copy) NSString * consensusMechanism;
@property (nonatomic, copy) NSString * projectType;
//众筹价格
@property (nonatomic, copy) NSString * crowdfundingPrice;
//全名
@property (nonatomic, copy) NSString * fullName;
@property (nonatomic, copy) NSString * projectTeam;
@property (nonatomic, copy) NSString * projectValuation;
//白皮书地址
@property (nonatomic, copy) NSString * whitePaper;
@property (nonatomic, copy) NSString * financingHistory;
@property (nonatomic, copy) NSString * technicalCharacteristics;
//区块查询
@property (nonatomic, copy) NSString * blockQuery;
@property (nonatomic, copy) NSString * projectConsultant;
//官网
@property (nonatomic, copy) NSString * officialWebsite;
@property (nonatomic, copy) NSString * projectPosition;
@property (nonatomic, copy) NSString * application;
@property (nonatomic, copy) NSString * projectProgress;
//发行总量
@property (nonatomic, copy) NSString * publishVolume;
@property (nonatomic, copy) NSString * icoprogress;
@end

/*
 klineData
 */
@interface klineData : NSObject
@property (nonatomic, copy) NSString * ID;
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
@property (nonatomic, assign) CGFloat rmbAmount;
@property (nonatomic, assign) CGFloat dollarAmount;
//成交额
@property (nonatomic, assign) CGFloat vol;
@property (nonatomic, assign) CGFloat rmbVol;
@property (nonatomic, assign) CGFloat dollarVol;
//成交笔数
@property (nonatomic, assign) NSInteger count;
//5点线
@property (nonatomic, assign) CGFloat fiveData;
@property (nonatomic, assign) CGFloat rmbFiveData;
@property (nonatomic, assign) CGFloat dollarFiveData;
//15点线
@property (nonatomic, assign) CGFloat fifteenData;
@property (nonatomic, assign) CGFloat rmbFifteenData;
@property (nonatomic, assign) CGFloat dollarFifteenData;
//30点线
@property (nonatomic, assign) CGFloat thirtyData;
@property (nonatomic, assign) CGFloat rmbThirtyData;
@property (nonatomic, assign) CGFloat dollarThirtyData;
@end


/*
 SymbolInfo
 */
@interface SymbolInfo : NSObject
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
