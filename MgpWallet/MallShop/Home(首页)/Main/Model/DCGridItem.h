//
//  DCGridItem.h
//  CDDMall
//
//  Created by apple on 2017/6/6.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCGridItem : NSObject

/** 图片  */
@property (nonatomic, copy ) NSString *iconImage;
/** 文字  */
@property (nonatomic, copy ) NSString *gridTitle;
/** tag  */
@property (nonatomic, copy ) NSString *gridTag;
/** tag颜色  */
@property (nonatomic, copy ) NSString *gridColor;


@property (nonatomic, copy) NSString *cateName;
@property (nonatomic, copy) NSString *pic;



@end
