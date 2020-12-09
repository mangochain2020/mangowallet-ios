//
//  MisBaseViewController.m
//  TaiYiToken
//
//  Created by 张元一 on 2019/3/8.
//  Copyright © 2019 admin. All rights reserved.
//

#import "MisBaseViewController.h"

@interface MisBaseViewController ()

@end

@implementation MisBaseViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self thescrollView];
    
}




-(UIScrollView *)thescrollView{
    if (_thescrollView == nil) {
        _thescrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _thescrollView.backgroundColor = [UIColor whiteColor];
        _thescrollView.showsVerticalScrollIndicator = NO;
        _thescrollView.showsHorizontalScrollIndicator = NO;
        _thescrollView.scrollEnabled = YES;
        _thescrollView.userInteractionEnabled = YES;
        _thescrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight*1.2);
        
        _thescrollView.scrollsToTop = YES;
        [self.view addSubview:_thescrollView];
        [_thescrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.top.equalTo(0);
            make.bottom.equalTo(0);
        }];
        _bridgeContentView = [UIView new];
        _bridgeContentView.backgroundColor = [UIColor whiteColor];
        _bridgeContentView.userInteractionEnabled = YES;
        [self.thescrollView addSubview:_bridgeContentView];
        [_bridgeContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.thescrollView);
            make.width.height.equalTo(self.thescrollView.contentSize);
        }];
    }
    
    return _thescrollView;
}

@end
