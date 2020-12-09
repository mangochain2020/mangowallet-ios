//
//  RegisterVC.m
//  TaiYiToken
//
//  Created by Frued on 2018/10/17.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "RegisterVC.h"
#import "UserInfoModel.h"
@interface RegisterVC ()<UITextFieldDelegate>
@property(nonatomic,strong)UILabel *titlelabel;
@property(nonatomic,strong)UIButton *backBtn;
@property(nonatomic,strong)UILabel *headlabel;
@property(nonatomic,strong)UILabel *detaillabel;


@property(nonatomic,strong) UITextField *userNameTextField;
@property(nonatomic,strong) UITextField *passwordTextField;
@property(nonatomic,strong) UITextField *repeatpasswordTextField;
@property(nonatomic,strong) UIButton *confirmBtn;

@end

@implementation RegisterVC
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.userNameTextField) {
        if (range.length == 1 && string.length == 0) {
            return YES;
        }else if (self.userNameTextField.text.length >= 12) {
            [self.view showAlert:@"" DetailMsg:NSLocalizedString(@"用户名为6-12位的字符，包含a-z,1-5！", nil)];
            self.userNameTextField.text = [textField.text substringToIndex:12];
            return NO;
        }
    }
    return YES;
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
    _titlelabel = [[UILabel alloc] init];
    _titlelabel.textColor = [UIColor blackColor];
    _titlelabel.font = [UIFont boldSystemFontOfSize:18];
    _titlelabel.text = NSLocalizedString(@"账户注册", nil);
    _titlelabel.textAlignment = NSTextAlignmentCenter;
    _titlelabel.numberOfLines = 1;
    [headBackView addSubview:_titlelabel];
    [_titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.top.equalTo(SafeAreaTopHeight - 34);
        make.width.equalTo(200);
        make.height.equalTo(20);
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
    
    _userNameTextField = [UITextField new];
    _userNameTextField.placeholder = NSLocalizedString(@"账户名(6-12位的字符，包含a-z,1-5)", nil);
    _userNameTextField.backgroundColor = [UIColor whiteColor];
    _userNameTextField.textAlignment = NSTextAlignmentLeft;
    _userNameTextField.textColor = [UIColor darkGrayColor];
    _userNameTextField.font = [UIFont systemFontOfSize:16];
    _userNameTextField.delegate = self;
    _userNameTextField.text = @"lohasalgor12";
    [self.view addSubview:_userNameTextField];
    [_userNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SafeAreaTopHeight + 154);
        make.height.equalTo(40);
        make.left.equalTo(16);
        make.right.equalTo(-50);
    }];
    
    _passwordTextField = [UITextField new];
    _passwordTextField.placeholder = NSLocalizedString(@"设置登录密码(8-18位字符)", nil);
    _passwordTextField.backgroundColor = [UIColor whiteColor];
    _passwordTextField.textAlignment = NSTextAlignmentLeft;
    _passwordTextField.textColor = [UIColor darkGrayColor];
    _passwordTextField.font = [UIFont systemFontOfSize:16];
    _passwordTextField.secureTextEntry = YES;
    [self.view addSubview:_passwordTextField];
    [_passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userNameTextField.mas_bottom).equalTo(20);
        make.height.equalTo(40);
        make.left.equalTo(16);
        make.right.equalTo(-50);
    }];
    
    _repeatpasswordTextField = [UITextField new];
    _repeatpasswordTextField.placeholder = NSLocalizedString(@"确认登录密码", nil);
    _repeatpasswordTextField.backgroundColor = [UIColor whiteColor];
    _repeatpasswordTextField.textAlignment = NSTextAlignmentLeft;
    _repeatpasswordTextField.textColor = [UIColor darkGrayColor];
    _repeatpasswordTextField.font = [UIFont systemFontOfSize:16];
    _repeatpasswordTextField.secureTextEntry = YES;

    [self.view addSubview:_repeatpasswordTextField];
    [_repeatpasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.passwordTextField.mas_bottom).equalTo(20);
        make.height.equalTo(40);
        make.left.equalTo(16);
        make.right.equalTo(-50);
    }];
   
    
    _confirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _confirmBtn.backgroundColor = RGB(100, 100, 255);
    _confirmBtn.tintColor = [UIColor whiteColor];
    _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _confirmBtn.layer.cornerRadius = 5;
    _confirmBtn.clipsToBounds = YES;
    [_confirmBtn gradientButtonWithSize:CGSizeMake(ScreenWidth, 44) colorArray:@[[UIColor colorWithHexString:@"#4090F7"],[UIColor colorWithHexString:@"#BBA8FF"],[UIColor colorWithHexString:@"#4090F7"]] percentageArray:@[@(0.3),@(0.7),@(0.3)] gradientType:GradientFromLeftToRight];
    [_confirmBtn setTitle:NSLocalizedString(@"完成", nil) forState:UIControlStateNormal];
    [_confirmBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_confirmBtn];
    _confirmBtn.userInteractionEnabled = YES;
    [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.repeatpasswordTextField.mas_bottom).equalTo(40);
        make.height.equalTo(44);
        make.left.equalTo(16);
        make.right.equalTo(-16);
    }];
    
    
}

