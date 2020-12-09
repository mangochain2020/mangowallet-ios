//
//  ShareItemCollectionViewCell.m
//  TaiYiToken
//
//  Created by Frued on 2018/8/31.
//  Copyright © 2018年 Frued. All rights reserved.
//

#import "ShareItemCollectionViewCell.h"

@implementation ShareItemCollectionViewCell

-(UIImageView *)iconImageView{
    if(!_iconImageView){
        _iconImageView = [UIImageView new];
        _iconImageView.layer.cornerRadius = 58 / 2.0;
        _iconImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_iconImageView];
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(0);
            make.centerX.equalTo(0);
            make.height.width.equalTo(58);
        }];
    }
    return _iconImageView;
}
-(UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:10];
        _titleLabel.textColor = [UIColor textBlackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(0);
            make.height.equalTo(20);
        }];
    }
    return _titleLabel;
}
- (void)setCellRelationDataTitle:(NSString *)title imageTitle:(NSString *)imageName
{
    self.iconImageView.image = [UIImage imageNamed:imageName];
    self.titleLabel.text = title;
}

@end
