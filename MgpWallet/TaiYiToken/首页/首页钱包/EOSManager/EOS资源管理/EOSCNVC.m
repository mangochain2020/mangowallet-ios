//
//  EOSCNVC.m
//  TaiYiToken
//
//  Created by 张元一 on 2018/12/20.
//  Copyright © 2018 admin. All rights reserved.
//

#import "EOSCNVC.h"
#import "EOSCNDetailView.h"
#import "TransactionGasView.h"
#import "BlockChain.h"
#import "EOSStakeView.h"
#import "EOSReclaimView.h"
#import "InputPasswordView.h"
#import "EOSTranDetailView.h"
#define CNSliderMAX 1.0
#define CNSliderMIN 0.0
@interface EOSCNVC ()<UITextFieldDelegate,UIScrollViewDelegate>
@property(nonatomic,strong)UILabel *titlelabel;
@property(nonatomic,strong)UIButton *backBtn;
@property(nonatomic,strong)EOSCNDetailView *detailView;
@property(nonatomic,strong)TransactionGasView *gasView;
@property(nonatomic,assign)CGFloat cpuprice;
@property(nonatomic,assign)CGFloat netprice;
@property(nonatomic,assign)CGFloat eosamount;
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIView *bridgeContentView;
@property(nonatomic,strong)UIButton *operationBtn;

@property(nonatomic,strong)EOSStakeView *stakeView;
@property(nonatomic,strong)EOSReclaimView *reclaimView;

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

@implementation EOSCNVC
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
    self.title = NSLocalizedString(@"带宽", nil);

    [self scrollView];
    if (_eosAccountInfo) {
        _detailView = [EOSCNDetailView new];
        _detailView.backgroundColor = [UIColor whiteColor];
        _detailView.cpu = _eosAccountInfo.cpu_limit.available;
        _detailView.cputotal = _eosAccountInfo.cpu_limit.max;
        _detailView.net = _eosAccountInfo.net_limit.available;
        _detailView.nettotal = _eosAccountInfo.net_limit.max;
        if (_eosAccountInfo.self_delegated_bandwidth) {
            _detailView.cpuStakeEOS = _eosAccountInfo.self_delegated_bandwidth.cpu_weight;
            _detailView.netStakeEOS = _eosAccountInfo.self_delegated_bandwidth.net_weight;
            
        }else{
            _detailView.cpuStakeEOS = self.wallet.coinType == EOS ? @"0.0000EOS" : @"0.0000MGP";
            _detailView.netStakeEOS = self.wallet.coinType == EOS ? @"0.0000EOS" : @"0.0000MGP";
        }
        _detailView.balance = _eosAccountInfo.core_liquid_balance;
        [self.bridgeContentView addSubview:_detailView];
        [_detailView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.top.equalTo(0);
            make.height.equalTo(500);
        }];
        
        [_detailView.stakeBtn addTarget:self action:@selector(stakeSelect:) forControlEvents:UIControlEventTouchUpInside];
        [_detailView.reclaimBtn addTarget:self action:@selector(reclaimSelect:) forControlEvents:UIControlEventTouchUpInside];
        _stakeView = [EOSStakeView new];
        _stakeView.coinType = self.wallet.coinType;
        _stakeView.backgroundColor = [UIColor whiteColor];
        _stakeView.balance = _eosAccountInfo.core_liquid_balance;
        
        _reclaimView = [EOSReclaimView new];
        _reclaimView.coinType = self.wallet.coinType;
        _reclaimView.backgroundColor = [UIColor whiteColor];
//        _reclaimView.cpureclaim =
        _reclaimView.hidden = YES;
        [self.bridgeContentView addSubview:_reclaimView];
        [_reclaimView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.top.equalTo(260);
            make.height.equalTo(260);
        }];
        
        _gasView = [TransactionGasView new];
        [_gasView initUI];
        _gasView.backgroundColor = [UIColor clearColor];
        [_gasView.namelb setText:@""];
        [_gasView.namelb setFont:[UIFont systemFontOfSize:13]];
        [_gasView.minLabel setFont:[UIFont systemFontOfSize:13]];
        [_gasView.maxLabel setFont:[UIFont systemFontOfSize:13]];
        
