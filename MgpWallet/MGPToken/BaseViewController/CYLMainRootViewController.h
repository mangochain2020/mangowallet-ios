//
//  CYLMainRootViewController.h
//  TaiYiToken
//
//  Created by mac on 2020/7/14.
//  Copyright © 2020 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

#if __has_include(<CYLTabBarController/CYLTabBarController.h>)
#import <CYLTabBarController/CYLTabBarController.h>
#else
#import "CYLTabBarController.h"
#endif

NS_ASSUME_NONNULL_BEGIN

@interface CYLMainRootViewController : UINavigationController

- (CYLTabBarController *)createNewTabBarWithContext:(NSString *)context;


@end

NS_ASSUME_NONNULL_END
