//
//  MarketTicketModel.h
//  TaiYiToken
//
//  Created by 张元一 on 2018/11/22.
//  Copyright © 2018 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MarketTicketModel : NSObject
@property (nonatomic, strong) NSString * coinChangeRate;
@property (nonatomic, strong) NSString * coinCode;
@property (nonatomic, strong) NSString * coinIconURL;
@property (nonatomic, strong) NSString * coinName;
@property (nonatomic, assign) CGFloat coinPrice;
@property (nonatomic, strong) NSString * marketValStr;
@property (nonatomic, strong) NSString * coinNum;
@property (nonatomic, assign) BOOL toBaseInfo;
@end

NS_ASSUME_NONNULL_END
