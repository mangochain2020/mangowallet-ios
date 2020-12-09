//
//  WalletDetailVC.m
//  TaiYiToken
//
//  Created by Frued on 2018/10/22.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "WalletDetailVC.h"
#import "WBQRCodeVC.h"
#import "WalletDetailView.h"
#import "NewBaseInfoModel.h"
#import "DetailBtnsView.h"
#import "TransactionVC.h"
#import "ReceiptQRCodeVC.h"
#import "ExportWalletVC.h"
#import "BTCTransactionRecordModel.h"
#import "ETHTransactionRecordModel.h"
#import "TransactionRecordDetailVC.h"
#import "TransactionRecordCell.h"
#import "VTwoMarketDetailVC.h"
#import "ETHPendingRecordModel.h"
#import "BTCBlockChainListModel.h"
#import "USDTTxListModel.h"
#define BTCRecordListPageSize 20

@interface WalletDetailVC ()<UIImagePickerControllerDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIView *bridgeContentView;
@property(nonatomic,strong) UIButton *backBtn;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIButton *scanBtn;
@property(nonatomic,strong)WalletDetailView *detailview;
@property (strong, nonatomic)NewBaseInfoModel *baseInfoModel;
@property (strong, nonatomic)DetailBtnsView *detailbtnsview;
//
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic)int page;
@property(nonatomic,strong)NSMutableArray <Tx *>*btcRecordArray;
@property(nonatomic,strong)NSMutableArray <ETHTransactionRecordModel *>*ethRecordArray;
@property(nonatomic,strong)NSMutableArray <USDTTxListData *>*usdtRecordArray;
@property(nonatomic,strong)NSDateFormatter* formatter;

@end

