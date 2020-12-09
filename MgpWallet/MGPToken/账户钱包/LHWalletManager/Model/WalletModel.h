//
//  WalletModel.h
//  realmDemo
//
//  Created by mac on 2020/9/24.
//  Copyright © 2020 mac. All rights reserved.
//

#import "RLMObject.h"
#import <RLMArray.h>
#import "TokenModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WalletModel : RLMObject

@property NSString *ID;
@property NSString *address;
@property NSString *name;
@property NSString *iconName;
@property NSString *pwdTips;
@property NSString *pwd;
@property int coinType;

@property NSString *eosPublicKey;

@property RLMArray<TokenModel *><TokenModel> *selectedTokenList;

@end
RLM_ARRAY_TYPE(WalletModel)

NS_ASSUME_NONNULL_END
