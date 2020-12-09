//
//  ThemeVoteTableViewCell.h
//  TaiYiToken
//
//  Created by mac on 2020/10/22.
//  Copyright © 2020 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ThemeVoteTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *rank;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *voteTitle;
@property (weak, nonatomic) IBOutlet UILabel *voteType;
@property (weak, nonatomic) IBOutlet UILabel *voteNum;
@property (weak, nonatomic) IBOutlet UIProgressView *voteP;


@end

NS_ASSUME_NONNULL_END
