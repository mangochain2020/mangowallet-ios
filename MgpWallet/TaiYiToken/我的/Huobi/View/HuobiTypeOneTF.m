//
//  HuobiTypeOneTF.m
//  TaiYiToken
//
//  Created by 张元一 on 2019/3/14.
//  Copyright © 2019 admin. All rights reserved.
//

#import "HuobiTypeOneTF.h"

@implementation HuobiTypeOneTF

//价格输入框
-(void)HuobiPriceTF{
    _huobiTF = [UITextField new];
    _huobiTF.textColor = [UIColor textDarkColor];
    _huobiTF.font = [UIFont systemFontOfSize:15];
    _huobiTF.textAlignment = NSTextAlignmentLeft;
    _huobiTF.backgroundColor = [UIColor whiteColor];
    _huobiTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [self setTextFieldLeftPadding:_huobiTF forWidth:5];
    _toolview = [HuobiToolView new];
    [_toolview HuobiTwoBtnView];
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.borderWidth = ToolViewBorderWidth;
    view.layer.borderColor = [UIColor grayColor].CGColor;
    [view addSubview:_huobiTF];
    [_huobiTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(0);
        make.right.equalTo(0);
    }];
    [view addSubview:_toolview];
    [_toolview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(60);
        make.top.bottom.right.equalTo(0);
    }];
    
    _remindLb = [UILabel new];
    _remindLb.textAlignment = NSTextAlignmentLeft;
    _remindLb.textColor = [UIColor lineGrayColor];
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
