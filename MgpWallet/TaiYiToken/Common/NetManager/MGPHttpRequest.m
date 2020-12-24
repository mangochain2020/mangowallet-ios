//
//  MGPHttpRequest.m
//  TaiYiToken
//
//  Created by mac on 2020/7/22.
//  Copyright © 2020 admin. All rights reserved.
//

#import "MGPHttpRequest.h"
#import "RSAEncryptor.h"

#define publicKeyStr @""


@implementation MGPHttpRequest
static MGPHttpRequest * defualt_shareMananger = nil;


+ (instancetype)shareManager {
    //_dispatch_once(&onceToken, ^{
    if (defualt_shareMananger == nil) {
        defualt_shareMananger = [[self alloc] init];
    }
   // });
    return defualt_shareMananger;
}

- (void)test:(NSString *)path paramters:(NSDictionary *)paramters{
     
}
/**
 拼接字典数据

 @param parameters 参数1
 @return 拼接后的字符串
 */
-(NSString *)parameters:(NSDictionary *)parameters
{
    //创建可变字符串来承载拼接后的参数
    NSMutableString *parameterString = [NSMutableString new];
    //获取parameters中所有的key
    NSArray *parameterArray = parameters.allKeys;
    for (int i = 0;i < parameterArray.count;i++) {
    //根据key取出所有的value
        id value = parameters[parameterArray[i]];
    //把parameters的key 和 value进行拼接
        NSString *keyValue = [NSString stringWithFormat:@"%@=%@",parameterArray[i],value];
        if (i == parameterArray.count || i == 0) {
        //如果当前参数是最后或者第一个参数就直接拼接到字符串后面，因为第一个参数和最后一个参数不需要加 “&”符号来标识拼接的参数
            [parameterString appendString:keyValue];
        }else
        {
        //拼接参数， &表示与前面的参数拼接
            [parameterString appendString:[NSString stringWithFormat:@"&%@",keyValue]];
        }
    }
    return parameterString;
}
/*
 加密
 */
- (NSString *)paranEncryptString:(NSString *)paran{
    NSString *restult = [RSAEncryptor encryptString:paran publicKey:publicKeyStr];
    return restult;
}
/*
解密
*/
- (NSString *)paranDecryptString:(NSString *)paran{
    NSString *restult = [RSAEncryptor decryptString:paran publicKey:publicKeyStr];
    return restult;
}



- (void)post:(NSString *)path paramters:(NSDictionary *)paramters completionHandler:(void (^)(id responseObj, NSError *error))handler{
    
//POST请求
    NSString *paths = [NSString stringWithFormat:@"%@%@",[[DomainConfigManager share]getCurrentEvnDict][kserveApi],path];
    
    if ([path isEqualToString:@"/voteNode/uploadNodeMsg"] || [path isEqualToString:@"/voteNode/nodeDetail"]|| [path isEqualToString:@"/voteNode/rule"] || [path isEqualToString:@"/voteNode/scNodeList"] || [path isEqualToString:@"/voteNode/votes"]) {
        paths = [NSString stringWithFormat:@"http://vote.mgpchain.io/api%@",path];
//        paths = [NSString stringWithFormat:@"http://192.168.31.50:9000/api%@",path];
    }
    
    NSString *p = @"";
    if (paramters != nil) {
        p = [self convertToJsonData:paramters];
    }
    NSString *restult = [self paranEncryptString:p];
    
   //请求地址
    NSURL *url = [NSURL URLWithString:paths];
    
    //设置请求地址
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //设置请求方式
    request.HTTPMethod = @"POST";
    
    //设置请求参数
    NSString *currentSelected = [[NSUserDefaults standardUserDefaults]objectForKey:@"CurrentLanguageSelected"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:paramters];
    [dic setValue:currentSelected forKey:@"lang"];
    
    request.HTTPBody = [[self parameters:dic] dataUsingEncoding:NSUTF8StringEncoding];
  //关于parameters是NSDictionary拼接后的NSString.关于拼接看后面拼接方法说明
    

    [request setValue:restult forHTTPHeaderField:@"content"];
    [request setValue:@"mangowalletnew" forHTTPHeaderField:@"apkName"];
    [request setValue:APP_BUILD forHTTPHeaderField:@"version"];
    [request setValue:@"ios" forHTTPHeaderField:@"appType"];
    [request setValue:[[[NSBundle mainBundle]bundleIdentifier] isEqualToString:@"com.lohas.mgpMangowallet"]?@"0":@"1" forHTTPHeaderField:@"iosStore"];
    [request setValue:currentSelected forHTTPHeaderField:@"lang"];
    [request setValue:[MGPHttpRequest shareManager].curretWallet.address forHTTPHeaderField:@"address"];
    [request setValue:[MGPHttpRequest shareManager].curretWallet.publicKey forHTTPHeaderField:@"publicKey"];
    [request setValue:[[UIDevice currentDevice] identifierForVendor].UUIDString forHTTPHeaderField:@"uuid"];

    NSLog(@"加密%@----%@",dic,paths);

    
    
    //设置请求session
    NSURLSession *session = [NSURLSession sharedSession];
    
    //设置网络请求的返回接收器
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                !handler ?:handler(nil,error);
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].windows lastObject] animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = @"HTTP Code = failure";
                int64_t delayInSeconds = 1.0;      // 延迟的时间
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].windows lastObject] animated:YES];
                });
                
                NSLog(@"数据接收失败:%@",error);
            }else
            {
                NSDictionary *responseDic = data.jsonValueDecoded;
                !handler ?:handler(responseDic,nil);

                NSLog(@"%@:数据接收成功:%@----",paths,responseDic);
                if ([responseDic[@"code"] intValue] != 0) {
                    
                    [[self jsd_findVisibleViewController].view showMsg:responseDic[@"msg"]];
                    
                }
                
            }
        });
    }];
