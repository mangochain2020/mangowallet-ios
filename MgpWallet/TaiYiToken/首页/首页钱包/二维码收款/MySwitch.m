//
//  MySwitch.m
//  TaiYiToken
//
//  Created by admin on 2018/9/4.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "MySwitch.h"

@implementation MySwitch

- (id)initWithFrame:(CGRect)frame withGap:(CGFloat)gap{
    self = [super initWithFrame:frame];
    
    if(self){
        //默认选中On状态
        _OnStatus=NO;
        _Gap=gap;
        _Width=frame.size.width;
        _Height=frame.size.height;
        _CircleR=(_Height-2*_Gap)/2;
        
        self.backgroundColor=[UIColor clearColor];
        
        //设置背景
        UIImageViewBack=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _Width, _Height)];
        UIImageViewBack.backgroundColor=[UIColor lightGrayColor];
        [self addSubview:UIImageViewBack];
        
        //设置 滑块图片
        UIImageViewBlock=[[UIImageView alloc]initWithFrame:CGRectMake(0, _Gap, _Width/2, 2*_CircleR)];
        UIImageViewBlock.backgroundColor=[UIColor whiteColor];
        [self addSubview:UIImageViewBlock];
        
        
        //
        leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(_Gap, _Gap, _Width/2, 2*_CircleR)];
        leftLabel.textColor = [UIColor textBlueColor];
        leftLabel.font = [UIFont systemFontOfSize:12];
        leftLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:leftLabel];
        
        rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(_Width/2+_Gap, _Gap, _Width/2, 2*_CircleR)];
        rightLabel.textColor = [UIColor textWhiteColor];
        rightLabel.font = [UIFont systemFontOfSize:12];
        rightLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:rightLabel];
        
        self.userInteractionEnabled=YES;
        //创建手势对象
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        tap.numberOfTapsRequired =1;
        tap.numberOfTouchesRequired =1;
        [self addGestureRecognizer:tap];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame withGap:(CGFloat)gap statusChange:(MyBlock)block{
    self = [super initWithFrame:frame];
    
    if(self){
        _myBlock=block;
         _OnStatus=YES;
        _Gap=gap;
        _Width=frame.size.width;
        _Height=frame.size.height;
        _CircleR=(_Height-2*_Gap)/2;
        
        self.backgroundColor=[UIColor whiteColor];
        
        //设置背景
        UIImageViewBack=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _Width, _Height)];
        UIImageViewBack.backgroundColor=[UIColor lightGrayColor];
        [self addSubview:UIImageViewBack];
        
        //设置 滑块图片
        UIImageViewBlock=[[UIImageView alloc]initWithFrame:CGRectMake(0, _Gap, _Width/2 + 2, 2*_CircleR)];
        UIImageViewBlock.backgroundColor=[UIColor whiteColor];
        [self addSubview:UIImageViewBlock];
        leftLabel.textColor = [UIColor textBlueColor];
        rightLabel.textColor = [UIColor textWhiteColor];
        self.userInteractionEnabled=YES;
        //创建手势对象
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        tap.numberOfTapsRequired =1;
        tap.numberOfTouchesRequired =1;
        [self addGestureRecognizer:tap];
    }
    
    return self;
}

-(void)tapAction:(UITapGestureRecognizer *)tap
{
    
    //图片切换
    if(_OnStatus){
        _OnStatus=NO;
        //滑块关闭动画
        CABasicAnimation * ani = [CABasicAnimation animationWithKeyPath:@"position"];
        ani.toValue = [NSValue valueWithCGPoint:CGPointMake(_Width-_Height-_Gap*5.5, _CircleR+_Gap)];//144-34-2
        ani.removedOnCompletion = NO;
        ani.fillMode = kCAFillModeForwards;
        ani.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [UIImageViewBlock.layer addAnimation:ani forKey:@"PostionToLeft"];
        
        if(UIImageSliderLeft){
            UIImageViewBlock.image=UIImageSliderLeft;
            leftLabel.textColor = [UIColor textWhiteColor];
            rightLabel.textColor = [UIColor textBlueColor];
        }else{
            UIImageViewBlock.backgroundColor=[UIColor grayColor];
        }
        
    }else{
        _OnStatus=YES;
        //滑块打开动画
        CABasicAnimation * ani = [CABasicAnimation animationWithKeyPath:@"position"];
        ani.toValue = [NSValue valueWithCGPoint:CGPointMake(_Width/2-_Height-_Gap*5.5, _CircleR+_Gap)];//144/2-34-2
        ani.removedOnCompletion = NO;
        ani.fillMode = kCAFillModeForwards;
        ani.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [UIImageViewBlock.layer addAnimation:ani forKey:@"PostionToRight"];
        
        if(UIImageSliderRight){
            UIImageViewBlock.image=UIImageSliderRight;
            leftLabel.textColor = [UIColor textBlueColor];
            rightLabel.textColor = [UIColor textWhiteColor];
        }else{
            UIImageViewBlock.backgroundColor=[UIColor whiteColor];
        }
    }
    if(_myBlock) _myBlock(_OnStatus);
    [_delegate onStatusDelegate];
}

//设置背景图片
-(void)setBackgroundImage:(UIImage *)image{
    UIImageViewBack.backgroundColor=[UIColor clearColor];
    UIImageBack=image;
    UIImageViewBack.image=image;
}


//设置左滑块图片
-(void)setLeftBlockImage:(UIImage *)image{
    UIImageViewBlock.backgroundColor=[UIColor clearColor];
    UIImageSliderLeft=image;
    UIImageViewBlock.image=image;
    
}

//设置右滑块图片
-(void)setRightBlockImage:(UIImage *)image{
    UIImageViewBlock.backgroundColor=[UIColor clearColor];
    UIImageSliderRight=image;
    UIImageViewBlock.image=image;
}
//设置左文字
-(void)setLeftLabelText:(NSString *)string{
    leftLabel.text = string;
}

//设置右文字
-(void)setRightLabelText:(NSString *)string{
    rightLabel.text = string;
}

@end
