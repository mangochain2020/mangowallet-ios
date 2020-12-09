//
//  TransactionRecordDetailVC.m
//  TaiYiToken
//
//  Created by admin on 2018/9/18.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "TransactionRecordDetailVC.h"
#import "TransactionDetailView.h"
#import "USDTTxDetailModel.h"
#import "WebVC.h"
@interface TransactionRecordDetailVC ()
@property(nonatomic,strong) UIButton *backBtn;
@property(nonatomic)UILabel *titleLabel;
@property(nonatomic)TransactionDetailView *detailView;
@property(nonatomic)NSDateFormatter* formatter;
@property(nonatomic,strong)UIImageView *QRcodeIV;
@property(nonatomic,copy)NSString *misurlstr;
@end

@implementation TransactionRecordDetailVC
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
    self.title = NSLocalizedString(@"交易记录详情", nil);

    self.formatter = [[NSDateFormatter alloc] init];
    [_formatter setDateStyle:NSDateFormatterMediumStyle];
    [_formatter setTimeStyle:NSDateFormatterShortStyle];
    [_formatter setDateFormat:@"yyyy/MM/dd \nHH:mm:ss"];
    
    
    if (self.wallet.coinType == BTC || self.wallet.coinType == BTC_TESTNET) {
        [self BTCRecordToView];
    }else if (self.wallet.coinType == ETH){
        [self ETHRecordToView];
    }else if (self.wallet.coinType == MIS){
        [self MISRecordToView];
    }else if (self.wallet.coinType == EOS){
        [self EOSRecordToView];
    }else if (self.wallet.coinType == MGP){
        [self EOSRecordToView];
    }else if (self.wallet.coinType == USDT){
        [self USDTRecordToView];
    }
}

//点击复制地址
-(void)copyAddress:(UIButton *)btn{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = btn.tag == 0?VALIDATE_STRING(self.toAddress):VALIDATE_STRING(self.fromAddress);
    [self.view showMsg:NSLocalizedString(@"地址已复制", nil)];
    NSLog(@"addressBtn %ld %@",btn.tag,pasteboard.string);
    
}