//开始请求
    [dataTask resume];
}


- (NSString *)arrayToJSONString:(NSArray *)array{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingSortedKeys error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}



-(NSString *)convertToJsonData:(NSDictionary *)dict
{

    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];

    NSString *jsonString;

    if (!jsonData) {

        NSLog(@"%@",error);

    }else{

        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];

    }

    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];

    NSRange range = {0,jsonString.length};

    //去掉字符串中的空格

    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];

    NSRange range2 = {0,mutStr.length};

    //去掉字符串中的换行符

    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];

    return mutStr;

}


//传图片流
- (void)post:(NSString *)path andImages:(NSArray *)postImageArr completionHandler:(void (^)(id responseObj, NSError *error))handler{
    
    NSString *paths = [NSString stringWithFormat:@"%@%@",[[DomainConfigManager share]getCurrentEvnDict][kserveApi],path];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:paths parameters:nil headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        // 上传 多张图片
        for(NSInteger i = 0; i < postImageArr.count; i++) {

            NSData * imageData = UIImageJPEGRepresentation([postImageArr objectAtIndex: i], 0.5);
            // 上传的参数名
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
            [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpeg"];
            
            NSLog(@"%@------fileName",fileName);

        }
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"完成 %@", result);
        if ([HTTPRequestManager validateResponseData:responseObject HttpURLResponse:task.response]) {
            NSDictionary *responseDic = ((NSData *)responseObject).jsonValueDecoded;
            !handler ?:handler(responseDic,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"错误 %@", error.localizedDescription);
        !handler ?:handler(nil,error);

    }];
  
 }


/**
 获取当前控制器
 */
- (UIViewController *)jsd_findVisibleViewController {
    
    UIViewController* currentViewController = [self jsd_getRootViewController];

    BOOL runLoopFind = YES;
    while (runLoopFind) {
        if (currentViewController.presentedViewController) {
            currentViewController = currentViewController.presentedViewController;
        } else {
            if ([currentViewController isKindOfClass:[UINavigationController class]]) {
                currentViewController = ((UINavigationController *)currentViewController).visibleViewController;
            } else if ([currentViewController isKindOfClass:[UITabBarController class]]) {
                currentViewController = ((UITabBarController* )currentViewController).selectedViewController;
            } else {
                break;
            }
        }
    }
    
    return currentViewController;
}
- (UIViewController *)jsd_getRootViewController{

    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
    return window.rootViewController;
}




@end
