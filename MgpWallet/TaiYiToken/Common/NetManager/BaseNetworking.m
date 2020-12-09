//
//  BaseNetworking.m
//  TRProject

//

#import "BaseNetworking.h"



@implementation BaseNetworking



+(void)SetHeaderParamsFor:(AFHTTPSessionManager *)manager{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
   // CFShow((__bridge CFTypeRef)(infoDictionary));
    /*  系统公共参数  */
    //appVersion //CFBundleShortVersionString CFBundleVersion
    NSString *appCurVersionNum = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    //hwid
    NSString *uuid = [UIDevice currentDevice].identifierForVendor.UUIDString;
    //mobileType 手机型号
    NSString* mobileType = [[UIDevice currentDevice] model];
    //osType
    NSString *osType = @"iOS";
    //osVersion
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
  
    //userToken
    NSString *userToken = ([[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"] == nil|| [[[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"] isEqualToString:@""])?nil:[[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"];
    //userId 
    NSString *userId = ([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] == nil || [[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] isEqualToString:@""])?nil:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    
    [manager.requestSerializer setValue:appCurVersionNum forHTTPHeaderField:@"appVersion"];
    [manager.requestSerializer setValue:uuid forHTTPHeaderField:@"hwid"];
    [manager.requestSerializer setValue:mobileType forHTTPHeaderField:@"mobileType"];
    [manager.requestSerializer setValue:osType forHTTPHeaderField:@"osType"];
    [manager.requestSerializer setValue:phoneVersion forHTTPHeaderField:@"osVersion"];
    
    userToken == nil? : [manager.requestSerializer setValue:userToken forHTTPHeaderField:@"userToken"];
    userId == nil? [manager.requestSerializer setValue:@"0" forHTTPHeaderField:@"userId"]:[manager.requestSerializer setValue:userId forHTTPHeaderField:@"userId"];
}


+ (id)GETSetHeader:(NSString *)path parameters:(NSDictionary *)parameters completionHandler:(void (^)(id, NSError *))completionHandler{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    //    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
    //    [securityPolicy setAllowInvalidCertificates:YES];
    //
    //    [manager setSecurityPolicy:securityPolicy];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", @"text/json", @"text/javascript", @"text/plain",@"application/x-www-form-urlencoded", nil];
    //设置请求头
    [BaseNetworking SetHeaderParamsFor:manager];

    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", @"text/json", @"text/javascript", @"text/plain", nil];
    return [manager GET:path parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"%@", task.currentRequest.URL.absoluteString);
        !completionHandler?:completionHandler(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", task.currentRequest.URL.absoluteString);
        NSLog(@"%@", error);
        !completionHandler ?: completionHandler(nil, error);
    }];
    
}
/*
 json
 */
+ (id)POSTSetHeader:(NSString *)path parameters:(NSDictionary *)parameters completionHandler:(void (^)(id, NSError *))completionHandler{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", @"text/json", @"text/javascript", @"text/plain", nil];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", @"text/json", @"text/javascript", @"text/plain",@"application/x-www-form-urlencoded", nil];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    //设置请求头
    [BaseNetworking SetHeaderParamsFor:manager];
    [manager.requestSerializer requestWithMethod:@"POST" URLString:path parameters:parameters error:nil];
    return [manager POST:path parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // NSLog(@"%@", task.currentRequest.URL.absoluteString);
        !completionHandler?:completionHandler(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //NSLog(@"%@", task.currentRequest.URL.absoluteString);
        //NSLog(@"%@", error);
        !completionHandler ?: completionHandler(nil, error);
    }];
    
}
/*
 多数据类型
 */
+ (id)POSTSetHeaderImage:(NSString *)path parameters:(NSDictionary *)parameters completionHandler:(void (^)(id, NSError *))completionHandler{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", @"text/json", @"text/javascript", @"text/plain",@"application/x-www-form-urlencoded", nil];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    //设置请求头
    [BaseNetworking SetHeaderParamsFor:manager];
    return [manager POST:path parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", task.currentRequest.URL.absoluteString);
        !completionHandler?:completionHandler(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", task.currentRequest.URL.absoluteString);
        NSLog(@"%@", error);
        !completionHandler ?: completionHandler(nil, error);
    }];
    
}


