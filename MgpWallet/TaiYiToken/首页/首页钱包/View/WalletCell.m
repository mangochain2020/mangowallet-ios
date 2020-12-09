//
//  WalletCell.m
//  TaiYiToken
//
//  Created by admin on 2018/9/3.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "WalletCell.h"

@implementation WalletCell

-(UILabel *)balancelb{
    if (!_balancelb) {
        _balancelb = [UILabel new];
        _balancelb.textColor = [UIColor textWhiteColor];
        _balancelb.font = [UIFont boldSystemFontOfSize:33];
        _balancelb.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_balancelb];
        [_balancelb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(26);
            make.top.equalTo(22);
            make.right.equalTo(-30);
            make.height.equalTo(40);
        }];
    }
    return _balancelb;
}
-(UILabel *)profitlb{
    if (!_profitlb) {
        _profitlb = [UILabel new];
        _profitlb.textColor = [UIColor textWhiteColor];
        _profitlb.font = [UIFont systemFontOfSize:12];
        _profitlb.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_profitlb];
        [_profitlb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(26);
            make.top.equalTo(self.balancelb.mas_bottom).equalTo(5);
            make.right.equalTo(-30);
            make.height.equalTo(15);
        }];
    }
    return _profitlb;
}
-(UIButton *)QRCodeBtn{
    if (!_QRCodeBtn) {
        _QRCodeBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        _QRCodeBtn.userInteractionEnabled = YES;
        [self  addSubview:_QRCodeBtn];
        [_QRCodeBtn setBackgroundImage:[UIImage imageNamed:@"wallet_code"] forState:UIControlStateNormal];
        [_QRCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(26);
            make.bottom.equalTo(-20);
            make.width.equalTo(18);
            make.height.equalTo(18);
        }];
    }
    return _QRCodeBtn;
}
-(UIButton *)addressBtn{
    if (!_addressBtn) {
        _addressBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        _addressBtn.userInteractionEnabled = YES;
        _addressBtn.titleLabel.textColor = [UIColor textWhiteColor];
        _addressBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        _addressBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        [self  addSubview:_addressBtn];
        [_addressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(0);
            make.bottom.equalTo(-20);
            make.width.equalTo(200);
            make.height.equalTo(20);
        }];
        
        UIImageView *iv = [UIImageView new];
        iv.image = [UIImage imageNamed:@"ico_backups"];
        [self addSubview:iv];
        [iv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-20);
            make.width.equalTo(10);
            make.height.equalTo(12);
            make.bottom.equalTo(-25);
        }];
    }
    return _addressBtn;
}
-(UIButton *)detailBtn{
    if (!_detailBtn) {
        _detailBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        _detailBtn.userInteractionEnabled = YES;
        [_detailBtn setBackgroundImage:[UIImage imageNamed:@"detail"] forState:UIControlStateNormal];
        _detailBtn.imageView.contentMode = UIViewContentModeCenter;
        [self addSubview:_detailBtn];
        [_detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-20);
            make.top.equalTo(22);
            make.width.equalTo(15);
            make.height.equalTo(10);
        }];
    }
    return _detailBtn;
}

@end
