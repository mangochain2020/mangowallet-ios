//
//  ListSortModel.h
//  TaiYiToken
//
//  Created by Frued on 2018/10/17.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ListSortModel : NSObject
@property (nonatomic, assign) CGFloat amount;
@property (nonatomic, assign) CGFloat openPrice;
@property (nonatomic, assign) CGFloat changePrice;
@property (nonatomic, assign) CGFloat changePriceRate;
@property (nonatomic, assign) CGFloat closePrice;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) CGFloat netInflow;
@property (nonatomic, assign) NSInteger vol;
@property (nonatomic, strong) NSString * netInflowStr;
@property (nonatomic, strong) NSString * symbol;
@property (nonatomic, strong) NSString * symbolName;

@end

NS_ASSUME_NONNULL_END
