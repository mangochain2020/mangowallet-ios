//
//  CreateAll.m
//  TaiYiToken
//
//  Created by Frued on 2018/8/21.
//  Copyright © 2018年 Frued. All rights reserved.
//

#import "CreateAll.h"
#import "NTVLocalized.h"

@implementation CreateAll

/*
 *********************************************系统初始化********************************************************
 */
//存系统初始化信息
+(void)SaveSystemData:(SystemInitModel *)model{
    [model datacheck];
    NSData *sysdata = [NSKeyedArchiver archivedDataWithRootObject:model requiringSecureCoding:NO error:nil];
    CurrentNodes *nodes = [CreateAll GetCurrentNodes];
    if (!nodes) {
        nodes = [CurrentNodes new];
        
        nodes.nodeBtc = nodes.nodeBtc?nodes.nodeBtc:model.nodeBtcList[0];
        nodes.nodeEth = nodes.nodeEth?nodes.nodeEth:model.nodeEthList[0];
        nodes.nodeEos = nodes.nodeEos?nodes.nodeEos:model.nodeEosList[0];
        nodes.nodeMis = nodes.nodeMis?nodes.nodeMis:model.nodeMisList[0];
        nodes.nodeMgp = @"http://explorer.mgpchain.io:8000";
        [CreateAll SaveCurrentNodes:nodes];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:sysdata forKey:@"sysdata_init_request"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    
}
//取系统初始化信息
+(SystemInitModel *)GetSystemData{
    NSData *sysdata =  [[NSUserDefaults standardUserDefaults] objectForKey:@"sysdata_init_request"];
    if (sysdata == nil || [sysdata isEqual:@""]) {
        return nil;
    }
    SystemInitModel *sysmodel =  [NSKeyedUnarchiver unarchiveObjectWithData:sysdata exception:nil];
    return sysmodel;
}

//存当前节点
+(void)SaveCurrentNodes:(CurrentNodes *)model{
    [model datacheck];
    NSData *modeldata = [NSKeyedArchiver archivedDataWithRootObject:model requiringSecureCoding:NO error:nil];
    [[NSUserDefaults standardUserDefaults] setObject:modeldata forKey:@"currentnodes_init_request"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//取当前节点
+(CurrentNodes *)GetCurrentNodes{
    NSData *modeldata =  [[NSUserDefaults standardUserDefaults] objectForKey:@"currentnodes_init_request"];
    if (modeldata == nil || [modeldata isEqual:@""]) {
        return nil;
    }
    CurrentNodes *model =  [NSKeyedUnarchiver unarchiveObjectWithData:modeldata exception:nil];
    return model;
}
/*
 *********************************************Mis钱包管理********************************************************
 */
//判断mis账号是否注册成功
+(BOOL)ifMisWalletRegistered{
    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"MisWalletRegistered"];
    if(isLogin == YES){
        return YES;
    }else{
        return NO;
    }
}
//标记注册成功
+(void)setmisWalletisRegistered{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"MisWalletRegistered"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


/*
 *********************************************账号本地管理********************************************************
 */
//判断是否登录
+(BOOL)isLogin{
    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"];
    if(isLogin == YES){
        return YES;
    }else{
        return NO;
    }
}

//登录成功 存用户名到keychain
+(void)SaveUserName:(NSString *)username Password:(NSString *)password{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLogin"];
    [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"current_loginuser_name"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//取当前用户名
+(NSString *)GetCurrentUserName{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"current_loginuser_name"]?[[NSUserDefaults standardUserDefaults] objectForKey:@"current_loginuser_name"]:@"";
}

//退出账号
+(void)LogOut{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogin"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"userToken"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"userId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/*
 保存当前用户，最多只存一个用户
 */
+(void)SaveCurrentUser:(UserInfoModel *)model{
    [model vailidateUserInfo];//过滤数据
    //  存userId userToken 请求时加入请求头
    [[NSUserDefaults standardUserDefaults] setObject:model.userToken forKey:@"userToken"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",model.userId] forKey:@"userId"];
    
    NSData *userdata = [NSKeyedArchiver archivedDataWithRootObject:model requiringSecureCoding:NO error:nil];
    [[NSUserDefaults standardUserDefaults] setObject:userdata forKey:@"current_user_info"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/*
 取当前用户
 */
+(UserInfoModel *)GetCurrentUser{
    NSData *userdata =  [[NSUserDefaults standardUserDefaults] objectForKey:@"current_user_info"];
    if (userdata == nil || [userdata isEqual:@""]) {
        return nil;
    }
    UserInfoModel *userinfo = [UserInfoModel new];
    userinfo =  [NSKeyedUnarchiver unarchiveObjectWithData:userdata];
    return userinfo;
}


/*
 保存当货币类型
 */
+(void)SaveCurrentCurrency:(LHCurrencyModel *)model{
    [model vailidateCurrencyModel];//过滤数据
    
    NSData *userdata = [NSKeyedArchiver archivedDataWithRootObject:model requiringSecureCoding:NO error:nil];
    [[NSUserDefaults standardUserDefaults] setObject:userdata forKey:@"current_currency"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/*
 取当前货币类型
 */
+(LHCurrencyModel *)GetCurrentCurrency{
    NSData *userdata =  [[NSUserDefaults standardUserDefaults] objectForKey:@"current_currency"];
    if (userdata == nil || [userdata isEqual:@""]) {
        return nil;
    }
    LHCurrencyModel *userinfo = [LHCurrencyModel new];
    userinfo =  [NSKeyedUnarchiver unarchiveObjectWithData:userdata];
    return userinfo;
}


/*
 存身份验证信息
 */
+(void)SaveUserID:(NSString *)idstring ForUser:(NSString *)name Status:(USERIDENTITY_VERIFY_STATUS)status{
    if (status == USERIDENTITY_VERIFY_NONE) {
        
    }else if (status == USERIDENTITY_VERIFY_FAILD){
        
    }else if (status == USERIDENTITY_VERIFY_SUCCESS){
        NSString *currentusername = [CreateAll GetCurrentUserName];
        if (!currentusername) {
            return;
        }
        [[NSUserDefaults standardUserDefaults] setObject:idstring forKey:[NSString stringWithFormat:@"USERID_VERIFY_FOR_%@",currentusername]];
        [[NSUserDefaults standardUserDefaults] setObject:name forKey:[NSString stringWithFormat:@"USERNAME_VERIFY_FOR_%@",currentusername]];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%u",status] forKey:[NSString stringWithFormat:@"VERIFYSTATUS_VERIFY_FOR_%@",currentusername]];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
/*
 取身份验证信息 ID
 */
+(NSString *)GetUserIDForCurrentUser{
    NSString *currentusername = [CreateAll GetCurrentUserName];
    if (!currentusername) {
        return nil;
    }
    NSString *idstring = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"USERID_VERIFY_FOR_%@",currentusername]];
    return idstring?idstring:@"";
}
/*
 取身份验证信息 姓名
 */
+(NSString *)GetUserNameForCurrentUser{
    NSString *currentusername = [CreateAll GetCurrentUserName];
    if (!currentusername) {
        return nil;
    }
    NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"USERNAME_VERIFY_FOR_%@",currentusername]];
    return name?name:@"";
}
/*
 取身份验证信息 验证状态
 */
+(USERIDENTITY_VERIFY_STATUS)GetUserIDVerifyStatusForCurrentUser{
    NSString *currentusername = [CreateAll GetCurrentUserName];
    if (!currentusername) {
        return -1;
    }
    NSString *statusstr = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"VERIFYSTATUS_VERIFY_FOR_%@",currentusername]];
    if([statusstr isEqualToString:@"1"]){
        return USERIDENTITY_VERIFY_FAILD;
    }else if([statusstr isEqualToString:@"2"]){
        return USERIDENTITY_VERIFY_SUCCESS;
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%u",USERIDENTITY_VERIFY_NONE] forKey:[NSString stringWithFormat:@"VERIFYSTATUS_VERIFY_FOR_%@",currentusername]];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return USERIDENTITY_VERIFY_NONE;
    }
    
}

//验证是否是HexString
+(BOOL)ValidHexString:(NSString *)string{
    NSString *hexStr = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    hexStr = [hexStr lowercaseString];
    NSString *hexChar = @"0123456789abcdefx";
    NSString *temp = nil;
    for(int i =0; i < [hexStr length]; i++){
        temp = [hexStr substringWithRange:NSMakeRange(i, 1)];
        if (![hexChar containsString:temp]) {
            return NO;
        }
    }
    return YES;
}
+ (BOOL)isValidForETH:(NSString *)string{
    
    if (string != nil && ![string hasPrefix:@"0x"]) {
        return NO;
    }
    //校验地址长度
    if (string.length != 42)
    {
        NSLog(@"%@ 地址错误",string);
        return NO;
    }
    return YES;
}


/*
 *********************************************钱包生成/导入/恢复********************************************************
 */
/* 1 * 生成种子
 助记词由长度为128到256位的随机序列(熵)匹配词库而来，随后采用PBKDF2(Password-Based Key Derivation Function 2)推导出更长的种子(seed)。
 生成的种子被用来生成构建deterministic Wallet和推导钱包密钥。
 */
+(NSString *)CreateSeedByMnemonic:(NSString *)mnemonic Password:(NSString *)password{
    NSString *seed = [NYMnemonic deterministicSeedStringFromMnemonicString:mnemonic
                                                                passphrase:@""
                                                                  language:@"english"];
    return seed;
}
/*
 根据mnemonic生成keystore,用于恢复账号，备份私钥，导出助记词等
 */
+(void)CreateKeyStoreByMnemonic:(NSString *)mnemonic WalletAddress:(NSString *)walletAddress Password:(NSString *)password  callback: (void (^)(Account *account, NSError *error))callback{
    
    Account *account = [Account accountWithMnemonicPhrase:mnemonic];
    if (account == nil) {
        NSError *err = [NSError ErrorWithTitle:@"助记词错误" Code:102101];
        callback(nil, err);
    }
    [account encryptSecretStorageJSON:password callback:^(NSString *json) {
        NSLog(@"\n keystore(json) = %@",json);
        [Account decryptSecretStorageJSON:json password:password callback:^(Account *decryptedAccount, NSError *error) {
            if (![account.address.checksumAddress isEqualToString:decryptedAccount.address.checksumAddress]) {
                NSError *err = [NSError ErrorWithTitle:@"keystore生成错误" Code:102100];
                callback(nil, err);
            }else{
                NSLog(NSLocalizedString(@"\n\n\n** keystore 恢复 mnemonic ** = \n %@ \n\n\n", nil),decryptedAccount.mnemonicPhrase);
                //按地址保存keystore
                [[NSUserDefaults standardUserDefaults] setObject:json forKey:[NSString stringWithFormat:@"keystore%@",walletAddress]];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            callback(decryptedAccount,error);
            
        }];
    }];
}


/*
 根据PrivateKey生成keystore,用于恢复账号，备份私钥，导出助记词等
 BTC:keystore用于之后的密码验证
 */
+(void)CreateKeyStoreByPrivateKey:(NSString *)privatekey  WalletAddress:(NSString *)walletAddress Password:(NSString *)password  callback: (void (^)(Account *account, NSError *error))callback{
    //privatekey 用来验证keystore
    //walletAddress 只用来存keystore
    
    Account *account = [Account accountWithPrivateKey:[NSData dataWithHexString:privatekey]];
    if (account == nil) {
        NSError *err = [NSError ErrorWithTitle:@"keystore生成错误" Code:102100];
        callback(nil, err);
    }
    [account encryptSecretStorageJSON:password callback:^(NSString *json) {
        NSLog(@"\n keystore(json) = %@",json);
        [Account decryptSecretStorageJSON:json password:password callback:^(Account *decryptedAccount, NSError *error) {
            if (![account.address.checksumAddress isEqualToString:decryptedAccount.address.checksumAddress]) {
                NSError *err = [NSError ErrorWithTitle:@"keystore生成错误" Code:102100];
                callback(nil, err);
            }else{
                NSLog(NSLocalizedString(@"\n\n\n** keystore 恢复 mnemonic ** = \n %@ \n\n\n", nil),decryptedAccount.mnemonicPhrase);
                //按密码保存keystore
                [[NSUserDefaults standardUserDefaults] setObject:json forKey:[NSString stringWithFormat:@"keystore%@",walletAddress]];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
            }
            callback(decryptedAccount,nil);
            
        }];
    }];
}


////扩展主公钥生成
//+(NSString *)CreateMasterPublicKeyWithSeed:(NSString *)seed{
//    BRBIP32Sequence *seq = [BRBIP32Sequence new];
//    NSData *mpk = [seq masterPublicKeyFromSeed:seed.hexToData];
//    [[NSUserDefaults standardUserDefaults] setObject:mpk forKey:@"masterPublicKey"];
//    //mpk前4位为较验位
//    NSString *mpkstr = [NSString hexWithData:mpk];
//    return  mpkstr;
//}
//
////取主公钥
//+(NSData *)GetMasterPublicKey{
//    NSData *mpk = [[NSUserDefaults standardUserDefaults] objectForKey:@"masterPublicKey"];
//    if (mpk == nil || [mpk isEqual:[NSNull null]]) {
//        return nil;
//    }
//    return mpk;
//}


//扩展账号私钥生成  BIP32 Root Key
+(NSString *)CreateExtendPrivateKeyWithSeed:(NSString *)seed{
    BRBIP32Sequence *seq = [BRBIP32Sequence new];
    //**********BIP32SequenceSerializedPrivateMasterFromSeed
    NSString *xprv = [seq serializedPrivateMasterFromSeed:seed.hexToData];
    // NSLog(@"xprv = %@",xprv);
    return  xprv;
}

////扩展账号公钥生成
//+(NSString *)CreateExtendPublicWithSeed:(NSString *)seed{
//    BRBIP32Sequence *seq = [BRBIP32Sequence new];
//    NSData *mpk = [seq masterPublicKeyFromSeed:seed.hexToData];
//    //*********BIP32SequenceSerializedMasterPublicKey 对应的是"m/0'" (hardened child #0 of the root key)
//    NSString *xpub = [seq serializedMasterPublicKey:mpk];
//    NSLog(@"xpub = %@",xpub);
//    return  xpub;
//}

//根据扩展公钥生成index索引的子BTCKey，用于增加BTC子地址
+(BTCKey *)CreateBTCAddressAtIndex:(UInt32)index ExtendKey:(NSString *)extendedPublicKey{
    BTCKeychain* pubchain = [[BTCKeychain alloc] initWithExtendedKey:extendedPublicKey];
    BTCKey* key = [pubchain keyAtIndex:index];
    return key;
}

/*
 由扩展私钥生成钱包
 指定钱包索引，币种两个参数
 xprv,index,coinType
 */
+(MissionWallet *)CreateWalletByXprv:(NSString*)xprv index:(UInt32)index CoinType:(CoinType)coinType Password:(NSString *)password{
    // BTCKeychain *masterchain = [[BTCKeychain alloc]initWithSeed:seed.hexToData];
    MissionWallet *wallet = [MissionWallet new];
    wallet.coinType = coinType;
    wallet.xprv = xprv;
    BTCKeychain *btckeychainxprv = [[BTCKeychain alloc]initWithExtendedKey:xprv];
    
    //Account Extendedm
    NSString *AccountPath = [NSString stringWithFormat:@"m/44'/%d'/0'",coinType];
    
    // NSLog(@"\n\n path = %@\n\n",AccountPath);
    
    //    NSString *AccountExtendedPrivateKey  =  [btckeychainxprv derivedKeychainWithPath:AccountPath].extendedPrivateKey;
    //    NSString *AccountExtendedPublicKey  = [btckeychainxprv derivedKeychainWithPath:AccountPath].extendedPublicKey;
    // NSLog(@"\n *** Account Extended ***\n pri = %@ \n pub = %@",AccountExtendedPrivateKey,AccountExtendedPublicKey);
    // BIP32 Extended
    NSString *BIP32Path = [NSString stringWithFormat:@"%@/0",AccountPath];
    //    NSString *BIP32ExtendedPrivateKey = [btckeychainxprv derivedKeychainWithPath:BIP32Path].extendedPrivateKey;
    //    NSString *BIP32ExtendedPublicKey = [btckeychainxprv derivedKeychainWithPath:BIP32Path].extendedPublicKey;
    // NSLog(@"\n *** BIP32 Extended ***\n pri = %@ \n pub = %@",BIP32ExtendedPrivateKey,BIP32ExtendedPublicKey);
    
    wallet.AccountExtendedPrivateKey = @"";
    wallet.AccountExtendedPublicKey = @"";
    wallet.BIP32ExtendedPrivateKey = @"";
    wallet.BIP32ExtendedPublicKey = @"";
    
    //第一个地址和私钥m/44'/0'/0'/0  m/44'/60'/0'/0
    BTCKey* key = [[btckeychainxprv derivedKeychainWithPath:BIP32Path] keyAtIndex:index];
    if(coinType == BTC){
        //生成btc找零地址
        [CreateAll CreateBTCChangeAddressByXprv:xprv CoinType:coinType Password:password];
        wallet.walletName = @"BTC";
        NSString *compressedPublicKeyAddress = key.compressedPublicKeyAddress.string;
        NSString *privateKey = key.privateKeyAddress.string;
        NSString *compressedPublicKey = [NSString hexWithData:key.compressedPublicKey];
        wallet.privateKey = privateKey;
        wallet.publicKey = compressedPublicKey;
        wallet.address = compressedPublicKeyAddress;
        wallet.addressarray = [@[compressedPublicKeyAddress] mutableCopy];
        wallet.index = index;
        // NSLog(@"\n BTC  privateKey= %@\n Address = %@\n  PublicKey = %@\n",privateKey,compressedPublicKeyAddress, compressedPublicKey);
        if ([wallet.address isEqualToString:BX_ADDRESS_ENCODE_ADDRESS_A_V0]) {
            return nil;
        }
    }else if(coinType == BTC_TESTNET){
        wallet.walletName = @"BTC";
        [CreateAll CreateBTCChangeAddressByXprv:xprv CoinType:coinType Password:password];
        NSString *compressedPublicKeyAddress = key.addressTestnet.string;
        NSString *privateKey = key.privateKeyAddressTestnet.string;
        NSString *compressedPublicKey = [NSString hexWithData:key.compressedPublicKey];
        wallet.privateKey = privateKey;
        wallet.publicKey = compressedPublicKey;
        wallet.address = compressedPublicKeyAddress;
        wallet.addressarray = [@[compressedPublicKeyAddress] mutableCopy];
        wallet.index = index;
        if ([wallet.address isEqualToString:BX_ADDRESS_ENCODE_ADDRESS_A_V0]) {
            return nil;
        }
        // NSLog(@"\n BTC  privateKey= %@\n Address = %@\n  PublicKey = %@\n",privateKey,compressedPublicKeyAddress, compressedPublicKey);
    }else if (coinType == ETH){
        wallet.walletName = @"ETH";
        Account *account = [Account accountWithPrivateKey:key.privateKeyAddress.data];
        NSString *privateKey = [NSString hexWithData:key.privateKeyAddress.data];
        NSString *compressedPublicKey = [NSString hexWithData:key.compressedPublicKey];
        wallet.privateKey = privateKey;
        wallet.publicKey = compressedPublicKey;
        wallet.address = account.address.checksumAddress;
        wallet.addressarray = [@[account.address.checksumAddress] mutableCopy];
        wallet.index = index;
        // NSLog(@"\n ETH  privateKey= %@\n Address = %@\n  PublicKey = %@\n",privateKey,account.address.checksumAddress, compressedPublicKey);
    }
    
    wallet.walletType = LOCAL_WALLET;//类型标记为本地生成
    wallet.importType = LOCAL_CREATED_WALLET;//类型标记为本地生成
    wallet.selectedBTCAddress = wallet.address;
    wallet.passwordHint = @"";
    return wallet;
}



//生成地址二维码
+(UIImage *)CreateQRCodeForAddress:(NSString *)address{
    if (address == nil || [address isEqualToString:@""]) {
        return nil;
    }
    UIImage *QRCodeImage = [BTCQRCode imageForString:address size:CGSizeMake(180, 180) scale:1.0];
    return QRCodeImage;
}

/*
 ************************************  导入  **************************************************
 BTC -> 助记词，私钥
 ETH -> keyStore,助记词，私钥
 */

//由助记词导入钱包 （存储钱包 生成存储KeyStore）
/*
 return nil; 表示钱包已存在
 */
+(void)ImportWalletByMnemonic:(NSString *)mnemonic CoinType:(CoinType)coinType Password:(NSString *)password PasswordHint:(NSString *)passwordHint callback: (void (^)(MissionWallet *wallet, NSError *error))completionHandler{
    NSString *seed = [CreateAll CreateSeedByMnemonic:mnemonic Password:password];
    NSString *xprv = [CreateAll CreateExtendPrivateKeyWithSeed:seed];
    MissionWallet *wallet = [CreateAll CreateWalletByXprv:xprv index:0 CoinType:coinType Password:password];
    wallet.passwordHint = passwordHint;
    wallet.walletName = [CreateAll GenerateNewWalletNameWithWalletAddress:wallet.address CoinType:coinType];
    if ([wallet.walletName isEqualToString:@"exist"]) {
        NSError *error =[NSError ErrorWithTitle:@"钱包已存在!" Code:102000];
        completionHandler(nil,error);
        return;
    }
    
    wallet.importType = IMPORT_BY_MNEMONIC;
    
    if (wallet.coinType == ETH) {
        //存KeyStore
        [CreateAll CreateKeyStoreByMnemonic:mnemonic WalletAddress:wallet.address Password:password callback:^(Account *account, NSError *error) {
            if (account == nil) {//说明出错
                completionHandler(nil,error);
            }else{
                if (!error) {//无错误
                    
                    //存钱包
                    [CreateAll SaveWallet:wallet Name:wallet.walletName WalletType:IMPORT_WALLET Password:password];
                    completionHandler(wallet,nil);
                }else{
                    completionHandler(nil,error);
                }
            }
        }];
    }else if (wallet.coinType == BTC || wallet.coinType == BTC_TESTNET){
        //存钱包
        [CreateAll SaveWallet:wallet Name:wallet.walletName WalletType:IMPORT_WALLET Password:password];
        completionHandler(wallet,nil);
    }else if (wallet.coinType == EOS){
        [CreateAll SaveWallet:wallet Name:wallet.walletName WalletType:IMPORT_WALLET Password:password];
        completionHandler(wallet,nil);
    }
    //存助记词
    NSString *enmne = [AESCrypt encrypt:mnemonic password:password];
    [SAMKeychain setPassword:enmne forService:PRODUCT_BUNDLE_ID account:[NSString stringWithFormat:@"mnemonic%@",wallet.address]];
    
}

//由私钥导入钱包 （存储钱包 生成存储KeyStore）
/*
 return nil; 表示钱包已存在
 */
+(MissionWallet *)ImportWalletByPrivateKey:(NSString *)privateKey CoinType:(CoinType)coinType Password:(NSString *)password PasswordHint:(NSString *)passwordHint{
    BTCKey *key = nil;
    if (coinType == BTC || coinType == BTC_TESTNET) {
        //只能导入压缩私钥
        NSString *firstchar = [privateKey substringToIndex:1];
        if([firstchar isEqualToString:@"5"]){
            BTCPrivateKeyAddress *pkaddr = [BTCPrivateKeyAddress addressWithString:privateKey];
            pkaddr.publicKeyCompressed = NO;
            key = [[BTCKey alloc] initWithPrivateKey:pkaddr.data];
            key.publicKeyCompressed = NO;
        }else{
            BTCPrivateKeyAddress* pkaddr = [BTCPrivateKeyAddress addressWithString:privateKey];
            NSData *privkeydata = pkaddr.data;
            key = [[BTCKey alloc]initWithPrivateKey:privkeydata];
        }
        
    }else if (coinType == ETH){
        key = [[BTCKey alloc]initWithPrivateKey:[NSData dataWithHexString:privateKey]];
    }
    
    if ([key.privateKey isEqual:[NSNull null]] || [key.publicKey isEqual:[NSNull null]]) {
        return nil;
    }
    if (key.privateKey == nil || key.publicKey == nil) {
        return nil;
    }
    MissionWallet *wallet = [MissionWallet new];
    wallet.xprv = @"";
    wallet.coinType = coinType;
    wallet.AccountExtendedPrivateKey = @"";
    wallet.AccountExtendedPublicKey = @"";
    wallet.BIP32ExtendedPrivateKey = @"";
    wallet.BIP32ExtendedPublicKey = @"";
    
    
    if (coinType == BTC) {
        NSString *firstchar = [privateKey substringToIndex:1];
        if([firstchar isEqualToString:@"5"]){
            wallet.publicKey = [NSString hexWithData:key.uncompressedPublicKey];
            wallet.address = key.uncompressedPublicKeyAddress.string;
        }else{
            wallet.publicKey = [NSString hexWithData:key.compressedPublicKey];
            wallet.address = key.compressedPublicKeyAddress.string;
        }
        wallet.privateKey = privateKey;
        
    }else{
        wallet.publicKey = [NSString hexWithData:key.compressedPublicKey];
        wallet.privateKey = [NSString hexWithData:key.privateKeyAddress.data];
        Account *account = [Account accountWithPrivateKey:key.privateKeyAddress.data];
        wallet.address = account.address.checksumAddress;
    }
    wallet.addressarray = [@[wallet.address] mutableCopy];
    wallet.index = 0;
    wallet.walletType = IMPORT_WALLET;
    wallet.selectedBTCAddress = wallet.address;
    wallet.passwordHint = passwordHint;
    wallet.index = [CreateAll GetCurrentImportWalletIndexWithWalletAddress:wallet.address CoinType:coinType];
    wallet.walletName = [CreateAll GenerateNewWalletNameWithWalletAddress:wallet.address CoinType:coinType];
    if ([wallet.walletName isEqualToString:@"exist"]) {
        return nil;
    }
    wallet.importType = IMPORT_BY_PRIVATEKEY;
    
    if (coinType == ETH){
        BOOL isValid = [CreateAll ValidHexString:wallet.privateKey];
        Account *account = [Account accountWithPrivateKey:[NSData dataWithHexString:wallet.privateKey]];
        if (isValid == NO || account == nil) {
            NSString *depri = [AESCrypt decrypt:wallet.privateKey password:password];
            [CreateAll CreateKeyStoreByPrivateKey:depri WalletAddress:wallet.address Password:password callback:^(Account *account, NSError *error) {
                
            }];
        }else{
            [CreateAll CreateKeyStoreByPrivateKey:wallet.privateKey WalletAddress:wallet.address Password:password callback:^(Account *account, NSError *error) {
                
            }];
        }
    }
    [CreateAll SaveWallet:wallet Name:wallet.walletName WalletType:IMPORT_WALLET Password:password];
    return wallet;
}

//由KeyStore导入钱包 （存储钱包 生成存储KeyStore）eth
/*
 callback(wallet,error); wallet == nil; 表示钱包已存在
 */
+(void)ImportWalletByKeyStore:(NSString *)keystore  CoinType:(CoinType)coinType Password:(NSString *)password PasswordHint:(NSString *)passwordHint callback: (void (^)(MissionWallet *wallet, NSError *error))callback{
    
    [Account decryptSecretStorageJSON:keystore password:password callback:^(Account *decryptedAccount, NSError *error) {
        NSString *privateKey = [NSString hexWithData:decryptedAccount.privateKey];
        MissionWallet *wallet = [CreateAll ImportWalletByPrivateKey:privateKey CoinType:coinType Password:(NSString *)password PasswordHint:passwordHint];
        if (wallet == nil) {
            
            callback(nil,error);
        }else{
            wallet.importType = IMPORT_BY_KEYSTORE;
            [CreateAll SaveWallet:wallet Name:wallet.walletName WalletType:IMPORT_WALLET Password:password];
            callback(wallet,error);
        }
        
    }];
}

//获取当前导入钱包的index
/*
 return -1;表示已存在
 */
+(int)GetCurrentImportWalletIndexWithWalletAddress:(NSString *)address CoinType:(CoinType)coinType{
    //查询本地导入数组中是否已经存在
    int importindex = 0;
    NSArray *importnamearray = [CreateAll GetImportWalletNameArray];
    for (NSString *name in importnamearray) {
        MissionWallet *miswallet = [CreateAll GetMissionWalletByName:name];
        if ([address isEqualToString:miswallet.address]) {
            return -1;
        }else{
            if (miswallet.coinType == coinType) {
                importindex ++;//标记是第几个BTC/ETH钱包
            }
        }
    }
    return importindex;
}
//生成新导入钱包的名称
/*
 return @"exist";表示已存在
 */
+(NSString *)GenerateNewWalletNameWithWalletAddress:(NSString *)address CoinType:(CoinType)coinType{
    //查询本地生成数组中是否已经存在
    NSArray *namearray = [CreateAll GetWalletNameArray];
    for (NSString *name in namearray) {
        MissionWallet *miswallet = [CreateAll GetMissionWalletByName:name];
        if ([address isEqualToString:miswallet.address]) {
            return @"exist";
        }
    }
    //查询本地导入数组中是否已经存在
    NSInteger importindex = 1;
    NSArray *importnamearray = [CreateAll GetImportWalletNameArray];
    for (NSString *name in importnamearray) {
        MissionWallet *miswallet = [CreateAll GetMissionWalletByName:name];
        if ([address isEqualToString:miswallet.address]) {
            return @"exist";
        }else{
            if (miswallet.coinType == coinType) {
                importindex ++;//标记是第几个BTC/ETH/EOS钱包
            }
        }
    }
    //本地不存在，存储
    NSString *savewalletname = @"";
    if (coinType == BTC || coinType == BTC_TESTNET) {
        savewalletname = [NSString stringWithFormat:@"BTC(%ld)",importindex];
    }else if(coinType == ETH){
        savewalletname = [NSString stringWithFormat:@"ETH(%ld)",importindex];
    }else if(coinType == EOS){
        savewalletname = [NSString stringWithFormat:@"EOS(%ld)",importindex];
    }else if(coinType == MGP){
        savewalletname = [NSString stringWithFormat:@"MGP(%ld)",importindex];
    }
    return savewalletname;
}


/*
 ************************************************ 钱包导出 *********************************************************************
 */
//导出keystore eth
+(void)ExportKeyStoreByPassword:(NSString *)password  WalletAddress:(NSString *)walletAddress callback: (void (^)(NSString *address, NSError *error))callback{
    NSString *json = [[NSUserDefaults standardUserDefaults]  objectForKey:[NSString stringWithFormat:@"keystore%@",walletAddress]];
    
    if (json == nil || [json isEqual:[NSNull null]]) {
        callback(nil,nil);
        return;
    }
    [Account decryptSecretStorageJSON:json password:password callback:^(Account *decryptedAccount, NSError *error) {
        callback(decryptedAccount.address.checksumAddress,error);
    }];
}
//导出助记词 btc eth
+(void)ExportMnemonicByPassword:(NSString *)password WalletAddress:(NSString *)walletAddress callback: (void (^)(NSString *mnemonic, NSError *error))callback{
    //    NSString *psd = [SAMKeychain passwordForService:PRODUCT_BUNDLE_ID account:walletAddress];
    NSString *psdinfo = [SAMKeychain passwordForService:PRODUCT_BUNDLE_ID account:walletAddress];
    NSString *deinfo = [AESCrypt decrypt:psdinfo password:password];
    if(![deinfo isEqualToString:walletAddress]){
        callback(nil,nil);
        return;
    }
    NSString *mne = [SAMKeychain passwordForService:PRODUCT_BUNDLE_ID account:[NSString stringWithFormat:@"mnemonic%@",walletAddress]];
    NSString *demne = [AESCrypt decrypt:mne password:password];
    callback(demne,nil);
}
//导出私钥 eth
+(void)ExportPrivateKeyByPassword:(NSString *)password CoinType:(CoinType)coinType WalletAddress:(NSString *)walletAddress  index:(UInt32)index  callback: (void (^)(NSString *privateKey, NSError *error))callback{
    NSString *json = [[NSUserDefaults standardUserDefaults]  objectForKey:[NSString stringWithFormat:@"keystore%@",walletAddress]];
    if (json == nil || [json isEqual:[NSNull null]]) {
        callback(nil,nil);
        return;
    }
    [Account decryptSecretStorageJSON:json password:password callback:^(Account *decryptedAccount, NSError *error) {
        
        NSString *hexprivatekey = [NSString hexWithData:decryptedAccount.privateKey];
        callback(hexprivatekey,error);
    }];
}
//验证钱包密码
+(BOOL)VerifyPassword:(NSString *)password ForWalletAddress:(NSString *)walletAddress{
    /*
     防止跨应用访问漏洞
     keychain上存储的是使用密码加密的地址
     使用密码解密出的地址与地址作对比，验证密码
     */
    NSString *psdinfo = [SAMKeychain passwordForService:PRODUCT_BUNDLE_ID account:walletAddress];
    NSString *deinfo = [AESCrypt decrypt:psdinfo password:password];
    if([deinfo isEqualToString:walletAddress]){
        return YES;
    }else{
        return NO;
    }
}
/*
 ********************************************** 钱包账号存取管理 *******************************************************************
 */
//清空所有钱包，退出账号
+(void)RemoveAllWallet{
    [CreateAll clearAllUserDefaultsData];
    //1.获得数据库文件的路径
    NSString *doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName=[doc stringByAppendingPathComponent:@"changeaddress.sqlite"];
    //2.获得数据库
    FMDatabase *db=[FMDatabase databaseWithPath:fileName];
    
    //3.打开数据库
    if ([db open]) {
        [CreateAll DeleteChangeAddressTable:db];
    }
    [db close];
}

/**
 *  清除所有的存储本地的数据
 */
+ (void)clearAllUserDefaultsData
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *dic = [userDefaults dictionaryRepresentation];
    for (id  key in dic) {
        [userDefaults removeObjectForKey:key];
    }
    [userDefaults synchronize];
    
    [[NTVLocalized sharedInstance] initLanguage];
    NSString *currentSelected = [[NSUserDefaults standardUserDefaults]objectForKey:@"CurrentLanguageSelected"];
    NSString *currency;
    if ([currentSelected isEqualToString:@"english"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"english" forKey:@"CurrentLanguageSelected"];
        currency = @"dollar";
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NTVLocalized sharedInstance] setLanguage:@"en"];//zh-Hans
    }else if ([currentSelected isEqualToString:@"chinese"]){
        [[NSUserDefaults standardUserDefaults] setObject:@"chinese" forKey:@"CurrentLanguageSelected"];
        currency = @"rmb";
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NTVLocalized sharedInstance] setLanguage:@"zh-Hans"];//zh-Hans
    }else{//没设置过语言 按系统的语言
        NSArray *languages=[NSLocale preferredLanguages];
        NSString *currentLanguage=[languages objectAtIndex:0];
        if ([currentLanguage isEqualToString:@""]) {
            [[NSUserDefaults standardUserDefaults] setObject:@"english" forKey:@"CurrentLanguageSelected"];
            currency = @"dollar";
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[NTVLocalized sharedInstance] setLanguage:@"en"];//zh-Hans
        }else{
            [[NSUserDefaults standardUserDefaults] setObject:@"chinese" forKey:@"CurrentLanguageSelected"];
            currency = @"rmb";
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[NTVLocalized sharedInstance] setLanguage:@"zh-Hans"];//zh-Hans
        }
    }
    
    NSString *currentCurrency = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentCurrencySelected"];
    if ([currentCurrency isEqualToString:@"dollar"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"dollar" forKey:@"CurrentCurrencySelected"];
    }else if([currentCurrency isEqualToString:@"rmb"]){
        [[NSUserDefaults standardUserDefaults] setObject:@"rmb" forKey:@"CurrentCurrencySelected"];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:currency forKey:@"CurrentCurrencySelected"];
    }
    
    //YES 跌红涨绿 NO 涨红跌绿
    BOOL colorConfig = [[NSUserDefaults standardUserDefaults] boolForKey:@"RiseColorConfig"];
    if(colorConfig != YES){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"RiseColorConfig"];
    }else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"RiseColorConfig"];
    }
    
    NSString *mysymbol = [[NSUserDefaults standardUserDefaults] objectForKey:@"MySymbol"];
    if ([mysymbol isEqual:[NSNull null]] || mysymbol == nil) {
        mysymbol = @"BTC,ETH,EOS,";
        [[NSUserDefaults standardUserDefaults] setObject:mysymbol forKey:@"MySymbol"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [[CustomizedTabBarController sharedCustomizedTabBarController] resetbartitle];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NetManager SysInitCompletionHandler:^(id responseObj, NSError *error) {
            if (!error) {
                if ([[NSString stringWithFormat:@"%@",responseObj[@"resultCode"]] isEqualToString:@"20000"]) {
                    NSDictionary *dic;
                    dic = responseObj[@"data"];
                    SystemInitModel *model = [SystemInitModel parse:dic];
                    if(model){
                        [CreateAll SaveSystemData:model];
                    }
                }
            }else{
            }
        }];
    });
}

