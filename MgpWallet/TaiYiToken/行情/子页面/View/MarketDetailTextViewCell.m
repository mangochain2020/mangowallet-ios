//
//  MarketDetailTextViewCell.m
//  TaiYiToken
//
//  Created by Frued on 2018/8/30.
//  Copyright © 2018年 Frued. All rights reserved.
//

#import "MarketDetailTextViewCell.h"

@implementation MarketDetailTextViewCell
-(UITextView *)celltextView{
    if(_celltextView == nil){
        _celltextView = [UITextView new];
        _celltextView.font = [UIFont systemFontOfSize:15];
        _celltextView.userInteractionEnabled = NO;
        _celltextView.textColor = [UIColor textBlackColor];
        _celltextView.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_celltextView];
        [_celltextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(0);
        }];
    }
    return _celltextView;
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
