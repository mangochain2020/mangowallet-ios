//
//  WalletDetailVC.h
//  TaiYiToken
//
//  Created by Frued on 2018/10/22.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WalletDetailVC : UIViewController
@property(nonatomic,strong)MissionWallet *wallet;
@property(nonatomic,strong)UIImage *iconimage;
@property(nonatomic,strong)NSString *symbolname;
@property(nonatomic,strong)NSString *amountstring;
@property(nonatomic,strong)NSString *balancestring;
@property(nonatomic)CGFloat RMBDollarCurrency;
@property(nonatomic,strong)NSMutableArray <MissionWallet*> *walletArray;
@property(nonatomic,strong)NSMutableArray *btcChangeAddressArray;
@end

NS_ASSUME_NONNULL_END
