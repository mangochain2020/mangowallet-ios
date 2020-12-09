//
//  AddBTCAddressCell.m
//  TaiYiToken
//
//  Created by admin on 2018/9/5.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "AddBTCAddressCell.h"

@implementation AddBTCAddressCell
-(UILabel *)addresslb{
    if (!_addresslb) {
        _addresslb = [UILabel new];
        _addresslb.textColor = [UIColor textBlackColor];
        _addresslb.font = [UIFont boldSystemFontOfSize:15];
        _addresslb.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_addresslb];
        [_addresslb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(27);
            make.top.equalTo(15);
            make.right.equalTo(-30);
            make.height.equalTo(20);
        }];
    }
    return _addresslb;
}
-(UILabel *)xpubIndexlb{
    if (!_xpubIndexlb) {
        _xpubIndexlb = [UILabel new];
        _xpubIndexlb.textColor = [UIColor textGrayColor];
        _xpubIndexlb.font = [UIFont boldSystemFontOfSize:12];
        _xpubIndexlb.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_xpubIndexlb];
        [_xpubIndexlb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(28);
            make.bottom.equalTo(-10);
            make.width.equalTo(80);
            make.height.equalTo(20);
        }];
    }
    return _xpubIndexlb;
}
-(UIButton *)selectBtn{
    if (!_selectBtn) {
        _selectBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        [_selectBtn setImage:[UIImage imageNamed:@"ico_check_select"] forState:UIControlStateSelected];
        [self.contentView addSubview:_selectBtn];
        [_selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-10);
            make.centerY.equalTo(0);
            make.width.equalTo(16);
            make.height.equalTo(13);
        }];
    }
    return _selectBtn;
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
