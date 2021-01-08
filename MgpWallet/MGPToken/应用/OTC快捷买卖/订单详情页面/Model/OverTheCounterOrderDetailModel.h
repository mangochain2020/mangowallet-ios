//
//  OverTheCounterOrderDetailModel.h
//  TaiYiToken
//
//  Created by mac on 2020/12/31.
//  Copyright © 2020 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 类目条目
 */
@interface CategoryDetailModel : NSObject

@property (nonatomic , assign)BOOL isTitle;

@property (nonatomic , copy)NSString *leftTitle;

@property (nonatomic , assign)BOOL isCopy;

@property (nonatomic , copy)NSString *rightTitle;

@end



/**
 银行卡支付方式
 */
@interface CardDetailModel : NSObject

@property (nonatomic , copy)NSString *cardName;
@property (nonatomic , copy)NSString *cardNameRightTitle;
@property (nonatomic , copy)NSString *cardIcon;
@property (nonatomic , copy)NSString *userNameL;
@property (nonatomic , copy)NSString *cardNumberL;
@property (nonatomic , copy)NSString *bankNameL;
@property (nonatomic , copy)NSString *accountOpeningBranchL;
@property (nonatomic , copy)NSString *describe;


@property (nonatomic , copy)NSString *userNameR;
@property (nonatomic , copy)NSString *cardNumberR;
@property (nonatomic , copy)NSString *bankNameR;
@property (nonatomic , copy)NSString *accountOpeningBranchR;


@end



NS_ASSUME_NONNULL_BEGIN

@interface OverTheCounterOrderDetailModel : NSObject

@property (nonatomic , strong) NSMutableArray             *categoryArrays;

@property (nonatomic , strong) CardDetailModel             *cardDetailModel;

@end

NS_ASSUME_NONNULL_END
