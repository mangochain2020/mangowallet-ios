//
//  MySwitch.h
//  TaiYiToken
//
//  Created by admin on 2018/9/4.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^MyBlock) (BOOL OnStatus);

@protocol MySwitchDelegate

- (void)onStatusDelegate;

@end

@interface MySwitch : UIView
{
    //背景View 滑块View
    UIImageView *UIImageViewBack,*UIImageViewBlock;
    //背景图片 滑块右图片 滑块左图片
    UIImage     *UIImageBack,*UIImageSliderRight,*UIImageSliderLeft;
    UILabel     *leftLabel,*rightLabel;
}

//Switch 返回开关量block
@property (nonatomic,copy) MyBlock myBlock;

//Switch 返回开关量delegate
@property (nonatomic) id delegate;

//Switch 开关状态
@property (nonatomic) BOOL OnStatus;

//Switch 长 宽 滑块半径
@property (nonatomic) CGFloat Width,Height,CircleR;

//滑块距离边框边距
@property (nonatomic) CGFloat Gap;



/*  带有block 初始化
 *  @param frame
 *  @param gap  滑块距离边框的距离
 *  @param block
 *
 */
- (id)initWithFrame:(CGRect)frame withGap:(CGFloat)gap statusChange:(MyBlock)block;

/*  初始化
 *  @param frame
 *  @param gap  滑块距离边框的距离
 *
 */
- (id)initWithFrame:(CGRect)frame withGap:(CGFloat)gap;

//设置背景图片
-(void)setBackgroundImage:(UIImage *)image;

//设置左滑块图片
-(void)setLeftBlockImage:(UIImage *)image;

//设置右滑块图片
-(void)setRightBlockImage:(UIImage *)image;

//设置左文字
-(void)setLeftLabelText:(NSString *)string;

//设置右文字
-(void)setRightLabelText:(NSString *)string;
@end

