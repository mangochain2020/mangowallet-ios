//
//  CreateAccountTool.h
//  TaiYiToken
//
//  Created by mac on 2020/12/16.
//  Copyright © 2020 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CreateAccountTool : NSObject

+ (instancetype)shareManager;

//是否备份
@property(nonatomic,assign)BOOL isSkip;

//用户名
@property(nonatomic,copy)NSString *walletName;





/**
 创建多链账户钱包
 */
-(void)CreateWalletSeed:(NSString *)seed PassWord:(NSString *)password PassHint:(NSString *)hint Mnemonic:(NSString *)mnemonic isSkip:(BOOL)isSkip WalletAddressName:(NSString *)walletName WalletType:(WALLET_TYPE)walletType ImportType:(IMPORT_WALLET_TYPE)importType CoinType:(CoinType)coinType completionHandler:(void (^)(id responseObj, NSError *error))handler;


/**
 创建单一钱包ETH
 */
-(void)CreateETHWalletSeed:(NSString *)seed PassWord:(NSString *)password PassHint:(NSString *)hint Mnemonic:(NSString *)mnemonic WalletType:(IMPORT_WALLET_TYPE)type isSkip:(BOOL)isSkip;

@end

NS_ASSUME_NONNULL_END
