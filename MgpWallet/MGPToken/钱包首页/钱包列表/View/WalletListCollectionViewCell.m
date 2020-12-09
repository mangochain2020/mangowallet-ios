//
//  WalletListCollectionViewCell.m
//  TaiYiToken
//
//  Created by mac on 2020/7/13.
//  Copyright © 2020 admin. All rights reserved.
//

#import "WalletListCollectionViewCell.h"

@implementation WalletListCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)layoutSubviews{
    [super layoutSubviews];
    _coinImage.layer.borderWidth = 1;
    _coinImage.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    _coinImage.layer.cornerRadius = 20;
    _coinImage.layer.masksToBounds = YES;
    
}
@end
