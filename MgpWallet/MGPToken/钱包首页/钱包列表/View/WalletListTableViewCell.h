//
//  WalletListTableViewCell.h
//  TaiYiToken
//
//  Created by mac on 2020/7/13.
//  Copyright © 2020 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WalletListTableViewCell : UITableViewCell


@property(weak, nonatomic) IBOutlet UILabel *walletName;
@property(weak, nonatomic) IBOutlet UILabel *walletAddress;
@property(weak, nonatomic) IBOutlet UIButton *moreBtn;
@property(weak, nonatomic) IBOutlet UIImageView *coinImage;
@property(strong, nonatomic) MissionWallet *model;



@end

NS_ASSUME_NONNULL_END
