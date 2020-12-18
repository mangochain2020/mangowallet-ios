//
//  SelectEOSAccountVC.m
//  TaiYiToken
//
//  Created by 张元一 on 2018/12/18.
//  Copyright © 2018 admin. All rights reserved.
//

#import "SelectEOSAccountVC.h"
#import "EOSWalletDetailVC.h"
@interface SelectEOSAccountVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *accountArray;

@end

@implementation SelectEOSAccountVC
-(void)viewWillAppear:(BOOL)animated{
    [self.view showHUD];
    if (self.wallet) {
        //查询账号
        MJWeakSelf
        [self getEOSKey:self.wallet.publicKey AccountSuccess:^(id response) {
            [self.view hideHUD];
            if (response) {
                NSLog(@"response %@",response);
                NSArray *arr = response[@"account_names"];
                if (arr.count > 0) {
                    weakSelf.accountArray = [NSMutableArray new];
                    [weakSelf.accountArray addObjectsFromArray:arr];
                    [weakSelf.tableView reloadData];
                }else{
                    //未注册
                    [weakSelf.view showMsg:NSLocalizedString(@"未查询到帐号", nil)];
                }
            }else{
                //未注册
                [weakSelf.view showMsg:NSLocalizedString(@"未查询到帐号", nil)];
            }
        }];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSLocalizedString(@"查询帐号", nil);
}

- (void)getEOSKey:(NSString *)pubkey AccountSuccess:(void(^)(id response))handler{
    NSDictionary *dic = @{@"public_key":pubkey};
    
    if (self.wallet.coinType == EOS){
        [[HTTPRequestManager shareEosManager] post:eos_get_key_accounts paramters:dic success:^(BOOL isSuccess, id responseObject) {
            if (isSuccess) {
                handler(responseObject);
            }else{
                handler(nil);
            }
        } failure:^(NSError *error) {
            handler(nil);
        } superView:self.view showFaliureDescription:YES];
        
    }else{
        [[HTTPRequestManager shareMgpManager] post:eos_get_key_accounts paramters:dic success:^(BOOL isSuccess, id responseObject) {
            if (isSuccess) {
                handler(responseObject);
            }else{
                handler(nil);
            }
        } failure:^(NSError *error) {
            handler(nil);
        } superView:self.view showFaliureDescription:YES];
        
    }
}

#pragma tableView

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.accountArray.count > 0) {
        return self.accountArray.count;
    }else{
        return 0;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.accountArray.count > indexPath.row) {
        
        
        NSString *accountname = self.accountArray[indexPath.row];
         
        self.wallet.walletName = [NSString stringWithFormat:@"%@_%@",self.wallet.coinType == EOS ? @"EOS" : @"MGP",accountname];
        self.wallet.address = accountname;
        self.wallet.ifEOSAccountRegistered = YES;
        self.wallet.isSkip = YES;

        if (_wallet.walletType == LOCAL_WALLET) {
            [CreateAll RemoveWallet:_wallet];
            [[NSUserDefaults standardUserDefaults] setObject:self.wallet.walletName forKey:self.wallet.coinType == EOS ? @"LocalEOSWalletName" : @"LocalMGPWalletName"];
            [[NSUserDefaults standardUserDefaults] synchronize];
//            [SAMKeychain setPassword:[AESCrypt encrypt:_mnemonic password:_pass] forService:PRODUCT_BUNDLE_ID account:[NSString stringWithFormat:@"mnemonic%@",_wallet.address]];
            [CreateAll SaveWallet:self.wallet Name:self.wallet.walletName WalletType:LOCAL_WALLET Password:_pass];
           
            
        }else if(_wallet.importType == IMPORT_BY_MNEMONIC){
            NSString *address = accountname;
            //查询本地生成数组中是否已经存在
            NSArray *namearray = [CreateAll GetWalletNameArray];
            for (NSString *name in namearray) {
                MissionWallet *miswallet = [CreateAll GetMissionWalletByName:name];
                if ([address isEqualToString:miswallet.address]) {
                    [self.view showMsg:NSLocalizedString(@"导入失败！钱包已存在！", nil)];
                    return;
                }
            }
            //查询本地导入数组中是否已经存在
            NSInteger importindex = 1;
            NSArray *importnamearray = [CreateAll GetImportWalletNameArray];
            for (NSString *name in importnamearray) {
                MissionWallet *miswallet = [CreateAll GetMissionWalletByName:name];
                if ([address isEqualToString:miswallet.address]) {
                    [self.view showMsg:NSLocalizedString(@"导入失败！钱包已存在！", nil)];
                    return;
                }else{
                    if (miswallet.coinType == EOS || miswallet.coinType == MIS) {
                        importindex ++;
                    }
                }
            }
            _wallet.index = (int)importindex;
            [self.view showMsg:NSLocalizedString(@"导入成功！", nil)];
            [SAMKeychain setPassword:[AESCrypt encrypt:_mnemonic password:_pass] forService:PRODUCT_BUNDLE_ID account:[NSString stringWithFormat:@"mnemonic%@",_wallet.address]];
            [CreateAll SaveWallet:self.wallet Name:self.wallet.walletName WalletType:self.wallet.walletType Password:_pass];
            
        }else if(_wallet.importType == IMPORT_BY_PRIVATEKEY){
            NSString *address = accountname;
            //查询本地生成数组中是否已经存在
            NSArray *namearray = [CreateAll GetWalletNameArray];
            for (NSString *name in namearray) {
                MissionWallet *miswallet = [CreateAll GetMissionWalletByName:name];
                if ([address isEqualToString:miswallet.address]) {
                    [self.view showMsg:NSLocalizedString(@"导入失败！钱包已存在！", nil)];
                    return;
                }
            }
            //查询本地导入数组中是否已经存在
            NSInteger importindex = 1;
            NSArray *importnamearray = [CreateAll GetImportWalletNameArray];
            for (NSString *name in importnamearray) {
                MissionWallet *miswallet = [CreateAll GetMissionWalletByName:name];
                if ([address isEqualToString:miswallet.address]) {
                    [self.view showMsg:NSLocalizedString(@"导入失败！钱包已存在！", nil)];
                    return;
                }else{
                    if (miswallet.coinType == EOS || miswallet.coinType == MIS) {
                        importindex ++;
                    }
                }
            }
            _wallet.index = (int)importindex;
            [self.view showMsg:NSLocalizedString(@"导入成功！", nil)];
            [CreateAll SaveWallet:self.wallet Name:self.wallet.walletName WalletType:self.wallet.walletType Password:_pass];
        }
        /*
        NSString *str = [NSString stringWithFormat:@"%@:EOS",accountname];
        MJWeakSelf
        [NetManager AddAccountLogWithuserName:[CreateAll GetCurrentUserName] AccountInfo:str RecordType:IMPORT_LOG_TYPE CompletionHandler:^(id responseObj, NSError *error) {
            if (!error) {
                if (![[NSString stringWithFormat:@"%@",responseObj[@"resultCode"]] isEqualToString:@"20000"]) {
                    [weakSelf.view showAlert:@"" DetailMsg:responseObj[@"resultMsg"]];
                    return ;
                }
            }else{
                [weakSelf.view showAlert:[NSString stringWithFormat:@"Error:%ld",error.code] DetailMsg:error.localizedDescription];
            }
        }];*/
        [[NSNotificationCenter defaultCenter]postNotificationName:CHANGECURRETWALLET object:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EOSAccountCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *accountname = self.accountArray[indexPath.row];
    cell.textLabel.text = accountname;
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
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"EOSAccountCell"];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(0);
            make.left.right.equalTo(0);
            make.bottom.equalTo(-SafeAreaBottomHeight - 44);
        }];
    }
    return _tableView;
}
@end
