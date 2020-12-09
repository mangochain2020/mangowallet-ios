//
//  HomeWalletViewController.m
//  TaiYiToken
//
//  Created by mac on 2020/7/10.
//  Copyright © 2020 admin. All rights reserved.
//

#import "HomeWalletViewController.h"
#import "WalletListViewController.h"
#import <HWPanModal/HWPanModal.h>
#import "ExportWalletVC.h"
#import "HomeWalletTableViewCell.h"
#import "BTCBlockChainListModel.h"
#import "EOSWalletRegister.h"
#import "MainCoinDetailViewController.h"
#import "EOSProManageVC.h"
#import "LHCreateViewController.h"
#import "ReceiptQRCodeVC.h"
#import "LHStakeVoteMainTableViewController.h"

//扫码二维码
#import "WBQRCodeVC.h"
#import "TransactionVC.h"
#import "EOSHelpRegisterVC.h"


@interface HomeWalletViewController ()<UITableViewDelegate,UITableViewDataSource>


@property(weak, nonatomic) IBOutlet UIView *headerView;

@property(weak, nonatomic) IBOutlet UITableView *tableView;

@property(weak, nonatomic) IBOutlet UIView *centerViewBg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerHight;
@property(weak, nonatomic) IBOutlet UIView *bottomViewBg;
@property(weak, nonatomic) IBOutlet UIView *topViewBg;

@property(weak, nonatomic) IBOutlet UIImageView *coinImage;
@property(weak, nonatomic) IBOutlet UILabel *wallet_address;
@property(weak, nonatomic) IBOutlet UILabel *money;
@property(weak, nonatomic) IBOutlet UILabel *walletName;
@property(weak, nonatomic) IBOutlet UIButton *ResourcesBtn;
@property(weak, nonatomic) IBOutlet UIButton *VoteBtn;
@property(weak, nonatomic) IBOutlet UIButton *AssetsBtn;
@property(weak, nonatomic) IBOutlet UIImageView *AssetsRightImage;
@property(weak, nonatomic) IBOutlet UIButton *InvitationBtn;

@property(strong, nonatomic)UIRefreshControl *refreshControl;
@property(strong, nonatomic)MissionWallet *curretWallet;
@property(nonatomic,strong)NSMutableArray <NSNumber *>*balances;
@property(nonatomic,strong)NSMutableArray <NSNumber *>*currencys;
@property(nonatomic,strong)NSMutableArray <MissionWallet *>*listData;


@end

