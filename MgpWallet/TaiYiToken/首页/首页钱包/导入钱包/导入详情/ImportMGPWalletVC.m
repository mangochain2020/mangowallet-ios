//
//  ImportMGPWalletVC.m
//  TaiYiToken
//
//  Created by mac on 2020/6/17.
//  Copyright © 2020 admin. All rights reserved.
//

#import "ImportMGPWalletVC.h"
#import "ControlBtnsView.h"
#import "SetPasswordView.h"
#import "WBQRCodeVC.h"
#import "SelectEOSAccountVC.h"
#define PRIVATEKEY_REMIND_TEXT  NSLocalizedString(@"输入private Key文件内容至输入框。或通过扫描PrivateKey内容生成的二维码录入。请留意字符大小写。", nil)
#define MNEMONIC_REMIND_TEXT    NSLocalizedString(@"使用助记词导入的同时可以修改钱包密码", nil)
typedef enum {
    PRIVATEKEY_IMPORT = 0,
    MNEMONIC_IMPORT = 1
}BTCWALLET_IMPORT_TYPE;

@interface ImportMGPWalletVC ()<UIImagePickerControllerDelegate>
@property(nonatomic,strong) UIButton *backBtn;
@property(nonatomic)UILabel *titleLabel;
@property(nonatomic)UILabel *remindLabel;
@property(nonatomic)UITextView *ImportContentTextView;
@property(nonatomic)ControlBtnsView *buttonView;
@property(nonatomic)SetPasswordView *setPasswordView;
@property(nonatomic,strong) UIButton *ImportBtn;
@property(nonatomic)UIView *shadowView;
@property(nonatomic)UIButton *scanBtn;
@property(nonatomic)BTCWALLET_IMPORT_TYPE importType;


@end