@implementation WalletDetailVC
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
    
    self.formatter = [[NSDateFormatter alloc] init];
    [_formatter setDateStyle:NSDateFormatterMediumStyle];
    [_formatter setTimeStyle:NSDateFormatterShortStyle];
    [_formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    self.view.backgroundColor = [UIColor ExportBackgroundColor];
    [self scrollView];
    self.title = _wallet.walletName;
//    [self initHeadView];
//    [self GetBaseInfo];
    [self detailview];
    [self detailbtnsview];

    if (self.wallet.coinType == BTC || self.wallet.coinType == BTC_TESTNET) {
        self.btcRecordArray = [NSMutableArray new];
        MJWeakSelf
        [self.scrollView addHeaderRefresh:^{
            [weakSelf.btcRecordArray removeAllObjects];
            weakSelf.page = 0;
            NSString *addr;
            if (weakSelf.wallet.changeAddressArray != nil && weakSelf.wallet.changeAddressArray.count > 0) {
                addr = [self.wallet.changeAddressStr stringByReplacingOccurrencesOfString:@"," withString:@"|"];
                NSLog(@"addr %@",addr);
            }else{
                addr = self.wallet.address;
            }
            [NetManager GetBTCTxFromBlockChainAddress:addr PageSize:BTCRecordListPageSize Offset:0 completionHandler:^(id responseObj, NSError *error) {
                [weakSelf.scrollView endHeaderRefresh];
                if (error) {
                    [weakSelf.view showAlert:[NSString stringWithFormat:@"Error:%ld",error.code] DetailMsg:error.localizedDescription];
                }else{
                    weakSelf.page ++;
                    if (responseObj) {
                        BTCBlockChainListModel *model = [BTCBlockChainListModel parse:responseObj];
                        NSArray *txsarr = responseObj[@"txs"];
                        NSMutableArray *arrcopyx = [NSMutableArray new];
                        for (NSInteger index = 0; index < txsarr.count && index < model.txs.count; index++) {
                            Tx *tx = model.txs[index];
                            NSDictionary *txdic = txsarr[index];
                            tx.hashs = (NSString *)(txdic[@"hash"]);
                            tx.outputs = [Output parse:txdic[@"out"] ];
                            [arrcopyx addObject:tx];
                        }
                        weakSelf.btcRecordArray = [arrcopyx mutableCopy];
                        NSMutableArray *arrCopy = [weakSelf.btcRecordArray mutableCopy];
                        if (arrCopy == nil || !arrCopy || arrCopy.count == 0) {
                            return ;
                        }
                        for (int i = 0;i<arrCopy.count-1;i++) {
                            Tx *modelx = arrCopy[i];
                            if (modelx) {
                                NSLog(@"%ld",modelx.time);
                            }
                            for (int j = i+1;j<arrCopy.count;j++) {
                                Tx *modely = arrCopy[j];
                                if ([modelx.hashs isEqualToString:modely.hashs]) {
                                    [weakSelf.btcRecordArray removeObject:modely];
                                }
                            }
                        }
                        [weakSelf.btcRecordArray sortUsingComparator:^NSComparisonResult(BTCTransactionRecordModel * obj1,BTCTransactionRecordModel * obj2) {
                            return obj1.time < obj2.time;
                        }];
                        dispatch_async_on_main_queue(^{
                            [weakSelf.tableView reloadData];
                        });
                    }
                }
            }];
            
        }];
        
        [self.scrollView addFooterRefresh:^{
//            weakSelf.page ++;
            NSString *addr;
            if (weakSelf.wallet.changeAddressArray != nil && weakSelf.wallet.changeAddressArray.count > 0) {
                addr = [self.wallet.changeAddressStr stringByReplacingOccurrencesOfString:@"," withString:@"|"];
            }else{
                addr = self.wallet.address;
            }
            [NetManager GetBTCTxFromBlockChainAddress:addr PageSize:BTCRecordListPageSize Offset:BTCRecordListPageSize*weakSelf.page completionHandler:^(id responseObj, NSError *error) {
                [weakSelf.scrollView endFooterRefresh];
                if (error) {
                    [weakSelf.view showAlert:[NSString stringWithFormat:@"Error:%ld",error.code] DetailMsg:error.localizedDescription];
                }else{
                    weakSelf.page ++;
                    if (responseObj) {
                        BTCBlockChainListModel *model = [BTCBlockChainListModel parse:responseObj];
                        NSArray *txsarr = responseObj[@"txs"];
                        NSMutableArray *arrcopyx = [NSMutableArray new];
                        for (NSInteger index = 0; index < txsarr.count && index < model.txs.count; index++) {
                            Tx *tx = model.txs[index];
                            NSDictionary *txdic = txsarr[index];
                            tx.hashs = (NSString *)(txdic[@"hash"]);
                            tx.outputs = [Output parse:txdic[@"out"] ];
                            [arrcopyx addObject:tx];
                        }
                        
                        [weakSelf.btcRecordArray addObjectsFromArray:arrcopyx];
                        NSMutableArray *arrCopy = [weakSelf.btcRecordArray mutableCopy];
                        if (arrCopy == nil || !arrCopy || arrCopy.count == 0) {
                            return ;
                        }
                        for (int i = 0;i<arrCopy.count-1;i++) {
                            Tx *modelx = arrCopy[i];
                            if (modelx) {
                                NSLog(@"%ld",modelx.time);
                            }
                            for (int j = i+1;j<arrCopy.count;j++) {
                                Tx *modely = arrCopy[j];
                                if ([modelx.hashs isEqualToString:modely.hashs]) {
                                    [weakSelf.btcRecordArray removeObject:modely];
                                }
                            }
                        }
                        [weakSelf.btcRecordArray sortUsingComparator:^NSComparisonResult(BTCTransactionRecordModel * obj1,BTCTransactionRecordModel * obj2) {
                            return obj1.time < obj2.time;
                        }];
                        dispatch_async_on_main_queue(^{
                            [weakSelf.tableView reloadData];
                        });
                    }
                }
            }];
            

        }];
        [self.scrollView beginHeaderRefresh];
    }else if (self.wallet.coinType == ETH){
        self.ethRecordArray = [NSMutableArray new];
        MJWeakSelf
        [self.scrollView addHeaderRefresh:^{
            //weakSelf.wallet.address
            
            [CreateAll GetTransactionsForAddress:weakSelf.wallet.address startBlockTag:999999 Callback:^(ArrayPromise *promiseArray) {
                [weakSelf.scrollView endHeaderRefresh];
                [weakSelf.ethRecordArray removeAllObjects];
                [weakSelf QueryETHPendingTxs];
                if (!promiseArray.error) {
                    
                    NSInteger num = 0;
                    for (TransactionInfo *info in promiseArray.value) {
                        if (num <= 20) {
                            num ++;
                        }else{
                            break;
                        }
                        ETHTransactionRecordModel *model = [ETHTransactionRecordModel new];
                        model.info = info;
                        if ([info.fromAddress.checksumAddress isEqual:weakSelf.wallet.address]) {
                            model.selectType = OUT_Trans;
                        }
                        if ([info.toAddress.checksumAddress isEqual:weakSelf.wallet.address]){
                            model.selectType = IN_Trans;
                        }
                        if ([info.fromAddress.checksumAddress isEqual:weakSelf.wallet.address] && [info.toAddress.checksumAddress isEqual:weakSelf.wallet.address]) {
                            model.selectType = SELF_Trans;
                        }
                        if (info.gasLimit.integerValue * info.gasPrice.integerValue <= 0 || info.gasUsed.integerValue <= 0) {
                            model.selectType = FAILD_Trans;
                        }
                        [weakSelf.ethRecordArray addObject:model];
                        
                    }
                    NSMutableArray *arrCopy = [weakSelf.ethRecordArray mutableCopy];
                    if (arrCopy == nil || !arrCopy || arrCopy.count == 0) {
                        return ;
                    }
                    for (int i = 0;i<arrCopy.count-1;i++) {
                        
                        ETHTransactionRecordModel *modelx = arrCopy[i];
                        if (modelx) {
                           // NSLog(@"%ld",modelx.info.timestamp);
                        }
                        for (int j = i+1;j<arrCopy.count;j++) {
                            ETHTransactionRecordModel *modely = arrCopy[j];
                            if ([modelx.info.transactionHash.hexString isEqualToString:modely.info.transactionHash.hexString]) {
                                modelx.selectType = IN_Trans;
                                modely.selectType = OUT_Trans;
                            }
                        }
                    }
                    [weakSelf.ethRecordArray sortUsingComparator:^NSComparisonResult(ETHTransactionRecordModel * obj1,ETHTransactionRecordModel * obj2) {
                        return obj1.info.timestamp < obj2.info.timestamp;
                    }];
                    dispatch_async_on_main_queue(^{
                        [weakSelf.tableView reloadData];
                    });
                   
                }else{
                    [weakSelf.view showAlert:@"error!" DetailMsg:promiseArray.error.description];
                }
            }];
            
        }];
        [self.scrollView addFooterRefresh:^{
            //weakSelf.wallet.address
            
            [CreateAll GetTransactionsForAddress:weakSelf.wallet.address startBlockTag:BLOCK_TAG_EARLIEST Callback:^(ArrayPromise *promiseArray) {
                [weakSelf.scrollView endFooterRefresh];
                if (!promiseArray.error) {
                    for (TransactionInfo *info in promiseArray.value) {
                        ETHTransactionRecordModel *model = [ETHTransactionRecordModel new];
                        model.info = info;
                        if ([info.fromAddress.checksumAddress isEqual:weakSelf.wallet.address]) {
                            model.selectType = OUT_Trans;
                        }
                        if ([info.toAddress.checksumAddress isEqual:weakSelf.wallet.address]){
                            model.selectType = IN_Trans;
                        }
                        if ([info.fromAddress.checksumAddress isEqual:weakSelf.wallet.address] && [info.toAddress.checksumAddress isEqual:weakSelf.wallet.address]) {
                            model.selectType = SELF_Trans;
                        }
                        if (info.gasLimit.integerValue * info.gasPrice.integerValue <= 0 || info.gasUsed.integerValue <= 0) {
                            model.selectType = FAILD_Trans;
                        }
                        
                        [weakSelf.ethRecordArray addObject:model];
                        
                    }
                    NSMutableArray *arrCopy = [weakSelf.ethRecordArray mutableCopy];
                     if (arrCopy == nil || !arrCopy || arrCopy.count == 0) {
                        return ;
                    }
                    for (int i = 0;i<arrCopy.count-1;i++) {
                        
                        ETHTransactionRecordModel *modelx = arrCopy[i];
                        if (modelx) {
                            // NSLog(@"%ld",modelx.info.timestamp);
                        }
                        for (int j = i+1;j<arrCopy.count;j++) {
                            
                            ETHTransactionRecordModel *modely = arrCopy[j];
                            if ([modelx.info.transactionHash.hexString isEqualToString:modely.info.transactionHash.hexString]) {
//                                modelx.selectType = IN_Trans;
//                                modely.selectType = OUT_Trans;
                                [weakSelf.ethRecordArray removeObject:modely];
                            }
                        }
                    }
                    [weakSelf.ethRecordArray sortUsingComparator:^NSComparisonResult(ETHTransactionRecordModel * obj1,ETHTransactionRecordModel * obj2) {
                        return obj1.info.timestamp < obj2.info.timestamp;
                    }];
                    dispatch_async_on_main_queue(^{
                        [weakSelf.tableView reloadData];
                    });
                }else{
                    [weakSelf.view showAlert:@"error!" DetailMsg:promiseArray.error.description];
                }
            }];
        }];
        [self.scrollView beginHeaderRefresh];
    }
}

