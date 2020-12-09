//
//  VTwoDataView.h
//  TaiYiToken
//
//  Created by 张元一 on 2018/11/21.
//  Copyright © 2018 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VTwoDataView : UIView
@property(nonatomic,strong)UILabel *commentlabel;//ETH全网实时价格，24h涨幅
@property(nonatomic,strong)UILabel *pricelabel;//￥1485
@property(nonatomic,strong)UILabel *ratelabel;//-0.1% -1.49
@property(nonatomic,strong)UILabel *infolabel;//=¥214 = 0.033BTC = 1ETH

@property(nonatomic,strong)UILabel *highpricelabel;//高
@property(nonatomic,strong)UILabel *lowpricelabel;//低
@property(nonatomic,strong)UILabel *volumelabel;//额
@property(nonatomic,strong)UILabel *marketVolumelabel;//市值
@property(nonatomic,strong)UILabel *changeratelabel;//换
@property(nonatomic,strong)UILabel *ranklabel;//排名
@end

NS_ASSUME_NONNULL_END
