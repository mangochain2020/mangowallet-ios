//
//  HTTPRequestManager.h
//  TaiYiToken
//
//  Created by Frued on 2018/10/25.
//  Copyright © 2018 admin. All rights reserved.
//


#import <Foundation/Foundation.h>
//#import "Wallet.h"
#import "AccountInfo.h"

@interface WalletRequest : NSObject

//@property (nonatomic, strong) Wallet *wallet;

- (void)getAccountInfo:(void(^)(AccountInfo *accountInfo,BOOL success,WalletRequest *request))response;

@end
