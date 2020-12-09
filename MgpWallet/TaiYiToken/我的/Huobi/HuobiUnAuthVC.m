//
//  HuobiUnAuthVC.m
//  TaiYiToken
//
//  Created by 张元一 on 2019/3/19.
//  Copyright © 2019 admin. All rights reserved.
//

#import "HuobiUnAuthVC.h"

@interface HuobiUnAuthVC ()
@property(nonatomic,strong)UIButton *backBtn;
@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,strong) UIButton *unauthBtn;
@end

@implementation HuobiUnAuthVC

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
    
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont boldSystemFontOfSize:17];
    _titleLabel.textColor = [UIColor textBlackColor];
    _titleLabel.text = NSLocalizedString(@"火币授权", nil);
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(SafeAreaTopHeight - 34);
        make.height.equalTo(25);
        make.left.equalTo(50);
        make.width.equalTo(100);
    }];
    
    _unauthBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _unauthBtn.backgroundColor = RGB(100, 100, 255);
    _unauthBtn.tintColor = [UIColor whiteColor];
    _unauthBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _unauthBtn.layer.cornerRadius = 5;
    _unauthBtn.clipsToBounds = YES;
    [_unauthBtn gradientButtonWithSize:CGSizeMake(ScreenWidth, 44) colorArray:@[[UIColor colorWithHexString:@"#4090F7"],[UIColor colorWithHexString:@"#BBA8FF"],[UIColor colorWithHexString:@"#4090F7"]] percentageArray:@[@(0.3),@(0.7),@(0.3)] gradientType:GradientFromLeftToRight];
    [_unauthBtn setTitle:NSLocalizedString(@"取消授权", nil) forState:UIControlStateNormal];
    [_unauthBtn addTarget:self action:@selector(unAuthAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_unauthBtn];
    _unauthBtn.userInteractionEnabled = YES;
    [_unauthBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(SafeAreaTopHeight + 50);
        make.height.equalTo(44);
        make.left.equalTo(16);
        make.right.equalTo(-16);
    }];
    
}

-(void)unAuthAction{
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    MJWeakSelf
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        });
    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定取消授权？", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [CreateAll SaveHuobiAPIKey:@"" APISecret:@""];
        [weakSelf.view showMsg:NSLocalizedString(@"取消成功", nil)];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        });
    }];

    [alertVc addAction:cancel];
    [alertVc addAction:action1];
    [self presentViewController:alertVc animated:YES completion:nil];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
