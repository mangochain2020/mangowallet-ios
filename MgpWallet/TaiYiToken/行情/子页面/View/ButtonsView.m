//
//  ButtonsView.m
//  TaiYiToken
//
//  Created by Frued on 2018/8/17.
//  Copyright © 2018年 Frued. All rights reserved.
//

#import "ButtonsView.h"
#define BtnColor RGB(256, 256, 256)
#define SelectColor [UIColor textBlueColor]
#define DeSelectColor [UIColor textGrayColor]
@implementation ButtonsView

-(void)initButtonsViewWidth:(CGFloat)width Height:(CGFloat)height{
    _FIVEMINBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _FIVEMINBtn.backgroundColor = BtnColor;
    _FIVEMINBtn.tintColor = [UIColor blackColor];
    _FIVEMINBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    _FIVEMINBtn.tag = 1;
    [_FIVEMINBtn setTitleColor:SelectColor forState:UIControlStateSelected];
    [_FIVEMINBtn setTitleColor:DeSelectColor forState:UIControlStateNormal];
    [_FIVEMINBtn setTitle:NSLocalizedString(@"5分", nil) forState:UIControlStateNormal];
    [self addSubview:_FIVEMINBtn];
    _FIVEMINBtn.userInteractionEnabled = YES;
    [_FIVEMINBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(0);
        make.width.equalTo(width/6);
        make.height.equalTo(height);
    }];
    
    _FIFTEENMINBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _FIFTEENMINBtn.backgroundColor = BtnColor;
    _FIFTEENMINBtn.tintColor = [UIColor blackColor];
    _FIFTEENMINBtn.tag = 2;
    _FIFTEENMINBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_FIFTEENMINBtn setTitleColor:SelectColor forState:UIControlStateSelected];
    [_FIFTEENMINBtn setTitleColor:DeSelectColor forState:UIControlStateNormal];
    [_FIFTEENMINBtn setTitle:NSLocalizedString(@"15分", nil) forState:UIControlStateNormal];
    [self addSubview:_FIFTEENMINBtn];
    _FIFTEENMINBtn.userInteractionEnabled = YES;
    [_FIFTEENMINBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(0);
        make.left.equalTo(width/6);
        make.width.equalTo(width/5);
        make.height.equalTo(height);
    }];
    
    _ONEHOURBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _ONEHOURBtn.backgroundColor = BtnColor;
    _ONEHOURBtn.tintColor = [UIColor blackColor];
    _ONEHOURBtn.tag = 4;
    _ONEHOURBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_ONEHOURBtn setTitle:NSLocalizedString(@"1时", nil) forState:UIControlStateNormal];
    [_ONEHOURBtn setTitleColor:SelectColor forState:UIControlStateSelected];
    [_ONEHOURBtn setTitleColor:DeSelectColor forState:UIControlStateNormal];
    [self addSubview:_ONEHOURBtn];
    _ONEHOURBtn.userInteractionEnabled = YES;
    [_ONEHOURBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.equalTo(width/6*2);
        make.width.equalTo(width/5);
        make.height.equalTo(height);
    }];
    
    _ONEDAYBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _ONEDAYBtn.backgroundColor = BtnColor;
    _ONEDAYBtn.tintColor = [UIColor blackColor];
    _ONEDAYBtn.tag = 5;
    _ONEDAYBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_ONEDAYBtn setTitle:NSLocalizedString(@"日", nil) forState:UIControlStateNormal];
    [_ONEDAYBtn setTitleColor:SelectColor forState:UIControlStateSelected];
    [_ONEDAYBtn setTitleColor:DeSelectColor forState:UIControlStateNormal];
    [self addSubview:_ONEDAYBtn];
    _ONEDAYBtn.userInteractionEnabled = YES;
    [_ONEDAYBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.equalTo(width/6*3);
        make.width.equalTo(width/5);
        make.height.equalTo(height);
    }];
    
    _ONEWEEKBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _ONEWEEKBtn.backgroundColor = BtnColor;
    _ONEWEEKBtn.tintColor = [UIColor blackColor];
    _ONEWEEKBtn.tag = 6;
    _ONEWEEKBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_ONEWEEKBtn setTitle:NSLocalizedString(@"周", nil) forState:UIControlStateNormal];
    [_ONEWEEKBtn setTitleColor:SelectColor forState:UIControlStateSelected];
    [_ONEWEEKBtn setTitleColor:DeSelectColor forState:UIControlStateNormal];
    [self addSubview:_ONEWEEKBtn];
    _ONEWEEKBtn.userInteractionEnabled = YES;
    [_ONEWEEKBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.equalTo(width/6*4);
        make.width.equalTo(width/5);
        make.height.equalTo(height);
    }];
    
    _ONEMONBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _ONEMONBtn.backgroundColor = BtnColor;
    _ONEMONBtn.tintColor = [UIColor blackColor];
    _ONEMONBtn.tag = 7;
    _ONEMONBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_ONEMONBtn setTitle:NSLocalizedString(@"月", nil) forState:UIControlStateNormal];
    [_ONEMONBtn setTitleColor:SelectColor forState:UIControlStateSelected];
    [_ONEMONBtn setTitleColor:DeSelectColor forState:UIControlStateNormal];
    [self addSubview:_ONEMONBtn];
    _ONEMONBtn.userInteractionEnabled = YES;
    [_ONEMONBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.equalTo(width/6*5);
        make.width.equalTo(width/5);
        make.height.equalTo(height);
    }];
    
    self.btnArray = [NSArray arrayWithObjects:_FIVEMINBtn,_FIFTEENMINBtn,_ONEHOURBtn,_ONEDAYBtn,_ONEWEEKBtn, _ONEMONBtn,nil];
}


@end
