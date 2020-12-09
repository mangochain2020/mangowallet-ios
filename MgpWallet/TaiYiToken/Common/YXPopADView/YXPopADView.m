//
//  YXPopBannerView.m
//  PopBannerDemo
//
//  Created by maoyuxiang on 2017/2/27.
//  Copyright © 2017年 maoyuxiang. All rights reserved.
//

#import "YXPopADView.h"
#import "Masonry.h"


#define kADViewHeight 405/667.0 * [UIScreen mainScreen].bounds.size.height
#define kADViewWidth 320/375.0 * [UIScreen mainScreen].bounds.size.width

#define kADHeight 335/667.0 * [UIScreen mainScreen].bounds.size.height
#define kADWidth 300/375.0 * [UIScreen mainScreen].bounds.size.width

#define kOffsetY 0//广告插件离Y轴中心的偏移量

@interface YXPopADView()

@property(strong, nonatomic) UIView *bgView;

@property(strong, nonatomic) UIButton *closeButton;

@property(strong, nonatomic) UIView *line;

@property(strong, nonatomic) UIView *bgAdView;

@property(strong, nonatomic) UIButton *goNextButton;



/**
 是否需要动画显示和隐藏（动画方向为从上往下）
 */
@property(assign, nonatomic) BOOL animated;

@end


@implementation YXPopADView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //初始化UI
        [self initUI];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.goNextButton.layer.cornerRadius = CGRectGetHeight(self.goNextButton.bounds)/2.0;
    self.goNextButton.layer.masksToBounds = YES;
}


#pragma mark - 自定义方法

/**
 初始化UI
 */
- (void)initUI{
    
    self.backgroundColor = [UIColor clearColor];
    
    self.bgView = [[UIView alloc]init];
    self.bgView.backgroundColor = [UIColor blackColor];
    self.bgView.alpha = 0.3;
    [self addSubview:self.bgView];
    
    
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeButton setBackgroundImage:[UIImage imageNamed:@"home_pop_ad_close"] forState:UIControlStateNormal];
    [self.closeButton addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.closeButton.tag = 10;
    [self addSubview:self.closeButton];
    
    self.line = [[UIView alloc]init];
    self.line.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.line];
    
    self.bgAdView = [[UIView alloc]init];
    self.bgAdView.backgroundColor = [UIColor whiteColor];
    self.bgAdView.layer.masksToBounds = YES;
    self.bgAdView.layer.cornerRadius = 8;
    [self addSubview:self.bgAdView];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:23];
//    self.titleLabel.text = @"口令已复制";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.bgAdView addSubview:self.titleLabel];
    
    self.desLabel = [[UITextView alloc]init];
    self.desLabel.font = [UIFont systemFontOfSize:17];
    self.desLabel.editable = NO;
    self.desLabel.layer.masksToBounds = YES;
    self.desLabel.layer.cornerRadius = 5;
    self.desLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
//    self.desLabel.text = @"2👈覆置本段内容 Http:/T￥ZYlHc4Y06IM￥打開👉手机天猫👈【帛卡琪2020新款港味格子衬衫上衣荷叶边V领短袖t恤女露锁骨衬衣夏】";
    [self.bgAdView addSubview:self.desLabel];
    
    self.adImageView = [[UIImageView alloc]init];
    self.adImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.adImageView.layer.masksToBounds = YES;
    [self.bgAdView addSubview:self.adImageView];
    
    self.goNextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.goNextButton.backgroundColor = [UIColor greenColor];
    [self.goNextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.goNextButton setTitle:@"去微信粘贴给好友" forState:UIControlStateNormal];
    [self.goNextButton addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.goNextButton.titleLabel.font = [UIFont systemFontOfSize:17];
    self.goNextButton.tag = 11;
    [self.bgAdView addSubview:self.goNextButton];

}


/**
 初始化页面约束
 */
- (void)makeViewContraints{
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.superview).insets(UIEdgeInsetsZero);
    }];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsZero);
    }];
    
    [self.bgAdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(-CGRectGetHeight([UIScreen mainScreen].bounds)/2.0 - kADViewHeight/2.0 - kOffsetY);
        make.centerX.equalTo(self).offset(0);
        make.width.mas_equalTo(kADViewWidth);
        make.height.equalTo(300);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgAdView);
        make.top.equalTo(self.bgAdView.top).offset(10);
        make.right.left.equalTo(0);
        make.height.equalTo(45);
        
    }];
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.height.equalTo(150);
        
    }];
    

    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgAdView.mas_bottom).offset(40);
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.centerX.equalTo(self.bgAdView);
        
    }];
    
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.closeButton.mas_centerX);
        make.top.equalTo(self.bgAdView.mas_bottom);
        make.width.mas_equalTo(1);
        make.bottom.equalTo(self.closeButton.mas_top);
    }];
    /*
    [self.adImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bgAdView).insets(UIEdgeInsetsMake(10, 10, 60/667.0 * [UIScreen mainScreen].bounds.size.height, 10));
    }];
    */
    [self.goNextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgAdView);
        make.top.equalTo(self.desLabel.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(kADViewWidth-80, 50));
    }];
}


- (void)btnPressed:(UIButton *)sender{
    NSInteger index = sender.tag - 10;
    switch (index) {
        case 0:{
            //关闭弹窗广告插件
            [self closeADWithAnimated:self.animated];
        }
            break;
        case 1:{
            //去看看
            if (self.goNextBlock) {
                [self closeADWithAnimated:NO];
                self.goNextBlock();
            }
        }
            break;
        default:
            break;
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self closeADWithAnimated:self.animated];

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