//        [_gasView.namelb setText:NSLocalizedString(@"抵押比例", nil)];
        [_gasView.minLabel setText:@"CPU"];
        [_gasView.maxLabel setText:@"NET"];
        [_gasView.gasSlider setValue:0.5];
        _gasView.userInteractionEnabled = YES;
        _gasView.gasSlider.userInteractionEnabled = YES;
        _gasView.gasSlider.maximumValue = CNSliderMAX;
        _gasView.gasSlider.minimumValue = CNSliderMIN;
        [self.stakeView addSubview:_gasView];
        [_gasView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(60);
            make.left.right.equalTo(0);
            make.height.equalTo(100);
        }];
        
        [_gasView.gasSlider setValue:_gasView.gasSlider.minimumValue];
        [_gasView.gasSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];// 针对值变化添加响应方法
        _stakeView.userInteractionEnabled = YES;
        _stakeView.cnTextField.delegate = self;
        _stakeView.cnTextField.tag = 3399;
        [_stakeView.cnTextField addTarget:self action:@selector(cntextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self.bridgeContentView addSubview:_stakeView];
        [_stakeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.top.equalTo(260);
            make.height.equalTo(260);
        }];
        NSInteger cpu = _eosAccountInfo.cpu_weight;
        self.cpuprice =  cpu*0.0001/_eosAccountInfo.cpu_limit.max*1000;
        NSInteger net = _eosAccountInfo.net_weight;
        self.netprice =  net*0.0001/_eosAccountInfo.net_limit.max*1000;
        [self.stakeView.cnLabel setText:[NSString stringWithFormat:@"CPU ≈ %.2f ms\nNET ≈ %.2f KB",self.eosamount/self.cpuprice*self.gasView.gasSlider.value,self.eosamount/self.netprice* (1.0-self.gasView.gasSlider.value)]];
        
        self.reclaimView.cpureclaim = [NSString stringWithFormat:@"%.4f %@",cpu*0.0001,self.wallet.coinType == EOS ? @"EOS" : @"MGP"];
        self.reclaimView.netreclaim = [NSString stringWithFormat:@"%.4f %@",net*0.0001,self.wallet.coinType == EOS ? @"EOS" : @"MGP"];
        self.reclaimView.reveiver = VALIDATE_STRING(self.wallet.address);
        [self.reclaimView.reveiverLabel setText:VALIDATE_STRING(self.wallet.address)];
        [self.reclaimView.reveiverLabel setUserInteractionEnabled:NO];
        [self.reclaimView.reveiverLabel setTextColor:[UIColor lightGrayColor]];
        self.reclaimView.cpuTextField.delegate = self;
        self.reclaimView.netTextField.delegate = self;
        self.stakeView.accountTextField.delegate = self;
        self.stakeView.accountTextField.tag = 2288;
        [self.stakeView.accountTextField setText:VALIDATE_STRING(self.wallet.address)];
        [self.operationBtn addTarget:self action:@selector(operationBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}



-(void)operationBtnAction:(UIButton *)btn{
   
    
    if (self.detailView.stakeBtn.selected == YES && self.detailView.reclaimBtn.selected == NO) {
        NSString *amount = self.stakeView.cnTextField.text;
        NSString *account = self.stakeView.accountTextField.text;
        //stake
        
        if ([NSString checkNumber:amount] == NO || amount == nil || [amount isEqualToString:@""]) {
            [self.view showMsg:NSLocalizedString(@"数量错误", nil)];
            return;
        }
        if ([NSString checkEOSAccount:account] == NO || account == nil || [account isEqualToString:@""]) {
            [self.view showMsg:NSLocalizedString(@"请输入有效的接收帐户", nil)];
            return;
        }
        CGFloat balance = [self.eosAccountInfo.core_liquid_balance componentsSeparatedByString:@" EOS"].firstObject.doubleValue;
        if (self.eosamount >= balance) {
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
        [_deview.titlelb setText:NSLocalizedString(@"抵押", nil)];
        [_deview.amountlb setText:[NSString stringWithFormat:@"%.4f %@",amount.doubleValue,self.wallet.coinType == EOS ? @"EOS" : @"MGP"]];
        [_deview.infolb setText: [NSString stringWithFormat:@"%@",NSLocalizedString(@"抵押", nil)]];
        
        _deview.userInteractionEnabled = YES;
        [_deview.tolb setText:account];
        [_deview.fromlb setText:_wallet.address];
        [_deview.closeBtn addTarget:self action:@selector(closeEOStranView) forControlEvents:UIControlEventTouchUpInside];
        [_deview.nextBtn addTarget:self action:@selector(nextEOStranView) forControlEvents:UIControlEventTouchUpInside];
        
        [UIView animateWithDuration:0.3 animations:^{
            self.dimview.alpha = 0.7;
            self.deview.alpha = 1;
            self.deview.frame = CGRectMake(0, self.view.frame.size.height - 400, ScreenWidth, 400);

//            self.deview.frame = CGRectMake(0, ScreenHeight- 400 - SafeAreaBottomHeight, ScreenWidth, 400);
        }];
 
    }else if (self.detailView.stakeBtn.selected == NO && self.detailView.reclaimBtn.selected == YES){
        //reclaim
        NSString *cpu = self.reclaimView.cpuTextField.text;
        NSString *net = self.reclaimView.netTextField.text;
        if ([NSString checkNumber:cpu] == NO || cpu == nil || [cpu isEqualToString:@""]) {
            [self.view showMsg:NSLocalizedString(@"CPU数量错误", nil)];
            return;
        }
        if ([NSString checkNumber:net] == NO || net == nil || [net isEqualToString:@""]) {
            [self.view showMsg:NSLocalizedString(@"NET数量错误", nil)];
            return;
        }
        
        CGFloat cpubalance = [self.reclaimView.cpureclaim componentsSeparatedByString:@" EOS"].firstObject.doubleValue;
        CGFloat netbalance = [self.reclaimView.netreclaim componentsSeparatedByString:@" EOS"].firstObject.doubleValue;
        if (cpu.doubleValue > cpubalance || net.doubleValue > netbalance) {
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
        [_deview.titlelb setText:NSLocalizedString(@"赎回", nil)];
        [_deview.amountlb setText:[NSString stringWithFormat:@"%.4f %@",cpu.doubleValue+net.doubleValue,self.wallet.coinType == EOS ? @"EOS" : @"MGP"]];
        [_deview.infolb setText: [NSString stringWithFormat:@"%@",NSLocalizedString(@"赎回", nil)]];
        
        _deview.userInteractionEnabled = YES;
        [_deview.tolb setText:_wallet.address];
        [_deview.fromlb setText:_wallet.address];
        [_deview.closeBtn addTarget:self action:@selector(closeEOStranView) forControlEvents:UIControlEventTouchUpInside];
        [_deview.nextBtn addTarget:self action:@selector(nextEOStranView) forControlEvents:UIControlEventTouchUpInside];
        
        [UIView animateWithDuration:0.3 animations:^{
            self.dimview.alpha = 0.7;
            self.deview.alpha = 1;
//            self.deview.frame = CGRectMake(0, ScreenHeight- 400 - SafeAreaBottomHeight, ScreenWidth, 400);
            self.deview.frame = CGRectMake(0, self.view.frame.size.height - 400, ScreenWidth, 400);

        }];
    }
    
}
//关闭交易信息页
-(void)closeEOStranView{
    [UIView animateWithDuration:0.3 animations:^{
        self.deview.frame = CGRectMake(0, ScreenHeight + SafeAreaBottomHeight, ScreenWidth, 400);
        self.deview.alpha = 0;
        self.dimview.alpha = 0;
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
//        weakSelf.nextview.frame = CGRectMake(0, ScreenHeight + SafeAreaBottomHeight, ScreenWidth, 400);
        weakSelf.nextview.frame = CGRectMake(0, self.view.frame.size.height - 400, ScreenWidth, 400);
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
        if (isRight == NO && _wallet.coinType == MGP && _wallet.walletType == LOCAL_WALLET) {
            isRight = [CreateAll VerifyPassword:self.password ForWalletAddress:@"MGP_Temp"];
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
    [self.scrollView scrollToTopAnimated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return NO;
}

-(void)cntextFieldDidChange :(UITextField *)textField{
    if (textField.tag == 3399) {//抵押EOS数
        if ([NSString checkNumber:textField.text] == NO) {
            return;
        }
        self.eosamount = textField.text.doubleValue;
        [self.stakeView.cnLabel setText:[NSString stringWithFormat:@"CPU ≈ %.2f ms\nNET ≈ %.2f KB",self.eosamount/self.cpuprice*self.gasView.gasSlider.value,self.eosamount/self.netprice* (1.0-self.gasView.gasSlider.value)]];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    MJWeakSelf
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.scrollView.contentInset = UIEdgeInsetsMake(-200, 0, 0, 0);
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.3 animations:^{
        self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }];
}

-(void)stakeSelect:(UIButton *)btn{
    [btn setSelected:YES];
    [_operationBtn setTitle:NSLocalizedString(@"抵押1", nil) forState:UIControlStateNormal];
    _operationBtn.backgroundColor = [UIColor appBlueColor];
    [_detailView.reclaimBtn setSelected:NO];
    _stakeView.hidden = NO;
    _reclaimView.hidden = YES;
}

-(void)reclaimSelect:(UIButton *)btn{
    [btn setSelected:YES];
    [_operationBtn setTitle:NSLocalizedString(@"赎回1", nil) forState:UIControlStateNormal];
    _operationBtn.backgroundColor = [UIColor redColor];
    [_detailView.stakeBtn setSelected:NO];
    _stakeView.hidden = YES;
    _reclaimView.hidden = NO;
}

-(void)sliderValueChanged:(UISlider *)sender{
    self.eosamount = self.stakeView.cnTextField.text.doubleValue;
    [self.stakeView.cnLabel setText:[NSString stringWithFormat:@"CPU ≈ %.2f ms\nNET ≈ %.2f KB",self.eosamount/self.cpuprice*self.gasView.gasSlider.value,self.eosamount/self.netprice* (1.0-self.gasView.gasSlider.value)]];
}

-(UIButton *)operationBtn{
    if (!_operationBtn) {
        _operationBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        _operationBtn.userInteractionEnabled = YES;
        _operationBtn.backgroundColor = [UIColor appBlueColor];
        [_operationBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
        if (self.detailView.stakeBtn.selected == YES && self.detailView.reclaimBtn.selected == NO) {
            //stake
            [_operationBtn setTitle:NSLocalizedString(@"抵押1", nil) forState:UIControlStateNormal];
            
        }else if (self.detailView.stakeBtn.selected == NO && self.detailView.reclaimBtn.selected == YES){
            //reclaim
            [_operationBtn setTitle:NSLocalizedString(@"赎回1", nil) forState:UIControlStateNormal];
            
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
    _titlelabel.text = NSLocalizedString(@"带宽", nil);
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
EOS抵押/赎回 *************************************************************************
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
                    NSLog(@"get_block_info_success:%@, %@---%@-%@", weakSelf.expiration , weakSelf.ref_block_num, weakSelf.ref_block_prefix, model.head_block_time);
                    
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

#pragma mark -


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
            handler(responseObject);
            /*
            NSString *from = VALIDATE_STRING(weakSelf.wallet.address);
            if (weakSelf.detailView.stakeBtn.selected == YES && weakSelf.detailView.reclaimBtn.selected == NO) {
                NSString *to = weakSelf.stakeView.accountTextField.text;
                [NetManager AddTradeWithuserName:[CreateAll GetCurrentUserName] TradeAmount:weakSelf.eosamount Poundage:0 CoinCode:@"EOS" From:VALIDATE_STRING(from) To:VALIDATE_STRING(to) CompletionHandler:^(id responseObj, NSError *error) {
                    
                }];
            }else if (weakSelf.detailView.stakeBtn.selected == NO && weakSelf.detailView.reclaimBtn.selected == YES){
                CGFloat amountsum = weakSelf.reclaimView.cpuTextField.text.doubleValue + weakSelf.reclaimView.netTextField.text.doubleValue;
                [NetManager AddTradeWithuserName:[CreateAll GetCurrentUserName] TradeAmount:amountsum Poundage:0 CoinCode:@"EOS" From:VALIDATE_STRING(from) To:VALIDATE_STRING(from) CompletionHandler:^(id responseObj, NSError *error) {
                    
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
    NSString *to = self.stakeView.accountTextField.text;
//    NSString *memo = @"";
    // 交易JSON序列化
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    [params setObject: @"eosio" forKey:@"code"];
//    抵押/赎回
    if (self.detailView.stakeBtn.selected == YES && self.detailView.reclaimBtn.selected == NO) {
        [params setObject:@"delegatebw" forKey:@"action"];
    }else if(self.detailView.stakeBtn.selected == NO && self.detailView.reclaimBtn.selected == YES){
        [params setObject:@"undelegatebw" forKey:@"action"];
    }
    if (self.detailView.stakeBtn.selected == YES && self.detailView.reclaimBtn.selected == NO) {
        [args setObject:VALIDATE_STRING(from) forKey:@"from"];
        [args setObject:VALIDATE_STRING(to) forKey:@"receiver"];
        [args setObject:[NSString stringWithFormat:@"%.4f %@",self.eosamount*self.gasView.gasSlider.value,self.wallet.coinType == EOS ? @"EOS" : @"MGP"] forKey:@"stake_cpu_quantity"];
        [args setObject:[NSString stringWithFormat:@"%.4f %@",self.eosamount*(1.0 -self.gasView.gasSlider.value),self.wallet.coinType == EOS ? @"EOS" : @"MGP"] forKey:@"stake_net_quantity"];
        [args setObject:@"0" forKey:@"transfer"];
    }else if (self.detailView.stakeBtn.selected == NO && self.detailView.reclaimBtn.selected == YES){
        [args setObject:VALIDATE_STRING(from) forKey:@"from"];
        [args setObject:VALIDATE_STRING(from) forKey:@"receiver"];
        [args setObject:[NSString stringWithFormat:@"%.4f %@",self.reclaimView.cpuTextField.text.doubleValue,self.wallet.coinType == EOS ? @"EOS" : @"MGP"] forKey:@"unstake_cpu_quantity"];
        [args setObject:[NSString stringWithFormat:@"%.4f %@",self.reclaimView.netTextField.text.doubleValue,self.wallet.coinType == EOS ? @"EOS" : @"MGP"] forKey:@"unstake_net_quantity"];
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
    if (self.detailView.stakeBtn.selected == YES && self.detailView.reclaimBtn.selected == NO) {
        [actionDict setObject:@"delegatebw" forKey:@"name"];
    }else if(self.detailView.stakeBtn.selected == NO && self.detailView.reclaimBtn.selected == YES){
        [actionDict setObject:@"undelegatebw" forKey:@"name"];
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
    if (self.detailView.stakeBtn.selected == YES && self.detailView.reclaimBtn.selected == NO) {
        [actionDict setObject:@"delegatebw" forKey:@"name"];
    }else if(self.detailView.stakeBtn.selected == NO && self.detailView.reclaimBtn.selected == YES){
        [actionDict setObject:@"undelegatebw" forKey:@"name"];
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
