//
//  TokenModel.h
//  realmDemo
//
//  Created by mac on 2020/9/24.
//  Copyright © 2020 mac. All rights reserved.
//

#import "RLMObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface TokenModel : RLMObject

@property NSString *ID;
@property NSString *identifier;
@property NSString *name;
@property NSString *iconUrl;
@property NSString *contractAddress;
@property int decimals;
@property NSString *symbol;
@property double price;
@property double balance;
@property int tokenCoinType;


@end

RLM_ARRAY_TYPE(TokenModel)
NS_ASSUME_NONNULL_END
