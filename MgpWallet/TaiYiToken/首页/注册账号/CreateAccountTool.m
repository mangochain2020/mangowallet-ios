//
//  CreateAccountTool.m
//  TaiYiToken
//
//  Created by mac on 2020/12/16.
//  Copyright © 2020 admin. All rights reserved.
//

#import "CreateAccountTool.h"

@implementation CreateAccountTool
static CreateAccountTool * defualt_shareMananger = nil;


+ (instancetype)shareManager {
    //_dispatch_once(&onceToken, ^{
    if (defualt_shareMananger == nil) {
        defualt_shareMananger = [[self alloc] init];
    }
   // });
    return defualt_shareMananger;
}


/**
 创建多链账户钱包
 */
-(void)CreateWalletSeed:(NSString *)seed PassWord:(NSString *)password PassHint:(NSString *)hint Mnemonic:(NSString *)mnemonic isSkip:(BOOL)isSkip WalletAddressName:(NSString *)walletName WalletType:(WALLET_TYPE)walletType ImportType:(IMPORT_WALLET_TYPE)importType CoinType:(CoinType)coinType completionHandler:(void (^)(id responseObj, NSError *error))handler{
    self.isSkip = isSkip;
    self.walletName = walletName;

    
    NSArray *importwalletarray = [CreateAll GetImportWalletNameArray];
    NSMutableArray *temp = [NSMutableArray array];
    
    
    //创建钱包对象
    NSString *mispri = [CreateAll CreateEOSPrivateKeyBySeed:seed Index:0];
    NSString *pub = [EosEncode eos_publicKey_with_wif:mispri];
    
    switch (coinType) {
        case BTC:
        case BTC_TESTNET:
        {
            for (NSString *s in importwalletarray) {
                MissionWallet *wallet = [CreateAll GetMissionWalletByName:s];
                if (wallet.coinType == BTC || wallet.coinType == BTC_TESTNET) {
                    [temp addObject:wallet];
                }
            }
            NSString *xprv = [CreateAll CreateExtendPrivateKeyWithSeed:seed];
            
            MissionWallet *walletBTC = [CreateAll CreateWalletByXprv:xprv index:0 CoinType:ChangeToTESTNET == 0 ? BTC : BTC_TESTNET Password:password];
            walletBTC.isSkip = self.isSkip;
            [SAMKeychain setPassword:[AESCrypt encrypt:mnemonic password:password] forService:PRODUCT_BUNDLE_ID account:[NSString stringWithFormat:@"mnemonic%@",walletBTC.address]];
            [CreateAll SaveWallet:walletBTC Name:[NSString stringWithFormat:@"BTC(%ld)",temp.count+1] WalletType:walletType Password:password];
            !handler ?:handler(walletBTC,nil);

        }
            break;
        case ETH:
        {
            for (NSString *s in importwalletarray) {
                MissionWallet *wallet = [CreateAll GetMissionWalletByName:s];
                if (wallet.coinType == ETH) {
                    [temp addObject:wallet];
                }
            }
            NSString *xprv = [CreateAll CreateExtendPrivateKeyWithSeed:seed];
            MissionWallet *walletETH = [CreateAll CreateWalletByXprv:xprv index:0 CoinType:ETH Password:password];
            walletETH.isSkip = self.isSkip;
            walletETH.importType = importType;
            [SAMKeychain setPassword:[AESCrypt encrypt:mnemonic password:password] forService:PRODUCT_BUNDLE_ID account:[NSString stringWithFormat:@"mnemonic%@",walletETH.address]];
            
            //创建并存KeyStore eth
           [CreateAll CreateKeyStoreByMnemonic:mnemonic  WalletAddress:walletETH.address Password:password callback:^(Account *account, NSError *error) {
               if (account == nil) {
                   !handler ?:handler(nil,error);
                   return ;
               }else{
                   [CreateAll SaveWallet:walletETH Name:[NSString stringWithFormat:@"ETH(%ld)",temp.count+1] WalletType:walletType Password:password];
                   
                   dispatch_async_on_main_queue(^{
                       !handler ?:handler(account,nil);
                   });
                   
               }
           }];
        }
            break;
        case EOS:
        {

            MissionWallet *eoswallet = [self CreateEOSWalletPri:mispri Pub:pub PassWord:password PassHint:hint WalletType:walletType ImportType:importType CoinType:EOS];
            //根据地址存助记词
            [SAMKeychain setPassword:[AESCrypt encrypt:mnemonic password:password] forService:PRODUCT_BUNDLE_ID account:[NSString stringWithFormat:@"mnemonic%@",eoswallet.address]];
            [CreateAll SaveWallet:eoswallet Name:eoswallet.walletName WalletType:walletType Password:password];
            dispatch_async_on_main_queue(^{
                !handler ?:handler(eoswallet,nil);
            });
            
        }
            break;
        case MGP:
        {
            MissionWallet *mgpwallet = [self CreateEOSWalletPri:mispri Pub:pub PassWord:password PassHint:hint WalletType:walletType ImportType:importType CoinType:MGP];

            //根据地址存助记词
            [SAMKeychain setPassword:[AESCrypt encrypt:mnemonic password:password] forService:PRODUCT_BUNDLE_ID account:[NSString stringWithFormat:@"mnemonic%@",mgpwallet.address]];
            //激活并保存
            [[MGPHttpRequest shareManager]post:@"/user/userRegister" paramters:@{@"publicKey":mgpwallet.publicKey,@"account":self.walletName} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
                    
                if (!error) {
                    mgpwallet.ifEOSAccountRegistered = YES;
                    [CreateAll SaveWallet:mgpwallet Name:mgpwallet.walletName WalletType:walletType Password:password];
                    dispatch_async_on_main_queue(^{
                        !handler ?:handler(responseObj,nil);
                    });
                }
                NSLog(@"%@-----1111",responseObj);
                
                
            }];
            
            
        }
            break;
            
        default:
        {
            MissionWallet *mgpwallet = [self CreateEOSWalletPri:mispri Pub:pub PassWord:password PassHint:hint WalletType:walletType ImportType:importType CoinType:MGP];
            [[NSUserDefaults standardUserDefaults] setObject:mgpwallet.walletName forKey:@"LocalMGPWalletName"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            //根据地址存助记词
            [SAMKeychain setPassword:[AESCrypt encrypt:mnemonic password:password] forService:PRODUCT_BUNDLE_ID account:[NSString stringWithFormat:@"mnemonic%@",mgpwallet.address]];
            //激活并保存
            [[MGPHttpRequest shareManager]post:@"/user/userRegister" paramters:@{@"publicKey":mgpwallet.publicKey,@"account":self.walletName} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
                    
                if (!error) {
                    mgpwallet.ifEOSAccountRegistered = YES;
                    [CreateAll SaveWallet:mgpwallet Name:mgpwallet.walletName WalletType:mgpwallet.walletType Password:password];
                }
                NSLog(@"%@-----1111",responseObj);
                
                
            }];
            
            MissionWallet *eoswallet = [self CreateEOSWalletPri:mispri Pub:pub PassWord:password PassHint:hint WalletType:walletType ImportType:importType CoinType:EOS];
            [SAMKeychain setPassword:[AESCrypt encrypt:mnemonic password:password] forService:PRODUCT_BUNDLE_ID account:[NSString stringWithFormat:@"mnemonic%@",eoswallet.address]];
            [[NSUserDefaults standardUserDefaults] setObject:eoswallet.walletName forKey:@"LocalEOSWalletName"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [CreateAll SaveWallet:eoswallet Name:eoswallet.walletName WalletType:eoswallet.walletType Password:password];

            NSString *xprv = [CreateAll CreateExtendPrivateKeyWithSeed:seed];
            
            MissionWallet *walletBTC = [CreateAll CreateWalletByXprv:xprv index:0 CoinType:ChangeToTESTNET == 0 ? BTC : BTC_TESTNET Password:password];
            walletBTC.isSkip = self.isSkip;
            [SAMKeychain setPassword:[AESCrypt encrypt:mnemonic password:password] forService:PRODUCT_BUNDLE_ID account:[NSString stringWithFormat:@"mnemonic%@",walletBTC.address]];
            [CreateAll SaveWallet:walletBTC Name:@"BTC(0)" WalletType:walletType Password:password];

            
            MissionWallet *walletETH = [CreateAll CreateWalletByXprv:xprv index:0 CoinType:ETH Password:password];
            walletETH.isSkip = self.isSkip;
            [SAMKeychain setPassword:[AESCrypt encrypt:mnemonic password:password] forService:PRODUCT_BUNDLE_ID account:[NSString stringWithFormat:@"mnemonic%@",walletETH.address]];
            
            //创建并存KeyStore eth
           [CreateAll CreateKeyStoreByMnemonic:mnemonic  WalletAddress:walletETH.address Password:password callback:^(Account *account, NSError *error) {
               if (account == nil) {
                   !handler ?:handler(nil,error);
                   return ;
               }else{
                   [CreateAll SaveWallet:walletETH Name:@"ETH(0)" WalletType:walletType Password:password];
                   
                   dispatch_async_on_main_queue(^{
                       !handler ?:handler(account,nil);
                   });
                   
               }
           }];
        }
            break;
    }
    
    
    
    
    
  
}
//创建mis钱包
-(MissionWallet *)CreateEOSWalletPri:(NSString *)pri Pub:(NSString *)pub PassWord:(NSString *)pass PassHint:(NSString *)hint WalletType:(WALLET_TYPE)walletType ImportType:(IMPORT_WALLET_TYPE)importType CoinType:(CoinType)type{

    MissionWallet *wallet = [MissionWallet new];
    wallet.coinType = type;
    wallet.importType = importType;
    wallet.walletType = walletType;
    wallet.index = 0;
    wallet.isSkip = self.isSkip;
    wallet.passwordHint = hint;
    wallet.privateKey = pri;
    wallet.publicKey = pub;
    wallet.walletName = [NSString stringWithFormat:@"%@_%@",type == MGP ? @"MGP" : @"EOS",self.walletName];
    wallet.address = self.walletName;
    [wallet dataCheck];
    return wallet;
}



