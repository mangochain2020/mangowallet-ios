//
//  CreateAll.h
//  TaiYiToken
//
//  Created by Frued on 2018/8/21.
//  Copyright © 2018年 Frued. All rights reserved.
//
/*
 生成钱包的整体流程
 
 *** bitcoin钱包生成 ***
 1.生成一个助记词（参见 BIP39）
 2.该助记词使用 PBKDF2 转化为种子（参见 BIP39）
 3.种子用于使用 HMAC-SHA512 生成根私钥（参见BIP32）
 4.从该根私钥，导出子私钥（参见BIP32），其中节点布局由BIP44设置
 
 包含私钥的扩展密钥用以推导子私钥，从子私钥又可推导对应的公钥和比特币地址
 包含公钥的扩展密钥用以推导子公钥
 扩展密钥使用 Base58Check 算法加上特定的前缀编码，编码得到的包含私钥的前缀为 xprv, 包含公钥的扩展密钥前缀为 xpub，相比比特币的公私钥，扩展密钥编码之后得到的长度为 512 或 513 位
 
 *** eth钱包生成 ***
 1.同上
 2.生成地址使用ethers接口实现
 */
#import <Foundation/Foundation.h>
#import "NYMnemonic.h"

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>


#import "secp256k1.h"
#import "secp256k1_ecdh.h"
#import "secp256k1_recovery.h"
#import "util.h"


#import "NSString+Bitcoin.h"
#import "NSData+Bitcoin.h"
#import "BRBIP32Sequence.h"

#import "JavascriptWebViewController.h"
#import "EOSAccountKey.h"
#import "UserInfoModel.h"
#import "SystemInitModel.h"
#import "CurrentNodes.h"
#import "LHCurrencyModel.h"

@interface CreateAll : NSObject
/*
 *********************************************系统初始化********************************************************
 */
//存系统初始化信息
+(void)SaveSystemData:(SystemInitModel *)model;

//取系统初始化信息
+(SystemInitModel *)GetSystemData;

//存当前节点
+(void)SaveCurrentNodes:(CurrentNodes *)model;

//取当前节点
+(CurrentNodes *)GetCurrentNodes;

/*
 *********************************************Mis钱包管理********************************************************
 */
//判断mis账号是否注册成功
+(BOOL)ifMisWalletRegistered;
//标记注册成功
+(void)setmisWalletisRegistered;
/*
 *********************************************账号本地管理********************************************************
 */
/*
判断是否登录
*/
+(BOOL)isLogin;

/*
 登录成功 存用户名到keychain
 */
+(void)SaveUserName:(NSString *)username Password:(NSString *)password;
/*
 取当前用户名
 */
+(NSString *)GetCurrentUserName;

/*
 退出账号
 */
+(void)LogOut;


/*
 保存当前用户，最多只存一个用户
 */
+(void)SaveCurrentUser:(UserInfoModel *)model;

/*
 取当前用户
 */
+(UserInfoModel *)GetCurrentUser;


/*
保存当前货币类型
*/
+(void)SaveCurrentCurrency:(LHCurrencyModel *)model;

/*
取当前货币类型
*/
+(LHCurrencyModel *)GetCurrentCurrency;


/***************  实名认证  ********************/
/*
 存身份验证信息
 */
+(void)SaveUserID:(NSString *)idstring ForUser:(NSString *)name Status:(USERIDENTITY_VERIFY_STATUS)status;

/*
 取身份验证信息 ID
 */
+(NSString *)GetUserIDForCurrentUser;

/*
 取身份验证信息 姓名
 */
+(NSString *)GetUserNameForCurrentUser;

/*
 取身份验证信息 验证状态
 */
+(USERIDENTITY_VERIFY_STATUS)GetUserIDVerifyStatusForCurrentUser;

/*
 工具
 */
//验证是否是HexString
+(BOOL)ValidHexString:(NSString *)string;

+ (BOOL)isValidForETH:(NSString *)string;

/*
 ********************************************** 钱包生成/导入/恢复 ***********************************************
 */
//由助记词生成种子  seed
+(NSString *)CreateSeedByMnemonic:(NSString *)mnemonic Password:(NSString *)password;


//根据mnemonic生成keystore,用于恢复账号，备份私钥，导出助记词等
+(void)CreateKeyStoreByMnemonic:(NSString *)mnemonic WalletAddress:(NSString *)walletAddress Password:(NSString *)password  callback: (void (^)(Account *account, NSError *error))callback;
//根据PrivateKey生成keystore,用于恢复账号，备份私钥，导出助记词等
+(void)CreateKeyStoreByPrivateKey:(NSString *)privatekey  WalletAddress:(NSString *)walletAddress Password:(NSString *)password  callback: (void (^)(Account *account, NSError *error))callback;

+(NSString *)GenerateNewWalletNameWithWalletAddress:(NSString *)address CoinType:(CoinType)coinType;

