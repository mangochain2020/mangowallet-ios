//
//  WalletListCell.m
//  TaiYiToken
//
//  Created by admin on 2018/9/3.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "WalletListCell.h"

@implementation WalletListCell
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
        _symbolNamelb.font = [UIFont boldSystemFontOfSize:14];
        _symbolNamelb.textAlignment = NSTextAlignmentLeft;
        [self.swipeContentView addSubview:_symbolNamelb];
        [_symbolNamelb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(40);
            make.top.equalTo(17);
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
        make.top.equalTo(20);
        make.width.equalTo(50);
        make.height.equalTo(12);
    }];
//    if(self.wallettype == LOCAL_WALLET){
//        [_symboldetaillb mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(72);
//            make.top.equalTo(20);
//            make.width.equalTo(50);
//            make.height.equalTo(12);
//        }];
//    }else{
//        [_symboldetaillb mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(95);
//            make.top.equalTo(20);
//            make.width.equalTo(50);
//            make.height.equalTo(12);
//        }];
//    }
    return _symboldetaillb;
}
- (UILabel *)addresslb {
    if(_addresslb == nil) {
        _addresslb = [[UILabel alloc] init];
        _addresslb.textColor = [UIColor textLightGrayColor];
        _addresslb.font = [UIFont systemFontOfSize:9];
        _addresslb.textAlignment = NSTextAlignmentLeft;
        _addresslb.numberOfLines = 1;
        [self.swipeContentView addSubview:_addresslb];
        [_addresslb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(40);
            make.centerY.equalTo(9);
            make.width.equalTo(130);
            make.height.equalTo(18);
        }];
        
    }
    return _addresslb;
}
-(UILabel *)qulb{
    if (!_qulb) {
        _qulb = [[UILabel alloc] init];
        _qulb.textColor = [UIColor textLightGrayColor];
        _qulb.font = [UIFont systemFontOfSize:9];
        _qulb.textAlignment = NSTextAlignmentRight;
        _qulb.numberOfLines = 1;
        _qulb.text = NSLocalizedString(@"数量", nil);
        [self.swipeContentView addSubview:_qulb];
        [_qulb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(30);
            make.centerY.equalTo(9);
            make.width.equalTo(70);
            make.height.equalTo(10);
        }];
    }
    return _qulb;
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
            make.centerX.equalTo(30);
            make.centerY.equalTo(-5);
            make.width.equalTo(110);
            make.height.equalTo(20);
        }];
    }
    return _amountlb;
}
- (UILabel *)valuelb {
    if(_valuelb == nil) {
        _valuelb = [[UILabel alloc] init];
        _valuelb.textColor = [UIColor textBlackColor];
        _valuelb.font = [UIFont systemFontOfSize:15];
        _valuelb.textAlignment = NSTextAlignmentRight;
        _valuelb.numberOfLines = 1;
        [self.swipeContentView addSubview:_valuelb];
        [_valuelb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(17);
            make.right.equalTo(-10);
            make.width.equalTo(90);
            make.height.equalTo(12);
        }];
        
    }
    return _valuelb;
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
            make.bottom.equalTo(-20);
            make.right.equalTo(-10);
            make.width.equalTo(90);
            make.height.equalTo(12);
        }];
        
    }
    return _rmbvaluelb;
}

@end
