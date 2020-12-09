//
//  DCCommodityTableViewCell.h
//  TaiYiToken
//
//  Created by mac on 2020/8/7.
//  Copyright © 2020 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCCommodityModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DCCommodityTableViewCell : UITableViewCell

@property(strong, nonatomic)DCCommodityModel *model;

@property (weak, nonatomic) IBOutlet UIImageView *shop_image;
@property (weak, nonatomic) IBOutlet UILabel *storeName;
@property (weak, nonatomic) IBOutlet UILabel *storeType;
@property (weak, nonatomic) IBOutlet UILabel *totalNum;
@property (weak, nonatomic) IBOutlet UILabel *price;

@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;

@end

NS_ASSUME_NONNULL_END
