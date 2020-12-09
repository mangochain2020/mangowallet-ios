//
//  HomeWalletTableViewCell.m
//  TaiYiToken
//
//  Created by mac on 2020/7/14.
//  Copyright © 2020 admin. All rights reserved.
//

#import "HomeWalletTableViewCell.h"

@implementation HomeWalletTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *identifier = @"HomeWalletTableViewCell";
    HomeWalletTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:identifier owner:nil options:nil] firstObject];
    }
    return cell;
}
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
    
    switch (self.wallet.coinType) {
        case ETH:
            self.coinImage.image = [UIImage imageNamed:@"ETH_coin"];
            self.coin_sys.text = @"ETH";
            break;
        case BTC:
        case BTC_TESTNET:
            self.coinImage.image = [UIImage imageNamed:@"BTC_coin"];
            self.coin_sys.text = @"BTC";

            break;
        case EOS:
            self.coinImage.image = [UIImage imageNamed:@"EOS_coin"];
            self.coin_sys.text = @"EOS";

            break;
        case MGP:
            self.coinImage.image = [UIImage imageNamed:@"MGP_coin"];
            self.coin_sys.text = @"MGP";
            break;
            
        case USDT:
            self.coinImage.image = [UIImage imageNamed:@"USDT_coin"];
            self.coin_sys.text = @"USDT";

            break;

        default:
            break;
    }
}
@end
