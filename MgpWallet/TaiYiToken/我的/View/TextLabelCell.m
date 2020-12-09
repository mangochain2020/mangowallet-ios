//
//  TextLabelCell.m
//  TaiYiToken
//
//  Created by 张元一 on 2018/10/31.
//  Copyright © 2018 admin. All rights reserved.
//

#import "TextLabelCell.h"

@implementation TextLabelCell
-(UILabel *)textlb{
    if (!_textlb) {
        _textlb = [UILabel new];
        _textlb.textColor = [UIColor textBlackColor];
        _textlb.font = [UIFont systemFontOfSize:14];
        _textlb.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_textlb];
        [_textlb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(100);
            make.height.equalTo(16);
            make.left.equalTo(16);
            make.centerY.equalTo(0);
        }];
    }
    return _textlb;
}
-(UILabel *)detaillb{
    if (!_detaillb) {
        _detaillb = [UILabel new];
        _detaillb.textColor = [UIColor textBlueColor];
        _detaillb.font = [UIFont systemFontOfSize:14];
        _detaillb.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_detaillb];
        [_detaillb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(250);
            make.height.equalTo(16);
            make.right.equalTo(-16);
            make.centerY.equalTo(0);
        }];
        
    }
    return _detaillb;
}

@end
