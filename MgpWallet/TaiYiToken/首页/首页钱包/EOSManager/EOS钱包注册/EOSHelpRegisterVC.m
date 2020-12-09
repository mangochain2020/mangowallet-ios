//
//  EOSHelpRegisterVC.m
//  TaiYiToken
//
//  Created by 张元一 on 2018/12/27.
//  Copyright © 2018 admin. All rights reserved.
//

#import "EOSHelpRegisterVC.h"
#import "EOSHelpRegisterView.h"
#import "InputPasswordView.h"
#import "EOSTranDetailView.h"
#import "BlockChain.h"
@interface EOSHelpRegisterVC ()<UIScrollViewDelegate>
@property(nonatomic,strong)UILabel *titlelabel;
@property(nonatomic,strong)UIButton *backBtn;
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIView *bridgeContentView;
@property(nonatomic,strong)UIButton *operationBtn;

@property(nonatomic,strong)NSMutableArray <MissionWallet *>*eosWalletArray;
@property(nonatomic,strong)MissionWallet *payerEOSWallet;
@property(nonatomic,strong)EOSHelpRegisterView *helpView;

@property(nonatomic,assign)CGFloat requiredTotalEOS;
@property(nonatomic,assign)CGFloat requiredRAMEOS;
@property(nonatomic,assign)CGFloat requiredCPUEOS;
@property(nonatomic,assign)CGFloat requiredNETEOS;

@property(nonatomic,strong)UIView *dimview;
@property(nonatomic,strong)EOSTranDetailView *deview;
@property(nonatomic,strong)EOSTranDetailView *nextview;
@property(nonatomic,copy)NSString *password;

//EOS trans
@property (nonatomic, strong) JSContext *context;
@property(nonatomic,strong)JavascriptWebViewController *jvc;

@property (nonatomic, copy) NSString *ref_block_prefix;
@property (nonatomic, copy) NSString *ref_block_num;
@property (nonatomic, strong) NSData *chain_Id;
@property (nonatomic, copy) NSString *expiration;
@property (nonatomic, copy) NSString *required_Publickey;
@property (nonatomic, copy) NSString *binargs;
@property (nonatomic, copy) NSString *binargs1;
@property (nonatomic, copy) NSString *binargs2;
@end

@implementation EOSHelpRegisterVC
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
    self.view.backgroundColor = [UIColor whiteColor];
