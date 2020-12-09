//
//  CommunityIncentivesTableViewCell.h
//  TaiYiToken
//
//  Created by mac on 2020/7/24.
//  Copyright © 2020 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommunityIncentivesTableViewCell : UITableViewCell

@property(weak, nonatomic) IBOutlet UIButton *titleLabel;
@property(weak, nonatomic) IBOutlet UIButton *subTitleLabel;
@property(weak, nonatomic) IBOutlet UILabel *bottomLeftLabel;
@property(weak, nonatomic) IBOutlet UILabel *bottomRightLabel;
@property(weak, nonatomic) IBOutlet UILabel *roleListLabel;

@end

NS_ASSUME_NONNULL_END
