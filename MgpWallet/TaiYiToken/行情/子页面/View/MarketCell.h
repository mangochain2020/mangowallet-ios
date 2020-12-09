//
//  MarketCell.h
//  TaiYiToken
//
//  Created by Frued on 2018/8/15.
//  Copyright © 2018年 Frued. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MarketCell : UITableViewCell
@property (strong, nonatomic) UIImageView *iconImageView;
@property(nonatomic,strong)UILabel *coinNamelabel;//ETH
@property(nonatomic,strong)UILabel *coinNameDetaillabel;//BTC

@property(nonatomic,strong)UILabel *namelabel;//火币pro,以太坊

@property(nonatomic,strong)UILabel *dollarPricelabel;//dollarPrice
@property(nonatomic,strong)UILabel *rmbPricelabel;//=¥
@property(nonatomic)UIButton *rateBtn;


/*
 deprated
 */
//@property(nonatomic,strong)UILabel *marketValuelabel;
//@property(nonatomic,strong)UILabel *pricelabel;//￥4,299,90

@end
