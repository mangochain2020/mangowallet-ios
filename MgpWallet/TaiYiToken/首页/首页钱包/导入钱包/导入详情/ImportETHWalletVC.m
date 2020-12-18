//
//  ImportETHWalletVC.m
//  TaiYiToken
//
//  Created by admin on 2018/9/7.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "ImportETHWalletVC.h"
#import "ControlBtnsView.h"
#import "SetPasswordView.h"
#import "WBQRCodeVC.h"

#define KEYSTORE_REMIND_TEXT  NSLocalizedString(@"复制粘贴以太坊钱包Keystore文件内容至输入框，或通过扫描Keystore内容生成的二维码录入", nil)
#define PRIVATEKEY_REMIND_TEXT  NSLocalizedString(@"输入private Key文件内容至输入框。或通过扫描PrivateKey内容生成的二维码录入。请留意字符大小写。", nil)
#define MNEMONIC_REMIND_TEXT    NSLocalizedString(@"使用助记词导入的同时可以修改钱包密码", nil)
typedef enum {
    KEYSTORE_IMPORT = 0,
    PRIVATEKEY_IMPORT = 1,
    MNEMONIC_IMPORT = 2,
}ETHWALLET_IMPORT_TYPE;
@interface ImportETHWalletVC ()<UIImagePickerControllerDelegate>
@property(nonatomic,strong) UIButton *backBtn;
@property(nonatomic)UILabel *titleLabel;
@property(nonatomic)UILabel *remindLabel;
@property(nonatomic)UITextView *ImportContentTextView;
@property(nonatomic)ControlBtnsView *buttonView;
@property(nonatomic)SetPasswordView *setPasswordView;
@property(nonatomic,strong) UIButton *ImportBtn;
@property(nonatomic)UIView *shadowView;
@property(nonatomic)UIButton *scanBtn;
@property(nonatomic)ETHWALLET_IMPORT_TYPE importType;
@end

@implementation ImportETHWalletVC
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
    [self selectImportWay:self.buttonView.btnArray[0]];
    self.importType = KEYSTORE_IMPORT;
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
    [_titleLabel setText:[NSString stringWithFormat:NSLocalizedString(@"导入ETHEREUM钱包", nil)]];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
//    [self.view addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(SafeAreaTopHeight - 30);
        make.left.equalTo(45);
        make.width.equalTo(250);
        make.height.equalTo(20);
    }];
    */
    _scanBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    [_scanBtn setBackgroundImage:[UIImage imageNamed:@"wallet_scan"] forState:UIControlStateNormal];
    [_scanBtn addTarget:self action:@selector(scanBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_scanBtn];
    self.title = NSLocalizedString(@"导入ETH钱包", nil);

//    [self.view addSubview:_scanBtn];
//    [_scanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(-20);
//        make.top.equalTo(SafeAreaTopHeight - 29);
//        make.width.equalTo(16);
//        make.height.equalTo(16);
//    }];
}

