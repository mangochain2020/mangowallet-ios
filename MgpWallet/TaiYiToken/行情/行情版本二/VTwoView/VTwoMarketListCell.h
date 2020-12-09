//
//  VTwoMarketListCell.h
//  TaiYiToken
//
//  Created by 张元一 on 2018/11/21.
//  Copyright © 2018 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VTwoMarketListCell : UITableViewCell
@property (strong, nonatomic) UIImageView *iconImageView;
@property(nonatomic,strong)UILabel *coinNamelabel;//BTC
@property(nonatomic,strong)UILabel *coinNameDetaillabel;//排名，市值

@property(nonatomic,strong)UILabel *namelabel;//Bitcoin

@property(nonatomic,strong)UILabel *pricelabel;//dollarPrice
//@property(nonatomic,strong)UILabel *rmbPricelabel;//=¥
@property(nonatomic,strong)UIButton *rateBtn;
@end

NS_ASSUME_NONNULL_END
