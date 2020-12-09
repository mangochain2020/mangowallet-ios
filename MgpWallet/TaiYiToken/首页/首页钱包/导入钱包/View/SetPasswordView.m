//
//  SetPasswordView.m
//  TaiYiToken
//
//  Created by admin on 2018/9/6.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "SetPasswordView.h"

@implementation SetPasswordView

-(void)initSetPasswordViewUI{
    self.backgroundColor = [UIColor clearColor];
    
    _passwordTextField = [UITextField new];
    _passwordTextField.borderStyle = UITextBorderStyleNone;
    _passwordTextField.attributedPlaceholder =[[NSAttributedString alloc]initWithString: NSLocalizedString(@"钱包密码(8-18位字符)", nil)];
    _passwordTextField.backgroundColor = [UIColor whiteColor];
    _passwordTextField.textAlignment = NSTextAlignmentLeft;
    _passwordTextField.textColor = [UIColor darkGrayColor];
    _passwordTextField.font = [UIFont systemFontOfSize:15];
    _passwordTextField.secureTextEntry = YES;
//    _passwordTextField.text = @"Aa123456";
    [self addSubview:_passwordTextField];
    [_passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.height.equalTo(54);
        make.left.equalTo(15);
        make.right.equalTo(-15);
    }];
    
    _repasswordTextField = [UITextField new];
    _repasswordTextField.borderStyle = UITextBorderStyleNone;
    _repasswordTextField.attributedPlaceholder =[[NSAttributedString alloc]initWithString: NSLocalizedString(@"重复输入密码", nil)];
    _repasswordTextField.backgroundColor = [UIColor whiteColor];
    _repasswordTextField.textAlignment = NSTextAlignmentLeft;
    _repasswordTextField.textColor = [UIColor darkGrayColor];
    _repasswordTextField.font = [UIFont systemFontOfSize:15];
    _repasswordTextField.secureTextEntry = YES;
//    _repasswordTextField.text = @"Aa123456";

    [self addSubview:_repasswordTextField];
    [_repasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.passwordTextField.mas_bottom);
        make.height.equalTo(54);
        make.left.equalTo(15);
        make.right.equalTo(-15);
    }];
    
    _passwordHintTextField = [UITextField new];
    _passwordHintTextField.borderStyle = UITextBorderStyleNone;
    _passwordHintTextField.attributedPlaceholder =[[NSAttributedString alloc]initWithString: NSLocalizedString(@"密码提示信息", nil)];
    _passwordHintTextField.backgroundColor = [UIColor whiteColor];
    _passwordHintTextField.textAlignment = NSTextAlignmentLeft;
    _passwordHintTextField.textColor = [UIColor darkGrayColor];
    _passwordHintTextField.font = [UIFont systemFontOfSize:15];
//    _passwordHintTextField.text = @"aa1-6";
    [self addSubview:_passwordHintTextField];
    [_passwordHintTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.repasswordTextField.mas_bottom);
        make.height.equalTo(54);
        make.left.equalTo(15);
        make.right.equalTo(-15);
    }];

}

@end