-(void)selectImportWay:(UIButton *)btn{
    switch (btn.tag) {
        case 0:
            self.importType = KEYSTORE_IMPORT;
            self.remindLabel.text = KEYSTORE_REMIND_TEXT;
            [self.setPasswordView.passwordTextField setPlaceholder:NSLocalizedString(@"确认密码", nil)];
            self.setPasswordView.repasswordTextField.hidden = YES;
            self.setPasswordView.passwordHintTextField.hidden = YES;
            break;
        case 1:
            self.importType = MNEMONIC_IMPORT;
            self.remindLabel.text = MNEMONIC_REMIND_TEXT;
            [self.setPasswordView.passwordTextField setPlaceholder:NSLocalizedString(@"钱包密码(8-18位字符)", nil)];
            self.setPasswordView.repasswordTextField.hidden = NO;
            self.setPasswordView.passwordHintTextField.hidden = NO;
            break;
        case 2:
            self.importType = PRIVATEKEY_IMPORT;
            self.remindLabel.text = PRIVATEKEY_REMIND_TEXT;
            [self.setPasswordView.passwordTextField setPlaceholder:NSLocalizedString(@"钱包密码(8-18位字符)", nil)];
            self.setPasswordView.repasswordTextField.hidden = NO;
            self.setPasswordView.passwordHintTextField.hidden = NO;
            break;
        default:
            break;
    }
    [_buttonView setBtnSelected:btn];
    
    //delay acoustic insect gaze test female army car lawsuit save enlist answer---
    
}
-(void)initUI{
    _buttonView = [ControlBtnsView new];
    [_buttonView initButtonsViewWithTitles:@[@"Keystore",NSLocalizedString(@"助记词", nil),NSLocalizedString(@"私钥", nil)] Width:ScreenWidth Height:44];
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
        make.top.equalTo(self.buttonView.mas_bottom).equalTo(10);
        make.left.equalTo(30);
        make.right.equalTo(-30);
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
        make.top.equalTo(self.remindLabel.mas_bottom).equalTo(20);
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
//导入
-(void)ImportWalletAction{
    if (![self.setPasswordView.passwordTextField.text isEqualToString:self.setPasswordView.repasswordTextField.text]) {
        if(self.importType == KEYSTORE_IMPORT){
            
        }else{
            [self.view showMsg:NSLocalizedString(@"两次密码输入不一致！", nil)];
            return;
        }
    }
    [[NSUserDefaults standardUserDefaults]setObject:self.setPasswordView.repasswordTextField.text forKey:PassWordText];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    MJWeakSelf
    if (self.importType == MNEMONIC_IMPORT) {
        //去除多余空格
        NSString *cleanmne = [self.ImportContentTextView.text stringByReplacingOccurrencesOfString:@"  " withString:@" "];
        NSString *cleanmne2 = [cleanmne stringByReplacingOccurrencesOfString:@"   " withString:@" "];
        Account *account = [Account accountWithMnemonicPhrase:cleanmne2];
        if (account == nil) {
            [self.view showAlert:@"" DetailMsg:NSLocalizedString(@"请输入正确的助记词！", nil)];
            return;
        }
        [self.view showHUD];
        [CreateAll ImportWalletByMnemonic:self.ImportContentTextView.text CoinType:ETH Password:self.setPasswordView.passwordTextField.text PasswordHint:self.setPasswordView.passwordHintTextField.text callback:^(MissionWallet *wallet, NSError *error) {
            [weakSelf.view hideHUD];
            if (wallet == nil) {
                if (error) {
                    [weakSelf.view showMsg:NSLocalizedString(@"导入失败！钱包已存在！", nil)];
                    
                }else{
                    [weakSelf.view showMsg:NSLocalizedString(@"导入失败！", nil)];
                }
            }else{
                [weakSelf.view showMsg:NSLocalizedString(@"导入成功！", nil)];
                NSString *str = [NSString stringWithFormat:@"%@:ETH",wallet.address];
                [NetManager AddAccountLogWithuserName:[CreateAll GetCurrentUserName] AccountInfo:str RecordType:IMPORT_LOG_TYPE CompletionHandler:^(id responseObj, NSError *error) {
                    if (!error) {
                        if (![[NSString stringWithFormat:@"%@",responseObj[@"resultCode"]] isEqualToString:@"20000"]) {
                            [weakSelf.view showAlert:@"" DetailMsg:responseObj[@"resultMsg"]];
                            return ;
                        }
                    }else{
                        [weakSelf.view showAlert:[NSString stringWithFormat:@"Error:%ld",error.code] DetailMsg:error.localizedDescription];
                    }
                }];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                });
            }
        }];
        
        
    }else if(self.importType == PRIVATEKEY_IMPORT){
        NSString *prikey = self.ImportContentTextView.text;
        if([prikey containsString:@"0x"]){
            prikey = [prikey substringFromIndex:2];
        }
        BOOL isValid = [CreateAll ValidHexString:prikey];
        if (isValid == NO) {
            [self.view showMsg:NSLocalizedString(@"请输入正确格式的私钥！", nil)];
            return;
        }
        Account *account = [Account accountWithPrivateKey:[NSData dataWithHexString:prikey]];
        if (account == nil) {
            [self.view showMsg:NSLocalizedString(@"请输入正确格式的私钥！", nil)];
            return;
        }
        
        [self.view showHUD];
        MissionWallet *wallet = [CreateAll ImportWalletByPrivateKey:prikey CoinType:ETH Password:self.setPasswordView.passwordTextField.text PasswordHint:self.setPasswordView.passwordHintTextField.text];
        [self.view hideHUD];
        if (wallet == nil) {
            [self.view showMsg:NSLocalizedString(@"导入失败！", nil)];
        }else{
            [self.view showMsg:NSLocalizedString(@"导入成功！", nil)];
            NSString *str = [NSString stringWithFormat:@"%@:ETH",wallet.address];
            [NetManager AddAccountLogWithuserName:[CreateAll GetCurrentUserName] AccountInfo:str RecordType:IMPORT_LOG_TYPE CompletionHandler:^(id responseObj, NSError *error) {
                if (!error) {
                    if (![[NSString stringWithFormat:@"%@",responseObj[@"resultCode"]] isEqualToString:@"20000"]) {
                        [weakSelf.view showAlert:@"" DetailMsg:responseObj[@"resultMsg"]];
                        return ;
                    }
                }else{
                    [weakSelf.view showAlert:[NSString stringWithFormat:@"Error:%ld",error.code] DetailMsg:error.localizedDescription];
                }
            }];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            });
        }
    }else if(self.importType == KEYSTORE_IMPORT){
        [self.view showHUD];
        [CreateAll ImportWalletByKeyStore:self.ImportContentTextView.text CoinType:ETH Password:self.setPasswordView.passwordTextField.text PasswordHint:@"" callback:^(MissionWallet *wallet, NSError *error) {
             [weakSelf.view hideHUD];
            if (wallet == nil) {
                [weakSelf.view showMsg:NSLocalizedString(@"导入失败！", nil)];
            }else{
                [weakSelf.view showMsg:NSLocalizedString(@"导入成功！", nil)];
                NSString *str = [NSString stringWithFormat:@"%@:ETH",wallet.address];
                [NetManager AddAccountLogWithuserName:[CreateAll GetCurrentUserName] AccountInfo:str RecordType:IMPORT_LOG_TYPE CompletionHandler:^(id responseObj, NSError *error) {
                    if (!error) {
                        if (![[NSString stringWithFormat:@"%@",responseObj[@"resultCode"]] isEqualToString:@"20000"]) {
                            [weakSelf.view showAlert:@"" DetailMsg:responseObj[@"resultMsg"]];
                            return ;
                        }
                    }else{
                        [weakSelf.view showAlert:[NSString stringWithFormat:@"Error:%ld",error.code] DetailMsg:error.localizedDescription];
                    }
                }];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                });
            }
        }];
       
    }
}



//扫描二维码
-(void)scanBtnAction{
    WBQRCodeVC *WBVC = [[WBQRCodeVC alloc] init];
    [self QRCodeScanVC:WBVC];
    MJWeakSelf
    [WBVC setGetQRCodeResult:^(NSString *string) {
        NSLog(@"QRCode result = %@",string);
        weakSelf.ImportContentTextView.text = string;
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
