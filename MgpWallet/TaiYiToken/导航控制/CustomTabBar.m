//
//  CustomTabBar.m
//  TRProject
//
//  Created by tarena on 16/10/9.
//  Copyright © 2016年 Tedu. All rights reserved.
//


#import "CustomTabBar.h"

@interface CustomTabBar ()

@end
@implementation CustomTabBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame WithImage:(UIImage *)image WithTitle:(NSString *)title{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.frame = frame;
        [self setAdjustsImageWhenHighlighted:NO];
        
        self.iv = [UIImageView new];
        [self addSubview:_iv];
        [_iv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.top.equalTo(9);
            make.width.height.equalTo(20);
        }];
        
        _lb = [UILabel new];
        _lb.font = [UIFont systemFontOfSize:10];
        _lb.textAlignment = NSTextAlignmentCenter;
        [_lb setText:title];
        [self addSubview:_lb];
        _lb.textColor = [UIColor lightGrayColor];
        [_lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.top.equalTo(29);
            make.width.equalTo(50);
            make.height.equalTo(18);
        }];
        [_iv setImage:image];
        [self.lb setTextColor:[UIColor lightGrayColor]];
        [self.iv setTintColor:[UIColor lightGrayColor]];
        [self addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)click:(CustomTabBar *)btn{
    if ([self.delegate respondsToSelector:@selector(didSelectBarItemAtIndex:)]) {
        [self.delegate didSelectBarItemAtIndex:self.index];/////////
    }
   
    switch ((int)(!btn.selected)) {
        case 0:
            btn.selected = YES;
            [btn.lb setTextColor:[UIColor colorWithHexString:@"#5091FF"]];//[UIColor colorWithHexString:@"#5091FF"]
            [btn.iv setImage:self.imageHelight];
            btn.tintColor = [UIColor colorWithHexString:@"#5091FF"];
            break;
        case 1:
            btn.selected = NO;
            [btn.lb setTextColor:[UIColor lightGrayColor]];
            [btn.iv setImage:self.imageDefault];
            break;
        default:
            break;
    }
}


@end

