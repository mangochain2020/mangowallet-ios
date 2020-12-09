//
//  BuySaleRecordCell.m
//  TaiYiToken
//
//  Created by Frued on 2018/10/16.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "BuySaleRecordCell.h"

@implementation BuySaleRecordCell


- (UILabel *)buyAmoutlb {
    if(_buyAmoutlb == nil) {
        self.backgroundColor = [UIColor whiteColor];
        _buyAmoutlb = [[UILabel alloc] init];
        _buyAmoutlb.textAlignment = NSTextAlignmentLeft;
        _buyAmoutlb.numberOfLines = 1;
        [self addSubview:_buyAmoutlb];
        [_buyAmoutlb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(10);
            make.centerY.equalTo(0);
            make.width.equalTo((ScreenWidth - 50)/4);
            make.height.equalTo(15);
        }];
    }
    return _buyAmoutlb;
}

- (UILabel *)buyPricelb {
    if(_buyPricelb == nil) {
        self.backgroundColor = [UIColor whiteColor];
        _buyPricelb = [[UILabel alloc] init];
        _buyPricelb.textAlignment = NSTextAlignmentRight;
        _buyPricelb.numberOfLines = 1;
        [self addSubview:_buyPricelb];
        [_buyPricelb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ScreenWidth/2.0 - (ScreenWidth - 50)/4 - 10);
            make.centerY.equalTo(0);
            make.width.equalTo((ScreenWidth - 50)/4);
            make.height.equalTo(15);
        }];
        
        UIView *line = [UIView new];
        line.backgroundColor = [UIColor lineGrayColor];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.top.bottom.equalTo(0);
            make.width.equalTo(0.5);
        }];
    }
    _buyPricelb.font = [UIFont systemFontOfSize:13];
    return _buyPricelb;
}

- (UILabel *)saleAmoutlb {
    if(_saleAmoutlb == nil) {
        self.backgroundColor = [UIColor whiteColor];
        _saleAmoutlb = [[UILabel alloc] init];
        _saleAmoutlb.textAlignment = NSTextAlignmentRight;
        _saleAmoutlb.numberOfLines = 1;
        [self addSubview:_saleAmoutlb];
        [_saleAmoutlb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-10);
            make.centerY.equalTo(0);
            make.width.equalTo((ScreenWidth - 50)/4);
            make.height.equalTo(15);
        }];
    }
    return _saleAmoutlb;
}

- (UILabel *)salePricelb {
    if(_salePricelb == nil) {
        self.backgroundColor = [UIColor whiteColor];
        _salePricelb = [[UILabel alloc] init];
        _salePricelb.textAlignment = NSTextAlignmentLeft;
        _salePricelb.numberOfLines = 1;
        [self addSubview:_salePricelb];
        [_salePricelb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(- ScreenWidth/2.0 + (ScreenWidth - 50)/4 + 10);
            make.centerY.equalTo(0);
            make.width.equalTo((ScreenWidth - 50)/4);
            make.height.equalTo(15);
        }];
    }
    return _salePricelb;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
