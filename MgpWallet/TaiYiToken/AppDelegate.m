//
//  AppDelegate.m
//  TaiYiToken
//
//  Created by Frued on 2018/8/13.
//  Copyright © 2018年 Frued. All rights reserved.
//

#import "AppDelegate.h"
#import "CustomizedTabBarController.h"
#import "LaunchIntroductionView.h"
#import "NTVLocalized.h"
#import "CYLMainRootViewController.h"
#import "LoginVC.h"
#import "IQKeyboardManager.h"
#import "DCAppVersionTool.h"
#import "DCNewFeatureViewController.h"
#import "CreateAccountVC.h"
#import "SELUpdateAlert.h"
#import "YXPopADView.h"
#import "LHWalletManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
 
    
    
    [FIRApp configure];
    
    
    //打开crash友好处理
    [NSObject openAllSafeProtectorWithIsDebug:NO block:^(NSException *exception, LSSafeProtectorCrashType crashType) {
        NSLog(@"LSSafeProtectorCrash :%@,%lu",exception.userInfo,(unsigned long)crashType);
    }];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [[LHWalletManager sharedManger]databaseMigration:16];
    //启动图延迟
   // [NSThread sleepForTimeInterval:2.0];
    [[NTVLocalized sharedInstance] initLanguage];
    NSString *currentSelected = [[NSUserDefaults standardUserDefaults]objectForKey:@"CurrentLanguageSelected"];
    NSString *currency;
    BOOL isEnglish;
    if ([currentSelected isEqualToString:@"en_US"]) {
        isEnglish = YES;
        [[NSUserDefaults standardUserDefaults] setObject:@"en_US" forKey:@"CurrentLanguageSelected"];
        currency = @"dollar";
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NTVLocalized sharedInstance] setLanguage:@"en"];//zh-Hans
    }else if ([currentSelected isEqualToString:@"zh_CN"]){
        isEnglish = NO;
        [[NSUserDefaults standardUserDefaults] setObject:@"zh_CN" forKey:@"CurrentLanguageSelected"];
        currency = @"rmb";
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NTVLocalized sharedInstance] setLanguage:@"zh-Hans"];//zh-Hans
    }else{//没设置过语言 按系统的语言
        NSString *currentLanguage = [[[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0] copy];
        if (![currentLanguage containsString:@"zh"]) {
            isEnglish = YES;
            [[NSUserDefaults standardUserDefaults] setObject:@"en_US" forKey:@"CurrentLanguageSelected"];
            currency = @"dollar";
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[NTVLocalized sharedInstance] setLanguage:@"en"];//zh-Hans
        }else{
            isEnglish = NO;
            [[NSUserDefaults standardUserDefaults] setObject:@"zh_CN" forKey:@"CurrentLanguageSelected"];
            currency = @"rmb";
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[NTVLocalized sharedInstance] setLanguage:@"zh-Hans"];//zh-Hans
        }
    }

    NSString *currentCurrency = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentCurrencySelected"];
    if ([currentCurrency isEqualToString:@"dollar"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"dollar" forKey:@"CurrentCurrencySelected"];
    }else if([currentCurrency isEqualToString:@"rmb"]){
        [[NSUserDefaults standardUserDefaults] setObject:@"rmb" forKey:@"CurrentCurrencySelected"];
    }else{
       [[NSUserDefaults standardUserDefaults] setObject:currency forKey:@"CurrentCurrencySelected"];
    }

    if (![CreateAll GetCurrentCurrency]) {
        LHCurrencyModel *selectModel = [LHCurrencyModel new];
        selectModel.name = @"美元";
        selectModel.price = @"1.0";
        selectModel.symbol = @"$";
        selectModel.symbolName = @"USD";
        [CreateAll SaveCurrentCurrency:selectModel];
    }

    //YES 跌红涨绿 NO 涨红跌绿
    BOOL colorConfig = [[NSUserDefaults standardUserDefaults] boolForKey:@"RiseColorConfig"];
    if(colorConfig != YES){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"RiseColorConfig"];
    }else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"RiseColorConfig"];
    }

    NSString *mysymbol = [[NSUserDefaults standardUserDefaults] objectForKey:@"MySymbol"];
    if ([mysymbol isEqual:[NSNull null]] || mysymbol == nil) {
        mysymbol = @"BTC,ETH,EOS,";
        [[NSUserDefaults standardUserDefaults] setObject:mysymbol forKey:@"MySymbol"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }




    [[MGPHttpRequest shareManager]post:@"/api/appVersion/check" paramters:nil completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {

        if ([responseObj[@"code"]intValue] == 0) {
            if ([APP_BUILD intValue] < [[responseObj[@"data"]objectForKey:@"versionNum"]intValue]) {
                
                [SELUpdateAlert showUpdateAlertWithVersion:[responseObj[@"data"]objectForKey:@"versionCode"] Description:[responseObj[@"data"]objectForKey:@"msg"] andDownUrl:[responseObj[@"data"]objectForKey:@"download"]];
            }
        }


    }];


    /*
    [NetManager SysInitCompletionHandler:^(id responseObj, NSError *error) {
        if (!error) {
            if ([[NSString stringWithFormat:@"%@",responseObj[@"resultCode"]] isEqualToString:@"20000"]) {
                NSDictionary *dic;
                dic = responseObj[@"data"];
                SystemInitModel *model = [SystemInitModel parse:dic];
                if(model){
                    [CreateAll SaveSystemData:model];
                }
            }
        }else{

        }
    }];

    NSArray *arr0 = @[@"201809e1",@"201809e2",@"201809e3"];
    NSArray *arr1 = @[@"201809y1",@"201809y2",@"201809y3"];
    NSString *currentLanguage = [[[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0] copy];

    LaunchIntroductionView *launch = [LaunchIntroductionView sharedWithImages:[currentLanguage isEqualToString:@"en"]?arr0:arr1];
    launch.currentColor = [UIColor backBlueColorA];
    launch.nomalColor = [UIColor textLightGrayColor];
    */


    [self setUpRootVC];
    //查找之后发现苹果在ios7之后提供了一个新的通知类型：UIApplicationUserDidTakeScreenshotNotification，这个通知会告知注册了此通知的对象已经发生了截屏事件，然后我们就可以在这个事件中实现自己的逻辑。
    //开发者需要显式的调用此函数，日志系统才能工作
//    [UMCommonLogManager setUpUMCommonLogManager];
//    [UMConfigure setLogEnabled:NO];//设置打开日志
//    [UMConfigure setEncryptEnabled:YES];//打开加密传输
//    [UMConfigure initWithAppkey:@"5f6029baa4ae0a7f7d0529b2" channel:@"App Store"];
    /*
    [ShareSDK authorize:SSDKPlatformTypeWechat
                         settings:nil
                onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {

            switch (state) {
                 case SSDKResponseStateSuccess:
                          NSLog(@"%@",[user.credential rawData]);
                          break;
                 case SSDKResponseStateFail:
                      {
                           NSLog(@"--%@",error.description);
                           //失败
                           break;
                      }
                case SSDKResponseStateCancel:
                           //用户取消授权
                           break;

                default:
                    break;
            }
    }];

    [ShareSDK registPlatforms:^(SSDKRegister *platformsRegister) {
                     //QQ
                     [platformsRegister setupQQWithAppId:@"100371282" appkey:@"aed9b0303e3ed1e27bae87c33761161d" enableUniversalLink:YES universalLink:@"https://ybpre.share2dlink.com/"];

                       //更新到4.3.3或者以上版本，微信初始化需要使用以下初始化
                     [platformsRegister setupWeChatWithAppId:@"wx617c77c82218ea2c" appSecret:@"c7253e5289986cf4c4c74d1ccc185fb1" universalLink:@"https://ybpre.share2dlink.com/"];


                     //新浪
                     [platformsRegister setupSinaWeiboWithAppkey:@"568898243" appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3" redirectUrl:@"http://www.sharesdk.cn"];



    }];*/


    [self.window makeKeyAndVisible];
    return YES;
}
 