/*
 ETH未打包的交易
 */
-(void)QueryETHPendingTxs{
    NSMutableArray *arr = [[CreateAll GetETHTxhashForAddr:self.wallet.address] mutableCopy];
    if (arr.count > 0) {
        NSString *hash = arr[0];
        [self RequestETHTx:hash Index:0 ALLHash:arr];
    }
}

-(void)RequestETHTx:(NSString *)hash Index:(NSInteger)index ALLHash:(NSArray *)hasharr {
    if (index == hasharr.count) {
        return;
    }
    hash = hasharr[index];
    index++;
    MJWeakSelf
    [CreateAll GetTransactionDetaslByHash:hash Callback:^(TransactionInfoPromise *promise) {
        if (promise) {
            ETHTransactionRecordModel *model = [ETHTransactionRecordModel new];
            model.info = promise.value;
            model.selectType = OUT_Trans;
            if (model.info.blockNumber < 0) {
                [weakSelf.ethRecordArray addObject:model];
                NSMutableArray *arrCopy = [weakSelf.ethRecordArray mutableCopy];
                if (arrCopy == nil || !arrCopy) {
                    return ;
                }
                for (int i = 0;i<arrCopy.count-1;i++) {
                    
                    ETHTransactionRecordModel *modelx = arrCopy[i];
//                    if (modelx) {
//                        // NSLog(@"%ld",modelx.info.timestamp);
//                    }
//
                    for (int j = i+1;j<arrCopy.count;j++) {
                        ETHTransactionRecordModel *modely = arrCopy[j];
                        if ([modelx.info.transactionHash.hexString isEqualToString:modely.info.transactionHash.hexString]) {
                            if ([weakSelf.ethRecordArray containsObject:modelx]) {
                                [weakSelf.ethRecordArray removeObject:modelx];
                            }
                        }
                    }
                }
                [weakSelf.ethRecordArray sortUsingComparator:^NSComparisonResult(ETHTransactionRecordModel * obj1,ETHTransactionRecordModel * obj2) {
                    return obj1.info.timestamp < obj2.info.timestamp;
                }];
                [weakSelf RequestETHTx:hash Index:index ALLHash:hasharr];
                dispatch_async_on_main_queue(^{
                    [weakSelf.tableView reloadData];
                });
            }else{
                [CreateAll DeleteETHTxHash:hash ForAddr:weakSelf.wallet.address];
            }   
        }
    }];

}

