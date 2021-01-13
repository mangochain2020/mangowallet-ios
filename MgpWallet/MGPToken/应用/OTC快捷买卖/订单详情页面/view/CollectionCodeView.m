//
//  CollectionCodeView.m
//  TaiYiToken
//
//  Created by mac on 2021/1/11.
//  Copyright © 2021 admin. All rights reserved.
//

#import "CollectionCodeView.h"

#define kADViewHeight 405/667.0 * [UIScreen mainScreen].bounds.size.height
#define kADViewWidth 320/375.0 * [UIScreen mainScreen].bounds.size.width

#define kADHeight 335/667.0 * [UIScreen mainScreen].bounds.size.height
#define kADWidth 300/375.0 * [UIScreen mainScreen].bounds.size.width

#define kOffsetY 0//广告插件离Y轴中心的偏移量


@implementation CollectionCodeView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];;
    
    
    
}



- (IBAction)cancelClick:(id)sender {
    [self closeADWithAnimated:self.animated];
}
/**
 初始化页面约束
 */
- (void)makeViewContraints{
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.superview).insets(UIEdgeInsetsZero);
    }];
    
    [self.bgAdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(-CGRectGetHeight([UIScreen mainScreen].bounds)/2.0 - kADViewHeight/2.0 - kOffsetY-30);
        make.centerX.equalTo(self).offset(30);
        make.width.mas_equalTo(kADViewWidth);
//        make.height.equalTo(300);
    }];
    
    
    
}

/**
 弹窗广告插件

 @param animated 是否需要动画
 */
- (void)popADWithAnimated:(BOOL)animated{

    self.animated = animated;
    
    [[[UIApplication sharedApplication].delegate window]addSubview:self];
    
    //初始化约束，并及时刷新约束
    [self makeViewContraints];
    [self layoutIfNeeded];
    
    //更新约束
    [self.bgAdView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(- kOffsetY);
    }];
    
    if(self.animated){
        //添加弹簧动画
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:100 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self layoutIfNeeded];
        } completion:nil];
    }
}



/**
 关闭弹窗广告插件
 
 @param animated 是否需要动画
 */
- (void)closeADWithAnimated:(BOOL)animated{
    
    //更新约束
    [self.bgAdView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(CGRectGetHeight([UIScreen mainScreen].bounds)/2.0 + kADViewHeight + kOffsetY);
    }];
    
    if(animated){
        [UIView animateWithDuration:0.5 animations:^{
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
    else{
        [self removeFromSuperview];
    }
}



@end
