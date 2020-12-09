
//
//  HuobiTypeTwoTF.m
//  TaiYiToken
//
//  Created by 张元一 on 2019/3/14.
//  Copyright © 2019 admin. All rights reserved.
//

#import "HuobiTypeTwoTF.h"

@implementation HuobiTypeTwoTF

//数量输入框
-(void)HuobiQuantityTF{
    _huobiTF = [UITextField new];
    _huobiTF.textColor = [UIColor textDarkColor];
    _huobiTF.font = [UIFont systemFontOfSize:15];
    _huobiTF.textAlignment = NSTextAlignmentLeft;
    _huobiTF.backgroundColor = [UIColor whiteColor];
    _huobiTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [self setTextFieldLeftPadding:_huobiTF forWidth:5];
    _coinLb = [UILabel new];
    _coinLb.textAlignment = NSTextAlignmentRight;
    _coinLb.textColor = [UIColor lightGrayColor];
    [_coinLb setFont:[UIFont systemFontOfSize:13]];
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.borderWidth = ToolViewBorderWidth;
    view.layer.borderColor = [UIColor grayColor].CGColor;
    [view addSubview:_huobiTF];
    [_huobiTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(0);
        make.right.equalTo(-80);
    }];
    [view addSubview:_coinLb];
    [_coinLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.huobiTF.mas_right);
        make.top.bottom.equalTo(0);
        make.right.equalTo(-5);
    }];
    
    _remindLb = [UILabel new];
    _remindLb.textAlignment = NSTextAlignmentLeft;
    _remindLb.textColor = [UIColor lightGrayColor];
    [_remindLb setFont:[UIFont systemFontOfSize:12]];
    
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.top.equalTo(0);
        make.bottom.equalTo(-30);
    }];
    [self addSubview:_remindLb];
    [_remindLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.height.equalTo(30);
        make.bottom.equalTo(0);
    }];
 
}

-(void)setTextFieldLeftPadding:(UITextField *)textField forWidth:(CGFloat)leftWidth
{
    CGRect frame = textField.frame;
    frame.size.width = leftWidth;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = leftview;
}
@end