/* 上传文件 人脸识别*/
+(id)POSTFileSetHeader:(NSString *)path parameters:(NSDictionary *)parameters completionHandler:(void (^)(id, NSError *))completionHandler{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", @"text/json", @"text/javascript", @"text/plain",@"application/x-www-form-urlencoded", nil];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    //设置请求头
    [BaseNetworking SetHeaderParamsFor:manager];
    return  [manager POST:path parameters:parameters headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        /* 本地图片上传 */
        
//        NSData *imageData =
        NSData *imgidfront = [parameters objectForKey:@"idFront"];
        NSData *imgidRevers =[parameters objectForKey:@"idRevers"];
        NSData *imgface =[parameters objectForKey:@"face"];
        // 直接将图片对象转成 data 也可以
        // UIImage *image = [UIImage imageNamed:@"test"];
        // NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
        
        /* 上传数据拼接 */
        [formData appendPartWithFileData:imgidfront name:@"file" fileName:@"idFront.png" mimeType:@"image/png"];
        [formData appendPartWithFileData:imgidRevers name:@"file" fileName:@"idRevers.png" mimeType:@"image/png"];
        [formData appendPartWithFileData:imgface name:@"file" fileName:@"face.png" mimeType:@"image/png"];
        
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        !completionHandler?:completionHandler(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !completionHandler?:completionHandler(nil, error);
    }];
    
}
///////////////////////





+ (id)GET:(NSString *)path parameters:(NSDictionary *)parameters completionHandler:(void (^)(id, NSError *))completionHandler{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
//    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
//    [securityPolicy setAllowInvalidCertificates:YES];
//
//    [manager setSecurityPolicy:securityPolicy];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //设置请求头
   // [];
    
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", @"text/json", @"text/javascript", @"text/plain", nil];
    return [manager GET:path parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"%@", task.currentRequest.URL.absoluteString);
        !completionHandler?:completionHandler(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", task.currentRequest.URL.absoluteString);
        NSLog(@"%@", error);
        !completionHandler ?: completionHandler(nil, error);
    }];
    
}
/*
 json
 */
+ (id)POST:(NSString *)path parameters:(NSDictionary *)parameters completionHandler:(void (^)(id, NSError *))completionHandler{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", @"text/json", @"text/javascript", @"text/plain", nil];
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 15.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [manager.requestSerializer requestWithMethod:@"POST" URLString:path parameters:parameters error:nil];
    return [manager POST:path parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
      // NSLog(@"%@", task.currentRequest.URL.absoluteString);
        !completionHandler?:completionHandler(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //NSLog(@"%@", task.currentRequest.URL.absoluteString);
        //NSLog(@"%@", error);
        !completionHandler ?: completionHandler(nil, error);
    }];

}
/*
 多数据类型
 */
+ (id)POSTImage:(NSString *)path parameters:(NSDictionary *)parameters completionHandler:(void (^)(id, NSError *))completionHandler{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", @"text/json", @"text/javascript", @"text/plain",@"application/x-www-form-urlencoded", nil];
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 15.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    return [manager POST:path parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", task.currentRequest.URL.absoluteString);
        !completionHandler?:completionHandler(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", task.currentRequest.URL.absoluteString);
        NSLog(@"%@", error);
        !completionHandler ?: completionHandler(nil, error);
    }];
    
}

+ (id)POSTJson:(NSString *)path parameters:(NSDictionary *)parameters completionHandler:(void (^)(id, NSError *))completionHandler{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", @"text/json", @"text/javascript", @"text/plain",@"application/x-www-form-urlencoded", nil];
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 15.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    return [manager POST:path parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", task.currentRequest.URL.absoluteString);
        !completionHandler?:completionHandler(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", task.currentRequest.URL.absoluteString);
        NSLog(@"%@", error);
        !completionHandler ?: completionHandler(nil, error);
    }];
    
}

@end











