//
//  ExportWalletVC.h
//  TaiYiToken
//
//  Created by admin on 2018/9/4.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExportWalletVC : UIViewController
@property(nonatomic)MissionWallet *wallet;
@property(nonatomic, copy)void(^updateUserInfoBlock)() ;
@end
