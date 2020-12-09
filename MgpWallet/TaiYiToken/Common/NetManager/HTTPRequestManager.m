//
//  HTTPRequestManager.m
//  TaiYiToken
//
//  Created by Frued on 2018/10/25.
//  Copyright © 2018 admin. All rights reserved.
//

#import "HTTPRequestManager.h"
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVMediaFormat.h>
#import <AVFoundation/AVAssetExportSession.h>

static NSString * const base_url = @"http://eos.greymass.com/";
static NSString * const eos_monitor_base_url = @"https://api.eosmonitor.io/v1/";


static CGFloat timeoutInterval = 10.0;

@implementation HTTPRequestManager

static HTTPRequestManager * defualt_monitor_shareMananger = nil;
static HTTPRequestManager * defualt_shareMananger = nil;
static HTTPRequestManager * defualt_EOSshareMananger = nil;
static HTTPRequestManager * defualt_MGPshareMananger = nil;
static HTTPRequestManager * defualt_normal_shareMananger = nil;

static dispatch_once_t onceToken;
static dispatch_once_t onceToken_normal;
static dispatch_once_t onceToken_monitor;

+ (instancetype)shareManager {
    //_dispatch_once(&onceToken, ^{
    if (defualt_shareMananger == nil) {
        CurrentNodes *nodes = [CreateAll GetCurrentNodes];
        NSString *misnodeurl;
        if (nodes) {
            misnodeurl = nodes.nodeMis;
            misnodeurl = @"https://api.coom.pub";

        }else{
            misnodeurl = @"https://api.mgpchain.com";
        }
        defualt_shareMananger = [[self alloc] initWithBaseURL:[NSURL URLWithString:misnodeurl]];

    }
   // });
    return defualt_shareMananger;
}

+ (instancetype)shareEosManager {
    //_dispatch_once(&onceToken, ^{
    if (defualt_EOSshareMananger == nil) {
        CurrentNodes *nodes = [CreateAll GetCurrentNodes];
        NSString *eosnodeurl;
        if (nodes) {
            eosnodeurl = nodes.nodeEos;
        }else{
            eosnodeurl = @"https://geo.eosasia.one";
        }
        if (eosnodeurl) {
            defualt_EOSshareMananger = [[self alloc] initWithBaseURL:[NSURL URLWithString:eosnodeurl]];
        }else{
            defualt_EOSshareMananger = [[self alloc] initWithBaseURL:[NSURL URLWithString:base_url]];
        }
    }
    // });
    return defualt_EOSshareMananger;

}
+ (instancetype)shareMgpManager {
    //_dispatch_once(&onceToken, ^{
    if (defualt_MGPshareMananger == nil) {
        CurrentNodes *nodes = [CreateAll GetCurrentNodes];
        NSString *eosnodeurl;
        if (nodes) {
            eosnodeurl = nodes.nodeMgp;
        }else{
            eosnodeurl = @"http://explorer.mgpchain.io:8000/";
        }
        if (eosnodeurl) {
            defualt_MGPshareMananger = [[self alloc] initWithBaseURL:[NSURL URLWithString:eosnodeurl]];
        }else{
            defualt_MGPshareMananger = [[self alloc] initWithBaseURL:[NSURL URLWithString:base_url]];
        }
    }
    // });
    return defualt_MGPshareMananger;

}

+ (void)deallocManager{
    // 销毁单例
    defualt_shareMananger = nil;
    defualt_EOSshareMananger = nil;
    defualt_MGPshareMananger = nil;
    onceToken=0l;
}


+ (instancetype)shareMonitorManager {
    
    _dispatch_once(&onceToken_monitor, ^{
        if (defualt_monitor_shareMananger == nil) {
            defualt_monitor_shareMananger = [[self alloc] initWithBaseURL:[NSURL URLWithString:eos_monitor_base_url]];
        }
    });
    
    return defualt_monitor_shareMananger;
}

+ (instancetype)shareNormalManager {
    _dispatch_once(&onceToken_normal, ^{
        if (defualt_normal_shareMananger == nil) {
            defualt_normal_shareMananger = [[self alloc] initWithBaseURL:nil];
        }
    });
    
    return defualt_normal_shareMananger;
}