-(void)GetBaseInfo{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *currentLanguage = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLanguageSelected"];
        if(currentLanguage == nil){
            currentLanguage = @"chinese";
            [[NSUserDefaults standardUserDefaults] setObject:@"chinese" forKey:@"CurrentLanguageSelected"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        NSString *symbol = nil;
        switch (self.wallet.coinType) {
            case BTC:
                symbol = @"BTC/USDT";
                break;
            case ETH:
                symbol = @"ETH/USDT";
                break;
            case EOS:
                symbol = @"EOS/USDT";
                break;
            case MIS:
                symbol = @"MIS/USDT";
                break;
                
            default:
                break;
        }
        [NetManager GetMarketBaseInfoWithMySymbol:symbol Lang:[currentLanguage isEqualToString:@"english"]?USD_TYPE:CHY_TYPE completionHandler:^(id responseObj, NSError *error) {
            if (!error) {
                if (![[NSString stringWithFormat:@"%@",responseObj[@"resultCode"]] isEqualToString:@"20000"]) {
                    [self.view showAlert:[NSString stringWithFormat:@"Error:%ld",error.code] DetailMsg:responseObj[@"resultMsg"]];
                    return ;
                }
                NSDictionary *dic;
                dic = responseObj[@"data"];
                self.baseInfoModel = [NewBaseInfoModel parse:dic];
                if (![self.baseInfoModel isEqual:[NSNull null]]) {
                    dispatch_async_on_main_queue(^{
                        [self.detailview.infotextView setText:self.baseInfoModel.summary == nil?@"":self.baseInfoModel.summary];
                    });
                }
               
            }else{
                [self.view showAlert:[NSString stringWithFormat:@"Error:%ld",error.code] DetailMsg:error.localizedDescription];
            }
        }];
    });
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
    [_titleLabel setText:_wallet.walletName];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(SafeAreaTopHeight - 30);
        make.left.equalTo(45);
        make.width.equalTo(200);
        make.height.equalTo(20);
    }];
    
    _scanBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    [_scanBtn setBackgroundImage:[UIImage imageNamed:@"wallet_scan"] forState:UIControlStateNormal];
    [_scanBtn addTarget:self action:@selector(scanBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_scanBtn];
    [_scanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-20);
        make.top.equalTo(SafeAreaTopHeight - 29);
        make.width.equalTo(16);
        make.height.equalTo(16);
    }];
    
}

