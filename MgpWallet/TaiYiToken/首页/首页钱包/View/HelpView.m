//
//  HelpView.m
//  TaiYiToken
//
//  Created by 张元一 on 2018/11/12.
//  Copyright © 2018 admin. All rights reserved.
//

#import "HelpView.h"

@implementation HelpView
-(UIImageView *)img0{
    if (!_img0) {
        _img0 = [UIImageView new];
        _img0.backgroundColor = [UIColor clearColor];
        _img0.image = [UIImage imageNamed:@"T3"];
        _img0.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_img0];
        [_img0 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(20);
            make.top.equalTo(SafeAreaTopHeight - 4);
            make.width.equalTo(70);
            make.height.equalTo(30);
        }];
    }
    return _img0;
}
-(UIImageView *)img1{
    if (!_img1) {
        _img1 = [UIImageView new];
        _img1.image = [UIImage imageNamed:@"T2"];
        _img1.backgroundColor = [UIColor clearColor];
        _img1.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_img1];
        [_img1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-20);
            make.top.equalTo(SafeAreaTopHeight - 4);
            make.width.equalTo(43);
            make.height.equalTo(36);
        }];
    }
    return _img1;
}
-(UIImageView *)img2{
    if (!_img2) {
        _img2 = [UIImageView new];
        _img2.image = [UIImage imageNamed:@"T5"];
        _img2.backgroundColor = [UIColor clearColor];
        _img2.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_img2];
        [_img2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(SafeAreaTopHeight + 261);
            make.left.right.equalTo(0);
            make.height.equalTo(65);
        }];
    }
    return _img2;
}

-(UIImageView *)img3{
    if (!_img3) {
        _img3 = [UIImageView new];
        _img3.alpha = 0;
        _img3.image = [UIImage imageNamed:@"T4"];
        _img3.backgroundColor = [UIColor clearColor];
        _img3.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:_img3];
        [_img3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-30);
            make.top.equalTo(SafeAreaTopHeight + 31);
            make.width.equalTo(80);
            make.height.equalTo(32);
        }];
    }
    return _img3;
}

-(UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_backBtn setBackgroundColor:kRGBA(200, 200, 200, 0.4)];
        [self addSubview:_backBtn];
        [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
    }
    return _backBtn;
}
@end
