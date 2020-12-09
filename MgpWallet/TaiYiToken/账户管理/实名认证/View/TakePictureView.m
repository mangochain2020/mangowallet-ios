//
//  TakePictureView.m
//  TaiYiToken
//
//  Created by Frued on 2018/10/19.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "TakePictureView.h"

@implementation TakePictureView

-(UILabel *)titlelabel{
    if (!_titlelabel) {
        self.backgroundColor = [UIColor whiteColor];
        _titlelabel = [UILabel new];
        _titlelabel.textColor = [UIColor textDarkColor];
        _titlelabel.font = [UIFont systemFontOfSize:15];
        _titlelabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_titlelabel];
        [_titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.left.equalTo(16);
            make.width.equalTo(200);
            make.height.equalTo(20);
        }];
    }
    return _titlelabel;
}

-(UILabel *)detaillabel{
    if (!_detaillabel) {
        _detaillabel = [UILabel new];
        _detaillabel.textColor = [UIColor textGrayColor];
        _detaillabel.font = [UIFont systemFontOfSize:12];
        _detaillabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_detaillabel];
        [_detaillabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.right.equalTo(-50);
            make.width.equalTo(100);
            make.height.equalTo(20);
        }];
    }
    return _detaillabel;
}

-(UIButton *)photoBtn{
    if (!_photoBtn) {
        _photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _photoBtn.backgroundColor = [UIColor clearColor];
        _photoBtn.tintColor = [UIColor whiteColor];
        [_photoBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [_photoBtn setImage:[UIImage imageNamed:@"photo-b-vv"] forState:UIControlStateNormal];
        [self addSubview:_photoBtn];
        _photoBtn.userInteractionEnabled = YES;
        [_photoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.right.equalTo(-16);
            make.width.equalTo(18);
            make.height.equalTo(18);
        }];
    }
    return _photoBtn;
}
@end
