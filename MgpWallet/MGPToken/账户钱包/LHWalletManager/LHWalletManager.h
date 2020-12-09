//
//  LHWalletManager.h
//  realmDemo
//
//  Created by mac on 2020/9/24.
//  Copyright © 2020 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LHWalletManager : NSObject

@property (strong, nonatomic)WalletModel *currentWallet;


/**初始化单列对象*/
+ (LHWalletManager *)sharedManger;

/**设置版本号*/
-(void)databaseMigration:(int)newVersion;

/**设置当前默认数据库*/
-(void)setDefaultRealmForUserDatabaseName:(NSString *)databaseName;


//---------------------------------增加---------------------------------
/**
 当前钱包添加代币
 */
- (void)addCurrentWalletToken:(TokenModel *)tokenModel;


/**
 增加数据
 */
- (void)addDefaultAppWalletModel:(AppModel *)appModel;

/***/
- (void)modifyDefaultAppWalletModel:(AppModel *)appModel;

//---------------------------------删除---------------------------------
/**
 删除当前钱包下的第*个代币
 */
- (void)deleteObjectIndex:(int)index;
/**
 删除当前钱包
 */
- (void)deleteCurrentWalletObject;


 

//---------------------------------修改数据------------------------------------

/**
 设置当前钱包
 */
- (void)setDefaultCurrentWalletModel:(WalletModel *)wallet;
    
@end

NS_ASSUME_NONNULL_END
