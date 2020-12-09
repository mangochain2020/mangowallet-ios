//
//  WalletDetailView.m
//  TaiYiToken
//
//  Created by Frued on 2018/10/22.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "WalletDetailView.h"

@implementation WalletDetailView

-(UIImageView *)iconImageView{
    if (!_iconImageView) {
        UIImage *backImage = [[UIImage alloc]createImageWithSize:CGSizeMake(ScreenWidth, 172) gradientColors:@[[UIColor colorWithHexString:@"#4090F7"],[UIColor colorWithHexString:@"#BBA8FF"],[UIColor colorWithHexString:@"#4090F7"]] percentage:@[@(0.3),@(0.7),@(0.3)] gradientType:GradientFromLeftToRight];
        [self setBackgroundColor:[UIColor colorWithPatternImage:backImage]];
        _iconImageView = [UIImageView new];
        [self addSubview:_iconImageView];
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(16);
            make.top.equalTo(20);
            make.width.height.equalTo(34);
        }];
    }
    return _iconImageView;
}
-(UILabel *)symbolNamelb{
    if (!_symbolNamelb) {
        _symbolNamelb = [UILabel new];
        _symbolNamelb.textColor = [UIColor textWhiteColor];
        _symbolNamelb.font = [UIFont boldSystemFontOfSize:22];
        _symbolNamelb.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_symbolNamelb];
        [_symbolNamelb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(30);
            make.top.equalTo(self.iconImageView.mas_top);
            make.width.equalTo(90);
            make.height.equalTo(25);
        }];
    }
    return _symbolNamelb;
}
-(UILabel *)symboldetaillb{
    if (!_symboldetaillb) {
        _symboldetaillb = [UILabel new];
        _symboldetaillb.textColor = [UIColor textWhiteColor];
        _symboldetaillb.font = [UIFont systemFontOfSize:13];
        _symboldetaillb.textAlignment = NSTextAlignmentRight;
        [self addSubview:_symboldetaillb];
        if (self.wallettype == LOCAL_WALLET) {
            [_symboldetaillb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(80);
                make.top.equalTo(self.iconImageView.mas_top).equalTo(9);
                make.width.equalTo(80);
                make.height.equalTo(15);
            }];
        }else{
            [_symboldetaillb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(80);
                make.top.equalTo(self.iconImageView.mas_top).equalTo(9);
                make.width.equalTo(80);
                make.height.equalTo(15);
            }];
        }
        
    }
    return _symboldetaillb;
}
-(UIButton *)addressBtn{
    if (!_addressBtn) {
        _addressBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        _addressBtn.userInteractionEnabled = YES;
        _addressBtn.titleLabel.textColor = [UIColor textWhiteColor];
        _addressBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        _addressBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        [self  addSubview:_addressBtn];
        
        
        UIImageView *iv = [UIImageView new];
        iv.image = [UIImage imageNamed:@"ico_backups"];
        [self addSubview:iv];
        if (self.cointype == MIS || self.cointype == EOS) {
            [_addressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(30);
                make.top.equalTo(self.iconImageView.mas_top).equalTo(20);
                make.width.equalTo(70);
                make.height.equalTo(20);
            }];
            [iv mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(100);
                make.top.equalTo(self.iconImageView.mas_top).equalTo(27);
                make.width.equalTo(8);
                make.height.equalTo(8);
            }];
        }else{
            [_addressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(30);
                make.top.equalTo(self.iconImageView.mas_top).equalTo(20);
                make.width.equalTo(140);
                make.height.equalTo(20);
            }];
            [iv mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(170);
                make.top.equalTo(self.iconImageView.mas_top).equalTo(27);
                make.width.equalTo(8);
                make.height.equalTo(8);
            }];
        }
        
    }
    return _addressBtn;
}
- (UILabel *)amountlb {
    if(_amountlb == nil) {
        _amountlb = [[UILabel alloc] init];
        _amountlb.textColor = [UIColor textWhiteColor];
        _amountlb.font = [UIFont boldSystemFontOfSize:18];
        _amountlb.textAlignment = NSTextAlignmentRight;
        _amountlb.numberOfLines = 1;
        [self addSubview:_amountlb];
        [_amountlb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-16);
            make.top.equalTo(self.iconImageView.mas_top);
            make.width.equalTo(200);
            make.height.equalTo(20);
        }];
        
    }
    return _amountlb;
}

- (UILabel *)balancelb {
    if(_balancelb == nil) {
        _balancelb = [[UILabel alloc] init];
        _balancelb.textColor = [UIColor textWhiteColor];
        _balancelb.font = [UIFont systemFontOfSize:10];
        _balancelb.textAlignment = NSTextAlignmentRight;
        _balancelb.numberOfLines = 1;
        [self addSubview:_balancelb];
        [_balancelb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-16);
            make.top.equalTo(self.iconImageView.mas_top).equalTo(20);
            make.width.equalTo(150);
            make.height.equalTo(20);
        }];
        
    }
    return _balancelb;
}

-(UITextView *)infotextView{
    if(_infotextView == nil) {
        UIView *backview = [UIView new];
        backview.backgroundColor = [UIColor whiteColor];
        [self addSubview:backview];
        [backview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.top.equalTo(72);
            make.height.equalTo(100);
        }];
        
        _infotextView = [[UITextView alloc] init];
        _infotextView.textColor = [UIColor blackColor];
        _infotextView.font = [UIFont systemFontOfSize:10];
        _infotextView.textAlignment = NSTextAlignmentLeft;
        _infotextView.editable = NO;
        [self addSubview:_infotextView];
        [_infotextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(10);
            make.right.equalTo(-10);
            make.top.equalTo(72);
            make.height.equalTo(100);
        }];
    }
    return _infotextView;
}

@end
