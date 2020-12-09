//
//  ImportHDWalletVC.h
//  TaiYiToken
//
//  Created by admin on 2018/9/25.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImportHDWalletVC : UIViewController
//2000 验证导入的助记词是否正确，与链上作对比
@property(nonatomic,assign)NSInteger ifverify;
@property(nonatomic,copy)NSString *pubkeyInChain;
@end
