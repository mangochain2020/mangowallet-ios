//
//  DataPointView.m
//  TaiYiToken
//
//  Created by Frued on 2018/8/20.
//  Copyright © 2018年 Frued. All rights reserved.
//

#import "DataPointView.h"
#define TextColor [UIColor textGrayColor]

@implementation DataPointView

-(void)initDataPointView{
    if (_highLabel == nil) {
        _highLabel = [[UILabel alloc] init];
        _highLabel.textColor = TextColor;
        _highLabel.font = [UIFont systemFontOfSize:10];
        _highLabel.textAlignment = NSTextAlignmentLeft;
        _highLabel.numberOfLines = 1;
        [self addSubview:_highLabel];
        [_highLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(5);
            make.top.equalTo(0);
            make.width.equalTo(self.width/5-10);
            make.height.equalTo(self.height);
        }];
    }
    if (_lowLabel == nil) {
        _lowLabel = [[UILabel alloc] init];
        _lowLabel.textColor = TextColor;
        _lowLabel.font = [UIFont systemFontOfSize:10];
        _lowLabel.textAlignment = NSTextAlignmentLeft;
        _lowLabel.numberOfLines = 1;
        [self addSubview:_lowLabel];
        [_lowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.highLabel.mas_right);
            make.top.equalTo(0);
            make.width.equalTo(self.width/5-10);
            make.height.equalTo(self.height);
        }];
    }
    if (_openLabel == nil) {
        _openLabel = [[UILabel alloc] init];
        _openLabel.textColor = TextColor;
        _openLabel.font = [UIFont systemFontOfSize:10];
        _openLabel.textAlignment = NSTextAlignmentLeft;
        _openLabel.numberOfLines = 1;
        [self addSubview:_openLabel];
        [_openLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.lowLabel.mas_right);
            make.top.equalTo(0);
            make.width.equalTo(self.width/5-10);
            make.height.equalTo(self.height);
        }];
    }
    if(_closeLabel == nil){
        _closeLabel = [[UILabel alloc] init];
        _closeLabel.textColor = TextColor;
        _closeLabel.font = [UIFont systemFontOfSize:10];
        _closeLabel.textAlignment = NSTextAlignmentLeft;
        _closeLabel.numberOfLines = 1;
        [self addSubview:_closeLabel];
        [_closeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.openLabel.mas_right);
            make.top.equalTo(0);
            make.width.equalTo(self.width/5-10);
            make.height.equalTo(self.height);
        }];
    }
    if (_volumeLabel == nil) {
        _volumeLabel = [[UILabel alloc] init];
        _volumeLabel.textColor = TextColor;
        _volumeLabel.font = [UIFont boldSystemFontOfSize:10];
        _volumeLabel.textAlignment = NSTextAlignmentLeft;
        _volumeLabel.numberOfLines = 1;
        [self addSubview:_volumeLabel];
        [_volumeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.closeLabel.mas_right);
            make.top.equalTo(0);
            make.right.equalTo(0);
            make.height.equalTo(self.height);
        }];
    }
   
}

@end
