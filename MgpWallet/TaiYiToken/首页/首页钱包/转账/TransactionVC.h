//
//  TransactionVC.h
//  TaiYiToken
//
//  Created by admin on 2018/9/13.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransactionVC : UIViewController
@property(nonatomic,strong)MissionWallet *wallet;
@property(nonatomic,copy)NSString *toAddress;//首页扫码所得
@end
