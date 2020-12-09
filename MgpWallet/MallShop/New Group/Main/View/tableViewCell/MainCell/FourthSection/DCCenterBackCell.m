//
//  DCCenterBackCell.m
//  CDDStoreDemo
//
//  Created by 陈甸甸 on 2017/12/13.
//Copyright © 2017年 RocketsChen. All rights reserved.
//

#import "DCCenterBackCell.h"

// Controllers

// Models

// Views

// Vendors

// Categories

// Others

@interface DCCenterBackCell ()

@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (weak, nonatomic) IBOutlet UILabel *income;
@property (weak, nonatomic) IBOutlet UILabel *incomeTitle;

@property (weak, nonatomic) IBOutlet UILabel *refundIncome;
@property (weak, nonatomic) IBOutlet UILabel *waitIncome;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation DCCenterBackCell

#pragma mark - Intial
- (void)awakeFromNib {
    [super awakeFromNib];
    self.incomeTitle.text = NSLocalizedString(@"已入账", nil);
    self.titleLabel.text = NSLocalizedString(@"我的收益", nil);
    [DCSpeedy dc_chageControlCircularWith:_backButton AndSetCornerRadius:15 SetBorderWidth:1 SetBorderColor:RGB(227, 107, 97) canMasksToBounds:YES];
}

#pragma mark - Setter Getter Methods
- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.income.text = [NSString stringWithFormat:@"%ld",self.myCenterModel.down.income];
    self.refundIncome.text = [NSString stringWithFormat:@"%@:%ld",NSLocalizedString(@"已退款", nil),self.myCenterModel.down.refundIncome];
    self.waitIncome.text = [NSString stringWithFormat:@"%@:%ld",NSLocalizedString(@"未入账", nil),self.myCenterModel.down.waitIncome];

}

@end
