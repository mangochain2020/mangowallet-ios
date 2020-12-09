//
//  LHMyExcitationTableViewCell.h
//  TaiYiToken
//
//  Created by mac on 2020/8/12.
//  Copyright © 2020 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LHMyExcitationTableViewCell : UITableViewCell

@property(weak, nonatomic) IBOutlet UILabel *money;
@property(weak, nonatomic) IBOutlet UILabel *createTime;
@property(weak, nonatomic) IBOutlet UILabel *channelName;
@property(weak, nonatomic) IBOutlet UIImageView *channelImage;

@end

NS_ASSUME_NONNULL_END
