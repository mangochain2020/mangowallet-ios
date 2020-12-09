//
//  InputPasswordView.m
//  TaiYiToken
//
//  Created by admin on 2018/9/4.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "InputPasswordView.h"

@implementation InputPasswordView

-(void)initUI{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    _titleLabel = [UILabel new];
    _titleLabel.textColor = [UIColor textDarkColor];
    _titleLabel.font = [UIFont boldSystemFontOfSize:15];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = NSLocalizedString(@"请输入密码", nil);
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(10);
        make.left.right.equalTo(0);
        make.height.equalTo(20);
    }];
    
    _passwordTextField = [UITextField new];
    _passwordTextField.font = [UIFont systemFontOfSize:15];
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.borderStyle = UITextBorderStyleLine;
    _passwordTextField.textColor = [UIColor textBlackColor];
    _passwordTextField.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_passwordTextField];
    [_passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.right.equalTo(-10);
        make.top.equalTo(40);
        make.height.equalTo(30);
    }];
    
    _confirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _confirmBtn.backgroundColor = [UIColor whiteColor];
    _confirmBtn.tintColor = [UIColor textBlueColor];
    _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_confirmBtn setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
    [self addSubview:_confirmBtn];
    _confirmBtn.userInteractionEnabled = YES;
    [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(0);
        make.left.equalTo(10);
        make.right.equalTo(-10);
        make.height.equalTo(35);
    }];
    
    
}
@end
