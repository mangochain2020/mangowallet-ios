//
//  HuobiAuthVC.m
//  TaiYiToken
//
//  Created by 张元一 on 2019/3/8.
//  Copyright © 2019 admin. All rights reserved.
//

#import "HuobiAuthVC.h"
#import "MisHuobiExchangeVC.h"
@interface HuobiAuthVC ()
@property(nonatomic,strong)UIButton *backBtn;
@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,strong) UILabel *tipLb;
@property(nonatomic,strong) UITextField *apikeyTF;
@property(nonatomic,strong) UITextField *apisecretTF;
@property(nonatomic,strong) UIButton *authBtn;
@end

@implementation HuobiAuthVC
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
    
    _tipLb = [[UILabel alloc] init];
    _tipLb.textColor = [UIColor grayColor];
    _tipLb.numberOfLines = 0;
    _tipLb.font = [UIFont systemFontOfSize:10];
    _tipLb.text = NSLocalizedString(@"在火币官网上登录后，点击“账号中心”，找到“API”管理页面，创建并复制里面的Api Key和Api Secret到这里进行授权。", nil);
    _tipLb.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_tipLb];
    [_tipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.right.equalTo(-16);
        make.top.equalTo(SafeAreaTopHeight);
        make.height.equalTo(60);
    }];
    
    _apikeyTF = [UITextField new];
    _apikeyTF.attributedPlaceholder = [[NSAttributedString alloc]initWithString: NSLocalizedString(@"请输入火币账号的Api Key(访问密钥)", nil)];
    _apikeyTF.backgroundColor = [UIColor whiteColor];
    _apikeyTF.textAlignment = NSTextAlignmentLeft;
    _apikeyTF.textColor = [UIColor darkGrayColor];
    _apikeyTF.font = [UIFont systemFontOfSize:15];
//    _apikeyTF.secureTextEntry = YES;
    [self.view addSubview:_apikeyTF];
    [_apikeyTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tipLb.mas_bottom).equalTo(10);
        make.height.equalTo(30);
        make.left.equalTo(16);
        make.right.equalTo(-16);
    }];
    
    _apisecretTF = [UITextField new];
    _apisecretTF.attributedPlaceholder = [[NSAttributedString alloc]initWithString: NSLocalizedString(@"请输入火币账号的Api Secret(访私密密钥)", nil)];
    _apisecretTF.backgroundColor = [UIColor whiteColor];
    _apisecretTF.textAlignment = NSTextAlignmentLeft;
    _apisecretTF.textColor = [UIColor darkGrayColor];
    _apisecretTF.font = [UIFont systemFontOfSize:15];
//    _apisecretTF.secureTextEntry = YES;
    [self.view addSubview:_apisecretTF];
    [_apisecretTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.apikeyTF.mas_bottom).equalTo(10);
        make.height.equalTo(30);
        make.left.equalTo(16);
        make.right.equalTo(-16);
    }];
   
    _authBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _authBtn.backgroundColor = RGB(100, 100, 255);
    _authBtn.tintColor = [UIColor whiteColor];
    _authBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _authBtn.layer.cornerRadius = 5;
    _authBtn.clipsToBounds = YES;
    [_authBtn gradientButtonWithSize:CGSizeMake(ScreenWidth, 44) colorArray:@[[UIColor colorWithHexString:@"#4090F7"],[UIColor colorWithHexString:@"#BBA8FF"],[UIColor colorWithHexString:@"#4090F7"]] percentageArray:@[@(0.3),@(0.7),@(0.3)] gradientType:GradientFromLeftToRight];
    [_authBtn setTitle:@"授权" forState:UIControlStateNormal];
    [_authBtn addTarget:self action:@selector(authAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_authBtn];
    _authBtn.userInteractionEnabled = YES;
    [_authBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.apisecretTF.mas_bottom).equalTo(30);
        make.height.equalTo(44);
        make.left.equalTo(16);
        make.right.equalTo(-16);
    }];
    
}

-(void)authAction{
    [self.view endEditing:YES];
    NSString *apikey = VALIDATE_STRING(self.apikeyTF.text);
    NSString *apisecret = VALIDATE_STRING(self.apisecretTF.text);
    if ([apikey isEqualToString:@""]) {
        [self.view showMsg:@"请输入Api key"];
        return;
    }
    if ([apisecret isEqualToString:@""]) {
        [self.view showMsg:@"请输入Api secret"];
        return;
    }
    //存
    [CreateAll SaveHuobiAPIKey:apikey APISecret:apisecret];
    NSLog(@"%@ %@",apikey,apisecret);
    MJWeakSelf
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [HuobiManager HuobiGetBalanceCompletionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
            if (!error) {
                NSLog(@"%@",responseObj);
                HuobiBalanceModel *model = [HuobiBalanceModel parse:responseObj];
                if (model.resultCode != 20000) {
                    [weakSelf.view showMsg:model.resultMsg];
                    //有问题 则清除本地apikey
                    [CreateAll SaveHuobiAPIKey:@"" APISecret:@""];
//                    [self.navigationController pushViewController:[HuobiAuthVC new] animated:YES];
                }else{
                    //
                    [weakSelf.view showMsg:@"Success"];
                    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:[MisHuobiExchangeVC new]];
                    [self presentViewController:navi animated:YES completion:^{
                        
                    }];
                }
            }else{
                [weakSelf.view showMsg:error.userInfo.description];
            }
        
        }];
    });
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


@end
