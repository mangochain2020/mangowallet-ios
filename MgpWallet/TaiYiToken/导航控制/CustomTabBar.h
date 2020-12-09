//
//  CustomTabBar.h
//  TRProject
//
//  Created by tarena on 16/10/9.
//  Copyright © 2016年 Tedu. All rights reserved.
//
//＊＊＊＊＊＊＊＊＊＊＊＊＊自定义tabbar＊＊＊＊＊＊＊＊＊＊＊＊
#import <UIKit/UIKit.h>


//实现点击button显示相应地页面,像系统的tabBar一样
@protocol CustomTabBarDelegate <NSObject>
-(void)didSelectBarItemAtIndex:(NSInteger)index;
@end

@interface CustomTabBar : UIButton

@property(nonatomic,strong)UIImageView *iv;
@property(nonatomic,strong)UILabel *lb;
@property(nonatomic,strong)UIImage *imageHelight;
@property(nonatomic,strong)UIImage *imageDefault;
@property(nonatomic,assign) NSInteger index;
//retain -> weak
@property (nonatomic,weak) id<CustomTabBarDelegate> delegate;
- (id)initWithFrame:(CGRect)frame WithImage:(UIImage *)image WithTitle:(NSString *)title;
@end

