//
//  EOSTranDetail.m
//  TaiYiToken
//
//  Created by Frued on 2018/10/24.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "EOSTranDetailView.h"

@implementation EOSTranDetailView

-(UILabel *)titlelb{
    if (!_titlelb) {
        _titlelb = [UILabel new];
        _titlelb.backgroundColor = RGB(252, 252, 253);
        _titlelb.textColor = [UIColor textBlackColor];
        _titlelb.font = [UIFont boldSystemFontOfSize:15];
        _titlelb.textAlignment = NSTextAlignmentCenter;
        _titlelb.layer.cornerRadius = 4;
        _titlelb.layer.masksToBounds = YES;
        [self addSubview:_titlelb];
        [_titlelb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(0);
            make.left.right.equalTo(0);
            make.height.equalTo(45);
        }];
    }
    return _titlelb;
}
-(UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _closeBtn.contentEdgeInsets = UIEdgeInsetsMake(7, 7, 7, 7);
        [_closeBtn setImage:[UIImage imageNamed:@"wallet_close"] forState:UIControlStateNormal];
        [self addSubview:_closeBtn];
        [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-16);
            make.top.equalTo(10);
            make.width.height.equalTo(30);
        }];
    }
    return _closeBtn;
}

-(UILabel *)amountlb{
    if (!_amountlb) {
        _amountlb = [UILabel new];
        _amountlb.textColor = [UIColor textBlackColor];
        _amountlb.font = [UIFont boldSystemFontOfSize:24];
        _amountlb.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_amountlb];
        [_amountlb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(40);
            make.left.right.equalTo(0);
            make.height.equalTo(30);
        }];
    }
    return _amountlb;
}
-(UILabel *)infolb{
    if (!_infolb) {
        UILabel *lb = [UILabel new];
        lb.textColor = [UIColor textGrayColor];
        lb.font = [UIFont systemFontOfSize:14];
        lb.textAlignment = NSTextAlignmentLeft;
        lb.text = NSLocalizedString(@"支付信息", nil);
        [self addSubview:lb];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(16);
            make.width.equalTo(80);
            make.top.equalTo(self.amountlb.mas_bottom).equalTo(15);
            make.height.equalTo(40);
        }];
        
        _infolb = [UILabel new];
        _infolb.textColor = [UIColor textBlackColor];
        _infolb.font = [UIFont systemFontOfSize:14];
        _infolb.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_infolb];
        [_infolb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(100);
            make.right.equalTo(0);
            make.top.equalTo(self.amountlb.mas_bottom).equalTo(15);
            make.height.equalTo(40);
        }];
        UIView *line = [UIView new];
        line.backgroundColor = [UIColor lineGrayColor];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(16);
            make.right.equalTo(0);
            make.top.equalTo(self.amountlb.mas_bottom).equalTo(55);
            make.height.equalTo(1);
        }];
        
    }
    return _infolb;
}
-(UILabel *)tolb{
    if (!_tolb) {
        UILabel *lb = [UILabel new];
        lb.textColor = [UIColor textGrayColor];
        lb.font = [UIFont systemFontOfSize:14];
        lb.textAlignment = NSTextAlignmentLeft;
        lb.text = NSLocalizedString(@"收款地址", nil);
        [self addSubview:lb];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(16);
            make.width.equalTo(80);
            make.top.equalTo(self.infolb.mas_bottom);
            make.height.equalTo(40);
        }];
        
        _tolb = [UILabel new];
        _tolb.textColor = [UIColor textBlackColor];
        _tolb.font = [UIFont systemFontOfSize:14];
        _tolb.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_tolb];
        [_tolb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(100);
            make.right.equalTo(0);
            make.top.equalTo(self.infolb.mas_bottom);
            make.height.equalTo(40);
        }];
        
        UIView *line = [UIView new];
        line.backgroundColor = [UIColor lineGrayColor];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(16);
            make.right.equalTo(0);
            make.top.equalTo(self.infolb.mas_bottom).equalTo(45);
            make.height.equalTo(1);
        }];
    }
    return _tolb;
}
-(UILabel *)fromlb{
    if (!_fromlb) {
        UILabel *lb = [UILabel new];
        lb.textColor = [UIColor textGrayColor];
        lb.font = [UIFont systemFontOfSize:14];
        lb.textAlignment = NSTextAlignmentLeft;
        lb.text = NSLocalizedString(@"付款地址", nil);
        [self addSubview:lb];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(16);
            make.width.equalTo(80);
            make.top.equalTo(self.tolb.mas_bottom);
            make.height.equalTo(40);
        }];
        
        _fromlb = [UILabel new];
        _fromlb.textColor = [UIColor textBlackColor];
        _fromlb.font = [UIFont systemFontOfSize:14];
        _fromlb.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_fromlb];
        [_fromlb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(100);
            make.right.equalTo(0);
            make.top.equalTo(self.tolb.mas_bottom);
            make.height.equalTo(40);
        }];
        
        UIView *line = [UIView new];
        line.backgroundColor = [UIColor lineGrayColor];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(16);
            make.right.equalTo(0);
            make.top.equalTo(self.tolb.mas_bottom).equalTo(45);
            make.height.equalTo(1);
        }];
    }
    return _fromlb;
}
-(UIButton *)nextBtn{
    if (!_nextBtn) {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _nextBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        _nextBtn.titleLabel.textColor = [UIColor whiteColor];
        _nextBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _nextBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _nextBtn.userInteractionEnabled = YES;
        [_nextBtn setTitle:NSLocalizedString(@"下一步", nil) forState:UIControlStateNormal];
        [_nextBtn gradientButtonWithSize:CGSizeMake(ScreenWidth, 44) colorArray:@[[UIColor colorWithHexString:@"#4090F7"],[UIColor colorWithHexString:@"#57A8FF"]] percentageArray:@[@(0.3),@(1)] gradientType:GradientFromLeftTopToRightBottom];
        [self addSubview:_nextBtn];
        [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(0);
            make.left.right.equalTo(0);
            make.height.equalTo(44);
        }];
    }
    return _nextBtn;
}
-(UITextField *)passTextField{
    if (!_passTextField) {
        UILabel *lb = [UILabel new];
        lb.textColor = [UIColor textBlackColor];
        lb.font = [UIFont systemFontOfSize:14];
        lb.textAlignment = NSTextAlignmentLeft;
        lb.text = NSLocalizedString(@"输入钱包密码", nil);
        [self addSubview:lb];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(20);
            make.width.equalTo(200);
            make.top.equalTo(60);
            make.height.equalTo(20);
        }];
        
        _passTextField = [UITextField new];
        _passTextField.textAlignment = NSTextAlignmentLeft;
        _passTextField.textColor = [UIColor textBlackColor];
        _passTextField.font = [UIFont systemFontOfSize:16];
        _passTextField.placeholder = NSLocalizedString(@"密码", nil);
        _passTextField.secureTextEntry = YES;
        [self addSubview:_passTextField];
        [_passTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(20);
            make.right.equalTo(0);
            make.top.equalTo(85);
            make.height.equalTo(30);
        }];
    }
    return _passTextField;
}
@end
