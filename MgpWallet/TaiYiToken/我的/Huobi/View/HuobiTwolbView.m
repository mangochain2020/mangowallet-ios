//
//  HuobiTwolbView.m
//  TaiYiToken
//
//  Created by 张元一 on 2019/3/18.
//  Copyright © 2019 admin. All rights reserved.
//

#import "HuobiTwolbView.h"

@implementation HuobiTwolbView
// 40
-(UILabel *)toplb{
    if (!_toplb) {
        _toplb = [UILabel new];
        _toplb.textColor = [UIColor lightGrayColor];
        _toplb.font = [UIFont boldSystemFontOfSize:10];
        _toplb.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_toplb];
        [_toplb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.top.equalTo(5);
            make.right.equalTo(0);
            make.height.equalTo(20);
        }];
    }
    return _toplb;
}

-(UILabel *)bottomlb{
    if (!_bottomlb) {
        _bottomlb = [UILabel new];
        _bottomlb.textColor = [UIColor lightGrayColor];
        _bottomlb.font = [UIFont boldSystemFontOfSize:10];
        _bottomlb.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_bottomlb];
        [_bottomlb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.bottom.equalTo(-5);
            make.right.equalTo(0);
            make.height.equalTo(20);
        }];
    }
    return _bottomlb;
}
@end
