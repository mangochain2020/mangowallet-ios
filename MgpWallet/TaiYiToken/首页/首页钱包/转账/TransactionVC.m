//
//  TransactionVC.m
//  TaiYiToken
//
//  Created by admin on 2018/9/13.
//  Copyright © 2018年 admin. All rights reserved.
//

#define MIN_ETH_GAS 0.0001

#define BTCMaximumValue 150
#define BTCMinimumValue 10
#define ETHMaximumValue 100
#define ETHMinimumValue 4



#import "TransactionVC.h"
#import "WBQRCodeVC.h"
#import "TransactionAmountView.h"
#import "TransactionAddressView.h"
#import "TransactionGasView.h"
#import "BTCBalanceModel.h"
#import "InputPasswordView.h"
#import "EOSTranDetailView.h"
#import "BlockChain.h"
#import "JavascriptWebViewController.h"
#import "SelectWalletView.h"
#import "BTCBlockChainListModel.h"
#import "OmniUSDTBalanceModel.h"
@interface TransactionVC ()<UIImagePickerControllerDelegate>
/*
 按钮选择d地址切换钱包
 */
//同币种钱包数组
@property(nonatomic,strong)NSMutableArray <MissionWallet *>*sameCoinTypeWallets;
@property(nonatomic,strong)SelectWalletView *selectAddressView;
@property(nonatomic)CGFloat RMBDollarCurrency;//人民币汇率
@property(nonatomic,strong) UIButton *backBtn;
@property(nonatomic)UILabel *titleLabel;
@property(nonatomic)UIButton *scanBtn;
@property(nonatomic,strong)TransactionAmountView *amountView;
@property(nonatomic,strong)TransactionAddressView *addressView;
@property(nonatomic,strong)TransactionGasView *gasView;
@property(nonatomic)UIButton *transactionBtn;
@property(nonatomic)CGFloat currentgasprice;
//@property(nonatomic)BTCBalanceModel *BTCbalance;
@property(nonatomic)CGFloat btcbalance;
@property(nonatomic)CGFloat btcUnconfirmedbalance;
@property(nonatomic)CGFloat BTCCurrency;//btc 美元汇率
@property(nonatomic)NSInteger satPerBit;//默认 35sat/b


@property(nonatomic)BigNumber *ETHbalance;
@property(nonatomic)CGFloat ETHCurrency;
@property(nonatomic)BigNumber *GasLimit;

@property(nonatomic)CGFloat MISbalance;
@property(nonatomic)CGFloat MISCurrency;

@property(nonatomic)CGFloat EOSbalance;
@property(nonatomic)CGFloat EOSCurrency;

@property(nonatomic)CGFloat usdtbalance;

//@property(nonatomic)UIView *shadowView;
//@property(nonatomic)InputPasswordView *ipview;
@property(nonatomic,copy)NSString *password;
@property(nonatomic,strong)UIView *dimview;
@property(nonatomic,strong)EOSTranDetailView *deview;
@property(nonatomic,strong)EOSTranDetailView *nextview;


//MIS/EOS trans
@property (nonatomic, strong) JSContext *context;
@property(nonatomic,strong)JavascriptWebViewController *jvc;

@property (nonatomic, copy) NSString *ref_block_prefix;
@property (nonatomic, copy) NSString *ref_block_num;
@property (nonatomic, strong) NSData *chain_Id;
@property (nonatomic, copy) NSString *expiration;
@property (nonatomic, copy) NSString *required_Publickey;
@property (nonatomic, copy) NSString *binargs;
@end

@implementation TransactionVC
//选择钱包
-(void)selectWallet:(UIButton *)btn{
   
    if (btn.tag == 5500) {
        btn.tag = 5501;
        if (self.sameCoinTypeWallets) {
            if (self.selectAddressView.isshowed == NO) {
                [self showSelectView];
            }
        }
    }else{
        
        btn.tag = 5500;
        if (self.selectAddressView.isshowed == YES) {
            [self hideSelectView];
        }
    }
}

-(void)showSelectView{
    CGFloat height = self.selectAddressView.view.height;
    self.selectAddressView.isshowed = YES;
    MJWeakSelf
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.selectAddressView.view.alpha = 1;
        [weakSelf.selectAddressView.view setFrame:CGRectMake(0, ScreenHeight - SafeAreaBottomHeight - height, ScreenWidth, height)];
    }];
}

-(void)hideSelectView{
    CGFloat height = self.selectAddressView.view.height;
    self.selectAddressView.isshowed = NO;
    MJWeakSelf
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.selectAddressView.view.alpha = 0;
        [weakSelf.selectAddressView.view setFrame:CGRectMake(0, ScreenHeight - height + SafeAreaBottomHeight, ScreenWidth, height)];
    }];
}
-(void)confirmselect{
    [self.addressView.fromAddressTextField setText:self.selectAddressView.selectedwallet.address];
    self.wallet = self.selectAddressView.selectedwallet;
    [self hideSelectView];
    self.MISbalance = 0;
    self.btcbalance = 0;
    self.ETHbalance = 0;
    self.EOSbalance = 0;
    self.usdtbalance = 0;
    if (_wallet.coinType == MGP) {
        [self.amountView.balancelb setText:[NSString stringWithFormat:@"%@：%.6f MGP", NSLocalizedString(@"余额", nil),self.MISbalance]];
    }else if (_wallet.coinType == EOS){
        [self.amountView.balancelb setText:[NSString stringWithFormat:@"%@：%.6f EOS", NSLocalizedString(@"余额", nil),self.EOSbalance]];
    }else if (_wallet.coinType == BTC  || _wallet.coinType == BTC_TESTNET){
        [self.amountView.balancelb setText:[NSString stringWithFormat:@"%@：%.6f BTC", NSLocalizedString(@"余额", nil),self.btcbalance]];
    }else if (_wallet.coinType == ETH){
        [self.amountView.balancelb setText:[NSString stringWithFormat:@"%@：0.000000f ETH", NSLocalizedString(@"余额", nil)]];
    }else if (_wallet.coinType == USDT){
        [self.amountView.balancelb setText:[NSString stringWithFormat:@"%@：%.8f USDT", NSLocalizedString(@"余额", nil),self.usdtbalance]];
    }
    MJWeakSelf
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [weakSelf requestData];
        sleep(3);
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf loadDataToView];
        });
    });
}


-(SelectWalletView *)selectAddressView{
    CGFloat height = self.sameCoinTypeWallets.count * 50 + 50;
    if (!_selectAddressView) {
        _selectAddressView = [SelectWalletView new];
        _selectAddressView.selectwalletArray = [self.sameCoinTypeWallets mutableCopy];
        _selectAddressView.selectedwallet = self.wallet;
        _selectAddressView.view.layer.shadowColor = [UIColor grayColor].CGColor;
        _selectAddressView.view.layer.shadowOffset = CGSizeMake(2, 5);
        _selectAddressView.view.alpha = 0.01;
        [_selectAddressView.cofirmBtn addTarget:self action:@selector(confirmselect) forControlEvents:UIControlEventTouchUpInside];
        [_selectAddressView.cancelBtn addTarget:self action:@selector(hideSelectView) forControlEvents:UIControlEventTouchUpInside];
        [self addChildViewController:_selectAddressView];
        [self.view addSubview:_selectAddressView.view];
        [_selectAddressView.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.bottom.equalTo(height - SafeAreaBottomHeight);
            make.height.equalTo(height);
            make.width.equalTo(ScreenWidth);
        }];
    }
    return _selectAddressView;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
//    self.navigationController.navigationBar.hidden = YES;
//    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
//    self.navigationController.hidesBottomBarWhenPushed = YES;
//    self.tabBarController.tabBar.hidden = YES;
    [self.addressView.toAddressTextField setPlaceholder:NSLocalizedString(@"请输入有效的接收帐户", nil)];
    if (self.toAddress != nil && ![self.toAddress isEqualToString:@""]) {
        [self.addressView.toAddressTextField setText:self.toAddress];
    }
    [self selectAddressView];
    
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
    if (self.wallet.coinType == USDT) {
        NSMutableArray *arrcopy = [NSMutableArray new];
        arrcopy = [[CreateAll GetWalletArrayByCoinType:BTC] mutableCopy];
        self.sameCoinTypeWallets = [NSMutableArray new];
        for (MissionWallet *wallet in arrcopy) {
            wallet.coinType = USDT;
            [self.sameCoinTypeWallets addObject:wallet];
        }
    }else{
        self.sameCoinTypeWallets = [[CreateAll GetWalletArrayByCoinType:self.wallet.coinType] mutableCopy];
    }
    
    
    
    MJWeakSelf
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [weakSelf requestData];
        sleep(3);
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf loadDataToView];
            if(weakSelf.wallet.coinType == USDT || weakSelf.wallet.coinType == BTC){
                weakSelf.satPerBit = 40;
                [weakSelf.gasView.gasSlider setValue:weakSelf.satPerBit];
                [weakSelf.gasView.gaspricelb setText:[NSString stringWithFormat:@"%ld sat/b",weakSelf.satPerBit]];
            }
        });
    });
    self.view.backgroundColor = [UIColor ExportBackgroundColor];