@implementation HomeWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"MangoWallet";
    [self.AssetsBtn setTitle:NSLocalizedString(@"资产", nil) forState:UIControlStateNormal];
    [self.ResourcesBtn setTitle:NSLocalizedString(@"资源管理", nil) forState:UIControlStateNormal];
    [self.VoteBtn setTitle:NSLocalizedString(@"节点投票", nil) forState:UIControlStateNormal];

    
    _centerViewBg.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    _centerViewBg.layer.borderWidth = 0.5;
    _tableView.tableFooterView = [UIView new];
    _tableView.rowHeight = 60;
    
    UIButton *_walletBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    [_walletBtn setBackgroundImage:[UIImage imageNamed:@"left_more"] forState:UIControlStateNormal];
    [_walletBtn addTarget:self action:@selector(QRCodeAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_walletBtn];

    UIButton *_scanBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    [_scanBtn setBackgroundImage:[UIImage imageNamed:@"wallet_scan"] forState:UIControlStateNormal];
    [_scanBtn addTarget:self action:@selector(scanBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_scanBtn];

    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    [self refreshData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshData) name:CHANGECURRETWALLET object:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
}

- (void)refreshData{
    if (!self.curretWallet) {
        NSArray *localwalletarray = [CreateAll GetWalletNameArray];
        for (NSString *s in localwalletarray) {
            MissionWallet *wallet = [CreateAll GetMissionWalletByName:s];
            if (wallet.coinType == MGP) {
                self.curretWallet = wallet;
                [MGPHttpRequest shareManager].curretWallet = self.curretWallet;
            }
        }
    }else{
        self.curretWallet = [MGPHttpRequest shareManager].curretWallet;
    }
    
    self.AssetsBtn.enabled = self.curretWallet.coinType == MGP ? NO : YES;
    self.AssetsRightImage.hidden = self.curretWallet.coinType == MGP ? YES : NO;
    
    self.balances = [NSMutableArray new];
    self.currencys = [NSMutableArray new];
    self.listData = [NSMutableArray new];
    self.walletName.text = self.curretWallet.walletName;
    self.wallet_address.text = self.curretWallet.address;
    self.money.text = @"0.00";
//    [self.AssetsRightImage setHidden:NO];
    [self.InvitationBtn setHidden:YES];
    self.centerHight.constant = 0;
    CGFloat height = self.topViewBg.height + self.bottomViewBg.height + 10*2;
    [self.listData addObject:self.curretWallet];

    MJWeakSelf
    //创建组队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_group_t group = dispatch_group_create();
    

    switch (self.curretWallet.coinType) {
        case ETH:
        {
            MissionWallet *walletUSDT = [CreateAll GetMissionWalletByName:@"ETH"];
            walletUSDT.coinType = USDT;
            walletUSDT.walletName = @"Tether USD (USDT)";
            [self.listData addObject:walletUSDT];
            
            self.coinImage.image = [UIImage imageNamed:@"bglogo2"];
            self.topViewBg.backgroundColor = RGB(63, 146, 190);
            dispatch_group_enter(group);//
            dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [CreateAll GetBalanceETHForWallet:self.curretWallet callback:^(BigNumber *balance) {
                    dispatch_group_leave(group);
                    @autoreleasepool {
                        double d = [balance unsignedIntegerValue] * 1.0/pow(10,18);
                        weakSelf.balances[0] = [NSNumber numberWithDouble:d];
                        weakSelf.balances[1] = [NSNumber numberWithDouble:33.7];

                    }
                }];
            });
            //组任务2
            dispatch_group_enter(group);//
            dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [[MGPHttpRequest shareManager]post:@"/api/coinPrice" paramters:@{@"pair":@"ETH_USDT"} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
                    dispatch_group_leave(group);
                    if ([responseObj[@"code"]intValue] == 0) {
                        weakSelf.currencys[0] =@(((NSString *)VALIDATE_STRING([responseObj[@"data"]objectForKey:@"price"])).doubleValue);
                        weakSelf.currencys[1] =@(((NSString *)VALIDATE_STRING(@"1")).doubleValue);
                    }
                                            
                }];
            });
            
            //二个网络请求都完成统一处理
            dispatch_group_notify(group, queue, ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadData];
                    self.money.text = [NSString stringWithFormat:@"%@%.2f",[CreateAll GetCurrentCurrency].symbol,([[CreateAll GetCurrentCurrency].price doubleValue] * (weakSelf.balances[0].doubleValue * weakSelf.currencys[0].doubleValue))];
                });
                
            });
        }
            break;
        case BTC:
        case BTC_TESTNET:
        {
            self.coinImage.image = [UIImage imageNamed:@"bglogo1"];
            self.topViewBg.backgroundColor = RGB(240, 162, 59);
            [self.AssetsRightImage setHidden:YES];
            MissionWallet *walletUSDT = [CreateAll GetMissionWalletByName:@"BTC"];
            walletUSDT.coinType = USDT;
            walletUSDT.walletName = @"USDT";
            [self.listData addObject:walletUSDT];
            
            NSString *addr;
            if (self.curretWallet.changeAddressArray != nil && self.curretWallet.changeAddressArray.count > 0) {
                addr = [self.curretWallet.changeAddressStr stringByReplacingOccurrencesOfString:@"," withString:@"|"];
            }else{
                addr = self.curretWallet.address;
            }
            dispatch_group_enter(group);//
            dispatch_group_async(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [NetManager GetBTCTxFromBlockChainAddress:addr PageSize:20 Offset:0 completionHandler:^(id responseObj, NSError *error) {
                    dispatch_group_leave(group);//
                    @autoreleasepool {
                        if (error) {
                            double amount = 0.0;
//                            weakSelf.tempwalletBalance[index] = [NSNumber numberWithDouble:amount];
                            weakSelf.balances[0] = [NSNumber numberWithDouble:amount];

                        }else{
                            if (responseObj) {
                                BTCBlockChainListModel *model = [BTCBlockChainListModel parse:responseObj];
                                NSUInteger result = 0;
                                for (NSInteger index = 0; index < model.txs.count && index < model.txs.count; index++) {
                                    @autoreleasepool {
                                        Tx *tx = model.txs[index];
                                        if (tx.block_height <= 0 && tx.result<0 && index < weakSelf.balances.count) {//转出未确认
                                            result += tx.result;
                                        }
                                    }
                                }
//                                if(index < weakSelf.tempwalletBalance.count){
//                                    weakSelf.tempwalletBalance[index] = [NSNumber numberWithDouble:(-result* 1.0/pow(10, 8))];
//                                }
                                weakSelf.balances[0] = [NSNumber numberWithDouble:(-result* 1.0/pow(10, 8))];

                            }
                        }
                    }
                    
                }];
            });
            dispatch_group_enter(group);//
            dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [NetManager GetBTCUTXOFromBlockChainAddress:addr MinumConfirmations:0 completionHandler:^(id responseObj, NSError *error) {
                    dispatch_group_leave(group);//
                    @autoreleasepool {
                        if (!error) {
                            if (!responseObj) {
                                return ;
                            }
                            NSArray *utxoarr = [BTCBlockChainUTXOModel parse:responseObj[@"unspent_outputs"]];
                            double amount = 0.0;
                            
                            for (BTCBlockChainUTXOModel *model in utxoarr) {
                                if(model.tx_output_n == 0 && model.confirmations <1){//转入未确认
                                    
                                }else if(model.tx_output_n == 0 && model.confirmations >=1){//转入 确认>1
                                    amount += model.value * 1.0/pow(10, 8);
                                }else if(model.tx_output_n > 0 && model.confirmations <1){//转出未确认
                                    //                            ifneedrefresh = NO;
                                    amount += model.value * 1.0/pow(10, 8);
                                }else if(model.tx_output_n > 0 && model.confirmations >=1){//转出 确认>=1
                                    amount += model.value * 1.0/pow(10, 8);
                                }
                            }
                            weakSelf.balances[0] = [NSNumber numberWithDouble:amount];

//                            if (index<weakSelf.btcBalance.count) {
//                                weakSelf.btcBalance[index] = [NSNumber numberWithDouble:amount];
//
//                            }
                        }else{
                            double amount = 0.0;
//                            weakSelf.btcBalance[index] = [NSNumber numberWithDouble:amount];
                            weakSelf.balances[0] = [NSNumber numberWithDouble:amount];

                        }
                    }
                    
                }];
            });
            //组任务3
            dispatch_group_enter(group);//
            dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [[MGPHttpRequest shareManager]post:@"/api/coinPrice" paramters:@{@"pair":@"BTC_USDT"} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
                    dispatch_group_leave(group);
                    if ([responseObj[@"code"]intValue] == 0) {
                        weakSelf.currencys[0] =@(((NSString *)VALIDATE_STRING([responseObj[@"data"]objectForKey:@"price"])).doubleValue);
                    }
                                            
                }];
            });
            
            //3个网络请求都完成统一处理
            dispatch_group_notify(group, queue, ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadData];
                    self.money.text = [NSString stringWithFormat:@"%@%.2f",[CreateAll GetCurrentCurrency].symbol,([[CreateAll GetCurrentCurrency].price doubleValue] * (weakSelf.balances[0].doubleValue * weakSelf.currencys[0].doubleValue))];

                });
                
            });
            
        }
            break;
        case EOS:
        {
            self.coinImage.image = [UIImage imageNamed:@"EOS"];
            self.topViewBg.backgroundColor = RGB(56, 53, 84);
            self.centerHight.constant = self.curretWallet.ifEOSAccountRegistered ? 40 : 0;
            height = self.topViewBg.height + self.bottomViewBg.height + 10*3 + self.centerHight.constant;
            [self.InvitationBtn setHidden:self.curretWallet.ifEOSAccountRegistered];
            if (![self.curretWallet.walletName isEqualToString:@"EOS_"]) {
               //组任务1
                dispatch_group_enter(group);//
                dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSString *name = [self.curretWallet.walletName componentsSeparatedByString:@"_"].lastObject;
                    [weakSelf getAccount:name Success:^(id response) {
                        dispatch_group_leave(group);
                        @autoreleasepool {
                            if (response) {
                                NSString *balancestr = [(NSDictionary *)response objectForKey:@"core_liquid_balance"];
                                NSString *valuestring = [balancestr componentsSeparatedByString:@" "].firstObject;
                                double balance = valuestring.doubleValue;
                                NSLog(@"eos blance = %.4f",balance);
                                weakSelf.balances[0] = [NSNumber numberWithDouble:balance];
                            }
                        }
                    }];
                });
                //组任务2
                dispatch_group_enter(group);//
                dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [[MGPHttpRequest shareManager]post:@"/api/coinPrice" paramters:@{@"pair":@"EOS_USDT"} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
                        dispatch_group_leave(group);
                        if ([responseObj[@"code"]intValue] == 0) {
                            weakSelf.currencys[0] =@(((NSString *)VALIDATE_STRING([responseObj[@"data"]objectForKey:@"price"])).doubleValue);
                        }
                                                
                    }];
                });
                
                //二个网络请求都完成统一处理
                dispatch_group_notify(group, queue, ^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.tableView reloadData];
                        self.money.text = [NSString stringWithFormat:@"%@%.2f",[CreateAll GetCurrentCurrency].symbol,([[CreateAll GetCurrentCurrency].price doubleValue] * (weakSelf.balances[0].doubleValue * weakSelf.currencys[0].doubleValue))];

                    });
                    
                });
                
            }else{
                [[HTTPRequestManager shareEosManager] post:eos_get_key_accounts paramters:@{@"public_key":[MGPHttpRequest shareManager].curretWallet.publicKey} success:^(BOOL isSuccess, id responseObject) {
                    if (isSuccess) {
                        NSArray *arr = responseObject[@"account_names"];
                        [weakSelf.InvitationBtn setTitle:arr.count > 0 ? NSLocalizedString(@"请选择导入的账户名", nil) : NSLocalizedString(@"邀请好友激活", nil) forState:UIControlStateNormal];
                    }
                } failure:^(NSError *error) {

                } superView:self.view showFaliureDescription:YES];
            }
        }
            break;
        case MGP:
        {
            self.coinImage.image = [UIImage imageNamed:@"MIS"];
            self.topViewBg.backgroundColor = RGB(85, 144, 240);
            self.centerHight.constant = self.curretWallet.ifEOSAccountRegistered ? 40 : 0;
            height = self.topViewBg.height + self.bottomViewBg.height + 10*3 + self.centerHight.constant;
            [self.InvitationBtn setHidden:self.curretWallet.ifEOSAccountRegistered];
            if (![self.curretWallet.walletName isEqualToString:@"MGP_"]) {
               //组任务1
                dispatch_group_enter(group);//
                dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSString *name = [self.curretWallet.walletName componentsSeparatedByString:@"_"].lastObject;
                    [weakSelf getAccount:name Success:^(id response) {
                        dispatch_group_leave(group);
                        @autoreleasepool {
                            if (response) {
                                NSString *balancestr = [(NSDictionary *)response objectForKey:@"core_liquid_balance"];
                                NSString *valuestring = [balancestr componentsSeparatedByString:@" "].firstObject;
                                double balance = valuestring.doubleValue;
                                NSLog(@"mgp blance = %.4f",balance);
                                weakSelf.balances[0] = [NSNumber numberWithDouble:balance];
                            }
                        }
                    }];
                });
                //组任务2
                dispatch_group_enter(group);//
                dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [[MGPHttpRequest shareManager]post:@"/api/coinPrice" paramters:@{@"pair":@"MGP_USDT"} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
                        dispatch_group_leave(group);
                        if ([responseObj[@"code"]intValue] == 0) {
                            weakSelf.currencys[0] =@(((NSString *)VALIDATE_STRING([responseObj[@"data"]objectForKey:@"price"])).doubleValue);
                        }
                                                
                    }];
                    
                });
                //组任务3
                dispatch_group_enter(group);//
                dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [[MGPHttpRequest shareManager]post:@"/user/findMgp" paramters:@{@"mgpName":[MGPHttpRequest shareManager].curretWallet.address} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
                        dispatch_group_leave(group);
                    }];
                    
                });
                
                //3个网络请求都完成统一处理
                dispatch_group_notify(group, queue, ^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.tableView reloadData];
                        self.money.text = [NSString stringWithFormat:@"%@%.2f",[CreateAll GetCurrentCurrency].symbol,([[CreateAll GetCurrentCurrency].price doubleValue] * (weakSelf.balances[0].doubleValue * weakSelf.currencys[0].doubleValue))];
                    });
                    
                });
                
            }else{
                [[HTTPRequestManager shareMgpManager] post:eos_get_key_accounts paramters:@{@"public_key":[MGPHttpRequest shareManager].curretWallet.publicKey} success:^(BOOL isSuccess, id responseObject) {
                    if (isSuccess) {
                        NSArray *arr = responseObject[@"account_names"];
                        [weakSelf.InvitationBtn setTitle:arr.count > 0 ? NSLocalizedString(@"请选择导入的账户名", nil) : NSLocalizedString(@"邀请好友激活", nil) forState:UIControlStateNormal];
                    }
                } failure:^(NSError *error) {

                } superView:self.view showFaliureDescription:YES];
                
            }
            
        }
            break;
            
        default:
            break;
    }
    [[MGPHttpRequest shareManager]post:@"/user/userLogin" paramters:nil completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {

    }];
    CGRect headerFrame = _headerView.frame;
    headerFrame.size.height = height;
    _headerView.frame = headerFrame;
    self.tableView.tableHeaderView = _headerView;
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}
//未注册
- (IBAction)walletRegisterClick:(id)sender {
    
    EOSWalletRegister *vc = [EOSWalletRegister new];
    vc.wallet = self.curretWallet;
    [self.navigationController pushViewController:vc animated:YES];
}
//添加Token
- (IBAction)addErcTokenClick:(id)sender {
    if (self.curretWallet.coinType != BTC_TESTNET || self.curretWallet.coinType != BTC) {
        [self.view showMsg:NSLocalizedString(@"即将开放添加Token", nil)];
    }

}