//扩展主公钥生成    mpk
//+(NSString *)CreateMasterPublicKeyWithSeed:(NSString *)seed;
//取主公钥
//+(NSData *)GetMasterPublicKey;

//根据BIP32ExtendedPublicKey扩展公钥生成index索引的子BTCKey
+(BTCKey *)CreateBTCAddressAtIndex:(UInt32)index ExtendKey:(NSString *)extendedPublicKey;

//扩展账号私钥生成  xprv
+(NSString *)CreateExtendPrivateKeyWithSeed:(NSString *)seed;
//扩展账号公钥生成  xpub
+(NSString *)CreateExtendPublicWithSeed:(NSString *)seed;

//创建钱包 由扩展私钥xprv生成第index个秘钥对及地址
+(MissionWallet *)CreateWalletByXprv:(NSString*)xprv index:(UInt32)index CoinType:(CoinType)coinType Password:(NSString *)password;

//生成地址二维码
+(UIImage *)CreateQRCodeForAddress:(NSString *)address;




/*
 *************************************************** 钱包导入 ****************************************************
 */

//由助记词导入钱包 （存储钱包 生成存储KeyStore）
/*
 return nil; 表示钱包已存在 提示导入错误
 */
+(void)ImportWalletByMnemonic:(NSString *)mnemonic CoinType:(CoinType)coinType Password:(NSString *)password PasswordHint:(NSString *)passwordHint callback: (void (^)(MissionWallet *wallet, NSError *error))completionHandler;

//由私钥导入钱包  （存储钱包 生成存储KeyStore）
/*
 return nil; 表示钱包已存在 提示导入错误
 */
+(MissionWallet *)ImportWalletByPrivateKey:(NSString *)privateKey CoinType:(CoinType)coinType Password:(NSString *)password PasswordHint:(NSString *)passwordHint;
//由KeyStore导入钱包 （存储钱包 生成存储KeyStore）
/*
 wallet == nil; 表示钱包已存在 提示导入错误
 */
+(void)ImportWalletByKeyStore:(NSString *)keystore  CoinType:(CoinType)coinType Password:(NSString *)password PasswordHint:(NSString *)passwordHint callback: (void (^)(MissionWallet *wallet, NSError *error))callback;






/*
 ************************************************** 钱包导出 *************************************
 */
//导出keystore
+(void)ExportKeyStoreByPassword:(NSString *)password  WalletAddress:(NSString *)walletAddress callback: (void (^)(NSString *address, NSError *error))callback;

//导出助记词
+(void)ExportMnemonicByPassword:(NSString *)password WalletAddress:(NSString *)walletAddress callback: (void (^)(NSString *mnemonic, NSError *error))callback;

//导出私钥
+(void)ExportPrivateKeyByPassword:(NSString *)password CoinType:(CoinType)coinType WalletAddress:(NSString *)walletAddress  index:(UInt32)index  callback: (void (^)(NSString *privateKey, NSError *error))callback;

//验证钱包密码
+(BOOL)VerifyPassword:(NSString *)password ForWalletAddress:(NSString *)walletAddress;




/*
 *************************************************** 钱包账号存取管理 *************************************************
 */
//清空所有钱包，退出账号
+(void)RemoveAllWallet;

//取得所有钱包名称（包含导入）
+(NSArray *)GetWalletNameArray;

//取得所有导入的钱包名称
+(NSArray *)GetImportWalletNameArray;

//根据钱包名称取钱包
+(MissionWallet *)GetMissionWalletByName:(NSString *)walletname;

//取某币种类型的钱包
+(NSArray *)GetWalletArrayByCoinType:(CoinType)type;

//存储钱包
+(void)SaveWallet:(MissionWallet *)wallet Name:(NSString *)walletname WalletType:(WALLET_TYPE)walletType Password:(NSString *)password;

//存取密码提示(本地钱包)
+(void)UpdatePasswordHint:(NSString *)passwordHint;
+(NSString *)GetPasswordHint;

//移除导入的钱包
/*
 return @"WalletType is LOCAL_WALLET !";
 return @"Delete WalletName Failed!";
 return @"Delete Wallet Failed!";
 return @"Delete Successed!"; 成功
 */
+(NSString *)RemoveImportedWallet:(MissionWallet *)wallet;

//删除钱包 仅用于本地EOS选择帐号后更新钱包
+(BOOL)RemoveWallet:(MissionWallet *)wallet;

/*
 ********************************************** 转账 *******************************************************************
 */
/*
 BTC 找零地址生成100条 并存入数据库**********************************
 */
