//
//  HTTPRequestManager.h
//  TaiYiToken
//
//  Created by Frued on 2018/10/25.
//  Copyright © 2018 admin. All rights reserved.
//

#import "AFHTTPSessionManager.h"

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

typedef NS_ENUM(NSUInteger, HTTPMethod) {
    HTTPMethodGET = 0,
    HTTPMethodPOST,
    HTTPMethodpUT,
    HTTPMethodPATCH,
    HTTPMethodDELETE,
};

@interface HTTPRequestManager : AFHTTPSessionManager

/**
 *  单例
 *
 *  @return 实例对象
 */
+ (instancetype)shareManager;

+ (instancetype)shareEosManager;

+ (instancetype)shareMgpManager;

/**
 * 销毁单例
 */
+ (void)deallocManager;

+ (instancetype)shareMonitorManager;

+ (instancetype)shareNormalManager;
#pragma mark - GET 请求网络数据
/**
 *  请求网络数据
 *
 *  @param path             请求的地址
 *  @param paramters        请求的参数
 *  @param success          请求成功的回调
 *  @param failure          请求失败的回调
 */
- (void)get:(NSString *)path paramters:(NSDictionary *)paramters success:(void (^)(BOOL, id))success failure:(void (^)(NSError *))failure superView:(UIView *)view showLoading:(BOOL)loading showFaliureDescription:(BOOL)show;

- (void)get:(NSString *)path paramters:(NSDictionary *)paramters success:(void (^)(BOOL isSuccess, id responseObject))success failure:(void (^)(NSError *failure))failure;

- (void)get:(NSString *)path paramters:(NSDictionary *)paramters success:(void (^)(BOOL isSuccess, id responseObject))success failure:(void (^)(NSError *failure))failure superView:(UIView *)view;

- (void)get:(NSString *)path paramters:(NSDictionary *)paramters success:(void (^)(BOOL, id))success failure:(void (^)(NSError *))failure superView:(UIView *)view showLoading:(BOOL)loading;

#pragma mark - POST 传送网络数据
/**
 *  传送网络数据
 *
 *  @param path           请求的地址
 *  @param paramters      请求的参数
 *  @param success        请求成功的回调
 *  @param failure        请求失败的回调
 */
- (NSURLSessionDataTask *)post:(NSString *)path
                     paramters:(NSDictionary *)paramters
                       success:(void(^) (BOOL isSuccess, id responseObject))success
                       failure:(void(^) (NSError *error))failure
                     superView:(UIView *)view
                   showLoading:(BOOL)loading
        showFaliureDescription:(BOOL)show;

- (NSURLSessionDataTask *)post:(NSString *)path
                     paramters:(NSDictionary *)paramters
                       success:(void(^) (BOOL isSuccess, id responseObject))success
                       failure:(void(^) (NSError *error))failure;

- (NSURLSessionDataTask *)post:(NSString *)path
                     paramters:(NSDictionary *)paramters
                       success:(void(^) (BOOL isSuccess, id responseObject))success
                       failure:(void(^) (NSError *error))failure
                     superView:(UIView *)view
                   showLoading:(BOOL)loading;

- (NSURLSessionDataTask *)post:(NSString *)path
                     paramters:(NSDictionary *)paramters
                       success:(void(^) (BOOL isSuccess, id responseObject))success
                       failure:(void(^) (NSError *error))failure
                     superView:(UIView *)view
        showFaliureDescription:(BOOL)show;


#pragma mark DOWNLOAD 文件下载
- (void)requestDownLoadDataWithPath:(NSString *)path
                      withParamters:(NSDictionary *)paramters
                       withSavaPath:(NSString *)savePath
                       withProgress:(void(^) (float progress))downLoadProgress
                            success:(void(^) (BOOL isSuccess, id responseObject))success
                            failure:(void(^) (NSError *error))failure;

#pragma mark - DELETE 删除资源
- (void)requestDELETEDataWithPath:(NSString *)path
                    withParamters:(NSDictionary *)paramters
                          success:(void (^) (BOOL isSuccess, id responseObject))success
                          failure:(void (^) (NSError *error))failure;

#pragma mark - PUT 更新全部属性
- (void)sendPUTDataWithPath:(NSString *)path
              withParamters:(NSDictionary *)paramters
                    success:(void(^) (BOOL isSuccess, id responseObject))success
                    failure:(void(^) (NSError *error))failure;

#pragma  mark - PATCH 改变资源状态或更新部分属性
- (void)sendPATCHDataWithPath:(NSString *)path
                withParamters:(NSDictionary *)paramters
                      success:(void (^) (BOOL isSuccess, id responseObject))success
                      failure:(void (^) (NSError *error))failure;

#pragma mark - 取消网络请求--全部请求
- (void)cancelAllNetworkRequest;

#pragma mark - 取消网络请求--指定请求
/**
 *  取消指定的url请求
 *
 *  @param type 该请求的请求类型
 *  @param path 该请求的完整url
 */
- (void)cancelHttpRequestWithType:(NSString *)type WithPath:(NSString *)path;


/**
 判断返回数据是否
 
 @param returnData returnData description
 @param response response description
 @return return value description
 */
+ (BOOL)validateResponseData:(id) returnData HttpURLResponse: (NSURLResponse *)response;

@end
