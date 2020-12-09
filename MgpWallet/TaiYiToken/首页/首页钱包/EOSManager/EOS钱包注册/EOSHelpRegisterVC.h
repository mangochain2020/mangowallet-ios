//
//  EOSHelpRegisterVC.h
//  TaiYiToken
//
//  Created by 张元一 on 2018/12/27.
//  Copyright © 2018 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EOSHelpRegisterVC : UIViewController
@property(nonatomic,copy)NSString *eosAccount;
@property(nonatomic,copy)NSString *eosAccountActiveKey;
@property(nonatomic,copy)NSString *eosAccountOwnerKey;
@property(nonatomic,assign)CoinType coinType;

@end

NS_ASSUME_NONNULL_END