//    [self initHeadView];
    self.title = NSLocalizedString(@"转账", nil);
    [self initUI];
    
    _transactionBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    _transactionBtn.titleLabel.textColor = [UIColor whiteColor];
    _transactionBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _transactionBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    _transactionBtn.userInteractionEnabled = YES;
    if (self.wallet.coinType == MGP || self.wallet.coinType == EOS) {
        [_transactionBtn setTitle:NSLocalizedString(@"下一步", nil) forState:UIControlStateNormal];
        [_transactionBtn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    }else if(self.wallet.coinType == BTC  || self.wallet.coinType == BTC_TESTNET || self.wallet.coinType == ETH || self.wallet.coinType == USDT){
        [_transactionBtn setTitle:NSLocalizedString(@"转账", nil) forState:UIControlStateNormal];
        [_transactionBtn addTarget:self action:@selector(transactionAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [_transactionBtn gradientButtonWithSize:CGSizeMake(ScreenWidth, 44) colorArray:@[[UIColor colorWithHexString:@"#4090F7"],[UIColor colorWithHexString:@"#57A8FF"]] percentageArray:@[@(0.3),@(1)] gradientType:GradientFromLeftTopToRightBottom];
    
    [self.view addSubview:_transactionBtn];
    [_transactionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.bottom.equalTo(-SafeAreaBottomHeight);
        make.height.equalTo(44);
    }];
}
//
-(void)nextAction{
    NSString *amount = self.amountView.amountTextField.text;
    if ([self checkAmount] == NO) {
        [self.view showMsg:NSLocalizedString(@"转账金额错误！", nil)];
        return;
    }
    if ([self.addressView.toAddressTextField.text isEqualToString:@""]) {
        [self.view showMsg:NSLocalizedString(@"请填写转账地址！", nil)];
        return;
    }
    if ([self.addressView.toAddressTextField.text isEqualToString:self.addressView.fromAddressTextField.text]) {
        [self.view showMsg:NSLocalizedString(@"不能给自己转账！", nil)];
        return;
    }
    if (!_dimview) {
        _dimview = [UIView new];
        _dimview.backgroundColor = [UIColor grayColor];
        [self.view addSubview:_dimview];
    }
//    _dimview.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 400);
    _dimview.alpha = 0;
    
    
    if (!_deview) {
        _deview = [EOSTranDetailView new];
        _deview.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_deview];
    }
    self.deview.alpha = 0;
    _deview.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 400);
    [_deview.titlelb setText:NSLocalizedString(@"支付详情", nil)];
    if (_wallet.coinType == MGP) {
        [_deview.amountlb setText:[NSString stringWithFormat:@"%.4f MGP",amount.doubleValue]];
        [_deview.infolb setText: [NSString stringWithFormat:@"MGP%@",NSLocalizedString(@"转账", nil)]];
    }else if (_wallet.coinType == EOS){
        [_deview.amountlb setText:[NSString stringWithFormat:@"%.4f EOS",amount.doubleValue]];
        [_deview.infolb setText: [NSString stringWithFormat:@"EOS%@",NSLocalizedString(@"转账", nil)]];
    }else if (_wallet.coinType == BTC  || _wallet.coinType == BTC_TESTNET){
        [_deview.amountlb setText:[NSString stringWithFormat:@"%.6f BTC",amount.doubleValue]];
        [_deview.infolb setText: [NSString stringWithFormat:@"BTC%@",NSLocalizedString(@"转账", nil)]];
    }else if (_wallet.coinType == ETH){
        [_deview.amountlb setText:[NSString stringWithFormat:@"%.6f ETH",amount.doubleValue]];
        [_deview.infolb setText: [NSString stringWithFormat:@"ETH%@",NSLocalizedString(@"转账", nil)]];
    }else if (_wallet.coinType == USDT){
        [_deview.amountlb setText:[NSString stringWithFormat:@"%.8f USDT",amount.doubleValue]];
        [_deview.infolb setText: [NSString stringWithFormat:@"USDT%@",NSLocalizedString(@"转账", nil)]];
    }
    _deview.userInteractionEnabled = YES;
    [_deview.tolb setText:self.addressView.toAddressTextField.text];
    [_deview.fromlb setText:_wallet.address];
    [_deview.closeBtn addTarget:self action:@selector(closeEOStranView) forControlEvents:UIControlEventTouchUpInside];
    [_deview.nextBtn addTarget:self action:@selector(nextEOStranView) forControlEvents:UIControlEventTouchUpInside];
    MJWeakSelf
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.dimview.alpha = 0.7;
        weakSelf.deview.alpha = 1;
        weakSelf.deview.frame = CGRectMake(0, self.view.frame.size.height - 400, ScreenWidth, 400);
    }];
}
//关闭交易信息页
-(void)closeEOStranView{
    MJWeakSelf
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.deview.frame = CGRectMake(0, ScreenHeight + SafeAreaBottomHeight, ScreenWidth, 400);
        weakSelf.deview.alpha = 0;
        weakSelf.dimview.alpha = 0;
    }];
}
//下一步进入输入密码页
-(void)nextEOStranView{
    if (!_nextview) {
        _nextview = [EOSTranDetailView new];
        _nextview.backgroundColor = [UIColor whiteColor];
        [_nextview.titlelb setText:NSLocalizedString(@"请输入密码", nil)];
        [_nextview.nextBtn setTitle:NSLocalizedString(@"确认", nil) forState:UIControlStateNormal];
        [self.view addSubview:_nextview];
    }
    _nextview.alpha = 1;
    _nextview.frame = CGRectMake(ScreenWidth, self.view.frame.size.height - 400, ScreenWidth, 400);
    [_nextview passTextField];
    [_nextview.closeBtn addTarget:self action:@selector(closeNextView) forControlEvents:UIControlEventTouchUpInside];
    [_nextview.nextBtn addTarget:self action:@selector(eosTransactionMake) forControlEvents:UIControlEventTouchUpInside];
    MJWeakSelf
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.deview.frame = CGRectMake(-ScreenWidth, self.view.frame.size.height - 400, ScreenWidth, 400);
        weakSelf.deview.alpha = 0;
        weakSelf.nextview.frame = CGRectMake(0, self.view.frame.size.height - 400, ScreenWidth, 400);
        weakSelf.nextview.alpha = 1;
    }];
    
}
//关闭输入密码页
-(void)closeNextView{
    MJWeakSelf
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.nextview.frame = CGRectMake(0, ScreenHeight + SafeAreaBottomHeight, ScreenWidth, 400);
        weakSelf.dimview.alpha = 0;
        weakSelf.nextview.alpha = 0;
    }];
}
//btc eth mis eos转账
-(void)eosTransactionMake{
    //eos/mis转账
    //。。。
    self.password = self.nextview.passTextField.text;
    if([self.password isEqualToString:@""] || self.password == nil){
        [self.view showMsg:NSLocalizedString(@"请输入密码！", nil)];
    }else{

        BOOL isRight = [CreateAll VerifyPassword:self.password ForWalletAddress:self.wallet.address];
        if (isRight == NO && _wallet.coinType == EOS && _wallet.walletType == LOCAL_WALLET) {
            isRight = [CreateAll VerifyPassword:self.password ForWalletAddress:@"EOS_Temp"];
            if (isRight == YES) {
                [CreateAll SaveWallet:_wallet Name:_wallet.walletName WalletType:_wallet.walletType Password:self.password];
            }
        }
        if(isRight == YES){
            if (self.wallet.coinType == BTC || self.wallet.coinType == BTC_TESTNET) {
                //解密钱包私钥
                if(![self.wallet.privateKey isValidBitcoinPrivateKey]){
                    NSString *depri = [AESCrypt decrypt:self.wallet.privateKey password:self.password];
                    if (depri != nil && ![depri isEqualToString:@""]) {
                        self.wallet.privateKey = depri;
                        [self transactionBTCToAddress:self.addressView.toAddressTextField.text];
                    }
                }else{
                    [self transactionBTCToAddress:self.addressView.toAddressTextField.text];
                }
            }else if (self.wallet.coinType == ETH){
                if([self.wallet.privateKey containsString:@"0x"]){
                    self.wallet.privateKey = [self.wallet.privateKey substringFromIndex:2];
                }
                BOOL isValid = [CreateAll ValidHexString:self.wallet.privateKey];
                if (isValid == NO) {
                    NSString *depri = [AESCrypt decrypt:self.wallet.privateKey password:self.password];
                    self.wallet.privateKey = depri;
                    if([self.wallet.privateKey containsString:@"0x"]){
                        self.wallet.privateKey = [self.wallet.privateKey substringFromIndex:2];
                    }
                    BOOL isValidde = [CreateAll ValidHexString:self.wallet.privateKey];
                    if (isValidde == YES) {
                        [self transactionETHToAddress:self.addressView.toAddressTextField.text];
                    }else{
                        [self.view showMsg:@"Wallet Error"];
                    }
                }else{
                    [self transactionETHToAddress:self.addressView.toAddressTextField.text];
                }
            }else if (self.wallet.coinType == MIS){
                //解密钱包私钥
                if(![self.wallet.privateKey isValidBitcoinPrivateKey]){
                    NSString *depri = [AESCrypt decrypt:self.wallet.privateKey password:self.password];
                    if (depri != nil && ![depri isEqualToString:@""]) {
                        self.wallet.privateKey = depri;
                        //MIS转账
                        if ([self.wallet.privateKey isValidBitcoinPrivateKey]) {
                            [self transfer];
                        }else{
                            [self.view showMsg:@"Wallet Error"];
                        }
                        
                    }
                }else{
                    [self transfer];
                }
                
            }else if (self.wallet.coinType == EOS){
                //解密钱包私钥
                if(![self.wallet.privateKey isValidBitcoinPrivateKey]){
                    NSString *depri = [AESCrypt decrypt:self.wallet.privateKey password:self.password];
                    if (depri != nil && ![depri isEqualToString:@""]) {
                        self.wallet.privateKey = depri;
                        [self transfer];
                    }else{
                        [self.view showMsg:@"Wallet Error"];
                    }
                }else{
                    [self transfer];
                }
                
            }else if (self.wallet.coinType == MGP){
                //解密钱包私钥
                if(![self.wallet.privateKey isValidBitcoinPrivateKey]){
                    NSString *depri = [AESCrypt decrypt:self.wallet.privateKey password:self.password];
                    if (depri != nil && ![depri isEqualToString:@""]) {
                        self.wallet.privateKey = depri;
                        [self transfer];
                    }else{
                        [self.view showMsg:@"Wallet Error"];
                    }
                }else{
                    [self transfer];
                }
                
            }else if (self.wallet.coinType == USDT) {
                //解密钱包私钥
                if(![self.wallet.privateKey isValidBitcoinPrivateKey]){
                    NSString *depri = [AESCrypt decrypt:self.wallet.privateKey password:self.password];
                    if (depri != nil && ![depri isEqualToString:@""]) {
                        self.wallet.privateKey = depri;
                        [self transactionUSDTToAddress:self.addressView.toAddressTextField.text];
                    }
                }else{
                    [self transactionUSDTToAddress:self.addressView.toAddressTextField.text];
                }
            }
        }else{
            [self.view showMsg:NSLocalizedString(@"密码错误！", nil)];
        }
    }
    
}
-(void)transactionAction{
    //如果超额
    if ([self checkAmount] == NO) {
        [self.view showMsg:NSLocalizedString(@"转账金额错误！", nil)];
        return;
    }
    if ([self.addressView.toAddressTextField.text isEqualToString:@""]) {
        [self.view showMsg:NSLocalizedString(@"请填写转账地址！", nil)];
        return;
    }
    if (self.wallet.coinType == MGP || self.wallet.coinType == EOS) {
        if ([self.addressView.toAddressTextField.text isEqualToString:self.addressView.fromAddressTextField.text]) {
            [self.view showMsg:NSLocalizedString(@"不能给自己转账！", nil)];
            return;
        }
    }
    [self nextAction];
}

