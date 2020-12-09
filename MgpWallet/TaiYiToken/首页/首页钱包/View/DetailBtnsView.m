

//
//  DetailBtnsView.m
//  TaiYiToken
//
//  Created by Frued on 2018/10/22.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "DetailBtnsView.h"
#define DetailBtnsViewHeight 110
#define DetailBtnsViewFont 13
@implementation DetailBtnsView
//@property(nonatomic,strong)UIButton *transBtn;
//@property(nonatomic,strong)UIButton *receiptBtn;
//@property(nonatomic,strong)UIButton *marketBtn;
//@property(nonatomic,strong)UIButton *exportBtn;
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
            make.width.equalTo(ScreenWidth/2);
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
            make.left.equalTo(ScreenWidth/2);
            make.top.equalTo(0);
            make.width.equalTo(ScreenWidth/2);
            make.height.equalTo(DetailBtnsViewHeight/2);
        }];
    }
    return _receiptBtn;
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
            make.width.equalTo(ScreenWidth/2);
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
            make.left.equalTo(ScreenWidth/2);
            make.top.equalTo(DetailBtnsViewHeight/2);
            make.width.equalTo(ScreenWidth/2);
            make.height.equalTo(DetailBtnsViewHeight/2);
        }];
    }
    return _exportBtn;
}

@end
