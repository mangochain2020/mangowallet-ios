//
//  VTwoMarketListCell.m
//  TaiYiToken
//
//  Created by 张元一 on 2018/11/21.
//  Copyright © 2018 admin. All rights reserved.
//

#import "VTwoMarketListCell.h"

@implementation VTwoMarketListCell
-(UIImageView *)iconImageView{
    if(!_iconImageView){
        _iconImageView = [UIImageView new];
        _iconImageView.layer.cornerRadius = 10;
        _iconImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_iconImageView];
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.left.equalTo(10);
            make.height.width.equalTo(20);
        }];
    }
    return _iconImageView;
}

- (UILabel *)namelabel {
    if(_namelabel == nil) {
        _namelabel = [[UILabel alloc] init];
        _namelabel.textColor = [UIColor grayColor];
        _namelabel.font = [UIFont systemFontOfSize:10];
        _namelabel.textAlignment = NSTextAlignmentLeft;
        _namelabel.numberOfLines = 1;
        [self.contentView addSubview:_namelabel];
        [_namelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(40);
            make.top.equalTo(5);
            make.width.equalTo(200);
            make.height.equalTo(12);
        }];
    }
    return _namelabel;
}
- (UILabel *)coinNamelabel {
    if(_coinNamelabel == nil) {
        _coinNamelabel = [[UILabel alloc] init];
        _coinNamelabel.textColor = [UIColor textBlackColor];
        _coinNamelabel.font = [UIFont boldSystemFontOfSize:15];
        _coinNamelabel.textAlignment = NSTextAlignmentLeft;
        _coinNamelabel.numberOfLines = 1;
        [self.contentView addSubview:_coinNamelabel];
        [_coinNamelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(40);
            make.centerY.equalTo(0);
            make.width.equalTo(200);
            make.height.equalTo(17);
        }];
    }
    return _coinNamelabel;
}
- (UILabel *)coinNameDetaillabel {
    if(_coinNameDetaillabel == nil) {
        _coinNameDetaillabel = [[UILabel alloc] init];
        _coinNameDetaillabel.textColor = [UIColor grayColor];
        _coinNameDetaillabel.font = [UIFont systemFontOfSize:10];
        _coinNameDetaillabel.numberOfLines = 1;
        [self.contentView addSubview:_coinNameDetaillabel];
        _coinNameDetaillabel.textAlignment = NSTextAlignmentLeft;
        [_coinNameDetaillabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(40);
            make.bottom.equalTo(-5);
            make.width.equalTo(130);
            make.height.equalTo(12);
        }];
    }
    return _coinNameDetaillabel;
}
- (UILabel *)pricelabel {
    if(_pricelabel == nil) {
        _pricelabel = [[UILabel alloc] init];
        _pricelabel.textColor = [UIColor textBlackColor];
        _pricelabel.font = [UIFont systemFontOfSize:15];
        _pricelabel.textAlignment = NSTextAlignmentRight;
        _pricelabel.numberOfLines = 1;
        [self addSubview:_pricelabel];
        [_pricelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(100);
            make.centerY.equalTo(0);
            make.width.equalTo(140);
            make.height.equalTo(20);
        }];
    }
    return _pricelabel;
}

-(UIButton *)rateBtn{
    if(_rateBtn == nil){
        _rateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rateBtn.backgroundColor = RGB(255, 130, 130);
        _rateBtn.layer.cornerRadius = 3;
        _rateBtn.layer.masksToBounds = YES;
        _rateBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _rateBtn.userInteractionEnabled = YES;
        [self.contentView addSubview:_rateBtn];
        [_rateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-10);
            make.centerY.equalTo(0);
            make.width.equalTo(100);
            make.height.equalTo(30);
        }];
    }
    return _rateBtn;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
