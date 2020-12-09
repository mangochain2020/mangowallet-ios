//
//  DappViewCell.m
//  TaiYiToken
//
//  Created by admin on 2018/9/25.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "DappViewCell.h"

@implementation DappViewCell
-(UIImageView *)iconImageView{
    if (!_iconImageView) {
        
        _shadowView = [UIView new];
        _shadowView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        _shadowView.layer.shadowOffset = CGSizeMake(0, 0);
        _shadowView.layer.shadowOpacity = 1;
        _shadowView.layer.shadowRadius = 1.0;
        _shadowView.layer.cornerRadius = 1.0;
        _shadowView.clipsToBounds = NO;
        [self.contentView addSubview:_shadowView];
        [_shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
        
        _backView = [UIView new];
        _backView.backgroundColor = [UIColor whiteColor];
        [_shadowView addSubview:_backView];
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];

        _iconImageView = [UIImageView new];
        [_backView addSubview:_iconImageView];
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(16);
            make.centerX.equalTo(0);
            make.width.height.equalTo(32);
        }];
    }
    return _iconImageView;
}
-(UILabel *)namelb{
    if (!_namelb) {
        _namelb = [UILabel new];
        _namelb.textColor = [UIColor textBlackColor];
        _namelb.font = [UIFont systemFontOfSize:12];
        _namelb.textAlignment = NSTextAlignmentCenter;
        [_backView addSubview:_namelb];
        [_namelb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.bottom.equalTo(-16);
            make.height.equalTo(15);
        }];
    }
    return _namelb;
}
@end
