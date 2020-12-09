//
//  SymbolInfoModel.h
//  TaiYiToken
//
//  Created by admin on 2018/10/12.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NewSymbolInfo,NewklineDataModel;
@interface SymbolInfoModel : NSObject
@property (nonatomic, strong) NewSymbolInfo *symbolInfo;
@property (nonatomic, strong) NSArray<NewklineDataModel *> *kLineDataArray;
@end
@interface NewSymbolInfo : NSObject
@property (nonatomic, strong) NSString * symbol;
@property (nonatomic, strong) NSString * symbolName;
@property (nonatomic, assign) CGFloat  openPrice;
@property (nonatomic, assign) CGFloat  symbolClosePrice;
@property (nonatomic, assign) CGFloat  closePrice;
@property (nonatomic, assign) CGFloat  highPrice;
@property (nonatomic, assign) CGFloat  lowPrice;
@property (nonatomic, assign) CGFloat  amount;
@property (nonatomic, assign) NSInteger  count;
@property (nonatomic, assign) CGFloat  vol;
@property (nonatomic, strong) NSString * volStr;
@property (nonatomic, assign) CGFloat   priceChange;
@property (nonatomic, strong) NSString * marketValueStr;
@property (nonatomic, assign) CGFloat priceChangeRate;
@end
@interface NewklineDataModel : NSObject
@property (nonatomic, assign) CGFloat ID;
@property (nonatomic, assign) CGFloat openPrice;
@property (nonatomic, assign) CGFloat closePrice;
@property (nonatomic, assign) CGFloat lowPrice;
@property (nonatomic, assign) CGFloat highPrice;
@property (nonatomic, assign) CGFloat amount;
@property (nonatomic, assign) CGFloat vol;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) CGFloat fiveData;
@property (nonatomic, assign) CGFloat tenData;
@property (nonatomic, assign) CGFloat thirtyData;
@end
