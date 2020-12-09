//
//  UserInfoHeadView.m
//  TaiYiToken
//
//  Created by admin on 2018/9/25.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "UserInfoHeadView.h"

@implementation UserInfoHeadView
-(UIButton *)headbtn{
    if(_headbtn == nil){
        _headbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _headbtn.backgroundColor = [UIColor whiteColor];
        _headbtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _headbtn.userInteractionEnabled = YES;
        _headbtn.layer.cornerRadius = 27;
        _headbtn.layer.masksToBounds = YES;
        [self addSubview:_headbtn];
        [_headbtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(54);
            make.left.equalTo(16);
            make.centerY.equalTo(0);
        }];
    }
    return _headbtn;
}

-(UIButton *)usernamebtn{
    if (!_usernamebtn) {
        _usernamebtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _usernamebtn.tintColor = [UIColor textBlackColor];
        _usernamebtn.titleLabel.textColor = [UIColor textBlackColor];
        _usernamebtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:_usernamebtn];
        [_usernamebtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(90);
            make.centerY.equalTo(0);
            make.width.equalTo(100);
            make.height.equalTo(20);
        }];
        
    }
    return _usernamebtn;
}
-(UILabel *)titlelb{
    if (!_titlelb) {
        _titlelb = [UILabel new];
        _titlelb.textColor = [UIColor textGrayColor];
        _titlelb.font = [UIFont systemFontOfSize:10];
        _titlelb.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_titlelb];
        [_titlelb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(90);
            make.top.equalTo(70);
            make.right.equalTo(-20);
            make.height.equalTo(20);
        }];
        
    }
    return _titlelb;
}


@end
