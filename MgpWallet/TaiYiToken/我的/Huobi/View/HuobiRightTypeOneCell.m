//
//  HuobiRightTypeOneCell.m
//  TaiYiToken
//
//  Created by 张元一 on 2019/3/15.
//  Copyright © 2019 admin. All rights reserved.
//

#import "HuobiRightTypeOneCell.h"

@implementation HuobiRightTypeOneCell

-(UILabel *)toplb{
    if (!_toplb) {
        _toplb = [UILabel new];
        _toplb.textColor = [UIColor darkappRedColor];
        _toplb.font = [UIFont boldSystemFontOfSize:15];
        _toplb.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_toplb];
        [_toplb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.top.equalTo(5);
            make.right.equalTo(0);
            make.height.equalTo(18);
        }];
    }
    return _toplb;
}

-(UILabel *)bottomlb{
    if (!_bottomlb) {
        _bottomlb = [UILabel new];
        _bottomlb.textColor = [UIColor lightGrayColor];
        _bottomlb.font = [UIFont systemFontOfSize:9];
        _bottomlb.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_bottomlb];
        [_bottomlb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.bottom.equalTo(-5);
            make.right.equalTo(0);
            make.height.equalTo(10);
        }];
    }
    return _bottomlb;
}
@end
