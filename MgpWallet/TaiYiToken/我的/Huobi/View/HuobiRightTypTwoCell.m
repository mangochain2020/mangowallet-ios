//
//  HuobiRightTypTwoCell.m
//  TaiYiToken
//
//  Created by 张元一 on 2019/3/15.
//  Copyright © 2019 admin. All rights reserved.
//

#import "HuobiRightTypTwoCell.h"

@implementation HuobiRightTypTwoCell

-(UILabel *)leftlb{
    if (!_leftlb) {
        _leftlb = [UILabel new];
        _leftlb.textColor = [UIColor darkappRedColor];
        _leftlb.font = [UIFont boldSystemFontOfSize:10];
        _leftlb.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_leftlb];
        [_leftlb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(5);
            make.top.equalTo(0);
            make.width.equalTo(150);
            make.bottom.equalTo(0);
        }];
    }
    return _leftlb;
}

-(UILabel *)rightlb{
    if (!_rightlb) {
        _rightlb = [UILabel new];
        _rightlb.textColor = [UIColor darkappGreenColor];
        _rightlb.font = [UIFont boldSystemFontOfSize:10];
        _rightlb.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_rightlb];
        [_rightlb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-5);
            make.top.equalTo(0);
            make.width.equalTo(100);
            make.bottom.equalTo(0);
        }];
    }
    return _rightlb;
}
@end
