//
//  UserConfigCell.m
//  TaiYiToken
//
//  Created by admin on 2018/9/25.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "UserConfigCell.h"

@implementation UserConfigCell
-(UIImageView *)checkIv{
    if (!_checkIv) {
        _checkIv = [UIImageView new];
        _checkIv.image = [UIImage imageNamed:@"ico_check_select"];
        [self.contentView addSubview:_checkIv];
        [_checkIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(16);
            make.height.equalTo(16);
            make.right.equalTo(-16);
            make.centerY.equalTo(0);
        }];
    }
    return _checkIv;
}
-(UIImageView *)rightIconIv{
    if (!_rightIconIv) {
        _rightIconIv = [UIImageView new];
        _rightIconIv.image = [UIImage imageNamed:@"ico_left_arrow-z"];
        [self.contentView addSubview:_rightIconIv];
        [_rightIconIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(16);
            make.height.equalTo(16);
            make.right.equalTo(-16);
            make.centerY.equalTo(0);
        }];
    }
    return _rightIconIv;
}
-(UISwitch *)switchBtn{
    if (!_switchBtn) {
        _switchBtn = [UISwitch new];
        _switchBtn.onTintColor = [UIColor appBlueColor];
        [self.contentView addSubview:_switchBtn];
        [_switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(32);
            make.height.equalTo(16);
            make.right.equalTo(-30);
            make.centerY.equalTo(-5);
        }];
    }
    return _switchBtn;
}
-(UILabel *)textlb{
    if (!_textlb) {
        _textlb = [UILabel new];
        _textlb.textColor = [UIColor textBlackColor];
        _textlb.font = [UIFont systemFontOfSize:15];
        _textlb.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_textlb];
        [_textlb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(150);
            make.height.equalTo(20);
            make.left.equalTo(16);
            make.centerY.equalTo(0);
        }];
    }
    return _textlb;
}
-(UILabel *)detailtextlb{
    if (!_detailtextlb) {
        _detailtextlb = [UILabel new];
        _detailtextlb.textColor = [UIColor textGrayColor];
        _detailtextlb.font = [UIFont systemFontOfSize:15];
        _detailtextlb.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_detailtextlb];
        [_detailtextlb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(200);
            make.height.equalTo(16);
            make.right.equalTo(-35);
            make.centerY.equalTo(0);
        }];
    }
    return _detailtextlb;
}
@end
