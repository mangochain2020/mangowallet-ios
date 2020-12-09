//
//  USDTDetailVC.h
//  TaiYiToken
//
//  Created by 张元一 on 2019/4/28.
//  Copyright © 2019 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface USDTDetailVC : UIViewController
@property(nonatomic,strong)MissionWallet *wallet;
@property(nonatomic,strong)UIImage *iconimage;
@property(nonatomic,strong)NSString *symbolname;
@property(nonatomic,strong)NSString *amountstring;
@property(nonatomic,strong)NSString *balancestring;
@property(nonatomic)CGFloat RMBDollarCurrency;
@property(nonatomic,strong)NSMutableArray <MissionWallet*> *walletArray;

@end

NS_ASSUME_NONNULL_END
