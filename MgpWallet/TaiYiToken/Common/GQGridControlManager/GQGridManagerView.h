//
//  GridManagerView.h
//  Gridcontrol
//
//  Created by tusm on 16/2/19.
//  Copyright © 2016年 tusm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GQGridViewControl.h"

@protocol __GQGridManageDelegate <NSObject>

@required
/**添加按钮点击代理*/
- (void)addItemButtonAction;

@optional
/**单击代理*/
- (void)gridItemDidClickedWithIndex:(NSInteger)index;
/*删除代理*/
- (void)gridItemDidDeleteWithIndex:(NSInteger)index;

@end

@interface GQGridManagerView : UIView

/**
 *  初始化
 *
 *  @param rect     GQGridManagerView大小
 *  @param canEdit  是否可以编辑
 *  @param delegate __GQGridManageDelegate
 *
 *  @return self
 */
- (id)initWithframe:(CGRect)rect withCanEdit:(BOOL)canEdit withDelegate:(id<__GQGridManageDelegate>)delegate;

/**
 *  设置单个item的宽高以及每行的最大排列数
 *
 *  @param width    单个item的宽度
 *  @param hight    单个item的高度
 *  @param maxCount 行的最大排列数
 */
- (void)setItemWidth:(float)width withItemHeight:(float)hight withRowMaxCount:(NSInteger)maxCount;

/**
 *  添加item
 *
 *  @param image 需要添加的image
 */
- (void)addItemWithImage:(UIImage *)image;

@end