//    [self initHeadView];
    self.title = self.coinType == EOS ? NSLocalizedString(@"创建EOS账户", nil) : NSLocalizedString(@"创建MGP账户", nil);

    [self scrollView];
    self.eosWalletArray = [NSMutableArray new];
    //找本地EOS钱包
    
    NSArray *walletarr = self.coinType == EOS ? [CreateAll GetWalletArrayByCoinType:EOS] : [CreateAll GetWalletArrayByCoinType:MGP];
    if (walletarr.count > 0) {
        for (MissionWallet *wallet in walletarr) {
            if ([NSString checkEOSAccount:wallet.address] == YES) {
                
                [self.eosWalletArray addObject:wallet];
            }
        }
        if (self.eosWalletArray.count > 0) {
            self.payerEOSWallet = self.eosWalletArray[0];
            //获取创建所需资源额
            
            
            
            self.helpView = [EOSHelpRegisterView new];
            self.helpView.backgroundColor = [UIColor whiteColor];
            self.helpView.ramamount = @"4.00 KB";
            self.helpView.cpuamount = @"9.72 ms";
            self.helpView.netamount = @"237.93 KB";
            if (self.coinType == EOS) {
                self.helpView.neteos = @"0.1000 EOS";
                self.helpView.cpueos = @"0.1000 EOS";
                self.helpView.rameos = @"0.2508 EOS";
                self.helpView.totaleos = @"0.4508 EOS";

                
            }else{
                self.helpView.neteos = @"0.1000 MGP";
                self.helpView.cpueos = @"0.1000 MGP";
                self.helpView.rameos = @"0.2508 MGP";
                self.helpView.totaleos = @"0.4508 MGP";
                
            }
            self.helpView.eosAccount = self.eosAccount;
            self.helpView.eosAccountActiveKey = self.eosAccountActiveKey;
            self.helpView.eosAccountOwnerKey = self.eosAccountOwnerKey;
            self.helpView.payerAccount = self.payerEOSWallet.address;
            [self.helpView.selectPayerBtn addTarget:self action:@selector(selectPayerWallet:) forControlEvents:UIControlEventTouchUpInside];
            [self.bridgeContentView addSubview:_helpView];
            [_helpView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(0);
                make.top.equalTo(0);
                make.height.equalTo(500);
            }];
            
            [self.operationBtn addTarget:self action:@selector(operationBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
            [self.view showMsg:self.coinType == EOS ? NSLocalizedString(@"没有可用的EOS钱包", nil) : NSLocalizedString(@"没有可用的MGP钱包", nil)];

        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
        [self.view showMsg:self.coinType == EOS ? NSLocalizedString(@"没有可用的EOS钱包", nil) : NSLocalizedString(@"没有可用的MGP钱包", nil)];
    }
    
}

-(void)selectPayerWallet:(UIButton *)btn{
    if (self.eosWalletArray.count <= 1) {
        return;
    }
    NSInteger currentIndex = [self.eosWalletArray indexOfObject:self.payerEOSWallet];
    currentIndex++;
    if (currentIndex >= self.eosWalletArray.count) {
        currentIndex = 0;
    }
    self.payerEOSWallet = [self.eosWalletArray objectAtIndex:currentIndex];
    [btn setTitle:self.payerEOSWallet.address forState:UIControlStateNormal];
    
}

-(void)operationBtnAction:(UIButton *)btn{
    //检查账户名
    if([NSString checkEOSAccount:VALIDATE_STRING(self.eosAccount)] == NO){
        [self.view showMsg:NSLocalizedString(@"账户名称为a-z与1-5组合的12位字符", nil)];
        return;
    }
    
    if([NSString checkEOSAccount:VALIDATE_STRING(self.payerEOSWallet.address)] == NO){
        [self.view showMsg:NSLocalizedString(@"账户名称为a-z与1-5组合的12位字符", nil)];
        return;
    }
    MJWeakSelf
    //查询创建者账户是否有足够余额
    [self getEOSAccount:VALIDATE_STRING(self.payerEOSWallet.address) Success:^(id response) {
        if (response) {
            NSMutableDictionary *dic = response;
            if (dic) {
                NSString *balancestr = [dic objectForKey:@"core_liquid_balance"];
                NSString *valuestring = [balancestr componentsSeparatedByString:@" "].firstObject;
                CGFloat balance = valuestring.doubleValue;
                if (balance > 0.2) {
                    if (!weakSelf.dimview) {
                        weakSelf.dimview = [UIView new];
                        weakSelf.dimview.backgroundColor = [UIColor grayColor];
                        [weakSelf.view addSubview:weakSelf.dimview];
                    }
                    weakSelf.dimview.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
                    weakSelf.dimview.alpha = 0;
                    if (!weakSelf.deview) {
                        weakSelf.deview = [EOSTranDetailView new];
                        weakSelf.deview.backgroundColor = [UIColor whiteColor];
                        [weakSelf.view addSubview:weakSelf.deview];
                    }
                    weakSelf.deview.alpha = 0;
                    weakSelf.deview.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 400);
                    [weakSelf.deview.titlelb setText:NSLocalizedString(@"创建帐号", nil)];
                    [weakSelf.deview.amountlb setText:weakSelf.helpView.totaleos];
                    [weakSelf.deview.infolb setText:self.coinType == EOS ? NSLocalizedString(@"创建EOS帐号", nil) : NSLocalizedString(@"创建MGP帐号", nil)];
                    
                    weakSelf.deview.userInteractionEnabled = YES;
                    [weakSelf.deview.tolb setText:weakSelf.eosAccount];
                    [weakSelf.deview.fromlb setText:weakSelf.payerEOSWallet.address];
                    [weakSelf.deview.closeBtn addTarget:weakSelf action:@selector(closeEOStranView) forControlEvents:UIControlEventTouchUpInside];
                    [weakSelf.deview.nextBtn addTarget:weakSelf action:@selector(nextEOStranView) forControlEvents:UIControlEventTouchUpInside];
                    
                    [UIView animateWithDuration:0.3 animations:^{
                        weakSelf.dimview.alpha = 0.7;
                        weakSelf.deview.alpha = 1;
                        weakSelf.deview.frame = CGRectMake(0, self.view.frame.size.height - 400, ScreenWidth, 400);
                    }];
                    
                }else{
                    [weakSelf.view showMsg:@"余额不足"];
                }
                
            }
        }
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

-(void)eosTransactionMake{
    self.password = self.nextview.passTextField.text;
    if([self.password isEqualToString:@""] || self.password == nil){
        [self.view showMsg:NSLocalizedString(@"请输入密码！", nil)];
    }else{
        BOOL isRight = [CreateAll VerifyPassword:self.password ForWalletAddress:self.payerEOSWallet.address];
        if (isRight == NO && self.payerEOSWallet.coinType == EOS && self.payerEOSWallet.walletType == LOCAL_WALLET) {
            isRight = [CreateAll VerifyPassword:self.password ForWalletAddress:@"EOS_Temp"];
            if (isRight == YES) {
                [CreateAll SaveWallet:self.payerEOSWallet Name:self.payerEOSWallet.walletName WalletType:self.payerEOSWallet.walletType Password:self.password];
            }
        }
        if (isRight == NO && self.payerEOSWallet.coinType == MGP && self.payerEOSWallet.walletType == LOCAL_WALLET) {
            isRight = [CreateAll VerifyPassword:self.password ForWalletAddress:@"MGP_Temp"];
            if (isRight == YES) {
                [CreateAll SaveWallet:self.payerEOSWallet Name:self.payerEOSWallet.walletName WalletType:self.payerEOSWallet.walletType Password:self.password];
            }
        }
        if(isRight == YES){
            //解密钱包私钥
            if(![self.payerEOSWallet.privateKey isValidBitcoinPrivateKey]){
                NSString *depri = [AESCrypt decrypt:self.payerEOSWallet.privateKey password:self.password];
                if (depri != nil && ![depri isEqualToString:@""]) {
                    self.payerEOSWallet.privateKey = depri;
                }
            }
            [self transfer];
        }else{
            [self.view showMsg:NSLocalizedString(@"密码错误！", nil)];
        }
    }
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [self.scrollView scrollToTopAnimated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return NO;
}

#pragma create


- (void)transfer {
    [self.view showHUD];
    MJWeakSelf
    [self getJson:[self getAbiJsonToBinParamters][0] Binargs:^(id response) {
        if ([response isKindOfClass:[NSDictionary class]]) {
            NSDictionary *d = (NSDictionary *)response;
            weakSelf.binargs = [d objectForKey:@"binargs"];
            [weakSelf getJson:[weakSelf getAbiJsonToBinParamters][1] Binargs:^(id response) {
                if ([response isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *d = (NSDictionary *)response;
                    weakSelf.binargs1 = [d objectForKey:@"binargs"];
                    [weakSelf getJson:[weakSelf getAbiJsonToBinParamters][2] Binargs:^(id response) {
                        if ([response isKindOfClass:[NSDictionary class]]) {
                            NSDictionary *d = (NSDictionary *)response;
                            weakSelf.binargs2 = [d objectForKey:@"binargs"];
                            [weakSelf getInfoSuccess:^(id response) {
                                if (response != nil) {
                                    BlockChain *model = [BlockChain parse:response];// [@"data"]
                                    weakSelf.expiration = [[[NSDate dateFromString: model.head_block_time] dateByAddingTimeInterval: 30] formatterToISO8601];
                                    weakSelf.ref_block_num = [NSString stringWithFormat:@"%@",model.head_block_num];
                                    
                                    NSString *js = @"function readUint32( tid, data, offset ){var hexNum= data.substring(2*offset+6,2*offset+8)+data.substring(2*offset+4,2*offset+6)+data.substring(2*offset+2,2*offset+4)+data.substring(2*offset,2*offset+2);var ret = parseInt(hexNum,16).toString(10);return(ret)}";
                                    [weakSelf.context evaluateScript:js];
                                    //读区块id，转化成**格式  ref_block_prefix: 515467051
                                    JSValue *n = [weakSelf.context[@"readUint32"] callWithArguments:@[@8,VALIDATE_STRING(model.head_block_id) , @8]];
                                    weakSelf.ref_block_prefix = [n toString];
                                    weakSelf.chain_Id = [NSData convertHexStrToData:model.chain_id];
                                    NSLog(@"get_block_info_success:%@, %@---%@-%@", weakSelf.expiration , weakSelf.ref_block_num, weakSelf.ref_block_prefix, weakSelf.chain_Id);
                                    
                                    [weakSelf getRequiredPublicKeyRequestOperationSuccess:^(id response) {
                                        if ([response isKindOfClass:[NSDictionary class]]) {
                                            weakSelf.required_Publickey = response[@"required_keys"][0];
                                            //具体交易签名广播
                                            [weakSelf pushTransactionRequestOperationSuccess:^(id response) {
                                                [weakSelf.view hideHUD];
                                                if ([response isKindOfClass:[NSDictionary class]]) {
                                                    NSMutableDictionary *dic;
                                                    dic = [response mutableCopy];
                                                    [weakSelf.view showMsg:NSLocalizedString(@"交易已广播", nil)];
                                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                        [weakSelf.navigationController popViewControllerAnimated:YES];
                                                    });
                                                    
                                                }else{
                                                    [weakSelf.view showMsg:@"pushTransaction Error"];
                                                }
                                            }];
                                        }else{
                                            [weakSelf.view showMsg:@"getRequiredPublicKey Error"];
                                        }
                                    }];
                                }else{
                                    [weakSelf.view showMsg:@"getInfo Error"];
                                }
                                
                            }];
                            
                        }else{
                            [weakSelf.view showMsg:@"getAbiJsonToBin [2] Error"];
                        }
                    }];
                    
                }else{
                    [weakSelf.view showMsg:@"getAbiJsonToBin [1] Error"];
                }
            }];
            
        }else{
            [weakSelf.view showMsg:@"getAbiJsonToBin [0] Error"];
        }
    }];
}


#pragma mark - 获取行动代码

- (void)getJson:(NSDictionary *)dic Binargs:(void(^)(id response))handler {
    HTTPRequestManager *manager = self.coinType == EOS ? [HTTPRequestManager shareEosManager] : [HTTPRequestManager shareMgpManager];

    [manager post:eos_abi_json_to_bin paramters:dic success:^(BOOL isSuccess, id responseObject) {
        
        if (isSuccess) {
            handler(responseObject);
        }
    } failure:^(NSError *error) {
        handler(nil);
    } superView:self.view showFaliureDescription:YES];
    
}



#pragma mark - 获取最新区块

- (void)getInfoSuccess:(void(^)(id response))handler {
    HTTPRequestManager *manager = self.coinType == EOS ? [HTTPRequestManager shareEosManager] : [HTTPRequestManager shareMgpManager];

    [manager post:eos_get_info paramters:nil success:^(BOOL isSuccess, id responseObject) {
        
        if (isSuccess) {
            handler(responseObject);
        }
    } failure:^(NSError *error) {
        handler(nil);
        NSLog(@"URL_GET_INFO_ERROR ==== %@",error.description);
    } superView:self.view showFaliureDescription:YES];
    
}

#pragma mark - 获取公钥

- (void)getRequiredPublicKeyRequestOperationSuccess:(void(^)(id response))handler {
    NSLog(@"URL_GET_REQUIRED_KEYS parameters ============ %@",[[self getPramatersForRequiredKeys] modelToJSONString]);
    HTTPRequestManager *manager = self.coinType == EOS ? [HTTPRequestManager shareEosManager] : [HTTPRequestManager shareMgpManager];

    [manager post:eos_get_required_keys paramters:[self getPramatersForRequiredKeys] success:^(BOOL isSuccess, id responseObject) {
        
        if (isSuccess) {
            handler(responseObject);
        }
    } failure:^(NSError *error) {
        handler(nil);
        NSLog(@"URL_GET_REQUIRED_KEYS ==== %@",error.description);
    } superView:self.view showFaliureDescription:YES];
    
}

#pragma mark -


- (void)pushTransactionRequestOperationSuccess:(void(^)(id response))handler {
    
    // NSDictionary *transacDic = [self getPramatersForRequiredKeys];
    //已解密过
    NSString *wif = self.payerEOSWallet.privateKey;
    const int8_t *private_key = [[EosEncode getRandomBytesDataWithWif:wif] bytes];
    if (!private_key) {
        return;
    }
    if (![self.payerEOSWallet.publicKey isEqualToString:self.required_Publickey]) {
        [self.view showMsg:NSLocalizedString(@"EOS公钥不匹配！", nil)];
    }
    
    NSData *d = [EosByteWriter getBytesForSignature:self.chain_Id andParams:[[self getPramatersForRequiredKeys] objectForKey:@"transaction"] andCapacity:255];
    NSString *signatureStr = [EosSignature initWithbytesForSignature:d privateKey:(int8_t *)private_key];
    NSString *packed_trxHexStr = [[EosByteWriter getBytesForSignature:nil andParams:[[self getPramatersForRequiredKeys] objectForKey:@"transaction"] andCapacity:512] hexadecimalString];
    
    NSMutableDictionary *pushDic = [NSMutableDictionary dictionary];
    [pushDic setObject:VALIDATE_STRING(packed_trxHexStr) forKey:@"packed_trx"];
    [pushDic setObject:@[signatureStr] forKey:@"signatures"];
    [pushDic setObject:@"none" forKey:@"compression"];
    [pushDic setObject:@"" forKey:@"packed_context_free_data"];
    NSLog(@"push = \n%@",pushDic);
    MJWeakSelf
    HTTPRequestManager *manager = self.coinType == EOS ? [HTTPRequestManager shareEosManager] : [HTTPRequestManager shareMgpManager];

    [manager post:eos_push_transaction paramters:pushDic success:^(BOOL isSuccess, id responseObject) {
        NSLog(@"tran response %@",responseObject);
        if (isSuccess) {
            handler(responseObject);/*
            //把操作记录到后台
            [NetManager AddTradeWithuserName:[CreateAll GetCurrentUserName] TradeAmount:weakSelf.helpView.totaleos.doubleValue Poundage:0 CoinCode:@"EOS" From:VALIDATE_STRING(weakSelf.payerEOSWallet.address) To:VALIDATE_STRING(weakSelf.helpView.eosAccount) CompletionHandler:^(id responseObj, NSError *error) {
                
            }];
            //帮助注册的认为是本钱包生成的eos帐号
            NSString *str = [NSString stringWithFormat:@"%@:EOS",self.eosAccount];
            MJWeakSelf
            [NetManager AddAccountLogWithuserName:[CreateAll GetCurrentUserName] AccountInfo:str RecordType:CREATE_LOG_TYPE CompletionHandler:^(id responseObj, NSError *error) {
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
/*
 
 tr.newaccount({ creator: creator, name: name, owner: owner, active: active, });
 tr.buyram({ payer: creator, receiver: name, quant: ram });
 tr.delegatebw({ from: creator, receiver: name, stake_net_quantity: net, stake_cpu_quantity: cpu, transfer: 0 });
 */
- (NSArray *)getAbiJsonToBinParamters {
    NSString *from = VALIDATE_STRING(self.payerEOSWallet.address);
    NSString *to = self.eosAccount;
    // 交易JSON序列化
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    [params setObject: @"eosio" forKey:@"code"];
    //action就是指这部操作，这里是新建帐号newaccount，也有转账transfer，抵押delegatebw等等
    [params setObject:@"newaccount" forKey:@"action"];
    [args setObject:from forKey:@"creator"];
    [args setObject:VALIDATE_STRING(to) forKey:@"name"];
    NSMutableDictionary *do1 = [@{@"threshold":@1,
                                         @"keys":@[@{@"key":VALIDATE_STRING(self.eosAccountOwnerKey),@"weight":@1}],
                                         @"accounts":@[],
                                         @"waits":@[]}mutableCopy];
    NSMutableDictionary *do2 = [@{@"threshold":@1,
                                  @"keys":@[@{@"key":VALIDATE_STRING(self.eosAccountActiveKey),@"weight":@1}],
                                  @"accounts":@[],
                                  @"waits":@[]}mutableCopy];
    [args setObject:do1 forKey:@"owner"];
    [args setObject:do2 forKey:@"active"];
    [params setObject:args forKey:@"args"];
    
    NSMutableDictionary *params1 = [NSMutableDictionary dictionary];
    NSMutableDictionary *args1 = [NSMutableDictionary dictionary];
    [params1 setObject: @"eosio" forKey:@"code"];
    [params1 setObject:@"buyram" forKey:@"action"];
    [args1 setObject:VALIDATE_STRING(from) forKey:@"payer"];
    [args1 setObject:VALIDATE_STRING(to) forKey:@"receiver"];
    [args1 setObject:self.helpView.rameos forKey:@"quant"];
    [params1 setObject:args1 forKey:@"args"];
    
    NSMutableDictionary *params2 = [NSMutableDictionary dictionary];
    NSMutableDictionary *args2 = [NSMutableDictionary dictionary];
    [params2 setObject: @"eosio" forKey:@"code"];
    [params2 setObject:@"delegatebw" forKey:@"action"];
    [args2 setObject:VALIDATE_STRING(from) forKey:@"from"];
    [args2 setObject:VALIDATE_STRING(to) forKey:@"receiver"];
    [args2 setObject:self.helpView.cpueos forKey:@"stake_cpu_quantity"];
    [args2 setObject:self.helpView.neteos forKey:@"stake_net_quantity"];
    [args2 setObject:@"0" forKey:@"transfer"];
    [params2 setObject:args2 forKey:@"args"];
    //newaccount buyram delegatebw
    return @[params,params1,params2];
}

- (NSDictionary *)getPramatersForRequiredKeys {
    NSString *from = VALIDATE_STRING(self.payerEOSWallet.address);
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
    [actionDict setObject:@"eosio" forKey:@"account"];
    [actionDict setObject:@"newaccount" forKey:@"name"];
    [actionDict setObject:VALIDATE_STRING(self.binargs) forKey:@"data"];
    
    NSMutableDictionary *actionDict1 = [NSMutableDictionary dictionary];
    [actionDict1 setObject:@"eosio" forKey:@"account"];
    [actionDict1 setObject:@"buyram" forKey:@"name"];
    [actionDict1 setObject:VALIDATE_STRING(self.binargs1) forKey:@"data"];
    
    NSMutableDictionary *actionDict2 = [NSMutableDictionary dictionary];
    [actionDict2 setObject:@"eosio" forKey:@"account"];
    [actionDict2 setObject:@"delegatebw" forKey:@"name"];
    [actionDict2 setObject:VALIDATE_STRING(self.binargs2) forKey:@"data"];
    
    NSMutableDictionary *authorizationDict = [NSMutableDictionary dictionary];
    [authorizationDict setObject:from forKey:@"actor"];
    [authorizationDict setObject:@"active" forKey:@"permission"];
    
    [actionDict setObject:@[authorizationDict] forKey:@"authorization"];
    [actionDict1 setObject:@[authorizationDict] forKey:@"authorization"];
    [actionDict2 setObject:@[authorizationDict] forKey:@"authorization"];
    [transacDic setObject:@[actionDict,actionDict1,actionDict2] forKey:@"actions"];
    
    [params setObject:transacDic forKey:@"transaction"];
    
    [params setObject:@[self.payerEOSWallet.publicKey,self.payerEOSWallet.publicKey,self.payerEOSWallet.publicKey] forKey:@"available_keys"];
    return params;
}

#pragma mark - getter

- (JSContext *)context {
    if (!_context) {
        _context = [[JSContext alloc] init];
    }
    return _context;
}



#pragma net
- (void)getEOSAccount:(NSString *)account Success:(void(^)(id response))handler{
    
    NSDictionary *dic = @{@"account_name":account};
    HTTPRequestManager *manager = self.coinType == EOS ? [HTTPRequestManager shareEosManager] : [HTTPRequestManager shareMgpManager];

    [manager post:eos_get_account paramters:dic success:^(BOOL isSuccess, id responseObject) {
        
        if (isSuccess) {
            handler(responseObject);
        }else{
            handler(nil);
        }
    } failure:^(NSError *error) {
        handler(nil);
    } superView:self.view showFaliureDescription:YES];
    
}



#pragma

-(void)initHeadView{
    UIView *headBackView = [UIView new];
    headBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headBackView];
    [headBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(SafeAreaTopHeight);
        make.height.equalTo(150);
    }];
    _titlelabel = [[UILabel alloc] init];
    _titlelabel.textColor = [UIColor textBlackColor];
    _titlelabel.font = [UIFont boldSystemFontOfSize:18];
    _titlelabel.text = self.coinType == EOS ? NSLocalizedString(@"创建EOS账户", nil) : NSLocalizedString(@"创建MGP账户", nil);
    _titlelabel.textAlignment = NSTextAlignmentLeft;
    _titlelabel.numberOfLines = 1;
    [self.view addSubview:_titlelabel];
    [_titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(SafeAreaTopHeight - 34);
        make.left.equalTo(45);
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
    
}

-(UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.scrollEnabled = YES;
        _scrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight + 100);
        _scrollView.delegate =self;
        _scrollView.scrollsToTop = YES;
        [self.view addSubview:_scrollView];
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.top.equalTo(0);
            make.bottom.equalTo(-SafeAreaBottomHeight);
        }];
        _bridgeContentView = [UIView new];
        _bridgeContentView.backgroundColor = [UIColor whiteColor];
        [self.scrollView addSubview:_bridgeContentView];
        [_bridgeContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.scrollView);
            make.width.height.equalTo(self.scrollView.contentSize);
        }];
    }
    
    return _scrollView;
}

-(UIButton *)operationBtn{
    if (!_operationBtn) {
        _operationBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        _operationBtn.userInteractionEnabled = YES;
        _operationBtn.backgroundColor = [UIColor appBlueColor];
        [_operationBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [_operationBtn setTitle:NSLocalizedString(@"下一步", nil) forState:UIControlStateNormal];
        [self.view addSubview:_operationBtn];
        [_operationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.bottom.equalTo(-SafeAreaBottomHeight);
            make.height.equalTo(40);
        }];
    }
    return _operationBtn;
}
@end
