//
//  LHStakeVoteMainTableViewCell.h
//  TaiYiToken
//
//  Created by mac on 2020/11/16.
//  Copyright © 2020 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LHStakeVoteMainTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *rank;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *reward_share;
@property (weak, nonatomic) IBOutlet UILabel *received_votes;
@property (weak, nonatomic) IBOutlet UILabel *url_votes;
@property (weak, nonatomic) IBOutlet UILabel *votesLabel;

@property (weak, nonatomic) IBOutlet UIButton *votesBtn;

@end

NS_ASSUME_NONNULL_END
