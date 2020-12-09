//
//  USDTDetailVC.m
//  TaiYiToken
//
//  Created by 张元一 on 2019/4/28.
//  Copyright © 2019 admin. All rights reserved.
//

#import "USDTDetailVC.h"

#import "WalletDetailVC.h"
#import "WBQRCodeVC.h"
#import "WalletDetailView.h"
#import "NewBaseInfoModel.h"
#import "DetailBtnsView.h"
#import "TransactionVC.h"
#import "ReceiptQRCodeVC.h"
#import "ExportWalletVC.h"
#import "TransactionRecordDetailVC.h"
#import "TransactionRecordCell.h"
#import "VTwoMarketDetailVC.h"

#import "USDTTxListModel.h"
#define BTCRecordListPageSize 20

@interface USDTDetailVC ()<UIImagePickerControllerDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIView *bridgeContentView;
@property(nonatomic,strong) UIButton *backBtn;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIButton *scanBtn;
@property(nonatomic,strong)WalletDetailView *detailview;
@property (strong, nonatomic)DetailBtnsView *detailbtnsview;
//
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic)int page;
@property(nonatomic,strong)NSMutableArray <USDTTxListData *>*usdtRecordArray;
@property(nonatomic,strong)NSDateFormatter* formatter;

@end

@implementation USDTDetailVC
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
//    [self initHeadView];
    self.title = NSLocalizedString(@"USDT", nil);

    [self detailview];
    [self detailbtnsview];
    
    if (self.wallet.coinType == USDT){
        self.usdtRecordArray = [NSMutableArray new];
        MJWeakSelf
        [self.scrollView addHeaderRefresh:^{
            [NetManager RequestUSDTTxListForAddress:weakSelf.wallet.address Page:0 CompletionHandler:^(id responseObj, NSError *error) {
                [weakSelf.scrollView endHeaderRefresh];
                [weakSelf.usdtRecordArray removeAllObjects];
                if (!error) {
                    weakSelf.page ++;
                    USDTTxListModel *model = [USDTTxListModel parse:responseObj];
                    weakSelf.usdtRecordArray = [model.transactions mutableCopy];
                    [weakSelf.usdtRecordArray sortUsingComparator:^NSComparisonResult(USDTTxListData * obj1,USDTTxListData * obj2) {
                        return obj1.blocktime < obj2.blocktime;
                    }];
                    dispatch_async_on_main_queue(^{
                        [weakSelf.tableView reloadData];
                    });
                }else{
                    [weakSelf.view showMsg:error.userInfo.description];
                }
                
            }];
        }];
        [self.scrollView addFooterRefresh:^{
            [NetManager RequestUSDTTxListForAddress:weakSelf.wallet.address Page:weakSelf.page CompletionHandler:^(id responseObj, NSError *error) {
                [weakSelf.scrollView endFooterRefresh];
                if (!error) {
                    weakSelf.page ++;
                    USDTTxListModel *model = [USDTTxListModel parse:responseObj];
                    [weakSelf.usdtRecordArray addObjectsFromArray:model.transactions];
                    [weakSelf.usdtRecordArray sortUsingComparator:^NSComparisonResult(USDTTxListData * obj1,USDTTxListData * obj2) {
                        return obj1.blocktime < obj2.blocktime;
                    }];
                    dispatch_async_on_main_queue(^{
                        [weakSelf.tableView reloadData];
                    });
                }else{
                    [weakSelf.view showMsg:error.userInfo.description];
                }
                
            }];
        }];
        [self.scrollView beginHeaderRefresh];
        
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
        
        if (_wallet.coinType == USDT) {
            NSString *address = @"";
            if(_wallet.address.length > 20){
                NSString *str1 = [_wallet.address substringToIndex:9];
                NSString *str2 = [_wallet.address substringFromIndex:_wallet.address.length - 10];
                address = [NSString stringWithFormat:@"%@...%@",str1,str2];
            }
            [_detailview.addressBtn setTitle:_wallet.address.length > 20?address:_wallet.address forState:UIControlStateNormal];
        }
        [_detailview.addressBtn addTarget:self action:@selector(copyAddress:) forControlEvents:UIControlEventTouchUpInside];
        [self.bridgeContentView addSubview:_detailview];
        [_detailview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(0);
            make.left.right.equalTo(0);
            make.height.equalTo(70);
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
        [self.bridgeContentView addSubview:_detailbtnsview];
        [_detailbtnsview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.detailview.mas_bottom).equalTo(5);
            make.left.right.equalTo(0);
            make.height.equalTo(55);
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
    if (self.wallet.coinType == USDT) {
        return self.usdtRecordArray.count;
    }else{
        return 0;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TransactionRecordDetailVC *dvc = [TransactionRecordDetailVC new];
    dvc.wallet = self.wallet;
    if (self.wallet.coinType == USDT) {
        USDTTxListData *model = self.usdtRecordArray[indexPath.row];
        dvc.usdtRecord = model;
        /*
         转出
         "type": "Simple Send",
         "type_int": 0,
         转入
         "type": "Send To Owners",
         "type_int": 3,
         
         */
        if(model.type_int == 0){
            dvc.fromAddress = self.wallet.address;
            dvc.toAddress = model.sendingaddress;
        }else if (model.type_int == 3){
            dvc.fromAddress = model.sendingaddress;
            dvc.toAddress = self.wallet.address;
        }
        
        dvc.amount = model.amount.doubleValue;
        
    }
    [self.navigationController pushViewController:dvc animated:YES];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TransactionRecordCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"TransactionRecordCell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    if (cell == nil) {
        cell = [TransactionRecordCell new];
    }
    if (self.wallet.coinType == USDT) {
        [cell.iconImageView setImage:[UIImage imageNamed:@"usdticon"]];
        if (self.usdtRecordArray.count > indexPath.row) {
            USDTTxListData *model = self.usdtRecordArray[indexPath.row];
            NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:model.blocktime];
            NSString *timeStr=[_formatter stringFromDate:currentDate];
            [cell.timelb setText:[NSString stringWithFormat:@"%@",timeStr]];
            if (model.confirmations <= 0) {
                cell.resultlb.text = NSLocalizedString(@"未打包", nil);
            }else if(model.confirmations <= 6){
                cell.resultlb.text = NSLocalizedString(@"确认中", nil);
            }else{
                cell.resultlb.text = NSLocalizedString(@"已确认", nil);
            }
            [cell.amountlb setTextColor:[UIColor textBlueColor]];
            [cell.resultlb setTextColor:[UIColor textLightGrayColor]];
            if(model.type_int == 0){//转出
                [cell.amountlb setTextColor:[UIColor textOrangeColor]];
                cell.amountlb.text = [NSString stringWithFormat:@"-%.8f", model.amount.doubleValue];
            
            }else if (model.type_int == 3){//转入
                [cell.amountlb setTextColor:[UIColor textBlueColor]];
                cell.amountlb.text = [NSString stringWithFormat:@"+%.8f", model.amount.doubleValue];
            }else{
                cell.amountlb.text = [NSString stringWithFormat:@"%.8f", model.amount.doubleValue];
                [cell.amountlb setTextColor:[UIColor textGrayColor]];
            }
            
            if (model.sendingaddress.length > 10) {
                NSString *str1 = [model.sendingaddress substringToIndex:9];
                NSString *str2 = [model.sendingaddress substringFromIndex:model.sendingaddress.length - 10];
                cell.addresslb.text = [NSString stringWithFormat:@"%@...%@",str1,str2];
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
