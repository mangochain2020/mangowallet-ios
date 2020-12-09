//
//  TransactionAmountView.m
//  TaiYiToken
//
//  Created by admin on 2018/9/13.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "TransactionAmountView.h"

@implementation TransactionAmountView
//@property(nonatomic)UITextField *amountTextField;
//@property(nonatomic)UITextField *remarkTextField;
//@property(nonatomic)UILabel *pricelb;
//@property(nonatomic)UILabel *balancelb;
-(void)initUI{
    self.backgroundColor = [UIColor whiteColor];
    //eth
    _namelb = [UILabel new];
    _namelb.textColor = [UIColor textBlackColor];
    _namelb.font = [UIFont boldSystemFontOfSize:13];
    _namelb.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_namelb];
    [_namelb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(17);
        make.top.equalTo(10);
        make.width.equalTo(150);
        make.height.equalTo(20);
    }];
    //余额：0.0105ETH
    _balancelb = [UILabel new];
    _balancelb.textColor = RGBACOLOR(23, 107, 172, 1);
    _balancelb.font = [UIFont boldSystemFontOfSize:13];
    _balancelb.textAlignment = NSTextAlignmentRight;
    [self addSubview:_balancelb];
    [_balancelb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-15);
        make.top.equalTo(10);
        make.left.equalTo(30);
        make.height.equalTo(20);
    }];
    //0.05
    _amountTextField = [UITextField new];
    _amountTextField.borderStyle = UITextBorderStyleNone;
    _amountTextField.attributedPlaceholder =[[NSAttributedString alloc]initWithString: NSLocalizedString(@"输入金额", nil)];
    _amountTextField.backgroundColor = [UIColor whiteColor];
    _amountTextField.textAlignment = NSTextAlignmentLeft;
    _amountTextField.textColor = [UIColor textBlackColor];
    _amountTextField.font = [UIFont systemFontOfSize:23];
    _amountTextField.keyboardType = UIKeyboardTypeDecimalPad;
    [self addSubview:_amountTextField];
    [_amountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(35);
        make.height.equalTo(30);
        make.left.equalTo(17);
        make.right.equalTo(-150);
    }];
    //≈￥92.97
    _pricelb = [UILabel new];
    _pricelb.textColor = RGBACOLOR(224, 224, 224, 1);
    _pricelb.font = [UIFont boldSystemFontOfSize:23];
    _pricelb.textAlignment = NSTextAlignmentRight;
    [self addSubview:_pricelb];
    [_pricelb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-15);
        make.top.equalTo(35);
        make.width.equalTo(200);
        make.height.equalTo(20);
    }];
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = RGBACOLOR(224, 224, 224, 1);
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.bottom.equalTo(-38);
        make.height.equalTo(1);
    }];
}

-(UILabel *)btcAvailableLb{
    if (!_btcAvailableLb) {
        _btcAvailableLb = [UILabel new];
        _btcAvailableLb.textColor = RGBACOLOR(23, 107, 172, 1);
        _btcAvailableLb.font = [UIFont boldSystemFontOfSize:12];
        _btcAvailableLb.numberOfLines = 0;
        _btcAvailableLb.textAlignment = NSTextAlignmentLeft;
        _btcAvailableLb.text = NSLocalizedString(@"备注", nil);
        [self addSubview:_btcAvailableLb];
        [_btcAvailableLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(17);
            make.bottom.equalTo(0);
            make.right.equalTo(-17);
            make.height.equalTo(35);
        }];
    }
    return _btcAvailableLb;
}


-(UITextField *)remarkTextField{
    if (!_remarkTextField) {
        //备注
        UILabel *remlb = [UILabel new];
        remlb.textColor = [UIColor textBlackColor];
        remlb.font = [UIFont boldSystemFontOfSize:13];
        remlb.textAlignment = NSTextAlignmentLeft;
        remlb.text = NSLocalizedString(@"备注：", nil);
        [self addSubview:remlb];
        [remlb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(17);
            make.bottom.equalTo(-15);
            make.width.equalTo(40);
            make.height.equalTo(20);
        }];
        //备注内容
        _remarkTextField = [UITextField new];
        _remarkTextField.borderStyle = UITextBorderStyleNone;
        _remarkTextField.attributedPlaceholder =[[NSAttributedString alloc]initWithString: NSLocalizedString(@"（选填）", nil)];
        _remarkTextField.backgroundColor = [UIColor whiteColor];
        _remarkTextField.textAlignment = NSTextAlignmentLeft;
        _remarkTextField.textColor = [UIColor textBlackColor];
        _remarkTextField.font = [UIFont systemFontOfSize:13];
        [self addSubview:_remarkTextField];
        [_remarkTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(-15);
            make.height.equalTo(20);
            make.left.equalTo(60);
            make.right.equalTo(-15);
        }];
    }
    return _remarkTextField;
}

@end
