//
//  HuobiNetBaseModel.h
//  TaiYiToken
//
//  Created by 张元一 on 2019/3/11.
//  Copyright © 2019 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HuobiNetBaseModel : NSObject
@property (nonatomic, assign) NSInteger resultCode;
@property (nonatomic, copy) NSString * resultMsg;
@end

NS_ASSUME_NONNULL_END
