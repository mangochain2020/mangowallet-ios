//
//  BusinessModel.h
//  TaiYiToken
//
//  Created by Frued on 2018/10/16.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BusinessModel : NSObject
@property (nonatomic, assign) CGFloat symbolRate;
@property (nonatomic, strong) NSArray <NSArray *>* buyInfo;
@property (nonatomic, strong) NSArray <NSArray *>* saleInfo;
@end



NS_ASSUME_NONNULL_END
