//
//  ImportHDWalletVC.m
//  TaiYiToken
//
//  Created by admin on 2018/9/25.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "ImportHDWalletVC.h"
#import "SetPasswordView.h"
#import "JavascriptWebViewController.h"
#import "AppDelegate.h"
#import "CYLMainRootViewController.h"
#import "WBQRCodeVC.h"


@interface ImportHDWalletVC ()
@property(nonatomic,strong)UILabel *headlabel;
@property(nonatomic,strong) UIButton *backBtn;
@property(nonatomic)UIView *shadowView;
@property(nonatomic)UITextView *ImportContentTextView;
@property(nonatomic)SetPasswordView *setPasswordView;
@property(nonatomic,strong) UIButton *ImportBtn;
@property(nonatomic,strong)NSString *mnemonic;
@property(nonatomic,assign)NSInteger taskcount;
@property(nonatomic,strong)MissionWallet *eoswallet;
@property(nonatomic,strong)MissionWallet *mgpwallet;
@end

@implementation ImportHDWalletVC


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
    [self initUI];
    self.taskcount = 0;
    // Do any additional setup after loading the view.
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
    
}

-(void)initUI{
    /*
    _headlabel = [[UILabel alloc] init];
    _headlabel.textColor = [UIColor blackColor];
    _headlabel.font = [UIFont systemFontOfSize:24];
    _headlabel.text = NSLocalizedString(@"输入助记词", nil);
    _headlabel.textAlignment = NSTextAlignmentLeft;
    _headlabel.numberOfLines = 1;
    [self.view addSubview:_headlabel];
    [_headlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.top.equalTo(15);
        make.right.equalTo(-16);
        make.height.equalTo(25);
    }];*/
    self.title = NSLocalizedString(@"输入助记词", nil);
    _shadowView = [UIView new];
    _shadowView.layer.shadowColor = [UIColor grayColor].CGColor;
    _shadowView.layer.shadowOffset = CGSizeMake(0, 0);
    _shadowView.layer.shadowOpacity = 1;
    _shadowView.layer.shadowRadius = 3.0;
    _shadowView.layer.cornerRadius = 3.0;
    _shadowView.clipsToBounds = NO;
    [self.view addSubview:_shadowView];
    [_shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(10);
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.height.equalTo(120);
    }];
    
    
    _ImportContentTextView = [UITextView new];
    _ImportContentTextView.layer.shadowColor = [UIColor grayColor].CGColor;
    _ImportContentTextView.layer.shadowOffset = CGSizeMake(0, 0);
    _ImportContentTextView.layer.shadowOpacity = 1;
    _ImportContentTextView.backgroundColor = [UIColor whiteColor];
    _ImportContentTextView.font = [UIFont systemFontOfSize:12];
    _ImportContentTextView.textAlignment = NSTextAlignmentLeft;
    _ImportContentTextView.editable = YES;
