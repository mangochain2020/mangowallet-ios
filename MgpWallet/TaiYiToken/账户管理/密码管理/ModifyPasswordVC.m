//
//  ModifyPasswordVC.m
//  TaiYiToken
//
//  Created by Frued on 2018/10/19.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "ModifyPasswordVC.h"
#import "LoginVC.h"
@interface ModifyPasswordVC ()
@property(nonatomic,strong)UILabel *titlelabel;
@property(nonatomic,strong)UIButton *backBtn;

@property(nonatomic,strong) UITextField *passwordTextField;
@property(nonatomic,strong) UITextField *repeatpasswordTextField;
@property(nonatomic,strong) UIButton *confirmBtn;

@end

@implementation ModifyPasswordVC
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
    _titlelabel.text = NSLocalizedString(@"重置密码", nil);
    _titlelabel.textAlignment = NSTextAlignmentCenter;
    _titlelabel.numberOfLines = 1;
    [headBackView addSubview:_titlelabel];
    [_titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.top.equalTo(30);
        make.width.equalTo(200);
        make.height.equalTo(20);
    }];
    
    _passwordTextField = [UITextField new];
    _passwordTextField.attributedPlaceholder =[[NSAttributedString alloc]initWithString: NSLocalizedString(@"设置登录密码", nil)];
    _passwordTextField.backgroundColor = [UIColor whiteColor];
    _passwordTextField.textAlignment = NSTextAlignmentLeft;
    _passwordTextField.textColor = [UIColor darkGrayColor];
    _passwordTextField.font = [UIFont systemFontOfSize:18];
    _passwordTextField.secureTextEntry = YES;
    
    [self.view addSubview:_passwordTextField];
    [_passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(180);
        make.height.equalTo(40);
        make.left.equalTo(16);
        make.right.equalTo(-50);
    }];
    
    _repeatpasswordTextField = [UITextField new];
    _repeatpasswordTextField.attributedPlaceholder =[[NSAttributedString alloc]initWithString: NSLocalizedString(@"确认登录密码", nil)];
    _repeatpasswordTextField.backgroundColor = [UIColor whiteColor];
    _repeatpasswordTextField.textAlignment = NSTextAlignmentLeft;
    _repeatpasswordTextField.textColor = [UIColor darkGrayColor];
    _repeatpasswordTextField.font = [UIFont systemFontOfSize:18];
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
   
    NSString *pass = self.passwordTextField.text;
    NSString *repass  =self.repeatpasswordTextField.text;
    if (![NSString checkPassword:pass] ) {
        [self.view showMsg:NSLocalizedString(@"请输入8-18位字符！", nil)];
        return;
    }
    if(![pass isEqualToString:repass]){
        [self.view showMsg:NSLocalizedString(@"两次密码输入不一致！", nil)];
        return;
    }
    [self.view showHUD];
    MJWeakSelf
    [NetManager ResetPassWordWithPassword:pass PasswordConfirm:repass completionHandler:^(id responseObj, NSError *error) {
        [weakSelf.view hideHUD];
        if (!error) {
            if (![[NSString stringWithFormat:@"%@",responseObj[@"resultCode"]] isEqualToString:@"20000"]) {
                [weakSelf.view showAlert:[NSString stringWithFormat:@"Error:%ld",error.code] DetailMsg:responseObj[@"resultMsg"]];
                return ;
            }
            
            dispatch_async_on_main_queue(^{
                [weakSelf.view showMsg:NSLocalizedString(@"重置成功！", nil)];
                LoginVC *vc = [LoginVC new];
                vc.showBackBtn = YES;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            });
        }else{
            dispatch_async_on_main_queue(^{
                [weakSelf.view showAlert:[NSString stringWithFormat:@"Error:%ld",error.code] DetailMsg:error.localizedDescription];
            });
        }
    }];
    
   
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
