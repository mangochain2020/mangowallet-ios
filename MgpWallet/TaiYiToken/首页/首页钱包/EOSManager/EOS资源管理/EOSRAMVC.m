//
//  EOSRAMVC.m
//  TaiYiToken
//
//  Created by 张元一 on 2018/12/24.
//  Copyright © 2018 admin. All rights reserved.
//

#import "EOSRAMVC.h"
#import "EOSRAMView.h"
#import "BlockChain.h"
#import "InputPasswordView.h"
#import "EOSTranDetailView.h"
@interface EOSRAMVC ()<UITextFieldDelegate,UIScrollViewDelegate>
@property(nonatomic,strong)UILabel *titlelabel;
@property(nonatomic,strong)UIButton *backBtn;
@property(nonatomic,strong)EOSRAMView *ramView;
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIView *bridgeContentView;
@property(nonatomic,strong)UIButton *operationBtn;
@property(nonatomic,assign)CGFloat ramPrice;
@property(nonatomic,copy)NSString *eosBalance;
@property(nonatomic,copy)NSString *ramBalance;//byte

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
@end

@implementation EOSRAMVC
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
    self.title = NSLocalizedString(@"RAM", nil);

    [self scrollView];
    if (_eosAccountInfo) {
        _ramView = [EOSRAMView new];
        _ramView.coinType = self.wallet.coinType;
        _ramView.backgroundColor = [UIColor whiteColor];
        _ramView.ram = (_eosAccountInfo.ram_quota - _eosAccountInfo.ram_usage)/1.024;
        _ramView.ramtotal = _eosAccountInfo.ram_quota/1.024;
        _ramView.eosbalance = _eosAccountInfo.core_liquid_balance;
        _ramView.balanceLabel.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"余额", nil),_ramView.eosbalance];
        self.eosBalance = _eosAccountInfo.core_liquid_balance;
        self.ramBalance = [NSString stringWithFormat:@"%ld bytes",_eosAccountInfo.ram_quota - _eosAccountInfo.ram_usage];
        [self.bridgeContentView addSubview:_ramView];
        [_ramView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.top.equalTo(0);
            make.height.equalTo(500);
        }];
        _ramView.manageTextField.delegate = self;
        _ramView.manageTextField.tag = 2930;
        [_ramView.manageTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [_ramView.buyBtn addTarget:self action:@selector(buySelect:) forControlEvents:UIControlEventTouchUpInside];
        [_ramView.saleBtn addTarget:self action:@selector(saleSelect:) forControlEvents:UIControlEventTouchUpInside];
        [self.operationBtn addTarget:self action:@selector(operationBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_ramView.reveiverTextField setText:VALIDATE_STRING(self.wallet.address)];
        
        MJWeakSelf
        if (self.wallet.coinType == EOS) {
            [self getTableRowsSuccessForeos:^(id response) {
                if (response != nil) {
                    //RAM价格 = (n * quote.balance) / (n + base.balance / 1024)
                    CGFloat quotebalance= ((NSString *)response[@"rows"][0][@"quote"][@"balance"]).doubleValue;
                    CGFloat basebalance= ((NSString *)response[@"rows"][0][@"base"][@"balance"]).doubleValue;
                    weakSelf.ramPrice = (1 * quotebalance) / (basebalance / 1024);
                    weakSelf.ramView.ramprice = [NSString stringWithFormat:@"%.5f EOS/KB",weakSelf.ramPrice];
                    [weakSelf.ramView.rampriceLabel setText:weakSelf.ramView.ramprice];
                }
            }];
        }else{
            [self getTableRowsSuccessFormgp:^(id response) {
                if (response != nil) {
                    //RAM价格 = (n * quote.balance) / (n + base.balance / 1024)
                    CGFloat quotebalance= ((NSString *)response[@"rows"][0][@"quote"][@"balance"]).doubleValue;
                    CGFloat basebalance= ((NSString *)response[@"rows"][0][@"base"][@"balance"]).doubleValue;
                    weakSelf.ramPrice = (1 * quotebalance) / (basebalance / 1024);
                    weakSelf.ramView.ramprice = [NSString stringWithFormat:@"%.5f MGP/KB",weakSelf.ramPrice];
                    [weakSelf.ramView.rampriceLabel setText:weakSelf.ramView.ramprice];
                }
            }];
        }
        
    }
}

