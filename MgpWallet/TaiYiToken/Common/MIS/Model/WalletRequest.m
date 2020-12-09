//
//  HTTPRequestManager.h
//  TaiYiToken
//
//  Created by Frued on 2018/10/25.
//  Copyright © 2018 admin. All rights reserved.
//

#import "WalletRequest.h"
//#import "AccountManager.h"

@interface WalletRequest ()

@property (nonatomic, strong) AccountInfo *info;
@property (nonatomic, strong) NSURLSessionTask *task;

@end

@implementation WalletRequest

- (void)getAccountInfo:(void (^)(AccountInfo *, BOOL, WalletRequest *))response {
    //if (self.wallet && !self.task) {
        
        // 如果存在直接返回
        if (self.info) {
            response(self.info,YES,self);
            return;
        }
        
        // 获取当前钱包的用户名
        NSString *accountName = [CreateAll GetCurrentUserName];
       
        // 判断用户名是否存在
        if (accountName) {
            NSDictionary *dic = @{@"account_name":VALIDATE_STRING(accountName)};
            self.task = [[HTTPRequestManager shareManager] post:eos_get_account paramters:dic success:^(BOOL isSuccess, id responseObject) {
                self.task = nil;
                if (isSuccess) {
                    AccountInfo *info = [AccountInfo parse:responseObject];
                    self.info = info;
                    response(info,YES,self);
                }else{
                    response(nil,NO,self);
                }
            } failure:^(NSError *error) {
                self.task = nil;
                response(nil,NO,self);
            }];
        }else{
            response(nil,NO,self);
        }
        
   
}

@end
