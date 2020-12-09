//
//  TransactionDetailView.m
//  TaiYiToken
//
//  Created by admin on 2018/9/18.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "TransactionDetailView.h"
#import "DashesLineView.h"
@implementation TransactionDetailView
-(UIImageView *)iconImageView{
    self.backgroundColor = [UIColor whiteColor];
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
        _iconImageView.layer.cornerRadius = 12;
        _iconImageView.layer.masksToBounds = YES;
        [self addSubview:_iconImageView];
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(20);
            make.left.equalTo(30);
            make.width.height.equalTo(24);
        }];
    }
    return _iconImageView;
}

-(UILabel *)timelb{
    if (!_timelb) {
        _timelb = [UILabel new];
        _timelb.textColor = [UIColor textLightGrayColor];
        _timelb.font = [UIFont systemFontOfSize:12];
        _timelb.numberOfLines = 2;
        _timelb.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_timelb];
        [_timelb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(30);
            make.top.equalTo(75);
            make.width.equalTo(80);
            make.height.equalTo(30);
        }];

    }
    return _timelb;
}

-(UILabel *)amountlb{
    if (!_amountlb) {
        _amountlb = [UILabel new];
        _amountlb.textColor = [UIColor textBlackColor];
        _amountlb.font = [UIFont boldSystemFontOfSize:24];
        _amountlb.textAlignment = NSTextAlignmentRight;
        [self addSubview:_amountlb];
        [_amountlb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-30);
            make.top.equalTo(20);
            make.width.equalTo(250);
            make.height.equalTo(30);
        }];
        
        UILabel *label = [UILabel new];
        label.text = NSLocalizedString(@"金额", nil);
        label.textColor = [UIColor textGrayColor];
        label.font = [UIFont systemFontOfSize:13];
        label.textAlignment = NSTextAlignmentRight;
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-30);
            make.top.equalTo(50);
            make.width.equalTo(150);
            make.height.equalTo(20);
        }];
    }
    return _amountlb;
}

-(UILabel *)resultlb{
    if (!_resultlb) {
        _resultlb = [UILabel new];
        _resultlb.textColor = [UIColor textBlackColor];
        _resultlb.font = [UIFont boldSystemFontOfSize:13];
        _resultlb.textAlignment = NSTextAlignmentRight;
        [self addSubview:_resultlb];
        [_resultlb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-30);
            make.top.equalTo(90);
            make.width.equalTo(200);
            make.height.equalTo(20);
        }];
    }
    return _resultlb;
}


-(RecordDetailLabel *)feelb{
    if (!_feelb) {
        
        DashesLineView *line = [DashesLineView new];
        line.backgroundColor = [UIColor whiteColor];
        line.lineColor = [UIColor lineGrayColor];
        line.lineWidth = 1.0;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.height.equalTo(2);
            make.top.equalTo(120);
        }];
        
        _feelb = [RecordDetailLabel new];
        [self addSubview:_feelb];
        [_feelb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.top.equalTo(150);
            make.height.equalTo(40);
        }];
    }
    return _feelb;
}

-(RecordDetailLabel *)tolb{
    if (!_tolb) {
        _tolb = [RecordDetailLabel new];
        [self addSubview:_tolb];
        [_tolb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.top.equalTo(200);
            make.height.equalTo(40);
        }];
    }
    return _tolb;
}
-(RecordDetailLabel *)fromlb{
    if (!_fromlb) {
        _fromlb = [RecordDetailLabel new];
        [self addSubview:_fromlb];
        [_fromlb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.top.equalTo(250);
            make.height.equalTo(40);
        }];
    }
    return _fromlb;
}
-(RecordDetailLabel *)remarklb{
    if (!_remarklb) {
        _remarklb = [RecordDetailLabel new];
        [self addSubview:_remarklb];
        [_remarklb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.top.equalTo(300);
            make.height.equalTo(40);
        }];
    }
    return _remarklb;
}
-(RecordDetailLabel *)tranNumberlb{
    if (!_tranNumberlb) {
        
        DashesLineView *line = [DashesLineView new];
        line.backgroundColor = [UIColor whiteColor];
        line.lineColor = [UIColor lineGrayColor];
        line.lineWidth = 1.0;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.height.equalTo(2);
            make.top.equalTo(350);
        }];
        
        _tranNumberlb = [RecordDetailLabel new];
        [self addSubview:_tranNumberlb];
        [_tranNumberlb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.top.equalTo(370);
            make.height.equalTo(40);
        }];
    }
    return _tranNumberlb;
}
-(RecordDetailLabel *)blockNumberlb{
    if (!_blockNumberlb) {
        _blockNumberlb = [RecordDetailLabel new];
        [self addSubview:_blockNumberlb];
        [_blockNumberlb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.top.equalTo(420);
            make.height.equalTo(40);
        }];
    
    }
    return _blockNumberlb;
}
@end
