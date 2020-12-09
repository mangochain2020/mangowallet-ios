//
//  MarketCell.m
//  TaiYiToken
//
//  Created by Frued on 2018/8/15.
//  Copyright © 2018年 Frued. All rights reserved.
//

#import "MarketCell.h"

@implementation MarketCell

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
        if(_iconImageView){
            [_namelabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(40);
                make.centerY.equalTo(11);
                make.width.equalTo(100);
                make.height.equalTo(12);
            }];
        }else{
            [_namelabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(16);
                make.centerY.equalTo(11);
                make.width.equalTo(90);
                make.height.equalTo(12);
            }];
        }
      
        
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
        if(_iconImageView){
            [_coinNamelabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(40);
                make.centerY.equalTo(-7);
                make.width.equalTo(50);
                make.height.equalTo(20);
            }];
        }else{
            [_coinNamelabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(16);
                make.centerY.equalTo(-7);
                make.width.equalTo(50);
                make.height.equalTo(20);
            }];
        }
        
        
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
        if(_iconImageView){
            _coinNameDetaillabel.textAlignment = NSTextAlignmentLeft;
            [_coinNameDetaillabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(95);
                make.centerY.equalTo(-4);
                make.width.equalTo(50);
                make.height.equalTo(20);
            }];
        }else{
            _coinNameDetaillabel.textAlignment = NSTextAlignmentRight;
            [_coinNameDetaillabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(70);
                make.centerY.equalTo(-4);
                make.width.equalTo(35);
                make.height.equalTo(20);
            }];
        }
       
    }
    return _coinNameDetaillabel;
}
- (UILabel *)dollarPricelabel {
    if(_dollarPricelabel == nil) {
        _dollarPricelabel = [[UILabel alloc] init];
        _dollarPricelabel.textColor = [UIColor textBlackColor];
        _dollarPricelabel.font = [UIFont systemFontOfSize:15];
        _dollarPricelabel.textAlignment = NSTextAlignmentRight;
        _dollarPricelabel.numberOfLines = 1;
        [self addSubview:_dollarPricelabel];
        [_dollarPricelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(140);
            make.centerY.equalTo(-7);
            make.width.equalTo(100);
            make.height.equalTo(20);
        }];
        
    }
    return _dollarPricelabel;
}
- (UILabel *)rmbPricelabel {
    if(_rmbPricelabel == nil) {
        _rmbPricelabel = [[UILabel alloc] init];
        _rmbPricelabel.textColor = [UIColor grayColor];
        _rmbPricelabel.font = [UIFont boldSystemFontOfSize:10];
        _rmbPricelabel.textAlignment = NSTextAlignmentRight;
        _rmbPricelabel.numberOfLines = 1;
        [self addSubview:_rmbPricelabel];
        [_rmbPricelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(140);
            make.centerY.equalTo(11);
            make.width.equalTo(100);
            make.height.equalTo(20);
        }];
        
    }
    return _rmbPricelabel;
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
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