-(void)buySelect:(UIButton *)btn{
    [btn setSelected:YES];
    [_ramView.reveiverTextField setUserInteractionEnabled:YES];
    [_ramView.reveiverTextField setTextColor:[UIColor textBlackColor]];
    [_ramView.saleBtn setSelected:NO];
    [_operationBtn setTitle:NSLocalizedString(@"购买", nil) forState:UIControlStateNormal];
    [_ramView.manageTitleLabel setText:NSLocalizedString(@"购买数量", nil)];
    if (self.wallet.coinType == EOS) {
        [_ramView.manageTextField setPlaceholder:NSLocalizedString(@"输入EOS数量", nil)];

    }else{
        [_ramView.manageTextField setPlaceholder:NSLocalizedString(@"输入MGP数量", nil)];
    }
    [_ramView.manageTextField setText:@""];
    [_ramView.amountLabel setText:@""];
    _ramView.balanceLabel.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"余额", nil),_ramView.eosbalance];
}

-(void)saleSelect:(UIButton *)btn{
    [btn setSelected:YES];
    [_ramView.reveiverTextField setUserInteractionEnabled:NO];
    [_ramView.reveiverTextField setTextColor:[UIColor lightGrayColor]];
    [_ramView.buyBtn setSelected:NO];
    [_operationBtn setTitle:NSLocalizedString(@"出售", nil) forState:UIControlStateNormal];
    [_ramView.manageTitleLabel setText:NSLocalizedString(@"出售数量(bytes)", nil)];
    [_ramView.manageTextField setPlaceholder:NSLocalizedString(@"输入RAM数量", nil)];
    [_ramView.manageTextField setText:@""];
    [_ramView.amountLabel setText:@""];
    _ramView.balanceLabel.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"余额", nil),self.ramBalance];
}

-(void)operationBtnAction:(UIButton *)btn{
    NSString *amount = self.ramView.manageTextField.text;
    NSString *account = self.ramView.reveiverTextField.text;
    
    if ([NSString checkEOSAccount:account] == NO || account == nil || [account isEqualToString:@""]) {
        [self.view showMsg:NSLocalizedString(@"请输入有效的接收帐户", nil)];
        return;
    }
    if (self.ramView.buyBtn.selected == YES && self.ramView.saleBtn.selected == NO) {
        if ([NSString checkNumber:amount] == NO || amount == nil || [amount isEqualToString:@""]) {
            [self.view showMsg:NSLocalizedString(@"数量错误", nil)];
            return;
        }
        CGFloat buyamount = self.ramView.manageTextField.text.doubleValue;
        if (buyamount >= [_eosBalance componentsSeparatedByString:@" EOS"].firstObject.doubleValue) {
            [self.view showMsg:NSLocalizedString(@"余额不足", nil)];
            return;
        }
        if (!_dimview) {
            _dimview = [UIView new];
            _dimview.backgroundColor = [UIColor grayColor];
            [self.view addSubview:_dimview];
        }
        _dimview.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        _dimview.alpha = 0;
        if (!_deview) {
            _deview = [EOSTranDetailView new];
            _deview.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:_deview];
        }
        self.deview.alpha = 0;
        _deview.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 400);
        [_deview.titlelb setText:NSLocalizedString(@"购买", nil)];
        [_deview.amountlb setText:[NSString stringWithFormat:@"%.4f %@",amount.doubleValue,self.wallet.coinType == EOS ? @"EOS" : @"MGP"]];
        [_deview.infolb setText: [NSString stringWithFormat:@"%@RAM",NSLocalizedString(@"购买", nil)]];
        
        _deview.userInteractionEnabled = YES;
        [_deview.tolb setText:account];
        [_deview.fromlb setText:_wallet.address];
        [_deview.closeBtn addTarget:self action:@selector(closeEOStranView) forControlEvents:UIControlEventTouchUpInside];
        [_deview.nextBtn addTarget:self action:@selector(nextEOStranView) forControlEvents:UIControlEventTouchUpInside];
        MJWeakSelf
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.dimview.alpha = 0.7;
            weakSelf.deview.alpha = 1;
