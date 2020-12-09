//
//  TransactionRecordCell.m
//  TaiYiToken
//
//  Created by admin on 2018/9/17.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "TransactionRecordCell.h"

@implementation TransactionRecordCell
-(UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
        _iconImageView.layer.cornerRadius = 12;
        _iconImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_iconImageView];
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.left.equalTo(18);
            make.width.height.equalTo(24);
        }];
    }
    return _iconImageView;
}


-(UILabel *)addresslb{
    if (!_addresslb) {
        _addresslb = [UILabel new];
        _addresslb.textColor = [UIColor textBlackColor];
        _addresslb.font = [UIFont boldSystemFontOfSize:12];
        _addresslb.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_addresslb];
        [_addresslb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(50);
            make.top.equalTo(16);
            make.width.equalTo(200);
            make.height.equalTo(20);
        }];
    }
    return _addresslb;
}

-(UILabel *)timelb{
    if (!_timelb) {
        _timelb = [UILabel new];
        _timelb.textColor = [UIColor textLightGrayColor];
        _timelb.font = [UIFont boldSystemFontOfSize:9];
        _timelb.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_timelb];
        [_timelb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(50);
            make.bottom.equalTo(-16);
            make.width.equalTo(200);
            make.height.equalTo(10);
        }];
    }
    return _timelb;
}

-(UILabel *)amountlb{
    if (!_amountlb) {
        _amountlb = [UILabel new];
        _amountlb.textColor = [UIColor textBlueColor];
        _amountlb.font = [UIFont boldSystemFontOfSize:11];
        _amountlb.textAlignment = NSTextAlignmentRight;
        _amountlb.numberOfLines = 0;
        [self.contentView addSubview:_amountlb];
        [_amountlb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-16);
            make.top.equalTo(12);
            make.width.equalTo(200);
            make.height.equalTo(30);
        }];
    }
    return _amountlb;
}

-(UILabel *)resultlb{
    if (!_resultlb) {
        _resultlb = [UILabel new];
        _resultlb.textColor = [UIColor textLightGrayColor];
        _resultlb.font = [UIFont boldSystemFontOfSize:9];
        _resultlb.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_resultlb];
        [_resultlb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-16);
            make.bottom.equalTo(-16);
            make.width.equalTo(100);
            make.height.equalTo(10);
        }];
    }
    return _resultlb;
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
