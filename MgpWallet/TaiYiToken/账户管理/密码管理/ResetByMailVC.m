//
//  ResetByMailVC.m
//  TaiYiToken
//
//  Created by Frued on 2018/10/19.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "ResetByMailVC.h"
#import "ModifyPasswordVC.h"
@interface ResetByMailVC ()
@property(nonatomic,strong)UILabel *titlelabel;
@property(nonatomic,strong)UIButton *backBtn;

@property(nonatomic,strong) UIButton *countryCodeBtn;
@property(nonatomic,strong) UIButton *sendVerifyCodeBtn;
@property(nonatomic,strong) UITextField *mailTextField;
@property(nonatomic,strong) UITextField *verifyCodeTextField;
@property(nonatomic,strong) UIButton *confirmBtn;

@property(nonatomic,copy)NSString *countryCode;

//标记请求验证码次数
@property(nonatomic,assign)NSInteger sendFrequency;
@end

@implementation ResetByMailVC

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
    _titlelabel = [[UILabel alloc] init];
    _titlelabel.textColor = [UIColor blackColor];
    _titlelabel.font = [UIFont boldSystemFontOfSize:18];
    _titlelabel.text = NSLocalizedString(@"重置密码", nil);
    _titlelabel.textAlignment = NSTextAlignmentCenter;
    _titlelabel.numberOfLines = 1;
    [headBackView addSubview:_titlelabel];
    [_titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.top.equalTo(SafeAreaTopHeight - 34);
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
    
    
    _mailTextField = [UITextField new];
    _mailTextField.attributedPlaceholder =[[NSAttributedString alloc]initWithString: NSLocalizedString(@"邮箱", nil)];
    _mailTextField.backgroundColor = [UIColor whiteColor];
    _mailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    _mailTextField.textAlignment = NSTextAlignmentLeft;
    _mailTextField.textColor = [UIColor darkGrayColor];
    _mailTextField.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_mailTextField];
    [_mailTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(180);
        make.height.equalTo(40);
        make.left.equalTo(16);
        make.right.equalTo(-50);
    }];
    
    _verifyCodeTextField = [UITextField new];
    _verifyCodeTextField.attributedPlaceholder =[[NSAttributedString alloc]initWithString: NSLocalizedString(@"验证码", nil)];
    _verifyCodeTextField.backgroundColor = [UIColor whiteColor];
    _verifyCodeTextField.textAlignment = NSTextAlignmentLeft;
    _verifyCodeTextField.textColor = [UIColor darkGrayColor];
    _verifyCodeTextField.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_verifyCodeTextField];
    [_verifyCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mailTextField.mas_bottom).equalTo(20);
        make.height.equalTo(40);
        make.left.equalTo(16);
        make.right.equalTo(-50);
    }];
    
    _sendVerifyCodeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _sendVerifyCodeBtn.backgroundColor = [UIColor clearColor];
    _sendVerifyCodeBtn.tintColor = [UIColor textBlueColor];
    _sendVerifyCodeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    _sendVerifyCodeBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    _sendVerifyCodeBtn.layer.cornerRadius = 5;
    _sendVerifyCodeBtn.clipsToBounds = YES;
    [_sendVerifyCodeBtn setTitle:NSLocalizedString(@"发送到邮箱", nil) forState:UIControlStateNormal];
    [_sendVerifyCodeBtn addTarget:self action:@selector(sendVerifyCode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sendVerifyCodeBtn];
    _sendVerifyCodeBtn.userInteractionEnabled = YES;
    [_sendVerifyCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mailTextField.mas_bottom).equalTo(20);
        make.height.equalTo(40);
        make.width.equalTo(100);
        make.right.equalTo(-16);
    }];
    
    _confirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _confirmBtn.backgroundColor = RGB(100, 100, 255);
    _confirmBtn.tintColor = [UIColor whiteColor];
    _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _confirmBtn.layer.cornerRadius = 5;
    _confirmBtn.clipsToBounds = YES;
    [_confirmBtn gradientButtonWithSize:CGSizeMake(ScreenWidth, 44) colorArray:@[[UIColor colorWithHexString:@"#4090F7"],[UIColor colorWithHexString:@"#BBA8FF"],[UIColor colorWithHexString:@"#4090F7"]] percentageArray:@[@(0.3),@(0.7),@(0.3)] gradientType:GradientFromLeftToRight];
    [_confirmBtn setTitle:NSLocalizedString(@"下一步", nil) forState:UIControlStateNormal];
    [_confirmBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_confirmBtn];
    _confirmBtn.userInteractionEnabled = YES;
    [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.verifyCodeTextField.mas_bottom).equalTo(40);
        make.height.equalTo(44);
        make.left.equalTo(16);
        make.right.equalTo(-16);
    }];
    
    
}

-(void)confirm{
    NSString *mail = self.mailTextField.text;
    if (![NSString checkEmail:mail]) {
        [self.view showMsg:NSLocalizedString(@"请输入正确的邮箱！", nil)];
        return;
    }
    NSString *verifycode = self.verifyCodeTextField.text;
    if(verifycode == nil || verifycode.length < 4){
        [self.view showMsg:NSLocalizedString(@"请填写验证码", nil)];
        return;
    }
    ModifyPasswordVC *vc = [ModifyPasswordVC new];
    vc.mobileOrMail = mail;
    vc.verifyCode  =verifycode;
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)sendVerifyCode{
    MJWeakSelf
    if (self.sendFrequency >= 3) {
        //safeCode 安全码，超过3次必须填写,防止短信被刷
        
    }
    self.sendFrequency ++;
    NSString *mail = self.mailTextField.text;
    
    if (![NSString checkEmail:mail]) {
        [self.view showMsg:NSLocalizedString(@"请输入正确的邮箱！", nil)];
        return;
    }
    
    [self openCountdown];
    [NetManager SendVerifyCodeWithType:MAIL_Code MobileORMail:mail  CheckDevice:YES SafeCode:@"" completionHandler:^(id responseObj, NSError *error) {
        if (!error) {
            if (![[NSString stringWithFormat:@"%@",responseObj[@"resultCode"]] isEqualToString:@"20000"]) {
                dispatch_async_on_main_queue(^{
                     [weakSelf.view showAlert:[NSString stringWithFormat:@"Error:%ld",error.code] DetailMsg:responseObj[@"resultMsg"]];
                });
                return ;
            }else{//请求成功
                dispatch_async_on_main_queue(^{
                    [weakSelf.view showMsg:NSLocalizedString(@"发送成功", nil)];
                });
            }
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
// 开启倒计时效果
-(void)openCountdown{
    MJWeakSelf
    self.sendVerifyCodeBtn.userInteractionEnabled = NO;
    __block NSInteger time = 59; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮的样式
                [weakSelf.sendVerifyCodeBtn setTitle:NSLocalizedString(@"重新发送", nil) forState:UIControlStateNormal];
                [weakSelf.sendVerifyCodeBtn setTitleColor:[UIColor textBlueColor] forState:UIControlStateNormal];
                weakSelf.sendVerifyCodeBtn.userInteractionEnabled = YES;
            });
        }else{
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮显示读秒效果
                [weakSelf.sendVerifyCodeBtn setTitle:[NSString stringWithFormat:@"%@(%.2d)",NSLocalizedString(@"重新发送", nil), seconds] forState:UIControlStateNormal];
                [weakSelf.sendVerifyCodeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            });
            time--;
        }
    });
    
    dispatch_resume(_timer);
    [_sendVerifyCodeBtn setTitle:NSLocalizedString(@"发送验证码", nil) forState:UIControlStateNormal];

}

@end
