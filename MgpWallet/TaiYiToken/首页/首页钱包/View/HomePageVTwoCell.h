//
//  HomePageVTwoCell.h
//  TaiYiToken
//
//  Created by 张元一 on 2019/4/24.
//  Copyright © 2019 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface HomePageVTwoCell : MGSwipeTableCell
@property(nonatomic,strong)UIImageView *iconImageView;
@property(nonatomic,strong)UILabel *symbolNamelb;//MIS
@property(nonatomic,strong)UILabel *symboldetaillb;//mistoken
@property(nonatomic,strong)UILabel *amountlb;//0.02
@property(nonatomic,assign)WALLET_TYPE wallettype;
@property(nonatomic,strong)UILabel *rmbvaluelb;//≈￥91,254.62

@property(nonatomic,strong)UIButton *closeBtn;
@end

NS_ASSUME_NONNULL_END
