//
//  CommunityIncentivesTableViewCell.m
//  TaiYiToken
//
//  Created by mac on 2020/7/24.
//  Copyright © 2020 admin. All rights reserved.
//

#import "CommunityIncentivesTableViewCell.h"

@implementation CommunityIncentivesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)midClick:(id)sender {
    [UIPasteboard generalPasteboard].string = self.titleLabel.titleLabel.text;
    [self showMsg:NSLocalizedString(@"已复制", nil)];

}

- (IBAction)addressClick:(id)sender {
    [UIPasteboard generalPasteboard].string = self.subTitleLabel.titleLabel.text;
    [self showMsg:NSLocalizedString(@"已复制", nil)];

}

@end
