//
//  BaseNetworking.h
//  TRProject
//

//

#import <Foundation/Foundation.h>

@interface BaseNetworking : NSObject
//带请求头**********************************************
+ (id)GETSetHeader:(NSString *)path parameters:(NSDictionary *)parameters completionHandler:(void (^)(id, NSError *))completionHandler;
/*
 json
 */
+ (id)POSTSetHeader:(NSString *)path parameters:(NSDictionary *)parameters completionHandler:(void (^)(id, NSError *))completionHandler;
/*
 多数据类型
 */
+ (id)POSTSetHeaderImage:(NSString *)path parameters:(NSDictionary *)parameters completionHandler:(void (^)(id, NSError *))completionHandler;

/* 上传文件 人脸识别*/
+(id)POSTFileSetHeader:(NSString *)path parameters:(NSDictionary *)parameters completionHandler:(void (^)(id, NSError *))completionHandler;

//不带请求头**********************************************
+ (id)GET:(NSString *)path parameters:(NSDictionary *)parameters completionHandler:(void(^)(id repsonseObj, NSError *error))completionHandler;

+ (id)POST:(NSString *)path parameters:(NSDictionary *)parameters completionHandler:(void(^)(id repsonseObj, NSError *error))completionHandler;

+ (id)POSTImage:(NSString *)path parameters:(NSDictionary *)parameters completionHandler:(void (^)(id, NSError *))completionHandler;
+ (id)POSTJson:(NSString *)path parameters:(NSDictionary *)parameters completionHandler:(void (^)(id, NSError *))completionHandler;
@end













