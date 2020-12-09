//
//  WalletListViewController.h
//  TaiYiToken
//
//  Created by mac on 2020/7/10.
//  Copyright © 2020 admin. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    PushWalletDetail = 1,
    PushImportVC = 2,
    PushCreateVC = 3,
    ReloadDataWallet = 4,
} WalletListBlockType;


NS_ASSUME_NONNULL_BEGIN

typedef void (^ReturnBlock)(UIViewController *vc,MissionWallet *wallet,WalletListBlockType type);
@interface WalletListViewController : UIViewController

@property (copy ,nonatomic) ReturnBlock returnBlock;

- (void)returnWithBlock:(ReturnBlock)block;
@end

NS_ASSUME_NONNULL_END