//节点投票
- (IBAction)voteClick:(id)sender {
//    [self.view showMsg:NSLocalizedString(@"即将开放", nil)];
    UIStoryboard* secondStoryboard = [UIStoryboard storyboardWithName:@"StakeVote" bundle:[NSBundle mainBundle]];
    LHStakeVoteMainTableViewController *secondNavigationController = [secondStoryboard instantiateViewControllerWithIdentifier:@"LHStakeVoteMainTableViewControllerIndex"];
    [self.navigationController pushViewController:secondNavigationController animated:YES];
    
}
//资源管理
- (IBAction)resourcesClick:(id)sender {
    EOSProManageVC *vc = [EOSProManageVC new];
    vc.wallet = self.curretWallet;
    [self.navigationController pushViewController:vc animated:YES];
}
//导出钱包
- (IBAction)exportClick:(id)sender {
    ExportWalletVC *evc = [ExportWalletVC new];
    evc.wallet = self.curretWallet;
    evc.updateUserInfoBlock = ^()
    {
        self.curretWallet = nil;
        [self refreshData];
    };
    [self.navigationController pushViewController:evc animated:YES];
}
//点击复制地址
- (IBAction)addressBtnAction:(id)sender {
    switch (self.curretWallet.coinType) {
        case MGP:
        case EOS:
        {
            if (self.curretWallet.ifEOSAccountRegistered) {
                ReceiptQRCodeVC *revc = [ReceiptQRCodeVC new];
                revc.wallet = self.curretWallet;
                [self.navigationController pushViewController:revc animated:YES];
            }
        }
            break;
            
        default:
        {
            ReceiptQRCodeVC *revc = [ReceiptQRCodeVC new];
            revc.wallet = self.curretWallet;
            [self.navigationController pushViewController:revc animated:YES];
            
        }
            break;
    }
    
}
-(void)QRCodeAction{

    WalletListViewController *vc = [WalletListViewController new];
    [self presentPanModal:vc];
    [vc returnWithBlock:^(UIViewController * _Nonnull vc, MissionWallet * _Nonnull wallet, WalletListBlockType type) {
        
        switch (type) {
            case PushWalletDetail:
            {
                ExportWalletVC *evc = [ExportWalletVC new];
                evc.wallet = wallet;
                [self.navigationController pushViewController:evc animated:YES];
            }
                break;
            case PushCreateVC:
            {
                LHCreateViewController *createVC = [[LHCreateViewController alloc]init];
                createVC.coinType = wallet.coinType;
                [self.navigationController pushViewController:createVC animated:YES];

            }
                break;
            case PushImportVC:
                [self.navigationController pushViewController:vc animated:YES];
                break;
            case ReloadDataWallet:
                [MGPHttpRequest shareManager].curretWallet = wallet;
                [self refreshData];
                break;
            default:
                break;
        }
        
        
    }];
    
    
    
}
-(void)scanBtnAction{

    WBQRCodeVC *WBVC = [[WBQRCodeVC alloc] init];
    [self QRCodeScanVC:WBVC];

    MJWeakSelf
    [WBVC setGetQRCodeResult:^(NSString *string) {
        if(VALIDATE_STRING(string)){
            TransactionVC *tranvc = [TransactionVC new];
            
            NSArray *importwalletarray = [CreateAll GetImportWalletNameArray];
            NSArray *localwalletarray = [CreateAll GetWalletNameArray];
            NSMutableArray *temp = [NSMutableArray array];
            for (NSString *s in importwalletarray) {
                MissionWallet *wallet = [CreateAll GetMissionWalletByName:s];
                [temp addObject:wallet];

            }
            for (NSString *s in localwalletarray) {
                MissionWallet *wallet = [CreateAll GetMissionWalletByName:s];
                [temp addObject:wallet];
                
            }
            
            
            if([string isValidBitcoinAddress]){
                for (MissionWallet *wallet in temp) {
                    if (wallet.coinType == BTC || wallet.coinType == BTC_TESTNET) {
                        tranvc.wallet = wallet;
                        break;
                    }
                    
                }
                tranvc.toAddress = string;
                [weakSelf.navigationController pushViewController:tranvc animated:YES];
            }else if ([CreateAll isValidForETH:string]){
                for (MissionWallet *wallet in temp) {
                    if (wallet.coinType == ETH) {
                        tranvc.wallet = wallet;
                        break;
                    }
                    
                }
                tranvc.toAddress = string;
                [weakSelf.navigationController pushViewController:tranvc animated:YES];
            }else if([NSString checkEOSAccount:string] == YES){
                for (MissionWallet *wallet in temp) {
                    if (wallet.coinType == EOS) {
                        tranvc.wallet = wallet;
                        break;
                    }else if (wallet.coinType == MGP){
                        tranvc.wallet = wallet;
                        break;
                    }
                }
                tranvc.toAddress = string;
                [weakSelf.navigationController pushViewController:tranvc animated:YES];
            }else if([string containsString:@"EOS:new_eos_account-"]||[string containsString:@"MGP:new_eos_account-"]){
                EOSHelpRegisterVC *vc = [EOSHelpRegisterVC new];
                vc.coinType = [string containsString:@"EOS:"] ? EOS : MGP;
                NSString *str1 = [string componentsSeparatedByString:@"accountName="].lastObject;
                NSString *str2 = [str1 componentsSeparatedByString:@"&activeKey="].firstObject;//account
                NSString *str3 = [str1 componentsSeparatedByString:@"activeKey="].lastObject;
                NSString *str4 = [str3 componentsSeparatedByString:@"&ownerKey="].firstObject;//activeKey
                NSString *str5 = [str3 componentsSeparatedByString:@"&ownerKey="].lastObject;//ownerKey
                vc.eosAccount = VALIDATE_STRING(str2);
                vc.eosAccountActiveKey = VALIDATE_STRING(str4);
                vc.eosAccountOwnerKey = VALIDATE_STRING(str5);
//                [weakSelf.navigationController pushViewController:vc animated:YES];
            }else if([self isJsonString:string]){
                NSDictionary *par = [self dictionaryWithJsonString:string];
                if ([par[@"type"]intValue] == 3){
                    EOSHelpRegisterVC *vc = [EOSHelpRegisterVC new];
                    vc.coinType = [VALIDATE_STRING(par[@"blockchain"]) isEqualToString:@"MGP"] ? MGP : EOS;
                    vc.eosAccount = VALIDATE_STRING(par[@"account"]);
                    vc.eosAccountActiveKey = VALIDATE_STRING(par[@"active"]);
                    vc.eosAccountOwnerKey = VALIDATE_STRING(par[@"owner"]);
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
                
            }else{
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = string;
                [weakSelf.view showMsg:[NSString stringWithFormat:@"\"%@\" %@",string, NSLocalizedString(@"已复制", nil)]];
            }
            
        }
    }];
}
- (BOOL)isJsonString:(NSString *)jsonString{
    if (jsonString.length < 2) return NO;
    if (!([jsonString hasPrefix:@"{"] || [jsonString hasPrefix:@"["])) return NO;
    return [jsonString characterAtIndex:jsonString.length-1]-[jsonString characterAtIndex:0] == 2;
}
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }

    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
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
- (void)getAccount:(NSString *)account Success:(void(^)(id response))handler{
    
    NSDictionary *dic = @{@"account_name":account};
    HTTPRequestManager *manager = self.curretWallet.coinType == MGP ? [HTTPRequestManager shareMgpManager] : [HTTPRequestManager shareEosManager];
    
    [manager post:eos_get_account paramters:dic success:^(BOOL isSuccess, id responseObject) {
        
        if (isSuccess) {
            handler(responseObject);
        }else{
            handler(nil);
        }
    } failure:^(NSError *error) {
        
    } superView:self.view showFaliureDescription:YES];
    
//    [manager post:@"v1/chain/get_currency_stats" paramters:@{@"code":@"eosio",@"currency":@"MGP"} success:^(BOOL isSuccess, id responseObject) {
//        NSLog(@"%@----------1",responseObject);
//
//
//    } failure:^(NSError *error) {
//
//    } superView:self.view showFaliureDescription:YES];
    
    
}



#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;//self.listData.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    HomeWalletTableViewCell *cell = [HomeWalletTableViewCell cellWithTableView:tableView];
    cell.wallet = self.listData.firstObject;
    double balance = self.balances.firstObject.doubleValue;
    double currency = self.currencys.firstObject.doubleValue;
    
    cell.balance.text = [NSString stringWithFormat:@"%.4f",balance];
    cell.money.text = [NSString stringWithFormat:@"%@%.2f",[CreateAll GetCurrentCurrency].symbol,([[CreateAll GetCurrentCurrency].price doubleValue] * currency)];
    return cell;
    
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MissionWallet *wallet = self.listData[indexPath.row];

    if ((wallet.coinType == MGP || wallet.coinType == EOS) &&  !wallet.ifEOSAccountRegistered) {
        //未注册
        EOSWalletRegister *vc = [EOSWalletRegister new];
        vc.wallet = wallet;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self performSegueWithIdentifier:@"coinDetailVC"sender:wallet];
    }

    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UIViewController *vc = [segue destinationViewController];
    if ([vc isKindOfClass:[MainCoinDetailViewController class]]) {
        MainCoinDetailViewController *VC = (MainCoinDetailViewController *)vc;
        VC.wallet = sender;
    }
}


@end
