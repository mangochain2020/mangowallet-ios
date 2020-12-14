//
//  MGPHttpRequest.h
//  TaiYiToken
//
//  Created by mac on 2020/7/22.
//  Copyright © 2020 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "MissionWallet.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGPHttpRequest : NSObject

@property(strong, nonatomic)MissionWallet *curretWallet;


+ (instancetype)shareManager;

- (void)post:(NSString *)path paramters:(NSDictionary *)paramters completionHandler:(void (^)(id responseObj, NSError *error))handler;

- (void)test:(NSString *)path paramters:(NSDictionary *)paramters;

//传图片流
- (void)post:(NSString *)path andImages:(NSArray *)postImageArr completionHandler:(void (^)(id responseObj, NSError *error))handler;

/*
字典转json字符串
*/
-(NSString *)convertToJsonData:(NSDictionary *)dict;

- (NSString *)arrayToJSONString:(NSArray *)array;
/*
解密
*/
- (NSString *)paranDecryptString:(NSString *)paran;
/*
 加密
 */
- (NSString *)paranEncryptString:(NSString *)paran;


/**
 获取当前控制器
 */
- (UIViewController *)jsd_findVisibleViewController;


@end

NS_ASSUME_NONNULL_END
