//
//  CustomizedTabBarController.h
//  TRProject
//
//  Created by tarena on 16/10/9.
//  Copyright © 2016年 Tedu. All rights reserved.
//
//＊＊＊＊＊＊＊＊＊＊＊＊＊自定义标签控制器＊＊＊＊＊＊＊＊＊＊＊＊
#import <UIKit/UIKit.h>

@interface CustomizedTabBarController : UITabBarController
+(CustomizedTabBarController*)sharedCustomizedTabBarController;
-(void)didSelectBarItemAtIndex:(NSInteger)index;
-(void)resetbartitle;
@end
