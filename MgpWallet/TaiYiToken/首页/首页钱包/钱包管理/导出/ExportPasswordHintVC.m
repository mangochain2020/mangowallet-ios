//
//  ExportPasswordHintVC.m
//  TaiYiToken
//
//  Created by admin on 2018/9/29.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "ExportPasswordHintVC.h"

@interface ExportPasswordHintVC ()
@property(nonatomic,strong) UIButton *backBtn;
@property(nonatomic)UILabel *titleLabel;
@property(nonatomic)UITextField *passwordHintTextField;
@property(nonatomic,strong)UIButton *UpdatePasswordHintBtn;
@end

@implementation ExportPasswordHintVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
//    self.navigationController.navigationBar.hidden = YES;
//    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
//    self.navigationController.hidesBottomBarWhenPushed = YES;
//    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
//    self.tabBarController.tabBar.hidden = NO;
//    self.navigationController.navigationBar.hidden = NO;
//    self.navigationController.hidesBottomBarWhenPushed = NO;
   
}
- (void)popAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor ExportBackgroundColor];
//    [self initHeadView];
    self.title = NSLocalizedString(@"密码提示信息", nil);
    [self initUI];
   
}
-(void)initUI{
    UIView *labelView = [UIView new];
    labelView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:labelView];
    [labelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(8);
        make.height.equalTo(40);
    }];
    
    _passwordHintTextField = [UITextField new];
    _passwordHintTextField.textColor = [UIColor blackColor];
    _passwordHintTextField.backgroundColor = [UIColor clearColor];
    _passwordHintTextField.text = self.passwordHint;
    _passwordHintTextField.textAlignment = NSTextAlignmentLeft;
    _passwordHintTextField.font = [UIFont systemFontOfSize:15];
    [labelView addSubview:_passwordHintTextField];
    [_passwordHintTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.right.equalTo(-10);
        make.centerY.equalTo(0);
        make.height.equalTo(30);
    }];
    
    _UpdatePasswordHintBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _UpdatePasswordHintBtn.backgroundColor = [UIColor clearColor];
    _UpdatePasswordHintBtn.tintColor = [UIColor textBlackColor];
    [_UpdatePasswordHintBtn setTitle:NSLocalizedString(@"完成", nil) forState:UIControlStateNormal];
    _UpdatePasswordHintBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    _UpdatePasswordHintBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [_UpdatePasswordHintBtn addTarget:self action:@selector(UpdatePasswordHint) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_UpdatePasswordHintBtn];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_UpdatePasswordHintBtn];

    _UpdatePasswordHintBtn.userInteractionEnabled = YES;
//    [_UpdatePasswordHintBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(SafeAreaTopHeight - 34);
//        make.height.equalTo(25);
//        make.right.equalTo(-10);
//        make.width.equalTo(80);
//    }];
}
-(void)UpdatePasswordHint{
    if(self.wallet.walletType == IMPORT_WALLET){
        self.wallet.passwordHint = self.passwordHintTextField.text == nil?@"":self.passwordHintTextField.text;
        [CreateAll SaveWallet:self.wallet Name:self.wallet.walletName WalletType:self.wallet.walletType Password:nil];
        [self.view showMsg:NSLocalizedString(@"成功", nil)];
    }else{
        [CreateAll UpdatePasswordHint:self.passwordHintTextField.text == nil?@"":self.passwordHintTextField.text];
        [self.view showMsg:NSLocalizedString(@"成功", nil)];
    }
}
-(void)initHeadView{
    UIView *headBackView = [UIView new];
    headBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headBackView];
    [headBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(0);
        make.height.equalTo(SafeAreaTopHeight);
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
    
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont boldSystemFontOfSize:17];
    _titleLabel.textColor = [UIColor textBlackColor];
    [_titleLabel setText:[NSString stringWithFormat:NSLocalizedString(@"密码提示信息", nil)]];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(SafeAreaTopHeight - 30);
        make.left.equalTo(45);
        make.width.equalTo(200);
        make.height.equalTo(20);
    }];
    
}


@end
