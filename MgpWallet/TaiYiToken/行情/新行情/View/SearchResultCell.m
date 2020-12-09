//
//  SearchResultCell.m
//  TaiYiToken
//
//  Created by 张元一 on 2018/11/13.
//  Copyright © 2018 admin. All rights reserved.
//

#import "SearchResultCell.h"

@implementation SearchResultCell

-(UILabel *)symbollb{
    if(_symbollb == nil) {
        self.backgroundColor = [UIColor whiteColor];
        _symbollb = [[UILabel alloc] init];
        _symbollb.textColor = [UIColor textBlackColor];
        _symbollb.font = [UIFont boldSystemFontOfSize:15];
        _symbollb.textAlignment = NSTextAlignmentLeft;
        _symbollb.numberOfLines = 1;
        [self.contentView addSubview:_symbollb];
        [_symbollb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(17);
            make.centerY.equalTo(0);
            make.width.equalTo(200);
            make.height.equalTo(18);
        }];
    }
    return _symbollb;
}

-(UIButton *)controlBtn{
    if (!_controlBtn) {
        _controlBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_controlBtn setImage:[UIImage imageNamed:@"add0"] forState:UIControlStateSelected];
        [_controlBtn setImage:[UIImage imageNamed:@"sub0"] forState:UIControlStateNormal];//默认减号
        [self addSubview:_controlBtn];
        [_controlBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-16);
            make.centerY.equalTo(0);
            make.width.equalTo(30);
            make.height.equalTo(30);
        }];
    }
    return _controlBtn;
}
@end
