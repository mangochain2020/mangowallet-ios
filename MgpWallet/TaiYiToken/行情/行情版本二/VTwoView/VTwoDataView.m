//
//  VTwoDataView.m
//  TaiYiToken
//
//  Created by 张元一 on 2018/11/21.
//  Copyright © 2018 admin. All rights reserved.
//

#import "VTwoDataView.h"
#define TITLETEXTCOLOR [UIColor colorWithHexString:@"#F32727"]
#define DATATEXTCOLOR  [UIColor colorWithHexString:@"#706F6F"]
#define RMBPRICETEXTCOLOR  [UIColor colorWithHexString:@"#C2C2C2"]
#define TwoLineLabelWIDTH ScreenWidth/6
#define TwoLineLabelFontSize 10
@implementation VTwoDataView
- (UILabel *)commentlabel {
    if(!_commentlabel) {
        _commentlabel = [[UILabel alloc] init];
        _commentlabel.textColor = RMBPRICETEXTCOLOR;
        _commentlabel.font = [UIFont systemFontOfSize:10];
        _commentlabel.textAlignment = NSTextAlignmentLeft;
        _commentlabel.numberOfLines = 1;
        [self addSubview:_commentlabel];
        [_commentlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(20);
            make.top.equalTo(15);
            make.width.equalTo(150);
            make.height.equalTo(12);
            
        }];
    }
    return _commentlabel;
}
- (UILabel *)pricelabel{
    if(!_pricelabel) {
        _pricelabel = [[UILabel alloc] init];
        _pricelabel.textColor = TITLETEXTCOLOR;
        _pricelabel.font = [UIFont systemFontOfSize:20];
        _pricelabel.textAlignment = NSTextAlignmentLeft;
        _pricelabel.numberOfLines = 1;
        [self addSubview:_pricelabel];
        [_pricelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(20);
            make.top.equalTo(30);
            make.width.equalTo(150);
            make.height.equalTo(22);
        }];
    }
    return _pricelabel;
}
- (UILabel *)ratelabel {
    if(!_ratelabel) {
        _ratelabel = [[UILabel alloc] init];
        _ratelabel.textColor = TITLETEXTCOLOR;
        _ratelabel.font = [UIFont systemFontOfSize:10];
        _ratelabel.textAlignment = NSTextAlignmentLeft;
        _ratelabel.numberOfLines = 1;
        [self addSubview:_ratelabel];
        [_ratelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(20);
            make.top.equalTo(55);
            make.width.equalTo(150);
            make.height.equalTo(12);
        }];
    }
    return _ratelabel;
}
- (UILabel *)infolabel{
    if (!_infolabel) {
        _infolabel = [[UILabel alloc] init];
        _infolabel.textColor = [UIColor textBlackColor];
        _infolabel.font = [UIFont systemFontOfSize:10];
        _infolabel.textAlignment = NSTextAlignmentLeft;
        _infolabel.numberOfLines = 1;
        [self addSubview:_infolabel];
        [_infolabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(20);
            make.top.equalTo(70);
            make.width.equalTo(ScreenWidth);
            make.height.equalTo(20);
        }];
    }
    return _infolabel;
}

