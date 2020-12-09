//
//  MissionWallet.h
//  TaiYiToken
//
//  Created by Frued on 2018/8/27.
//  Copyright © 2018年 Frued. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTCChangeAddressModel.h"
@interface MissionWallet : NSObject<NSCoding>
/*
 BTC/ETH
 */
@property(nonatomic,copy)NSString *xprv;

@property(nonatomic,copy)NSString *AccountExtendedPrivateKey;
@property(nonatomic,copy)NSString *AccountExtendedPublicKey;
@property(nonatomic,copy)NSString *BIP32ExtendedPrivateKey;
@property(nonatomic,copy)NSString *BIP32ExtendedPublicKey;

@property(nonatomic,copy)NSString *privateKey;
@property(nonatomic,copy)NSString *publicKey;
@property(nonatomic,copy)NSString *address;

@property(nonatomic,copy)NSString *walletName;
@property(nonatomic,assign)BOOL ifEOSAccountRegistered;
//子钱包索引
@property(nonatomic)int index;

@property(nonatomic,assign)CoinType coinType;
//BTC存所有地址，ETH只有主地址address
@property(nonatomic)NSMutableArray *addressarray;
//当前选中的子地址
@property(nonatomic,copy)NSString *selectedBTCAddress;
//导入/本地生成
@property(nonatomic)WALLET_TYPE walletType;
//导入方式，若不是导入则为LOCAL_CREATED_WALLET
@property(nonatomic)IMPORT_WALLET_TYPE importType;
//密码提示
@property(nonatomic,copy)NSString *passwordHint;
//btc找零地址
@property(nonatomic,strong)NSMutableArray <BTCChangeAddressModel *> *changeAddressArray;
//btc找零地址
@property(nonatomic,copy)NSString *changeAddressStr;
-(void)dataCheck;
@end
