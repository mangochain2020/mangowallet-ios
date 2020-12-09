//
//  DataView.h
//  TaiYiToken
//
//  Created by Frued on 2018/8/17.
//  Copyright © 2018年 Frued. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataView : UIView

@property(nonatomic,strong)UILabel *dollarlabel;//6710.01
@property(nonatomic,strong)UILabel *rmblabel;//≈￥45795.81
@property(nonatomic,strong)UILabel *ratelabel;//120.00 120.00
//流通市值  总额(24h)  成交量(24h)
// 1,945亿 255.14亿 9289
@property(nonatomic,strong)UILabel *marketVolumelabel;
@property(nonatomic,strong)UILabel *totalPricelabel;
@property(nonatomic,strong)UILabel *amountlabel;

//最高(24h)  最低(24h)
// 12945.00 12552.00
@property(nonatomic,strong)UILabel *highpricelabel;
@property(nonatomic,strong)UILabel *lowpricelabel;


@end
