//
//  EOSAccountKey.h
//  TaiYiToken
//
//  Created by admin on 2018/9/26.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JavascriptWebViewController.h"

@interface EOSAccountKey : NSObject
@property(nonatomic, strong) NSString *eosPrivateKey;
@property(nonatomic, strong) NSString *eosPublicKey;

//+(void)EOSKeyByJvc:(JavascriptWebViewController *)jvc Mnemonic:(NSString*)mnemonic KeyType:(EOSKeyType)keyType callback: (void (^)(EOSAccountKey *key))callback;
@end