//点击复制地址
-(void)addressBtnAction:(UIButton *)btn{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _wallet.address;
    [self.view showMsg:NSLocalizedString(@"地址已复制", nil)];
    NSLog(@"addressBtn %ld %@",btn.tag,pasteboard.string);
}


-(void)trasAction{
    TransactionVC *tranvc = [TransactionVC new];
    tranvc.wallet = self.wallet;
    [self.navigationController pushViewController:tranvc animated:YES];
}
-(void)receiptAction{
    ReceiptQRCodeVC *revc = [ReceiptQRCodeVC new];
    revc.wallet = self.wallet;
    [self.navigationController pushViewController:revc animated:YES];
}
-(void)marketAction{
    VTwoMarketDetailVC *devc = [VTwoMarketDetailVC new];
    devc.RMBDollarCurrency = self.RMBDollarCurrency <= 0?6.8:self.RMBDollarCurrency;
    devc.marketModel = [MarketTicketModel new];
    NSString *symbol = nil;
    switch (self.wallet.coinType) {
        case BTC:
            symbol = @"BTC";
            break;
        case BTC_TESTNET:
            symbol = @"BTC";
            break;
        case ETH:
            symbol = @"ETH";
            break;
        case EOS:
            symbol = @"EOS";
            break;
        case MIS:
            symbol = @"MIS";
            break;
            
        default:
            break;
    }
    devc.marketModel.coinCode = symbol;
    
    [self.navigationController pushViewController:devc animated:YES];
}
-(void)exportAction{
    ExportWalletVC *evc = [ExportWalletVC new];
    evc.wallet = _wallet;
    [self.navigationController pushViewController:evc animated:YES];
}

//扫描二维码 ??
-(void)scanBtnAction{
    WBQRCodeVC *WBVC = [[WBQRCodeVC alloc] init];
    [self QRCodeScanVC:WBVC];
    [WBVC setGetQRCodeResult:^(NSString *string) {
        if(VALIDATE_STRING(string)){
            TransactionVC *tranvc = [TransactionVC new];
            if([string isValidBitcoinAddress]){
                for (MissionWallet *wallet in self.walletArray) {
                    if (wallet.walletType == LOCAL_WALLET && (wallet.coinType == BTC ||wallet.coinType == BTC_TESTNET)) {
                        tranvc.wallet = wallet;
                    }
                }
                tranvc.toAddress = string;
                [self.navigationController pushViewController:tranvc animated:YES];
            }else if ([CreateAll ValidHexString:string]){
                for (MissionWallet *wallet in self.walletArray) {
                    if (wallet.walletType == LOCAL_WALLET && (wallet.coinType == ETH)) {
                        tranvc.wallet = wallet;
                    }
                }
                tranvc.toAddress = string;
                [self.navigationController pushViewController:tranvc animated:YES];
            }else if([string containsString:@"MIS"]){
                for (MissionWallet *wallet in self.walletArray) {
                    if (wallet.walletType == LOCAL_WALLET && (wallet.coinType == MIS)) {
                        tranvc.wallet = wallet;
                    }
                }
                tranvc.toAddress = [string componentsSeparatedByString:@"@MIS@"].lastObject;
                [self.navigationController pushViewController:tranvc animated:YES];
            }else if([NSString checkEOSAccount:string]){
                for (MissionWallet *wallet in self.walletArray) {
                    if (wallet.walletType == LOCAL_WALLET && (wallet.coinType == EOS)) {
                        tranvc.wallet = wallet;
                    }
                    if (wallet.walletType == LOCAL_WALLET && (wallet.coinType == MGP)) {
                        tranvc.wallet = wallet;
                    }
                }
                tranvc.toAddress = string;
                [self.navigationController pushViewController:tranvc animated:YES];
            }else{
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = string;
                [self.view showMsg:[NSString stringWithFormat:@"\"%@\" %@",string, NSLocalizedString(@"已复制", nil)]];
            }
            
            NSLog(@"QRCode result = %@",string);
        }
    }];
}

