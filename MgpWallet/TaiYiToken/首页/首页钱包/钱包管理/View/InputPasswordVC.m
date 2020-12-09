//
//  InputPasswordVC.m
//  TaiYiToken
//
//  Created by admin on 2018/9/4.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "InputPasswordVC.h"

@interface InputPasswordVC ()

@end

@implementation InputPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUI];
}
-(void)initUI{
    _titleLabel = [UILabel new];
    _titleLabel.textColor = [UIColor textDarkColor];
    _titleLabel.font = [UIFont boldSystemFontOfSize:10];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.text = NSLocalizedString(@"请输入密码", nil);
    [self.view addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(10);
        make.left.right.equalTo(0);
        make.height.equalTo(20);
    }];
    
    _passwordTextField = [UITextField new];
    _passwordTextField.font = [UIFont systemFontOfSize:15];
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.backgroundColor = [UIColor lightGrayColor];
    _passwordTextField.textColor = [UIColor textBlackColor];
    _passwordTextField.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_passwordTextField];
    [_passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.right.equalTo(-10);
        make.top.equalTo(40);
        make.height.equalTo(20);
    }];
    
    _confirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _confirmBtn.backgroundColor = [UIColor whiteColor];
    _confirmBtn.tintColor = [UIColor textBlueColor];
    _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_confirmBtn setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
    [self.view addSubview:_confirmBtn];
    _confirmBtn.userInteractionEnabled = YES;
    [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(0);
        make.left.equalTo(10);
        make.right.equalTo(-10);
        make.height.equalTo(35);
    }];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

@end
