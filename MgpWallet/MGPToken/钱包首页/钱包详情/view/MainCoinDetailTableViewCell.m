//
//  MainCoinDetailTableViewCell.m
//  TaiYiToken
//
//  Created by mac on 2020/7/15.
//  Copyright © 2020 admin. All rights reserved.
//

#import "MainCoinDetailTableViewCell.h"

@implementation MainCoinDetailTableViewCell


+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *identifier = @"MainCoinDetailTableViewCell";
    MainCoinDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:identifier owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
