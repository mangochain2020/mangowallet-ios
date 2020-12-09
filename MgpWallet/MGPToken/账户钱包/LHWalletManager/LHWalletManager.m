//
//  LHWalletManager.m
//  realmDemo
//
//  Created by mac on 2020/9/24.
//  Copyright © 2020 mac. All rights reserved.
//

#import "LHWalletManager.h"

@implementation LHWalletManager

static LHWalletManager *__onetimeClass;
+ (LHWalletManager *)sharedManger {
static dispatch_once_t oneToken;

    dispatch_once(&oneToken, ^{

        __onetimeClass = [[LHWalletManager alloc]init];
        [__onetimeClass setDefaultRealmForUserDatabaseName:@"algor_testNetwork"];
    });
    return __onetimeClass;
}

-(void)databaseMigration:(int)newVersion{

   // 1. 获取默认配置
   RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
   // 2. 叠加版本号(要比上一次的版本号高) 0
   config.schemaVersion = newVersion;
   // 3. 设置闭包，这个闭包将会在打开低于上面所设置版本号的 Realm 数据库的时候被自动调用
   [config setMigrationBlock:^(RLMMigration *migration, uint64_t oldSchemaVersion) {
         // 什么都不要做！Realm 会自行检测新增和需要移除的属性，然后自动更新硬盘上的数据库架构
         if (oldSchemaVersion < newVersion) {
         
         }
   }];
   // 4. 让配置生效（告诉 Realm 为默认的 Realm 数据库使用这个新的配置对象）
   [RLMRealmConfiguration setDefaultConfiguration:config];
   // 5. 我们已经告诉了 Realm 如何处理架构的变化，打开文件之后将会自动执行迁移,数据结构会发生变化
   [RLMRealm defaultRealm];
}

-(void)setDefaultRealmForUserDatabaseName:(NSString *)databaseName{

    
    NSMutableData *key = [NSMutableData dataWithLength:64];
    (void)SecRandomCopyBytes(kSecRandomDefault, key.length, (uint8_t *)key.mutableBytes);
    
     RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
//    config.encryptionKey = key;
     // 使用默认的目录，但是使用用户名来替换默认的文件名
     config.fileURL = [[[config.fileURL URLByDeletingLastPathComponent] URLByAppendingPathComponent: databaseName] URLByAppendingPathExtension:@"realm"];
     // 将这个配置应用到默认的 Realm 数据库当中
     [RLMRealmConfiguration setDefaultConfiguration:config];
    
    NSLog(@"%@----%@",config.fileURL,key);
    
    NSError *error = nil;
    RLMRealm *realm = [RLMRealm realmWithConfiguration:config error:&error];
    if (!realm) {
        // 如果秘钥错误，`error` 会提示数据库无法访问
        NSLog(@"Error opening realm: %@", error);
    }
    
    
}


/**
 增加数据---------------------------------------------------------------------
 */
- (void)addDefaultAppWalletModel:(AppModel *)appModel {
    //将数据加入到数据库中
    RLMRealm *realm = [RLMRealm defaultRealm];

    [realm transactionWithBlock:^{
        [realm addObject:appModel];
    }];
    NSLog(@"results: %@",[AppModel allObjects]);
}

/**
 当前钱包添加代币
 */
- (void)addCurrentWalletToken:(TokenModel *)tokenModel {
    //将数据加入到数据库中
    RLMRealm *realm = [RLMRealm defaultRealm];

    AppModel *appModel = [[AppModel allObjects] firstObject];
    [realm transactionWithBlock:^{
        
        NSInteger index = [appModel.wallets indexOfObject:appModel.currentWallet];
        if (index < appModel.wallets.count) {
            WalletModel *walletModel = appModel.wallets[index];
            [walletModel.selectedTokenList addObject:tokenModel];
            appModel.currentWallet = walletModel;
        }
    }];
}





/**
 删除数据--------------------------------------------------------------------------
 */
- (void)deleteObject {

    //获取OrderModel所有数据
    RLMResults *results = [WalletModel allObjects];
    NSLog(@"results: %@",results);
    
    //将数据加入到数据库中
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        [realm deleteAllObjects];
    }];
    NSLog(@"results: %@",results);
}
/**
 删除当前钱包下的第*个代币
 */
- (void)deleteObjectIndex:(int)index{
    
    //删除数据库中数据
    RLMRealm *realm = [RLMRealm defaultRealm];

    AppModel *appModel = [[AppModel allObjects] firstObject];
    [realm transactionWithBlock:^{
        [appModel.currentWallet.selectedTokenList removeObjectAtIndex:index];
    }];
}
/**
 删除当前钱包
 */
- (void)deleteCurrentWalletObject{
    
    //删除数据库中数据
    RLMRealm *realm = [RLMRealm defaultRealm];

    AppModel *appModel = [[AppModel allObjects] firstObject];
    [realm transactionWithBlock:^{
        
        NSInteger index = [appModel.wallets indexOfObject:appModel.currentWallet];
        if (index < appModel.wallets.count) {
            [appModel.wallets removeObjectAtIndex:index];
            appModel.currentWallet = appModel.wallets.firstObject;
        }else{
            [[[MGPHttpRequest shareManager]jsd_findVisibleViewController].view showMsg:@"最后一个钱包了"];
        }
    }];
}


/**
 修改数据---------------------------------------------------------------------
 */
/**
 设置当前钱包
 */
- (void)setDefaultCurrentWalletModel:(WalletModel *)wallet {
    RLMRealm *realm = [RLMRealm defaultRealm];

    AppModel *appModel = [[AppModel allObjects] firstObject];
    [realm transactionWithBlock:^{
        appModel.currentWallet = wallet;
    }];
    
}
- (void)modifyDefaultAppWalletModel:(AppModel *)appModel {
    //将数据加入到数据库中
    RLMRealm *realm = [RLMRealm defaultRealm];

    [realm transactionWithBlock:^{
        [realm addOrUpdateObject:appModel];
    }];
    NSLog(@"results: %@",[AppModel allObjects]);
}

/**
 查询数据---------------------------------------------------------------------
 */
- (void)queryObject {
    
    RLMResults *results = [WalletModel allObjects];


    
}



@end
