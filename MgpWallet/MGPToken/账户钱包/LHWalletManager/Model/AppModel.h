//
//  AppModel.h
//  realmDemo
//
//  Created by mac on 2020/9/24.
//  Copyright © 2020 mac. All rights reserved.
//

#import "RLMObject.h"
#import "WalletModel.h"
#import <RLMArray.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppModel : RLMObject

@property NSString *ID;
@property WalletModel *currentWallet;
@property RLMArray<WalletModel *><WalletModel> *wallets;


@end

NS_ASSUME_NONNULL_END