@implementation ImportMGPWalletVC

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
    [self initHeadView];
    [self initUI];
    self.importType = MNEMONIC_IMPORT;
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
    /*
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.backgroundColor = [UIColor clearColor];
    _backBtn.tintColor = [UIColor whiteColor];
    [_backBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [_backBtn setImage:[UIImage imageNamed:@"ico_right_arrow"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_backBtn];
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
    [_titleLabel setText:[NSString stringWithFormat:NSLocalizedString(@"导入MGP钱包", nil)]];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
//    [self.view addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(SafeAreaTopHeight - 30);
        make.left.equalTo(45);
        make.width.equalTo(200);
        make.height.equalTo(20);
    }];
    */
    _scanBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    [_scanBtn setBackgroundImage:[UIImage imageNamed:@"wallet_scan"] forState:UIControlStateNormal];
    [_scanBtn addTarget:self action:@selector(scanBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_scanBtn];
    self.title = NSLocalizedString(@"导入MGP钱包", nil);

    //    [self.view addSubview:_scanBtn];
//    [_scanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(-20);
//        make.top.equalTo(SafeAreaTopHeight - 29);
//        make.width.equalTo(16);
//        make.height.equalTo(16);
//    }];
}
-(void)selectImportWay:(UIButton *)btn{
    self.importType = btn.tag == 0? MNEMONIC_IMPORT : PRIVATEKEY_IMPORT;
    [_buttonView setBtnSelected:btn];
//    [self.ImportContentTextView setText:@"5KV3E9zxAQ73EzWth3iPCgPD8NCFxpjv2LhYZwVdh57kjTuoZWE"];
    self.remindLabel.text =  btn.tag == 0?MNEMONIC_REMIND_TEXT : PRIVATEKEY_REMIND_TEXT;
    
}
-(void)initUI{
    _buttonView = [ControlBtnsView new];
    [_buttonView initButtonsViewWithTitles:@[NSLocalizedString(@"助记词", nil),NSLocalizedString(@"私钥", nil)] Width:ScreenWidth Height:44];
    for (UIButton *btn in _buttonView.btnArray) {
        [btn addTarget:self action:@selector(selectImportWay:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.view addSubview:_buttonView];
    [_buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.right.equalTo(0);
        make.height.equalTo(44);
    }];
    
    _remindLabel = [UILabel new];
    _remindLabel.font = [UIFont boldSystemFontOfSize:12];
    _remindLabel.textColor = [UIColor textGrayColor];
    _remindLabel.numberOfLines = 0;
    [_remindLabel setText:MNEMONIC_REMIND_TEXT];
    _remindLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_remindLabel];
    [_remindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(125-SafeAreaTopHeight);
        make.left.equalTo(30);
        make.right.equalTo(-30);
        make.height.equalTo(65);
    }];
    
    
    _shadowView = [UIView new];
    _shadowView.layer.shadowColor = [UIColor grayColor].CGColor;
    _shadowView.layer.shadowOffset = CGSizeMake(0, 0);
    _shadowView.layer.shadowOpacity = 1;
    _shadowView.layer.shadowRadius = 3.0;
    _shadowView.layer.cornerRadius = 3.0;
    _shadowView.clipsToBounds = NO;
    [self.view addSubview:_shadowView];
    [_shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(210-SafeAreaTopHeight);
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.height.equalTo(100);
    }];
    
    _ImportContentTextView = [UITextView new];
    _ImportContentTextView.layer.shadowColor = [UIColor grayColor].CGColor;
    _ImportContentTextView.layer.shadowOffset = CGSizeMake(0, 0);
    _ImportContentTextView.layer.shadowOpacity = 1;
    _ImportContentTextView.backgroundColor = [UIColor whiteColor];
    _ImportContentTextView.font = [UIFont systemFontOfSize:12];
    _ImportContentTextView.textAlignment = NSTextAlignmentLeft;
    _ImportContentTextView.editable = YES;
    [self.shadowView addSubview:_ImportContentTextView];
    [_ImportContentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
    
    _setPasswordView = [SetPasswordView new];
    [_setPasswordView initSetPasswordViewUI];
    [self.view addSubview:_setPasswordView];
    [_setPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ImportContentTextView.mas_bottom).equalTo(20);
        make.left.right.equalTo(0);
        make.height.equalTo(162);
    }];
    
    
    _ImportBtn = [UIButton buttonWithType: UIButtonTypeSystem];
    _ImportBtn.titleLabel.textColor = [UIColor textBlackColor];
    _ImportBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _ImportBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [_ImportBtn gradientButtonWithSize:CGSizeMake(ScreenWidth, 44) colorArray:@[[UIColor colorWithHexString:@"#4090F7"],[UIColor colorWithHexString:@"#57A8FF"]] percentageArray:@[@(0.3),@(1)] gradientType:GradientFromLeftTopToRightBottom];
    _ImportBtn.tintColor = [UIColor textWhiteColor];
    _ImportBtn.userInteractionEnabled = YES;
    [_ImportBtn setTitle:NSLocalizedString(@"开始导入", nil) forState:UIControlStateNormal];
    [_ImportBtn addTarget:self action:@selector(ImportWalletAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_ImportBtn];
    [_ImportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.right.equalTo(-16);
        make.top.equalTo(self.setPasswordView.mas_bottom).equalTo(20);
        make.height.equalTo(44);
    }];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(MissionWallet *)CreateEOSWalletPri:(NSString *)pri Pub:(NSString *)pub PassWord:(NSString *)pass PassHint:(NSString *)hint CoinType:(CoinType)type{
    NSString *username = [CreateAll GetCurrentUserName];
    if (!username) {
        return nil;
    }
    MissionWallet *wallet = [MissionWallet new];
    wallet.coinType = type;
    wallet.walletType = IMPORT_WALLET;
    wallet.index = 0;
    wallet.passwordHint = hint;
    wallet.privateKey = pri;
    wallet.publicKey = pub;
    wallet.walletName = type == MGP?[NSString stringWithFormat:@"%@_%@",@"MGP",username]:@"EOS_";
    wallet.address = type == MGP?username : @"";
    [wallet dataCheck];
    return wallet;
}

- (void)getEOSKey:(NSString *)pubkey AccountSuccess:(void(^)(id response))handler{
    NSDictionary *dic = @{@"public_key":pubkey};
    [[HTTPRequestManager shareEosManager] post:eos_get_key_accounts paramters:dic success:^(BOOL isSuccess, id responseObject) {
        if (isSuccess) {
            handler(responseObject);
        }else{
            handler(nil);
        }
    } failure:^(NSError *error) {
        handler(nil);
    } superView:self.view showFaliureDescription:YES];
    
}

