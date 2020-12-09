//
//  ForgetPasswordVC.m
//  TaiYiToken
//
//  Created by Frued on 2018/10/19.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "ForgetPasswordVC.h"
#import "ResetByMobileVC.h"
#import "ResetByMailVC.h"
@interface ForgetPasswordVC ()
@property(nonatomic,strong)UIButton *backBtn;
@property(nonatomic,strong)UILabel *titlelabel;
@property(nonatomic,strong) UIButton *resetByMobileBtn;
@property(nonatomic,strong) UIButton *resetByMailBtn;
@end

@implementation ForgetPasswordVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    self.navigationController.hidesBottomBarWhenPushed = YES;
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.hidesBottomBarWhenPushed = NO;
}
- (void)popAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initHeadView];
}

-(void)initHeadView{
    UIView *headBackView = [UIView new];
    headBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headBackView];
    [headBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(0);
        make.height.equalTo(150);
    }];
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.backgroundColor = [UIColor clearColor];
    _backBtn.tintColor = [UIColor whiteColor];
    [_backBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [_backBtn setImage:[UIImage imageNamed:@"ico_right_arrow"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backBtn];
    _backBtn.userInteractionEnabled = YES;
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(SafeAreaTopHeight - 34);
        make.height.equalTo(25);
        make.left.equalTo(10);
        make.width.equalTo(30);
    }];
    
    _titlelabel = [[UILabel alloc] init];
    _titlelabel.textColor = [UIColor blackColor];
    _titlelabel.font = [UIFont boldSystemFontOfSize:18];
    _titlelabel.text = NSLocalizedString(@"忘记密码", nil);
    _titlelabel.textAlignment = NSTextAlignmentCenter;
    _titlelabel.numberOfLines = 1;
    [headBackView addSubview:_titlelabel];
    [_titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.top.equalTo(SafeAreaTopHeight - 34);
        make.width.equalTo(200);
        make.height.equalTo(20);
    }];
    
    _resetByMobileBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _resetByMobileBtn.backgroundColor = RGB(100, 100, 255);
    _resetByMobileBtn.tintColor = [UIColor whiteColor];
    _resetByMobileBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _resetByMobileBtn.layer.cornerRadius = 5;
    _resetByMobileBtn.clipsToBounds = YES;
    [_resetByMobileBtn gradientButtonWithSize:CGSizeMake(ScreenWidth, 44) colorArray:@[[UIColor colorWithHexString:@"#4090F7"],[UIColor colorWithHexString:@"#BBA8FF"],[UIColor colorWithHexString:@"#4090F7"]] percentageArray:@[@(0.3),@(0.7),@(0.3)] gradientType:GradientFromLeftToRight];
    [_resetByMobileBtn setTitle:NSLocalizedString(@"通过手机找回", nil) forState:UIControlStateNormal];
    [_resetByMobileBtn addTarget:self action:@selector(resetByMobile) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_resetByMobileBtn];
    _resetByMobileBtn.userInteractionEnabled = YES;
    [_resetByMobileBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(250);
        make.height.equalTo(44);
        make.left.equalTo(16);
        make.right.equalTo(-16);
    }];
    
    _resetByMailBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _resetByMailBtn.backgroundColor = [UIColor whiteColor];
    _resetByMailBtn.layer.cornerRadius = 2;
    _resetByMailBtn.layer.masksToBounds = YES;
    _resetByMailBtn.layer.borderColor = [UIColor grayColor].CGColor;
    _resetByMailBtn.layer.borderWidth = 1;
    _resetByMailBtn.tintColor = RGB(100, 100, 255);
    _resetByMailBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_resetByMailBtn setTitle:NSLocalizedString(@"通过邮箱找回", nil) forState:UIControlStateNormal];
    [_resetByMailBtn addTarget:self action:@selector(resetByMail) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_resetByMailBtn];
    _resetByMailBtn.userInteractionEnabled = YES;
    [_resetByMailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.resetByMobileBtn.mas_bottom).equalTo(5);
        make.height.equalTo(44);
        make.left.equalTo(16);
        make.right.equalTo(-16);
    }];
    
    
    
}


-(void)resetByMobile{
    ResetByMobileVC *vc = [ResetByMobileVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)resetByMail{
    ResetByMailVC *vc = [ResetByMailVC new];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
