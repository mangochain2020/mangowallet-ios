//
//  OverTheCounterPaymentTableViewCell.h
//  TaiYiToken
//
//  Created by mac on 2020/12/30.
//  Copyright © 2020 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OverTheCounterPaymentTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *payImageView;
@property (weak, nonatomic) IBOutlet UILabel *payTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *account;
@property (weak, nonatomic) IBOutlet UIImageView *collectionImageView;

@end

NS_ASSUME_NONNULL_END
