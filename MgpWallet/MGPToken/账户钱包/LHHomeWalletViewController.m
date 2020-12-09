//
//  HomeWalletViewController.m
//  TaiYiToken
//
//  Created by mac on 2020/7/10.
//  Copyright © 2020 admin. All rights reserved.
//

#import "LHHomeWalletViewController.h"
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

//扫码二维码
#import "WBQRCodeVC.h"
#import "TransactionVC.h"
#import "EOSHelpRegisterVC.h"


@interface LHHomeWalletViewController ()<UITableViewDelegate,UITableViewDataSource>


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


@property (nonatomic, strong) RLMNotificationToken *token;
                              
@end

@implementation LHHomeWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"MangoWallet";
    [self.AssetsBtn setTitle:NSLocalizedString(@"资产", nil) forState:UIControlStateNormal];
    [self.ResourcesBtn setTitle:NSLocalizedString(@"资源管理", nil) forState:UIControlStateNormal];
    [self.VoteBtn setTitle:NSLocalizedString(@"节点投票", nil) forState:UIControlStateNormal];

    NSLog(@"results: %@",[AppModel allObjects]);

    
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
    
    
    AppModel *aPerson = [[AppModel allObjects]firstObject];
    self.token = [aPerson.currentWallet addNotificationBlock:^(BOOL deleted,NSArray<RLMPropertyChange *> *changes,NSError *error) {
        if (deleted) {
               NSLog(@"The object was deleted.");
        }
        else if (error) {
               NSLog(@"An error occurred: %@", error);
        }
        else {
             for (RLMPropertyChange *property in changes)  {
                    // 做一些处理
                    [self refreshData];
                 
                }
            }
    }];

    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
}

- (void)refreshData{
    
    RLMResults *result = [AppModel allObjects];
    AppModel *appModel = result.firstObject;
    [LHWalletManager sharedManger].currentWallet = appModel.currentWallet;
    
 
    self.wallet_address.text = appModel.currentWallet.address;
    self.walletName.text = appModel.currentWallet.name;
    
    self.tableView.tableHeaderView = _headerView;
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}
//未注册
- (IBAction)walletRegisterClick:(id)sender {
    [self.view showMsg:@"未注册"];

    
    
    
}
//添加Token
- (IBAction)addErcTokenClick:(id)sender {
    [self.view showMsg:@"添加Token"];
  
    [[LHWalletManager sharedManger]deleteCurrentWalletObject];
    
    AppModel *appModel = [[AppModel allObjects] firstObject];
    [[LHWalletManager sharedManger]setDefaultCurrentWalletModel:appModel.wallets[0]];
    [self refreshData];


}

//节点投票
- (IBAction)voteClick:(id)sender {

    TokenModel *mgpToken1 = [TokenModel new];
    mgpToken1.decimals = 18;
    mgpToken1.identifier = [NSString stringWithFormat:@"%d",arc4random()];
    mgpToken1.name = @"MGP-ACBC";
    mgpToken1.symbol = @"mgp";
    mgpToken1.tokenCoinType = 4;
    mgpToken1.iconUrl = @"https://api.coom.pub/static/img/7052555092901603264415850.jpg";
    [[LHWalletManager sharedManger]addCurrentWalletToken:mgpToken1];
    
    
    [self refreshData];

    
    
    [self.view showMsg:@"添加token成功"];
    
}
//资源管理
- (IBAction)resourcesClick:(id)sender {

    AppModel *appModel = [[AppModel allObjects] firstObject];
    int s = arc4random()%appModel.wallets.count;
    [[LHWalletManager sharedManger]setDefaultCurrentWalletModel:appModel.wallets[s]];
    [self refreshData];
    
    [self.view showMsg:@"变更当前选中的钱包"];
    
}
//导出钱包
- (IBAction)exportClick:(id)sender {
    [self.view showMsg:@"导出钱包"];
    
    AppModel *myPuppy = [[AppModel allObjects] firstObject];
    [[RLMRealm defaultRealm] transactionWithBlock:^{

        for (TokenModel *token in myPuppy.currentWallet.selectedTokenList) {
            token.balance = arc4random()%100000;
            token.price = arc4random()%100;
            switch (myPuppy.currentWallet.coinType) {
                case 0:
                    token.iconUrl = @"https://api.coom.pub/static/img/8691016015501603264415849.jpg";
                    break;
                case 1:
                    token.iconUrl = @"https://api.coom.pub/static/img/6154163252501603264415850.jpg";
                    break;
                case 2:
                    token.iconUrl = @"https://api.coom.pub/static/img/6416018686411603264415850.jpg";
                    break;
                case 3:
                    token.iconUrl = @"https://api.coom.pub/static/img/7052555092901603264415850.jpg";
                    break;
                    
                default:
                    break;
            }
        }
        
    }];
    [self refreshData];

}
//点击复制地址
- (IBAction)addressBtnAction:(id)sender {
    [self.view showMsg:@"点击复制地址"];

    
    
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
    
}



#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    WalletModel *wallet = [LHWalletManager sharedManger].currentWallet;
    
    return wallet.selectedTokenList.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
/*
    HomeWalletTableViewCell *cell = [HomeWalletTableViewCell cellWithTableView:tableView];
    cell.wallet = self.listData.firstObject;
    double balance = self.balances.firstObject.doubleValue;
    double currency = self.currencys.firstObject.doubleValue;
    
    cell.balance.text = [NSString stringWithFormat:@"%.4f",balance];
    cell.money.text = [NSString stringWithFormat:@"%@%.2f",[CreateAll GetCurrentCurrency].symbol,([[CreateAll GetCurrentCurrency].price doubleValue] * currency)];
    return cell;
    */
    
    HomeWalletTableViewCell *cell = [HomeWalletTableViewCell cellWithTableView:tableView];
    TokenModel *tokenModel = [LHWalletManager sharedManger].currentWallet.selectedTokenList[indexPath.row];
    
    cell.coin_sys.text = tokenModel.name;
    cell.balance.text = [NSString stringWithFormat:@"%.6f",tokenModel.balance];
    cell.money.text = [NSString stringWithFormat:@"$%.2f",tokenModel.price];

    [cell.coinImage sd_setImageWithURL:[NSURL URLWithString:tokenModel.iconUrl]];
    cell.coinImage.contentMode = UIViewContentModeCenter;
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