//            weakSelf.deview.frame = CGRectMake(0, ScreenHeight- 400 - SafeAreaBottomHeight, ScreenWidth, 400);
            weakSelf.deview.frame = CGRectMake(0, self.view.frame.size.height - 400, ScreenWidth, 400);

        }];
    }else if (self.ramView.buyBtn.selected == NO && self.ramView.saleBtn.selected == YES){
        if ([NSString checkNumber:amount] == NO || amount == nil || [amount isEqualToString:@""]) {
            [self.view showMsg:NSLocalizedString(@"RAM数量错误", nil)];
            return;
        }
        CGFloat saleamount = self.ramView.manageTextField.text.doubleValue;
        if (saleamount >= _eosAccountInfo.ram_quota - _eosAccountInfo.ram_usage) {
            [self.view showMsg:NSLocalizedString(@"余额不足", nil)];
            return;
        }

        [_deview.titlelb setText:NSLocalizedString(@"出售", nil)];
        if (!_dimview) {
            _dimview = [UIView new];
            _dimview.backgroundColor = [UIColor grayColor];
            [self.view addSubview:_dimview];
        }
        _dimview.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        _dimview.alpha = 0;
        if (!_deview) {
            _deview = [EOSTranDetailView new];
            _deview.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:_deview];
        }
        self.deview.alpha = 0;
        _deview.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 400);
        [_deview.amountlb setText:[NSString stringWithFormat:@"%.4f KB",saleamount/1024.0]];
        [_deview.infolb setText: [NSString stringWithFormat:@"%@RAM",NSLocalizedString(@"出售", nil)]];
        
        _deview.userInteractionEnabled = YES;
        [_deview.tolb setText:_wallet.address];
        [_deview.fromlb setText:_wallet.address];
        _deview.closeBtn.hidden = NO;
        [_deview.closeBtn addTarget:self action:@selector(closeEOStranView) forControlEvents:UIControlEventTouchUpInside];
        [_deview.nextBtn addTarget:self action:@selector(nextEOStranView) forControlEvents:UIControlEventTouchUpInside];
        MJWeakSelf
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.dimview.alpha = 0.7;
            weakSelf.deview.alpha = 1;
//            weakSelf.deview.frame = CGRectMake(0, ScreenHeight- 400 - SafeAreaBottomHeight, ScreenWidth, 400);
            weakSelf.deview.frame = CGRectMake(0, self.view.frame.size.height - 400, ScreenWidth, 400);

        }];
    }
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
    _nextview.frame = CGRectMake(ScreenWidth, ScreenHeight-400 - SafeAreaBottomHeight, ScreenWidth, 400);
    [_nextview passTextField];
    [_nextview.closeBtn addTarget:self action:@selector(closeNextView) forControlEvents:UIControlEventTouchUpInside];
    [_nextview.nextBtn addTarget:self action:@selector(eosTransactionMake) forControlEvents:UIControlEventTouchUpInside];
    MJWeakSelf
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.deview.frame = CGRectMake(-ScreenWidth, ScreenHeight - 400 - SafeAreaBottomHeight, ScreenWidth, 400);
        weakSelf.deview.alpha = 0;