//扫码判断权限
- (void)QRCodeScanVC:(UIViewController *)scanVC {
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
                            [self presentViewController:navisc animated:YES completion:^{
                                
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
                [self presentViewController:navisc animated:YES completion:^{
                    
                }];
                break;
            }
            case AVAuthorizationStatusDenied: {
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:NSLocalizedString(@"请去-> [设置 - 隐私 - 相机 - MisToken] 打开访问开关", nil) preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *alertA = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                
                [alertC addAction:alertA];
                [self presentViewController:alertC animated:YES completion:nil];
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

-(WalletDetailView *)detailview{
    if (!_detailview) {
        _detailview = [WalletDetailView new];
        _detailview.cointype = _wallet.coinType;
        _detailview.wallettype = _wallet.walletType;
        _detailview.iconImageView.image = self.iconimage;
        _detailview.symbolNamelb.text = _wallet.walletName;
        _detailview.symboldetaillb.text = self.symbolname;
        _detailview.amountlb.text = self.amountstring;
        _detailview.balancelb.text = self.balancestring;
//        _detailview.infotextView.text = NSLocalizedString(@"无", nil);
        if (_wallet.coinType == BTC || _wallet.coinType == BTC_TESTNET || _wallet.coinType == ETH) {
            NSString *address = @"";
            if(_wallet.address.length > 20){
                NSString *str1 = [_wallet.address substringToIndex:9];
                NSString *str2 = [_wallet.address substringFromIndex:_wallet.address.length - 10];
                address = [NSString stringWithFormat:@"%@...%@",str1,str2];
            }
            [_detailview.addressBtn setTitle:_wallet.address.length > 20?address:_wallet.address forState:UIControlStateNormal];
        }else if (_wallet.coinType == MIS || _wallet.coinType == EOS){
            [_detailview.addressBtn setTitle:_wallet.walletName forState:UIControlStateNormal];
        }
        [_detailview.addressBtn addTarget:self action:@selector(copyAddress:) forControlEvents:UIControlEventTouchUpInside];
        [self.bridgeContentView addSubview:_detailview];
        [_detailview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(0);
            make.left.right.equalTo(0);
            make.height.equalTo(100);
        }];
    }
    return _detailview;
}

//点击复制地址
-(void)copyAddress:(UIButton *)btn{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _wallet.address;
    [self.view showMsg:NSLocalizedString(@"地址已复制", nil)];
    NSLog(@"addressBtn %ld %@",btn.tag,pasteboard.string);
}

-(DetailBtnsView *)detailbtnsview{
    if (!_detailbtnsview) {
        _detailbtnsview = [DetailBtnsView new];
        _detailbtnsview.backgroundColor = [UIColor whiteColor];
        [_detailbtnsview.transBtn setTitle:NSLocalizedString(@"我要转账", nil) forState:UIControlStateNormal];
        [_detailbtnsview.transBtn addTarget:self action:@selector(trasAction) forControlEvents:UIControlEventTouchUpInside];
        [_detailbtnsview.receiptBtn setTitle:NSLocalizedString(@"我的收款码", nil) forState:UIControlStateNormal];
        [_detailbtnsview.receiptBtn addTarget:self action:@selector(receiptAction) forControlEvents:UIControlEventTouchUpInside];
        [_detailbtnsview.marketBtn setTitle:NSLocalizedString(@"行情走势", nil) forState:UIControlStateNormal];
        [_detailbtnsview.marketBtn addTarget:self action:@selector(marketAction) forControlEvents:UIControlEventTouchUpInside];
        [_detailbtnsview.exportBtn setTitle:NSLocalizedString(@"导出钱包", nil) forState:UIControlStateNormal];
        [_detailbtnsview.exportBtn addTarget:self action:@selector(exportAction) forControlEvents:UIControlEventTouchUpInside];
        [self.bridgeContentView addSubview:_detailbtnsview];
        [_detailbtnsview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.detailview.mas_bottom).equalTo(5);
            make.left.right.equalTo(0);
            make.height.equalTo(110);
        }];
    }
    return _detailbtnsview;
}


