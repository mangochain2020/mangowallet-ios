//
//  EOSDetailBtnsView.m
//  TaiYiToken
//
//  Created by 张元一 on 2018/12/18.
//  Copyright © 2018 admin. All rights reserved.
//

#import "EOSDetailBtnsView.h"
#define DetailBtnsViewHeight 110
#define DetailBtnsViewFont 13
@implementation EOSDetailBtnsView
-(UIButton *)transBtn{
    if (!_transBtn) {
        _transBtn = [UIButton buttonWithType: UIButtonTypeSystem];
        _transBtn.userInteractionEnabled = YES;
        _transBtn.tintColor = [UIColor textBlackColor];
        _transBtn.titleLabel.textColor = [UIColor textBlackColor];
        _transBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _transBtn.titleLabel.font = [UIFont systemFontOfSize:DetailBtnsViewFont];
        [self addSubview:_transBtn];
        [_transBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.top.equalTo(0);
            make.width.equalTo(ScreenWidth/3);
            make.height.equalTo(DetailBtnsViewHeight/2);
        }];
    }
    return _transBtn;
}
-(UIButton *)receiptBtn{
    if (!_receiptBtn) {
        _receiptBtn = [UIButton buttonWithType: UIButtonTypeSystem];
        _receiptBtn.userInteractionEnabled = YES;
        _receiptBtn.tintColor = [UIColor textBlackColor];
        _receiptBtn.titleLabel.textColor = [UIColor textBlackColor];
        _receiptBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _receiptBtn.titleLabel.font = [UIFont systemFontOfSize:DetailBtnsViewFont];
        [self addSubview:_receiptBtn];
        [_receiptBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ScreenWidth/3);
            make.top.equalTo(0);
            make.width.equalTo(ScreenWidth/3);
            make.height.equalTo(DetailBtnsViewHeight/2);
        }];
    }
    return _receiptBtn;
}

-(UIButton *)proManageBtn{
    if (!_proManageBtn) {
        _proManageBtn = [UIButton buttonWithType: UIButtonTypeSystem];
        _proManageBtn.userInteractionEnabled = YES;
        _proManageBtn.tintColor = [UIColor textBlackColor];
        _proManageBtn.titleLabel.textColor = [UIColor textBlackColor];
        _proManageBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _proManageBtn.titleLabel.font = [UIFont systemFontOfSize:DetailBtnsViewFont];
        [self addSubview:_proManageBtn];
        [_proManageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ScreenWidth*2/3);
            make.top.equalTo(0);
            make.width.equalTo(ScreenWidth/3);
            make.height.equalTo(DetailBtnsViewHeight/2);
        }];
    }
    return _proManageBtn;
}

-(UIButton *)marketBtn{
    if (!_marketBtn) {
        _marketBtn = [UIButton buttonWithType: UIButtonTypeSystem];
        _marketBtn.userInteractionEnabled = YES;
        _marketBtn.tintColor = [UIColor textBlackColor];
        _marketBtn.titleLabel.textColor = [UIColor textBlackColor];
        _marketBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _marketBtn.titleLabel.font = [UIFont systemFontOfSize:DetailBtnsViewFont];
        [self addSubview:_marketBtn];
        [_marketBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.top.equalTo(DetailBtnsViewHeight/2);
            make.width.equalTo(ScreenWidth/3);
            make.height.equalTo(DetailBtnsViewHeight/2);
        }];
    }
    return _marketBtn;
}
-(UIButton *)exportBtn{
    if (!_exportBtn) {
        _exportBtn = [UIButton buttonWithType: UIButtonTypeSystem];
        _exportBtn.userInteractionEnabled = YES;
        _exportBtn.tintColor = [UIColor textBlackColor];
        _exportBtn.titleLabel.textColor = [UIColor textBlackColor];
        _exportBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _exportBtn.titleLabel.font = [UIFont systemFontOfSize:DetailBtnsViewFont];
        [self addSubview:_exportBtn];
        [_exportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ScreenWidth/3);
            make.top.equalTo(DetailBtnsViewHeight/2);
            make.width.equalTo(ScreenWidth/3);
            make.height.equalTo(DetailBtnsViewHeight/2);
        }];
    }
    return _exportBtn;
}


-(UIButton *)perCheckBtn{
    if (!_perCheckBtn) {
        _perCheckBtn = [UIButton buttonWithType: UIButtonTypeSystem];
        _perCheckBtn.userInteractionEnabled = YES;
        _perCheckBtn.tintColor = [UIColor textBlackColor];
        _perCheckBtn.titleLabel.textColor = [UIColor textBlackColor];
        _perCheckBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _perCheckBtn.titleLabel.font = [UIFont systemFontOfSize:DetailBtnsViewFont];
        [self addSubview:_perCheckBtn];
        [_perCheckBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ScreenWidth*2/3);
            make.top.equalTo(DetailBtnsViewHeight/2);
            make.width.equalTo(ScreenWidth/3);
            make.height.equalTo(DetailBtnsViewHeight/2);
        }];
    }
    return _perCheckBtn;
}
@end
