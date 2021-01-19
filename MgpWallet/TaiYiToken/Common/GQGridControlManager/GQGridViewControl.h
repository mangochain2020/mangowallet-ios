//
//  GridViewControl.h
//  WeatherInZhuhai
//
//  Created by tb on 14-9-5.
//  Copyright (c) 2014年 tb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GQGridViewControl;

@protocol __GQGridControlDelegate<NSObject>
@required
- (void)gridItemDidClicked:(GQGridViewControl *)gridItem atIndex:(NSInteger)index;
- (void)gridItemDidDeleted:(GQGridViewControl *)gridItem atIndex:(NSInteger)index;
- (void)gridItemDidLongPressed:(GQGridViewControl *)gridItem atIndex:(NSInteger)index;
@end

@interface GQGridViewControl : UIControl

@property (nonatomic) BOOL isEditing;   //是否是编辑状态
@property (nonatomic) NSInteger index;  //标记当前ItemID

- (id)initWithFrame:(CGRect)frame withImage:(UIImage *)image atIndex:(NSInteger)index withDelegate:(id<__GQGridControlDelegate>)delegate;

- (void)enableEditing;  //启动编辑
- (void)disableEditing; //取消编辑

@end