-(UILabel *)highpricelabel{
    if (!_highpricelabel) {
        UILabel *lb = [[UILabel alloc] init];
        lb.textColor = DATATEXTCOLOR;
        lb.text = NSLocalizedString(@"高", nil);
        lb.font = [UIFont systemFontOfSize:TwoLineLabelFontSize];
        lb.textAlignment = NSTextAlignmentLeft;
        lb.numberOfLines = 1;
        [self addSubview:lb];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(15);
            make.centerY.equalTo(-10);
            make.left.equalTo(135);
            make.height.equalTo(15);
        }];
        
        _highpricelabel = [[UILabel alloc] init];
        _highpricelabel.font = [UIFont systemFontOfSize:TwoLineLabelFontSize];
        _highpricelabel.textAlignment = NSTextAlignmentLeft;
        _highpricelabel.numberOfLines = 1;
        [self addSubview:_highpricelabel];
        [_highpricelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(TwoLineLabelWIDTH - 15);
            make.centerY.equalTo(-10);
            make.left.equalTo(155);
            make.height.equalTo(15);
        }];
    }
    return _highpricelabel;
}
-(UILabel *)lowpricelabel{
    if (!_lowpricelabel) {
        
        UILabel *lb = [[UILabel alloc] init];
        lb.textColor = DATATEXTCOLOR;
        lb.font = [UIFont systemFontOfSize:TwoLineLabelFontSize];
        lb.textAlignment = NSTextAlignmentLeft;
        lb.text = NSLocalizedString(@"低", nil);
        lb.numberOfLines = 1;
        [self addSubview:lb];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(15);
            make.centerY.equalTo(10);
            make.left.equalTo(135);
            make.height.equalTo(15);
        }];
        
        _lowpricelabel = [[UILabel alloc] init];
        _lowpricelabel.font = [UIFont systemFontOfSize:TwoLineLabelFontSize];
        _lowpricelabel.textAlignment = NSTextAlignmentLeft;
        _lowpricelabel.numberOfLines = 1;
        [self addSubview:_lowpricelabel];
        [_lowpricelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(TwoLineLabelWIDTH - 15);
            make.centerY.equalTo(10);
            make.left.equalTo(155);
            make.height.equalTo(15);
        }];
    }
    return _lowpricelabel;
}

-(UILabel *)volumelabel{
    if (!_volumelabel) {
        _volumelabel = [[UILabel alloc] init];
        _volumelabel.textColor = DATATEXTCOLOR;
        _volumelabel.font = [UIFont systemFontOfSize:TwoLineLabelFontSize];
        _volumelabel.textAlignment = NSTextAlignmentLeft;
        _volumelabel.numberOfLines = 1;
        [self addSubview:_volumelabel];
        [_volumelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(TwoLineLabelWIDTH+10);
            make.centerY.equalTo(-10);
            make.left.equalTo(self.highpricelabel.mas_right).equalTo(0);
            make.height.equalTo(15);
        }];
    }
    return _volumelabel;
}

-(UILabel *)changeratelabel{
    if (!_changeratelabel) {
        _changeratelabel = [[UILabel alloc] init];
        _changeratelabel.textColor = DATATEXTCOLOR;
        _changeratelabel.font = [UIFont systemFontOfSize:TwoLineLabelFontSize];
        _changeratelabel.textAlignment = NSTextAlignmentLeft;
        _changeratelabel.numberOfLines = 1;
        [self addSubview:_changeratelabel];
        [_changeratelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(TwoLineLabelWIDTH+10);
            make.centerY.equalTo(10);
            make.left.equalTo(self.lowpricelabel.mas_right).equalTo(0);
            make.height.equalTo(15);
        }];
    }
    return _changeratelabel;
}


- (UILabel *)marketVolumelabel {
    if(!_marketVolumelabel) {
        _marketVolumelabel = [[UILabel alloc] init];
        _marketVolumelabel.textColor = DATATEXTCOLOR;
        _marketVolumelabel.font = [UIFont systemFontOfSize:TwoLineLabelFontSize];
        _marketVolumelabel.textAlignment = NSTextAlignmentLeft;
        _marketVolumelabel.numberOfLines = 1;
        [self addSubview:_marketVolumelabel];
        [_marketVolumelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(0);
            make.centerY.equalTo(-10);
            make.left.equalTo(self.volumelabel.mas_right).equalTo(0);
            make.height.equalTo(15);
        }];
    }
    return _marketVolumelabel;
}

-(UILabel *)ranklabel{
    if(!_ranklabel) {
        _ranklabel = [[UILabel alloc] init];
        _ranklabel.textColor = DATATEXTCOLOR;
        _ranklabel.font = [UIFont systemFontOfSize:TwoLineLabelFontSize];
        _ranklabel.textAlignment = NSTextAlignmentLeft;
        _ranklabel.numberOfLines = 1;
        [self addSubview:_ranklabel];
        [_ranklabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(TwoLineLabelWIDTH+10);
            make.centerY.equalTo(10);
            make.left.equalTo(self.lowpricelabel.mas_right).equalTo(0);
            make.height.equalTo(15);
        }];
    }
    return _ranklabel;
}
@end