-(void)confirm{
    NSString *username = self.userNameTextField.text;
    if (username == nil) {
        [self.view showMsg:NSLocalizedString(@"用户名不能为空！", nil)];
        return;
    }else if (![NSString checkUserName:username]||username.length > 12||username.length<6){
        [self.view showAlert:@"" DetailMsg:NSLocalizedString(@"用户名为6-12位的字符，包含a-z,1-5！", nil)];
        return;
    }
    if ([self checkAccountName:username] == NO) {
        [self.view showAlert:NSLocalizedString(@"特殊的用户名不可注册", nil) DetailMsg:NSLocalizedString(@"请更换其他用户名再试", nil)];
        return;
    }
    NSString *pass = self.passwordTextField.text;
    NSString *repass  =self.repeatpasswordTextField.text;
    if (![NSString checkPassword:pass] ) {
        [self.view showAlert:@"" DetailMsg:NSLocalizedString(@"请输入8-18位字符！", nil)];
        return;
    }
    if(![pass isEqualToString:repass]){
        [self.view showMsg:NSLocalizedString(@"两次密码输入不一致！", nil)];
        return;
    }
    [self.view showHUD];
    MJWeakSelf
    [NetManager RegisterAccountWithLoginName:self.userNameTextField.text Password:pass PasswordConfirm:repass completionHandler:^(id responseObj, NSError *error) {
        [weakSelf.view hideHUD];
        if (!error) {
            if (![[NSString stringWithFormat:@"%@",responseObj[@"resultCode"]] isEqualToString:@"20000"]) {
                [weakSelf.view showAlert:[NSString stringWithFormat:@"Error:%ld",error.code] DetailMsg:responseObj[@"resultMsg"]];
                return ;
            }
            NSMutableDictionary *dic;
            dic = responseObj[@"data"];
            if([dic isEqual:[NSNull null]]){
                [weakSelf.view showMsg:NSLocalizedString(@"注册失败！", nil)];
                return;
            }
            //存储用户信息
            UserInfoModel *model = [UserInfoModel parse:dic];
            [CreateAll SaveUserName:username Password:pass];
            [CreateAll SaveCurrentUser:model];
            //登陆成功通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"userlogin" object:nil];
            dispatch_async_on_main_queue(^{
                [weakSelf.view showMsg:NSLocalizedString(@"注册成功！", nil)];
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            });
        }else{
            [weakSelf.view showAlert:[NSString stringWithFormat:@"Error:%ld",error.code] DetailMsg:error.localizedDescription];
        }
    }];
}

-(BOOL)checkAccountName:(NSString *)account{
    NSString *str = @"mistoken/mischain/gongchandang/renquan/shangfang/youxing/boycott/baoluan/baodong/jieyan/xuechao/wikipedia/youtube/baozha/zhadan/zhayao/mayingjiu/taiwan/fenlie/zangdu/xizang/qingzhen/falungong/dajiyuan/tuidang/jiuping/suicide/testosterone/adrenaline/tamoxifen/strychnine/androst/heroin/diamorphine/cocain/ketamine/cannabis/chengdu/tianwang/bignews/chinaliberal/chinamz/freechina/freedom/freenet/hongzhi/hrichina/huanet/incest/lihongzhi/making/minghui/minghuinews/peacehall/playboy/renminbao/renmingbao/safeweb/simple/tibetalk/triangle/triangleboy/unixbox/ustibet/voachinese/wangce/wstaiji/xinsheng/yuming/zhengjian/zhenshanren/zhuanfalu/zhuanfalun/amateur/hardcore/sexinsex/tokyohot/morphine/narcotic";
    if ([str containsString:account]) {
        return NO;
    }else{
        return YES;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
