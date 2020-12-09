//
//  VTwoMarketDetailVC.h
//  TaiYiToken
//
//  Created by 张元一 on 2018/11/22.
//  Copyright © 2018 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarketTicketModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface VTwoMarketDetailVC : UIViewController
@property(nonatomic,strong)MarketTicketModel *marketModel;
@property(nonatomic,assign)CGFloat RMBDollarCurrency;//人民币汇率
@property(nonatomic,strong)NSString *rank;
@end

NS_ASSUME_NONNULL_END
