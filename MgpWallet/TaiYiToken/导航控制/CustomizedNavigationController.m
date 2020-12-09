//
//  CustomizedNavigationController.m
//  YJFVideo
//
//  Created by Summer on 14-10-23.
//  Copyright (c) 2014年 Personal. All rights reserved.
//

#import "CustomizedNavigationController.h"

@interface CustomizedNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation CustomizedNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      
    }
    return self;
}
-(void)play{
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    
    _titlelb = [UILabel new];
    _titlelb.textColor = [UIColor textBlackColor];
    _titlelb.textAlignment = NSTextAlignmentCenter;
    _titlelb.font = [UIFont systemFontOfSize:18 weight:0];
    [self.navigationBar addSubview:_titlelb];
    [_titlelb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.top.equalTo(10);
        make.height.equalTo(28);
        make.width.equalTo(100);
    }];
    
    //self.interactivePopGestureRecognizer.delegate = self;
    self.navigationBar.translucent = NO;
//    self.navigationBar.barTintColor = [UIColor colorWithHexString:@"#5091FF"];
    self.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationBar setTintColor:[UIColor textBlackColor]];
    
    UIBarButtonItem *playItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(play)];
    //barMetrics:横竖屏区别
    [playItem setBackgroundImage:[UIImage imageNamed:@"ButtonListHighlighted"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [playItem setBackgroundImage:[UIImage imageNamed:@"ButtonList"]  forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [playItem setImage:[UIImage imageNamed:@"ButtonList"]];
    
    self.navigationItem.rightBarButtonItem = playItem;


}
//设置状态条的样式
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