#pragma mark 重写
- (instancetype)initWithBaseURL:(NSURL *)url {
    
    self = [super initWithBaseURL:url];
    if (self) {
        // 设置请求以及相应的序列化器
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        // 设置相应的缓存策略--URL应该加载源端数据，不使用本地缓存数据,忽略缓存直接从原始地址下载。
        self.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        // 设置超时时间
        self.requestSerializer.timeoutInterval = timeoutInterval;
        
        //注意：默认的Response为json数据
        //        AFJSONResponseSerializer *responseSerializer  = [AFJSONResponseSerializer serializer];
        // 在服务器返回json数据的时候，时常会出现null数据。json解析的时候，可能会将这个null解析成NSNull的对象，我们向这个NSNull对象发送消息的时候就会遇到crash的问题。
        //        responseSerializer.removesKeysWithNullValues = YES;
        // 设置请求内容的类型-- 复杂的参数类型 需要使用json传值-设置请求内容的类型】
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json", @"text/javascript", @"text/plain", nil];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    return self;
}

#pragma mark - GET 请求网络数据
/**
 *  请求网络数据
 *
 *  @param path             请求的地址
 *  @param paramters        请求的参数
 *  @param success          请求成功的回调
 *  @param failure          请求失败的回调
 */

- (void)get:(NSString *)path paramters:(NSDictionary *)paramters success:(void (^)(BOOL, id))success failure:(void (^)(NSError *))failure superView:(UIView *)view showLoading:(BOOL)loading showFaliureDescription:(BOOL)show {
    
    MBProgressHUD *hud;
    if (view && loading) hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    [self GET:path parameters:paramters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (hud) [hud hideAnimated:YES];
        
        
        if ([HTTPRequestManager validateResponseData:responseObject HttpURLResponse:task.response]) {
            if (IsNilOrNull(success)) return;
            success(YES,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (hud) [hud hideAnimated:YES];
 
        
        if (failure) failure(error);
    }];
}

- (void)get:(NSString *)path paramters:(NSDictionary *)paramters success:(void (^)(BOOL, id))success failure:(void (^)(NSError *))failure {
    [self get:path paramters:paramters success:success failure:failure superView:nil showLoading:NO showFaliureDescription:NO];
}

- (void)get:(NSString *)path paramters:(NSDictionary *)paramters success:(void (^)(BOOL, id))success failure:(void (^)(NSError *))failure superView:(UIView *)view {
    [self get:path paramters:paramters success:success failure:failure superView:view showLoading:NO showFaliureDescription:NO];
}

- (void)get:(NSString *)path paramters:(NSDictionary *)paramters success:(void (^)(BOOL, id))success failure:(void (^)(NSError *))failure superView:(UIView *)view showLoading:(BOOL)loading {
    [self get:path paramters:paramters success:success failure:failure superView:view showLoading:loading showFaliureDescription:NO];
}

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
        showFaliureDescription:(BOOL)show{
    
    MBProgressHUD *hud;
    if (view && loading) hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    NSURLSessionDataTask *task = [self POST:path parameters:paramters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (hud) [hud hideAnimated:YES];
        
//        NSLog(@"%@",task.description);
        
        if ([HTTPRequestManager validateResponseData:responseObject HttpURLResponse:task.response]) {
            if (IsNilOrNull(success)) return;
            success(YES,responseObject);
        }else{
            success(NO,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (hud) [hud hideAnimated:YES];
        
        
        if (failure) failure(error);
    }];
    
    return task;
}


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
                       failure:(void(^) (NSError *error))failure {
    return [self post:path paramters:paramters success:success failure:failure superView:nil showLoading:NO showFaliureDescription:NO];
}

- (NSURLSessionDataTask *)post:(NSString *)path
                     paramters:(NSDictionary *)paramters
                       success:(void(^) (BOOL isSuccess, id responseObject))success
                       failure:(void(^) (NSError *error))failure
                     superView:(UIView *)view
                   showLoading:(BOOL)loading {
    return [self post:path paramters:paramters success:success failure:failure superView:view showLoading:loading showFaliureDescription:NO];
}

- (NSURLSessionDataTask *)post:(NSString *)path
                     paramters:(NSDictionary *)paramters
                       success:(void(^) (BOOL isSuccess, id responseObject))success
                       failure:(void(^) (NSError *error))failure
                     superView:(UIView *)view
        showFaliureDescription:(BOOL)show {
    return [self post:path paramters:paramters success:success failure:failure superView:view showLoading:NO showFaliureDescription:show];
}


-(void)requestDownLoadDataWithPath:(NSString *)path withParamters:(NSDictionary *)paramters withSavaPath:(NSString *)savePath withProgress:(void (^)(float))downLoadProgress success:(void (^)(BOOL, id))success failure:(void (^)(NSError *))failure{
}


#pragma mark - DELETE 删除资源
- (void)requestDELETEDataWithPath:(NSString *)path
                    withParamters:(NSDictionary *)paramters
                          success:(void (^) (BOOL isSuccess, id responseObject))success
                          failure:(void (^) (NSError *error))failure {
    
    [[HTTPRequestManager  shareManager] DELETE:path parameters:paramters headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        if (success) {
            success(YES,success);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        if (failure) {
            failure(error);
        }
    }];
    
}

#pragma mark - PUT 更新全部属性
- (void)sendPUTDataWithPath:(NSString *)path
              withParamters:(NSDictionary *)paramters
                    success:(void(^) (BOOL isSuccess, id responseObject))success
                    failure:(void(^) (NSError *error))failure {
    
    [[HTTPRequestManager shareManager] PUT:path parameters:paramters headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        if (success) {
            success(YES,success);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        if (failure) {
            failure(error);
        }
    }];
}

#pragma  mark - PATCH 改变资源状态或更新部分属性
- (void)sendPATCHDataWithPath:(NSString *)path
                withParamters:(NSDictionary *)paramters
                      success:(void (^) (BOOL isSuccess, id responseObject))success
                      failure:(void (^) (NSError *error))failure {
    [[HTTPRequestManager shareManager] PATCH:path parameters:paramters headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        if (success) {
            success(YES,success);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark - 取消网络请求--全部请求
- (void)cancelAllNetworkRequest {
    
    [[HTTPRequestManager shareManager].operationQueue cancelAllOperations];
}

#pragma mark - 取消网络请求--指定请求
/**
 *  取消指定的url请求
 *
 *  @param type 该请求的请求类型
 *  @param path 该请求的完整url
 */
- (void)cancelHttpRequestWithType:(NSString *)type WithPath:(NSString *)path {
    
    NSError * error;
    // 根据请求的类型 以及 请求的url创建一个NSMutableURLRequest---通过该url去匹配请求队列中是否有该url,如果有的话 那么就取消该请求
    NSString *urlToPeCanced = [[[[HTTPRequestManager shareManager].requestSerializer requestWithMethod:type URLString:path parameters:nil error:&error] URL] path];
    
    for (NSOperation *operation in [HTTPRequestManager shareManager].operationQueue.operations) {
        
        // 如果是请求队列
        if ([operation isKindOfClass:[NSURLSessionTask class]]) {
            
            // 请求的类型匹配
            BOOL hasMatchRequestType = [type isEqualToString:[[(NSURLSessionTask *)operation currentRequest] HTTPMethod]];
            
            // 请求的url匹配
            BOOL hasMatchRequestUrlString = [urlToPeCanced isEqualToString:[[[(NSURLSessionTask *)operation currentRequest] URL] path]];
            
            // 两项都匹配的话  取消该请求
            if (hasMatchRequestType&&hasMatchRequestUrlString) {
                [operation cancel];
            }
        }
    }
}

#pragma mark Return the data validation interfaces
+ (BOOL)validateResponseData:(id) returnData HttpURLResponse: (NSURLResponse *)response{
    //获取http 状态码
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSLog(@"HttpCode: %ld", (long)httpResponse.statusCode);
    if(httpResponse.statusCode > 300){
        return NO;
    }
    return YES;
}
@end
