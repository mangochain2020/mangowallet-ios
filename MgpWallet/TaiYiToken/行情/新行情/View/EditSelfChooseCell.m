//
//  EditSelfChooseCell.m
//  TaiYiToken
//
//  Created by admin on 2018/10/12.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "EditSelfChooseCell.h"

@implementation EditSelfChooseCell
-(void)initBtns{
    [self chooseBtn];
    [self moveToTopBtn];
    //[self moveBtn];
}

- (UILabel *)namelabel {
    if(_namelabel == nil) {
        _namelabel = [[UILabel alloc] init];
        _namelabel.textColor = [UIColor grayColor];
        _namelabel.font = [UIFont systemFontOfSize:10];
        _namelabel.textAlignment = NSTextAlignmentLeft;
        _namelabel.numberOfLines = 1;
        [self addSubview:_namelabel];
        [_namelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(50);
            make.centerY.equalTo(11);
            make.width.equalTo(90);
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
        [self addSubview:_coinNamelabel];
        [_coinNamelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(50);
            make.centerY.equalTo(-4);
            make.width.equalTo(50);
            make.height.equalTo(20);
        }];
        
    }
    return _coinNamelabel;
}
- (UILabel *)coinNameDetaillabel {
    if(_coinNameDetaillabel == nil) {
        _coinNameDetaillabel = [[UILabel alloc] init];
        _coinNameDetaillabel.textColor = [UIColor grayColor];
        _coinNameDetaillabel.font = [UIFont systemFontOfSize:10];
        _coinNameDetaillabel.textAlignment = NSTextAlignmentLeft;
        _coinNameDetaillabel.numberOfLines = 1;
        [self addSubview:_coinNameDetaillabel];
        [_coinNameDetaillabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(100);
            make.centerY.equalTo(-1);
            make.width.equalTo(35);
            make.height.equalTo(20);
        }];
        
    }
    return _coinNameDetaillabel;
}

-(UIButton *)chooseBtn{
    if (!_chooseBtn) {
        _chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chooseBtn setImage:[UIImage imageNamed:@"wxz"] forState:UIControlStateNormal];
        [_chooseBtn setImage:[UIImage imageNamed:@"yxz"] forState:UIControlStateSelected];
        [self addSubview:_chooseBtn];
        [_chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(16);
            make.centerY.equalTo(0);
            make.width.equalTo(20);
            make.height.equalTo(20);
        }];
    }
    return _chooseBtn;
}

-(UIButton *)moveToTopBtn{
    if (!_moveToTopBtn) {
        _moveToTopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moveToTopBtn setImage:[UIImage imageNamed:@"zd"] forState:UIControlStateNormal];
        [self.contentView addSubview:_moveToTopBtn];
        [_moveToTopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(30);
            make.centerY.equalTo(0);
            make.width.equalTo(20);
            make.height.equalTo(20);
        }];
    }
    return _moveToTopBtn;
}

-(UIButton *)moveBtn{
    if (!_moveBtn) {
        _moveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moveBtn setImage:[UIImage imageNamed:@"td"] forState:UIControlStateNormal];
        [self.contentView addSubview:_moveBtn];
        [_moveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-16);
            make.centerY.equalTo(0);
            make.width.equalTo(20);
            make.height.equalTo(20);
        }];
    }
    return _moveBtn;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
