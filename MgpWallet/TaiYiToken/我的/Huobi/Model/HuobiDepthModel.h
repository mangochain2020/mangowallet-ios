//
//  HuobiDepthModel.h
//  TaiYiToken
//
//  Created by 张元一 on 2019/3/11.
//  Copyright © 2019 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class HuobiDepthTick,HuobiDepthData;
@interface HuobiDepthModel : HuobiNetBaseModel
@property (nonatomic, strong) HuobiDepthData * data;
@end

@interface HuobiDepthData : NSObject
@property (nonatomic, copy) NSString * ch;
@property (nonatomic, copy) NSString * errCode;
@property (nonatomic, copy) NSString * errMsg;
@property (nonatomic, copy) NSString * status;
@property (nonatomic, strong) HuobiDepthTick * tick;
@property (nonatomic, copy) NSString * ts;
@end

@interface HuobiDepthTick : NSObject
@property (nonatomic, strong) NSArray <NSArray *>* asks;//买
@property (nonatomic, strong) NSArray <NSArray *>* bids;//卖
@property (nonatomic, copy) NSString * ID;
@property (nonatomic, copy) NSString * ts;
@end


NS_ASSUME_NONNULL_END
