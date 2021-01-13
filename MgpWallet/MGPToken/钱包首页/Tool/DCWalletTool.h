//
//  DCWalletTool.h
//  TaiYiToken
//
//  Created by mac on 2021/1/12.
//  Copyright © 2021 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DCWalletTool : NSObject

+ (instancetype)shareManager;

/**
 parameters:                  //参数数组
     NSDictionary *dic = @{
         @"code":@"",         //合约名
         @"action":@"",       //动作
         @"parameter":@{      //参数集合
                 @"k1":@"v1",
                 @"k2":@"v2"
         }
     };
 
 
 */
- (void)contractParameters:(NSArray *)parameters andPassWord:(NSString *)passWord completionHandler:(void (^)(id responseObj, NSError *error))handler;


@end

NS_ASSUME_NONNULL_END