-(void)USDTRecordToView{
    MJWeakSelf
    [NetManager GetUSDTTxDetail:VALIDATE_STRING(self.usdtRecord.txid) CompletionHandler:^(id responseObj, NSError *error) {
        if (!error) {
            
            USDTTxDetailModel *model = [USDTTxDetailModel parse:responseObj];
            
            dispatch_async_on_main_queue(^{
                weakSelf.detailView = [TransactionDetailView new];
                [weakSelf.view addSubview:weakSelf.detailView];
                [weakSelf.detailView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(6);
                    make.left.right.equalTo(0);
                    make.bottom.equalTo(-30);
                }];
                [weakSelf.detailView.iconImageView setImage:[UIImage imageNamed:@"ico_btc"]];
                
                NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:model.blocktime];
                NSString *timeStr=[self.formatter stringFromDate:currentDate];
                [weakSelf.detailView.timelb setText:[NSString stringWithFormat:@"%@",timeStr]];
                
                if (model.type_int == 3) {
                    weakSelf.detailView.resultlb.text = NSLocalizedString(@"转账成功", nil);
                    weakSelf.detailView.amountlb.text = [NSString stringWithFormat:@"-%.8f USDT", model.amount.doubleValue];
                }else if(model.type_int == 0){
                    weakSelf.detailView.resultlb.text = NSLocalizedString(@"收款成功", nil);
                    weakSelf.detailView.amountlb.text = [NSString stringWithFormat:@"+%.8f USDT", model.amount.doubleValue];
                }
                if (model.confirmations <= 0) {
                    weakSelf.detailView.resultlb.text = NSLocalizedString(@"未打包", nil);
                }
                
                //随字符串长度变化字体大小
                NSString *strlen = [NSString stringWithFormat:@"+%.8f USDT", model.amount.doubleValue];
                UIFont *bigfont = [UIFont boldSystemFontOfSize:24.0*16/strlen.length];
                [weakSelf.detailView.amountlb setFont:bigfont];
                
                
                NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.8f BTC\n",model.fee.doubleValue] attributes:@{NSForegroundColorAttributeName:[UIColor textBlackColor], NSFontAttributeName:[UIFont systemFontOfSize:13]}];
                [weakSelf.detailView.feelb initWithTitle:NSLocalizedString(@"旷工费用：", nil) Detail:str1];
                
                
                NSTextAttachment * attach = [[NSTextAttachment alloc] init];
                attach.image = [UIImage imageNamed:@"ico_password"];
                attach.bounds = CGRectMake(0, 0, 10, 10);
                NSAttributedString * imageStr = [NSAttributedString attributedStringWithAttachment:attach];
                
                NSMutableAttributedString * to = [[NSMutableAttributedString alloc] initWithString:VALIDATE_STRING(model.referenceaddress)];
                [to appendAttributedString:imageStr];
                [weakSelf.detailView.tolb initWithTitle:NSLocalizedString(@"收款地址：", nil) DetailBtn:to];
                [weakSelf.detailView.tolb.detailbtn addTarget:weakSelf action:@selector(copyAddress:) forControlEvents:UIControlEventTouchUpInside];
                weakSelf.detailView.tolb.detailbtn.tag = 0;
                
                NSMutableAttributedString * from = [[NSMutableAttributedString alloc] initWithString:VALIDATE_STRING(model.sendingaddress)];
                [from appendAttributedString:imageStr];
                [weakSelf.detailView.fromlb initWithTitle:NSLocalizedString(@"付款地址：", nil) DetailBtn:from];
                [weakSelf.detailView.fromlb.detailbtn addTarget:weakSelf action:@selector(copyAddress:) forControlEvents:UIControlEventTouchUpInside];
                weakSelf.detailView.fromlb.detailbtn.tag = 1;
                
                [weakSelf.detailView.remarklb initWithTitle:NSLocalizedString(@"备注：", nil) DetailBtn:nil];
                

                NSMutableAttributedString * ethtransactionHashAttr = [[NSMutableAttributedString alloc] initWithString:VALIDATE_STRING(model.txid) attributes:@{NSForegroundColorAttributeName:[UIColor textBlackColor], NSFontAttributeName:[UIFont systemFontOfSize:13]}];
                [weakSelf.detailView.tranNumberlb initWithTitle:NSLocalizedString(@"交易号：", nil) Detail:ethtransactionHashAttr];
                
                
                NSMutableAttributedString * blocknumAttr = [[NSMutableAttributedString alloc] initWithString:VALIDATE_STRING(model.blockhash) attributes:@{NSForegroundColorAttributeName:[UIColor textBlackColor], NSFontAttributeName:[UIFont systemFontOfSize:13]}];
                [weakSelf.detailView.blockNumberlb initWithTitle:NSLocalizedString(@"区块：", nil) Detail:blocknumAttr];
                
                //https://www.omniexplorer.info/search/318fb016144f3dadb16acf39cd7e00089b808418f1c4b343926af55882824966
                weakSelf.QRcodeIV = [UIImageView new];
                NSString *QRcodeStr = [NSString stringWithFormat:@"https://www.omniexplorer.info/search/%@",model.blockhash];
                weakSelf.misurlstr = QRcodeStr.copy;
                UIImage *qrcode = [CreateAll CreateQRCodeForAddress:QRcodeStr];
                weakSelf.QRcodeIV.image = qrcode;
                [weakSelf.view addSubview:weakSelf.QRcodeIV];
                [weakSelf.QRcodeIV mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(0);
                    make.width.height.equalTo(70);
                    make.bottom.equalTo(-50 - SafeAreaBottomHeight);
                }];
                
                UIButton *searchbtn = [UIButton buttonWithType:UIButtonTypeSystem];
                [searchbtn setTintColor:[UIColor textBlueColor]];
                [searchbtn.titleLabel setFont:[UIFont systemFontOfSize:10]];
                [searchbtn setTitle:NSLocalizedString(@"到omniexplorer去查询详情>>", nil) forState:UIControlStateNormal];
                [searchbtn addTarget:weakSelf action:@selector(gotoOmni) forControlEvents:UIControlEventTouchUpInside];
                [weakSelf.view addSubview:searchbtn];
                [searchbtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(0);
                    make.bottom.equalTo(-30 - SafeAreaBottomHeight);
                    make.height.equalTo(15);
                    make.width.equalTo(180);
                }];
            });
        }else{
            [weakSelf.view showMsg:error.userInfo.description];
        }
    }];
}

-(void)gotoOmni{
    MJWeakSelf
    WebVC *vc = [WebVC new];
    vc.urlstring = weakSelf.misurlstr;
    [weakSelf.navigationController pushViewController:vc animated:YES];
}

