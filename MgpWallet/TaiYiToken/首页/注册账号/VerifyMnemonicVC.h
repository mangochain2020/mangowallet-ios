//
//  VerifyMnemonicVC.h
//  TaiYiToken
//
//  Created by Frued on 2018/8/20.
//  Copyright © 2018年 Frued. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerifyMnemonicVC : UIViewController
@property(nonatomic)NSString *mnemonic;
@property(nonatomic,copy)NSString *password;
@property(assign, nonatomic)CoinType coinType;
@property(nonatomic,strong)MissionWallet *baseWallet;

@end