#pragma tableView - delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    view.frame = CGRectMake(0, 0, ScreenWidth, 40);
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor textDarkColor];
    label.text = NSLocalizedString(@"交易记录", nil);
    [view addSubview:label];
    [label  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.centerY.equalTo(0);
        make.width.equalTo(150);
        make.height.equalTo(15);
    }];
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor lineGrayColor];
    [view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.bottom.equalTo(0);
        make.height.equalTo(1);
    }];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.wallet.coinType == BTC || self.wallet.coinType == BTC_TESTNET) {
        return self.btcRecordArray.count;
    }else if(self.wallet.coinType == ETH){
        return self.ethRecordArray.count;
    }else{
        return 0;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TransactionRecordDetailVC *dvc = [TransactionRecordDetailVC new];
    dvc.wallet = self.wallet;
    if (self.wallet.coinType == BTC || self.wallet.coinType == BTC_TESTNET) {
        Tx *model = self.btcRecordArray[indexPath.row];
        dvc.btcRecord = model;
        NSString *fromaddr;
        NSString *toaddr;
        CGFloat amountmax = 0;
        if (model.result + model.fee == 0) {
            for (Output *vout in model.outputs) {
                amountmax+=vout.value;
            }
            amountmax = amountmax * 1.0/pow(10, 8);
            fromaddr = self.wallet.address;
            NSString *addr;
            for (Output *vout in model.outputs) {//转出
                if (![self.wallet.changeAddressStr containsString:vout.addr]) {
                    toaddr = vout.addr;
                    break;
                }else{
                    addr = vout.addr;
                }
            }
            if (toaddr == nil) {
                toaddr = addr;
            }
            
        }else{
            if (model.result > 0) {//转入
                amountmax = model.result * 1.0/pow(10, 8);
                fromaddr = ((Input *)model.inputs[0]).prev_out.addr;
                toaddr = self.wallet.address;
                
            }else{
                amountmax = (model.result + model.fee) * 1.0/pow(10, 8);
                fromaddr = self.wallet.address;
                NSString *addr;
                for (Output *vout in model.outputs) {//转出
                    if (![self.wallet.changeAddressStr containsString:vout.addr]) {
                        toaddr = vout.addr;
                        break;
                    }else{
                        addr = vout.addr;
                    }
                }
                if (toaddr == nil) {
                    toaddr = addr;
                }
                    
            }
        }
        dvc.fromAddress = fromaddr;
        dvc.toAddress = toaddr;
        dvc.amount = amountmax;
       
    }else if(self.wallet.coinType == ETH){
        ETHTransactionRecordModel *model = self.ethRecordArray[indexPath.row];
        dvc.ethRecord = model;
        dvc.fromAddress = model.info.fromAddress.checksumAddress;
        dvc.toAddress = model.info.toAddress.checksumAddress;
       
    }
    [self.navigationController pushViewController:dvc animated:YES];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TransactionRecordCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"TransactionRecordCell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    if (cell == nil) {
        cell = [TransactionRecordCell new];
    }
    
    if (self.wallet.coinType == BTC || self.wallet.coinType == BTC_TESTNET) {
        [cell.iconImageView setImage:[UIImage imageNamed:@"ico_btc"]];
        if (self.btcRecordArray.count > indexPath.row) {
            Tx *model = self.btcRecordArray[indexPath.row];
            NSString *addr = nil;
            CGFloat amountmax = 0;
            
//            for (Output *vout in model.outputs) {
//                if (![self.wallet.changeAddressStr containsString:vout.addr]) {
//                    addr = vout.addr;
//                    break;
//                }
//            }
//            if (addr == nil) {
//                addr = self.wallet.address;
//            }
//
            
            NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:model.time];
            NSString *timeStr=[_formatter stringFromDate:currentDate];
            [cell.timelb setText:[NSString stringWithFormat:@"%@",timeStr]];
            
            if (model.result + model.fee == 0) {
                if (model.block_height <= 0) {
                    cell.resultlb.text = NSLocalizedString(@"未打包", nil);
                }else{
                    cell.resultlb.text = NSLocalizedString(@"已确认", nil);
                }
                [cell.amountlb setTextColor:[UIColor textBlueColor]];
                [cell.resultlb setTextColor:[UIColor textLightGrayColor]];
                addr = self.wallet.address;
                amountmax = 0;
                for (Output *vout in model.outputs) {//转出
                    amountmax+=vout.value;
                }
                amountmax = amountmax * 1.0/pow(10, 8);
                cell.amountlb.text = [NSString stringWithFormat:@"-%.8f", amountmax];
            }else{
                if (model.block_height <= 0) {
                    cell.resultlb.text = NSLocalizedString(@"未打包", nil);
                }else{
                    cell.resultlb.text = NSLocalizedString(@"已确认", nil);
                }
//                if(model.confirmations < 6){
//                    cell.resultlb.text = NSLocalizedString(@"确认中", nil);
//                }else{
//                    cell.resultlb.text = NSLocalizedString(@"成功", nil);
//                }
                [cell.amountlb setTextColor:[UIColor textBlueColor]];
                [cell.resultlb setTextColor:[UIColor textLightGrayColor]];
                
                if (model.result > 0) {//转入
                    [cell.amountlb setTextColor:[UIColor textBlueColor]];
                    amountmax = model.result * 1.0/pow(10, 8);
                    addr = ((Input *)model.inputs[0]).prev_out.addr;
                    cell.amountlb.text = [NSString stringWithFormat:@"+%.8f", amountmax];
                    NSString *str1 = [addr substringToIndex:9];
                    NSString *str2 = [addr substringFromIndex:addr.length - 10];
                    cell.addresslb.text = [NSString stringWithFormat:@"%@...%@",str1,str2];
                }else if(model.result < 0){
                    [cell.amountlb setTextColor:[UIColor textOrangeColor]];
                    amountmax = (model.result + model.fee) * 1.0/pow(10, 8);
                    for (Output *vout in model.outputs) {//转出
                        if (![self.wallet.changeAddressStr containsString:vout.addr]) {
                            addr = vout.addr;
                            break;
                        }
                    }
                    cell.amountlb.text = [NSString stringWithFormat:@"%.8f", amountmax];
                }else{
                    addr = self.wallet.address;
                    cell.amountlb.text = [NSString stringWithFormat:@"0.00000000"];
                    [cell.amountlb setTextColor:[UIColor textGrayColor]];
                }
               
            }
            if (addr.length > 10) {
                NSString *str1 = [addr substringToIndex:9];
                NSString *str2 = [addr substringFromIndex:addr.length - 10];
                cell.addresslb.text = [NSString stringWithFormat:@"%@...%@",str1,str2];
            }
        }
        
        
    }else if(self.wallet.coinType == ETH){
        [cell.iconImageView setImage:[UIImage imageNamed:@"ico_eth-1"]];
        ETHTransactionRecordModel *model;
        if (self.ethRecordArray.count > indexPath.row) {
            model = self.ethRecordArray[indexPath.row];
            TransactionInfo *info;
            info = model.info;
            NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:info.timestamp];
            NSString *timeStr=[_formatter stringFromDate:currentDate];
            [cell.timelb setText:[NSString stringWithFormat:@"%@",timeStr]];
            CGFloat amount = info.value.integerValue * 1.0 / pow(10, 18);
            if (model.selectType == IN_Trans) {
                cell.amountlb.text = [NSString stringWithFormat:@"+%.5f", amount];
            }else if(model.selectType == OUT_Trans){
                cell.amountlb.text = [NSString stringWithFormat:@"-%.5f", amount];
            }else if(model.selectType == SELF_Trans){
                cell.amountlb.text = [NSString stringWithFormat:@"+%.5f", amount];
            }else{
                cell.amountlb.text = [NSString stringWithFormat:@"0.00000"];
            }
            if (model.selectType == IN_Trans) {
                cell.addresslb.text = info.fromAddress.checksumAddress;
            }else{
                cell.addresslb.text = info.toAddress.checksumAddress;
            }
            if (model.selectType == OUT_Trans) {
                [cell.amountlb setTextColor:[UIColor textOrangeColor]];
            }else if(model.selectType == IN_Trans){
                [cell.amountlb setTextColor:[UIColor textBlueColor]];
            }else{
                [cell.amountlb setTextColor:[UIColor textGrayColor]];
            }
            if (model.info.blockNumber<1) {
                cell.resultlb.text = NSLocalizedString(@"未打包", nil);
            }else{
                cell.resultlb.text = @"";
            }
            //判断交易是否有错
            if (info.gasLimit.integerValue * info.gasPrice.integerValue == 0 || info.gasUsed == 0) {
                // cell.resultlb.text = NSLocalizedString(@"失败", nil);
            }else{
                //  cell.resultlb.text = NSLocalizedString(@"成功", nil);
            }
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins  = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        UIView *view = [[UIView alloc] init];
        _tableView.tableFooterView = view;
        [_tableView registerClass:[TransactionRecordCell class] forCellReuseIdentifier:@"TransactionRecordCell"];
        [self.bridgeContentView addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.detailbtnsview.mas_bottom).equalTo(5);
            make.left.right.equalTo(0);
            make.bottom.equalTo(0);
        }];
    }
    return _tableView;
}

-(UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.scrollEnabled = YES;
        _scrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight + 350);
        _scrollView.delegate =self;
        _scrollView.scrollsToTop = YES;
        [self.view addSubview:_scrollView];
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.top.equalTo(SafeAreaTopHeight);
            make.bottom.equalTo(-SafeAreaBottomHeight);
        }];
        _bridgeContentView = [UIView new];
        _bridgeContentView.backgroundColor = [UIColor ExportBackgroundColor];
        [self.scrollView addSubview:_bridgeContentView];
        [_bridgeContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.scrollView);
            make.width.height.equalTo(self.scrollView.contentSize);
        }];
    }
    
    return _scrollView;
}

@end
