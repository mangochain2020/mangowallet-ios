//
//  TransactionGasView.m
//  TaiYiToken
//
//  Created by admin on 2018/9/13.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "TransactionGasView.h"

@implementation TransactionGasView

-(void)initUI{
    self.backgroundColor = [UIColor whiteColor];
    //手续费
    _namelb = [UILabel new];
    _namelb.textColor = [UIColor textBlackColor];
    _namelb.font = [UIFont boldSystemFontOfSize:13];
    _namelb.textAlignment = NSTextAlignmentLeft;
    _namelb.text = NSLocalizedString(@"手续费", nil);
    [self addSubview:_namelb];
    [_namelb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(17);
        make.top.equalTo(10);
        make.width.equalTo(150);
        make.height.equalTo(20);
    }];
    //0.001 ether ≈ ￥0.19
    _gaspricelb = [UILabel new];
    _gaspricelb.textColor = RGBACOLOR(23, 107, 172, 1);
    _gaspricelb.font = [UIFont boldSystemFontOfSize:13];
    _gaspricelb.textAlignment = NSTextAlignmentRight;
    [self addSubview:_gaspricelb];
    [_gaspricelb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-15);
        make.top.equalTo(10);
        make.width.equalTo(200);
        make.height.equalTo(20);
    }];
    
    // 滑动条slider
    _gasSlider = [UISlider new];
    [self addSubview:_gasSlider];
    [_gasSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(50);
        make.centerX.equalTo(0);
        make.width.equalTo(250);
        make.height.equalTo(20);
    }];

    // 当前值label
    _valueLabel = [UILabel new];
    _valueLabel.font = [UIFont systemFontOfSize:15];
    _valueLabel.textColor = [UIColor textLightGrayColor];
    _valueLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_valueLabel];
    [_valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(self.gasSlider.mas_bottom).equalTo(5);
        make.height.equalTo(20);
    }];
    
    // 最小值label
    _minLabel = [UILabel new];
    _minLabel.font = [UIFont systemFontOfSize:15];
    _minLabel.textColor = [UIColor textBlackColor];
    _minLabel.textAlignment = NSTextAlignmentRight;
    _minLabel.text = [NSString stringWithFormat:NSLocalizedString(@"慢", nil)];
    [self addSubview:_minLabel];
    [_minLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.right.equalTo(self.gasSlider.mas_left);
        make.height.equalTo(20);
        make.top.equalTo(self.gasSlider.mas_top);
    }];
    
    // 最大值label
    _maxLabel = [UILabel new];
    _maxLabel.textAlignment = NSTextAlignmentLeft;
    _maxLabel.font = [UIFont systemFontOfSize:15];
    _maxLabel.textColor = [UIColor textBlackColor];
    _maxLabel.text = [NSString stringWithFormat:NSLocalizedString(@"快", nil)];
    [self addSubview:_maxLabel];
    [_maxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-10);
        make.left.equalTo(self.gasSlider.mas_right);
        make.height.equalTo(20);
        make.top.equalTo(self.gasSlider.mas_top);
    }];
}

//-(UITextField *)customBtcFeeTextField{
//    if (!_customBtcFeeTextField) {
//       
//        _customBtcFeeTextField = [UITextField new];
//        _customBtcFeeTextField.placeholder = @"0";
//        _customBtcFeeTextField.keyboardType = UIKeyboardTypeNumberPad;
//        _customBtcFeeTextField.borderStyle = UITextBorderStyleNone;
//        _customBtcFeeTextField.backgroundColor = [UIColor whiteColor];
//        _customBtcFeeTextField.textAlignment = NSTextAlignmentLeft;
//        _customBtcFeeTextField.textColor = [UIColor textBlackColor];
//        _customBtcFeeTextField.font = [UIFont systemFontOfSize:13];
//        [self addSubview:_customBtcFeeTextField];
//        [_customBtcFeeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(ScreenWidth/2-5);
//            make.top.equalTo(10);
//            make.width.equalTo(100);
//            make.height.equalTo(20);
//        }];
//        
//        UILabel *remlb = [UILabel new];
//        remlb.textColor = [UIColor textBlackColor];
//        remlb.backgroundColor = [UIColor whiteColor];
//        remlb.font = [UIFont boldSystemFontOfSize:13];
//        remlb.textAlignment = NSTextAlignmentRight;
//        remlb.text = NSLocalizedString(@"自定义:", nil);
//        [self addSubview:remlb];
//        [remlb mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(ScreenWidth/2 - 100);
//            make.top.equalTo(10);
//            make.width.equalTo(90);
//            make.height.equalTo(20);
//        }];
//    }
//    return _customBtcFeeTextField;
//}

-(void)updateLabelValues:(CGFloat)value{
    self.valueLabel.text = [NSString stringWithFormat:@"%.2f gwei",value];
}
@end