/**
 创建单一钱包ETH
 */
-(void)CreateETHWalletSeed:(NSString *)seed PassWord:(NSString *)password PassHint:(NSString *)hint Mnemonic:(NSString *)mnemonic WalletType:(IMPORT_WALLET_TYPE)type isSkip:(BOOL)isSkip{
    
    NSString *xprv = [CreateAll CreateExtendPrivateKeyWithSeed:seed];
    MissionWallet *walletETH = [CreateAll CreateWalletByXprv:xprv index:0 CoinType:ETH Password:password];
    walletETH.isSkip = isSkip;
    walletETH.importType = type;
    
    if (!walletETH) {
//        [self.view showMsg:NSLocalizedString(@"创建出错！", nil)];
        return;
    }
    [SAMKeychain setPassword:[AESCrypt encrypt:mnemonic password:password] forService:PRODUCT_BUNDLE_ID account:walletETH.address];
    //创建并存KeyStore eth
    [CreateAll CreateKeyStoreByMnemonic:mnemonic  WalletAddress:walletETH.address Password:password callback:^(Account *account, NSError *error) {
        if (account == nil) {
//            [self.view showMsg:NSLocalizedString(@"创建出错！", nil)];
            return ;
        }else{
            [CreateAll SaveWallet:walletETH Name:@"ETH_Name" WalletType:IMPORT_WALLET Password:password];
            dispatch_async_on_main_queue(^{
//                [self.view showMsg:NSLocalizedString(@"创建成功！", nil)];
                NSLog(@"创建成功！");
            });
            
        }
    }];
    
    
}





@end
