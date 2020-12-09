//
//  InfoBaseModel.h
//  TaiYiToken
//
//  Created by 张元一 on 2019/4/1.
//  Copyright © 2019 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface InfoBaseModel : NSObject
@property (nonatomic, strong) NSObject * data;
@property (nonatomic, assign) NSInteger resultCode;
@property (nonatomic, strong) NSString * resultMsg;
@end

NS_ASSUME_NONNULL_END
