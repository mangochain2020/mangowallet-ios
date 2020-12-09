//
//  HuobiBalanceCollectModel.h
//  TaiYiToken
//
//  Created by 张元一 on 2019/3/20.
//  Copyright © 2019 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HuobiBalanceCollectModel : NSObject
@property (nonatomic, copy) NSString * trade;
@property (nonatomic, copy) NSString * frozen;
@property (nonatomic, copy) NSString * chyprice;
@property (nonatomic, copy) NSString * chybalance;
@property (nonatomic, copy) NSString * symbol;
@end

NS_ASSUME_NONNULL_END
