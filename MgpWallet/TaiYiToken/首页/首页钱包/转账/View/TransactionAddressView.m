//
//  TransactionAddressView.m
//  TaiYiToken
//
//  Created by admin on 2018/9/13.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "TransactionAddressView.h"

@implementation TransactionAddressView

-(void)initUI{
    self.backgroundColor = [UIColor whiteColor];
    UILabel *leftlb = [UILabel new];
    leftlb.textColor = [UIColor textBlackColor];
    leftlb.font = [UIFont boldSystemFontOfSize:13];
    leftlb.textAlignment = NSTextAlignmentLeft;
    leftlb.text = NSLocalizedString(@"收款地址", nil);
    [self addSubview:leftlb];
    [leftlb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.centerY.equalTo(-25);
        make.width.equalTo(60);
        make.height.equalTo(20);
    }];
    
    _toAddressTextField = [UITextField new];
    _toAddressTextField.borderStyle = UITextBorderStyleNone;
    _toAddressTextField.backgroundColor = [UIColor whiteColor];
    _toAddressTextField.textAlignment = NSTextAlignmentLeft;
    _toAddressTextField.textColor = [UIColor textBlackColor];
    _toAddressTextField.font = [UIFont systemFontOfSize:13];
    [self addSubview:_toAddressTextField];
    [_toAddressTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(90);
        make.centerY.equalTo(-25);
        make.right.equalTo(-15);
        make.height.equalTo(20);
    }];
    
    UILabel *leftlb1 = [UILabel new];
    leftlb1.textColor = [UIColor textBlackColor];
    leftlb1.font = [UIFont boldSystemFontOfSize:13];
    leftlb1.textAlignment = NSTextAlignmentLeft;
    leftlb1.text = NSLocalizedString(@"付款地址", nil);
    [self addSubview:leftlb1];
    [leftlb1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.centerY.equalTo(25);
        make.width.equalTo(60);
        make.height.equalTo(20);
    }];
    
    _fromAddressTextField = [UITextField new];
    _fromAddressTextField.borderStyle = UITextBorderStyleNone;
    _fromAddressTextField.backgroundColor = [UIColor whiteColor];
    _fromAddressTextField.textAlignment = NSTextAlignmentLeft;
    _fromAddressTextField.textColor = [UIColor textBlackColor];
    _fromAddressTextField.font = [UIFont systemFontOfSize:13];
    [self addSubview:_fromAddressTextField];
    [_fromAddressTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(90);
        make.centerY.equalTo(25);
        make.right.equalTo(-50);
        make.height.equalTo(20);
    }];
    
    _selectWalletBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    _selectWalletBtn.userInteractionEnabled = YES;
    _selectWalletBtn.backgroundColor = [UIColor whiteColor];
    [_selectWalletBtn setImage:[UIImage imageNamed:@"ico_dw_arrow-z"] forState:UIControlStateNormal];
    _selectWalletBtn.imageEdgeInsets=UIEdgeInsetsMake(8, 16, 8, 16);
    [self addSubview:_selectWalletBtn];
    [_selectWalletBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(25);
        make.right.equalTo(-0);
        make.height.equalTo(40);
        make.width.equalTo(50);
    }];
}

@end
