//
//  EOSWalletRegister.h
//  TaiYiToken
//
//  Created by 张元一 on 2018/12/11.
//  Copyright © 2018 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
//页面只用于刚创建钱包未注册EOS账号情况
@interface EOSWalletRegister : UIViewController
@property(nonatomic,strong)MissionWallet *wallet;
@end
NS_ASSUME_NONNULL_END
