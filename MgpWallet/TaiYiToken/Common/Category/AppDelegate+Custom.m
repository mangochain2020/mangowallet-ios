//
//  AppDelegate+Custom.m
//  TRProject
//
//  Created by tarena on 16/9/29.
//  Copyright © 2016年 Tedu. All rights reserved.
//

#import "AppDelegate+Custom.h"
#import "AFNetworkActivityIndicatorManager.h"
@implementation AppDelegate (Custom)
-(void)configClobalSystem{
    //图片的统一配置
    [UIImageView appearance].clipsToBounds = YES;
    [UIImageView appearance].contentMode = UIViewContentModeScaleAspectFill;
    
    //AF有网络操作的状态栏提示
    [AFNetworkActivityIndicatorManager sharedManager].enabled=YES;
}


//为保证AppDelegate的整洁，把不常用的代码分到另一个类

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

@end
