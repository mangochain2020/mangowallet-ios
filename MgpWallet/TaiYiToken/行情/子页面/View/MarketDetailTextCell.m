//
//  MarketDetailTextCell.m
//  TaiYiToken
//
//  Created by Frued on 2018/8/30.
//  Copyright © 2018年 Frued. All rights reserved.
//

#import "MarketDetailTextCell.h"

@implementation MarketDetailTextCell


- (UILabel *)rightLabel {
    if(_rightLabel == nil) {
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.textColor = [UIColor textBlackColor];
        _rightLabel.font = [UIFont systemFontOfSize:15];
        _rightLabel.textAlignment = NSTextAlignmentRight;
        _rightLabel.numberOfLines = 1;
        [self.contentView addSubview:_rightLabel];
        [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-10);
            make.centerY.equalTo(0);
            make.width.equalTo(200);
            make.height.equalTo(20);
        }];
        
    }
    return _rightLabel;
}

- (UILabel *)leftLabel {
    if(_leftLabel == nil) {
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.textColor = [UIColor grayColor];
        _leftLabel.font = [UIFont systemFontOfSize:15];
        _leftLabel.textAlignment = NSTextAlignmentLeft;
        _leftLabel.numberOfLines = 1;
        [self.contentView addSubview:_leftLabel];
        [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(10);
            make.centerY.equalTo(0);
            make.width.equalTo(140);
            make.height.equalTo(20);
        }];
        
    }
    return _leftLabel;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
