//
//  LoginVC.m
//  TaiYiToken
//
//  Created by Frued on 2018/10/17.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "LoginVC.h"
#import "RegisterVC.h"
#import "BindPhoneVC.h"
#import "BindMailVC.h"
#import "ForgetPasswordVC.h"
#import "WebVC.h"
#import "AppDelegate.h"
#import "CYLMainRootViewController.h"
#import "CreateAccountVC.h"


@interface LoginVC ()
@property(nonatomic,strong)UIButton *backBtn;
@property(nonatomic,strong)UILabel *headlabel;
@property(nonatomic,strong)UILabel *detaillabel;
@property(nonatomic,strong)UILabel *remindlabel;
@property(nonatomic,strong)UILabel *remindlb;
@property(nonatomic,strong) UITextField *userNameTextField;
@property(nonatomic,strong) UITextField *passwordTextField;
@property(nonatomic,strong) UIButton *forgotPasswordBtn;
@property(nonatomic,strong) UIButton *goToRegisterBtn;
@property(nonatomic,strong) UIButton *loginBtn;
@property(nonatomic,strong) UIButton *protocolBtn;

@end

@implementation LoginVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    self.navigationController.hidesBottomBarWhenPushed = YES;
   //self.tabBarController.tabBar.hidden = YES;
    _userNameTextField.attributedPlaceholder =[[NSAttributedString alloc]initWithString: NSLocalizedString(@"账户名/邮箱/手机号", nil)];
    _passwordTextField.attributedPlaceholder =[[NSAttributedString alloc]initWithString: NSLocalizedString(@"密码", nil)];
    [_forgotPasswordBtn setTitle:NSLocalizedString(@"忘记密码？", nil) forState:UIControlStateNormal];
    [_loginBtn setTitle:NSLocalizedString(@"登录", nil) forState:UIControlStateNormal];
    [_goToRegisterBtn setTitle:NSLocalizedString(@"新用户注册", nil) forState:UIControlStateNormal];
    _remindlb.text = NSLocalizedString(@"登录即表示您同意", nil);
    [_protocolBtn setTitle:NSLocalizedString(@"《隐私政策》", nil) forState:UIControlStateNormal];
    _remindlabel.text = NSLocalizedString(@"MGPChain基于帐户体系，需要登录使用", nil);
    if ([CreateAll isLogin]) {
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
   // self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.hidesBottomBarWhenPushed = YES;
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
    _headlabel = [[UILabel alloc] init];
    _headlabel.textColor = [UIColor blackColor];
    _headlabel.font = [UIFont boldSystemFontOfSize:26];
    _headlabel.text = NSLocalizedString(@"您好，", nil);
    _headlabel.textAlignment = NSTextAlignmentLeft;
    _headlabel.numberOfLines = 1;
    [headBackView addSubview:_headlabel];
    [_headlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(17);
        make.top.equalTo(SafeAreaTopHeight + 16);
        make.width.equalTo(200);
        make.height.equalTo(30);
    }];
    _detaillabel = [[UILabel alloc] init];
    _detaillabel.textColor = [UIColor textGrayColor];
    _detaillabel.font = [UIFont systemFontOfSize:17];
    _detaillabel.text = NSLocalizedString(@"欢迎使用", nil);
    _detaillabel.textAlignment = NSTextAlignmentLeft;
    _detaillabel.numberOfLines = 1;
    [headBackView addSubview:_detaillabel];
    [_detaillabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(17);
        make.top.equalTo(SafeAreaTopHeight + 51);
        make.width.equalTo(200);
        make.height.equalTo(20);
    }];
    
    if (self.showBackBtn == YES) {
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
    }
    
    _userNameTextField = [UITextField new];
    
    _userNameTextField.backgroundColor = [UIColor whiteColor];
    _userNameTextField.textAlignment = NSTextAlignmentLeft;
    _userNameTextField.textColor = [UIColor darkGrayColor];
    _userNameTextField.font = [UIFont systemFontOfSize:16];
    _userNameTextField.text = @"lohasalgor12";
    [self.view addSubview:_userNameTextField];
    [_userNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(180);
        make.height.equalTo(40);
        make.left.equalTo(16);
        make.right.equalTo(-50);
    }];
    
    _passwordTextField = [UITextField new];
   
    _passwordTextField.backgroundColor = [UIColor whiteColor];
    _passwordTextField.textAlignment = NSTextAlignmentLeft;
    _passwordTextField.textColor = [UIColor darkGrayColor];
    _passwordTextField.font = [UIFont systemFontOfSize:16];
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.text = @"lohasal";

    [self.view addSubview:_passwordTextField];
    [_passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userNameTextField.mas_bottom).equalTo(20);
        make.height.equalTo(40);
        make.left.equalTo(16);
        make.right.equalTo(-50);
    }];
    
    _forgotPasswordBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _forgotPasswordBtn.backgroundColor = [UIColor clearColor];
    _forgotPasswordBtn.tintColor = [UIColor textGrayColor];
    _forgotPasswordBtn.titleLabel.textColor = [UIColor textGrayColor];
    _forgotPasswordBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [_forgotPasswordBtn addTarget:self action:@selector(forgotPasswordAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_forgotPasswordBtn];
    _forgotPasswordBtn.userInteractionEnabled = YES;
    [_forgotPasswordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.passwordTextField.mas_bottom).equalTo(10);
        make.height.equalTo(20);
        make.right.equalTo(-16);
        make.width.equalTo(120);
    }];
    
    _loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _loginBtn.backgroundColor = RGB(100, 100, 255);
    _loginBtn.tintColor = [UIColor whiteColor];
    _loginBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _loginBtn.layer.cornerRadius = 5;
    _loginBtn.clipsToBounds = YES;
    [_loginBtn gradientButtonWithSize:CGSizeMake(ScreenWidth, 44) colorArray:@[[UIColor colorWithHexString:@"#4090F7"],[UIColor colorWithHexString:@"#BBA8FF"],[UIColor colorWithHexString:@"#4090F7"]] percentageArray:@[@(0.3),@(0.7),@(0.3)] gradientType:GradientFromLeftToRight];
   
    [_loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginBtn];
    _loginBtn.userInteractionEnabled = YES;
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.passwordTextField.mas_bottom).equalTo(40);
        make.height.equalTo(44);
        make.left.equalTo(16);
        make.right.equalTo(-16);
    }];
    
    _goToRegisterBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _goToRegisterBtn.backgroundColor = [UIColor whiteColor];
    _goToRegisterBtn.layer.cornerRadius = 2;
    _goToRegisterBtn.layer.masksToBounds = YES;
    _goToRegisterBtn.layer.borderColor = [UIColor grayColor].CGColor;
    _goToRegisterBtn.layer.borderWidth = 1;
    _goToRegisterBtn.tintColor = RGB(100, 100, 255);
    _goToRegisterBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [_goToRegisterBtn addTarget:self action:@selector(goToRegisterAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_goToRegisterBtn];
    _goToRegisterBtn.userInteractionEnabled = YES;
    [_goToRegisterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.loginBtn.mas_bottom).equalTo(5);
        make.height.equalTo(44);
        make.left.equalTo(16);
        make.right.equalTo(-16);
    }];
    
    _remindlb = [[UILabel alloc] init];
    _remindlb.textColor = [UIColor blackColor];
    _remindlb.font = [UIFont boldSystemFontOfSize:12];
    _remindlb.textAlignment = NSTextAlignmentRight;
    _remindlb.numberOfLines = 1;
    [self.view addSubview:_remindlb];
    [_remindlb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.goToRegisterBtn.mas_bottom).equalTo(10);
        make.height.equalTo(20);
        make.left.equalTo(30);
        make.right.equalTo(-kScreenWidth/2 + 5);
    }];

    _protocolBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _protocolBtn.backgroundColor = [UIColor clearColor];
    _protocolBtn.tintColor = RGB(100, 100, 255);
    _protocolBtn.titleLabel.textColor = [UIColor textBlueColor];
    _protocolBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    _protocolBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    
    [_protocolBtn addTarget:self action:@selector(seeProtocol) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_protocolBtn];
    _protocolBtn.userInteractionEnabled = YES;
    [_protocolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.goToRegisterBtn.mas_bottom).equalTo(10);
        make.left.equalTo(kScreenWidth/2);
        make.width.equalTo(120);
        make.height.equalTo(20);
    }];
    
    _remindlabel = [[UILabel alloc] init];
    _remindlabel.textColor = [UIColor grayColor];
    _remindlabel.font = [UIFont systemFontOfSize:10];
    
    _remindlabel.textAlignment = NSTextAlignmentCenter;
    _remindlabel.numberOfLines = 0;
    [self.view addSubview:_remindlabel];
    [_remindlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.protocolBtn.mas_bottom).equalTo(10);
        make.height.equalTo(40);
        make.left.equalTo(30);
        make.right.equalTo(-30);
    }];
}
//隐私政策
-(void)seeProtocol{
    WebVC *vc = [WebVC new];
    NSString *current = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLanguageSelected"];
    if ([current isEqualToString:@"chinese"]) {
        vc.urlstring = PrivacyPolicyURL_CHS;
    }else{
        vc.urlstring = PrivacyPolicyURL_EN;
    }
    [self.navigationController pushViewController:vc animated:YES];
}
//connect witness since monkey bar grace retire feed level segment veteran cloud---
-(void)forgotPasswordAction{
    ForgetPasswordVC *vc = [ForgetPasswordVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)login{
    NSString *username = self.userNameTextField.text;
    if (username == nil || username.length < 1) {
        [self.view showMsg:NSLocalizedString(@"用户名不能为空！", nil)];
        return;
    }
    NSString *pass = self.passwordTextField.text;
//    if (![NSString checkPassword:pass] ) {
//        [self.view showMsg:NSLocalizedString(@"请输入8-18位字符！", nil)];
//        return;
//    }
    if (pass == nil || pass.length < 1) {
        [self.view showMsg:NSLocalizedString(@"密码不能为空！", nil)];
        return;
    }
    if ([CreateAll GetWalletNameArray].count <= 0) {
        CreateAccountVC *vc = [[CreateAccountVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];

    }else{
        UIWindow *window = ((AppDelegate*)([UIApplication sharedApplication].delegate)).window;
        CYLMainRootViewController *csVC = [[CYLMainRootViewController alloc] init];
        window.rootViewController = csVC;
    }
    
    /*
    [self.view showHUD];
    MJWeakSelf
    [NetManager LoginWithLoginName:username Password:pass completionHandler:^(id responseObj, NSError *error) {
        [weakSelf.view hideHUD];
        if (!error) {
            if (![[NSString stringWithFormat:@"%@",responseObj[@"resultCode"]] isEqualToString:@"20000"]) {
                [weakSelf.view showAlert:[NSString stringWithFormat:@"Error:%ld",error.code] DetailMsg:responseObj[@"resultMsg"]];
                return ;
            }
            NSMutableDictionary *dic;
            dic = responseObj[@"data"];
            if([dic isEqual:[NSNull null]]){
                [weakSelf.view showMsg:NSLocalizedString(@"登录失败！", nil)];
                return;
            }
            __block UserInfoModel *loginmodel =  [UserInfoModel parse:dic];
            [CreateAll SaveUserName:loginmodel.loginName Password:pass];
            [CreateAll SaveCurrentUser:loginmodel];
            //登陆成功通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"userlogin" object:nil];
            dispatch_async_on_main_queue(^{
                [weakSelf.view showMsg:NSLocalizedString(@"登录成功！", nil)];
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            });
        }else{
            [weakSelf.view showAlert:[NSString stringWithFormat:@"Error:%ld",error.code] DetailMsg:error.localizedDescription];
        }
    }];
   */
}



-(void)goToRegisterAction{
    RegisterVC *revc = [RegisterVC new];
    [self.navigationController pushViewController:revc animated:YES];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
