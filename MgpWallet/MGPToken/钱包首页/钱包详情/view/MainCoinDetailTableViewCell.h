//
//  MainCoinDetailTableViewCell.h
//  TaiYiToken
//
//  Created by mac on 2020/7/15.
//  Copyright © 2020 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainCoinDetailTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property(weak, nonatomic) IBOutlet UILabel *accountName;
@property(weak, nonatomic) IBOutlet UILabel *timeLabel;
@property(weak, nonatomic) IBOutlet UILabel *quantity;
@property(weak, nonatomic) IBOutlet UILabel *name;
@property(weak, nonatomic) IBOutlet UIImageView *typeImage;


@end

NS_ASSUME_NONNULL_END
