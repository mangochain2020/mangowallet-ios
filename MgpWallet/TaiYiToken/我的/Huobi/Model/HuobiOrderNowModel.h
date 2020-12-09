//
//  HuobiOrderNowModel.h
//  TaiYiToken
//
//  Created by 张元一 on 2019/3/11.
//  Copyright © 2019 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class HuobiOrderNowArrObj,HuobiOrderNowData;
@interface HuobiOrderNowModel : HuobiNetBaseModel
@property (nonatomic, strong) HuobiOrderNowData * data;
@end

@interface HuobiOrderNowData : NSObject
@property (nonatomic, strong) NSArray <HuobiOrderNowArrObj *>* data;
@property (nonatomic, copy) NSString * errCode;
@property (nonatomic, copy) NSString * errMsg;
@property (nonatomic, copy) NSString * status;
@end

@interface HuobiOrderNowArrObj : NSObject
@property (nonatomic, copy) NSString * accountid;
@property (nonatomic, copy) NSString * amount;
@property (nonatomic, copy) NSString * batch;
@property (nonatomic, copy) NSString * canceledat;
@property (nonatomic, copy) NSString * createdat;
@property (nonatomic, copy) NSString * exchange;
@property (nonatomic, copy) NSString * fieldamount;
@property (nonatomic, copy) NSString * fieldcashamount;
@property (nonatomic, copy) NSString * fieldfees;
@property (nonatomic, copy) NSString * finishedat;
@property (nonatomic, copy) NSString * ID;
@property (nonatomic, copy) NSString * price;
@property (nonatomic, copy) NSString * source;
@property (nonatomic, copy) NSString * state;
@property (nonatomic, copy) NSString * symbol;
@property (nonatomic, copy) NSString * type;
@property (nonatomic, copy) NSString *  userid;
@end

NS_ASSUME_NONNULL_END
