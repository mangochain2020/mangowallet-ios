//
//  HuobibalanceModel.h
//  TaiYiToken
//
//  Created by 张元一 on 2019/3/11.
//  Copyright © 2019 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class HuobiBalanceListObj,HuobiBalanceDetailData,HuobiBalanceData;
@interface HuobiBalanceModel : HuobiNetBaseModel
@property (nonatomic, strong) HuobiBalanceData * data;
@end

@interface HuobiBalanceData : NSObject
@property (nonatomic, strong) HuobiBalanceDetailData * data;
@property (nonatomic, copy) NSString * errCode;
@property (nonatomic, copy) NSString * errMsg;
@property (nonatomic, copy) NSString * status;
@end

@interface HuobiBalanceDetailData : NSObject
@property (nonatomic, copy) NSString * ID;
@property (nonatomic, strong) NSArray <HuobiBalanceListObj *>* list;
@property (nonatomic, copy) NSString * state;
@property (nonatomic, copy) NSString * type;
@property (nonatomic, copy) NSString * userid;
@end

@interface HuobiBalanceListObj : NSObject
@property (nonatomic, copy) NSString * balance;
@property (nonatomic, copy) NSString * currency;
@property (nonatomic, copy) NSString * type;
@end
NS_ASSUME_NONNULL_END
