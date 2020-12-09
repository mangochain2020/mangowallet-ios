//
//  JavascriptWebViewController.m
//  pocketEOS
//
//  Created by oraclechain on 2018/1/18.
//  Copyright © 2018年 oraclechain. All rights reserved.
//

#import "JavascriptWebViewController.h"

#import "QuoteLocalHtmlTool.h"
@interface JavascriptWebViewController ()

@property(nonatomic, strong) WKWebView *webView;

@end

@implementation JavascriptWebViewController

- (WKWebView *)webView{
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame: CGRectZero ];
    }
    return _webView;
}
// 隐藏自带的导航栏
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //隐藏默认的navigationBar
    [self.navigationController.navigationBar setHidden: YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //显示默认的navigationBar
    [self.navigationController.navigationBar setHidden: NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.webView];
    [self initWebViewConfig];
    [WKWebViewJavascriptBridge enableLogging];
}

-(void)initWebViewConfig{
    [WKWebViewJavascriptBridge enableLogging];
    self.bridge = [WKWebViewJavascriptBridge bridgeForWebView:self.webView];
    [self.bridge setWebViewDelegate:self];
    
    //调用逻辑
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Javascript" ofType:@"html"];
    if(path){
        if (@available(iOS 9.0, *)) {
            NSURL *fileURL = [NSURL fileURLWithPath:path];
            [self.webView loadFileURL:fileURL allowingReadAccessToURL:fileURL];
        }
    }
    // 注册 js 的方法 testObjcCallback
    [_bridge registerHandler:@"testObjcCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"testObjcCallback called: %@", data);
        responseCallback(@"Response from testObjcCallback");
    }];
}


- (void)btnDidClick:(UIButton *)sender{
   
}
//******************************************************************

//EOStransaction
    
- (void)EOStransaction:(id)sender callback: (void (^)(id response))callback{
       
        [self.bridge callHandler:@"EOStransaction" data:@"01939394734394839abd" responseCallback:^(id response) {
            NSLog(@"EOStransaction: %@", response);
            
        }];
    }
    
    
    
    
//******************************************************************





- (void)callHandler:(id)sender {
    id data = @{ @"greetingFromObjC": @"Hi there, JS!" };
    [self.bridge callHandler:@"testJavascriptHandler" data:data responseCallback:^(id response) {
        NSLog(@"testJavascriptHandler responded: %@", response);
        
    }];
}
//生成私钥privateKeyGen
- (void)ownerPrivateKeyGen:(NSString *)tid callback: (void (^)(id response))callback{
    [self.bridge callHandler:@"owner_privateKeyGen" data:tid responseCallback:^(id responseData) {
        callback(responseData);
    }];
}
//生成私钥privateKeyGen
- (void)activePrivateKeyGen:(NSString *)tid callback: (void (^)(id response))callback{
    [self.bridge callHandler:@"active_privateKeyGen" data:tid responseCallback:^(id responseData) {
        callback(responseData);
    }];
}
//根据私钥生成公钥privateToPublic
- (void)privateToPublic:(NSString *)tid andPriv_key:(NSString *)priv_key  callback: (void (^)(id response))callback{
    id params = @{ @"tid": @"privateToPublic", @"priv_key" : priv_key };
    [self.bridge callHandler:@"privateToPublic" data:params responseCallback:^(id responseData) {
        callback(responseData);
       // NSLog(NSLocalizedString(NSLocalizedString(@"oc请求js后接受的回调结果：%@", nil), nil),responseData);
    }];
}
//验证私钥格式isValidPrivate
- (void)isValidPrivate:(NSString *)tid andPriv_key:(NSString *)priv_key  callback: (void (^)(id response))callback{
    id params = @{ @"tid": tid, @"priv_key" : priv_key };
    [self.bridge callHandler:@"isValidPrivate" data:params responseCallback:^(id responseData) {
        callback(responseData);
        //NSLog(NSLocalizedString(NSLocalizedString(@"oc请求js后接受的回调结果：%@", nil), nil),responseData);
    }];
}
//验证公钥格式isValidPublic
- (void)isValidPublic:(NSString *)tid andPub_key:(NSString *)pub_key  callback: (void (^)(id response))callback{
    id params = @{ @"tid": tid, @"pub_key" : pub_key };
    [self.bridge callHandler:@"isValidPublic" data:params responseCallback:^(id responseData) {
        callback(responseData);
    }];
}
//签名sign
- (void)sign:(NSString *)tid andData:(id)data andPriv_key:(NSString *)priv_key  callback: (void (^)(id response))callback{
    id params = @{ @"tid": tid, @"sign_data" : data , @"priv_key" : priv_key };
    [self.bridge callHandler:@"sign" data:params responseCallback:^(id responseData) {
        callback(responseData);
    }];
}
//验证签名verify
- (void)verify:(NSString *)tid andSign:(NSString *)sign andData:(id)data andPub_key:(NSString *)pub_key  callback: (void (^)(id response))callback{
    id params = @{ @"tid": tid, @"sign" : sign , @"verify_data" : data,  @"pub_key" : pub_key };
    [self.bridge callHandler:@"verify" data:params responseCallback:^(id responseData) {
        callback(responseData);
    }];
}
//SHA256
- (void)sha256:(NSString *)tid andData:(id)data callback: (void (^)(id response))callback{
    id params = @{ @"tid": tid, @"sha256_data" : data  };
    [self.bridge callHandler:@"sha256" data:params responseCallback:^(id responseData) {
//        NSLog(NSLocalizedString(NSLocalizedString(@"oc请求js后接受的回调结果：%@", nil), nil),responseData);
    }];
}
@end
