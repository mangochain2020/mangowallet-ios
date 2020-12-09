//
//  SelectEOSAccountVC.h
//  TaiYiToken
//
//  Created by 张元一 on 2018/12/18.
//  Copyright © 2018 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SelectEOSAccountVC : UIViewController
@property(nonatomic,strong)MissionWallet *wallet;
//导入钱包使用
@property(nonatomic,copy)NSString *mnemonic;
@property(nonatomic,copy)NSString *pass;
@end

NS_ASSUME_NONNULL_END