//检查金额？
-(void)transactionBTCToAddress:(NSString *)address{
    __block MissionWallet *walletBTC = self.wallet;
    NSString *amount = self.amountView.amountTextField.text;
    BTCAmount amountvalue = amount.doubleValue * pow(10,8);
    BTCAmount fee = self.satPerBit;
    [self.view showHUD];
    //BTCAPIChain
    MJWeakSelf
    [CreateAll BTCTransactionFromWallet:walletBTC ToAddress:address Amount:amountvalue
                                    Fee:fee Api:BTCAPIChain Password:self.password callback:^(NSString *result, NSError *error) {
                                       // [self.view hideHUD];
                                        if (result == nil) {
                                            [weakSelf.view showAlert:[NSString stringWithFormat:@"error:%ld",error.code] DetailMsg:error.localizedDescription];
                                        }else{
                                            [weakSelf.view showMsg:NSLocalizedString(@"交易已广播", nil)];
                                            //Poundage为估算值
                                            /*[NetManager AddTradeWithuserName:[CreateAll GetCurrentUserName] TradeAmount:weakSelf.amountView.amountTextField.text.doubleValue Poundage:fee*300.0/pow(10,8) CoinCode:@"BTC" From:weakSelf.addressView.fromAddressTextField.text To:weakSelf.addressView.toAddressTextField.text CompletionHandler:^(id responseObj, NSError *error) {
                                                if (!error) {
                                                    if (![[NSString stringWithFormat:@"%@",responseObj[@"resultCode"]] isEqualToString:@"20000"]) {
                                                        //[weakSelf.view showAlert:[NSString stringWithFormat:@"Error:%ld",error.code] DetailMsg:responseObj[@"resultMsg"]];
                                                        return ;
                                                    }

                                                }else{
                                                   // [weakSelf.view showAlert:[NSString stringWithFormat:@"Error:%ld",error.code] DetailMsg:error.localizedDescription];
                                                }
                                            }];*/
                                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                [weakSelf.navigationController popViewControllerAnimated:YES];
                                            });
                                        }
                                        [weakSelf closeNextView];
                                    }];

}

-(void)transactionUSDTToAddress:(NSString *)address{
    /*
     test usdt
     */
    __block MissionWallet *walletBTC = self.wallet;
    NSString *amount = self.amountView.amountTextField.text;
    BTCAmount amountvalue = amount.doubleValue;
    BTCAmount fee = self.satPerBit;
    [self.view showHUD];
    MJWeakSelf
    [CreateAll USDTTransactionFromWallet:walletBTC ToAddress:address Amount:amountvalue Fee:fee Api:BTCAPIChain  Password:self.password callback:^(NSString *result, NSError *error) {
        // [self.view hideHUD];
        if (result == nil) {
            [weakSelf.view showAlert:[NSString stringWithFormat:@"error:%ld",error.code] DetailMsg:error.localizedDescription];
        }else{
            [weakSelf.view showMsg:NSLocalizedString(@"交易已广播", nil)];
            //Poundage为估算值
            [NetManager AddTradeWithuserName:[CreateAll GetCurrentUserName] TradeAmount:weakSelf.amountView.amountTextField.text.doubleValue Poundage:fee*300.0/pow(10,8) CoinCode:@"BTC" From:weakSelf.addressView.fromAddressTextField.text To:weakSelf.addressView.toAddressTextField.text CompletionHandler:^(id responseObj, NSError *error) {
                if (!error) {
                    if (![[NSString stringWithFormat:@"%@",responseObj[@"resultCode"]] isEqualToString:@"20000"]) {
                        //[weakSelf.view showAlert:[NSString stringWithFormat:@"Error:%ld",error.code] DetailMsg:responseObj[@"resultMsg"]];
                        return ;
                    }
                    
                }else{
                    // [weakSelf.view showAlert:[NSString stringWithFormat:@"Error:%ld",error.code] DetailMsg:error.localizedDescription];
                }
            }];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        }
        [weakSelf closeNextView];
    }];
}


