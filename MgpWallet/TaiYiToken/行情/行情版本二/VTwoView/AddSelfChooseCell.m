//
//  AddSelfChooseCell.m
//  TaiYiToken
//
//  Created by 张元一 on 2018/11/26.
//  Copyright © 2018 admin. All rights reserved.
//

#import "AddSelfChooseCell.h"

@implementation AddSelfChooseCell
-(UIImageView *)iconIV{
    if(!_iconIV){
        _iconIV = [UIImageView new];
        _iconIV.tintColor = [UIColor grayColor];
        [self.contentView addSubview:_iconIV];
        [_iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.left.equalTo(ScreenWidth/2 - 40);
            make.height.width.equalTo(15);
        }];
    }
    return _iconIV;
}

- (UILabel *)namelb {
    if(_namelb == nil) {
        _namelb = [[UILabel alloc] init];
        _namelb.textColor = [UIColor grayColor];
        _namelb.font = [UIFont systemFontOfSize:14];
        _namelb.textAlignment = NSTextAlignmentLeft;
        _namelb.numberOfLines = 1;
        [self.contentView addSubview:_namelb];
        [_namelb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ScreenWidth/2 - 20);
            make.centerY.equalTo(0);
            make.width.equalTo(100);
            make.height.equalTo(12);
        }];
    }
    return _namelb;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