//        weakSelf.nextview.frame = CGRectMake(0, ScreenHeight-400 - SafeAreaBottomHeight, ScreenWidth, 400);
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
            //解密钱包私钥
            if(![self.wallet.privateKey isValidBitcoinPrivateKey]){
                NSString *depri = [AESCrypt decrypt:self.wallet.privateKey password:self.password];
                if (depri != nil && ![depri isEqualToString:@""]) {
                    self.wallet.privateKey = depri;
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
}

-(void)textFieldDidChange :(UITextField *)textField{
    if (textField.tag == 2930) {
        CGFloat amount = textField.text.doubleValue;
        if ([NSString checkNumber:textField.text] == NO) {
            return;
        }
        if (self.ramView.buyBtn.selected == YES && self.ramView.saleBtn.selected == NO) {
            [_ramView.amountLabel setText:[NSString stringWithFormat:@"≈%.4fKB",amount/self.ramPrice]];
            
        }else if (self.ramView.buyBtn.selected == NO && self.ramView.saleBtn.selected == YES){
            
            [_ramView.amountLabel setText:[NSString stringWithFormat:@"≈%.4f%@",self.ramPrice * amount/1024.0,self.wallet.coinType == EOS ? @"EOS" : @"MGP"]];
        }
    }
}


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
    _titlelabel.text = NSLocalizedString(@"RAM", nil);
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

- (void)getTableRowsSuccessForeos:(void(^)(id response))handler{
    
    NSDictionary *dic = @{@"json": @1,@"code": @"eosio",@"scope":@"eosio",@"table":@"rammarket"};
    [[HTTPRequestManager shareEosManager] post:eos_get_table_rows paramters:dic success:^(BOOL isSuccess, id responseObject) {
        
        if (isSuccess) {
            handler(responseObject);
        }else{
            handler(nil);
        }
    } failure:^(NSError *error) {
        
    } superView:self.view showFaliureDescription:YES];
    
}
- (void)getTableRowsSuccessFormgp:(void(^)(id response))handler{
    
    NSDictionary *dic = @{@"json": @1,@"code": @"eosio",@"scope":@"eosio",@"table":@"rammarket"};
    [[HTTPRequestManager shareMgpManager] post:eos_get_table_rows paramters:dic success:^(BOOL isSuccess, id responseObject) {
        
        if (isSuccess) {
            handler(responseObject);
        }else{
            handler(nil);
        }
    } failure:^(NSError *error) {
        
    } superView:self.view showFaliureDescription:YES];
    
}

-(UIButton *)operationBtn{
    if (!_operationBtn) {
        _operationBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        _operationBtn.userInteractionEnabled = YES;
        _operationBtn.backgroundColor = [UIColor appBlueColor];
        [_operationBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
        if (self.ramView.buyBtn.selected == YES && self.ramView.saleBtn.selected == NO) {
            [_operationBtn setTitle:NSLocalizedString(@"购买", nil) forState:UIControlStateNormal];
        }else if (self.ramView.saleBtn.selected == NO && self.ramView.saleBtn.selected == YES){
            [_operationBtn setTitle:NSLocalizedString(@"出售", nil) forState:UIControlStateNormal];
        }
        [self.view addSubview:_operationBtn];
        [_operationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.bottom.equalTo(-SafeAreaBottomHeight);
            make.height.equalTo(40);
        }];
    }
    return _operationBtn;
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
/*
 EOS *************************************************************************
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
                if (response != nil) {
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
            [weakSelf.view showMsg:@"getAbiJsonToBin Error"];
        }
    }];
}
#pragma bin_to_json
-(void)getBinToJson:(NSString *)datastring Handler:(void(^)(id response))handler{
    //NSString *from = self.addressView.fromAddressTextField.text;
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject: @"eosio" forKey:@"code"];
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
        handler(nil);
    } superView:self.view showFaliureDescription:YES];
    
}

#pragma mark - 获取帐号信息
- (void)getAccountSuccess:(void(^)(id response))handler {
    NSString *account = [self.wallet.walletName componentsSeparatedByString:@"_"].lastObject;
    NSDictionary *dic = @{@"account_name":account};
    HTTPRequestManager *manager = self.wallet.coinType == EOS ? [HTTPRequestManager shareEosManager] : [HTTPRequestManager shareMgpManager];

    [manager post:eos_get_account paramters:dic success:^(BOOL isSuccess, id responseObject) {
        
        if (isSuccess) {
            handler(responseObject);
            
        }
    } failure:^(NSError *error) {
        handler(nil);
        NSLog(@"URL_GET_INFO_ERROR ==== %@",error.description);
    } superView:self.view showFaliureDescription:YES];
}


#pragma mark - 获取最新区块

- (void)getInfoSuccess:(void(^)(id response))handler {
    HTTPRequestManager *manager = self.wallet.coinType == EOS ? [HTTPRequestManager shareEosManager] : [HTTPRequestManager shareMgpManager];
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
    HTTPRequestManager *manager = self.wallet.coinType == EOS ? [HTTPRequestManager shareEosManager] : [HTTPRequestManager shareMgpManager];

    [manager post:eos_get_required_keys paramters:[self getPramatersForRequiredKeys] success:^(BOOL isSuccess, id responseObject) {
        
        if (isSuccess) {
            handler(responseObject);
        }
    } failure:^(NSError *error) {
        handler(nil);
        NSLog(@"URL_GET_REQUIRED_KEYS ==== %@",error.description);
    } superView:self.view showFaliureDescription:YES];
    
}

#pragma mark -----df

- (void)pushTransactionRequestOperationSuccess:(void(^)(id response))handler {
    
    // NSDictionary *transacDic = [self getPramatersForRequiredKeys];
    NSString *wif = self.wallet.privateKey;
    const int8_t *private_key = [[EosEncode getRandomBytesDataWithWif:wif] bytes];
    if (!private_key) {
        return;
    }
    if (![self.wallet.publicKey isEqualToString:self.required_Publickey] && self.wallet.coinType == MIS) {
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
    HTTPRequestManager *manager = self.wallet.coinType == EOS ? [HTTPRequestManager shareEosManager] : [HTTPRequestManager shareMgpManager];

    [manager post:eos_push_transaction paramters:pushDic success:^(BOOL isSuccess, id responseObject) {
        NSLog(@"tran response %@",responseObject);
        if (isSuccess) {
            handler(responseObject);
            /*
            NSString *from = VALIDATE_STRING(weakSelf.wallet.address);
            NSString *to = VALIDATE_STRING(weakSelf.ramView.reveiverTextField.text);
            if (weakSelf.ramView.buyBtn.selected == YES && weakSelf.ramView.saleBtn.selected == NO) {
                [NetManager AddTradeWithuserName:[CreateAll GetCurrentUserName] TradeAmount:weakSelf.ramView.manageTextField.text.doubleValue Poundage:0 CoinCode:@"EOS" From:VALIDATE_STRING(from) To:VALIDATE_STRING(to) CompletionHandler:^(id responseObj, NSError *error) {
                    
                }];
            }else if(weakSelf.ramView.buyBtn.selected == NO && weakSelf.ramView.saleBtn.selected == YES){
                [NetManager AddTradeWithuserName:[CreateAll GetCurrentUserName] TradeAmount:weakSelf.ramPrice * weakSelf.ramView.manageTextField.text.doubleValue/1024.0 Poundage:0 CoinCode:@"EOS" From:VALIDATE_STRING(from) To:VALIDATE_STRING(weakSelf.ramView.manageTextField.text) CompletionHandler:^(id responseObj, NSError *error) {
                    
                }];
            }*/
            
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
    NSString *from = VALIDATE_STRING(self.wallet.address);
    NSString *to = VALIDATE_STRING(self.ramView.reveiverTextField.text);
//    NSString *memo = @"";
    // 交易JSON序列化
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    [params setObject: @"eosio" forKey:@"code"];
    if (self.ramView.buyBtn.selected == YES && self.ramView.saleBtn.selected == NO) {
        [params setObject:@"buyram" forKey:@"action"];
        [args setObject:VALIDATE_STRING(from) forKey:@"payer"];
        [args setObject:VALIDATE_STRING(to) forKey:@"receiver"];
        NSString *buyamount = [NSString stringWithFormat:@"%.4f %@",self.ramView.manageTextField.text.doubleValue,self.wallet.coinType == EOS ? @"EOS" : @"MGP"];
        [args setObject:VALIDATE_STRING(buyamount) forKey:@"quant"];
    }else if(self.ramView.buyBtn.selected == NO && self.ramView.saleBtn.selected == YES){
        [params setObject:@"sellram" forKey:@"action"];
        [args setObject:VALIDATE_STRING(from) forKey:@"account"];
        [args setObject:VALIDATE_STRING(self.ramView.manageTextField.text) forKey:@"bytes"];
    }
    
    [params setObject:args forKey:@"args"];
    
    return params;
}

- (NSDictionary *)getPramatersForRequiredKeys {
    NSString *from = VALIDATE_STRING(self.wallet.address);
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
    if (self.ramView.buyBtn.selected == YES && self.ramView.saleBtn.selected == NO) {
        [actionDict setObject:@"buyram" forKey:@"name"];
    }else if(self.ramView.buyBtn.selected == NO && self.ramView.saleBtn.selected == YES){
        [actionDict setObject:@"sellram" forKey:@"name"];
    }
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
    NSString *from = VALIDATE_STRING(self.wallet.address);
    
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
    [actionDict setObject:@"eosio" forKey:@"account"];
    if (self.ramView.buyBtn.selected == YES && self.ramView.saleBtn.selected == NO) {
        [actionDict setObject:@"buyram" forKey:@"name"];
    }else if(self.ramView.buyBtn.selected == NO && self.ramView.saleBtn.selected == YES){
        [actionDict setObject:@"sellram" forKey:@"name"];
    }
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
@end
