//
//  OverTheCounterMyOrderTableViewCell.h
//  TaiYiToken
//
//  Created by mac on 2020/12/29.
//  Copyright © 2020 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OverTheCounterMyOrderTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface OverTheCounterMyOrderTableViewCell : UITableViewCell

@property (nonatomic,assign) OverTheCounterMyOrderType myOrderType; //我的订单类型
@property (nonatomic,strong) NSDictionary *dic; //我的订单

@property (weak, nonatomic) IBOutlet UILabel *numTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabelT;
@property (weak, nonatomic) IBOutlet UILabel *numLabelT;
@property (weak, nonatomic) IBOutlet UILabel *totalLabelT;

@property (weak, nonatomic) IBOutlet UILabel *timeLabelB;
@property (weak, nonatomic) IBOutlet UILabel *numLabelB;
@property (weak, nonatomic) IBOutlet UILabel *totalLabelB;

@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@end

NS_ASSUME_NONNULL_END
