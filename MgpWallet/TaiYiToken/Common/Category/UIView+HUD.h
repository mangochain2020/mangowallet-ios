//
//  UIView+HUD.h
//  Day10_PodDemo
//
//  Created by tarena on 16/9/13.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface UIView (HUD)

- (void)showHUD;
- (void)hideHUD;

- (void)showMsg:(NSString *)msg;
- (void)showAlert:(NSString *)title DetailMsg:(NSString *)msg;
@end













