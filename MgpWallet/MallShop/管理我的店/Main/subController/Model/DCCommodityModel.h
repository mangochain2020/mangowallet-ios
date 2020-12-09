//
//  DCCommodityModel.h
//  TaiYiToken
//
//  Created by mac on 2020/8/7.
//  Copyright © 2020 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DCCommodityModel : NSObject

@property (nonatomic , assign) NSInteger              merId;
@property (nonatomic , copy) NSString              * image;
@property (nonatomic , copy) NSString              * storeName;
@property (nonatomic , copy) NSString              * storeUnit;
@property (nonatomic , copy) NSString              * storeInfo;
@property (nonatomic , copy) NSString              * storeType;
@property (nonatomic , copy) NSString              * keyword;
@property (nonatomic , assign) NSInteger              cateId;
@property (nonatomic , assign) NSInteger              price;
@property (nonatomic , assign) NSInteger              postage;
@property (nonatomic , assign) NSInteger              sales;
@property (nonatomic , assign) NSInteger              stock;
@property (nonatomic , assign) BOOL              isShow;
@property (nonatomic , assign) BOOL              isHot;
@property (nonatomic , assign) BOOL              isNew;
@property (nonatomic , assign) BOOL              isPostage;
@property (nonatomic , assign) BOOL              isDel;
@property (nonatomic , assign) NSInteger              givePro;
@property (nonatomic , assign) NSInteger              bonusPro;
@property (nonatomic , assign) NSInteger              buyerPro;
@property (nonatomic , assign) NSInteger              browse;
@property (nonatomic , copy) NSString              * upTime;
@property (nonatomic , copy) NSString              * addTime;
@property (nonatomic , assign) NSInteger              auditStatus;
@property (nonatomic , copy) NSString              * auditTime;
@property (nonatomic , copy) NSString              * auditMsg;
@property (nonatomic , assign) NSInteger              proID;
@property (nonatomic , strong) NSArray              * image_url;
@property (nonatomic , strong) NSArray              * sliderImages;


@end

NS_ASSUME_NONNULL_END
