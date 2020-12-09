//
//  JavascriptWebViewController.h
//  pocketEOS
//
//  Created by oraclechain on 2018/1/18.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKWebViewJavascriptBridge.h"
@interface JavascriptWebViewController : UIViewController
@property (nonatomic,strong)WKWebViewJavascriptBridge* bridge;
//************************************************
- (void)EOStransaction:(id)sender callback: (void (^)(id response))callback;






//************************************************


//生成私钥active privateKeyGen
- (void)activePrivateKeyGen:(NSString *)tid callback: (void (^)(id response))callback;
//生成私钥owner privateKeyGen
- (void)ownerPrivateKeyGen:(NSString *)tid callback: (void (^)(id response))callback;
//根据私钥生成公钥privateToPublic
- (void)privateToPublic:(NSString *)tid andPriv_key:(NSString *)priv_key  callback: (void (^)(id response))callback;
//验证私钥格式isValidPrivate
- (void)isValidPrivate:(NSString *)tid andPriv_key:(NSString *)priv_key  callback: (void (^)(id response))callback;
//验证公钥格式isValidPublic
- (void)isValidPublic:(NSString *)tid andPub_key:(NSString *)pub_key  callback: (void (^)(id response))callback;
//签名sign
- (void)sign:(NSString *)tid andData:(id)data andPriv_key:(NSString *)priv_key  callback: (void (^)(id response))callback;
//验证签名verify
- (void)verify:(NSString *)tid andSign:(NSString *)sign andData:(id)data andPub_key:(NSString *)pub_key  callback: (void (^)(id response))callback;
//SHA256
- (void)sha256:(NSString *)tid andData:(id)data callback: (void (^)(id response))callback;
@end
