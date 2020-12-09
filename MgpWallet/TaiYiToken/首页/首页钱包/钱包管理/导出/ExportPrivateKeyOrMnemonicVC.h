//
//  ExportPrivateKeyOrMnemonicVC.h
//  TaiYiToken
//
//  Created by admin on 2018/9/5.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExportPrivateKeyOrMnemonicVC : UIViewController
@property(nonatomic)NSString *privateKey;
@property(nonatomic)NSString *mnemonic;

@property(nonatomic)BOOL isExportPrivateKey;
@property(nonatomic)BOOL isExportMnemonic;
@end
