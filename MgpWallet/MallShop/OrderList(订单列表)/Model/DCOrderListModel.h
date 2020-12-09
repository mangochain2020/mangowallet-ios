//
//  DCOrderListModel.h
//  TaiYiToken
//
//  Created by mac on 2020/8/6.
//  Copyright © 2020 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface Pro :NSObject
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

@end

@interface StoreUserDelivery :NSObject

@property (nonatomic , copy) NSString              * city;
@property (nonatomic , copy) NSString              * createTime;
@property (nonatomic , copy) NSString              * detailedAddress;
@property (nonatomic , copy) NSString              * mark;
@property (nonatomic , copy) NSString              * phone;
@property (nonatomic , copy) NSString              * userName;


@end

@interface Order :NSObject
@property (nonatomic , copy) NSString              * orderId;
@property (nonatomic , strong) StoreUserDelivery              * storeUserDelivery;
@property (nonatomic , assign) NSInteger              userId;
@property (nonatomic , copy) NSString              * province;
@property (nonatomic , copy) NSString              * city;
@property (nonatomic , copy) NSString              * county;
@property (nonatomic , copy) NSString              * userAddress;
@property (nonatomic , assign) NSInteger              cartId;
@property (nonatomic , assign) NSInteger              productId;
@property (nonatomic , assign) NSInteger              totalNum;
@property (nonatomic , assign) NSInteger              productPrice;
@property (nonatomic , assign) NSInteger              payMoney;
@property (nonatomic , assign) NSInteger              totalPostage;
@property (nonatomic , assign) NSInteger              payPostage;
@property (nonatomic , assign) NSInteger              payStatus;
@property (nonatomic , assign) NSInteger              merId;
@property (nonatomic , assign) BOOL              isDel;
@property (nonatomic , copy) NSString              * mark;
@property (nonatomic , assign) NSInteger              isDeliver;
@property (nonatomic , assign) NSInteger              refund;
@property (nonatomic , copy) NSString              * mgpPrice;
@property (nonatomic , copy) NSString              * payMgp;
@property (nonatomic , copy) NSString              * createTime;
@property (nonatomic , copy) NSString              * hashStr;
@property (nonatomic , copy) NSString              * upTime;
@property (nonatomic , copy) NSString              * num;
@property (nonatomic , copy) NSString              * buyMark;
@property (nonatomic , strong) NSDictionary              * appStoreUserDelivery;
@property (nonatomic , copy) NSString              * pay;
@property (nonatomic , copy) NSString              * usdtAddr;


@end


@interface DataItem :NSObject
@property (nonatomic , strong) Pro              * pro;
@property (nonatomic , strong) Order              * order;
@property (nonatomic , copy) NSString              * username;

@end


@interface DCOrderListModel : NSObject

@property (nonatomic , assign) NSInteger              code;
@property (nonatomic , strong) NSArray <DataItem *>              * data;

@end

NS_ASSUME_NONNULL_END


