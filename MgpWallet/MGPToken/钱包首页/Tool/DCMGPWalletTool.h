//
//  DCMGPWalletTool.h
//  TaiYiToken
//
//  Created by mac on 2020/9/3.
//  Copyright © 2020 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DCMGPWalletTool : NSObject

+ (instancetype)shareManager;

/**
 交易转账
 */
- (void)transferAmount:(NSString *)amount andFrom:(NSString *)from andTo:(NSString *)to andMemo:(NSString *)memo andPassWord:(NSString *)passWord completionHandler:(void (^)(id responseObj, NSError *error))handler;

/**
 合约调用
 */
- (void)contractCode:(NSString *)code andAction:(NSString *)action andParameters:(NSDictionary *)parameters andPassWord:(NSString *)passWord completionHandler:(void (^)(id responseObj, NSError *error))handler;


/**
 字典转json字符串
 */
-(NSString *)convertToJsonData:(NSDictionary *)dict;

/**
 数组转json字符串
 */
- (NSString *)arrayToJSONString:(NSArray *)array;

@end

NS_ASSUME_NONNULL_END
