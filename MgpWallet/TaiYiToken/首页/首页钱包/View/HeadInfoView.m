//
//  HeadInfoView.m
//  TaiYiToken
//
//  Created by Frued on 2018/10/22.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "HeadInfoView.h"

@implementation HeadInfoView

-(UIButton *)balanceBtn{
    if (!_balanceBtn) {
        _balanceBtn = [UIButton buttonWithType: UIButtonTypeSystem];
        _balanceBtn.tintColor = [UIColor textWhiteColor];
        _balanceBtn.titleLabel.font = [UIFont boldSystemFontOfSize:33];
        _balanceBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        _balanceBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _balanceBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _balanceBtn.userInteractionEnabled = NO;
        [self addSubview:_balanceBtn];
        [_balanceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(26);
            make.top.equalTo(22);
            make.right.equalTo(-100);
            make.height.equalTo(40);
        }];
    }
    return _balanceBtn;
}
-(UIButton *)detailBtn{
    if (!_detailBtn) {
        _detailBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        _detailBtn.userInteractionEnabled = YES;
        _detailBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 20);
        [_detailBtn setImage:[UIImage imageNamed:@"detail"] forState:UIControlStateNormal];
        _detailBtn.imageView.contentMode = UIViewContentModeCenter;
        [self addSubview:_detailBtn];
        [_detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(0);
            make.top.equalTo(10);
            make.width.equalTo(65);
            make.height.equalTo(30);
        }];
    }
    return _detailBtn;
}
-(UIButton *)gainsBtn{
    if (!_gainsBtn) {
        _gainsBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        _gainsBtn.titleLabel.textColor = [UIColor textWhiteColor];
        _gainsBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _gainsBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        _gainsBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _gainsBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _gainsBtn.userInteractionEnabled = NO;
        [self addSubview:_gainsBtn];
        [_gainsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(26);
            make.top.equalTo(100);
            make.right.equalTo(-80);
            make.height.equalTo(20);
        }];
    }
    return _gainsBtn;
}

@end
