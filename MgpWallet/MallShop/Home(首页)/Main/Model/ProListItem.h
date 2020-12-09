//
//  ProListItem.h
//  TaiYiToken
//
//  Created by mac on 2020/9/8.
//  Copyright © 2020 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PayConfigs :NSObject

@property (nonatomic , assign) NSInteger              payId;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , assign) BOOL              isDel;
@property (nonatomic , copy) NSString              * createTime;
@property (nonatomic , copy) NSString              * pic;

@end

@interface ProListItem :NSObject
@property (nonatomic , assign) NSInteger              merId;
@property (nonatomic , copy) NSString              * image;
@property (nonatomic , copy) NSString              * storeName;
@property (nonatomic , copy) NSString              * storeUnit;
@property (nonatomic , copy) NSString              * storeInfo;
@property (nonatomic , copy) NSString              * storeType;
@property (nonatomic , assign) NSInteger              cateId;
@property (nonatomic , assign) CGFloat              price;
@property (nonatomic , assign) NSInteger              postage;
@property (nonatomic , assign) NSInteger              sales;
@property (nonatomic , assign) NSInteger              stock;
@property (nonatomic , assign) BOOL              isShow;
@property (nonatomic , assign) BOOL              isHot;
@property (nonatomic , assign) BOOL              isNew;
@property (nonatomic , assign) BOOL              isPostage;
@property (nonatomic , assign) BOOL              isDel;
@property (nonatomic , assign) CGFloat              givePro;
@property (nonatomic , assign) CGFloat              bonusPro;
@property (nonatomic , assign) CGFloat              buyerPro;
@property (nonatomic , assign) NSInteger              browse;
@property (nonatomic , copy) NSString              * upTime;
@property (nonatomic , copy) NSString              * addTime;
@property (nonatomic , assign) NSInteger              countryNum;
@property (nonatomic , assign) NSInteger              auditStatus;
@property (nonatomic , copy) NSString              * auditTime;
@property (nonatomic , copy) NSString              * auditMsg;
@property (nonatomic , copy) NSString              * countryName;
@property (nonatomic , assign) NSInteger              proID;
@property (nonatomic , copy) NSString              * serviceCharge;


@property (nonatomic , copy) NSArray              * image_url;
@property (nonatomic , strong) NSArray              * sliderImages;

@property (nonatomic , strong) NSArray <PayConfigs *>              * payConfigs;
@property (nonatomic , copy) NSString              * usdtAddr;


@end

NS_ASSUME_NONNULL_END
