
//
//  DataView.m
//  TaiYiToken
//
//  Created by Frued on 2018/8/17.
//  Copyright © 2018年 Frued. All rights reserved.
//

#import "DataView.h"
#define TITLETEXTCOLOR [UIColor colorWithHexString:@"#F32727"]
#define DATATEXTCOLOR  [UIColor colorWithHexString:@"#706F6F"]
#define RMBPRICETEXTCOLOR  [UIColor colorWithHexString:@"#C2C2C2"]
#define TwoLineLabelWIDTH ScreenWidth/6
#define TwoLineLabelFontSize 10
@implementation DataView

- (UILabel *)dollarlabel {
    if(_dollarlabel == nil) {
        _dollarlabel = [[UILabel alloc] init];
        _dollarlabel.textColor = TITLETEXTCOLOR;
        _dollarlabel.font = [UIFont boldSystemFontOfSize:24];
        _dollarlabel.textAlignment = NSTextAlignmentLeft;
        _dollarlabel.numberOfLines = 1;
        [self addSubview:_dollarlabel];
        [_dollarlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(20);
            make.top.equalTo(15);
            make.width.equalTo(150);
            make.height.equalTo(30);
        }];
    }
    return _dollarlabel;
}
- (UILabel *)rmblabel {
    if(_rmblabel == nil) {
        _rmblabel = [[UILabel alloc] init];
        _rmblabel.textColor = RMBPRICETEXTCOLOR;
        _rmblabel.font = [UIFont systemFontOfSize:12];
        _rmblabel.textAlignment = NSTextAlignmentLeft;
        _rmblabel.numberOfLines = 1;
        [self addSubview:_rmblabel];
        [_rmblabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(20);
            make.top.equalTo(self.dollarlabel.mas_bottom);
            make.width.equalTo(150);
            make.height.equalTo(20);
        }];
    }
    return _rmblabel;
}
- (UILabel *)ratelabel {
    if(_ratelabel == nil) {
        _ratelabel = [[UILabel alloc] init];
        _ratelabel.textColor = TITLETEXTCOLOR;
        _ratelabel.font = [UIFont systemFontOfSize:12];
        _ratelabel.textAlignment = NSTextAlignmentLeft;
        _ratelabel.numberOfLines = 1;
        [self addSubview:_ratelabel];
        [_ratelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(20);
            make.top.equalTo(self.rmblabel.mas_bottom);
            make.width.equalTo(150);
            make.height.equalTo(20);
        }];
    }
    return _ratelabel;
}


- (UILabel *)marketVolumelabel {
    if(_marketVolumelabel == nil) {
        _marketVolumelabel = [[UILabel alloc] init];
        _marketVolumelabel.textColor = DATATEXTCOLOR;
        _marketVolumelabel.font = [UIFont boldSystemFontOfSize:TwoLineLabelFontSize];
        _marketVolumelabel.textAlignment = NSTextAlignmentCenter;
        _marketVolumelabel.numberOfLines = 2;
        [self addSubview:_marketVolumelabel];
        [_marketVolumelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(TwoLineLabelWIDTH);
            make.centerY.equalTo(-20);
            make.left.equalTo(ScreenWidth/2);
            make.height.equalTo(30);
        }];
    }
    return _marketVolumelabel;
}

- (UILabel *)totalPricelabel {
    if(_totalPricelabel == nil) {
        _totalPricelabel = [[UILabel alloc] init];
        _totalPricelabel.textColor = DATATEXTCOLOR;
        _totalPricelabel.font = [UIFont boldSystemFontOfSize:TwoLineLabelFontSize];
        _totalPricelabel.textAlignment = NSTextAlignmentCenter;
        _totalPricelabel.numberOfLines = 2;
        [self addSubview:_totalPricelabel];
        [_totalPricelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(TwoLineLabelWIDTH);
            make.centerY.equalTo(-20);
            make.left.equalTo(ScreenWidth/2 + TwoLineLabelWIDTH);
            make.height.equalTo(30);
        }];
    }
    return _totalPricelabel;
}

- (UILabel *)amountlabel {
    if(_amountlabel == nil) {
        _amountlabel = [[UILabel alloc] init];
        _amountlabel.textColor = DATATEXTCOLOR;
        _amountlabel.font = [UIFont boldSystemFontOfSize:TwoLineLabelFontSize];
        _amountlabel.textAlignment = NSTextAlignmentCenter;
        _amountlabel.numberOfLines = 2;
        [self addSubview:_amountlabel];
        [_amountlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(TwoLineLabelWIDTH);
            make.centerY.equalTo(-20);
            make.left.equalTo(ScreenWidth/2 + TwoLineLabelWIDTH * 2);
            make.height.equalTo(30);
        }];
    }
    return _amountlabel;
}

////最高(24h)  最低(24h)
//// 12945.00 12552.00
//@property(nonatomic,strong)UILabel *highpricelabel;
//@property(nonatomic,strong)UILabel *lowpricelabel;

-(UILabel *)highpricelabel{
    if (!_highpricelabel) {
        _highpricelabel = [[UILabel alloc] init];
        _highpricelabel.textColor = DATATEXTCOLOR;
        _highpricelabel.font = [UIFont boldSystemFontOfSize:TwoLineLabelFontSize];
        _highpricelabel.textAlignment = NSTextAlignmentCenter;
        _highpricelabel.numberOfLines = 2;
        [self addSubview:_highpricelabel];
        [_highpricelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(TwoLineLabelWIDTH);
            make.centerY.equalTo(20);
            make.left.equalTo(ScreenWidth/2);
            make.height.equalTo(30);
        }];
    }
    return _highpricelabel;
}
-(UILabel *)lowpricelabel{
    if (!_lowpricelabel) {
        _lowpricelabel = [[UILabel alloc] init];
        _lowpricelabel.textColor = DATATEXTCOLOR;
        _lowpricelabel.font = [UIFont boldSystemFontOfSize:TwoLineLabelFontSize];
        _lowpricelabel.textAlignment = NSTextAlignmentCenter;
        _lowpricelabel.numberOfLines = 2;
        [self addSubview:_lowpricelabel];
        [_lowpricelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(TwoLineLabelWIDTH);
            make.centerY.equalTo(20);
            make.left.equalTo(ScreenWidth/2 + TwoLineLabelWIDTH);
            make.height.equalTo(30);
        }];
    }
    return _lowpricelabel;
}
@end
