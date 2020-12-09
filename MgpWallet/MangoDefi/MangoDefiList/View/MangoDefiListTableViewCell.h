//
//  MangoDefiListTableViewCell.h
//  TaiYiToken
//
//  Created by mac on 2020/8/31.
//  Copyright © 2020 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MangoDefiListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *bankTime;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *address;

@property (weak, nonatomic) IBOutlet UIButton *buyBtn;

@end

NS_ASSUME_NONNULL_END
