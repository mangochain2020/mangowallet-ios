//
//  DCMyCenterModel.h
//  TaiYiToken
//
//  Created by mac on 2020/8/10.
//  Copyright © 2020 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppUser :NSObject

@property (nonatomic , assign) NSInteger              id;
@property (nonatomic , assign) NSInteger              userId;
@property (nonatomic , copy) NSString              * userName;
@property (nonatomic , copy) NSString              * identityCard;
@property (nonatomic , copy) NSString              * socialCode;
@property (nonatomic , copy) NSString              * businessLicense;
@property (nonatomic , copy) NSString              * identityCardPhoto;
@property (nonatomic , copy) NSString              * handCardPhoto;
@property (nonatomic , assign) NSInteger              status;
@property (nonatomic , copy) NSString              * createTime;


@end


@interface Shop :NSObject

@property (nonatomic , assign) NSInteger              lifeID;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , assign) NSInteger              userId;
@property (nonatomic , copy) NSString              * homeImg;
@property (nonatomic , copy) NSString              * detailImg;
@property (nonatomic , copy) NSString              * bankTime;
@property (nonatomic , copy) NSString              * createTime;
@property (nonatomic , assign) NSInteger              isShow;
@property (nonatomic , assign) NSInteger              isDel;
@property (nonatomic , assign) NSInteger              status;
@property (nonatomic , assign) NSInteger              isHot;
@property (nonatomic , assign) NSInteger              country;
@property (nonatomic , copy) NSString              * storeAddress;
@property (nonatomic , assign) NSInteger              longitude;
@property (nonatomic , assign) NSInteger              latitude;
@property (nonatomic , assign) CGFloat              storePro;
@property (nonatomic , assign) CGFloat              buyerPro;
@property (nonatomic , assign) CGFloat              rewardPro;
@property (nonatomic , assign) NSInteger              categoryId;
@property (nonatomic , strong) NSArray <NSString *>              * imgs;
@property (nonatomic , strong) NSArray <NSString *>              * detailImgs;
@property (nonatomic , copy) NSString              * failMsg;



@end

@interface Top :NSObject
@property (nonatomic , assign) NSInteger              proNum;
@property (nonatomic , assign) NSInteger              isBindUsdt;
@property (nonatomic , assign) NSInteger              orderIncome;
@property (nonatomic , assign) NSInteger              totalMoney;
@property (nonatomic , assign) NSInteger              orderNum;

@end

@interface Orders :NSObject
@property (nonatomic , assign) NSInteger              all;
@property (nonatomic , assign) NSInteger              enter;
@property (nonatomic , assign) NSInteger              goods;
@property (nonatomic , assign) NSInteger              prepare;
@property (nonatomic , assign) NSInteger              refund;
@property (nonatomic , assign) NSInteger              prepay;


@end

@interface Down :NSObject
@property (nonatomic , assign) NSInteger              income;
@property (nonatomic , assign) NSInteger              waitIncome;
@property (nonatomic , assign) NSInteger              refundIncome;

@end

@interface DCMyCenterModel : NSObject

@property (nonatomic , strong) Top              * top;
@property (nonatomic , strong) AppUser              * appUser;
@property (nonatomic , strong) Shop              * shop;
@property (nonatomic , strong) Orders              * orders;
@property (nonatomic , strong) Down              * down;


@end

NS_ASSUME_NONNULL_END
