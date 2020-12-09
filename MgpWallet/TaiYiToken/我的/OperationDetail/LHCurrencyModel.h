//
//  LHCurrencyModel.h
//  TaiYiToken
//
//  Created by mac on 2020/8/26.
//  Copyright © 2020 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LHCurrencyModel : NSObject<NSCoding>

@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * symbol;
@property (nonatomic, copy) NSString * price;
@property (nonatomic, copy) NSString * symbolName;
@property (nonatomic, assign) NSInteger sort;

-(void)vailidateCurrencyModel;


@end

NS_ASSUME_NONNULL_END
