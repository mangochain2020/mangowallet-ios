//
//  WalletListCell.h
//  TaiYiToken
//
//  Created by admin on 2018/9/3.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"
@interface WalletListCell : MGSwipeTableCell
@property(nonatomic,strong)UIImageView *iconImageView;
@property(nonatomic,strong)UILabel *symbolNamelb;//MIS
@property(nonatomic,strong)UILabel *symboldetaillb;//mistoken
@property(nonatomic,strong)UILabel *addresslb;//0x88DS73214...7f4B5Y468
@property(nonatomic,strong)UILabel *amountlb;//0.02
@property(nonatomic,strong)UILabel *valuelb;//60,338.96
@property(nonatomic,strong)UILabel *rmbvaluelb;//≈￥91,254.62
@property(nonatomic,strong)UILabel *qulb;//
@property(nonatomic,assign)WALLET_TYPE wallettype;

@end
