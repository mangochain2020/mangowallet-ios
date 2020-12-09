//
//  WalletListTableViewCell.m
//  TaiYiToken
//
//  Created by mac on 2020/7/13.
//  Copyright © 2020 admin. All rights reserved.
//

#import "WalletListTableViewCell.h"

@implementation WalletListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setFrame:(CGRect)frame{
    frame.origin.x += 10;
    frame.origin.y += 10;
    frame.size.height -= 10;
    frame.size.width -= 20;
    [super setFrame:frame];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
        
    self.walletName.text = self.model.walletName;
    self.walletAddress.text = self.model.address;

    switch (self.model.coinType) {
        case ETH:
            self.coinImage.image = [UIImage imageNamed:@"bglogo2"];
            self.contentView.backgroundColor = RGB(63, 146, 190);
            break;
        case BTC:
        case BTC_TESTNET:
        case USDT:
            self.coinImage.image = [UIImage imageNamed:@"bglogo1"];
            self.contentView.backgroundColor = RGB(240, 162, 59);
            break;
        case EOS:
            self.coinImage.image = [UIImage imageNamed:@"EOS"];
            self.contentView.backgroundColor = RGB(56, 53, 84);
            self.walletAddress.text = self.model.ifEOSAccountRegistered ? self.model.address : NSLocalizedString(@"未激活", nil);
            break;
        case MGP:
            self.coinImage.image = [UIImage imageNamed:@"MIS"];
            self.contentView.backgroundColor = RGB(85, 144, 240);
            self.walletAddress.text = self.model.ifEOSAccountRegistered ? self.model.address : NSLocalizedString(@"未激活", nil);
            break;
            
        default:
            break;
    }
    
}
@end