//导入
-(void)ImportWalletAction{
    if (![self.setPasswordView.passwordTextField.text isEqualToString:self.setPasswordView.repasswordTextField.text]) {
        [self.view showMsg:NSLocalizedString(@"两次密码输入不一致！", nil)];
        return;
    }
    if (self.setPasswordView.passwordTextField.text.length <= 0) {
        [self.view showMsg:NSLocalizedString(@"请输入密码！", nil)];
        return;
    }
    [[NSUserDefaults standardUserDefaults]setObject:self.setPasswordView.repasswordTextField.text forKey:PassWordText];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    if (self.importType == MNEMONIC_IMPORT) {
        NSString *password = self.setPasswordView.passwordTextField.text;
        NSString *hint = self.setPasswordView.passwordHintTextField.text;
        //去除多余空格
        NSString *cleanmne = [self.ImportContentTextView.text stringByReplacingOccurrencesOfString:@"  " withString:@" "];
        NSString *cleanmne2 = [cleanmne stringByReplacingOccurrencesOfString:@"   " withString:@" "];
        Account *account = [Account accountWithMnemonicPhrase:cleanmne2];
        if (account == nil) {
            [self.view showAlert:@"" DetailMsg:NSLocalizedString(@"请输入正确的助记词！", nil)];
            return;
        }
        
        //[self.view showHUD];
//        CoinType typex = EOS;
        NSString *seed = [CreateAll CreateSeedByMnemonic:cleanmne2 Password:@""];
        NSString *mispri = [CreateAll CreateEOSPrivateKeyBySeed:seed Index:0];
        NSString *pubx = [EosEncode eos_publicKey_with_wif:mispri];
        MissionWallet *eoswallet = [self CreateEOSWalletPri:mispri Pub:pubx PassWord:password PassHint:hint CoinType:MGP];
        eoswallet.importType = IMPORT_BY_MNEMONIC;
        
        //查询账号
        SelectEOSAccountVC *vc = [SelectEOSAccountVC new];
        vc.wallet = eoswallet;
        vc.pass = password;
        vc.mnemonic = cleanmne2;
        [self.navigationController pushViewController:vc animated:YES];
        

        
    }else if(self.importType == PRIVATEKEY_IMPORT){
//        if (![self.ImportContentTextView.text ]) {
//            [self.view showMsg:NSLocalizedString(@"请输入正确格式的私钥！", nil)];
//            return;
//        }
        NSString *password = self.setPasswordView.passwordTextField.text;
        NSString *hint = self.setPasswordView.passwordHintTextField.text;
        
//        CoinType typex = EOS;
        NSString *mispri = [self.ImportContentTextView.text stringByReplacingOccurrencesOfString:@" " withString:@""];;
        NSString *pubx = [EosEncode eos_publicKey_with_wif:mispri];
        MissionWallet *eoswallet = [self CreateEOSWalletPri:mispri Pub:pubx PassWord:password PassHint:hint CoinType:MGP];
        eoswallet.importType = IMPORT_BY_PRIVATEKEY;
        
        //查询账号
        SelectEOSAccountVC *vc = [SelectEOSAccountVC new];
        vc.wallet = eoswallet;
        vc.pass = password;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
//扫描二维码
-(void)scanBtnAction{
    WBQRCodeVC *WBVC = [[WBQRCodeVC alloc] init];
    [self QRCodeScanVC:WBVC];
    MJWeakSelf
    [WBVC setGetQRCodeResult:^(NSString *string) {
        NSLog(@"QRCode result = %@",string);
        NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        if (dict) {
            if([[dict allKeys] containsObject:@"type"]){
                NSNumber *type = dict[@"type"];
                if ([type intValue] == 2) {
                    weakSelf.ImportContentTextView.text = dict[@"privateKey"];
                    weakSelf.importType = PRIVATEKEY_IMPORT;
                }else{
                    NSString *content = [dict[@"mnemonic"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    weakSelf.ImportContentTextView.text = content;
                    weakSelf.importType = MNEMONIC_IMPORT;

                }
            }
        }else{
            weakSelf.ImportContentTextView.text = string;
        }

    }];
}

//扫码判断权限
- (void)QRCodeScanVC:(UIViewController *)scanVC {
    MJWeakSelf
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        switch (status) {
            case AVAuthorizationStatusNotDetermined: {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    if (granted) {
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            // [weakSelf.navigationController pushViewController:scanVC animated:YES];
                            UINavigationController *navisc = [[UINavigationController alloc]initWithRootViewController:scanVC];
                            [weakSelf presentViewController:navisc animated:YES completion:^{
                                
                            }];
                        });
                        NSLog(NSLocalizedString(@"用户第一次同意了访问相机权限 - - %@", nil), [NSThread currentThread]);
                    } else {
                        NSLog(NSLocalizedString(@"用户第一次拒绝了访问相机权限 - - %@", nil), [NSThread currentThread]);
                    }
                }];
                break;
            }
            case AVAuthorizationStatusAuthorized: {
                // [weakSelf.navigationController pushViewController:scanVC animated:YES];
                UINavigationController *navisc = [[UINavigationController alloc]initWithRootViewController:scanVC];
                [weakSelf presentViewController:navisc animated:YES completion:^{
                    
                }];
                break;
            }
            case AVAuthorizationStatusDenied: {
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:NSLocalizedString(@"请去-> [设置 - 隐私 - 相机 - MisToken] 打开访问开关", nil) preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *alertA = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                
                [alertC addAction:alertA];
                [weakSelf presentViewController:alertC animated:YES completion:nil];
                break;
            }
            case AVAuthorizationStatusRestricted: {
                NSLog(NSLocalizedString(@"因为系统原因, 无法访问相册", nil));
                break;
            }
                
            default:
                break;
        }
        return;
    }
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:NSLocalizedString(@"未检测到您的摄像头", nil) preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *alertA = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertC addAction:alertA];
    [self presentViewController:alertC animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
