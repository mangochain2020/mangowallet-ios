//
//  DCRecommendItem.h
//  CDDMall
//
//  Created by apple on 2017/6/5.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCRecommendItem : NSObject

/** 图片URL */
@property (nonatomic, copy) NSString *image_url;
/** 商品标题 */
@property (nonatomic, copy) NSString *main_title;
/** 商品小标题 */
@property (nonatomic, copy) NSString *goods_title;
/** 商品价格 */
@property (nonatomic, copy) NSString *price;
/** 剩余 */
@property (nonatomic, copy) NSString *stock;
/** 属性 */
@property (nonatomic, copy) NSString *nature;

/* 头部轮播 */
@property (copy , nonatomic)NSArray *images;

/** 属性 */
@property (nonatomic, assign) NSInteger postage;
/** 属性 */
@property (nonatomic, copy) NSString *storeType;
/** 属性 */
@property (nonatomic, copy) NSString *storeUnit;
/** 属性 */
@property (nonatomic, assign) NSInteger proID;

@end
