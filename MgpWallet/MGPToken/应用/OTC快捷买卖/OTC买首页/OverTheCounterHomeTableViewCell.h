//
//  OverTheCounterHomeTableViewCell.h
//  TaiYiToken
//
//  Created by mac on 2020/12/29.
//  Copyright © 2020 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OverTheCounterHomeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *buyButton;

@property (weak, nonatomic) IBOutlet UILabel *ownerLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceAssetLabel;


@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantityLeftLabel;

@property (weak, nonatomic) IBOutlet UILabel *min_accept_quantityLabel;
@property (weak, nonatomic) IBOutlet UILabel *min_accept_quantityLeftLabel;




@end

NS_ASSUME_NONNULL_END
