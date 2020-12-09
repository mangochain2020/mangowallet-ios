//
//  HomePageVTwoCell.m
//  TaiYiToken
//
//  Created by 张元一 on 2019/4/24.
//  Copyright © 2019 admin. All rights reserved.
//

#import "HomePageVTwoCell.h"

@implementation HomePageVTwoCell

-(UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
        [self.swipeContentView addSubview:_iconImageView];
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(16);
            make.centerY.equalTo(0);
            make.width.height.equalTo(20);
        }];
    }
    return _iconImageView;
}
-(UILabel *)symbolNamelb{
    if (!_symbolNamelb) {
        _symbolNamelb = [UILabel new];
        _symbolNamelb.textColor = [UIColor textBlackColor];
        _symbolNamelb.font = [UIFont boldSystemFontOfSize:17];
        _symbolNamelb.textAlignment = NSTextAlignmentLeft;
        [self.swipeContentView addSubview:_symbolNamelb];
        [_symbolNamelb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(40);
            make.centerY.equalTo(0);
            make.width.equalTo(55);
            make.height.equalTo(15);
        }];
    }
    return _symbolNamelb;
}
-(UILabel *)symboldetaillb{
    if (!_symboldetaillb) {
        _symboldetaillb = [UILabel new];
        _symboldetaillb.textColor = [UIColor textLightGrayColor];
        _symboldetaillb.font = [UIFont systemFontOfSize:9];
        _symboldetaillb.textAlignment = NSTextAlignmentLeft;
        [self.swipeContentView addSubview:_symboldetaillb];
    }
    [_symboldetaillb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(95);
        make.centerY.equalTo(3);
        make.width.equalTo(50);
        make.height.equalTo(12);
    }];
    
    return _symboldetaillb;
}

- (UILabel *)amountlb {
    if(_amountlb == nil) {
        _amountlb = [[UILabel alloc] init];
        _amountlb.textColor = [UIColor blackColor];
        _amountlb.font = [UIFont boldSystemFontOfSize:15];
        _amountlb.textAlignment = NSTextAlignmentRight;
        _amountlb.numberOfLines = 1;
        [self.swipeContentView addSubview:_amountlb];
        [_amountlb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(-7);
            make.right.equalTo(-40);
            make.width.equalTo(110);
            make.height.equalTo(20);
        }];
    }
    return _amountlb;
}

- (UILabel *)rmbvaluelb {
    if(_rmbvaluelb == nil) {
        _rmbvaluelb = [[UILabel alloc] init];
        _rmbvaluelb.textColor = [UIColor textGrayColor];
        _rmbvaluelb.font = [UIFont boldSystemFontOfSize:10];
        _rmbvaluelb.textAlignment = NSTextAlignmentRight;
        _rmbvaluelb.numberOfLines = 1;
        [self.swipeContentView addSubview:_rmbvaluelb];
        [_rmbvaluelb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(-16);
            make.right.equalTo(-40);
            make.width.equalTo(90);
            make.height.equalTo(12);
        }];
        [self closeBtn];
    }
    return _rmbvaluelb;
}

-(UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        _closeBtn.userInteractionEnabled = YES;
        _closeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        [_closeBtn setImage:[UIImage imageNamed:@"ico_dw_arrow-z"] forState:UIControlStateNormal];
        _closeBtn.imageView.contentMode = UIViewContentModeCenter;
        [self addSubview:_closeBtn];
        [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-5);
            make.centerY.equalTo(0);
            make.width.equalTo(15);
            make.height.equalTo(15);
        }];
    }
    return _closeBtn;
}

@end
