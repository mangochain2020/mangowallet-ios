//
//  MarketThreeBtnView.m
//  TaiYiToken
//
//  Created by admin on 2018/10/11.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "MarketThreeBtnView.h"
#define BTNSFONTSIZE 13
@implementation MarketThreeBtnView

-(UIButton *)firstBtnWithTitile:(NSString *)title ifHasImages:(BOOL)ifHasImages{
    if (!_firstBtn) {
        self.backgroundColor = [UIColor whiteColor];
        _firstBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_firstBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _firstBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        _firstBtn.titleLabel.font = [UIFont systemFontOfSize:BTNSFONTSIZE];
        [self addSubview:_firstBtn];
        [_firstBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(0);
            make.left.equalTo(0);
            make.width.equalTo(80);
            make.height.equalTo(30);
        }];
        _iv0 = [UIImageView new];
        _iv0.image = [UIImage imageNamed:@"bj-x"];
        [self addSubview:_iv0];
        [_iv0 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.firstBtn.mas_right).equalTo(-15);
            make.centerY.equalTo(2);
            make.width.equalTo(10);
            make.height.equalTo(10);
        }];
    }
    [_firstBtn setTitle:NSLocalizedString(title, nil) forState:UIControlStateNormal];
    if (ifHasImages == YES) {
        _iv0.hidden = NO;
    }else{
        _iv0.hidden = YES;
    }
    return _firstBtn;
}

-(UIButton *)secondBtnWithTitle:(NSString *)title ifHasImages:(BOOL)ifHasImages  SelectTYpe:(BTN_SELECT_TYPE)selectType{
    if (!_secondBtn) {
        _secondBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _secSelectType = NONE_SELECT;
        [_secondBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _secondBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        _secondBtn.titleLabel.font = [UIFont systemFontOfSize:BTNSFONTSIZE];
        [self addSubview:_secondBtn];
        [_secondBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(0);
            make.left.equalTo(ScreenWidth/2 - 30);
            make.width.equalTo(80);
            make.height.equalTo(30);
        }];
        _iv10 = [UIImageView new];
        _iv10.image = [UIImage imageNamed:@"ico_up_default"];
        _iv11 = [UIImageView new];
        _iv11.image = [UIImage imageNamed:@"ico_down_default"];
        [self addSubview:_iv10];
        [_iv10 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(-4);
            make.left.equalTo(ScreenWidth/2+50);
            make.width.equalTo(8);
            make.height.equalTo(5);
        }];
        [self addSubview:_iv11];
        [_iv11 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(4);
            make.left.equalTo(ScreenWidth/2+50);
            make.width.equalTo(8);
            make.height.equalTo(5);
        }];
    }
    [_secondBtn setTitle:NSLocalizedString(title, nil) forState:UIControlStateNormal];
    if (ifHasImages == YES) {
        _iv10.hidden = NO;
        _iv11.hidden = NO;
        if (selectType == NONE_SELECT) {
            _secSelectType = NONE_SELECT;
            _iv10.image = [UIImage imageNamed:@"ico_up_default"];
            _iv11.image = [UIImage imageNamed:@"ico_down_default"];
        }else if (selectType == UP_SELECT){
            _secSelectType = UP_SELECT;
            _iv10.image = [UIImage imageNamed:@"ico_up_select"];
            _iv11.image = [UIImage imageNamed:@"ico_down_default"];
        }else if (selectType == DOWN_SELECT){
            _secSelectType = DOWN_SELECT;
            _iv10.image = [UIImage imageNamed:@"ico_up_default"];
            _iv11.image = [UIImage imageNamed:@"ico_down_select"];
        }else{//不指定这三种 按顺序+1
            _secSelectType = (_secSelectType + 1) % 3;
            if (_secSelectType == NONE_SELECT) {
                _iv10.image = [UIImage imageNamed:@"ico_up_default"];
                _iv11.image = [UIImage imageNamed:@"ico_down_default"];
            }else if (_secSelectType == UP_SELECT){
                _iv10.image = [UIImage imageNamed:@"ico_up_select"];
                _iv11.image = [UIImage imageNamed:@"ico_down_default"];
            }else if (_secSelectType == DOWN_SELECT){
                _iv10.image = [UIImage imageNamed:@"ico_up_default"];
                _iv11.image = [UIImage imageNamed:@"ico_down_select"];
            }
        }
    }else{
        _secSelectType = 0;
        _iv10.hidden = YES;
        _iv11.hidden = YES;
    }
    return _secondBtn;
}

-(UIButton *)thirdBtnWithTitle:(NSString *)title ifHasImages:(BOOL)ifHasImages  SelectTYpe:(BTN_SELECT_TYPE)selectType{
    if (!_thirdBtn) {
        _thirdBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _thirSelectType = NONE_SELECT;
        [_thirdBtn setTitle:NSLocalizedString(title, nil) forState:UIControlStateNormal];
        [_thirdBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _thirdBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _thirdBtn.titleLabel.font = [UIFont systemFontOfSize:BTNSFONTSIZE];
        [self addSubview:_thirdBtn];
        [_thirdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(0);
            make.right.equalTo(-20);
            make.width.equalTo(80);
            make.height.equalTo(30);
        }];
        _iv20 = [UIImageView new];
        _iv20.image = [UIImage imageNamed:@"ico_up_default"];
        _iv21 = [UIImageView new];
        _iv21.image = [UIImage imageNamed:@"ico_down_default"];
        [self addSubview:_iv20];
        [_iv20 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(-4);
            make.right.equalTo(-10);
            make.width.equalTo(8);
            make.height.equalTo(5);
        }];
        [self addSubview:_iv21];
        [_iv21 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(4);
            make.right.equalTo(-10);
            make.width.equalTo(8);
            make.height.equalTo(5);
        }];
    }
    [_thirdBtn setTitle:NSLocalizedString(title, nil) forState:UIControlStateNormal];
    if (ifHasImages == YES) {
        _iv20.hidden = NO;
        _iv21.hidden = NO;
        if (selectType == NONE_SELECT) {
            _thirSelectType = NONE_SELECT;
            _iv20.image = [UIImage imageNamed:@"ico_up_default"];
            _iv21.image = [UIImage imageNamed:@"ico_down_default"];
        }else if (selectType == UP_SELECT){
            _thirSelectType = UP_SELECT;
            _iv20.image = [UIImage imageNamed:@"ico_up_select"];
            _iv21.image = [UIImage imageNamed:@"ico_down_default"];
        }else if (selectType == DOWN_SELECT){
            _thirSelectType = DOWN_SELECT;
            _iv20.image = [UIImage imageNamed:@"ico_up_default"];
            _iv21.image = [UIImage imageNamed:@"ico_down_select"];
        }else{//不指定这三种 按顺序+1
            _thirSelectType = (_thirSelectType + 1) % 3;
            if (_thirSelectType == NONE_SELECT) {
                _iv20.image = [UIImage imageNamed:@"ico_up_default"];
                _iv21.image = [UIImage imageNamed:@"ico_down_default"];
            }else if (_thirSelectType == UP_SELECT){
                _iv20.image = [UIImage imageNamed:@"ico_up_select"];
                _iv21.image = [UIImage imageNamed:@"ico_down_default"];
            }else if (_thirSelectType == DOWN_SELECT){
                _iv20.image = [UIImage imageNamed:@"ico_up_default"];
                _iv21.image = [UIImage imageNamed:@"ico_down_select"];
            }
        }
       
    }else{
        _thirSelectType = 0;
        _iv20.hidden = YES;
        _iv21.hidden = YES;
    }
    return _thirdBtn;
}


@end
