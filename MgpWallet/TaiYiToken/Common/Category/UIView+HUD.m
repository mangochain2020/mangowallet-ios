//
//  UIView+HUD.m
//  Day10_PodDemo
//
//  Created by tarena on 16/9/13.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "UIView+HUD.h"

@implementation UIView (HUD)
- (void)showHUD{
    [self hideHUD];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.opaque = NO;
    hud.bezelView.backgroundColor = [UIColor darkGrayColor];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.animationType = MBProgressHUDAnimationZoomIn;
    hud.contentColor = [UIColor whiteColor];
    //转圈提示 最长30秒
    [hud hideAnimated:YES afterDelay:30];
}

- (void)hideHUD{
    [MBProgressHUD hideHUDForView:self animated:YES];
}

- (void)showMsg:(NSString *)msg{
    [self hideHUD];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.mode = MBProgressHUDModeText;
    //    hud.bezelView.layer.shadowColor = [UIColor grayColor].CGColor;
    //    hud.bezelView.layer.shadowOffset = CGSizeMake(0, 0);
    //    hud.bezelView.layer.shadowOpacity = 1;
    hud.bezelView.layer.shadowRadius = 3.0;
    hud.bezelView.layer.cornerRadius = 3.0;
    hud.bezelView.alpha = 0.8;
    hud.bezelView.clipsToBounds = YES;
    hud.bezelView.backgroundColor = [UIColor darkGrayColor];
    hud.contentColor = [UIColor whiteColor];
    hud.detailsLabel.text = msg;
    [hud.detailsLabel setFont:[UIFont systemFontOfSize:15]];
    [hud hideAnimated:YES afterDelay:2];
    
}

- (void)showAlert:(NSString *)title DetailMsg:(NSString *)msg{
    [self hideHUD];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.bezelView.layer.shadowColor = [UIColor grayColor].CGColor;
    hud.bezelView.layer.shadowOffset = CGSizeMake(0, 0);
    hud.bezelView.layer.shadowOpacity = 1;
    hud.bezelView.layer.shadowRadius = 3.0;
    hud.bezelView.layer.cornerRadius = 3.0;
    hud.bezelView.layer.masksToBounds = NO;
    hud.bezelView.backgroundColor = [UIColor darkGrayColor];
    hud.contentColor = [UIColor whiteColor];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = title;
    hud.detailsLabel.text = [NSString stringWithFormat:NSLocalizedString(msg, nil)];
    [hud hideAnimated:YES afterDelay:2.0];
}
@end





