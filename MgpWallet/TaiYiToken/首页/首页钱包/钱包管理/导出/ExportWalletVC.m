//
//  ExportWalletVC.m
//  TaiYiToken
//
//  Created by admin on 2018/9/4.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "ExportWalletVC.h"
#import "ExportWalletCell.h"
#import "InputPasswordView.h"
#import "ExportKeyStoreVC.h"
#import "ExportPrivateKeyOrMnemonicVC.h"
#import "ExportWalletAddressVC.h"
#import "ExportPasswordHintVC.h"
#import "ExportEOSPriKeyVC.h"
@interface ExportWalletVC ()<UITableViewDelegate ,UITableViewDataSource>
@property(nonatomic)UITableView *tableView;
@property(nonatomic)NSArray *iconImageNameArray;
@property(nonatomic)NSArray *titleArray;
@property(nonatomic)UIView *shadowView;
@property(nonatomic)InputPasswordView *ipview;
@property(nonatomic,strong) UIButton *backBtn;
@property(nonatomic)UILabel *titleLabel;
@property(nonatomic)NSInteger selectedIndex;
@property(nonatomic,copy)NSString *password;

@property(nonatomic)UIButton *deleteWalletBtn;
@end

@implementation ExportWalletVC
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
//    [self initHeadView];
    NSString *title = @"";
    if (self.wallet.coinType == BTC) {
        title = [NSString stringWithFormat:@"%@ %@",self.wallet.walletName, NSLocalizedString(@"导出", nil)];
    }else if (self.wallet.coinType == ETH){
        title = [NSString stringWithFormat:@"%@ %@",self.wallet.walletName, NSLocalizedString(@"导出", nil)];
    }else if (self.wallet.coinType == MGP){
        title = [NSString stringWithFormat:@"MGP %@", NSLocalizedString(@"导出", nil)];
    }else if (self.wallet.coinType == EOS){
        title = [NSString stringWithFormat:@"EOS %@", NSLocalizedString(@"导出", nil)];
    }
    self.title = title;
    self.selectedIndex = -1;
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.wallet.coinType == BTC || self.wallet.coinType == BTC_TESTNET) {
        if ((self.wallet.importType == IMPORT_BY_MNEMONIC) || (self.wallet.walletType == LOCAL_WALLET)) {//助记词导入的才能导出助记词
//            self.iconImageNameArray = @[@"ico_wallet_adress",@"ico_export_pub",@"ico_password",@"ico_export_pub"];
//            self.titleArray = @[NSLocalizedString(@"钱包地址", nil),NSLocalizedString(@"切换地址类型", nil),NSLocalizedString(@"密码提示信息", nil),NSLocalizedString(@"导出助记词", nil)];
            self.iconImageNameArray = @[@"ico_export_pub",@"ico_password",@"ico_export_pub"];
            self.titleArray = @[NSLocalizedString(@"密码提示信息", nil),NSLocalizedString(@"导出助记词", nil)];
        }else{
            self.iconImageNameArray = @[@"ico_export_pub",@"ico_password"];
            self.titleArray = @[NSLocalizedString(@"密码提示信息", nil),NSLocalizedString(@"导出私钥", nil)];
        }
        
    }else if (self.wallet.coinType == ETH){
        if ((self.wallet.importType == IMPORT_BY_MNEMONIC) || (self.wallet.walletType == LOCAL_WALLET)) {
            self.iconImageNameArray = @[@"ico_key",@"ico_export_pub",@"ico_password",@"ico_export_pub"];
            self.titleArray = @[NSLocalizedString(@"密码提示信息", nil),NSLocalizedString(@"导出Keystore", nil),NSLocalizedString(@"导出私钥", nil),NSLocalizedString(@"导出助记词", nil)];
        }else{
            self.iconImageNameArray = @[@"ico_key",@"ico_export_pub",@"ico_password"];
            self.titleArray = @[NSLocalizedString(@"密码提示信息", nil),NSLocalizedString(@"导出Keystore", nil),NSLocalizedString(@"导出私钥", nil)];
        }
    }else if (self.wallet.coinType == MIS){
        self.iconImageNameArray = @[@"ico_export_pub",@"ico_key",@"ico_password"];
        self.titleArray = @[NSLocalizedString(@"密码提示信息", nil),NSLocalizedString(@"导出助记词", nil),NSLocalizedString(@"导出私钥", nil)];
    }else if (self.wallet.coinType == EOS || self.wallet.coinType == MGP){
        if (_wallet.importType == IMPORT_BY_PRIVATEKEY) {
            self.iconImageNameArray = @[@"ico_export_pub",@"ico_password"];
            self.titleArray = @[NSLocalizedString(@"密码提示信息", nil),NSLocalizedString(@"导出私钥", nil)];
        }else{
            self.iconImageNameArray = @[@"ico_export_pub",@"ico_key",@"ico_password"];
            self.titleArray = @[NSLocalizedString(@"密码提示信息", nil),NSLocalizedString(@"导出助记词", nil),NSLocalizedString(@"导出私钥", nil)];
        }
        
    }
    [self tableView];
    

    //导入的钱包可删除
    if (self.wallet.walletType == IMPORT_WALLET) {
        
        UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
        self.tableView.tableFooterView = view1;
        
        _deleteWalletBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteWalletBtn.backgroundColor = [UIColor redColor];
        [_deleteWalletBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [_deleteWalletBtn setTitle:NSLocalizedString(@"删除钱包", nil) forState:UIControlStateNormal];
        _deleteWalletBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [_deleteWalletBtn addTarget:self action:@selector(deleteWalletAction) forControlEvents:UIControlEventTouchUpInside];
        [view1 addSubview:_deleteWalletBtn];
        [_deleteWalletBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.right.equalTo(0);
        }];
    }else{
        _tableView.tableFooterView = [UIView new];

    }
    
}