-(void)transactionETHToAddress:(NSString *)address{
    __block MissionWallet *walletETH = self.wallet;
    NSString *amount = self.amountView.amountTextField.text;
    __block BigNumber *value = [BigNumber bigNumberWithDecimalString:[NSString stringWithFormat:@"%ld",(NSInteger)(amount.doubleValue * pow(10,18))]];
    [self.view showHUD];
    MJWeakSelf
    [CreateAll CreateETHTransactionFromWallet:walletETH ToAddress:address Value:value callback:^(Transaction *transactionresult) {
        __block Transaction *transaction = transactionresult;
        if (transaction) {
            //获取eth余额
            [CreateAll GetBalanceETHForWallet:walletETH callback:^(BigNumber *balance) {
                transaction.value = value;
                NSLog(@"value = %@ bal = %@",value,balance);
                //相当于单价wei/gas
                CGFloat gwei = weakSelf.gasView.gasSlider.value;
                NSInteger gasvalue = (NSInteger)(gwei * pow(10, 9));
                BigNumber *gasbignumber = [BigNumber bigNumberWithDecimalString:[NSString stringWithFormat:@"%ld",gasvalue]];
                [CreateAll ETHTransaction:transaction Wallet:walletETH GasPrice:gasbignumber GasLimit:weakSelf.GasLimit tokenETH:nil callback:^(HashPromise *promise) {
                    [weakSelf.view hideHUD];
                    if (promise.error) {
                        if ([promise.error.userInfo containsObjectForKey:@"response"]) {
                            NSString *responsedata = promise.error.userInfo[@"response"];
                            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responsedata.dataValue options:kNilOptions error:nil];
                            if ([response containsObjectForKey:@"error"]) {
                                NSDictionary *err = response[@"error"];
                                if ([err containsObjectForKey:@"message"]) {
                                    [weakSelf.view showAlert:@"error!" DetailMsg:err[@"message"]];
                                }
                            }
                        } 
                    }else{
                        if ([promise.value isEqual:[NSNull null]]) {
                            [weakSelf.view showMsg:NSLocalizedString(@"交易创建失败！", nil)];
                            return ;
                        }
                        //存储刚广播的交易id，用于显示在交易列表
                        [CreateAll SaveETHTxHash:promise.value.hexString ForAddr:walletETH.address];
                        [weakSelf.view showMsg:NSLocalizedString(@"交易已广播", nil)];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [weakSelf.navigationController popViewControllerAnimated:YES];
                        });
                    }
                    [weakSelf closeNextView];
                    
                    NSLog(@"result = %@",promise.value);
                }];
               
            }];
        }else{
            [weakSelf.view showMsg:NSLocalizedString(@"交易创建失败！", nil)];
        }
    }];
}


-(BOOL)checkAmount{
    
    NSString *amount = self.amountView.amountTextField.text;
    if (amount == nil ||[amount isEqualToString:@""]) {
        return NO;
    }
    if (self.wallet.coinType == BTC || self.wallet.coinType == BTC_TESTNET) {
        //转账金额不能大于余额+最低手续费
        [self.transactionBtn setEnabled:YES];
        return YES;
        if (amount.doubleValue > self.btcbalance) {
            [self.transactionBtn setEnabled:NO];
            return NO;
        }else{
            [self.transactionBtn setEnabled:YES];
            return YES;
        }
    }else if (self.wallet.coinType == ETH){
        //不能过大
        CGFloat gwei = self.gasView.gasSlider.value;
        CGFloat gasvalue = (gwei * self.GasLimit.unsignedIntegerValue)*1.0/pow(10,9);
        if ((amount.doubleValue >= (self.ETHbalance.unsignedIntegerValue*1.0/pow(10,18) - gasvalue))) {
            
            [self.transactionBtn setEnabled:NO];
            return NO;
        }else{
            [self.transactionBtn setEnabled:YES];
            return YES;
        }
    }else if (self.wallet.coinType == MGP){
        if (amount.doubleValue > self.MISbalance) {
            return NO;
        }
        return YES;
    }else if (self.wallet.coinType == EOS){
        if (amount.doubleValue > self.EOSbalance) {
            return NO;
        }
        return YES;
    }else if (self.wallet.coinType == USDT){
        //转账金额不能大于余额+最低手续费
        if (amount.doubleValue > self.usdtbalance) {
            [self.transactionBtn setEnabled:NO];
            return NO;
        }else{
            [self.transactionBtn setEnabled:YES];
            return YES;
        }
    }
    return NO;
}



