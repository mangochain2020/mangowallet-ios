//
//  JWProgressView.m
//  TaiYiToken
//
//  Created by 张元一 on 2018/12/19.
//  Copyright © 2018 admin. All rights reserved.
//

#import "JWProgressView.h"

@interface JWProgressView ()
{
    CAShapeLayer *backGroundLayer;      //背景图层
    CAShapeLayer *stakeFillLayer;       //用来填充的图层
    CAShapeLayer *reclaimingFillLayer;       //用来填充的图层
    UIBezierPath *backGroundBezierPath; //背景贝赛尔曲线
    UIBezierPath *stakeFillBezierPath;  //用来填充的贝赛尔曲线
    UIBezierPath *reclaimingFillBezierPath;  //用来填充的贝赛尔曲线
    UILabel *_contentLabel;              //中间的label
}
@end


@implementation JWProgressView

@synthesize stakeValue = _stakeValue;
@synthesize reclaimingValue = _reclaimingValue;
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setUp];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setUp];
        
    }
    return self;
    
}

//初始化创建图层
- (void)setUp
{
    //创建背景图层
    backGroundLayer = [CAShapeLayer layer];
    backGroundLayer.fillColor = nil;
    
    //创建填充图层
    stakeFillLayer = [CAShapeLayer layer];
    stakeFillLayer.fillColor = nil;
    //创建填充图层
    reclaimingFillLayer = [CAShapeLayer layer];
    reclaimingFillLayer.fillColor = nil;
    
    //创建中间label
    _contentLabel = [[UILabel alloc]init];
    _contentLabel.textAlignment = NSTextAlignmentCenter;
//    _contentLabel.text = @"120";
    _contentLabel.font = [UIFont systemFontOfSize:15];
    _contentLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_contentLabel];
    
    [self.layer addSublayer:backGroundLayer];
    [self.layer addSublayer:stakeFillLayer];
    [self.layer addSublayer:reclaimingFillLayer];
    
    //设置颜色
    stakeFillLayer.strokeColor = kRGBA(62, 143, 251, 1).CGColor;
    reclaimingFillLayer.strokeColor = kRGBA(37, 99, 180, 1).CGColor;
    _contentLabel.textColor = [UIColor colorWithRed:78/255.0 green:194/255.0 blue:0/255.0 alpha:1.0];
    backGroundLayer.strokeColor = kRGBA(122, 197, 254, 1).CGColor;
    
}

#pragma mark -子控件约束
-(void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat width = self.bounds.size.width;
    _contentLabel.frame = CGRectMake(0, 0, width - 4, 20);
    _contentLabel.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    backGroundLayer.frame = self.bounds;
    
    
    backGroundBezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(width/2.0f, width/2.0f) radius:(CGRectGetWidth(self.bounds)-2.0)/2.f startAngle:0 endAngle:M_PI*2
                                                       clockwise:YES];
    backGroundLayer.path = backGroundBezierPath.CGPath;
    
    
    stakeFillLayer.frame = self.bounds;
    reclaimingFillLayer.frame = self.bounds;
    //设置线宽
    stakeFillLayer.lineWidth = 6.0;
    reclaimingFillLayer.lineWidth = 6.0;
    backGroundLayer.lineWidth = 6.0;
}

#pragma mark - 设置label文字和进度的方法
-(void)setContentText:(NSString *)contentText {
    
    if (_reclaimingValue + _stakeValue > 1) {
        
        return;
    }
    if (contentText) {
        
       // _contentLabel.text = contentText;
    }
}

-(void)setStakeValue:(CGFloat)stakeValue{
    stakeValue = MAX( MIN(stakeValue, 1.0), 0.0);
    _stakeValue = stakeValue;
    if (stakeValue == 1) {
        
        if ([self.delegate respondsToSelector:@selector(progressViewOver:)]) {
            
            [self.delegate progressViewOver:self];
        }
        return;
    }
    
    CGFloat width = self.bounds.size.width;
    
    stakeFillBezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(width/2.0f, width/2.0f) radius:(CGRectGetWidth(self.bounds)-2.0)/2.f startAngle:-0.25*2*M_PI endAngle:(2*M_PI)*stakeValue - 0.25*2*M_PI clockwise:YES];
    stakeFillLayer.path = stakeFillBezierPath.CGPath;
}

-(void)setReclaimingValue:(CGFloat)reclaimingValue{
    reclaimingValue = MAX( MIN(reclaimingValue, 1.0), 0.0);
    _reclaimingValue = reclaimingValue;
    if (reclaimingValue == 1) {
        
        if ([self.delegate respondsToSelector:@selector(progressViewOver:)]) {
            
            [self.delegate progressViewOver:self];
        }
        return;
    }
    
    CGFloat width = self.bounds.size.width;
    
    reclaimingFillBezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(width/2.0f, width/2.0f) radius:(CGRectGetWidth(self.bounds)-2.0)/2.f startAngle:(2*M_PI)*_stakeValue - 0.25*2*M_PI endAngle:(2*M_PI)*reclaimingValue + (2*M_PI)*_stakeValue - 0.25*2*M_PI clockwise:YES];
    reclaimingFillLayer.path = reclaimingFillBezierPath.CGPath;
}


- (CGFloat)stakeValue
{
    return _stakeValue;
}
- (CGFloat)reclaimingValue
{
    return _reclaimingValue;
}
@end
