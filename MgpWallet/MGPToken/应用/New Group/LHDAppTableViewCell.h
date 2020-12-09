//
//  LHDAppTableViewCell.h
//  TaiYiToken
//
//  Created by mac on 2020/8/11.
//  Copyright © 2020 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LHDAppTableViewCell : UITableViewCell

@property(weak, nonatomic) IBOutlet UILabel *titleLabel;
@property(weak, nonatomic) IBOutlet UILabel *tabLabel;
@property(weak, nonatomic) IBOutlet UILabel *childTitleLabel;
@property(weak, nonatomic) IBOutlet UIImageView *tabImage;
@property(weak, nonatomic) IBOutlet UIImageView *cellImage;
@property(weak, nonatomic) IBOutlet UILabel *titleRightLabel;

@end

NS_ASSUME_NONNULL_END