//查询余额
-(void)requestData{
    MJWeakSelf
    if (self.wallet.coinType == BTC || self.wallet.coinType == BTC_TESTNET) {
        //余额
        NSString *addr;
        if (self.wallet.changeAddressArray != nil && self.wallet.changeAddressArray.count > 0) {
            addr = [self.wallet.changeAddressStr stringByReplacingOccurrencesOfString:@"," withString:@"|"];
        }else{
            addr = self.wallet.address;
        }
        self.btcUnconfirmedbalance = 0;
        
        [NetManager GetBTCTxFromBlockChainAddress:addr PageSize:20 Offset:0 completionHandler:^(id responseObj, NSError *error) {
            if (error) {
                
            }else{
                if (responseObj) {
                    BTCBlockChainListModel *model = [BTCBlockChainListModel parse:responseObj];
                    NSArray *txsarr = responseObj[@"txs"];
                    NSInteger result = 0;
                    for (NSInteger index = 0; index < txsarr.count && index < model.txs.count; index++) {
                        Tx *tx = model.txs[index];
                        NSDictionary *txdic = txsarr[index];
                        tx.hashs = (NSString *)(txdic[@"hash"]);
                        tx.outputs = [Output parse:txdic[@"out"] ];
                        
                        if (tx.block_height <= 0 && tx.result<0) {//转出未确认
                            result += tx.result;
                        }
                    }
                    weakSelf.btcUnconfirmedbalance = (-result* 1.0/pow(10, 8));
                    dispatch_async_on_main_queue(^{
                        [weakSelf loadDataToView];
                    });
                }
            }
        }];
        [NetManager GetBTCUTXOFromBlockChainAddress:addr MinumConfirmations:-1 completionHandler:^(id responseObj, NSError *error) {
            if (!error) {
                if (!responseObj) {
                    return ;
                }
                NSArray *utxoarr = [BTCBlockChainUTXOModel parse:responseObj[@"unspent_outputs"]];
                CGFloat amount = 0;
                for (BTCBlockChainUTXOModel *model in utxoarr) {
//                    if(model.tx_output_n == 0 && model.confirmations <1){//转入未确认
//                        amount += model.value * 1.0/pow(10, 8);//gai
//                    }else if(model.tx_output_n == 0 && model.confirmations >=1){//转入 确认>1
//                        amount += model.value * 1.0/pow(10, 8);
//                    }else if(model.tx_output_n > 0 && model.confirmations <1){//转出未确认
//                        amount += model.value * 1.0/pow(10, 8);
//                    }else if(model.tx_output_n > 0 && model.confirmations >=1){//转出 确认>=1
//                        amount += model.value * 1.0/pow(10, 8);
//                    }
                    amount += model.value * 1.0/pow(10, 8);
                }
                weakSelf.btcbalance = amount;
                dispatch_async_on_main_queue(^{
                    [weakSelf loadDataToView];
                });
            }else{
                
            }
        }];
        

        //btc 美元汇率
        [NetManager GetCurrencyCompletionHandler:^(id responseObj, NSError *error) {
            if (!error) {
                NSDictionary *dic;
                if ([responseObj containsObjectForKey:@"data"]) {
                     dic = responseObj[@"data"];
                    if ([dic containsObjectForKey:@"bitstamp"]) {
                        weakSelf.BTCCurrency = ((NSString *)[dic objectForKey:@"bitstamp"]).doubleValue;
                        dispatch_async_on_main_queue(^{
                             [weakSelf loadDataToView];
                        });
                    }
                }
            }
        }];
        self.satPerBit = 35;
    }else if (self.wallet.coinType == ETH){
        
        [CreateAll GetBalanceETHForWallet:self.wallet callback:^(BigNumber *balance) {
            weakSelf.ETHbalance = balance;
            BigNumber *valuenumber =  [balance div:[BigNumber bigNumberWithInteger:4]];
            [CreateAll CreateETHTransactionFromWallet:weakSelf.wallet ToAddress:weakSelf.wallet.address Value:valuenumber callback:^(Transaction *transaction) {
                [CreateAll GetGasLimitPriceForTransaction:transaction callback:^(BigNumber *gasLimitPrice) {
                    weakSelf.GasLimit = gasLimitPrice;
                    dispatch_async_on_main_queue(^{
                        [weakSelf loadDataToView];
                    });
                }];
            }];
        }];
       
//        [CreateAll GetETHCurrencyCallback:^(FloatPromise *etherprice) {
//            weakSelf.ETHCurrency = etherprice.value;
//        }];
        [[MGPHttpRequest shareManager]post:@"/api/coinPrice" paramters:@{@"pair":@"ETH_USDT"} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {

            if ([responseObj[@"code"]intValue] == 0) {
                weakSelf.ETHCurrency = ((NSString *)VALIDATE_STRING([responseObj[@"data"]objectForKey:@"price"])).floatValue;
            }
                                    
        }];
        [CreateAll GetGasPriceCallback:^(BigNumberPromise *gasPrice) {
//            NSString *balance = [Payment formatEther:gasPrice.value
//            options:(EtherFormatOptionCommify | EtherFormatOptionApproximate)];
            CGFloat gasprice = [gasPrice.value unsignedIntegerValue] * 1.3/pow(10,9);
            weakSelf.currentgasprice = gasprice;
            [weakSelf.gasView.gasSlider setValue:gasprice];
            [weakSelf sliderValueChanged:weakSelf.gasView.gasSlider];
            
        }];
        
        /*
        [NetManager GetETHGasPriceCompletionHandler:^(id responseObj, NSError *error) {
            if (!error) {
                if (responseObj == nil) {
                    return ;
                }
                NSString *ddd = responseObj[@"result"];
                if([ddd isEqual:[NSNull null]] || ddd == nil){
                    return;
                }else{
                    NSInteger price = strtoul([ddd UTF8String],0, 16);
                    CGFloat gasprice = price * 1.3/ pow(10, 9);
                    dispatch_async_on_main_queue(^{
                        weakSelf.currentgasprice = gasprice;
                        [weakSelf.gasView.gasSlider setValue:gasprice];
                        [weakSelf sliderValueChanged:weakSelf.gasView.gasSlider];
                    });
                }
            }else{
                [weakSelf.view showAlert:[NSString stringWithFormat:@"Error:%ld",error.code] DetailMsg:error.localizedDescription];
            }
        }];*/
        
    }else if (self.wallet.coinType == MIS){
        [self getAccountSuccess:^(id response) {
            NSLog(@"account %@",response);
            NSMutableDictionary *dic = response;
            if (dic) {
                NSString *balancestr = [dic objectForKey:@"core_liquid_balance"];
                NSString *valuestring = [balancestr componentsSeparatedByString:@" "].firstObject;
                CGFloat balance = valuestring.doubleValue;
                weakSelf.MISbalance = balance;
                weakSelf.MISCurrency = ![[NSUserDefaults standardUserDefaults] floatForKey:@"MISCurrency"]?0:[[NSUserDefaults standardUserDefaults] floatForKey:@"MISCurrency"];
                NSLog(@"mis blance = %.4f",balance);
                dispatch_async_on_main_queue(^{
                    [weakSelf loadDataToView];
                });
            }
        }];

    }else if (self.wallet.coinType == EOS){
        [self getEOSAccount:self.wallet.address Success:^(id response) {
            NSMutableDictionary *dic = response;
            if (dic) {
                NSString *balancestr = [dic objectForKey:@"core_liquid_balance"];
                NSString *valuestring = [balancestr componentsSeparatedByString:@" "].firstObject;
                CGFloat balance = valuestring.doubleValue;
                weakSelf.EOSbalance = balance;
//                weakSelf.EOSCurrency = ![[NSUserDefaults standardUserDefaults] floatForKey:@"EOSCurrency"]?0:[[NSUserDefaults standardUserDefaults] floatForKey:@"EOSCurrency"];
                [[MGPHttpRequest shareManager]post:@"/api/coinPrice" paramters:@{@"pair":@"EOS_USDT"} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {

                    if ([responseObj[@"code"]intValue] == 0) {
                        self.EOSCurrency = ((NSString *)VALIDATE_STRING([responseObj[@"data"]objectForKey:@"price"])).floatValue;
                    }
                                            
                }];
                dispatch_async_on_main_queue(^{
                    [weakSelf loadDataToView];
                });
            }
        }];
    }else if (self.wallet.coinType == MGP){
        [self getMGPAccount:self.wallet.address Success:^(id response) {
            NSMutableDictionary *dic = response;
            if (dic) {
                NSString *balancestr = [dic objectForKey:@"core_liquid_balance"];
                NSString *valuestring = [balancestr componentsSeparatedByString:@" "].firstObject;
                CGFloat balance = valuestring.doubleValue;
                weakSelf.MISbalance = balance;
//                weakSelf.MISCurrency = ![[NSUserDefaults standardUserDefaults] floatForKey:@"MISCurrency"]?0:[[NSUserDefaults standardUserDefaults] floatForKey:@"MISCurrency"];
                [[MGPHttpRequest shareManager]post:@"/api/coinPrice" paramters:@{@"pair":@"MGP_USDT"} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {

                    if ([responseObj[@"code"]intValue] == 0) {
                        self.MISCurrency = ((NSString *)VALIDATE_STRING([responseObj[@"data"]objectForKey:@"price"])).floatValue;
                    }
                                            
                }];
                
                dispatch_async_on_main_queue(^{
                    [weakSelf loadDataToView];
                });
            }
        }];
    }else if (self.wallet.coinType == USDT){

        //***************************usdt只查主地址*****************************
        [NetManager RequestUSDT_BalanceAddress:self.wallet.address CompletionHandler:^(id responseObj, NSError *error) {
            if (!error) {
                if (!responseObj) {
                    return ;
                }
                OmniUSDTBalanceModel *data = [OmniUSDTBalanceModel parse:responseObj];
                for (OmniUSDTBalanceData *balancemodel in data.balance) {
                    if ([balancemodel.symbol isEqualToString:@"SP31"]) {
                        CGFloat balancevalue = balancemodel.value.doubleValue * 1.0/pow(10, 8);
                        weakSelf.usdtbalance = balancevalue;
                    }
                }
                dispatch_async_on_main_queue(^{
                    [weakSelf loadDataToView];
                });
            }
        }];
    }
}

- (void)getEOSAccount:(NSString *)account Success:(void(^)(id response))handler{
    
    NSDictionary *dic = @{@"account_name":account};
    
    [[HTTPRequestManager shareEosManager] post:eos_get_account paramters:dic success:^(BOOL isSuccess, id responseObject) {
        
        if (isSuccess) {
            handler(responseObject);
        }else{
            handler(nil);
        }
    } failure:^(NSError *error) {
        
    } superView:self.view showFaliureDescription:YES];
    
}
- (void)getMGPAccount:(NSString *)account Success:(void(^)(id response))handler{
    
    NSDictionary *dic = @{@"account_name":account};
    
    [[HTTPRequestManager shareMgpManager] post:eos_get_account paramters:dic success:^(BOOL isSuccess, id responseObject) {
        
        if (isSuccess) {
            handler(responseObject);
        }else{
            handler(nil);
        }
    } failure:^(NSError *error) {
        
    } superView:self.view showFaliureDescription:YES];
    
}
-(void)loadDataToView{
    NSString *amount = self.amountView.amountTextField.text;
    if (self.wallet.coinType == BTC || self.wallet.coinType == BTC_TESTNET) {
        [self.amountView.balancelb setText:[NSString stringWithFormat:@"%@：%.8f BTC", NSLocalizedString(@"总", nil),self.btcbalance + self.btcUnconfirmedbalance, NSLocalizedString(@"可用", nil),self.btcbalance]];
        [self.amountView.btcAvailableLb setText:[NSString stringWithFormat:@"%@：%.8f BTC\n%@：%.8f BTC",NSLocalizedString(@"可用", nil),self.btcbalance,NSLocalizedString(@"未确认", nil),self.btcUnconfirmedbalance]];
        [self.amountView.pricelb setText:[NSString stringWithFormat:@"≈$%.2f",amount.doubleValue * self.BTCCurrency]];
        [self.gasView.gaspricelb setText:[NSString stringWithFormat:@"%ld sat/b",self.satPerBit]];
    }else if (self.wallet.coinType == ETH){ 
        CGFloat ethbalance = self.ETHbalance.unsignedIntegerValue*1.0/pow(10,18);
        [self.amountView.balancelb setText:[NSString stringWithFormat:@"%@：%.6f ETH", NSLocalizedString(@"余额", nil),ethbalance]];
        [self.amountView.pricelb setText:[NSString stringWithFormat:@"≈$%.2f ",amount.doubleValue * self.ETHCurrency]];
        //ETH矿工费 = Gas Limit * Gas Price
        self.gasView.gasSlider.value = self.currentgasprice >0?self.currentgasprice : self.gasView.gasSlider.minimumValue;
        CGFloat gwei = self.gasView.gasSlider.value;
        CGFloat gasvalue = (gwei * self.GasLimit.unsignedIntegerValue)*1.0/pow(10,9);
        CGFloat dollarvalue = gasvalue * _ETHCurrency;
        self.RMBDollarCurrency = [[NSUserDefaults standardUserDefaults] floatForKey:@"RMBDollarCurrency"];
        CGFloat rmbvalue = dollarvalue * _RMBDollarCurrency/100.0;
        NSLog(@"gwei = %lf    GasPrice = %ld",gwei,self.GasLimit.unsignedIntegerValue);
        NSString *unitstr = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentCurrencySelected"];
        [self.gasView.gaspricelb setText:[NSString stringWithFormat:@"%.4f ether ≈ %@%.4f",gasvalue,[unitstr isEqualToString:@"rmb"]?@"¥":@"$",[unitstr isEqualToString:@"rmb"]?rmbvalue:dollarvalue]];
    }else if (self.wallet.coinType == MGP){
        [self.amountView.balancelb setText:[NSString stringWithFormat:@"%@：%.4f MGP", NSLocalizedString(@"余额", nil),self.MISbalance]];
//        [self.amountView.pricelb setText:[NSString stringWithFormat:@"≈$%.2f ",self.MISbalance * self.MISCurrency]];
        
    }else if (self.wallet.coinType == EOS){
        [self.amountView.balancelb setText:[NSString stringWithFormat:@"%@：%.4f EOS", NSLocalizedString(@"余额", nil),self.EOSbalance]];
//        [self.amountView.pricelb setText:[NSString stringWithFormat:@"≈$%.2f ",self.EOSbalance * self.EOSCurrency]];
    }else if (self.wallet.coinType == USDT){
        [self.amountView.balancelb setText:[NSString stringWithFormat:@"%@：%.8f USDT", NSLocalizedString(@"余额", nil),self.usdtbalance]];
        [self.amountView.pricelb setText:[NSString stringWithFormat:@"≈$%.2f ",self.usdtbalance]];
    }
   
}