//    _ImportContentTextView.text = @"pulse alone pulp network soda topple fork fiscal dose question matrix quit";
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
        make.bottom.equalTo(-71);
        make.height.equalTo(44);
    }];
    
    UIButton *_scanBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    [_scanBtn setBackgroundImage:[UIImage imageNamed:@"wallet_scan"] forState:UIControlStateNormal];
    [_scanBtn addTarget:self action:@selector(scanBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_scanBtn];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(void)ImportWalletAction{
    
    if ([self.ImportContentTextView.text isEqualToString:@""] || self.ImportContentTextView.text == nil) {
        [self.view showMsg:NSLocalizedString(@"请输入助记词！", nil)];
        return;
    }
    if(![NSString checkPassword:self.setPasswordView.passwordTextField.text]){
        [self.view showMsg:NSLocalizedString(@"请输入8-18位字符！", nil)];
        return;
    }
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
    
    //去除多余空格
    NSString *cleanmne = [self.ImportContentTextView.text stringByReplacingOccurrencesOfString:@"  " withString:@" "];
    NSString *cleanmne2 = [cleanmne stringByReplacingOccurrencesOfString:@"   " withString:@" "];
    self.mnemonic = cleanmne2;
    [self.view showMsg:NSLocalizedString(@"正在创建钱包...", nil)];
    [self.view showHUD];
    [self CreateWallet];
   
}
-(void)scanBtnAction{

    WBQRCodeVC *WBVC = [[WBQRCodeVC alloc] init];
    [self QRCodeScanVC:WBVC];

    MJWeakSelf
    [WBVC setGetQRCodeResult:^(NSString *string) {
        if(VALIDATE_STRING(string)){
            _ImportContentTextView.text = string;
        }
            
    }];
}
-(void)CreateWallet{
    
    NSString *password = self.setPasswordView.passwordTextField.text;
    NSString *hint = self.setPasswordView.passwordHintTextField.text == nil?@"":self.setPasswordView.passwordHintTextField.text;
    //512位种子 长度为128字符 64Byte
    NSString *seed = [CreateAll CreateSeedByMnemonic:self.mnemonic Password:password];
    //临时存,回到主页生成MIS钱包后删除
    [[NSUserDefaults standardUserDefaults] setObject:seed forKey:@"temp_seed"];
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"temp_password"];
    [[NSUserDefaults standardUserDefaults] setObject:hint forKey:@"temp_hint"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    //**********mis
    /*
     登录的账户已经在链上存在时，需要验证: 输入的助记词生成的公钥是否与链上一致，若一致才导入成功
     当前账户在公链不存在时，才去注册，可能存在同一套公司钥注册不同帐号问题
     */
    /*
     if ((self.ifverify == 2000 && self.pubkeyInChain) || [CreateAll ifMisWalletRegistered] == YES) {
         [self VerifymnemonicSeed:seed callback:^(BOOL response , NSString *pubkey) {
             if (response == NO) {
                 [self.view hideHUD];
                 [self.view showMsg:NSLocalizedString(@"请输入帐号对应的助记词或更换其他帐号！", nil)];
             }else{
                 [self CreateMISWalletSeed:seed PassWord:password PassHint:hint];
             }
         }];
     }else{
         //新注册用户，需要检测导入的是否存在
         [self CreateMISWalletSeed:seed PassWord:password PassHint:hint];

     }*/
    [self CreateMISWalletSeed:seed PassWord:password PassHint:hint];


}
//type:0:import  1:create
-(void)CreateWalletsSeed:(NSString *)seed password:(NSString *)password Hint:(NSString *)hint Type:(NSInteger)type{
    NSString *xprv = [CreateAll CreateExtendPrivateKeyWithSeed:seed];
    CoinType typex = BTC;
    if (ChangeToTESTNET == 0) {
        typex = BTC;
    }else if (ChangeToTESTNET == 1){
        typex = BTC_TESTNET;
    }
    
    
    MissionWallet *walletBTC = [CreateAll CreateWalletByXprv:xprv index:0 CoinType:typex Password:password];
    MissionWallet *walletETH = [CreateAll CreateWalletByXprv:xprv index:0 CoinType:ETH Password:password];
    
    if (!walletBTC || !walletETH) {
        [self.view hideHUD];
        [self.view showAlert:@"Error" DetailMsg:@"钱包生成失败！"];
        return;
    }
    
    if (self.setPasswordView.passwordHintTextField.text == nil) {
        walletBTC.passwordHint = @"";
        walletETH.passwordHint = @"";
    }else{
        walletBTC.passwordHint = self.setPasswordView.passwordHintTextField.text;
        walletETH.passwordHint = self.setPasswordView.passwordHintTextField.text;
        [CreateAll UpdatePasswordHint:self.setPasswordView.passwordHintTextField.text];
    }
    //根据地址存助记词
    [SAMKeychain setPassword:[AESCrypt encrypt:_mnemonic password:password] forService:PRODUCT_BUNDLE_ID account:[NSString stringWithFormat:@"mnemonic%@",_eoswallet.address]];
    [SAMKeychain setPassword:[AESCrypt encrypt:_mnemonic password:password] forService:PRODUCT_BUNDLE_ID account:[NSString stringWithFormat:@"mnemonic%@",walletBTC.address]];
    [SAMKeychain setPassword:[AESCrypt encrypt:_mnemonic password:password] forService:PRODUCT_BUNDLE_ID account:[NSString stringWithFormat:@"mnemonic%@",walletETH.address]];
    MJWeakSelf
    //创建并存KeyStore eth
    [CreateAll CreateKeyStoreByMnemonic:self.mnemonic  WalletAddress:walletETH.address Password:password callback:^(Account *account, NSError *error) {
        if (account == nil) {
            [weakSelf.view showMsg:NSLocalizedString(@"导入出错,助记词错误！", nil)];
        }else{
            [self addTempWalletData:walletBTC andEth:walletETH andmgp:self.mgpwallet];

            [weakSelf.view showMsg:NSLocalizedString(@"导入成功！", nil)];
            [[NSUserDefaults standardUserDefaults]  setBool:YES forKey:@"ifHasAccount"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [CreateAll SaveWallet:walletBTC Name:walletBTC.walletName WalletType:LOCAL_WALLET Password:password];
            [CreateAll SaveWallet:walletETH Name:walletETH.walletName WalletType:LOCAL_WALLET Password:password];
            [[NSUserDefaults standardUserDefaults] setInteger:200 forKey:@"isFirstUse"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                UIWindow *window = ((AppDelegate*)([UIApplication sharedApplication].delegate)).window;
                CYLMainRootViewController *csVC = [[CYLMainRootViewController alloc] init];
                window.rootViewController = csVC;;
            });
        }
    }];
    /*
    NSString *str = [NSString stringWithFormat:@"%@:MIS,%@:BTC,%@:ETH",[CreateAll GetCurrentUserName],walletBTC.address,walletETH.address];
 
    [NetManager AddAccountLogWithuserName:[CreateAll GetCurrentUserName] AccountInfo:str RecordType:type == 0?IMPORT_LOG_TYPE:CREATE_LOG_TYPE CompletionHandler:^(id responseObj, NSError *error) {
        if (!error) {
            if (![[NSString stringWithFormat:@"%@",responseObj[@"resultCode"]] isEqualToString:@"20000"]) {
                [weakSelf.view showAlert:@"" DetailMsg:responseObj[@"resultMsg"]];
                return ;
            }
        }else{
            [weakSelf.view showAlert:[NSString stringWithFormat:@"Error:%ld",error.code] DetailMsg:error.localizedDescription];
        }
    }];*/
}


//创建mis钱包
-(MissionWallet *)CreateEOSWalletPri:(NSString *)pri Pub:(NSString *)pub PassWord:(NSString *)pass PassHint:(NSString *)hint CoinType:(CoinType)type{
    NSString *username = [CreateAll GetCurrentUserName];
    if (!username) {
        return nil;
    }
    MissionWallet *wallet = [MissionWallet new];
    wallet.coinType = type;
    wallet.importType = LOCAL_CREATED_WALLET;
    wallet.walletType = LOCAL_WALLET;
    wallet.index = 0;
    wallet.passwordHint = hint;
    wallet.privateKey = pri;
    wallet.publicKey = pub;
    wallet.walletName = [NSString stringWithFormat:@"%@_%@",type == MGP ? @"MGP" : @"EOS",username];
//    wallet.walletName = type == MGP?[NSString stringWithFormat:@"%@_%@",@"MGP",username]:@"EOS_";
    wallet.address = @"";
    [wallet dataCheck];
    return wallet;
}
//注册mis账户
-(void)RegisterMisWallet:( MissionWallet *)misWallet Seed:(NSString *)seed Password:(NSString *)password PassHint:(NSString *)hint{
    CurrentNodes *nodes = [CreateAll GetCurrentNodes];
    if (!nodes) {
        [self.view showMsg:NSLocalizedString(@"Mis节点没得到", nil)];
        return;
    }
    NSString *misnodeurl = nodes.nodeMis;
    NSString *accountname = [misWallet.walletName componentsSeparatedByString:@"_"].lastObject;
    [CreateAll SaveWallet:misWallet Name:misWallet.walletName WalletType:LOCAL_WALLET Password:password];
     [CreateAll setmisWalletisRegistered];
     
     [CreateAll SaveWallet:self.eoswallet Name:self.eoswallet.walletName WalletType:LOCAL_WALLET Password:password];
     [[NSUserDefaults standardUserDefaults] setObject:self.eoswallet.walletName forKey:@"LocalEOSWalletName"];
     [[NSUserDefaults standardUserDefaults] synchronize];
     
     [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"temp_seed"];
     [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"temp_password"];
     [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"temp_hint"];
     [[NSUserDefaults standardUserDefaults] synchronize];
     [self.view showMsg:NSLocalizedString(@"导入成功！", nil)];
     [self CreateWalletsSeed:seed password:password Hint:hint Type:1];
    
    /*
    MJWeakSelf
    [NetManager CreateAccountWithAccountName:accountname publickey:misWallet.publicKey nodeUrl:misnodeurl completionHandler:^(id responseObj, NSError *error) {
            if (!error) {
                
                if (![[NSString stringWithFormat:@"%@",responseObj[@"resultCode"]] isEqualToString:@"20000"]) {
                    if ([responseObj[@"resultMsg"] containsString:@"code:3050001"]) {//code:3050001(Account name already exists)
                        [weakSelf.view showAlert:@"" DetailMsg:responseObj[@"resultMsg"]];
                        [CreateAll setmisWalletisRegistered];
                        return ;
                    }else{
                        [weakSelf.view showAlert:@"" DetailMsg:responseObj[@"resultMsg"]];
                        return ;
                    }
                }
                
                [CreateAll SaveWallet:misWallet Name:misWallet.walletName WalletType:LOCAL_WALLET Password:password];
                [CreateAll setmisWalletisRegistered];
                
                [CreateAll SaveWallet:self.eoswallet Name:self.eoswallet.walletName WalletType:LOCAL_WALLET Password:password];
                [[NSUserDefaults standardUserDefaults] setObject:self.eoswallet.walletName forKey:@"LocalEOSWalletName"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"temp_seed"];
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"temp_password"];
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"temp_hint"];
                [[NSUserDefaults standardUserDefaults] synchronize];
               // [weakSelf.view showMsg:NSLocalizedString(@"导入成功！", nil)];
                [weakSelf CreateWalletsSeed:seed password:password Hint:hint Type:1];
               
            }else{
                [weakSelf.view showAlert:[NSString stringWithFormat:@"Error:%ld",error.code] DetailMsg:error.localizedDescription];
            }
        }];
*/
}

-(void)VerifymnemonicSeed:(NSString *)seed  callback: (void(^)(BOOL response, NSString *pubkey))callback{
  
    NSString *mispri = [CreateAll CreateEOSPrivateKeyBySeed:seed Index:0];
    
    NSString *pubx = [EosEncode eos_publicKey_with_wif:mispri];
    NSLog(@"mispri %@\n***pub %@",mispri,self.pubkeyInChain);
    NSLog(@"pubx = %@",pubx);
    NSString *pubkeyInChainstr = [self.pubkeyInChain stringByReplacingOccurrencesOfString:@"MIS" withString:@"EOS"];
    if (![pubx isEqualToString:pubkeyInChainstr]) {
        callback(NO, nil);
    }else{
        callback(YES, pubx);
        
    }

}
//

//生成mgp公私钥
-(void)CreateMISWalletSeed:(NSString *)seed PassWord:(NSString *)password PassHint:(NSString *)hint{
    // MIS & EOS & MGP*****************
 
    NSString *mispri = [CreateAll CreateEOSPrivateKeyBySeed:seed Index:0];
    NSString *pubx = [EosEncode eos_publicKey_with_wif:mispri];
//    NSString *pub = [pubx stringByReplacingOccurrencesOfString:@"EOS" withString:@"MGP"];
    MissionWallet *mgpwallet = [self CreateEOSWalletPri:mispri Pub:pubx PassWord:password PassHint:hint CoinType:MGP];
    self.mgpwallet = mgpwallet;
    self.eoswallet = [self CreateEOSWalletPri:mispri Pub:pubx PassWord:password PassHint:hint CoinType:EOS];
    
    if (mgpwallet != nil) {
        if (mgpwallet != nil) { //self.ifverify == 2000 && self.pubkeyInChain
            [CreateAll SaveWallet:mgpwallet Name:mgpwallet.walletName WalletType:LOCAL_WALLET Password:password];
            [CreateAll SaveWallet:self.eoswallet Name:self.eoswallet.walletName WalletType:LOCAL_WALLET Password:password];
            
            [[NSUserDefaults standardUserDefaults] setObject:self.eoswallet.walletName forKey:@"LocalEOSWalletName"];
            [[NSUserDefaults standardUserDefaults] setObject:mgpwallet.walletName forKey:@"LocalMGPWalletName"];
            [CreateAll setmisWalletisRegistered];
//            [CreateAll SaveWallet:self.eoswallet Name:self.eoswallet.walletName WalletType:LOCAL_WALLET Password:password];
//            [[NSUserDefaults standardUserDefaults] setObject:self.eoswallet.walletName forKey:@"LocalEOSWalletName"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"temp_seed"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"temp_password"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"temp_hint"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self CreateWalletsSeed:seed password:password Hint:hint Type:0];
            
        }else{
            
            [self RegisterMisWallet:mgpwallet Seed:seed Password:password PassHint:hint];
        }
    }
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
                            // [self.navigationController pushViewController:scanVC animated:YES];
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
                // [self.navigationController pushViewController:scanVC animated:YES];
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
    [weakSelf presentViewController:alertC animated:YES completion:nil];
}


- (void)addTempWalletData:(MissionWallet *)wallet_btc andEth:(MissionWallet *)wallet_eth andmgp:(MissionWallet *)wallet_mgp{
    
    //临时数据
    TokenModel *btcToken = [TokenModel new];
    btcToken.decimals = 18;
    btcToken.identifier = [NSString stringWithFormat:@"%d",arc4random()];
    btcToken.name = @"BTC";
    btcToken.symbol = @"btc";
    btcToken.iconUrl = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1600952264668&di=dd73a38d6d614e002166bd34f1243604&imgtype=0&src=http%3A%2F%2Fbpic.588ku.com%2Felement_pic%2F18%2F07%2F09%2F9142656059f7982817b6fb7f20f49137.jpg";
    
    WalletModel *btcWallet = [WalletModel new];
    btcWallet.address = wallet_btc.address;
    btcWallet.name = @"BTC 钱包";
    btcWallet.pwdTips = @"1-8";
    btcWallet.coinType = 0;
    [btcWallet.selectedTokenList addObject:btcToken];
        
    //eth
    TokenModel *ethToken = [TokenModel new];
    ethToken.decimals = 18;
    ethToken.identifier = [NSString stringWithFormat:@"%d",arc4random()];
    ethToken.name = @"ETH";
    ethToken.symbol = @"eth";
    ethToken.iconUrl = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1600952747030&di=69b86f79b7d6d4b566ab5c892f9823b4&imgtype=0&src=http%3A%2F%2Fwww.sdkbox.com%2Fassets%2Fimg%2Feth.png";
    
    TokenModel *ethToken1 = [TokenModel new];
    ethToken1.decimals = 18;
    ethToken1.identifier = [NSString stringWithFormat:@"%d",arc4random()];
    ethToken1.name = @"ACBC";
    ethToken1.symbol = @"acbc";
    ethToken1.contractAddress = @"0x77BC9462EF31177693edaAaA9aa68f10F9DA685D";
    ethToken1.iconUrl = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1600952747030&di=69b86f79b7d6d4b566ab5c892f9823b4&imgtype=0&src=http%3A%2F%2Fwww.sdkbox.com%2Fassets%2Fimg%2Feth.png";
    
    TokenModel *ethToken2 = [TokenModel new];
    ethToken2.decimals = 18;
    ethToken2.identifier = [NSString stringWithFormat:@"%d",arc4random()];
    ethToken2.name = @"BBA";
    ethToken2.symbol = @"bba";
    ethToken2.contractAddress = @"0xA9c812E981cc5C98813F2E052841C26E0dff3BFD";
    ethToken2.iconUrl = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1600952747030&di=69b86f79b7d6d4b566ab5c892f9823b4&imgtype=0&src=http%3A%2F%2Fwww.sdkbox.com%2Fassets%2Fimg%2Feth.png";
    
    WalletModel *ethWallet = [WalletModel new];
    ethWallet.address = wallet_eth.address;
    ethWallet.name = @"ETH 钱包";
    ethWallet.pwdTips = @"1-8";
    ethWallet.coinType = 1;
    [ethWallet.selectedTokenList addObject:ethToken];
    [ethWallet.selectedTokenList addObject:ethToken1];
    [ethWallet.selectedTokenList addObject:ethToken2];

    
    //eos
    TokenModel *eosToken = [TokenModel new];
    eosToken.decimals = 18;
    eosToken.identifier = [NSString stringWithFormat:@"%d",arc4random()];
    eosToken.name = @"EOS";
    eosToken.symbol = @"eos";
    eosToken.iconUrl = @"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=2081595052,1781790372&fm=26&gp=0.jpg";
    
    WalletModel *eosWallet = [WalletModel new];
    eosWallet.address = self.eoswallet.address;
    eosWallet.name = @"EOS 钱包";
    eosWallet.pwdTips = @"1-8";
    eosWallet.coinType = 3;
    [eosWallet.selectedTokenList addObject:eosToken];
    
    
    //mgp
    TokenModel *mgpToken = [TokenModel new];
    mgpToken.decimals = 18;
    mgpToken.identifier = [NSString stringWithFormat:@"%d",arc4random()];
    mgpToken.name = @"MGP";
    mgpToken.symbol = @"mgp";
    mgpToken.iconUrl = @"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=2396357380,56598836&fm=26&gp=0.jpg";
    
    TokenModel *mgpToken1 = [TokenModel new];
    mgpToken1.decimals = 18;
    mgpToken1.identifier = [NSString stringWithFormat:@"%d",arc4random()];
    mgpToken1.name = @"MGP-usdt";
    mgpToken1.symbol = @"mgp";
    mgpToken1.iconUrl = @"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=2396357380,56598836&fm=26&gp=0.jpg";
    
    
    WalletModel *mgpWallet = [WalletModel new];
    mgpWallet.address = wallet_mgp.address;
    mgpWallet.name = @"MGP 钱包";
    mgpWallet.pwdTips = @"1-8";
    mgpWallet.coinType = 4;
    [mgpWallet.selectedTokenList addObject:mgpToken];
    [mgpWallet.selectedTokenList addObject:mgpToken1];

    
    AppModel *appModel = [AppModel new];
    appModel.currentWallet = mgpWallet;
    [appModel.wallets addObject:btcWallet];
    [appModel.wallets addObject:ethWallet];
    [appModel.wallets addObject:eosWallet];
    [appModel.wallets addObject:mgpWallet];

    [[LHWalletManager sharedManger]addDefaultAppWalletModel:appModel];

    
    
}

@end
