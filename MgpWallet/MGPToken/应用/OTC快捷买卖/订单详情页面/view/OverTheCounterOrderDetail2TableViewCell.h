//
//  OverTheCounterOrderDetail2TableViewCell.h
//  TaiYiToken
//
//  Created by mac on 2020/12/30.
//  Copyright © 2020 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OverTheCounterOrderDetail2TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidth;


@end

NS_ASSUME_NONNULL_END