//取得所有钱包名称（不包含导入）
+(NSArray *)GetWalletNameArray{
    NSArray *walletarray = [[NSUserDefaults standardUserDefaults]  objectForKey:@"walletArray"];
    return walletarray;
}

//取得所有导入的钱包名称
+(NSArray *)GetImportWalletNameArray{
    NSArray *walletarray = [[NSUserDefaults standardUserDefaults]  objectForKey:@"importwalletArray"];
    return walletarray;
}

//取某币种类型的钱包
+(NSArray *)GetWalletArrayByCoinType:(CoinType)type{
    NSArray *walletarray0 = [[NSUserDefaults standardUserDefaults]  objectForKey:@"walletArray"];
    NSArray *walletarray = [[NSUserDefaults standardUserDefaults]  objectForKey:@"importwalletArray"];
    NSMutableArray *namearr = [NSMutableArray arrayWithArray:walletarray0];
    [namearr addObjectsFromArray:walletarray];
    NSMutableArray *arr = [NSMutableArray new];
    for (NSString *name in namearr) {
        MissionWallet *wallet = [CreateAll GetMissionWalletByName:name];
        if (wallet.coinType == type) {
            [arr addObject:wallet];
        }
    }
    return arr;
}


//根据钱包名称取钱包
+(MissionWallet *)GetMissionWalletByName:(NSString *)walletname{
    NSData *walletdata =  [[NSUserDefaults standardUserDefaults] objectForKey:walletname];
    if (walletdata == nil || [walletdata isEqual:@""]) {
        return nil;
    }
    MissionWallet *wallet =  [NSKeyedUnarchiver unarchiveObjectWithData:walletdata exception:nil];
    return wallet;
}
//存取密码提示(本地钱包)
+(void)UpdatePasswordHint:(NSString *)passwordHint{
    [[NSUserDefaults standardUserDefaults] setObject:passwordHint forKey:@"passwordHint"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSString *)GetPasswordHint{
    NSString *passwordHint = [[NSUserDefaults standardUserDefaults] objectForKey:@"passwordHint"];
    if (!passwordHint) {
        passwordHint = @"";
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"passwordHint"];
    }
    return passwordHint;
}
//删除钱包
+(BOOL)RemoveWallet:(MissionWallet *)wallet{
    
    //如果是本地创建类型 存储到本地钱包名数组
    if (wallet.walletType == LOCAL_WALLET) {
        NSMutableArray *oldwalletarray = [[[NSUserDefaults standardUserDefaults]  objectForKey:@"walletArray"] mutableCopy];
        if (oldwalletarray == nil || [oldwalletarray containsObject:wallet.walletName]) {
            if (oldwalletarray == nil) {
                return NO;
            }
            [oldwalletarray removeObject:wallet.walletName];
            NSMutableArray *newwalletarray = [oldwalletarray mutableCopy];
            [[NSUserDefaults standardUserDefaults]  setObject:newwalletarray forKey:@"walletArray"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:wallet.walletName];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return YES;
}

//移除导入的钱包
/*
 return @"WalletType is LOCAL_WALLET !";
 return @"Delete WalletName Failed!";
 return @"Delete Wallet Failed!";
 return @"Delete Successed!"; 成功
 */
+(NSString *)RemoveImportedWallet:(MissionWallet *)wallet{
    //只能移除导入的钱包
    if (wallet.walletType == LOCAL_WALLET) {
        return @"WalletType is LOCAL_WALLET !";
    }
    
    CoinType deltype = wallet.coinType;
    BOOL deleteName;
    BOOL deleteWallet;
    if (wallet.coinType == EOS && wallet.walletType == IMPORT_WALLET) {
        //移除钱包名
        deleteName = [CreateAll DeleteWalletFromImportWalletNameArray:wallet.walletName];
        //移除钱包
        deleteWallet = [CreateAll DeleteWallet:wallet.address WalletName:wallet.walletName];
    }else{
        //移除钱包名
        deleteName = [CreateAll DeleteWalletFromImportWalletNameArray:wallet.walletName];
        //移除钱包
        deleteWallet = [CreateAll DeleteWallet:wallet.address WalletName:wallet.walletName];
    }
    
    if (deleteName == NO) {
        return @"Delete WalletName Failed!";
    }
    if (deleteWallet == NO) {
        return @"Delete Wallet Failed!";
    }
    if(wallet.coinType == BTC){
        //1.获得数据库文件的路径
        NSString *doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *fileName=[doc stringByAppendingPathComponent:@"changeaddress.sqlite"];
        //2.获得数据库
        FMDatabase *db=[FMDatabase databaseWithPath:fileName];
        
        //3.打开数据库
        if ([db open]) {
            [CreateAll delete:db walletaddress:wallet.address];
        }
        [db close];
    }
    if (wallet.coinType == EOS) {
        NSArray *namearr = [CreateAll GetImportWalletNameArray];
        for (NSString *name in namearr) {
            MissionWallet *walletedit = [CreateAll GetMissionWalletByName:name];
            if (walletedit.coinType == EOS) {
                //index大于被删EOS钱包的 重新计算index
                if(walletedit.index >= wallet.index){
                    walletedit.index -= 1;
                    //存为新的
                    [CreateAll SaveWallet:walletedit Name:walletedit.walletName WalletType:walletedit.walletType Password:nil];
                }
            }
        }
    }else{
        NSString *str0 = [wallet.walletName componentsSeparatedByString:@"("].lastObject;
        NSString *str1 = [str0 componentsSeparatedByString:@")"].firstObject;
        //修改剩余同币种钱包的名称
        NSInteger delindex = str1.integerValue;
        NSArray *namearr = [CreateAll GetImportWalletNameArray];
        for (NSString *name in namearr) {
            NSString *str0 = [name componentsSeparatedByString:@"("].lastObject;
            NSString *str1 = [str0 componentsSeparatedByString:@")"].firstObject;
            NSInteger currindex = str1.integerValue;
            
            if (currindex > delindex) {//删除的钱包后面的钱包 需要重命名
                MissionWallet *walletedit = [CreateAll GetMissionWalletByName:name];
                if (walletedit.coinType == deltype) {
                    
                    NSString *str0 = [name componentsSeparatedByString:@"("].firstObject;
                    NSString *str1 = [str0 stringByAppendingString:[NSString stringWithFormat:@"(%ld)",currindex-1]];
                    walletedit.walletName = str1;
                    //存为新的
                    [CreateAll SaveWallet:walletedit Name:walletedit.walletName WalletType:walletedit.walletType Password:nil];
                    //删除旧的
                    //移除钱包名
                    BOOL deleteName = [CreateAll DeleteWalletFromImportWalletNameArray:name];
                    //移除钱包
                    BOOL deleteWallet = [CreateAll DeleteWallet:walletedit.address WalletName:name];
                    if (deleteName == NO) {
                        return @"Delete WalletName Failed!";
                    }
                    if (deleteWallet == NO) {
                        return @"Delete Wallet Failed!";
                    }
                }
                
            }
        }
        
    }
    
    
    return @"Delete Successed!";
}

//存储钱包
/*
 EOS:
 本地未注册帐号walletName = EOS_ , address = EOS_Temp
 导入一定有帐号：walletName = EOS_'eosaccount' , address = 'eosaccount'
 @"importwalletArray" 存walletName
 walletdata 本地EOS key = walletName 导入：key = walletName
 
 */
+(void)SaveWallet:(MissionWallet *)wallet Name:(NSString *)walletname WalletType:(WALLET_TYPE)walletType Password:(NSString *)password{
    //password预留
    wallet.walletName = walletname;
    wallet.walletType = walletType;
    if (wallet.coinType == EOS && wallet.walletType == LOCAL_WALLET && wallet.address.length < 2) {
        wallet.address = @"EOS_Temp";
    }
    if (wallet.coinType == MGP && wallet.walletType == LOCAL_WALLET && wallet.address.length < 2) {
        wallet.address = @"MGP_Temp";
    }
    //1.存钱包
    //导入的钱包，根据顺序排index
    if (wallet.walletType == IMPORT_WALLET) {
        NSMutableArray *namearray = [[[NSUserDefaults standardUserDefaults]  objectForKey:@"importwalletArray"] mutableCopy];
        int indexForWallet = 1;
        for (NSString *str in namearray) {
            if(![str isEqualToString:walletname]){
                if (wallet.coinType == BTC || wallet.coinType == BTC_TESTNET) {
                    if([str containsString:@"BTC"]){
                        indexForWallet ++;
                    }
                }else if (wallet.coinType == ETH){
                    if([str containsString:@"ETH"]){
                        indexForWallet ++;
                    }
                }else if (wallet.coinType == MIS){
                    if([str containsString:@"MIS"]){
                        indexForWallet ++;
                    }
                }
            }
            MissionWallet *miswallet = [CreateAll GetMissionWalletByName:str];
            if ([wallet.address isEqualToString:miswallet.address]) {
                
            }else{
                if (miswallet.coinType == EOS || miswallet.coinType == MGP) {
                    indexForWallet ++;
                }
            }
        }
        wallet.index = indexForWallet;
    }
    
    
    
    //根据地址存密码加密的地址到keychain
    if (password != nil && ![password isEqualToString:@""]) {
        /*
         防止跨应用访问漏洞
         keychain上存储的是使用密码加密的地址
         使用密码解密出的地址与地址作对比，验证密码
         */
        
        NSString *enaddr = [AESCrypt encrypt:wallet.address password:password];
        [SAMKeychain setPassword:enaddr forService:PRODUCT_BUNDLE_ID account:wallet.address];
        
        /*
         需要解密私钥的情况：
         1.导出钱包私钥
         2.EOS资源管理
         3.转账
         */
        NSString *enxprv = [AESCrypt encrypt:wallet.xprv password:password];
        wallet.xprv = enxprv;
        //加密钱包私钥
        if((wallet.coinType == BTC || wallet.coinType == EOS || wallet.coinType == MIS || wallet.coinType == MGP) && [wallet.privateKey isValidBitcoinPrivateKey]){
            NSString *enpri = [AESCrypt encrypt:wallet.privateKey password:password];
            wallet.privateKey = enpri;
        }
        if (wallet.coinType == ETH) {
            if([wallet.privateKey containsString:@"0x"]){
                wallet.privateKey = [wallet.privateKey substringFromIndex:2];
            }
            BOOL isValid = [CreateAll ValidHexString:wallet.privateKey];
            Account *account = [Account accountWithPrivateKey:[NSData dataWithHexString:wallet.privateKey]];
            if (isValid == YES && account != nil) {
                NSString *enpri = [AESCrypt encrypt:wallet.privateKey password:password];
                wallet.privateKey = enpri;
            }
        }
    }
    // NSData *walletdata = [NSKeyedArchiver archivedDataWithRootObject:wallet];
    NSData *walletdata = [NSKeyedArchiver archivedDataWithRootObject:wallet requiringSecureCoding:NO error:nil];
    [[NSUserDefaults standardUserDefaults] setObject:walletdata forKey:walletname];
    //2.存钱包名
    //如果是本地创建类型 存储到本地钱包名数组
    if (walletType == LOCAL_WALLET) {
        NSMutableArray *oldwalletarray = [[[NSUserDefaults standardUserDefaults]  objectForKey:@"walletArray"] mutableCopy];
        if (oldwalletarray == nil || ![oldwalletarray containsObject:walletname]) {
            if (oldwalletarray == nil) {
                oldwalletarray = [NSMutableArray array];
            }
            [oldwalletarray addObject:walletname];
            NSMutableArray *newwalletarray = [oldwalletarray mutableCopy];
            [[NSUserDefaults standardUserDefaults]  setObject:newwalletarray forKey:@"walletArray"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    //如果是导入类型 存储到导入钱包名数组
    if (walletType == IMPORT_WALLET) {
        
        NSMutableArray *oldimportwalletarray = [[[NSUserDefaults standardUserDefaults]  objectForKey:@"importwalletArray"] mutableCopy];
        if (oldimportwalletarray == nil || ![oldimportwalletarray containsObject:walletname]) {
            if (oldimportwalletarray == nil) {
                oldimportwalletarray = [NSMutableArray array];
            }
            if (wallet.coinType == EOS && wallet.walletType == IMPORT_WALLET) {
                [oldimportwalletarray addObject:walletname];
            }else{
                [oldimportwalletarray addObject:walletname];
            }
            
            NSMutableArray *newimportwalletarray = [oldimportwalletarray mutableCopy];
            [[NSUserDefaults standardUserDefaults]  setObject:newimportwalletarray forKey:@"importwalletArray"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    
}
//移除钱包名
+(BOOL)DeleteWalletFromImportWalletNameArray:(NSString *)walletname{
    NSMutableArray *oldimportwalletarray = [[[NSUserDefaults standardUserDefaults]  objectForKey:@"importwalletArray"] mutableCopy];
    if ([oldimportwalletarray containsObject:walletname]) {
        [oldimportwalletarray removeObject:walletname];
        NSMutableArray *newimportwalletarray = [oldimportwalletarray mutableCopy];
        [[NSUserDefaults standardUserDefaults]  setObject:newimportwalletarray forKey:@"importwalletArray"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }else{
        return NO;
    }
}
//移除钱包
+(BOOL)DeleteWallet:(NSString *)walletaddress WalletName:(NSString *)walletname{
    MissionWallet *miswallet = [CreateAll GetMissionWalletByName:walletname];
    if ([walletaddress isEqualToString:miswallet.address]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:walletname];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }else{
        return NO;
    }
}





/*
 ********************************************** BTC转账 *******************************************************************
 */

/*
 BTC 找零地址生成100条 并存入数据库**********************************
 */
+(void)CreateBTCChangeAddressByXprv:(NSString*)xprv CoinType:(CoinType)coinType Password:(NSString *)password{
    
    if (![xprv containsString:@"xprv"]) {
        xprv = [AESCrypt decrypt:xprv password:password];
    }
    //1.获得数据库文件的路径
    NSString *doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName=[doc stringByAppendingPathComponent:@"changeaddress.sqlite"];
    //2.获得数据库
    FMDatabase *db=[FMDatabase databaseWithPath:fileName];
    
    //3.打开数据库
    if ([db open]) {
        //4.创表 (walletaddress, index, privatekey,publickey,changeaddress changeaddressstatus)
        BOOL result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS ChangeAdress(id integer PRIMARY KEY AUTOINCREMENT, walletaddress text NOT NULL, addrindex integer NOT NULL, privatekey text NOT NULL, publickey text NOT NULL, changeaddress text NOT NULL, changeaddressstatus integer NOT NULL);"];
        if (result) {
            NSLog(@"创表成功");
        }else{
            NSLog(@"创表失败");
            return;
        }
    }
    NSString *basepath = [NSString stringWithFormat:@"m/44'/%d'/0'/",coinType];
    BTCKeychain *btckeychainxprv = [[BTCKeychain alloc]initWithExtendedKey:xprv];
    BTCKey* key0 = [[btckeychainxprv derivedKeychainWithPath:[basepath stringByAppendingString:@"0"]] keyAtIndex:0];
    
    NSString *BIP32Path = [basepath stringByAppendingString:@"1"];
    for (int index = 0; index < 100; index++) {
        BTCKey* key = [[btckeychainxprv derivedKeychainWithPath:BIP32Path] keyAtIndex:index];
        if (coinType == BTC) {
            [CreateAll insert:db WalletAddress:key0.address.string Data:key Index:index CoinType:coinType Password:password];
        }else if (coinType == BTC_TESTNET){
            [CreateAll insert:db WalletAddress:key0.addressTestnet.string Data:key Index:index CoinType:coinType Password:password];
        }
    }
    
    [db close];
}
////给指定的BTC钱包新增一条找零地址
//+(BOOL)addChangeAddressForWalletAddress:(NSString *)walletaddr Key:(NSString *)xprv CoinType:(CoinType)coinType{
//    if ([xprv isEqualToString:@""] || xprv == nil) {
//        return NO;
//    }
//    //1.获得数据库文件的路径
//    NSString *doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *fileName=[doc stringByAppendingPathComponent:@"changeaddress.sqlite"];
//    //2.获得数据库
//    FMDatabase *db=[FMDatabase databaseWithPath:fileName];
//    //3.打开数据库
//    if ([db open]) {
//        FMResultSet *resultSet = [db executeQuery:@"select * from ChangeAdress where addrindex =(select max(addrindex) from ChangeAdress where walletaddress = ?)",walletaddr];
//        int index = 0;
//        while ([resultSet next]) {
//            index = [resultSet intForColumn:@"addrindex"] + 1;
//        }
//        BTCKeychain *btckeychainxprv = [[BTCKeychain alloc]initWithExtendedKey:xprv];
//        BTCKey* key = [[btckeychainxprv derivedKeychainWithPath:@"m/44'/0'/0'/1"] keyAtIndex:index];
//        [CreateAll insert:db WalletAddress:walletaddr Data:key Index:index CoinType:coinType];
//    }
//    
//    [db close];
//    return NO;
//}

//更新数据 根据changeaddress 记录地址当前是否使用过 (1000 unused/1001used)
+(BOOL)updateStatus:(FMDatabase *)db ChangeAddr:(NSString *)changeaddress Status:(NSInteger)status{
    return [db executeUpdate:@"UPDATE ChangeAdress SET changeaddressstatus = ? WHERE changeaddress = ?",status, changeaddress];
}

//更新数据 根据index 记录地址当前是否使用过 (1000 unused/1001used)
+(BOOL)updateStatus:(FMDatabase *)db Index:(NSInteger)index Status:(NSInteger)status{
    return [db executeUpdate:@"UPDATE ChangeAdress SET changeaddressstatus = ? WHERE addrindex = ?",status, index];
}

//更新数据 根据index 记录地址当前是否使用过 (1000 unused/1001used)
+(BOOL)updateStatus:(FMDatabase *)db FromZeroToIndex:(NSInteger)index Status:(NSInteger)status{
    return [db executeUpdate:@"UPDATE ChangeAdress SET changeaddressstatus = ? WHERE addrindex < ?",status, index];
}

//插入数据
+(BOOL)insert:(FMDatabase *)db WalletAddress:(NSString *)walletaddr Data:(BTCKey *)key Index:(int)index CoinType:(CoinType)coinType Password:(NSString *)password{
    NSString *compressedPublicKeyAddress = @"";
    NSString *privateKey = @"";
    NSString *compressedPublicKey = @"";
    if (coinType == BTC) {
        compressedPublicKeyAddress = key.address.string;
        privateKey = key.privateKeyAddress.string;
        compressedPublicKey = [NSString hexWithData:key.compressedPublicKey];
    }else if (coinType == BTC_TESTNET){
        compressedPublicKeyAddress = key.addressTestnet.string;
        privateKey = key.privateKeyAddressTestnet.string;
        compressedPublicKey = [NSString hexWithData:key.compressedPublicKey];
    }
    //存加密私钥
    NSString *enpri = [AESCrypt encrypt:privateKey password:password];
    return [db executeUpdateWithFormat:@"INSERT INTO ChangeAdress (walletaddress, addrindex, privatekey, publickey,changeaddress ,changeaddressstatus) VALUES (%@, %i, %@, %@, %@, %i);", walletaddr,index,enpri,compressedPublicKey,compressedPublicKeyAddress,1000];
    
}
//删除找零地址表
+(BOOL)DeleteChangeAddressTable:(FMDatabase *)db{
    //如果表格存在 则销毁
    return [db executeUpdate:@"drop table if exists ChangeAdress;"];
}

//删除数据
+(BOOL)delete:(FMDatabase *)db walletaddress:(NSString *)walletaddress{
    //
    return  [db executeUpdate:@"DELETE FROM ChangeAdress WHERE walletaddress = ?",walletaddress];
}
//查询所有用过的找零地址
+(NSArray *)queryAllchange:(FMDatabase *)db Address:(NSString *)walletaddress{
    // 1.执行查询语句
    FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM ChangeAdress WHERE walletaddress = ?",walletaddress];
    
    // 2.遍历结果
    NSMutableArray *array = [NSMutableArray new];
    while ([resultSet next]) {
        BTCChangeAddressModel *model = [BTCChangeAddressModel new];
        model.walletaddress = [resultSet stringForColumn:@"walletaddress"];
        model.privatekey = [resultSet stringForColumn:@"privatekey"];
        model.publickey = [resultSet stringForColumn:@"publickey"];
        model.changeaddress = [resultSet stringForColumn:@"changeaddress"];
        model.index = [resultSet intForColumn:@"addrindex"];
        model.changeaddressstatus = [resultSet intForColumn:@"changeaddressstatus"];
        [array addObject:model];
    }
    return array;
}
//查询索引
+ (NSArray *)query:(FMDatabase *)db walletaddress:(NSString *)walletaddress changeAddress:(NSString *)changeaddress{
    // 1.执行查询语句
    FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM ChangeAdress WHERE walletaddress = ? AND changeaddress = ?",walletaddress,changeaddress];
    
    // 2.遍历结果
    NSMutableArray *array = [NSMutableArray new];
    while ([resultSet next]) {
        BTCChangeAddressModel *model = [BTCChangeAddressModel new];
        model.walletaddress = [resultSet stringForColumn:@"walletaddress"];
        model.privatekey = [resultSet stringForColumn:@"privatekey"];
        model.publickey = [resultSet stringForColumn:@"publickey"];
        model.changeaddress = [resultSet stringForColumn:@"changeaddress"];
        model.index = [resultSet intForColumn:@"addrindex"];
        model.changeaddressstatus = [resultSet intForColumn:@"changeaddressstatus"];
        [array addObject:model];
    }
    return array;
}

//广播交易
+ (void)extracted:(NSString *)broadcastTX callback:(void (^)(NSString *, NSError *))callback {
    [NetManager BroadcastBTCTransactionData:broadcastTX completionHandler:^(id responseObj, NSError *error) {
        if (!error) {
            NSString *hexstring = [NSString hexWithData:responseObj];
            NSString *string = [NSString stringFromHexString:hexstring];
            NSString *txid = [[string componentsSeparatedByString:@"\"txid\":\""].lastObject componentsSeparatedByString:@"\"}"].firstObject;
            callback(txid,error);
        }else{
            callback(responseObj,error);
        }
        
    }];
}

//转账
+(void)BTCTransactionFromWallet:(MissionWallet *)wallet ToAddress:(NSString *)address Amount:(BTCAmount)amount
                            Fee:(BTCAmount)fee
                            Api:(BTCAPI)btcApi
                       Password:(NSString *)password
                       callback: (void (^)(NSString *result, NSError *error))callback{
    //确定找零地址
    BTCPublicKeyAddress *changeAddress;
    BTCPublicKeyAddress *toAddress;
    NSInteger index = (arc4random() % 100);
    NSString *changeaddr;
    if (wallet.changeAddressArray.count >= 100) {
        //hd钱包助记词导入，有100个找零地址，随机生成
        changeaddr = ((BTCChangeAddressModel *)wallet.changeAddressArray[index]).changeaddress;
    }else{
        //私钥导入，只有一个地址
        changeaddr = wallet.address;
    }
    //切换主网，测试网
    if (ChangeToTESTNET == 0) {
        changeAddress = [BTCPublicKeyAddress addressWithString:changeaddr];
        toAddress = [BTCPublicKeyAddress addressWithString:address];
    }else if (ChangeToTESTNET == 1){
        //m,n,2
        changeAddress = [BTCPublicKeyAddressTestnet addressWithString:changeaddr];
        toAddress = [BTCPublicKeyAddressTestnet addressWithString:address];
    }
    
    [CreateAll transactionSpendingFromPrivateKey:wallet
                                              to:toAddress
                                          change:changeAddress
                                          amount:amount
                                             fee:fee
                                             api:btcApi
                                        Password:(NSString *)password
                                        callback:^(BTCTransaction *transaction, NSError *error) {
                                            //交易是否构建成功
                                            if (!transaction) {
                                                NSLog(@"Can't make a transaction");
                                                callback(nil, error);
                                                return;
                                            }
                                            //
                                            NSLog(@"transaction = %@", transaction.dictionary);
                                            NSLog(@"transaction in hex:\n------------------\n%@\n------------------\n", BTCHexFromData([transaction data]));
                                            NSString *broadcastTX = BTCHexFromData([transaction data]);
                                            NSLog(@"Sending ...");
                                            
                                            //广播交易
                                            [self extracted:broadcastTX callback:^(NSString *string, NSError *error) {
                                                //返回交易id，或者错误
                                                callback(string,error);
                                            }];
                                            
                                        }];
    
    
}

// Simple method for now, fetching unspent coins on the fly
+ (void) transactionSpendingFromPrivateKey:(MissionWallet*)wallet
                                        to:(BTCPublicKeyAddress*)destinationAddress
                                    change:(BTCPublicKeyAddress*)changeAddress
                                    amount:(BTCAmount)amount
                                       fee:(BTCAmount)fee
                                       api:(BTCAPI)btcApi
                                  Password:(NSString *)password
                                  callback: (void (^)(BTCTransaction *result, NSError *error))callback
{
    // 1. Get a private key, destination address, change address and amount
    // 2. Get unspent outputs for that key (using both compressed and non-compressed pubkey)
    // 3. Take the smallest available outputs to combine into the inputs of new transaction
    // 4. Prepare the scripts with proper signatures for the inputs
    // 5. Broadcast the transaction
    
    __block NSArray* utxos = nil;
    
    NSString *addr;
    if (wallet.changeAddressArray != nil && wallet.changeAddressArray.count > 0) {
        addr = [wallet.changeAddressStr stringByReplacingOccurrencesOfString:@"," withString:@"|"];
    }else{
        addr = wallet.address;
    }
//    //查询未花费utxo
//    [NetManager GetBTCUTXOFromBlockChainAddress:addr MinumConfirmations:0 completionHandler:^(id responseObj, NSError *error) {
//        if (!error) {
//            if (!responseObj) {
//                return ;
//            }
//
//            NSArray *utxoarr = [BTCBlockChainUTXOModel parse:responseObj[@"unspent_outputs"]];
//            NSMutableArray *utoxarray = [NSMutableArray new];
//            for (BTCBlockChainUTXOModel *model in utxoarr) {
//                if(model.tx_output_n == 0 && model.confirmations <1){//转入未确认
//                    [utoxarray addObject:model];//gai
//                }else if(model.tx_output_n == 0 && model.confirmations >=1){//转入 确认>1
//                    [utoxarray addObject:model];
//                }else if(model.tx_output_n > 0 && model.confirmations <1){//转出未确认
//                    [utoxarray addObject:model];
//                }else if(model.tx_output_n > 0 && model.confirmations >=1){//转出 确认>=1
//                    [utoxarray addObject:model];
//                }
//            }
//            utxos = utoxarray;
//            //具体构建交易
//            [CreateAll DoTransBTCKey:wallet UTXO:utxos to:destinationAddress change:changeAddress amount:amount fee:fee api:btcApi  Password:(NSString *)password callback:^(BTCTransaction *result, NSError *error) {
//                callback(result,error);
//            }];
//        }else{
//            callback(nil,error);
//        }
//    }];
    [NetManager GetUTXOByBTCAdress:([wallet.changeAddressStr isEqualToString:@""] || wallet.changeAddressStr == nil)?wallet.address:wallet.changeAddressStr completionHandler:^(id responseObj, NSError *error) {
        if (!error) {
            NSArray *array = (NSArray *)responseObj;
            NSMutableArray *utoxarray = [NSMutableArray new];
             for (int i = 0; i < array.count; i++) {
                 BTCUTXOModel *model = [BTCUTXOModel parse:array[i]];
                 if(model.satoshis > 1000){//太小的utxo只能扩大交易大小，让手续费暴增，不如直接弃用
                     [utoxarray addObject:model];//gai
                 }
             }
             utxos = utoxarray;
            [CreateAll DoTransBTCKey:wallet UTXO:utxos to:destinationAddress change:changeAddress amount:amount fee:fee api:btcApi  Password:(NSString *)password callback:^(BTCTransaction *result, NSError *error) {
                callback(result,error);
            }];
            
        }else{
                    callback(nil,error);
            }
            
        }];
            
    
}

+(void)DoTransBTCKey:(MissionWallet*)wallet  UTXO:(NSArray *)utxos   to:(BTCPublicKeyAddress*)destinationAddress change:(BTCPublicKeyAddress*)changeAddress
              amount:(BTCAmount)amount fee:(BTCAmount)fee api:(BTCAPI)btcApi  Password:(NSString *)password callback: (void (^)(BTCTransaction *result, NSError *error))callback{
    
    NSError* error = nil;
    
   // NSLog(@"UTXOs for %@: %@ ", wallet.address, utxos);
    
    //BTCPrivateKeyAddressTestnet* pkaddr = [BTCPrivateKeyAddressTestnet addressWithString:wallet.privateKey];
    //BTCKey* key = [[BTCKey alloc]initWithPrivateKeyAddress:pkaddr];
    
    
    if (!utxos) {
        NSError *err = [NSError ErrorWithTitle:@"UTXO为0" Code:102500];
        callback(nil,err);
        return;
    }
    // Find enough outputs to spend the total amount.
    //先取size = 300预估算 正常一笔交易的大小大约226 bytes
    //总金额=转账金额+预估fee
    BTCAmount totalAmount = amount + fee * 300;
    //灰尘交易，要求转账不小于这个值
    BTCAmount dustThreshold = 5000;
    
    // Sort utxo in order of
    //根据金额大小排序utxo
//    utxos = [utxos sortedArrayUsingComparator:^(BTCBlockChainUTXOModel* utxo1, BTCBlockChainUTXOModel* utxo2) {
//        if (utxo1.value < utxo2.value) return NSOrderedAscending;
//        else return NSOrderedDescending;
//    }];
    utxos = [utxos sortedArrayUsingComparator:^(BTCUTXOModel* utxo1, BTCUTXOModel* utxo2) {
        if (utxo1.satoshis < utxo2.satoshis)
            return NSOrderedAscending;
         else return NSOrderedDescending;
        }];
    //存储utxo
    NSMutableArray* txouts = [NSMutableArray new];
    //存储utxo累加金额
    NSInteger satishistotal = 0;
    //遍历utxo,使其满足转账总金额totalAmount
    for (BTCUTXOModel* txout in utxos) {
        if (satishistotal < (totalAmount + dustThreshold)) {
            [txouts addObject:txout];
            satishistotal += txout.satoshis;
        }else{
            break;
        }
    }
    //*******************da
    
    if (satishistotal < (totalAmount + dustThreshold)){
        NSError *err = [NSError ErrorWithTitle:@"余额不足" Code:102906];
        callback(nil,err);
        return;
    }
    
    // Create a new transaction
    BTCTransaction* tx = [[BTCTransaction alloc] init];
    //估算fees
    long size = txouts.count * 148 + 2 * 34 + 10 + 40;
    BTCAmount transfee = (size * fee);//换算为sat/Byte
    [tx setFee:transfee];
    //累加输入金额
    BTCAmount spentCoins = 0;
    
    // Add all outputs as inputs
    //上一笔交易转过来的（上一笔的输出）作为这一笔的输入
    for (BTCUTXOModel* txout in txouts) {
        BTCTransactionInput* txin = [[BTCTransactionInput alloc] init];
        //"script":"76a914939e9bf4929611da68d8c4886cb879e06997d26188ac",
        txin.signatureScript = [[BTCScript alloc]initWithString:txout.scriptPubKey];
        //"tx_hash_big_endian":"7a6643633261ae23f7dd7856f0525f4972b45a2f242a5849359baee964fbafb4",
        txin.previousTransactionID = txout.txid;
        //"tx_output_n":0,
        txin.previousIndex = (uint32_t)txout.vout;
        [tx addInput:txin];
        spentCoins += txout.satoshis;
    }
    if ((spentCoins - (amount + transfee)) < 0) {
        if ((spentCoins - (amount + transfee)) < 0) {
            NSError *err = [NSError ErrorWithTitle:@"余额不足" Code:102906];
            callback(nil,err);
            return;
        }
    }
    NSLog(@"Total satoshis to spend:       %lld", spentCoins);
    NSLog(@"Total satoshis to destination: %lld", amount);
    NSLog(@"Total satoshis to fee:         %lld", transfee);
    NSLog(@"Total satoshis to change:      %lld", (spentCoins - (amount + transfee)));
    
    // Add required outputs - payment and change
    //输出有两个，一个是要转给目标地址，一个是找零地址
    //转账金额
    BTCTransactionOutput* paymentOutput = [[BTCTransactionOutput alloc] initWithValue:amount address:destinationAddress];
    //找零
    BTCTransactionOutput* changeOutput = [[BTCTransactionOutput alloc] initWithValue:(spentCoins - (amount + transfee)) address:changeAddress];
    
    
    // Idea: deterministically-randomly choose which output goes first to improve privacy.
    [tx addOutput:paymentOutput];
    [tx addOutput:changeOutput];
    //给所有输入进行签名
    // Sign all inputs. We now have both inputs and outputs defined, so we can sign the transaction.
    for (int i = 0; i < txouts.count; i++) {
        // Normally, we have to find proper keys to sign this txin, but in this
        // example we already know that we use a single private key.
        BTCUTXOModel *model = txouts[i];
        
        /*
         utxo blockchain api
         model.script——》公钥——〉地址，目的是找出它对应的私钥，以签名
         */
        BTCScript *scriptPubKey = [[BTCScript alloc] initWithData:BTCDataFromHex(model.scriptPubKey)];
        NSString *addrx = scriptPubKey.standardAddress.string;
        /*
         utxo blockchain api
         根据上一步的地址找对应的私钥
         */
        NSString *changeprikey = nil;
        if ([wallet.address isEqualToString:addrx]) {
            changeprikey = wallet.privateKey;
        }else{
            for (BTCChangeAddressModel *chmodel in wallet.changeAddressArray) {
                if ([chmodel.changeaddress isEqualToString:addrx]) {
                    changeprikey = chmodel.privatekey;
                    //这里找零地址对应的私钥都是加密后存在数据库里，这里验证其是否是有效的比特币私钥，如果不是，则需要解密成私钥格式
                    if (![changeprikey isValidBitcoinPrivateKey]) {
                        NSString *depri = [AESCrypt decrypt:changeprikey password:password];
                        if (depri != nil && [depri isValidBitcoinPrivateKey]) {
                            changeprikey = depri;
                        }else{
                            NSError *err = [NSError ErrorWithTitle:@"Private Key Error" Code:102855];
                            callback(nil,err);
                            return;
                        }
                    }
                }
            }
        }
        if (changeprikey == nil) {
            NSError *err = [NSError ErrorWithTitle:@"没有匹配的私钥" Code:102502];
            callback(nil,err);
            return;
        }
        //下面为签名
        BTCTransactionInput* txin = tx.inputs[i];
        
        BTCScript* sigScript = [[BTCScript alloc] init];
        //要对tx进行签名
        NSData* d1 = tx.data;
        
        BTCSignatureHashType hashtype = BTCSignatureHashTypeAll;
        NSError* errorx = nil;
        NSData* hash = [tx signatureHashForScript:scriptPubKey inputIndex:i hashType:hashtype error:&errorx];
        
        NSData* d2 = tx.data;
        NSLog(@"Hash for input %d: %@", i, BTCHexFromData(hash));
        if (!hash) {
            NSError *err = [NSError ErrorWithTitle:@"hash生成错误" Code:102503];
            callback(nil,err);
            return;
        }
        BOOL datacheck = [d1 isEqual:d2];
        if (!datacheck) {
            NSError *err = [NSError ErrorWithTitle:@"交易不能在signatureHashForScript中更改!" Code:102504];
            callback(nil,err);
            return;
        }
        BTCPrivateKeyAddress *pkaddr;
        BTCKey* key;
        if (ChangeToTESTNET == 0) {
            pkaddr = [BTCPrivateKeyAddress addressWithString:changeprikey];
            key = [[BTCKey alloc]initWithPrivateKeyAddress:pkaddr];
        }else if (ChangeToTESTNET == 1){
            pkaddr = [BTCPrivateKeyAddressTestnet addressWithString:changeprikey];
            key = [[BTCKey alloc]initWithPrivateKeyAddress:pkaddr];
        }
        NSData* signatureForScript = [key signatureForHash:hash hashType:hashtype];
        [sigScript appendData:signatureForScript];
        [sigScript appendData:key.publicKey];
        
        NSData* sig = [signatureForScript subdataWithRange:NSMakeRange(0, signatureForScript.length - 1)]; // trim hashtype byte to check the signature.
        BOOL validsig = [key isValidSignature:sig hash:hash];
        if (!validsig) {
            NSError *err = [NSError ErrorWithTitle:@"签名无效!" Code:102505];
            callback(nil,err);
            return;
        }
        txin.signatureScript = sigScript;
    }
    
    // Validate the signatures before returning for extra measure.
    
    for (int i = 0; i < txouts.count; i++){
        BTCScriptMachine* sm = [[BTCScriptMachine alloc] initWithTransaction:tx inputIndex:i];
        BTCUTXOModel *model = txouts[i];
        BTCScript *scriptPubKey = [[BTCScript alloc]initWithString:model.scriptPubKey];
        BOOL r = [sm verifyWithOutputScript:scriptPubKey  error:&error];
        if (!r) {
            NSError *err = [NSError ErrorWithTitle:@"需要验证第一笔输出" Code:102506];
            callback(nil,err);
            return;
        }
        NSLog(@"Error: %@", error);
    }
    
    /*
     上面构造的交易为了计算实际大小，从而得到正确手续费
     实际交易大小
     */
    //实际交易大小
    NSString *broadcastTX = BTCHexFromData([tx data]);
    long length = broadcastTX.length;
    
    // Create a new transaction
    BTCTransaction* tx2 = [[BTCTransaction alloc] init];
    
    BTCAmount transfee2 = (fee * length/2);//换算为sat/Byte
    [tx2 setFee:transfee2];
    
    BTCAmount spentCoins2 = 0;
    
    // Add all outputs as inputs
    for (BTCUTXOModel* txout in txouts) {
        BTCTransactionInput* txin = [[BTCTransactionInput alloc] init];
        txin.signatureScript = [[BTCScript alloc]initWithString:txout.scriptPubKey];
        txin.previousTransactionID = txout.txid;
        txin.previousIndex = (uint32_t)txout.vout;
        [tx2 addInput:txin];
        spentCoins2 += txout.satoshis;
    }
    if ((spentCoins2 - (amount + transfee2)) < 0) {
        NSError *err = [NSError ErrorWithTitle:@"余额不足" Code:102906];
        callback(nil,err);
        return;
    }
    NSLog(@"Total satoshis to spend:       %lld", spentCoins2);
    NSLog(@"Total satoshis to destination: %lld", amount);
    NSLog(@"Total satoshis to fee:         %lld", transfee2);
    NSLog(@"Total satoshis to change:      %lld", (spentCoins2 - (amount + transfee2)));
    
    // Add required outputs - payment and change
    //转账金额
    BTCTransactionOutput* paymentOutput2 = [[BTCTransactionOutput alloc] initWithValue:amount address:destinationAddress];
    //找零
    BTCTransactionOutput* changeOutput2 = [[BTCTransactionOutput alloc] initWithValue:(spentCoins2 - (amount + transfee2)) address:changeAddress];
    
    
    // Idea: deterministically-randomly choose which output goes first to improve privacy.
    [tx2 addOutput:paymentOutput2];
    [tx2 addOutput:changeOutput2];
    
    // Sign all inputs. We now have both inputs and outputs defined, so we can sign the transaction.
    for (int i = 0; i < txouts.count; i++) {
        // Normally, we have to find proper keys to sign this txin, but in this
        // example we already know that we use a single private key.
        BTCUTXOModel *model = txouts[i];
        
        /*
         utxo blockchain api
         
         */
        BTCScript *scriptPubKey = [[BTCScript alloc] initWithData:BTCDataFromHex(model.scriptPubKey)];
        NSString *addrx = scriptPubKey.standardAddress.string;
        /*
         utxo blockchain api
         */
        NSString *changeprikey = nil;
        if ([wallet.address isEqualToString:addrx]) {
            changeprikey = wallet.privateKey;
        }else{
            for (BTCChangeAddressModel *chmodel in wallet.changeAddressArray) {
                if ([chmodel.changeaddress isEqualToString:addrx]) {
                    changeprikey = chmodel.privatekey;
                    if (![changeprikey isValidBitcoinPrivateKey]) {
                        NSString *depri = [AESCrypt decrypt:changeprikey password:password];
                        if (depri != nil && [depri isValidBitcoinPrivateKey]) {
                            changeprikey = depri;
                        }else{
                            NSError *err = [NSError ErrorWithTitle:@"Private Key Error" Code:102855];
                            callback(nil,err);
                            return;
                        }
                    }
                }
            }
        }
        if (changeprikey == nil) {
            NSError *err = [NSError ErrorWithTitle:@"没有匹配的私钥" Code:102502];
            callback(nil,err);
            return;
        }
        BTCTransactionInput* txin = tx2.inputs[i];
        
        BTCScript* sigScript = [[BTCScript alloc] init];
        
        NSData* d1 = tx2.data;
        
        BTCSignatureHashType hashtype = BTCSignatureHashTypeAll;
        NSError* errorx = nil;
        NSData* hash = [tx2 signatureHashForScript:scriptPubKey inputIndex:i hashType:hashtype error:&errorx];
        
        NSData* d2 = tx2.data;
        NSLog(@"Hash for input %d: %@", i, BTCHexFromData(hash));
        if (!hash) {
            NSError *err = [NSError ErrorWithTitle:@"hash生成错误" Code:102503];
            callback(nil,err);
            return;
        }
        BOOL datacheck = [d1 isEqual:d2];
        if (!datacheck) {
            NSError *err = [NSError ErrorWithTitle:@"交易不能在signatureHashForScript中更改!" Code:102504];
            callback(nil,err);
            return;
        }
        BTCPrivateKeyAddress *pkaddr;
        BTCKey* key;
        if (ChangeToTESTNET == 0) {
            pkaddr = [BTCPrivateKeyAddress addressWithString:changeprikey];
            key = [[BTCKey alloc]initWithPrivateKeyAddress:pkaddr];
        }else if (ChangeToTESTNET == 1){
            pkaddr = [BTCPrivateKeyAddressTestnet addressWithString:changeprikey];
            key = [[BTCKey alloc]initWithPrivateKeyAddress:pkaddr];
        }
        NSData* signatureForScript = [key signatureForHash:hash hashType:hashtype];
        [sigScript appendData:signatureForScript];
        [sigScript appendData:key.publicKey];
        
        NSData* sig = [signatureForScript subdataWithRange:NSMakeRange(0, signatureForScript.length - 1)]; // trim hashtype byte to check the signature.
        BOOL validsig = [key isValidSignature:sig hash:hash];
        if (!validsig) {
            NSError *err = [NSError ErrorWithTitle:@"签名无效!" Code:102505];
            callback(nil,err);
            return;
        }
        txin.signatureScript = sigScript;
    }
    // Validate the signatures before returning for extra measure.
    
    for (int i = 0; i < txouts.count; i++){
        BTCScriptMachine* sm = [[BTCScriptMachine alloc] initWithTransaction:tx2 inputIndex:i];
        BTCUTXOModel *model = txouts[i];
        BTCScript *scriptPubKey = [[BTCScript alloc]initWithString:model.scriptPubKey];
        BOOL r = [sm verifyWithOutputScript:scriptPubKey  error:&error];
        if (!r) {
            NSError *err = [NSError ErrorWithTitle:@"需要验证第一笔输出" Code:102506];
            callback(nil,err);
            return;
        }
        NSLog(@"Error: %@", error);
    }
    //构建tx完成，返回进行广播
    callback(tx2,error);
}

/*
 ********************************************** ETH转账 *******************************************************************
 */
//切换ETH测试网络 小金额转账可能会报错 ChainIdHomestead正式 ChainIdKovan测试 @"I9A7VY96R41H5HQYETGCBJXZDPQ6QUVDA9"

//获取ETH价格
+(void)GetETHCurrencyCallback: (void (^)(FloatPromise *etherprice))callback{
//    EtherscanProvider *provider = [[EtherscanProvider alloc] initWithChainId:MODENET apiKey:EtherscanApiKey];
    NSURL *url = [[NSURL alloc]initWithString:[CreateAll GetCurrentNodes].nodeEth];
    InfuraProvider *provider = [[InfuraProvider alloc]initWithChainId:MODENET url:url];
    
    [[provider getEtherPrice] onCompletion:^(FloatPromise *etherprice) {
        callback(etherprice);
    }];
    
    
}
//获取GAS价格
+(void)GetGasPriceCallback: (void (^)(BigNumberPromise *gasPrice))callback{
//    EtherscanProvider *provider = [[EtherscanProvider alloc] initWithChainId:MODENET apiKey:EtherscanApiKey];
    NSURL *url = [[NSURL alloc]initWithString:[CreateAll GetCurrentNodes].nodeEth];
    InfuraProvider *provider = [[InfuraProvider alloc]initWithChainId:MODENET url:url];
    
    [[provider getGasPrice] onCompletion:^(BigNumberPromise *gasPrice) {
        callback(gasPrice);
    }];
}
//获取交易记录
+(void)GetTransactionsForAddress:(NSString *)address  startBlockTag: (BlockTag)blockTag Callback: (void (^)(ArrayPromise *promiseArray))callback{
//    EtherscanProvider *provider = [[EtherscanProvider alloc] initWithChainId:MODENET apiKey:EtherscanApiKey];
    NSURL *url = [[NSURL alloc]initWithString:[CreateAll GetCurrentNodes].nodeEth];
    InfuraProvider *provider = [[InfuraProvider alloc]initWithChainId:ChainIdHomestead url:url];
    
    [[provider getTransactions:[Address addressWithString:address] startBlockTag:blockTag] onCompletion:^(ArrayPromise *promiseArray) {
        if (promiseArray.error) {
            callback(nil);
        }else{
            callback(promiseArray);
        }
    }];

    
    
}
//获取交易详情
+(void)GetTransactionDetaslByHash:(NSString *)hash Callback: (void (^)(TransactionInfoPromise *promise))callback{
//    EtherscanProvider *provider = [[EtherscanProvider alloc] initWithChainId:MODENET apiKey:EtherscanApiKey];
    NSURL *url = [[NSURL alloc]initWithString:[CreateAll GetCurrentNodes].nodeEth];
    InfuraProvider *provider = [[InfuraProvider alloc]initWithChainId:MODENET url:url];
    
    [[provider getTransaction:[Hash hashWithHexString:hash]] onCompletion:^(TransactionInfoPromise *promise) {
        callback(promise);
    }];
}
//创建交易
+(void)CreateETHTransactionFromWallet:(MissionWallet *)wallet ToAddress:(NSString *)address Value:(BigNumber *)value callback: (void (^)(Transaction *transaction))callback{
    Transaction *transaction = [[Transaction alloc] init];
//    EtherscanProvider *provider = [[EtherscanProvider alloc] initWithChainId:MODENET apiKey:EtherscanApiKey];
    NSURL *url = [[NSURL alloc]initWithString:[CreateAll GetCurrentNodes].nodeEth];
    InfuraProvider *provider = [[InfuraProvider alloc]initWithChainId:MODENET url:url];
    
    transaction.toAddress = [Address addressWithString:address];
    transaction.value = value;
    transaction.data = [SecureData hexStringToData:@""];
    transaction.gasLimit = [BigNumber constantZero];
    transaction.gasPrice = [BigNumber constantZero];
//    transaction.chainId = MODENET;
    [[provider getTransactionCount:[Address addressWithString:wallet.address]] onCompletion:^(IntegerPromise *lastnounce) {
    transaction.nonce = (NSUInteger)(lastnounce.value);
//        transaction.nonce = 1;
        NSLog(@"nounce = %ld last%ld",transaction.nonce,lastnounce.value);
        [NetManager getChainIdHandler:^(id responseObj, NSError *error) {
            if (error) {
                callback(nil);
            }else{
                transaction.chainId = [responseObj intValue];
                callback(transaction);
            }
        }];
    }];
}

//获取交易预估gas
+(void)GetGasLimitPriceForTransaction:(Transaction *)transaction callback: (void (^)(BigNumber *gasLimitPrice))callback{
//    EtherscanProvider *provider = [[EtherscanProvider alloc] initWithChainId:MODENET apiKey:EtherscanApiKey];
    NSURL *url = [[NSURL alloc]initWithString:[CreateAll GetCurrentNodes].nodeEth];
    InfuraProvider *provider = [[InfuraProvider alloc]initWithChainId:MODENET url:url];
    
    
    [[provider estimateGas:transaction] onCompletion:^(BigNumberPromise *promise) {
        NSLog(@"estimateGas = %@",promise.result);
        BigNumber *gaslimit = (BigNumber *)promise.result;
        callback(gaslimit);
    }];

}
//获取余额
+(void)GetBalanceETHForWallet:(MissionWallet *)wallet callback: (void (^)(BigNumber *balance))callback{
    @autoreleasepool {
        Address *addr = [Address addressWithString:wallet.address];
//        EtherscanProvider *provider = [[EtherscanProvider alloc] initWithChainId:MODENET apiKey:EtherscanApiKey];
        NSURL *url = [[NSURL alloc]initWithString:[CreateAll GetCurrentNodes].nodeEth];
        InfuraProvider *provider = [[InfuraProvider alloc]initWithChainId:ChainIdHomestead url:url];
        [[provider getBalance:addr] onCompletion:^(BigNumberPromise *promise) {
            BigNumber *balance = (BigNumber *)promise.result;
            callback(balance);
        }];
            

        
        
    }
    
    
    
    
}
/*
 转账 广播交易
 gasPrice gasLimit value为10进制
 */
+(void)ETHTransaction:(Transaction *)transaction Wallet:(MissionWallet *)wallet GasPrice:(BigNumber *)gasPrice GasLimit:(BigNumber *)gasLimit tokenETH:(NSString *)tokenETH callback: (void (^)(HashPromise *promise))callback{
    
    Account *account =  [Account accountWithPrivateKey:[NSData dataWithHexString:wallet.privateKey]];
    if (transaction) {
//        EtherscanProvider *provider = [[EtherscanProvider alloc] initWithChainId:MODENET apiKey:EtherscanApiKey];
        NSURL *url = [[NSURL alloc]initWithString:[CreateAll GetCurrentNodes].nodeEth];
        InfuraProvider *provider = [[InfuraProvider alloc]initWithChainId:MODENET url:url];
        
        transaction.gasPrice = gasPrice;
        transaction.gasLimit = gasLimit;
        
        if (tokenETH != nil) {
            SecureData *data = [SecureData secureDataWithCapacity:68];
            [data appendData:[SecureData hexStringToData:@"0xa9059cbb"]];
            transaction.gasLimit = [BigNumber bigNumberWithDecimalString:@"60000"];

            NSData *dataAddress = transaction.toAddress.data;//转入地址（真实代币转入地址添加到data里面）
            for (int i=0; i < 32 - dataAddress.length; i++)
            {
                [data appendByte:'\0'];
            }

            [data appendData:dataAddress];

            NSData *valueData = transaction.value.data;//真实代币交易数量添加到data里面
            for (int i=0; i < 32 - valueData.length; i++)
            {
                [data appendByte:'\0'];
            }
            [data appendData:valueData];

            transaction.value = [BigNumber constantZero];
            transaction.data = data.data;
            transaction.toAddress = [Address addressWithString:tokenETH];//合约地址（代币交易 转入地址为合约地址）
        }
        
        
        [account sign:transaction];
        //        NSData *data = [transaction serialize];
        [[provider getBalance:account.address] onCompletion:^(BigNumberPromise *promise) {
            NSLog(@"balance = %@ \n",promise.result);
            BigNumber *balance = (BigNumber *)promise.result;
            if (![balance lessThan:[transaction.value add:gasPrice]]) {
                [[provider sendTransaction:[transaction serialize]] onCompletion:^(HashPromise *promise) {
                    NSLog(@"tran = %@\n",transaction);
                    callback(promise);
                }];
            }else{
                callback(nil);
            }
        }];
    }
}
/*
 存储刚刚广播未打包的ETH交易
 */
+(void)SaveETHTxHash:(NSString *)hash ForAddr:(NSString *)addr{
    if (!hash) {
        return;
    }
    NSMutableArray *array = [[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"ETHBrodestTxHashs%@",addr]] mutableCopy];
    if (array == nil || array.count == 0) {
        array = [NSMutableArray new];
    }
    if (![array containsObject:hash]) {
        [array addObject:hash];
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:[NSString stringWithFormat:@"ETHBrodestTxHashs%@",addr]];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
/*
 删除已经打包的ETH交易
 */
+(void)DeleteETHTxHash:(NSString *)hash ForAddr:(NSString *)addr{
    NSMutableArray *array = [[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"ETHBrodestTxHashs%@",addr]] mutableCopy];
    if (array == nil || array.count == 0) {
        array = [NSMutableArray new];
    }
    if([array containsObject:hash]){
        [array removeObject:hash];
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:[NSString stringWithFormat:@"ETHBrodestTxHashs%@",addr]];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
/*
 取未打包的ETH交易
 */
+(NSArray *)GetETHTxhashForAddr:(NSString *)addr{
    NSArray *array = [[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"ETHBrodestTxHashs%@",addr]] mutableCopy];
    return VALIDATE_ARRAY(array);
}

/*
 ********************************************** EOS *******************************************************************
 */


////*************************  BIP44 EOSKey  *************************

//BIP44 EOSKey
+(NSString *)CreateEOSPrivateKeyBySeed:(NSString *)seed Index:(uint32_t)index{
    NSString *xprv = [CreateAll CreateExtendPrivateKeyWithSeed:seed];
    //@"m/44'/194'/0'/0"   @"m/48'/4'/0'/0'"
    BTCKeychain *btckeychainxprv = [[BTCKeychain alloc]initWithExtendedKey:xprv];
    NSString *OWNERPath = [NSString stringWithFormat:@"m/44'/194'/0'/0"];
    
    BTCKey* ownerkey = [[btckeychainxprv derivedKeychainWithPath:OWNERPath] keyAtIndex:index hardened:NO];
    //    NSString *privateKey = ownerkey.privateKeyAddress.string;
    /*
     私钥不同格式的转换 （56位二进制格式，WIF未压缩格式和WIF压缩格式）
     相互转换：
     假设随机生成的私钥如下：
     P = 0x9B257AD1E78C14794FBE9DC60B724B375FDE5D0FB2415538820D0D929C4AD436
     添加前缀0x80
     
     WIF = Base58(0x80 + P + CHECK(0x80 + P) + 0x01)
     = Base58(0x80 +
     0x9B257AD1E78C14794FBE9DC60B724B375FDE5D0FB2415538820D0D929C4AD436 +
     0x36dfd253 +
     0x01)
     其中CHECK表示两次sha256哈希后取前四个比特。前缀0x80表示私钥类型，后缀0x01表示公钥采用压缩格式，如果用 *非压缩公钥则不加这个后缀*
     WIF格式的私钥的首字符是以“5”，“K”或“L”开头的，其中以“5” 开头的是WIF未压缩格式，其他两个是WIF压缩格式。
     */
    BTCPrivateKeyAddress *umcomaddr = [BTCPrivateKeyAddress addressWithData:ownerkey.privateKeyAddress.data];
    umcomaddr.publicKeyCompressed = NO;
    NSString *umcompresspri = umcomaddr.string;
    // NSLog(@"pri =%@ \n %@", privateKey,umcompresspri);
    //length 52 / 51
    // NSLog(@"length =%ld \n %ld", privateKey.length,umcompresspri.length);
    
    return umcompresspri;
    
}


/*
 omnicore-cli "omni_createpayload_simplesend" 31 "10.0"
 返回
 0000 0000 0000001f 000000003b9aca00
 
 std::vector<unsigned char> payload;
 uint16_t messageType = 0;
 uint16_t messageVer = 0;
 mastercore::swapByteOrder16(messageType);
 mastercore::swapByteOrder16(messageVer);
 mastercore::swapByteOrder32(propertyId);
 mastercore::swapByteOrder64(amount);
 
 PUSH_BACK_BYTES(payload, messageVer);
 PUSH_BACK_BYTES(payload, messageType);
 PUSH_BACK_BYTES(payload, propertyId);
 PUSH_BACK_BYTES(payload, amount);
 
 return payload;
 ************************************************************************
 { // https://juejin.im/post/5c5008c26fb9a049bc4d0e20

 {
 16    // len
 6a    // op_return
 14    // len
 6f6d6e69    // "omni"的ASCII编码,以为这个备注信息是与 Omni 协议有关系的
 0000    // Transaction version
 0000    // Transaction type, 2 Bytes,代表着Simple Send
 0000001f    // Currency identifier, 4 bytes. 1f== 31 == TetherUS
 //以上是固定的，以下是usdt转账金额
 0000 000b 0f38 7b00    // Amount to transfer. 8Bytes. 数量的十六进制0000000b0f387b00 = 47500000000聪 = 475 USDT
 }
 2202000000000000
 1976a914ef32ddf172029d683acb18d696da7f4c2c0b04ff88ac
 00000000
 OP_RETURN 6f6d6e69000000000000001f0000000b0f387b00
 由于 Omni协议中,vout 找零必须找给发送地址,否则,这笔交易将不会被判断为是Omni交易,
 只会认为是发送 0.00000546的普通BTC交易,所以这里增加一个 vout,
 将剩下的钱全部转给原 SendFrom 地址mujE43EZckhHf6i1P2ru9UUg78VTjLwwL3

 }
 */
//@"6f6d6e69 00000000 0000001f 00000000 3b9aca00"
+(NSString *)Omni_createpayload_simplesend_USDT:(BTCAmount)amount{
    NSString *vv = @"6f6d6e69";
    NSString* messageType = @"0000";
    NSString* messageVer = @"0000";
    NSString* propertyId = @"0000001f";
    NSString *hexstr = [NSString getHexByDecimal:amount*pow(10, 8)];
    NSInteger zeronum = 16 - hexstr.length;
    NSString *result = [NSString stringWithFormat:@"%@%@%@%@",vv,messageType,messageVer,propertyId];
    for (int index = 0; index < zeronum; index++) {
        result = [result stringByAppendingString:@"0"];
    }
    result = [result stringByAppendingString:hexstr];
    NSLog(@"%@",result);
    return result;
}


/*
 用于生成omni部分data<00000000 0000001f 00000000 3b9aca00>
 */
+(NSData *)Omni_createpayload_simplesend_USDTData:(BTCAmount)amount{
    NSString *result = [CreateAll Omni_createpayload_simplesend_USDT:amount];
    return [NSData dataWithHexString:result];
}


//转账
+(void)USDTTransactionFromWallet:(MissionWallet *)wallet ToAddress:(NSString *)address Amount:(BTCAmount)usdtamount
                            Fee:(BTCAmount)fee
                            Api:(BTCAPI)btcApi
                       Password:(NSString *)password
                       callback: (void (^)(NSString *result, NSError *error))callback{
    
    BTCPublicKeyAddress *changeAddress;
    BTCPublicKeyAddress *toAddress;
    NSString *changeaddr = wallet.address;
    if (ChangeToTESTNET == 0) {
        changeAddress = [BTCPublicKeyAddress addressWithString:changeaddr];
        toAddress = [BTCPublicKeyAddress addressWithString:address];
    }else if (ChangeToTESTNET == 1){
        changeAddress = [BTCPublicKeyAddressTestnet addressWithString:changeaddr];
        toAddress = [BTCPublicKeyAddressTestnet addressWithString:address];
    }
    
    [CreateAll USDTtransactionSpendingFromPrivateKey:wallet
                                              to:toAddress
                                          change:changeAddress
                                          amount:usdtamount
                                             fee:fee
                                             api:btcApi
                                        Password:(NSString *)password
                                        callback:^(BTCTransaction *transaction, NSError *error) {
                                            
                                            if (!transaction) {
                                                NSLog(@"Can't make a transaction");
                                                callback(nil, error);
                                                return;
                                            }
                                            
                                            NSLog(@"transaction = %@", transaction.dictionary);
                                            NSLog(@"transaction in hex:\n------------------\n%@\n------------------\n", BTCHexFromData([transaction data]));
                                            NSString *broadcastTX = BTCHexFromData([transaction data]);
                                            NSLog(@"Sending ...");
                                            
                                            //广播交易
                                            [self extracted:broadcastTX callback:^(NSString *string, NSError *error) {
                                                callback(string,error);
                                            }];
                                            
                                        }];
    
    
}

// Simple method for now, fetching unspent coins on the fly
+ (void) USDTtransactionSpendingFromPrivateKey:(MissionWallet*)wallet
                                        to:(BTCPublicKeyAddress*)destinationAddress
                                    change:(BTCPublicKeyAddress*)changeAddress
                                    amount:(BTCAmount)usdtamount
                                       fee:(BTCAmount)fee

                                       api:(BTCAPI)btcApi
                                  Password:(NSString *)password
                                  callback: (void (^)(BTCTransaction *result, NSError *error))callback
{
    // 1. Get a private key, destination address, change address and amount
    // 2. Get unspent outputs for that key (using both compressed and non-compressed pubkey)
    // 3. Take the smallest available outputs to combine into the inputs of new transaction
    // 4. Prepare the scripts with proper signatures for the inputs
    // 5. Broadcast the transaction
    
    __block NSArray* utxos = nil;
    
    NSString *addr;
    if (wallet.changeAddressArray != nil && wallet.changeAddressArray.count > 0) {
        addr = [wallet.changeAddressStr stringByReplacingOccurrencesOfString:@"," withString:@"|"];
    }else{
        addr = wallet.address;
    }
    
    [NetManager GetBTCUTXOFromBlockChainAddress:addr MinumConfirmations:0 completionHandler:^(id responseObj, NSError *error) {
        if (!error) {
            if (!responseObj) {
                return ;
            }
            
            NSArray *utxoarr = [BTCBlockChainUTXOModel parse:responseObj[@"unspent_outputs"]];
            NSMutableArray *utoxarray = [NSMutableArray new];
            for (BTCBlockChainUTXOModel *model in utxoarr) {
                if(model.tx_output_n == 0 && model.confirmations <1){//转入未确认
                    [utoxarray addObject:model];//gai
                }else if(model.tx_output_n == 0 && model.confirmations >=1){//转入 确认>1
                    [utoxarray addObject:model];
                }else if(model.tx_output_n > 0 && model.confirmations <1){//转出未确认
                    [utoxarray addObject:model];
                }else if(model.tx_output_n > 0 && model.confirmations >=1){//转出 确认>=1
                    [utoxarray addObject:model];
                }
            }
            utxos = utoxarray;
            //0.00000546 指定的usdt转账的btc金额
            BTCAmount btcamount = BTCAmountFromDecimalNumber(@546);
            [CreateAll DoUSDTTransBTCKey:wallet UTXO:utxos OmniAmount:usdtamount to:destinationAddress change:changeAddress amount:btcamount fee:fee api:btcApi  Password:(NSString *)password callback:^(BTCTransaction *result, NSError *error) {
                 callback(result,error);
            }];
        }else{
            callback(nil,error);
        }
    }];
    
    
}


+(void)DoUSDTTransBTCKey:(MissionWallet*)wallet  UTXO:(NSArray *)utxos OmniAmount:(BTCAmount)usdtamount to:(BTCPublicKeyAddress*)destinationAddress change:(BTCPublicKeyAddress*)changeAddress
              amount:(BTCAmount)amount fee:(BTCAmount)fee api:(BTCAPI)btcApi  Password:(NSString *)password callback: (void (^)(BTCTransaction *result, NSError *error))callback{
    
    NSError* error = nil;
    
    NSLog(@"UTXOs for %@: %@ ", wallet.address, utxos);

    if (!utxos) {
        NSError *err = [NSError ErrorWithTitle:@"UTXO为0" Code:102500];
        callback(nil,err);
        return;
    }
    // Find enough outputs to spend the total amount.
    //先取size = 300预估算 正常一笔交易的大小大约226 bytes
    BTCAmount totalAmount = amount + fee * 300;
    BTCAmount dustThreshold = 5000;
    
    // Sort utxo in order of
    utxos = [utxos sortedArrayUsingComparator:^(BTCBlockChainUTXOModel* utxo1, BTCBlockChainUTXOModel* utxo2) {
        if (utxo1.value < utxo2.value) return NSOrderedAscending;
        else return NSOrderedDescending;
    }];
    
    NSMutableArray* txouts = [NSMutableArray new];
    NSInteger satishistotal = 0;
    for (BTCBlockChainUTXOModel* txout in utxos) {
        [txouts addObject:txout];
        satishistotal += txout.value;
    }
    //*******************da
    
    if (satishistotal < (totalAmount + dustThreshold)){
        NSError *err = [NSError ErrorWithTitle:@"余额不足" Code:102906];
        callback(nil,err);
        return;
    }
    
    // Create a new transaction
    BTCTransaction* tx = [[BTCTransaction alloc] init];
    //估算fees
    long size = txouts.count * 148 + 2 * 34 + 10 + 40;
    BTCAmount transfee = (size * fee);//换算为sat/Byte
    [tx setFee:transfee];
    
    BTCAmount spentCoins = 0;
    
    // Add all outputs as inputs
    for (BTCBlockChainUTXOModel* txout in txouts) {
        BTCTransactionInput* txin = [[BTCTransactionInput alloc] init];
        txin.signatureScript = [[BTCScript alloc]initWithString:txout.script];
        txin.previousTransactionID = txout.tx_hash_big_endian;
        txin.previousIndex = (uint32_t)txout.tx_output_n;
        [tx addInput:txin];
        spentCoins += txout.value;
    }
    if ((spentCoins - (amount + transfee)) < 0) {
        if ((spentCoins - (amount + transfee)) < 0) {
            NSError *err = [NSError ErrorWithTitle:@"余额不足" Code:102906];
            callback(nil,err);
            return;
        }
    }
    NSLog(@"Total satoshis to spend:       %lld", spentCoins);
    NSLog(@"Total satoshis to destination: %lld", amount);
    NSLog(@"Total satoshis to fee:         %lld", transfee);
    NSLog(@"Total satoshis to change:      %lld", (spentCoins - (amount + transfee)));
    
    // Add required outputs - payment and change
    //转账金额
    BTCTransactionOutput* paymentOutput = [[BTCTransactionOutput alloc] initWithValue:amount address:destinationAddress];
    //找零
    BTCTransactionOutput* changeOutput = [[BTCTransactionOutput alloc] initWithValue:(spentCoins - (amount + transfee)) address:changeAddress];
    
    /*
    ****************usdt
     */
    //6f6d6e69000000000000001f0000000b0f387b00
    
    NSString *omnistr = [CreateAll Omni_createpayload_simplesend_USDT:usdtamount];
    BTCScript *opreturnscript = [[BTCScript alloc] initWithString:[NSString stringWithFormat:@"OP_RETURN %@",omnistr]];
    BTCTransactionOutput* opreturnOutput = [[BTCTransactionOutput alloc] initWithValue:0 script:opreturnscript];
    [tx addOutput:opreturnOutput];
    /*
     ****************usdt
     */
    // Idea: deterministically-randomly choose which output goes first to improve privacy.
    [tx addOutput:paymentOutput];
    [tx addOutput:changeOutput];
    
    // Sign all inputs. We now have both inputs and outputs defined, so we can sign the transaction.
    for (int i = 0; i < txouts.count; i++) {
        // Normally, we have to find proper keys to sign this txin, but in this
        // example we already know that we use a single private key.
        BTCBlockChainUTXOModel *model = txouts[i];
        
        /*
         utxo blockchain api
         
         */
        BTCScript *scriptPubKey = [[BTCScript alloc] initWithData:BTCDataFromHex(model.script)];
        NSString *addrx = scriptPubKey.standardAddress.string;
        /*
         utxo blockchain api
         */
        NSString *changeprikey = nil;
        if ([wallet.address isEqualToString:addrx]) {
            changeprikey = wallet.privateKey;
        }else{
            for (BTCChangeAddressModel *chmodel in wallet.changeAddressArray) {
                if ([chmodel.changeaddress isEqualToString:addrx]) {
                    changeprikey = chmodel.privatekey;
                    if (![changeprikey isValidBitcoinPrivateKey]) {
                        NSString *depri = [AESCrypt decrypt:changeprikey password:password];
                        if (depri != nil && [depri isValidBitcoinPrivateKey]) {
                            changeprikey = depri;
                        }else{
                            NSError *err = [NSError ErrorWithTitle:@"Private Key Error" Code:102855];
                            callback(nil,err);
                            return;
                        }
                    }
                }
            }
        }
        if (changeprikey == nil) {
            NSError *err = [NSError ErrorWithTitle:@"没有匹配的私钥" Code:102502];
            callback(nil,err);
            return;
        }
        BTCTransactionInput* txin = tx.inputs[i];
        
        BTCScript* sigScript = [[BTCScript alloc] init];
        
        NSData* d1 = tx.data;
        
        BTCSignatureHashType hashtype = BTCSignatureHashTypeAll;
        NSError* errorx = nil;
        NSData* hash = [tx signatureHashForScript:scriptPubKey inputIndex:i hashType:hashtype error:&errorx];
        
        NSData* d2 = tx.data;
        NSLog(@"Hash for input %d: %@", i, BTCHexFromData(hash));
        if (!hash) {
            NSError *err = [NSError ErrorWithTitle:@"hash生成错误" Code:102503];
            callback(nil,err);
            return;
        }
        BOOL datacheck = [d1 isEqual:d2];
        if (!datacheck) {
            NSError *err = [NSError ErrorWithTitle:@"交易不能在signatureHashForScript中更改!" Code:102504];
            callback(nil,err);
            return;
        }
        BTCPrivateKeyAddress *pkaddr;
        BTCKey* key;
        if (ChangeToTESTNET == 0) {
            pkaddr = [BTCPrivateKeyAddress addressWithString:changeprikey];
            key = [[BTCKey alloc]initWithPrivateKeyAddress:pkaddr];
        }else if (ChangeToTESTNET == 1){
            pkaddr = [BTCPrivateKeyAddressTestnet addressWithString:changeprikey];
            key = [[BTCKey alloc]initWithPrivateKeyAddress:pkaddr];
        }
        NSData* signatureForScript = [key signatureForHash:hash hashType:hashtype];
        [sigScript appendData:signatureForScript];
        [sigScript appendData:key.publicKey];
        
        NSData* sig = [signatureForScript subdataWithRange:NSMakeRange(0, signatureForScript.length - 1)]; // trim hashtype byte to check the signature.
        BOOL validsig = [key isValidSignature:sig hash:hash];
        if (!validsig) {
            NSError *err = [NSError ErrorWithTitle:@"签名无效!" Code:102505];
            callback(nil,err);
            return;
        }
        txin.signatureScript = sigScript;
    }
    
    
    /*
     上面构造的交易为了计算实际大小，从而得到正确手续费
     实际交易大小
     */
    //实际交易大小
    NSString *broadcastTX = BTCHexFromData([tx data]);
    long length = broadcastTX.length;
    
    // Create a new transaction
    BTCTransaction* tx2 = [[BTCTransaction alloc] init];
    
    BTCAmount transfee2 = (fee * length/2);//换算为sat/Byte
    [tx2 setFee:transfee2];
    
    BTCAmount spentCoins2 = 0;
    
    // Add all outputs as inputs
    for (BTCBlockChainUTXOModel* txout in txouts) {
        BTCTransactionInput* txin = [[BTCTransactionInput alloc] init];
        txin.signatureScript = [[BTCScript alloc]initWithString:txout.script];
        txin.previousTransactionID = txout.tx_hash_big_endian;
        txin.previousIndex = (uint32_t)txout.tx_output_n;
        [tx2 addInput:txin];
        spentCoins2 += txout.value;
    }
    if ((spentCoins2 - (amount + transfee2)) < 0) {
        NSError *err = [NSError ErrorWithTitle:@"余额不足" Code:102906];
        callback(nil,err);
        return;
    }
    NSLog(@"Total satoshis to spend:       %lld", spentCoins2);
    NSLog(@"Total satoshis to destination: %lld", amount);
    NSLog(@"Total satoshis to fee:         %lld", transfee2);
    NSLog(@"Total satoshis to change:      %lld", (spentCoins2 - (amount + transfee2)));
    
    // Add required outputs - payment and change
    //转账金额
    BTCTransactionOutput* paymentOutput2 = [[BTCTransactionOutput alloc] initWithValue:amount address:destinationAddress];
    //找零
    BTCTransactionOutput* changeOutput2 = [[BTCTransactionOutput alloc] initWithValue:(spentCoins2 - (amount + transfee2)) address:changeAddress];
    /*
     ****************usdt
     */
    
    NSString *omnistr2 = [CreateAll Omni_createpayload_simplesend_USDT:usdtamount];
    BTCScript *opreturnscript2 = [[BTCScript alloc] initWithString:[NSString stringWithFormat:@"OP_RETURN %@",omnistr2]];
    BTCTransactionOutput* opreturnOutput2 = [[BTCTransactionOutput alloc] initWithValue:0 script:opreturnscript2];
    [tx2 addOutput:opreturnOutput2];
    /*
     ****************usdt
     */
    
    // Idea: deterministically-randomly choose which output goes first to improve privacy.
    [tx2 addOutput:paymentOutput2];
    [tx2 addOutput:changeOutput2];
    
    // Sign all inputs. We now have both inputs and outputs defined, so we can sign the transaction.
    for (int i = 0; i < txouts.count; i++) {
        // Normally, we have to find proper keys to sign this txin, but in this
        // example we already know that we use a single private key.
        BTCBlockChainUTXOModel *model = txouts[i];
        
        /*
         utxo blockchain api
         
         */
        BTCScript *scriptPubKey = [[BTCScript alloc] initWithData:BTCDataFromHex(model.script)];
        NSString *addrx = scriptPubKey.standardAddress.string;
        /*
         utxo blockchain api
         */
        NSString *changeprikey = nil;
        if ([wallet.address isEqualToString:addrx]) {
            changeprikey = wallet.privateKey;
        }else{
            for (BTCChangeAddressModel *chmodel in wallet.changeAddressArray) {
                if ([chmodel.changeaddress isEqualToString:addrx]) {
                    changeprikey = chmodel.privatekey;
                    if (![changeprikey isValidBitcoinPrivateKey]) {
                        NSString *depri = [AESCrypt decrypt:changeprikey password:password];
                        if (depri != nil && [depri isValidBitcoinPrivateKey]) {
                            changeprikey = depri;
                        }else{
                            NSError *err = [NSError ErrorWithTitle:@"Private Key Error" Code:102855];
                            callback(nil,err);
                            return;
                        }
                    }
                }
            }
        }
        if (changeprikey == nil) {
            NSError *err = [NSError ErrorWithTitle:@"没有匹配的私钥" Code:102502];
            callback(nil,err);
            return;
        }
        BTCTransactionInput* txin = tx2.inputs[i];
        
        BTCScript* sigScript = [[BTCScript alloc] init];
        
        NSData* d1 = tx2.data;
        
        BTCSignatureHashType hashtype = BTCSignatureHashTypeAll;
        NSError* errorx = nil;
        NSData* hash = [tx2 signatureHashForScript:scriptPubKey inputIndex:i hashType:hashtype error:&errorx];
        
        NSData* d2 = tx2.data;
        NSLog(@"Hash for input %d: %@", i, BTCHexFromData(hash));
        if (!hash) {
            NSError *err = [NSError ErrorWithTitle:@"hash生成错误" Code:102503];
            callback(nil,err);
            return;
        }
        BOOL datacheck = [d1 isEqual:d2];
        if (!datacheck) {
            NSError *err = [NSError ErrorWithTitle:@"交易不能在signatureHashForScript中更改!" Code:102504];
            callback(nil,err);
            return;
        }
        BTCPrivateKeyAddress *pkaddr;
        BTCKey* key;
        if (ChangeToTESTNET == 0) {
            pkaddr = [BTCPrivateKeyAddress addressWithString:changeprikey];
            key = [[BTCKey alloc]initWithPrivateKeyAddress:pkaddr];
        }else if (ChangeToTESTNET == 1){
            pkaddr = [BTCPrivateKeyAddressTestnet addressWithString:changeprikey];
            key = [[BTCKey alloc]initWithPrivateKeyAddress:pkaddr];
        }
        NSData* signatureForScript = [key signatureForHash:hash hashType:hashtype];
        [sigScript appendData:signatureForScript];
        [sigScript appendData:key.publicKey];
        
        NSData* sig = [signatureForScript subdataWithRange:NSMakeRange(0, signatureForScript.length - 1)]; // trim hashtype byte to check the signature.
        BOOL validsig = [key isValidSignature:sig hash:hash];
        if (!validsig) {
            NSError *err = [NSError ErrorWithTitle:@"签名无效!" Code:102505];
            callback(nil,err);
            return;
        }
        txin.signatureScript = sigScript;
    }
    // Validate the signatures before returning for extra measure.
    
    for (int i = 0; i < txouts.count; i++){
        BTCScriptMachine* sm = [[BTCScriptMachine alloc] initWithTransaction:tx2 inputIndex:i];
        BTCBlockChainUTXOModel *model = txouts[i];
        BTCScript *scriptPubKey = [[BTCScript alloc]initWithString:model.script];
        BOOL r = [sm verifyWithOutputScript:scriptPubKey  error:&error];
        if (!r) {
            NSError *err = [NSError ErrorWithTitle:@"需要验证第一笔输出" Code:102506];
            callback(nil,err);
            return;
        }
        NSLog(@"Error: %@", error);
    }
    
    callback(tx2,error);
}












/* ********************************   huobi  ****************************** */
+(void)SaveHuobiAPIKey:(NSString *)apikey APISecret:(NSString *)apisecret{
    apikey == nil?: [[NSUserDefaults standardUserDefaults] setObject:apikey forKey:@"HuobiAPIKey"];
    apisecret == nil?: [[NSUserDefaults standardUserDefaults] setObject:apisecret forKey:@"HuobiAPISecret"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSString *)GetHuobiAPIKey{
    NSString *key = [NSString stringWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"HuobiAPIKey"]];
    return VALIDATE_STRING(key);
}
+(NSString *)GetHuobiAPISecret{
    NSString *key = [NSString stringWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"HuobiAPISecret"]];
    return VALIDATE_STRING(key);
}
@end