-(void)sliderValueChanged:(UISlider *)sender{
    if (self.wallet.coinType == BTC || self.wallet.coinType == BTC_TESTNET || self.wallet.coinType == USDT) {
//        if (sender.value >= 40) {
//            [sender setValue:sender.maximumValue];
//            self.satPerBit = 45;
//        }else{
//            [sender setValue:sender.minimumValue];
//            self.satPerBit = 35;
//        }
        self.satPerBit = sender.value;
        [self.gasView.gaspricelb setText:[NSString stringWithFormat:@"%ld sat/b",self.satPerBit]];
    }else if (self.wallet.coinType == ETH){
        CGFloat gwei = sender.value;
        CGFloat gasvalue = (gwei * self.GasLimit.unsignedIntegerValue)*1.0/pow(10,9);
        CGFloat dollarvalue = gasvalue * _ETHCurrency;
        CGFloat rmbvalue = dollarvalue * _RMBDollarCurrency/100.0;
        NSString *unitstr = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentCurrencySelected"];
        [self.gasView.gaspricelb setText:[NSString stringWithFormat:@"%.4f ether ≈ %@%.4f",gasvalue,[unitstr isEqualToString:@"rmb"]?@"¥":@"$",[unitstr isEqualToString:@"rmb"]?rmbvalue:dollarvalue]];
        [self.gasView updateLabelValues:gwei];
        NSString *amount = self.amountView.amountTextField.text;
        if (amount != nil && ![amount isEqualToString:@""]) {
            if ((amount.doubleValue >= (self.ETHbalance.unsignedIntegerValue*1.0/pow(10,18) - gasvalue))) {
                [self.transactionBtn setEnabled:NO];
            }else{
                [self.transactionBtn setEnabled:YES];
            }
        }
       
    }
   
}
- (void)textFieldDidChange{
    NSString *amount = self.amountView.amountTextField.text;
    if (self.wallet.coinType == BTC || self.wallet.coinType == BTC_TESTNET ) {
         [self.amountView.pricelb setText:[NSString stringWithFormat:@"≈$%.2f",amount.doubleValue * self.BTCCurrency]];
        
        //转账金额不能大于余额+最低手续费
        if (amount.doubleValue > self.btcbalance) {
            [self.transactionBtn setEnabled:NO];
        }else{
            [self.transactionBtn setEnabled:YES];
        }
        [self.transactionBtn setEnabled:YES];
    }else if (self.wallet.coinType == ETH){
        [self.amountView.pricelb setText:[NSString stringWithFormat:@"≈$%.2f",amount.doubleValue * self.ETHCurrency]];
        CGFloat gwei = self.gasView.gasSlider.value;
        CGFloat gasvalue = (gwei * self.GasLimit.unsignedIntegerValue)*1.0/pow(10,9);
        if (amount.doubleValue > self.ETHbalance.unsignedIntegerValue*1.0/pow(10,18) - gasvalue) {
            [self.transactionBtn setEnabled:NO];
        }else{
            [self.transactionBtn setEnabled:YES];
        }
    }else if (self.wallet.coinType == USDT){
        [self.amountView.pricelb setText:[NSString stringWithFormat:@"≈$%.2f",amount.doubleValue]];
        //转账金额不能大于余额+最低手续费
        if (amount.doubleValue > self.usdtbalance) {
            [self.transactionBtn setEnabled:NO];
        }else{
            [self.transactionBtn setEnabled:YES];
        }
    }else if (self.wallet.coinType == EOS){
        [self.amountView.pricelb setText:[NSString stringWithFormat:@"≈$%.2f ",amount.doubleValue * self.EOSCurrency]];
        //转账金额不能大于余额
        if (amount.doubleValue > self.EOSbalance) {
            [self.transactionBtn setEnabled:NO];
        }else{
            [self.transactionBtn setEnabled:YES];
        }
    }else if (self.wallet.coinType == MGP){
        [self.amountView.pricelb setText:[NSString stringWithFormat:@"≈$%.2f",amount.doubleValue * self.MISCurrency]];
        //转账金额不能大于余额
        if (amount.doubleValue > self.MISbalance) {
            [self.transactionBtn setEnabled:NO];
        }else{
            [self.transactionBtn setEnabled:YES];
        }
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
    [_titleLabel setText:[NSString stringWithFormat:NSLocalizedString(@"转账", nil)]];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
//    [self.view addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(SafeAreaTopHeight - 31);
        make.left.equalTo(45);
        make.width.equalTo(200);
        make.height.equalTo(20);
    }];
    
    
}

-(void)initUI{
    _scanBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    [_scanBtn setBackgroundImage:[UIImage imageNamed:@"wallet_scan"] forState:UIControlStateNormal];
    [_scanBtn addTarget:self action:@selector(scanBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_scanBtn];

    
    _amountView = [TransactionAmountView new];
    [_amountView initUI];
    switch (self.wallet.coinType) {
        case BTC:
            _amountView.namelb.text = @"BTC";
            break;
        case BTC_TESTNET:
            _amountView.namelb.text = @"BTC_TESTNET";
            break;
        case ETH:
            _amountView.namelb.text = @"ETH";
            break;
        case MGP:
            _amountView.namelb.text = @"MGP";
            _amountView.remarkTextField.hidden = NO;
            break;
        case EOS:
            _amountView.namelb.text = @"EOS";
            _amountView.remarkTextField.hidden = NO;
            break;
        case USDT:
            _amountView.namelb.text = @"USDT";
            break;
        default:
            _amountView.namelb.text = @"unknown Wallet coinType";
            break;
    }
    [_amountView.amountTextField addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_amountView];
    [_amountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(6);
        make.left.right.equalTo(0);
        make.height.equalTo(110);
    }];
    
    _addressView = [TransactionAddressView new];
    [_addressView initUI];
    _addressView.selectWalletBtn.tag = 5500;
    [_addressView.selectWalletBtn addTarget:self action:@selector(selectWallet:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_addressView];
    [_addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.amountView.mas_bottom).equalTo(10);
        make.left.right.equalTo(0);
        make.height.equalTo(110);
    }];
    
    
    [_addressView.fromAddressTextField setText:self.wallet.address];
    if (self.wallet.coinType == MGP || self.wallet.coinType == EOS) {

    }else if(self.wallet.coinType == BTC  || self.wallet.coinType == BTC_TESTNET || self.wallet.coinType == ETH || self.wallet.coinType == USDT){
        _gasView = [TransactionGasView new];
        [_gasView initUI];
        [_gasView.gasSlider setValue:-1];
        [self.view addSubview:_gasView];
        [_gasView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.addressView.mas_bottom).equalTo(10);
            make.left.right.equalTo(0);
            make.height.equalTo(150);
        }];
        if (self.wallet.coinType == BTC || self.wallet.coinType == BTC_TESTNET || self.wallet.coinType == USDT) {
            _gasView.gasSlider.maximumValue = BTCMaximumValue;
            _gasView.gasSlider.minimumValue = BTCMinimumValue;
//            [_gasView customBtcFeeTextField];
        }else if (self.wallet.coinType == ETH){
            _gasView.gasSlider.maximumValue = ETHMaximumValue;
            _gasView.gasSlider.minimumValue = ETHMinimumValue;
        }
        [_gasView.gasSlider setValue:_gasView.gasSlider.minimumValue];
        [_gasView.gasSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];// 针对值变化添加响应方法
    }
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

