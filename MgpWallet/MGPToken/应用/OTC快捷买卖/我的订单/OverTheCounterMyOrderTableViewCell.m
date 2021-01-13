//
//  OverTheCounterMyOrderTableViewCell.m
//  TaiYiToken
//
//  Created by mac on 2020/12/29.
//  Copyright © 2020 admin. All rights reserved.
//

#import "OverTheCounterMyOrderTableViewCell.h"

@implementation OverTheCounterMyOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)layoutSubviews{
    [super layoutSubviews];
    NSString *block_time = self.dic[@"created_at"];;
    NSString *orderMaker = self.myOrderType == OverTheCounterMyOrderType_buy ? @"order_taker" : @"order_maker";

    switch (self.myOrderType) {
        case OverTheCounterMyOrderType_buy:
        case OverTheCounterMyOrderType_sell:
        case OverTheCounterMyOrderType_arbiters:
        {
            if (self.myOrderType == OverTheCounterMyOrderType_buy){
                self.numTitleLabel.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"购买", nil),self.dic[@"deal_quantity"]];
            }else if (self.myOrderType == OverTheCounterMyOrderType_sell){
                self.numTitleLabel.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"购买", nil),self.dic[@"deal_quantity"]];
            }else if (self.myOrderType == OverTheCounterMyOrderType_arbiters){
                self.numTitleLabel.text = [NSString stringWithFormat:@"%@",self.dic[@"order_sn"]];
            }
            //总额
            NSString *quantitystring = [self.dic[@"deal_quantity"] componentsSeparatedByString:@" "].firstObject;
            NSString *pricestring = [self.dic[@"order_price"] componentsSeparatedByString:@" "].firstObject;
            self.totalLabelB.text = [NSString getMoneyStringWithMoneyNumber:quantitystring.doubleValue * pricestring.doubleValue];
            
            //数量
            self.numLabelT.text = [NSString stringWithFormat:@"%@(MGP)",(self.myOrderType == OverTheCounterMyOrderType_buy ? NSLocalizedString(@"购买", nil) : NSLocalizedString(@"出售", nil)),self.dic[@"deal_quantity"]];
            self.numLabelB.text = [NSString stringWithFormat:@"%.4f",quantitystring.doubleValue];
            
            int timeCount = 0;
            for (NSString *timeStr in @[self.dic[@"taker_passed_at"],self.dic[@"maker_passed_at"],self.dic[@"arbiter_passed_at"]]) {
                if (![timeStr isEqualToString:@"1970-01-01T00:00:00"]) {
                    timeCount++;
                }
            }
            int stateCount = 0;
            for (NSString *timeStr in @[self.dic[@"taker_passed"],self.dic[@"maker_passed"],self.dic[@"arbiter_passed"]]) {
                if (![timeStr isEqualToString:@"0"]) {
                    stateCount++;
                }
            }
            
            
            if ([self.dic[@"taker_passed"]intValue] == 0 && [self.dic[@"closed"]intValue] == 0 && [self.dic[@"taker_passed_at"]isEqualToString:@"1970-01-01T00:00:00"]) {
                
                self.stateLabel.text = NSLocalizedString(@"待付款", nil);

            }else if ([self.dic[@"taker_passed"]intValue] == 1 && [self.dic[@"closed"]intValue] == 0 && ![self.dic[@"taker_passed_at"]isEqualToString:@"1970-01-01T00:00:00"]){
                
                self.stateLabel.text = NSLocalizedString(@"待放行", nil);

                
            }else if (timeCount >= 2 && stateCount >= 2 && [self.dic[@"closed"]intValue] == 1){
                
                self.stateLabel.text = NSLocalizedString(@"交易完成", nil);
                
            }else if ([self.dic[@"closed"]intValue] == 1){
                
                self.stateLabel.text = NSLocalizedString(@"交易取消", nil);
                
            }
            
        }
            break;
        case OverTheCounterMyOrderType_myPos:
        {
            //出售总数和状态
            self.numTitleLabel.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"总出售", nil),self.dic[@"quantity"]];
            self.stateLabel.text = [self.dic[@"closed"] boolValue] ? NSLocalizedString(@"已完成", nil) : NSLocalizedString(@"出售中", nil);
            
            double quantity_str = [[self.dic[@"quantity"] componentsSeparatedByString:@" "].firstObject doubleValue];
            double frozen_quantity_str = [[self.dic[@"frozen_quantity"] componentsSeparatedByString:@" "].firstObject doubleValue];
            double fufilled_quantity_str = [[self.dic[@"fulfilled_quantity"] componentsSeparatedByString:@" "].firstObject doubleValue];
            double quantity = quantity_str - fufilled_quantity_str - frozen_quantity_str;
            
            
            if ([self.dic[@"closed"]boolValue]) {
                
                self.stateLabel.text = fufilled_quantity_str >= quantity_str ? NSLocalizedString(@"已完成", nil) : NSLocalizedString(@"已撤销", nil);

            }else{
                self.stateLabel.text = NSLocalizedString(@"出售中", nil);
            }
            
            
            //总额
            NSString *pricestring = [self.dic[@"price"] componentsSeparatedByString:@" "].firstObject;
            self.totalLabelB.text = [NSString getMoneyStringWithMoneyNumber:quantity * pricestring.doubleValue];
            
            //剩余数量
            self.numLabelB.text = [NSString stringWithFormat:@"%.4f",quantity];
            
            
            
        }
            break;
        default:
            break;
    }

    //时间
    NSDate *date = [NSDate dateFromString:block_time];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    NSTimeInterval time = [timeSp doubleValue];
    
    NSDate *date2=[NSDate dateWithTimeIntervalSince1970:time];
    NSDate *date3 = [date2 dateByAddingHours:8];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
//    [dateformatter setDateFormat:@"YYYY/MM/dd HH:mm:ss"];
    [dateformatter setDateFormat:@"HH:mm MM/dd"];

    NSString *staartstr=[dateformatter stringFromDate:date3];
    [self.timeLabelB setText:staartstr];
    
}
@end