-(void)deleteWalletAction{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"此操作将会移除钱包，请提前做好备份！", nil) message:@"" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *alertA = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *alertB = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        NSString *result = [CreateAll RemoveImportedWallet:self.wallet];
        [self.view showMsg:result];
        if (self.updateUserInfoBlock) {
            self.updateUserInfoBlock();
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    [alertC addAction:alertA];
    [alertC addAction:alertB];
    [self presentViewController:alertC animated:YES completion:nil];
}


-(void)initHeadView{
 
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
    NSString *title = @"";
    if (self.wallet.coinType == BTC) {
        title = [NSString stringWithFormat:@"%@ %@",self.wallet.walletName, NSLocalizedString(@"导出", nil)];
    }else if (self.wallet.coinType == ETH){
        title = [NSString stringWithFormat:@"%@ %@",self.wallet.walletName, NSLocalizedString(@"导出", nil)];
    }else if (self.wallet.coinType == MGP){
        title = [NSString stringWithFormat:@"MGP %@", NSLocalizedString(@"导出", nil)];
    }else if (self.wallet.coinType == EOS){
        title = [NSString stringWithFormat:@"EOS %@", NSLocalizedString(@"导出", nil)];
    }
    self.title = title;
    [_titleLabel setText:title];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(SafeAreaTopHeight - 30);
        make.left.equalTo(45);
        make.width.equalTo(200);
        make.height.equalTo(20);
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma tableView

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *lineview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    lineview.backgroundColor = kRGBA(230, 230, 230, 1);
    return lineview;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 2;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    //比特币导出地址 不用密码
//    if (self.wallet.coinType == BTC && indexPath.row == 0) {
//        [self ExportAddress];
//        return;
//    }
    //比特币切换地址类型 不用密码
//    if (self.wallet.coinType == BTC && indexPath.row == 1) {
//        [self ChangeBTCAddressType];
//        return;
//    }
//    if (self.wallet.importType == IMPORT_BY_PRIVATEKEY && (self.wallet.coinType == BTC || self.wallet.coinType == BTC_TESTNET)) {
//        if (indexPath.row == 0) {
//            [self ExportPasswordHint];
//            return;
//        }
//    }
     //密码提示信息 不用密码
    if (indexPath.row == 0) {
        [self ExportPasswordHint];
        return;
    }
   
    if (!_shadowView) {
        _shadowView = [UIView new];
        _shadowView.layer.shadowColor = [UIColor grayColor].CGColor;
        _shadowView.layer.shadowOffset = CGSizeMake(0, 0);
        _shadowView.layer.shadowOpacity = 1;
        _shadowView.layer.shadowRadius = 3.0;
        _shadowView.layer.cornerRadius = 3.0;
        _shadowView.clipsToBounds = NO;
    }
    
    _shadowView.alpha = 0;
    [self.tableView addSubview:_shadowView];
    [_shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(0);
        make.width.equalTo(300);
        make.height.equalTo(120);
    }];
    if (!_ipview) {
        _ipview = [InputPasswordView new];
        [_ipview initUI];
        [_ipview.confirmBtn addTarget:self action:@selector(confirmBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    [_shadowView addSubview:_ipview];
    [_ipview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
    self.selectedIndex = indexPath.row;
    MJWeakSelf
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.shadowView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.shadowView removeFromSuperview];
    [self.ipview removeFromSuperview];
    self.shadowView = nil;
    self.ipview = nil;
}

-(void)confirmBtnAction{
    MJWeakSelf
    [UIView animateWithDuration:0.5 animations:^{
       weakSelf.shadowView.alpha = 0;
        
    } completion:^(BOOL finished) {
        weakSelf.password = weakSelf.ipview.passwordTextField.text;
        [weakSelf.shadowView removeFromSuperview];
        [weakSelf.ipview removeFromSuperview];
        weakSelf.shadowView = nil;
        weakSelf.ipview = nil;
        [weakSelf GoToExportPage];
    }];
   
}
-(void)GoToExportPage{
    if (self.selectedIndex == -1) {
        return;
    }
    if (self.password == nil || [self.password isEqualToString:@""]) {
        [self.view showMsg:NSLocalizedString(@"请输入密码", nil)];
        return;
    }
   

// ETH  @[NSLocalizedString(@"密码提示信息", nil),NSLocalizedString(@"导出Keystore", nil),NSLocalizedString(@"导出私钥", nil),NSLocalizedString(@"导出助记词", nil)];
// MIS  @[NSLocalizedString(@"密码提示信息", nil),NSLocalizedString(@"导出助记词", nil),NSLocalizedString(@"导出私钥", nil)];
// BTC  @[NSLocalizedString(@"密码提示信息", nil),NSLocalizedString(@"导出私钥", nil),NSLocalizedString(@"导出助记词", nil)];
    
    switch (self.selectedIndex) {
        case 1:
            if (self.wallet.coinType == ETH) {
                [self ExportKeyStore];
            }
            else if (_wallet.coinType == MIS) {
                [self ExportMnemonic];
            }
            else if(_wallet.coinType == BTC){
                if (_wallet.importType == IMPORT_BY_PRIVATEKEY) {
                    [self ExportPrivateKey];
                }else{
                    [self ExportMnemonic];
                }
                
            }else if (_wallet.coinType == EOS){
                if (_wallet.importType == IMPORT_BY_PRIVATEKEY) {
                    [self ExportPrivateKey];
                }else{
                    [self ExportMnemonic];
                }
            }else if (_wallet.coinType == MGP){
                if (_wallet.importType == IMPORT_BY_PRIVATEKEY) {
                    [self ExportPrivateKey];
                }else{
                    [self ExportMnemonic];
                }
            }
            break;
        case 2:
            if (self.wallet.coinType == ETH) {
                [self ExportPrivateKey];
            }
            else if (_wallet.coinType == MIS) {
                [self ExportPrivateKey];
            }else if (_wallet.coinType == BTC) {
                [self ExportMnemonic];
            }else if (_wallet.coinType == EOS){
                [self ExportPrivateKey];
            }else if (_wallet.coinType == MGP){
                [self ExportPrivateKey];
            }
            break;
        case 3:
            if (self.wallet.coinType == ETH) {
                [self ExportMnemonic];
            }
            break;
        default:
            [self ExportPasswordHint];
            break;
    }
}
//导出地址 不验证密码
-(void)ExportAddress{
    ExportWalletAddressVC *wadvc = [ExportWalletAddressVC new];
    wadvc.wallet = self.wallet;
    [self.navigationController pushViewController:wadvc animated:YES];
}
//ETH 导出KeyStore
-(void)ExportKeyStore{
    MJWeakSelf
    [self.view showHUD];
    [CreateAll ExportKeyStoreByPassword:self.password WalletAddress:self.wallet.address callback:^(NSString *address, NSError *error) {
        [weakSelf.view hideHUD];
        if (!error) {
            if ([weakSelf.wallet.address isEqualToString:address]) {
                ExportKeyStoreVC *ekvc = [ExportKeyStoreVC new];
                ekvc.keystore = [[NSUserDefaults standardUserDefaults]  objectForKey:[NSString stringWithFormat:@"keystore%@",address]];
                [weakSelf.navigationController pushViewController:ekvc animated:YES];
            } else{
                [weakSelf.view showMsg:NSLocalizedString(@"密码错误", nil)];
            }
        }else{
            [weakSelf.view showMsg:NSLocalizedString(@"密码错误", nil)];
        }
    }];
}
//ETH MIS 导出私钥
-(void)ExportPrivateKey{
    MJWeakSelf
    [self.view showHUD];
    if (self.wallet.coinType == ETH) {
        [CreateAll ExportPrivateKeyByPassword:self.password  CoinType:self.wallet.coinType WalletAddress:self.wallet.address index:self.wallet.index callback:^(NSString *privateKey, NSError *error) {
            [weakSelf.view hideHUD];
            if (!error && privateKey != nil) {
                
                //解密钱包私钥
                if([weakSelf.wallet.privateKey containsString:@"0x"]){
                    weakSelf.wallet.privateKey = [weakSelf.wallet.privateKey substringFromIndex:2];
                }
                BOOL isValid = [CreateAll ValidHexString:weakSelf.wallet.privateKey];
                if (isValid == NO) {
                    NSString *depri = [AESCrypt decrypt:weakSelf.wallet.privateKey password:weakSelf.password];
                    weakSelf.wallet.privateKey = depri;
                    if([weakSelf.wallet.privateKey containsString:@"0x"]){
                        weakSelf.wallet.privateKey = [weakSelf.wallet.privateKey substringFromIndex:2];
                    }
                    BOOL isValidde = [CreateAll ValidHexString:weakSelf.wallet.privateKey];
                    if (isValidde == YES) {
                        ExportPrivateKeyOrMnemonicVC *epmvc = [ExportPrivateKeyOrMnemonicVC new];
                        epmvc.privateKey = weakSelf.wallet.privateKey;
                        epmvc.isExportPrivateKey = YES;
                        epmvc.isExportMnemonic = NO;
                        [weakSelf.navigationController pushViewController:epmvc animated:YES];
                    }else{
                        [weakSelf.view showMsg:@"Wallet Error"];
                    }
                }else{
                    ExportPrivateKeyOrMnemonicVC *epmvc = [ExportPrivateKeyOrMnemonicVC new];
                    epmvc.privateKey = weakSelf.wallet.privateKey;
                    epmvc.isExportPrivateKey = YES;
                    epmvc.isExportMnemonic = NO;
                    [weakSelf.navigationController pushViewController:epmvc animated:YES];
                }
                
            }else{
                
                BOOL passwordisright =  [CreateAll VerifyPassword:weakSelf.password ForWalletAddress:weakSelf.wallet.address];
                if (passwordisright == YES) {
                    //解密钱包私钥
                    if([weakSelf.wallet.privateKey containsString:@"0x"]){
                        weakSelf.wallet.privateKey = [weakSelf.wallet.privateKey substringFromIndex:2];
                    }
                    BOOL isValid = [CreateAll ValidHexString:weakSelf.wallet.privateKey];
                    if (isValid == NO) {
                        NSString *depri = [AESCrypt decrypt:weakSelf.wallet.privateKey password:weakSelf.password];
                        weakSelf.wallet.privateKey = depri;
                        if([weakSelf.wallet.privateKey containsString:@"0x"]){
                            weakSelf.wallet.privateKey = [weakSelf.wallet.privateKey substringFromIndex:2];
                        }
                        BOOL isValidde = [CreateAll ValidHexString:weakSelf.wallet.privateKey];
                        if (isValidde == YES) {
                            ExportPrivateKeyOrMnemonicVC *epmvc = [ExportPrivateKeyOrMnemonicVC new];
                            epmvc.privateKey = weakSelf.wallet.privateKey;
                            epmvc.isExportPrivateKey = YES;
                            epmvc.isExportMnemonic = NO;
                            [weakSelf.navigationController pushViewController:epmvc animated:YES];
                        }else{
                            [weakSelf.view showMsg:@"Wallet Error"];
                        }
                    }else{
                        ExportPrivateKeyOrMnemonicVC *epmvc = [ExportPrivateKeyOrMnemonicVC new];
                        epmvc.privateKey = weakSelf.wallet.privateKey;
                        epmvc.isExportPrivateKey = YES;
                        epmvc.isExportMnemonic = NO;
                        [weakSelf.navigationController pushViewController:epmvc animated:YES];
                    }
                }else{
                    [weakSelf.view showMsg:NSLocalizedString(@"密码错误", nil)];
                }
            }
        }];
    }else if (self.wallet.coinType == MIS){
        BOOL passwordisright = [CreateAll VerifyPassword:self.password ForWalletAddress:self.wallet.address];
        [self.view hideHUD];
        if (passwordisright == YES) {
            //解密钱包私钥
            if(![self.wallet.privateKey isValidBitcoinPrivateKey]){
                NSString *depri = [AESCrypt decrypt:self.wallet.privateKey password:self.password];
                if (depri != nil && ![depri isEqualToString:@""]) {
                    self.wallet.privateKey = depri;
                }
            }
            ExportEOSPriKeyVC *epmvc = [ExportEOSPriKeyVC new];
            epmvc.privateKey = self.wallet.privateKey;
            epmvc.publicKey = self.wallet.publicKey;
            [self.navigationController pushViewController:epmvc animated:YES];
        }else{
             [self.view showMsg:NSLocalizedString(@"密码错误", nil)];
        }
    }else if (self.wallet.coinType == BTC){
        BOOL passwordisright = [CreateAll VerifyPassword:self.password ForWalletAddress:self.wallet.address];
        [self.view hideHUD];
        if (passwordisright == YES) {
            //解密钱包私钥
            if(![self.wallet.privateKey isValidBitcoinPrivateKey]){
                NSString *depri = [AESCrypt decrypt:self.wallet.privateKey password:self.password];
                if (depri != nil && ![depri isEqualToString:@""]) {
                    self.wallet.privateKey = depri;
                }
            }
            ExportPrivateKeyOrMnemonicVC *epmvc = [ExportPrivateKeyOrMnemonicVC new];
            epmvc.privateKey = self.wallet.privateKey;
            epmvc.isExportPrivateKey = YES;
            epmvc.isExportMnemonic = NO;
            [self.navigationController pushViewController:epmvc animated:YES];
        }else{
            [self.view showMsg:NSLocalizedString(@"密码错误", nil)];
        }
    }else if (self.wallet.coinType == EOS){
        
        BOOL passwordisright = [CreateAll VerifyPassword:self.password ForWalletAddress:self.wallet.address];
        if (passwordisright == NO && _wallet.coinType == EOS && _wallet.walletType == LOCAL_WALLET) {
            passwordisright = [CreateAll VerifyPassword:self.password ForWalletAddress:@"EOS_Temp"];
            if (passwordisright == YES) {
                [CreateAll SaveWallet:_wallet Name:_wallet.walletName WalletType:_wallet.walletType Password:self.password];
            }
        }
        [self.view hideHUD];
        if (passwordisright == YES) {
            //解密钱包私钥
            if(![self.wallet.privateKey isValidBitcoinPrivateKey]){
                NSString *depri = [AESCrypt decrypt:self.wallet.privateKey password:self.password];
                if (depri != nil && ![depri isEqualToString:@""]) {
                    self.wallet.privateKey = depri;
                }
            }
            ExportEOSPriKeyVC *epmvc = [ExportEOSPriKeyVC new];
            epmvc.privateKey = self.wallet.privateKey;
            epmvc.publicKey = self.wallet.publicKey;
            [self.navigationController pushViewController:epmvc animated:YES];
        }else{
            [self.view showMsg:NSLocalizedString(@"密码错误", nil)];
        }
    }else if (self.wallet.coinType == MGP){
        
        BOOL passwordisright = [CreateAll VerifyPassword:self.password ForWalletAddress:self.wallet.address];
        if (passwordisright == NO && _wallet.coinType == MGP && _wallet.walletType == LOCAL_WALLET) {
            passwordisright = [CreateAll VerifyPassword:self.password ForWalletAddress:@"MGP_Temp"];
            if (passwordisright == YES) {
                [CreateAll SaveWallet:_wallet Name:_wallet.walletName WalletType:_wallet.walletType Password:self.password];
            }
        }
        [self.view hideHUD];
        if (passwordisright == YES) {
            //解密钱包私钥
            if(![self.wallet.privateKey isValidBitcoinPrivateKey]){
                NSString *depri = [AESCrypt decrypt:self.wallet.privateKey password:self.password];
                if (depri != nil && ![depri isEqualToString:@""]) {
                    self.wallet.privateKey = depri;
                }
            }
            ExportEOSPriKeyVC *epmvc = [ExportEOSPriKeyVC new];
            epmvc.privateKey = self.wallet.privateKey;
            epmvc.publicKey = self.wallet.publicKey;
            [self.navigationController pushViewController:epmvc animated:YES];
        }else{
            [self.view showMsg:NSLocalizedString(@"密码错误", nil)];
        }
    }
   
}
//BTC ETH导出Mnemonic
-(void)ExportMnemonic{
    [self.view showHUD];
    
    NSString *addr;
    if (self.wallet.walletType == LOCAL_WALLET) {
        MissionWallet *ethwallet = [CreateAll GetMissionWalletByName:@"ETH"];
        addr = ethwallet.address;
    }else{
        addr = self.wallet.address;
    }
    MJWeakSelf
    [CreateAll ExportMnemonicByPassword:self.password  WalletAddress:addr callback:^(NSString *mnemonic, NSError *error) {
        [weakSelf.view hideHUD];
        if (!error && mnemonic != nil) {
            ExportPrivateKeyOrMnemonicVC *epmvc = [ExportPrivateKeyOrMnemonicVC new];
            epmvc.mnemonic = mnemonic;
            epmvc.isExportPrivateKey = NO;
            epmvc.isExportMnemonic = YES;
            [weakSelf.navigationController pushViewController:epmvc animated:YES];
        }else{
            [weakSelf.view showMsg:NSLocalizedString(@"密码错误", nil)];
        }
    }];
}
//BTC  ETH MIS密码提示
-(void)ExportPasswordHint{
    ExportPasswordHintVC *passhintvc = [ExportPasswordHintVC new];
    if (self.wallet.walletType == IMPORT_WALLET) {
        passhintvc.passwordHint = self.wallet.passwordHint;
    }else{
        passhintvc.passwordHint = [CreateAll GetPasswordHint];
    }
    passhintvc.wallet = self.wallet;
    [self.navigationController pushViewController:passhintvc animated:YES];
}
//切换BTC地址类型
-(void)ChangeBTCAddressType{
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ExportWalletCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExportWalletCell" forIndexPath:indexPath];
    [cell.imageViewLeft setImage:[UIImage imageNamed:self.iconImageNameArray[indexPath.row]]];
    [cell.namelb setText:self.titleArray[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma lazy

-(UITableView *)tableView{
    if (!_tableView) {
       
        _tableView = [UITableView new];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[ExportWalletCell class] forCellReuseIdentifier:@"ExportWalletCell"];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(0);
            make.left.right.bottom.equalTo(0);
        }];
    }
    return _tableView;
}

@end