+(void)CreateBTCChangeAddressByXprv:(NSString*)xprv CoinType:(CoinType)coinType Password:(NSString *)password;
//给指定的BTC钱包新增一条找零地址
//+(BOOL)addChangeAddressForWalletAddress:(NSString *)walletaddr Key:(NSString *)xprv CoinType:(CoinType)coinType;
//插入数据
+(BOOL)insert:(FMDatabase *)db WalletAddress:(NSString *)walletaddr Data:(BTCKey *)key Index:(int)index CoinType:(CoinType)coinType Password:(NSString *)password;
//更新数据 根据changeaddress 记录地址当前是否使用过 (1000 unused/1001used)
+(BOOL)updateStatus:(FMDatabase *)db ChangeAddr:(NSString *)changeaddress Status:(NSInteger)status;
//更新数据 根据index 记录地址当前是否使用过 (1000 unused/1001used)
+(BOOL)updateStatus:(FMDatabase *)db Index:(NSInteger)index Status:(NSInteger)status;
//更新数据 根据index 记录地址当前是否使用过 (1000 unused/1001used)
+(BOOL)updateStatus:(FMDatabase *)db FromZeroToIndex:(NSInteger)index Status:(NSInteger)status;
//删除找零地址表
+(BOOL)DeleteChangeAddressTable:(FMDatabase *)db;
//删除数据
+(BOOL)delete:(FMDatabase *)db walletaddress:(NSString *)walletaddress;
//查询所有找零地址
+(NSArray *)queryAllchange:(FMDatabase *)db Address:(NSString *)walletaddress;
//查询找零地址的索引
+ (NSArray *)query:(FMDatabase *)db walletaddress:(NSString *)walletaddress changeAddress:(NSString *)changeaddress;


//**************  BTC ********************
//转账
+(void)BTCTransactionFromWallet:(MissionWallet *)wallet ToAddress:(NSString *)address Amount:(BTCAmount)amount
                            Fee:(BTCAmount)fee
                            Api:(BTCAPI)btcApi
                            Password:(NSString *)password
                       callback: (void (^)(NSString *result, NSError *error))callback;

//**************  ETH ********************
//转账
+(void)ETHTransaction:(Transaction *)transaction Wallet:(MissionWallet *)wallet GasPrice:(BigNumber *)gasPrice GasLimit:(BigNumber *)gasLimit tokenETH:(NSString *)tokenETH callback: (void (^)(HashPromise *promise))callback;
//获取ETH价格
+(void)GetETHCurrencyCallback: (void (^)(FloatPromise *etherprice))callback;
//获取GAS价格
+(void)GetGasPriceCallback: (void (^)(BigNumberPromise *gasPrice))callback;
//获取交易记录
+(void)GetTransactionsForAddress:(NSString *)address startBlockTag: (BlockTag)blockTag Callback: (void (^)(ArrayPromise *promiseArray))callback;
//获取交易详情
+(void)GetTransactionDetaslByHash:(NSString *)hash Callback: (void (^)(TransactionInfoPromise *promise))callback;
//获取余额
+(void)GetBalanceETHForWallet:(MissionWallet *)wallet callback: (void (^)(BigNumber *balance))callback;
//创建交易
+(void)CreateETHTransactionFromWallet:(MissionWallet *)wallet ToAddress:(NSString *)address Value:(BigNumber *)value callback: (void (^)(Transaction *transaction))callback;
//获取交易预估gas
+(void)GetGasLimitPriceForTransaction:(Transaction *)transaction callback: (void (^)(BigNumber *gasLimitPrice))callback;
/*
 存储刚刚广播未打包的ETH交易
 */
+(void)SaveETHTxHash:(NSString *)hash ForAddr:(NSString *)addr;
/*
 删除已经打包的ETH交易
 */
+(void)DeleteETHTxHash:(NSString *)hash ForAddr:(NSString *)addr;
/*
 取未打包的ETH交易
 */
+(NSArray *)GetETHTxhashForAddr:(NSString *)addr;

/*
 ********************************************** EOS *******************************************************************
 */


////*************************  BIP44 EOSKey  *************************
//BIP44 EOSKey
+(NSString *)CreateEOSPrivateKeyBySeed:(NSString *)seed Index:(uint32_t)index;

/*
 ********************************************** USDT *******************************************************************
 */
/*
 00000000 0000001f 00000000 3b9aca00
 NSString *str = [CreateAll Omni_createpayload_simplesend_USDT:BTCAmountFromDecimalNumber(@475)];
 */
+(NSString *)Omni_createpayload_simplesend_USDT:(BTCAmount)amount;

+(NSData *)Omni_createpayload_simplesend_USDTData:(BTCAmount)amount;


//转账
+(void)USDTTransactionFromWallet:(MissionWallet *)wallet ToAddress:(NSString *)address Amount:(BTCAmount)usdtamount
                             Fee:(BTCAmount)fee
                             Api:(BTCAPI)btcApi
                        Password:(NSString *)password
                        callback: (void (^)(NSString *result, NSError *error))callback;
/* ********************************   huobi  ****************************** */
+(void)SaveHuobiAPIKey:(NSString *)apikey APISecret:(NSString *)apisecret;
+(NSString *)GetHuobiAPIKey;
+(NSString *)GetHuobiAPISecret;
@end
