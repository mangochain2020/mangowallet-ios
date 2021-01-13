//
//  UIButton+HXExtension.h
//  照片选择器
//
//  Created by 洪欣 on 17/2/16.
//  Copyright © 2017年 洪欣. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (HXExtension)
/**  扩大buuton点击范围  */
- (void)hx_setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left;


/**
 *  图片在上边
 *  文字在下边
 */
- (void)refreshTopBottom;
/**
 *  图片在下边
 *  文字在上边
 */
- (void)refreshBottomTop;
/**
 *  图片在右边
 *  文字在左边
 */
- (void)refreshRightLeft;
/**
 *  已经用refresh刷新过不满意，可以调用此方法在原来基础上再次增加
 *
 *  @param top    上边
 *  @param bottom 下边
 *  @param left   左边
 *  @param right  右边
 */
- (void)refreshImageViewWithTop:(CGFloat)top andBottom:(CGFloat)bottom andLeft:(CGFloat)left andRight:(CGFloat)right;

- (void)refreshTitleLabelWithTop:(CGFloat)top andBottom:(CGFloat)bottom andLeft:(CGFloat)left andRight:(CGFloat)right;

//竖直排列 设置图片和文字的距离
- (void)verticalImageAndTitle:(CGFloat)spacing;
@end