-(void)MISRecordToView{
    self.detailView = [TransactionDetailView new];
    [self.view addSubview:self.detailView];
    [_detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(6);
        make.left.right.equalTo(0);
        make.bottom.equalTo(-30);
    }];
    [self.detailView.iconImageView setImage:[UIImage imageNamed:@"ico_mis"]];
    
    NSDate *date = [NSDate dateFromString:_misRecord.block_time];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    NSTimeInterval time = [timeSp doubleValue];
    NSDate *date2=[NSDate dateWithTimeIntervalSince1970:time];
    NSDate *date3 = [date2 dateByAddingHours:8];
    NSString *staartstr=[_formatter stringFromDate:date3];
    [self.detailView.timelb setText:staartstr];

    
    NSString *from = _misRecord.action_trace.act.data.from;
    NSString *to =  _misRecord.action_trace.act.data.to;
    NSString *amount = [_misRecord.action_trace.act.data.quantity componentsSeparatedByString:@" "].firstObject;
    NSString *name = [self.wallet.walletName componentsSeparatedByString:@"_"].lastObject;
    if (amount.doubleValue <= 0) {
        self.detailView.resultlb.text = NSLocalizedString(@"失败", nil);
    }else{
        if ([to isEqualToString:name]) {
            self.detailView.resultlb.text = NSLocalizedString(@"收款成功", nil);
             _detailView.amountlb.text = [NSString stringWithFormat:@"+%@ MIS", amount];
           
        }else if([from isEqualToString:name]){
            self.detailView.resultlb.text = NSLocalizedString(@"转账成功", nil);
            _detailView.amountlb.text = [NSString stringWithFormat:@"-%@ MIS", amount];
        }else{
            _detailView.amountlb.text = [NSString stringWithFormat:@"0.00000  MIS"];
        }
    }
    //
   
   // [_detailView.feelb initWithTitle:NSLocalizedString(@"", nil) Detail:@""];
    
    
    NSTextAttachment * attach = [[NSTextAttachment alloc] init];
    attach.image = [UIImage imageNamed:@"ico_password"];
    attach.bounds = CGRectMake(0, 0, 10, 10);
    NSAttributedString * imageStr = [NSAttributedString attributedStringWithAttachment:attach];
    
    NSMutableAttributedString * toaddress = [[NSMutableAttributedString alloc] initWithString:VALIDATE_STRING(self.toAddress)];
    [toaddress appendAttributedString:imageStr];
    
    [_detailView.tolb initWithTitle:NSLocalizedString(@"收款地址：", nil) DetailBtn:toaddress];
    [_detailView.tolb.detailbtn addTarget:self action:@selector(copyAddress:) forControlEvents:UIControlEventTouchUpInside];
    _detailView.tolb.detailbtn.tag = 0;
    
    NSMutableAttributedString * fromaddress = [[NSMutableAttributedString alloc] initWithString:VALIDATE_STRING(self.fromAddress)];
    [fromaddress appendAttributedString:imageStr];
    [_detailView.fromlb initWithTitle:NSLocalizedString(@"付款地址：", nil) DetailBtn:fromaddress];
    [_detailView.fromlb.detailbtn addTarget:self action:@selector(copyAddress:) forControlEvents:UIControlEventTouchUpInside];
    _detailView.fromlb.detailbtn.tag = 1;
    
    NSMutableAttributedString * memo = [[NSMutableAttributedString alloc] initWithString:VALIDATE_STRING(self.misRecord.action_trace.act.data.memo)];
    [_detailView.remarklb initWithTitle:NSLocalizedString(@"备注：", nil) DetailBtn:memo];
    
    NSString *btctxid = self.misRecord.action_trace.trx_id;
    NSMutableAttributedString * ethtransactionHashAttr = [[NSMutableAttributedString alloc] initWithString:VALIDATE_STRING(btctxid) attributes:@{NSForegroundColorAttributeName:[UIColor textBlackColor], NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    [_detailView.tranNumberlb initWithTitle:NSLocalizedString(@"交易号：", nil) Detail:ethtransactionHashAttr];
    
    NSString *blocknum = [NSString stringWithFormat:@"%ld\n", self.misRecord.block_num];
    NSMutableAttributedString * blocknumAttr = [[NSMutableAttributedString alloc] initWithString:VALIDATE_STRING(blocknum) attributes:@{NSForegroundColorAttributeName:[UIColor textBlackColor], NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    [_detailView.blockNumberlb initWithTitle:NSLocalizedString(@"区块：", nil) Detail:blocknumAttr];
    
    SystemInitModel *model = [CreateAll GetSystemData];
    NSString *misurl = model.misChainBrowser;
    if (!misurl) {
        return;
    }
    //http://122.112.203.124:8080/#/transactions/d2a828e9ab8e82d02fcf63abf87fc79cc28b637b99890e11d7ba038b318d2758
    self.misurlstr = [NSString stringWithFormat:@"%@/#/transactions/%@",misurl,self.misRecord.action_trace.trx_id];
    _QRcodeIV = [UIImageView new];
    NSString *QRcodeStr = self.misurlstr;
    UIImage *qrcode = [CreateAll CreateQRCodeForAddress:QRcodeStr];
    _QRcodeIV.image = qrcode;
    [self.view addSubview:_QRcodeIV];
    [_QRcodeIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.width.height.equalTo(70);
        make.bottom.equalTo(-50 - SafeAreaBottomHeight);
    }];
    
    UIButton *searchbtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [searchbtn setTintColor:[UIColor textBlueColor]];
    [searchbtn.titleLabel setFont:[UIFont systemFontOfSize:10]];
    [searchbtn setTitle:NSLocalizedString(@"到mgpchain去查询详情>>", nil) forState:UIControlStateNormal];
    [searchbtn addTarget:self action:@selector(gotoMisChain) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchbtn];
    [searchbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.bottom.equalTo(-30 - SafeAreaBottomHeight);
        make.height.equalTo(15);
        make.width.equalTo(180);
    }];
}

-(void)gotoMisChain{
    WebVC *vc = [WebVC new];
    vc.urlstring = self.misurlstr;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)gotoEosio{
    WebVC *vc = [WebVC new];
    vc.urlstring = self.misurlstr;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)EOSRecordToView{
    self.detailView = [TransactionDetailView new];
    [self.view addSubview:self.detailView];
    [_detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(6);
        make.left.right.equalTo(0);
        make.bottom.equalTo(-30);
    }];
    [self.detailView.iconImageView setImage:[UIImage imageNamed:self.wallet.coinType == MGP?@"ico_mis":@"ico_eos"]];
    
    NSDate *date = [NSDate dateFromString:_misRecord.block_time];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    NSTimeInterval time = [timeSp doubleValue];
    NSDate *date2=[NSDate dateWithTimeIntervalSince1970:time];
    NSDate *date3 = [date2 dateByAddingHours:8];
    NSString *staartstr=[_formatter stringFromDate:date3];
    [self.detailView.timelb setText:staartstr];
    
    NSString *from = _misRecord.action_trace.act.data.from;
    NSString *to =  _misRecord.action_trace.act.data.to;
    NSString *amount = [_misRecord.action_trace.act.data.quantity componentsSeparatedByString:@" "].firstObject;
    NSString *name = [self.wallet.walletName componentsSeparatedByString:@"_"].lastObject;
    
    if ([@"transfer" containsString:VALIDATE_STRING(_misRecord.action_trace.act.name)]){
        if ([from isEqualToString:name] && [to isEqualToString:name]) {
            _detailView.amountlb.text = [NSString stringWithFormat:@"+%@ %@", amount,self.wallet.coinType == MGP?@"MGP":@"EOS"];
        }else if([from isEqualToString:name]){
            _detailView.amountlb.text = [NSString stringWithFormat:@"-%@ %@", amount,self.wallet.coinType == MGP?@"MGP":@"EOS"];
        }else if([to isEqualToString:name]){
            _detailView.amountlb.text = [NSString stringWithFormat:@"+%@ %@", amount,self.wallet.coinType == MGP?@"MGP":@"EOS"];
        }
    }else if([@"delegatebw" containsString:VALIDATE_STRING(_misRecord.action_trace.act.name)]){
        amount = [NSString stringWithFormat:@"%.4f",([_misRecord.action_trace.act.data.stake_cpu_quantity componentsSeparatedByString:@" "].firstObject.doubleValue+[_misRecord.action_trace.act.data.stake_net_quantity componentsSeparatedByString:@" "].firstObject.doubleValue)];
        _detailView.amountlb.text = [NSString stringWithFormat:@"-%@ %@", amount,self.wallet.coinType == MGP?@"MGP":@"EOS"];
        to = _misRecord.action_trace.act.data.receiver;
    }else if([@"undelegatebw" containsString:VALIDATE_STRING(_misRecord.action_trace.act.name)]){
        amount = [NSString stringWithFormat:@"%.4f",([_misRecord.action_trace.act.data.unstake_cpu_quantity componentsSeparatedByString:@" "].firstObject.doubleValue+[_misRecord.action_trace.act.data.unstake_net_quantity componentsSeparatedByString:@" "].firstObject.doubleValue)];
        _detailView.amountlb.text = [NSString stringWithFormat:@"+%@ %@", amount,self.wallet.coinType == MGP?@"MGP":@"EOS"];
        to = _misRecord.action_trace.act.data.receiver;
    }else if([@"receive-action" containsString:VALIDATE_STRING(_misRecord.action_trace.act.name)]){
        
    }else if([@"send-action" containsString:VALIDATE_STRING(_misRecord.action_trace.act.name)]){
        
    }else if([@"newaccount" containsString:VALIDATE_STRING(_misRecord.action_trace.act.name)]){
        
    }else if([VALIDATE_STRING(_misRecord.action_trace.act.name) containsString:@"buyram"]){
        from = _misRecord.action_trace.act.data.payer;
        amount = [NSString stringWithFormat:@"-%@", _misRecord.action_trace.act.data.quant];
        to = _misRecord.action_trace.act.data.receiver;
        _detailView.amountlb.text = amount;
    }else if([VALIDATE_STRING(_misRecord.action_trace.act.name) containsString:@"sellram"]){
        from = _wallet.address;
        amount = [NSString stringWithFormat:@"-%.4f KB", _misRecord.action_trace.act.data.bytes.doubleValue/1024.0];
        to = _misRecord.action_trace.act.data.account;
        _detailView.amountlb.text = amount;
    }else if([@"dice" containsString:VALIDATE_STRING(_misRecord.action_trace.act.name)]){
        _detailView.amountlb.text = @"+eos";
    }
    
    self.detailView.resultlb.text = VALIDATE_STRING(_misRecord.action_trace.act.name);
    
    NSTextAttachment * attach = [[NSTextAttachment alloc] init];
    attach.image = [UIImage imageNamed:@"ico_password"];
    attach.bounds = CGRectMake(0, 0, 10, 10);
    NSAttributedString * imageStr = [NSAttributedString attributedStringWithAttachment:attach];
    
    NSMutableAttributedString * toaddress = [[NSMutableAttributedString alloc] initWithString:VALIDATE_STRING(to)];
    [toaddress appendAttributedString:imageStr];
    
    [_detailView.tolb initWithTitle:NSLocalizedString(@"收款地址：", nil) DetailBtn:toaddress];
    [_detailView.tolb.detailbtn addTarget:self action:@selector(copyAddress:) forControlEvents:UIControlEventTouchUpInside];
    _detailView.tolb.detailbtn.tag = 0;
    
    NSMutableAttributedString * fromaddress = [[NSMutableAttributedString alloc] initWithString:VALIDATE_STRING(from)];
    [fromaddress appendAttributedString:imageStr];
    [_detailView.fromlb initWithTitle:NSLocalizedString(@"付款地址：", nil) DetailBtn:fromaddress];
    [_detailView.fromlb.detailbtn addTarget:self action:@selector(copyAddress:) forControlEvents:UIControlEventTouchUpInside];
    _detailView.fromlb.detailbtn.tag = 1;
    
    NSMutableAttributedString * memo = [[NSMutableAttributedString alloc] initWithString:VALIDATE_STRING(self.misRecord.action_trace.act.data.memo)];
    [_detailView.remarklb initWithTitle:NSLocalizedString(@"备注：", nil) Detail:memo];
    
    NSString *btctxid = self.misRecord.action_trace.trx_id;
    NSMutableAttributedString * ethtransactionHashAttr = [[NSMutableAttributedString alloc] initWithString:VALIDATE_STRING(btctxid) attributes:@{NSForegroundColorAttributeName:[UIColor textBlackColor], NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    [_detailView.tranNumberlb initWithTitle:NSLocalizedString(@"交易号：", nil) Detail:ethtransactionHashAttr];
    
    NSString *blocknum = [NSString stringWithFormat:@"%ld\n", self.misRecord.block_num];
    NSMutableAttributedString * blocknumAttr = [[NSMutableAttributedString alloc] initWithString:VALIDATE_STRING(blocknum) attributes:@{NSForegroundColorAttributeName:[UIColor textBlackColor], NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    [_detailView.blockNumberlb initWithTitle:NSLocalizedString(@"区块：", nil) Detail:blocknumAttr];
    
    
    
//
    self.misurlstr = self.wallet.coinType == MGP?[NSString stringWithFormat:@"http://explorer.mgpchain.io/transaction/%@",self.misRecord.action_trace.trx_id]:[NSString stringWithFormat:@"https://www.eosx.io/tx/%@",self.misRecord.action_trace.trx_id];
//    self.misurlstr = [NSString stringWithFormat:@"https://eospark.com/tx/%@",self.misRecord.action_trace.trx_id];
    _QRcodeIV = [UIImageView new];
    NSString *QRcodeStr = self.misurlstr;
    UIImage *qrcode = [CreateAll CreateQRCodeForAddress:QRcodeStr];
    _QRcodeIV.image = qrcode;
    [self.view addSubview:_QRcodeIV];
    [_QRcodeIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.width.height.equalTo(70);
        make.bottom.equalTo(-50 - SafeAreaBottomHeight);
    }];
    
    UIButton *searchbtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [searchbtn setTintColor:[UIColor textBlueColor]];
    [searchbtn.titleLabel setFont:[UIFont systemFontOfSize:10]];
    [searchbtn setTitle:NSLocalizedString(self.wallet.coinType == MGP?@"到mgpchain去查询详情":@"到eosx去查询详情", nil) forState:UIControlStateNormal];
    [searchbtn addTarget:self action:@selector(gotoEosio) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchbtn];
    [searchbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.bottom.equalTo(-30 - SafeAreaBottomHeight);
        make.height.equalTo(15);
        make.width.equalTo(180);
    }];
}
-(void)BTCRecordToView{
    self.detailView = [TransactionDetailView new];
    [self.view addSubview:self.detailView];
    [_detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(6);
        make.left.right.equalTo(0);
        make.bottom.equalTo(-30);
    }];
    [self.detailView.iconImageView setImage:[UIImage imageNamed:@"ico_btc"]];

    NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:self.btcRecord.time];
    NSString *timeStr=[_formatter stringFromDate:currentDate];
    [self.detailView.timelb setText:[NSString stringWithFormat:@"%@",timeStr]];
   
    if (_btcRecord.result + _btcRecord.fee == 0) {
         self.detailView.resultlb.text = NSLocalizedString(@"转账成功", nil);
        _detailView.amountlb.text = [NSString stringWithFormat:@"-%.8f BTC", _amount];
    }else{
        if (_btcRecord.result > 0) {//转入
            self.detailView.resultlb.text = NSLocalizedString(@"收款成功", nil);
            _detailView.amountlb.text = [NSString stringWithFormat:@"+%.8f BTC", _amount];
        }else{
            self.detailView.resultlb.text = NSLocalizedString(@"转账成功", nil);
            _detailView.amountlb.text = [NSString stringWithFormat:@"%.8f BTC", _amount];
        }
    }
    if (_btcRecord.block_height <= 0) {
        self.detailView.resultlb.text = NSLocalizedString(@"未打包", nil);
    }
   
    //
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.8f BTC\n",self.btcRecord.fee*1.0/pow(10, 8)] attributes:@{NSForegroundColorAttributeName:[UIColor textBlackColor], NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    [_detailView.feelb initWithTitle:NSLocalizedString(@"旷工费用：", nil) Detail:str1];
    
    
    NSTextAttachment * attach = [[NSTextAttachment alloc] init];
    attach.image = [UIImage imageNamed:@"ico_password"];
    attach.bounds = CGRectMake(0, 0, 10, 10);
    NSAttributedString * imageStr = [NSAttributedString attributedStringWithAttachment:attach];
    
    NSMutableAttributedString * to = [[NSMutableAttributedString alloc] initWithString:VALIDATE_STRING(self.toAddress)];
    [to appendAttributedString:imageStr];
    [_detailView.tolb initWithTitle:NSLocalizedString(@"收款地址：", nil) DetailBtn:to];
    [_detailView.tolb.detailbtn addTarget:self action:@selector(copyAddress:) forControlEvents:UIControlEventTouchUpInside];
    _detailView.tolb.detailbtn.tag = 0;
    
    NSMutableAttributedString * from = [[NSMutableAttributedString alloc] initWithString:VALIDATE_STRING(self.fromAddress)];
    [from appendAttributedString:imageStr];
    [_detailView.fromlb initWithTitle:NSLocalizedString(@"付款地址：", nil) DetailBtn:from];
    [_detailView.fromlb.detailbtn addTarget:self action:@selector(copyAddress:) forControlEvents:UIControlEventTouchUpInside];
    _detailView.fromlb.detailbtn.tag = 1;
    
    [_detailView.remarklb initWithTitle:NSLocalizedString(@"备注：", nil) DetailBtn:nil];
    
    NSString *btctxid = self.btcRecord.hashs;
    NSMutableAttributedString * ethtransactionHashAttr = [[NSMutableAttributedString alloc] initWithString:VALIDATE_STRING(btctxid) attributes:@{NSForegroundColorAttributeName:[UIColor textBlackColor], NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    [_detailView.tranNumberlb initWithTitle:NSLocalizedString(@"交易号：", nil) Detail:ethtransactionHashAttr];
    
    NSString *blocknum = [NSString stringWithFormat:@"%ld\n", self.btcRecord.block_height];
    NSMutableAttributedString * blocknumAttr = [[NSMutableAttributedString alloc] initWithString:VALIDATE_STRING(blocknum) attributes:@{NSForegroundColorAttributeName:[UIColor textBlackColor], NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    [_detailView.blockNumberlb initWithTitle:NSLocalizedString(@"区块：", nil) Detail:blocknumAttr];
    //http://159.138.1.94:3001/insight/tx/a132bb0e9a04d2e1c92a3bc1bcdcfc9eef05275dd77266f4c828f4e0cea4a9dc
    //https://www.blockchain.com/en/btc/tx/3bf7b93e99d37b01dd158767976c945dea9747017620408a5badc3b16412c028
    _QRcodeIV = [UIImageView new];
    NSString *QRcodeStr = [NSString stringWithFormat:@"https://www.blockchain.com/en/btc/tx/%@",self.btcRecord.hashs];
    UIImage *qrcode = [CreateAll CreateQRCodeForAddress:QRcodeStr];
    _QRcodeIV.image = qrcode;
    [self.view addSubview:_QRcodeIV];
    [_QRcodeIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.width.height.equalTo(70);
        make.bottom.equalTo(-50 - SafeAreaBottomHeight);
    }];
    
    UIButton *searchbtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [searchbtn setTintColor:[UIColor textBlueColor]];
    [searchbtn.titleLabel setFont:[UIFont systemFontOfSize:10]];
    [searchbtn setTitle:NSLocalizedString(@"到blockchain去查询详情>>", nil) forState:UIControlStateNormal];
    [searchbtn addTarget:self action:@selector(gotoblockchain) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchbtn];
    [searchbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.bottom.equalTo(-30 - SafeAreaBottomHeight);
        make.height.equalTo(15);
        make.width.equalTo(180);
    }];
}

-(void)gotoblockchain{
    WebVC *vc = [WebVC new];
    vc.urlstring = [NSString stringWithFormat:@"https://www.blockchain.com/en/btc/tx/%@",self.btcRecord.hashs];//http://159.138.1.94:3001/insight/tx
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)ETHRecordToView{
    ETHTransactionRecordModel *info = self.ethRecord;
   
    
    CGFloat amount = info.value.integerValue * 1.0 / pow(10, 18);
    self.detailView = [TransactionDetailView new];
    [self.detailView.iconImageView setImage:[UIImage imageNamed:@"ico_eth-1"]];
    [self.view addSubview:self.detailView];
    [_detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(6);
        make.left.right.equalTo(0);
        make.bottom.equalTo(-30);
    }];
    
    //
    CGFloat gwei = info.gasPrice.integerValue *1.0 / pow(10,9);
    NSInteger gasused =  info.gasUsed.integerValue;
    CGFloat gasfee = (gwei * gasused)*1.0/pow(10,9);
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.7f ETH\n≈Gas(%ld) * GasPrice(%.2f gwei)",gasfee,gasused,gwei] attributes:@{NSForegroundColorAttributeName:[UIColor textBlackColor], NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor textLightGrayColor] range:NSMakeRange(13, str1.length - 13)];
    [_detailView.feelb initWithTitle:NSLocalizedString(@"旷工费用：", nil) Detail:str1];
    
    NSTextAttachment * attach = [[NSTextAttachment alloc] init];
    attach.image = [UIImage imageNamed:@"ico_password"];
    attach.bounds = CGRectMake(0, 0, 10, 10);
    NSAttributedString * imageStr = [NSAttributedString attributedStringWithAttachment:attach];
    
    NSMutableAttributedString * to =  [[NSMutableAttributedString alloc] initWithString:VALIDATE_STRING(self.toAddress) attributes:@{NSForegroundColorAttributeName:[UIColor textBlackColor], NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    [to appendAttributedString:imageStr];
    [_detailView.tolb initWithTitle:NSLocalizedString(@"收款地址：", nil) DetailBtn:to];
    [_detailView.tolb.detailbtn addTarget:self action:@selector(copyAddress:) forControlEvents:UIControlEventTouchUpInside];
    _detailView.tolb.detailbtn.tag = 0;
    
    NSMutableAttributedString * from = [[NSMutableAttributedString alloc] initWithString:VALIDATE_STRING(self.fromAddress) attributes:@{NSForegroundColorAttributeName:[UIColor textBlackColor], NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    [from appendAttributedString:imageStr];
    [_detailView.fromlb initWithTitle:NSLocalizedString(@"付款地址：", nil) DetailBtn:from];
    [_detailView.fromlb.detailbtn addTarget:self action:@selector(copyAddress:) forControlEvents:UIControlEventTouchUpInside];
    _detailView.fromlb.detailbtn.tag = 1;
    
    [_detailView.remarklb initWithTitle:NSLocalizedString(@"备注：", nil) DetailBtn:nil];
    
    NSString *ethtransactionHash = info.blockHash;
    NSMutableAttributedString * ethtransactionHashAttr = [[NSMutableAttributedString alloc] initWithString:VALIDATE_STRING(ethtransactionHash) attributes:@{NSForegroundColorAttributeName:[UIColor textBlackColor], NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    [_detailView.tranNumberlb initWithTitle:NSLocalizedString(@"交易号：", nil) Detail:ethtransactionHashAttr];
    
    NSString *blocknum = [NSString stringWithFormat:@"%ld\n", [info.blockNumber integerValue]];
    NSMutableAttributedString * blocknumAttr = [[NSMutableAttributedString alloc] initWithString:VALIDATE_STRING(blocknum) attributes:@{NSForegroundColorAttributeName:[UIColor textBlackColor], NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    [_detailView.blockNumberlb initWithTitle:NSLocalizedString(@"区块：", nil) Detail:blocknumAttr];
    //https://etherscan.io/tx/0x40eb908387324f2b575b4879cd9d7188f69c8fc9d87c901b9e2daaea4b442170
    _QRcodeIV = [UIImageView new];
    NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:[info.timeStamp integerValue]];
    NSString *timeStr=[_formatter stringFromDate:currentDate];
    [self.detailView.timelb setText:[NSString stringWithFormat:@"%@",timeStr]];
    
    BOOL isScurre = [info.to isEqualToString:[@"" stringToLower:[MGPHttpRequest shareManager].curretWallet.address]];
    
    NSString *str = isScurre ? @"+" : @"-";
    self.detailView.amountlb.text = [NSString stringWithFormat:@"%@%.5f",str, amount];

    //判断交易是否有错
    if (![info.isError boolValue]) {
        self.detailView.resultlb.text = isScurre ? NSLocalizedString(@"收款成功", nil):NSLocalizedString(@"转账成功", nil);
        [self.detailView.resultlb setTextColor:[UIColor textGrayColor]];

        
    }else{
        self.detailView.resultlb.text = isScurre ? NSLocalizedString(@"收款失败", nil):NSLocalizedString(@"转账失败", nil);
        [self.detailView.resultlb setTextColor:[UIColor redColor]];
        
    }
    
    
    
    /*
    if ([info.blockNumber integerValue] < 1) {
        self.detailView.resultlb.text = NSLocalizedString(@"未打包", nil);
        self.detailView.amountlb.text = [NSString stringWithFormat:@"+%.5f ETH", amount];
        if (self.ethRecord.selectType == IN_Trans) {
            self.detailView.amountlb.text = [NSString stringWithFormat:@"+%.5f ETH", amount];
        }else if(self.ethRecord.selectType == OUT_Trans){
            self.detailView.amountlb.text = [NSString stringWithFormat:@"-%.5f ETH", amount];
        }else if(self.ethRecord.selectType == SELF_Trans){
            self.detailView.amountlb.text = [NSString stringWithFormat:@"%.5f ETH", amount];
        }
    }else{
        [self.view showHUD];
        [NetManager VerifyIFAddressIsContract:[_wallet.address isEqualToString:_fromAddress]?_toAddress:_fromAddress completionHandler:^(id responseObj, NSError *error) {
            
            if (!error) {
                if (responseObj == nil) {
                    return ;
                }
                id ddd = responseObj[@"result"];
                if([ddd isEqual:[NSNull null]] || ddd == nil){
                    return;
                }else{
                    if ([ddd isEqualToString:@"Contract source code not verified"]) {//普通地址
                        [NetManager GetETHTraRecordStatusWithHash:self.ethRecord.info.transactionHash.hexString Check:NO completionHandler:^(id responseObj, NSError *error) {
                            [self.view hideHUD];
                            if (!error) {
                                if (responseObj == nil) {
                                    return ;
                                }
                                id ddd = responseObj[@"result"];
                                if([ddd isEqual:[NSNull null]] || ddd == nil){
                                    return;
                                }else{
                                    NSString *status = [ddd objectForKey:@"status"];
                                    if ([status isEqualToString:@"1"]) {
                                        if (self.ethRecord.selectType == IN_Trans) {
                                            self.detailView.resultlb.text = NSLocalizedString(@"收款成功", nil);
                                            self.detailView.amountlb.text = [NSString stringWithFormat:@"+%.5f ETH", amount];
                                        }else if(self.ethRecord.selectType == OUT_Trans){
                                            self.detailView.resultlb.text = NSLocalizedString(@"转账成功", nil);
                                            self.detailView.amountlb.text = [NSString stringWithFormat:@"-%.5f ETH", amount];
                                        }else if(self.ethRecord.selectType == SELF_Trans){
                                            self.detailView.resultlb.text = NSLocalizedString(@"转账/收款成功", nil);
                                            self.detailView.amountlb.text = [NSString stringWithFormat:@"%.5f ETH", amount];
                                        }
                                    }else if ([status isEqualToString:@"0"]){
                                        if (self.ethRecord.selectType == IN_Trans) {
                                            self.detailView.resultlb.text = NSLocalizedString(@"收款失败", nil);
                                            self.detailView.amountlb.text = [NSString stringWithFormat:@"+%.5f ETH", amount];
                                        }else if(self.ethRecord.selectType == OUT_Trans){
                                            self.detailView.resultlb.text = NSLocalizedString(@"转账失败", nil);
                                            self.detailView.amountlb.text = [NSString stringWithFormat:@"-%.5f ETH", amount];
                                        }else if(self.ethRecord.selectType == SELF_Trans){
                                            self.detailView.resultlb.text = NSLocalizedString(@"转账/收款失败", nil);
                                            self.detailView.amountlb.text = [NSString stringWithFormat:@"%.5f ETH", amount];
                                        }
                                    }
                                    
                                }
                            }else{
                                [self.view showAlert:[NSString stringWithFormat:@"Error:%ld",error.code] DetailMsg:error.localizedDescription];
                            }
                            
                            
                        }];
                    }else{//合约地址
                        [NetManager GetETHTraRecordStatusWithHash:self.ethRecord.info.transactionHash.hexString Check:YES completionHandler:^(id responseObj, NSError *error) {
                            [self.view hideHUD];
                            if (!error) {
                                if (responseObj == nil) {
                                    return ;
                                }
                                id ddd = responseObj[@"result"];
                                if([ddd isEqual:[NSNull null]] || ddd == nil){
                                    return;
                                }else{
                                    NSString *status = [ddd objectForKey:@"isError"];
                                    if ([status isEqualToString:@"0"]) {
                                        self.detailView.resultlb.text = NSLocalizedString(@"合约调用成功", nil);
                                        self.detailView.amountlb.text = [NSString stringWithFormat:@"-%.5f ETH", amount];
                                    }else if ([status isEqualToString:@"1"]){
                                        self.detailView.resultlb.text = NSLocalizedString(@"合约调用失败", nil);
                                        self.detailView.amountlb.text = [NSString stringWithFormat:@"-%.5f ETH", amount];
                                    }
                                }
                            }else{
                                [self.view showAlert:[NSString stringWithFormat:@"Error:%ld",error.code] DetailMsg:error.localizedDescription];
                            }
                        }];
                    }
                }
            }else{
                [self.view showAlert:[NSString stringWithFormat:@"Error:%ld",error.code] DetailMsg:error.localizedDescription];
            }
        }];
    }
    */
    
    NSString *QRcodeStr = [NSString stringWithFormat:@"https://etherscan.io/tx/%@",self.ethRecord.info.transactionHash.hexString];
    UIImage *qrcode = [CreateAll CreateQRCodeForAddress:QRcodeStr];
    _QRcodeIV.image = qrcode;
    [self.view addSubview:_QRcodeIV];
    [_QRcodeIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.width.height.equalTo(70);
        make.bottom.equalTo(-50 - SafeAreaBottomHeight);
    }];
    
    UIButton *searchbtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [searchbtn setTintColor:[UIColor textBlueColor]];
    [searchbtn.titleLabel setFont:[UIFont systemFontOfSize:10]];
    [searchbtn setTitle:NSLocalizedString(@"到Etherscan去查询详情>>", nil) forState:UIControlStateNormal];
    [searchbtn addTarget:self action:@selector(gotoEtherscan) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchbtn];
    [searchbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.bottom.equalTo(-30 - SafeAreaBottomHeight);
        make.height.equalTo(15);
        make.width.equalTo(180);
    }];
    
    UILabel *label = [UILabel new];
    label.text = @"Powered by Etherscan.io APIs";
    label.textColor = [UIColor textGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.height.equalTo(20);
        make.bottom.equalTo(-5 - SafeAreaBottomHeight);
    }];
   
  
   
}

-(void)gotoEtherscan{
    WebVC *vc = [WebVC new];
//    https://etherscan.io/tx/0x40eb908387324f2b575b4879cd9d7188f69c8fc9d87c901b9e2daaea4b442170
    vc.urlstring = [NSString stringWithFormat:@"https://etherscan.io/tx/%@",self.ethRecord.info.transactionHash.hexString];
    [self.navigationController pushViewController:vc animated:YES];
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
    
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont boldSystemFontOfSize:17];
    _titleLabel.textColor = [UIColor textBlackColor];
    [_titleLabel setText:NSLocalizedString(@"交易记录详情", nil)];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(SafeAreaTopHeight - 31);
        make.left.equalTo(45);
        make.width.equalTo(200);
        make.height.equalTo(20);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