//扫描二维码
-(void)scanBtnAction{
    WBQRCodeVC *WBVC = [[WBQRCodeVC alloc] init];
    [self QRCodeScanVC:WBVC];
    MJWeakSelf
    [WBVC setGetQRCodeResult:^(NSString *string) {
        if (weakSelf.wallet.coinType == BTC || weakSelf.wallet.coinType == BTC_TESTNET || weakSelf.wallet.coinType == USDT) {
            if([string isValidBitcoinAddress]){
                [weakSelf.addressView.toAddressTextField setText:string];
            }else{
                [weakSelf.view showMsg:[NSString stringWithFormat:@"%@ BTC %@", NSLocalizedString(@"不是有效的", nil),NSLocalizedString(@"地址", nil)]];
            }
        }else if (weakSelf.wallet.coinType == ETH){
            if([CreateAll ValidHexString:string]){
                [weakSelf.addressView.toAddressTextField setText:string];
            }else{
                [weakSelf.view showMsg:[NSString stringWithFormat:@"%@ ETH %@", NSLocalizedString(@"不是有效的", nil),NSLocalizedString(@"地址", nil)]];
            }
        }else if(weakSelf.wallet.coinType == MGP){
            if ([NSString checkEOSAccount:string]) {
                [weakSelf.addressView.toAddressTextField setText:string];
            }else{
                [weakSelf.view showMsg:[NSString stringWithFormat:@"%@ MGP %@", NSLocalizedString(@"不是有效的", nil),NSLocalizedString(@"地址", nil)]];
            }
           
        }else if(weakSelf.wallet.coinType == EOS){
            if([NSString checkEOSAccount:string]){
                [weakSelf.addressView.toAddressTextField setText:string];
            }else{
                [weakSelf.view showMsg:[NSString stringWithFormat:@"%@ EOS %@", NSLocalizedString(@"不是有效的", nil),NSLocalizedString(@"地址", nil)]];
            }
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
/*
 MIS/EOS转账 *************************************************************************
 */

#pragma mark - transaction

- (void)transfer {
    [self.view showHUD];
    MJWeakSelf
    [self getJson:[self getAbiJsonToBinParamters] Binargs:^(id response) {
        if ([response isKindOfClass:[NSDictionary class]]) {
            NSDictionary *d = (NSDictionary *)response;
            weakSelf.binargs = [d objectForKey:@"binargs"];
            
            [weakSelf getInfoSuccess:^(id response) {
                BlockChain *model = [BlockChain parse:response];// [@"data"]
                weakSelf.expiration = [[[NSDate dateFromString: model.head_block_time] dateByAddingTimeInterval: 30] formatterToISO8601];
                weakSelf.ref_block_num = [NSString stringWithFormat:@"%@",model.head_block_num];
                
                NSString *js = @"function readUint32( tid, data, offset ){var hexNum= data.substring(2*offset+6,2*offset+8)+data.substring(2*offset+4,2*offset+6)+data.substring(2*offset+2,2*offset+4)+data.substring(2*offset,2*offset+2);var ret = parseInt(hexNum,16).toString(10);return(ret)}";
                [weakSelf.context evaluateScript:js];
                JSValue *n = [weakSelf.context[@"readUint32"] callWithArguments:@[@8,VALIDATE_STRING(model.head_block_id) , @8]];
                weakSelf.ref_block_prefix = [n toString];
                weakSelf.chain_Id = [NSData convertHexStrToData:model.chain_id];
                NSLog(@"get_block_info_success:%@, %@---%@-%@", weakSelf.expiration , weakSelf.ref_block_num, weakSelf.ref_block_prefix, weakSelf.chain_Id);
                
                [weakSelf getRequiredPublicKeyRequestOperationSuccess:^(id response) {
                    if ([response isKindOfClass:[NSDictionary class]]) {
                        weakSelf.required_Publickey = response[@"required_keys"][0];
                        [weakSelf pushTransactionRequestOperationSuccess:^(id response) {
                            [weakSelf.view hideHUD];
                            if ([response isKindOfClass:[NSDictionary class]]) {
                                NSMutableDictionary *dic;
                                dic = [response mutableCopy];
                                [weakSelf.view showMsg:NSLocalizedString(@"转账成功", nil)];
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    [weakSelf.navigationController popViewControllerAnimated:YES];
                                });
                                [weakSelf closeNextView];
                            }
                        }];
                    }
                }];
            }];
        }
    }];
}
#pragma bin_to_json
-(void)getBinToJson:(NSString *)datastring Handler:(void(^)(id response))handler{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject: @"eosio.token" forKey:@"code"];
    [params setObject:@"sign" forKey:@"action"];
    [params setObject:datastring forKey:@"binargs"];
    HTTPRequestManager *manager = self.wallet.coinType == EOS ? [HTTPRequestManager shareEosManager] : [HTTPRequestManager shareMgpManager];

    [manager post:eos_abi_bin_to_json paramters:params success:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            handler(responseObject);
        }
    } failure:^(NSError *error) {
        
    } superView:self.view showFaliureDescription:YES];
   
}

#pragma mark - 获取行动代码

- (void)getJson:(NSDictionary *)dic Binargs:(void(^)(id response))handler {
    HTTPRequestManager *manager = self.wallet.coinType == EOS ? [HTTPRequestManager shareEosManager] : [HTTPRequestManager shareMgpManager];

    [manager post:eos_abi_json_to_bin paramters:dic success:^(BOOL isSuccess, id responseObject) {
        
        if (isSuccess) {
            handler(responseObject);
        }
    } failure:^(NSError *error) {
        
    } superView:self.view showFaliureDescription:YES];
   
}

#pragma mark - 获取帐号信息
- (void)getAccountSuccess:(void(^)(id response))handler {
    NSString *account = [self.wallet.walletName componentsSeparatedByString:@"_"].lastObject;
    NSDictionary *dic = @{@"account_name":account};
    MJWeakSelf
    HTTPRequestManager *manager = self.wallet.coinType == EOS ? [HTTPRequestManager shareEosManager] : [HTTPRequestManager shareMgpManager];

    [manager post:eos_get_account paramters:dic success:^(BOOL isSuccess, id responseObject) {
        
        if (isSuccess) {
            handler(responseObject);
            
        }
    } failure:^(NSError *error) {
        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
        NSLog(@"error--%@",serializedData);
        NSDictionary *err = [serializedData objectForKey:@"error"];
        NSArray *detail = [err objectForKey:@"details"];
        NSString *mesg = [[detail[0] objectForKey:@"message"] copy];
        [weakSelf.view showAlert:@"Error" DetailMsg:mesg];
    } superView:weakSelf.view showFaliureDescription:YES];
   
}


#pragma mark - 获取最新区块

- (void)getInfoSuccess:(void(^)(id response))handler {
    HTTPRequestManager *manager = self.wallet.coinType == EOS ? [HTTPRequestManager shareEosManager] : [HTTPRequestManager shareMgpManager];

    [manager post:eos_get_info paramters:nil success:^(BOOL isSuccess, id responseObject) {
        
        if (isSuccess) {
            handler(responseObject);
        }
    } failure:^(NSError *error) {
        
        NSLog(@"URL_GET_INFO_ERROR ==== %@",error.description);
    } superView:self.view showFaliureDescription:YES];
   
}

#pragma mark - 获取公钥