#pragma mark - 根控制器
- (void)setUpRootVC
{
    
    //设置导航栏返回按钮的图片
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, 0)forBarMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor clearColor]}forState:UIControlStateNormal];//将title 文字的颜色改为透明

    if (@available(iOS 11.0, *)) {// 如果iOS 11走else的代码，系统自己的文字和箭头会出来

        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-200, 0) forBarMetrics:UIBarMetricsDefault];

        UIImage *backButtonImage = [[UIImage imageNamed:@"left_arrow"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

        [UINavigationBar appearance].backIndicatorImage = backButtonImage;

        [UINavigationBar appearance].backIndicatorTransitionMaskImage =backButtonImage;
        [[UINavigationBar appearance] setTranslucent:NO];

    }else
    {

        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-200, 0) forBarMetrics:UIBarMetricsDefault];

        UIImage *image = [[UIImage imageNamed:@"left_arrow"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];

        [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(0, image.size.width, 0, 0)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];

        [[UINavigationBar appearance] setTranslucent:NO];
    }
    
    if ([BIULD_VERSION isEqualToString:[DCAppVersionTool dc_GetLastOneAppVersion]]) {
        //判断是否当前版本号等于上一次储存版本号
        if ([CreateAll GetWalletNameArray].count <= 0) {
            UIViewController *vc = [[CYLBaseNavigationController alloc]
            initWithRootViewController:[[CreateAccountVC alloc] init]];
            self.window.rootViewController = vc;

            
            
        }else{
            CYLMainRootViewController *csVC = [[CYLMainRootViewController alloc] init];
            self.window.rootViewController = csVC;
        }
        
    }else{
        
        [DCAppVersionTool dc_SaveNewAppVersion:BIULD_VERSION]; //储存当前版本号

        // 设置窗口的根控制器
        DCNewFeatureViewController *dcFVc = [[DCNewFeatureViewController alloc] init];
        [dcFVc setUpFeatureAttribute:^(NSArray *__autoreleasing *imageArray, UIColor *__autoreleasing *selColor, BOOL *showSkip, BOOL *showPageCount) {
            
            *imageArray = @[@"guide_page_1",@"guide_page_2",@"guide_page_3"];
            *showPageCount = YES;
            *showSkip = YES;
        }];
        self.window.rootViewController = dcFVc;
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{

    NSLog(@"\n ===> 程序暂行 !");
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

     NSLog(@"\n ===> 程序进入后台 !");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{

     NSLog(@"\n ===> 程序进入前台 !");
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"\n ===> 程序重新激活 !");

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"\n ===> 程序意外暂行 !");

}

@end
