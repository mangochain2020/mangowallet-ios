//
//  ImageTextCell.m
//  TaiYiToken
//
//  Created by admin on 2018/9/25.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "ImageTextCell.h"

@implementation ImageTextCell
-(UIImageView *)iconiv{
    if (!_iconiv) {
        _iconiv = [UIImageView new];
        _iconiv.layer.cornerRadius = 14;
        _iconiv.layer.masksToBounds = YES;
        _iconiv.layer.borderColor = [UIColor blackColor].CGColor;
        _iconiv.layer.borderWidth = 2;
        _iconiv.layer.borderColor = [UIColor blackColor].CGColor;
        [self.contentView addSubview:_iconiv];
        [_iconiv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(18);
            make.height.equalTo(16);
            make.left.equalTo(16);
            make.centerY.equalTo(0);
        }];
    }
    return _iconiv;
}
-(UILabel *)textlb{
    if (!_textlb) {
        _textlb = [UILabel new];
        _textlb.textColor = [UIColor textBlackColor];
        _textlb.font = [UIFont systemFontOfSize:15];
        _textlb.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_textlb];
        [_textlb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(200);
//            make.height.equalTo(18);
            make.left.equalTo(46);
            make.top.equalTo(0);
            make.bottom.equalTo(0);

//            make.centerY.equalTo(0);
        }];
        
        UIImageView *rightiv = [UIImageView new];
        rightiv.image = [UIImage imageNamed:@"ico_left_arrow-z"];
        [self.contentView addSubview:rightiv];
        [rightiv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(16);
//            make.height.equalTo(16);
            make.right.equalTo(-16);
            make.centerY.equalTo(0);

        }];
        
    }
    return _textlb;
}

-(UILabel *)detaillb{
    if (!_detaillb) {
        _detaillb = [UILabel new];
        _detaillb.textColor = [UIColor redColor];
        _detaillb.font = [UIFont systemFontOfSize:10];
        _detaillb.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_detaillb];
        [_detaillb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(150);
//            make.height.equalTo(18);
            make.right.equalTo(-40);
//            make.centerY.equalTo(0);
            make.top.equalTo(0);
                    make.bottom.equalTo(0);

        }];
    }
    return _detaillb;
}
@end