- (void)getRequiredPublicKeyRequestOperationSuccess:(void(^)(id response))handler {
    NSLog(@"URL_GET_REQUIRED_KEYS parameters ============ %@",[[self getPramatersForRequiredKeys] modelToJSONString]);
    HTTPRequestManager *manager = self.wallet.coinType == EOS ? [HTTPRequestManager shareEosManager] : [HTTPRequestManager shareMgpManager];

    [manager post:eos_get_required_keys paramters:[self getPramatersForRequiredKeys] success:^(BOOL isSuccess, id responseObject) {
        
        if (isSuccess) {
            handler(responseObject);
        }
    } failure:^(NSError *error) {
        
        NSLog(@"URL_GET_REQUIRED_KEYS ==== %@",error.description);
    } superView:self.view showFaliureDescription:YES];
   
}

#pragma mark -


- (void)pushTransactionRequestOperationSuccess:(void(^)(id response))handler {
    
   // NSDictionary *transacDic = [self getPramatersForRequiredKeys];
    NSString *wif = self.wallet.privateKey;
    const int8_t *private_key = [[EosEncode getRandomBytesDataWithWif:wif] bytes];
    if (!private_key) {
        return;
    }
    if (![self.wallet.publicKey isEqualToString:self.required_Publickey] && self.wallet.coinType == MIS) {
        [self.view showAlert:NSLocalizedString(@"MIS帐号有误！", nil)  DetailMsg:@"请使用正确的助记词导入账号"];
    }
//    NSLog(@"%@",self.required_Publickey);
//    NSLog(@"getPramatersForRequiredKeys ============= %@",[self getPramatersForSign]);
   

    NSData *d = [EosByteWriter getBytesForSignature:self.chain_Id andParams:[[self getPramatersForRequiredKeys] objectForKey:@"transaction"] andCapacity:255];
    NSString *signatureStr = [EosSignature initWithbytesForSignature:d privateKey:private_key];
    NSString *packed_trxHexStr = [[EosByteWriter getBytesForSignature:nil andParams:[[self getPramatersForRequiredKeys] objectForKey:@"transaction"] andCapacity:512] hexadecimalString];
    
    NSMutableDictionary *pushDic = [NSMutableDictionary dictionary];
    [pushDic setObject:VALIDATE_STRING(packed_trxHexStr) forKey:@"packed_trx"];
    [pushDic setObject:@[signatureStr] forKey:@"signatures"];
    [pushDic setObject:@"none" forKey:@"compression"];
    [pushDic setObject:@"" forKey:@"packed_context_free_data"];
    NSLog(@"push = \n%@",pushDic);
    MJWeakSelf
    HTTPRequestManager *manager = self.wallet.coinType == EOS ? [HTTPRequestManager shareEosManager] : [HTTPRequestManager shareMgpManager];

    [manager post:eos_push_transaction paramters:pushDic success:^(BOOL isSuccess, id responseObject) {
        NSLog(@"tran response %@",responseObject);
        if (isSuccess) {
            [NetManager AddTradeWithuserName:[CreateAll GetCurrentUserName] TradeAmount:weakSelf.amountView.amountTextField.text.doubleValue Poundage:0 CoinCode:@"MGP" From:weakSelf.addressView.fromAddressTextField.text To:weakSelf.addressView.toAddressTextField.text CompletionHandler:^(id responseObj, NSError *error) {
                if (!error) {
                    if (![[NSString stringWithFormat:@"%@",responseObj[@"resultCode"]] isEqualToString:@"20000"]) {
                        // [weakSelf.view showAlert:[NSString stringWithFormat:@"Error:%ld",error.code] DetailMsg:responseObj[@"resultMsg"]];
                        return ;
                    }
                    
                }else{
                    // [weakSelf.view showAlert:[NSString stringWithFormat:@"Error:%ld",error.code] DetailMsg:error.localizedDescription];
                }
            }];
            handler(responseObject);
        }
    } failure:^(NSError *error) {
        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
        NSLog(@"error--%@",serializedData);
        NSDictionary *err = [serializedData objectForKey:@"error"];
        NSArray *detail = [err objectForKey:@"details"];
        NSString *mesg = [[detail[0] objectForKey:@"message"] copy];
        [weakSelf.view showAlert:@"Error" DetailMsg:mesg];
    } superView:self.view showFaliureDescription:YES];
    
    
}

#pragma mark - Get Paramter

- (NSDictionary *)getAbiJsonToBinParamters {
    NSString *amount = self.amountView.amountTextField.text;
    NSString *from = self.addressView.fromAddressTextField.text;
    NSString *to = self.addressView.toAddressTextField.text;
    NSString *memo = self.amountView.remarkTextField.text;
    // 交易JSON序列化
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject: @"eosio.token" forKey:@"code"];
    [params setObject:@"transfer" forKey:@"action"];
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    [args setObject:VALIDATE_STRING(from) forKey:@"from"];
    [args setObject:VALIDATE_STRING(to) forKey:@"to"];
    [args setObject:VALIDATE_STRING(memo) forKey:@"memo"];//备注
    if (self.wallet.coinType == MGP) {
        [args setObject:[NSString stringWithFormat:@"%.4f MGP", amount.doubleValue] forKey:@"quantity"];
    }else{
        [args setObject:[NSString stringWithFormat:@"%.4f EOS", amount.doubleValue] forKey:@"quantity"];
    }
    
    [params setObject:args forKey:@"args"];
    
    return params;
}

- (NSDictionary *)getPramatersForRequiredKeys {
    NSString *from = self.addressView.fromAddressTextField.text;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *transacDic = [NSMutableDictionary dictionary];
    [transacDic setObject:VALIDATE_STRING(self.ref_block_prefix) forKey:@"ref_block_prefix"];
    [transacDic setObject:VALIDATE_STRING(self.ref_block_num) forKey:@"ref_block_num"];
    [transacDic setObject:VALIDATE_STRING(self.expiration) forKey:@"expiration"];
    
    [transacDic setObject:@[] forKey:@"context_free_data"];
    [transacDic setObject:@[] forKey:@"signatures"];
    [transacDic setObject:@[] forKey:@"context_free_actions"];
    [transacDic setObject:@0 forKey:@"delay_sec"];
    [transacDic setObject:@0 forKey:@"max_cpu_usage_ms"];//max_cpu_usage_ms  max_kcpu_usage
    [transacDic setObject:@0 forKey:@"max_net_usage_words"];
    
    
    NSMutableDictionary *actionDict = [NSMutableDictionary dictionary];
    [actionDict setObject:@"eosio.token" forKey:@"account"];
    [actionDict setObject:@"transfer" forKey:@"name"];
    [actionDict setObject:VALIDATE_STRING(self.binargs) forKey:@"data"];
    
    NSMutableDictionary *authorizationDict = [NSMutableDictionary dictionary];
    [authorizationDict setObject:from forKey:@"actor"];
    [authorizationDict setObject:@"active" forKey:@"permission"];
    [actionDict setObject:@[authorizationDict] forKey:@"authorization"];
    [transacDic setObject:@[actionDict] forKey:@"actions"];
    
    [params setObject:transacDic forKey:@"transaction"];
    
    [params setObject:@[self.wallet.publicKey] forKey:@"available_keys"];
    return params;
    
}
- (NSDictionary *)getPramatersForSign {
    NSString *from = self.addressView.fromAddressTextField.text;

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:VALIDATE_STRING(self.ref_block_prefix) forKey:@"ref_block_prefix"];
    [params setObject:VALIDATE_STRING(self.ref_block_num) forKey:@"ref_block_num"];
    [params setObject:VALIDATE_STRING(self.expiration) forKey:@"expiration"];
    
    [params setObject:@[] forKey:@"context_free_data"];
    [params setObject:@[] forKey:@"signatures"];
    [params setObject:@[] forKey:@"context_free_actions"];
    [params setObject:@0 forKey:@"delay_sec"];
    [params setObject:@0 forKey:@"max_cpu_usage_ms"];//max_cpu_usage_ms  max_kcpu_usage
    [params setObject:@0 forKey:@"max_net_usage_words"];
    
    
    NSMutableDictionary *actionDict = [NSMutableDictionary dictionary];
    [actionDict setObject:@"eosio.token" forKey:@"account"];
    [actionDict setObject:@"transfer" forKey:@"name"];
    [actionDict setObject:VALIDATE_STRING(self.binargs) forKey:@"data"];
    
    NSMutableDictionary *authorizationDict = [NSMutableDictionary dictionary];
    [authorizationDict setObject:from forKey:@"actor"];
    [authorizationDict setObject:@"active" forKey:@"permission"];
    [actionDict setObject:@[authorizationDict] forKey:@"authorization"];
    [params setObject:@[actionDict] forKey:@"actions"];
    
    return params;
}

#pragma mark - getter

- (JSContext *)context {
    if (!_context) {
        _context = [[JSContext alloc] init];
    }
    return _context;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
