//
//  HomeWalletTableViewCell.h
//  TaiYiToken
//
//  Created by mac on 2020/7/14.
//  Copyright © 2020 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeWalletTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property(weak, nonatomic) IBOutlet UIImageView *coinImage;
@property(weak, nonatomic) IBOutlet UILabel *coin_sys;
@property(weak, nonatomic) IBOutlet UILabel *balance;
@property(weak, nonatomic) IBOutlet UILabel *money;

@property(strong, nonatomic)MissionWallet *wallet;


@end

NS_ASSUME_NONNULL_END
