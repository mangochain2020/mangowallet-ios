//
//  DCCommodityTableViewCell.m
//  TaiYiToken
//
//  Created by mac on 2020/8/7.
//  Copyright © 2020 admin. All rights reserved.
//

#import "DCCommodityTableViewCell.h"

@implementation DCCommodityTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews{
    [super layoutSubviews];

    [self.shop_image sd_setImageWithURL:[NSURL URLWithString:self.model.image_url.firstObject]];
    self.storeName.text = self.model.storeName;
    self.storeType.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"商品规格", nil),self.model.storeType];
    self.totalNum.text = [NSString stringWithFormat:@"%@:%ld",NSLocalizedString(@"商品库存", nil),(long)self.model.stock];
    self.price.text = [NSString stringWithFormat:@"%@$:%ld",NSLocalizedString(@"零售价", nil),(long)self.model.price];
    [self.button2 setTitle:NSLocalizedString(@"删除", nil) forState:UIControlStateNormal];
    

}
@end
