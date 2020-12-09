//
//  NetManager.m
//  TRProject


#import "NetManager.h"
//usdt https://api.omniexplorer.info/#request-v1-properties-list
#define USDT_Node_URL @"https://api.omniexplorer.info"
#define USDT_Addr @"/v1/address/addr/"
#define USDT_MultiAddr @"/v2/address/addr/"
#define USDT_Addr_Details @"/v1/address/addr/details/"
#define USDT_Addr_Decode @"/v1/decode/"
#define USDT_TxList @"/v1/transaction/address"
#define USDT_PushTx @"/v1/transaction/pushtx/"
#define USDT_Txdetail @"/v1/transaction/tx/"


//#define BASE_URL @"http://159.138.5.245:8080/mission-wallet"
#define BTC_GETUTXO_URL @"/addrs/"
#define BTC_GETBalance_URL @"/addr/"
#define BTC_GETTXList_URL @"/txs"
#define BTC_GETCurrency_URL @"/currency"
#define BTC_GETTXDetail_URL @"/tx/"
#define BTC_BroadcastTransaction_URL @"/tx/send"

//BTC testnet

#define BTC_GETUTXO_URL_TESTNET @"https://test-insight.bitpay.com/api/addrs/"
#define BTC_GETBalance_URL_TESTNET @"https://test-insight.bitpay.com/api/addr/"
#define BTC_GETTXList_URL_TESTNET @"https://test-insight.bitpay.com/api/txs/"
#define BTC_GETCurrency_URL_TESTNET @"https://test-insight.bitpay.com/api/currency"
#define BTC_GETTXDetail_URL_TESTNET @"https://test-insight.bitpay.com/api/tx/"
#define BTC_BroadcastTransaction_URL_TESTNET @"https://test-insight.bitpay.com/api/tx/send"
/*
 *****************************************  行情  *******************************
 */
//获取行情列表 mySymbol自选交易对，没有填空
//http://159.138.7.23:8080/mission-wallet/getMarketTickers?mySymbol=ETH/BTC,ETH/USDT
//获取交易对详情
//http://159.138.7.23:8080/mission-wallet/getSymbolInfo?searchSymbol=EOS/ETH&kLineType=1&searchNum=500
//获取全部币种的接口
//http://192.168.1.27:8080/wallet_manager/currencyList
//************ 新接口  ****************
#define SMSSEND_BASEURL @"http://122.112.203.124:8081/chainmarket/api"
#define MISBASEURL @"http://122.112.203.124:8088/missuser/api"
#define NewsBaseURL @"http://122.112.203.124:8081/serve/api"
//test
#define NEW_BASE_URLV2 @"http://159.138.5.245:8088/market/api"
#define LIST_BASE_URLV2 @"http://122.112.203.124:8088/market/api"
//#define NEW_BASE_URL @"http://159.138.5.245:8080/market/api"

//http://159.138.5.245:8080/market/api/market/**********
//用户操作
#define USER_REGISTER @"/user/register"
#define USER_LOGIN @"/user/login"
#define USER_SENDVERIFYCODE @"/user/sendVerifyCode"
#define USER_BINDMOBILE @"/user/bindMobile"
#define USER_BINDMAIL @"/user/bindMail"
#define USER_RESETPASS @"/user/resetPass"
#define USER_MODIFYPASS @"/user/modifyPass"
#define USER_GETUSER @"/user/getUser"
#define FACE_COMPARE @"/face/compare"
#define FACE_COMPAREFILE @"/face/compareFile"
#define DATA_STA @"/trade/addTrade"
#define ACCLOG_STA @"/trade/addAccountLog"
#define USER_TAG_API @"/user/tag"
//系统初始化
#define SYS_INIT @"/sys/init"

//行情
#define MARKET_GETPROFIT @"/market/getProfit"

#define MARKETLIST @"/market/list"
#define MARKETLIST_SORT @"/market/listsort"
#define MARKET_COMPREHENSIVE @"/market/comprehensive"
#define MARKET_PLATELIST @"/market/plateList"
#define MARKET_GETMISSIONRATE @"/market/getMissionRate"
#define MARKET_SYMBOLINFO @"/market/symbolInfo"

#define MARKET_BASEINFO @"/market/baseInfo"
#define MARKET_GETSYMBOL @"/market/getsymbol"
#define MARKET_GETALLCOIN @"/market/getAllCoin"
//行情二版
#define MARKET_BUSINESS @"/market/business"
#define MARKET_TICKERS @"/market/marketTickers"
#define MARKET_OPTIONAL_LIST @"/market/getOptionalList"
#define MARKET_COINBASEINFO @"/market/getCoinPriceInfo"

//创建MIS钱包
#define WALLET_CREATEACCOUNT @"/wallet/createAccount"



//资讯
#define InfoList @"/information/list"
#define InfoDetail @"/information/details"
#define InfoCollAdd @"/information/collectionAdd"
#define InfoCollDel @"/information/collectionDel"
#define InfoCollList @"/information/collectionList"
#define InfoCollDelBatch @"/information/collectionDelBatch"
@implementation NetManager

//************************************** 新接口  ******************************************
//获取时间戳
+(NSString *)getNowTimeTimestamp{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    return timeString;
}
/*
 三个基本参数（若需要）+ 请求带有的参数
 map.put("userid", "0");
 map.put("usertoken", "");
 map.put("timestamp", "1539308564622");
 dic中传入请求本身参数(包括timestamp)
 */
+(NSString *)signParams:(NSDictionary *)dic{
    NSMutableDictionary *kvdic =  [dic mutableCopy];
    NSArray *keyarr = [kvdic allKeys];
    NSMutableArray *kArrSort = [keyarr mutableCopy];
    
    //userToken
    NSString *userToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"]?[[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"]:nil;
    
    //userId
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]?[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]:nil;
    UserInfoModel *model = [CreateAll GetCurrentUser];
    userToken = model.userToken;
    userId = model.userId;
    if(userToken){
        [kArrSort addObject:@"userToken"];
        [kvdic setObject:userToken forKey:@"userToken"];
    }
    if(userId){
        [kArrSort addObject:@"userId"];
        [kvdic setObject:userId forKey:@"userId"];
    }else{
        [kArrSort addObject:@"userId"];
        [kvdic setObject:@"0" forKey:@"userId"];
    }
    
    NSArray *resultkArrSort = [kArrSort sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    NSString *resultStr = [NSString new];
    for(int index = 0;index < resultkArrSort.count; index ++){
        NSString *key =resultkArrSort[index];
        NSString *keystr = key.lowercaseString;
        NSString *value = [kvdic objectForKey:key];
        resultStr = [resultStr stringByAppendingString:[NSString stringWithFormat:@"%@%@",keystr,value]];
    }
    
    NSString *secretKey = NET_API_KEY;
    resultStr = [resultStr stringByAppendingString:secretKey];
   // NSString *result = resultStr.lowercaseString;
    NSString *md5str = resultStr.md5String;
    return md5str.uppercaseString ;
}



/*
 用户注册
 */
+(void)RegisterAccountWithLoginName:(NSString*)loginName Password:(NSString *)password PasswordConfirm:(NSString *)passwordConfirm completionHandler:(void (^)(id responseObj, NSError *error))handler{
    NSString *path = [NSString stringWithFormat:@"%@%@",MISBASEURL,USER_REGISTER];
    NSString *timestamp = [NetManager getNowTimeTimestamp];
   // NSString *sign = [NetManager signHeaderParams];
    NSString *ip = [IPAddressGet getIPAddress:YES];
    
    NSDictionary *dic = @{@"loginName":loginName == nil?@"":loginName,
                          @"password":password == nil?@"":password,
                          @"passwordConfirm":passwordConfirm == nil?@"":passwordConfirm,
                          @"clientIp":ip,
                          @"timestamp":timestamp
                          };

    NSString *sign = [NetManager signParams:dic];
    NSDictionary *params = @{@"loginName":loginName == nil?@"":loginName,
                             @"password":password == nil?@"":password,
                             @"passwordConfirm":passwordConfirm == nil?@"":passwordConfirm,
                             @"clientIp":ip,
                             @"timestamp":timestamp,
                             @"sign":sign
                             };
    
    [self POSTSetHeader:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
        if(!error){
            NSDictionary *responseDic = ((NSData *)repsonseObj).jsonValueDecoded;
            !handler ?:handler(responseDic,error);
        }else{
            NSError *err = [NSError ErrorWithTitle:@"注册失败" Code:102720];
            !handler ?:handler(nil,err);
        }
    }];
}
/*
 用户登录
 */
+(void)LoginWithLoginName:(NSString*)loginName Password:(NSString *)password completionHandler:(void (^)(id responseObj, NSError *error))handler{
    NSString *path = [NSString stringWithFormat:@"%@%@",MISBASEURL,USER_LOGIN];
    NSString *timestamp = [NetManager getNowTimeTimestamp];
    
    NSDictionary *dic = @{@"loginName":loginName == nil?@"":loginName,
                          @"password":password == nil?@"":password,
                          @"timestamp":timestamp
                          };
    
    NSString *sign = [NetManager signParams:dic];
    NSDictionary *params = @{@"loginName":loginName == nil?@"":loginName,
                             @"password":password == nil?@"":password,
                             @"timestamp":timestamp,
                             @"sign":sign
                             };
    [self POSTSetHeader:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
        if(!error){
            NSDictionary *responseDic = ((NSData *)repsonseObj).jsonValueDecoded;
            !handler ?:handler(responseDic,error);
        }else{
            NSError *err = [NSError ErrorWithTitle:@"登录失败" Code:102719];
            !handler ?:handler(nil,err);
        }
    }];
}
+ (void)GetMyOrderWithUserId:(NSString*)userId withType:(NSString*)type completionHandler:(void (^)(id responseObj, NSError *error))handler {
    NSString *path = [NSString stringWithFormat:@"/orderFormListShowBuy"];
    NSString *timestamp = [NetManager getNowTimeTimestamp];
    NSDictionary *dic = @{
                          @"userId":userId,
                          @"type": type,
                          @"timestamp":timestamp
                          };
    
    NSString *sign = [NetManager signParams:dic];
    NSDictionary *params = @{
                             @"userId":userId,
                             @"type": type,
                             @"timestamp":timestamp,
                             @"sign":sign
                             };
    
    [NetManager POSTSetHeader:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
        if(!error){
            NSDictionary *responseDic = ((NSData *)repsonseObj).jsonValueDecoded;
            !handler ?:handler(responseDic,error);
        }else{
            NSError *err = [NSError ErrorWithTitle:@"获取订单列表失败" Code:102720];
            !handler ?:handler(nil,err);
        }
    }];
}
/*
 发送验证码
 type弃用 后台判断
 safeCode :安全码，超过3次必须填写,防止短信被刷
 */
+(void)SendVerifyCodeWithType:(VerifyCodeType)type MobileORMail:(NSString *)mobileOrMail CheckDevice:(BOOL)checkDevice SafeCode:(NSString *)safeCode completionHandler:(void (^)(id responseObj, NSError *error))handler{
   
    NSString *path =  type == SMS_Code? [NSString stringWithFormat:@"%@%@",MISBASEURL,USER_SENDVERIFYCODE]:[NSString stringWithFormat:@"%@%@",MISBASEURL,USER_SENDVERIFYCODE];
    mobileOrMail = mobileOrMail == nil?@"":mobileOrMail;
    NSString *timestamp = [NetManager getNowTimeTimestamp];
    timestamp = timestamp == nil?@"":timestamp;
    NSDictionary *dic = @{@"device":mobileOrMail == nil?@"":mobileOrMail,
                          @"checkDevice":checkDevice == YES? @"1":@"0",
                          @"timestamp":timestamp
                                };
//    safeCode == nil? : [dic setObject:safeCode forKey:@"safeCode"];
    NSString *sign = [NetManager signParams:dic];
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:mobileOrMail == nil?@"":mobileOrMail forKey:@"device"];
    [params setObject:timestamp forKey:@"timestamp"];
    [params setObject:checkDevice == YES? @"1":@"0" forKey:@"checkDevice"];
//    safeCode == nil? : [params setObject:safeCode forKey:@"safeCode"];
    [params setObject:sign forKey:@"sign"];
    
    [self POSTSetHeader:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
        if(!error){
            NSDictionary *responseDic = ((NSData *)repsonseObj).jsonValueDecoded;
            !handler ?:handler(responseDic,error);
        }else{
            NSError *err = [NSError ErrorWithTitle:@"验证码发送失败" Code:102718];
            !handler ?:handler(nil,err);
        }
    }];
}
/*
 绑定手机
 */
+(void)BindMobileWithMobile:(NSString *)mobile VerifyCode:(NSString *)verifyCode completionHandler:(void (^)(id responseObj, NSError *error))handler{
    NSString *path = [NSString stringWithFormat:@"%@%@",MISBASEURL,USER_BINDMOBILE];
    NSString *timestamp = [NetManager getNowTimeTimestamp];
    NSDictionary *dic = @{@"mobile":VALIDATE_STRING(mobile),
                          @"verifyCode":VALIDATE_STRING(verifyCode),
                          @"timestamp":timestamp
                          };
    NSString *sign = [NetManager signParams:dic];
    NSDictionary *params = @{@"mobile":VALIDATE_STRING(mobile),
                             @"verifyCode":VALIDATE_STRING(verifyCode),
                             @"timestamp":timestamp,
                             @"sign":sign
                             };
    [self POSTSetHeader:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
        if(!error){
            NSDictionary *responseDic = ((NSData *)repsonseObj).jsonValueDecoded;
            !handler ?:handler(responseDic,error);
        }else{
            NSError *err = [NSError ErrorWithTitle:@"绑定手机失败" Code:102717];
            !handler ?:handler(nil,err);
        }
    }];
}

/*
 绑定邮箱
 */
+(void)BindMailWithMail:(NSString *)mail VerifyCode:(NSString *)verifyCode completionHandler:(void (^)(id responseObj, NSError *error))handler{
    NSString *path = [NSString stringWithFormat:@"%@%@",MISBASEURL,USER_BINDMAIL];
    NSString *timestamp = [NetManager getNowTimeTimestamp];
    NSDictionary *dic = @{@"mail":mail == nil?@"":mail,
                          @"verifyCode":verifyCode == nil?@"":verifyCode,
                          @"timestamp":timestamp
                          };
    NSString *sign = [NetManager signParams:dic];
    NSDictionary *params = @{@"mail":mail == nil?@"":mail,
                             @"verifyCode":verifyCode == nil?@"":verifyCode,
                             @"timestamp":timestamp,
                             @"sign":sign
                             };
    [self POSTSetHeader:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
        if(!error){
            NSDictionary *responseDic = ((NSData *)repsonseObj).jsonValueDecoded;
            !handler ?:handler(responseDic,error);
        }else{
            NSError *err = [NSError ErrorWithTitle:@"绑定邮箱失败" Code:102716];
            !handler ?:handler(nil,err);
        }
    }];
}

/*
 重置密码
 */
+(void)ResetPassWordWithPassword:(NSString *)password PasswordConfirm:(NSString *)passwordConfirm completionHandler:(void (^)(id responseObj, NSError *error))handler{
    NSString *path = [NSString stringWithFormat:@"%@%@",MISBASEURL,USER_RESETPASS];
    NSString *timestamp = [NetManager getNowTimeTimestamp];
    NSDictionary *dic = @{@"password":password == nil?@"":password,
                          @"passwordConfirm":passwordConfirm == nil?@"":passwordConfirm,
                          @"timestamp":timestamp
                          };
    NSString *sign = [NetManager signParams:dic];
    NSDictionary *params = @{@"password":password == nil?@"":password,
                             @"passwordConfirm":passwordConfirm == nil?@"":passwordConfirm,
                             @"timestamp":timestamp,
                             @"sign":sign
                             };
    [self POSTSetHeader:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
        if(!error){
            NSDictionary *responseDic = ((NSData *)repsonseObj).jsonValueDecoded;
            !handler ?:handler(responseDic,error);
        }else{
            NSError *err = [NSError ErrorWithTitle:@"重置密码失败" Code:102715];
            !handler ?:handler(nil,err);
        }
    }];
}

/*
 修改密码
 */
+(void)ModifyPassWordWithOldPassword:(NSString *)oldpassword NewPassword:(NSString *)newpassword completionHandler:(void (^)(id responseObj, NSError *error))handler{
    NSString *path = [NSString stringWithFormat:@"%@%@",MISBASEURL,USER_MODIFYPASS];
    NSString *timestamp = [NetManager getNowTimeTimestamp];
    NSDictionary *dic = @{@"oldPassword":oldpassword == nil?@"":oldpassword,
                          @"newPassword":newpassword == nil?@"":newpassword,
                          @"passwordConfirm":newpassword == nil?@"":newpassword,
                          @"timestamp":timestamp
                          };
    NSString *sign = [NetManager signParams:dic];
    NSDictionary *params = @{@"oldPassword":oldpassword == nil?@"":oldpassword,
                             @"newPassword":newpassword == nil?@"":newpassword,
                             @"passwordConfirm":newpassword == nil?@"":newpassword,
                             @"timestamp":timestamp,
                             @"sign":sign
                             };
    [self POSTSetHeader:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
        if(!error){
            NSDictionary *responseDic = ((NSData *)repsonseObj).jsonValueDecoded;
            !handler ?:handler(responseDic,error);
        }else{
            NSError *err = [NSError ErrorWithTitle:@"修改密码失败" Code:102714];
            !handler ?:handler(nil,err);
        }
    }];
}

/*
 交易数据统计
 */
+(void)AddTradeWithuserName:(NSString *)userName TradeAmount:(CGFloat)tradeAmount Poundage:(CGFloat)poundage CoinCode:(NSString *)coinCode From:(NSString *)fromToken To:(NSString *)toToken  CompletionHandler:(void (^)(id responseObj, NSError *error))handler{
    NSString *path = [NSString stringWithFormat:@"%@%@",MISBASEURL,DATA_STA];
    NSString *timestamp = [NetManager getNowTimeTimestamp];
    NSDictionary *dic = @{@"userName":VALIDATE_STRING(userName),
                          @"tradeAmount":[NSNumber numberWithDouble:tradeAmount],
                          @"poundage":[NSNumber numberWithDouble:poundage],
                          @"coinCode":VALIDATE_STRING(coinCode),
                          @"fromToken":VALIDATE_STRING(fromToken),
                          @"toToken":VALIDATE_STRING(toToken),
                          @"timestamp":timestamp
                          };
    NSString *sign = [NetManager signParams:dic];
    NSDictionary *params = @{@"userName":VALIDATE_STRING(userName),
                             @"tradeAmount":[NSNumber numberWithDouble:tradeAmount],
                             @"poundage":[NSNumber numberWithDouble:poundage],
                             @"coinCode":VALIDATE_STRING(coinCode),
                             @"fromToken":VALIDATE_STRING(fromToken),
                             @"toToken":VALIDATE_STRING(toToken),
                             @"timestamp":timestamp,
                             @"sign":sign
                             };
    [self POSTSetHeader:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
        if(!error){
            NSDictionary *responseDic = ((NSData *)repsonseObj).jsonValueDecoded;
            !handler ?:handler(responseDic,error);
        }else{
            NSError *err = [NSError ErrorWithTitle:@"交易数据统计信息上传失败" Code:102803];
            !handler ?:handler(nil,err);
        }
    }];
}

/*
 保存账号创建导入记录
 */
+(void)AddAccountLogWithuserName:(NSString *)userName AccountInfo:(NSString *)accountInfo RecordType:(ADDACCOUNT_LOG_RECORD_TYPE)recordType CompletionHandler:(void (^)(id responseObj, NSError *error))handler{
    NSString *path = [NSString stringWithFormat:@"%@%@",MISBASEURL,ACCLOG_STA];
    NSString *timestamp = [NetManager getNowTimeTimestamp];
    NSDictionary *dic = @{@"userName":VALIDATE_STRING(userName),
                          @"accountInfo":VALIDATE_STRING(accountInfo),
                          @"recordType":[NSNumber numberWithFloat:recordType],
                          @"timestamp":timestamp
                          };
    NSString *sign = [NetManager signParams:dic];
    NSDictionary *params = @{@"userName":VALIDATE_STRING(userName),
                             @"accountInfo":VALIDATE_STRING(accountInfo),
                             @"recordType":[NSNumber numberWithFloat:recordType],
                             @"timestamp":timestamp,
                             @"sign":sign
                             };
    [self POSTSetHeader:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
        if(!error){
            NSDictionary *responseDic = ((NSData *)repsonseObj).jsonValueDecoded;
            !handler ?:handler(responseDic,error);
        }else{
            NSError *err = [NSError ErrorWithTitle:@"保存账号创建导入记录失败" Code:102804];
            !handler ?:handler(nil,err);
        }
    }];
}


/*
 系统初始化
 返回 eth节点,btc节点,eos节点,mis节点
 */
+(void)SysInitCompletionHandler:(void (^)(id responseObj, NSError *error))handler{
    NSString *path = [NSString stringWithFormat:@"%@%@",MISBASEURL,SYS_INIT];
    NSString *timestamp = [NetManager getNowTimeTimestamp];
    NSDictionary *dic = @{
                          @"timestamp":timestamp
                          };
    NSString *sign = [NetManager signParams:dic];
    NSDictionary *params = @{
                             @"timestamp":timestamp,
                             @"sign":sign
                             };
    [self POSTSetHeader:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
        if(!error){
            NSDictionary *responseDic = ((NSData *)repsonseObj).jsonValueDecoded;
            !handler ?:handler(responseDic,error);
        }else{
            NSError *err = [NSError ErrorWithTitle:@"初始化信息获取失败" Code:102702];
            !handler ?:handler(nil,err);
        }
        
    }];
}

/*
 获取收益
 返回 涨跌幅 涨跌额
 */
+(void)GetProfitCompletionHandler:(void (^)(id responseObj, NSError *error))handler{
    NSString *path = [NSString stringWithFormat:@"%@%@",NEW_BASE_URLV2,MARKET_GETPROFIT];
    NSString *timestamp = [NetManager getNowTimeTimestamp];
    NSDictionary *dic = @{
                          @"timestamp":timestamp
                          };
    NSString *sign = [NetManager signParams:dic];
    NSDictionary *params = @{
                             @"timestamp":timestamp,
                             @"sign":sign
                             };
    [self POSTSetHeader:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
        if (!error) {
            NSDictionary *responseDic = ((NSData *)repsonseObj).jsonValueDecoded;
            !handler ?:handler(responseDic,error);
        }else{
            NSError *err = [NSError ErrorWithTitle:@"获取收益额失败" Code:102703];
            !handler ?:handler(nil,err);
        }
    }];
}

/*
 行情列表
 */
+(void)GetMarketListWithSearchType:(MarketSearchType)searchType MySymbol:(NSString *)mySymbol Lang:(LangeuageType)lang completionHandler:(void (^)(id responseObj, NSError *error))handler{
    NSString *path = [NSString stringWithFormat:@"%@%@",NEW_BASE_URLV2,MARKETLIST];
    NSString *unitstr = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentCurrencySelected"];
    NSString *timestamp = [NetManager getNowTimeTimestamp];
    NSDictionary *dic = @{
                          @"searchType":[NSNumber numberWithInt:searchType],
                          @"mySymbol":mySymbol == nil?@"":mySymbol,
                          @"lang":[NSNumber numberWithInt:lang],
                          @"unit":[unitstr isEqualToString:@"rmb"]?@1:@0,
                          @"timestamp":timestamp
                          };
    NSString *sign = [NetManager signParams:dic];
    NSDictionary *params = @{@"searchType":[NSNumber numberWithInt:searchType],
                             @"mySymbol":mySymbol == nil?@"":mySymbol,
                             @"lang":[NSNumber numberWithInt:lang],
                             @"unit":[unitstr isEqualToString:@"rmb"]?@1:@0,
                             @"timestamp":timestamp,
                             @"sign":sign
                             };
    [self POSTSetHeader:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
        NSDictionary *responseDic = ((NSData *)repsonseObj).jsonValueDecoded;
        !handler ?:handler(responseDic,error);
        if (!error) {
            NSDictionary *responseDic = ((NSData *)repsonseObj).jsonValueDecoded;
            !handler ?:handler(responseDic,error);
        }else{
            NSError *err = [NSError ErrorWithTitle:@"行情列表数据获取失败" Code:102701];
            !handler ?:handler(nil,err);
        }
    }];
}

/*
 排行榜
 plateId  板块Id,如果是根据板块则必填
 */
+(void)GetMarketListSortWithSortSearchType:(MarketSortSearchType)searchType PlateId:(NSString *)plateId Lang:(LangeuageType)lang completionHandler:(void (^)(id responseObj, NSError *error))handler{
    NSString *path = [NSString stringWithFormat:@"%@%@",NEW_BASE_URLV2,MARKETLIST_SORT];
    NSString *timestamp = [NetManager getNowTimeTimestamp];
    NSString *unitstr = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentCurrencySelected"];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:[unitstr isEqualToString:@"rmb"]?@"1":@"0" forKey:@"unit"];
    [dic setObject:[NSString stringWithFormat:@"%u",searchType] forKey:@"searchType"];
    [dic setObject:[NSString stringWithFormat:@"%u",lang] forKey:@"lang"];
    [dic setObject:timestamp forKey:@"timestamp"];
    plateId == nil?[dic setObject:@"0" forKey:@"plateId"] : [dic setObject:plateId forKey:@"plateId"];
    NSString *sign = [NetManager signParams:dic];
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:[unitstr isEqualToString:@"rmb"]?@1:@0 forKey:@"unit"];
    [params setObject:[NSNumber numberWithInt:searchType] forKey:@"searchType"];
    [params setObject:[NSNumber numberWithInt:lang] forKey:@"lang"];
    [params setObject:timestamp forKey:@"timestamp"];
    [params setObject:sign forKey:@"sign"];
    plateId == nil?[params setObject:@0 forKey:@"plateId"] : [params setObject:plateId forKey:@"plateId"];
    [self POSTSetHeader:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
        if (!error) {
            NSDictionary *responseDic = ((NSData *)repsonseObj).jsonValueDecoded;
            !handler ?:handler(responseDic,error);
        }else{
            NSError *err = [NSError ErrorWithTitle:@"排行榜获取失败" Code:102801];
            !handler ?:handler(nil,err);
        }
    }];
}

/*
 市值列表接口
 */
+(void)GetMarketTicketsPage:(NSInteger)pageindex PageSize:(NSInteger)pagesize Lang:(LangeuageType)lang completionHandler:(void (^)(id responseObj, NSError *error))handler{
    NSString *path = [NSString stringWithFormat:@"%@%@",LIST_BASE_URLV2,MARKET_TICKERS];
    NSString *timestamp = [NetManager getNowTimeTimestamp];
    NSString *unitstr = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentCurrencySelected"];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:[unitstr isEqualToString:@"rmb"]?@"1":@"0" forKey:@"unit"];
    [dic setObject:[NSString stringWithFormat:@"%u",lang] forKey:@"lang"];
    [dic setObject:timestamp forKey:@"timestamp"];
    [dic setObject:[NSString stringWithFormat:@"%ld",pageindex] forKey:@"pageIndex"];
    [dic setObject:[NSString stringWithFormat:@"%ld",pagesize] forKey:@"pageSize"];
    NSString *sign = [NetManager signParams:dic];
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:[unitstr isEqualToString:@"rmb"]?@1:@0 forKey:@"unit"];
    [params setObject:[NSNumber numberWithInt:lang] forKey:@"lang"];
    [params setObject:timestamp forKey:@"timestamp"];
    [params setObject:[NSNumber numberWithInteger:pageindex] forKey:@"pageIndex"];
    [params setObject:[NSNumber numberWithInteger:pagesize] forKey:@"pageSize"];
    [params setObject:sign forKey:@"sign"];
    [self POSTSetHeader:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
        if (!error) {
            NSDictionary *responseDic = ((NSData *)repsonseObj).jsonValueDecoded;
            !handler ?:handler(responseDic,error);
        }else{
            NSError *err = [NSError ErrorWithTitle:@"市值列表获取失败" Code:102801];
            !handler ?:handler(nil,err);
        }
    }];
}

/*
 自选列表接口
 */
+(void)GetOptionalListMySymbol:(NSString *)mySymbol  Lang:(LangeuageType)lang completionHandler:(void (^)(id responseObj, NSError *error))handler{
    NSString *path = [NSString stringWithFormat:@"%@%@",LIST_BASE_URLV2,MARKET_OPTIONAL_LIST];
    NSString *timestamp = [NetManager getNowTimeTimestamp];
    NSString *unitstr = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentCurrencySelected"];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:[unitstr isEqualToString:@"rmb"]?@"1":@"0" forKey:@"unit"];
    [dic setObject:[NSString stringWithFormat:@"%u",lang] forKey:@"lang"];
    [dic setObject:timestamp forKey:@"timestamp"];
    [dic setObject:VALIDATE_STRING(mySymbol) forKey:@"coinList"];

    NSString *sign = [NetManager signParams:dic];
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:[unitstr isEqualToString:@"rmb"]?@1:@0 forKey:@"unit"];
    [params setObject:[NSNumber numberWithInt:lang] forKey:@"lang"];
    [params setObject:timestamp forKey:@"timestamp"];
    [params setObject:VALIDATE_STRING(mySymbol) forKey:@"coinList"];
    [params setObject:sign forKey:@"sign"];
    [self POSTSetHeader:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
        if (!error) {
            NSDictionary *responseDic = ((NSData *)repsonseObj).jsonValueDecoded;
            !handler ?:handler(responseDic,error);
        }else{
            NSError *err = [NSError ErrorWithTitle:@"自选列表获取失败" Code:102802];
            !handler ?:handler(nil,err);
        }
    }];
}


/*
 币种详情接口
 */
+(void)GetCoinPriceInfoCoinCode:(NSString *)coinCode kLineType:(KLineType)kLineType  Lang:(LangeuageType)lang  ExchangeId:(NSInteger)exchangeid  completionHandler:(void (^)(id responseObj, NSError *error))handler{
    NSString *path = [NSString stringWithFormat:@"%@%@",NEW_BASE_URLV2,MARKET_COINBASEINFO];
    NSString *unitstr = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentCurrencySelected"];
    NSString *timestamp = [NetManager getNowTimeTimestamp];
    NSDictionary *dic = @{
                          @"coinCode":VALIDATE_STRING(coinCode),
                          @"kLineType":[NSNumber numberWithInt:kLineType],
                          @"searchNum":@200,
                          @"exchangeId":[NSNumber numberWithInteger:exchangeid],
                          @"lang":[NSNumber numberWithInt:lang],
                          @"unit":[unitstr isEqualToString:@"rmb"]?@1:@0,
                          @"timestamp":timestamp
                          };
    NSString *sign = [NetManager signParams:dic];
    NSDictionary *params = @{
                             @"coinCode":VALIDATE_STRING(coinCode),
                             @"kLineType":[NSNumber numberWithInt:kLineType],
                             @"searchNum":@200,
                             @"exchangeId":[NSNumber numberWithInteger:exchangeid],
                             @"lang":[NSNumber numberWithInt:lang],
                             @"unit":[unitstr isEqualToString:@"rmb"]?@1:@0,
                             @"timestamp":timestamp,
                             @"sign":sign
                             };
    [self POSTSetHeader:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
        if (!error) {
            NSDictionary *responseDic = ((NSData *)repsonseObj).jsonValueDecoded;
            !handler ?:handler(responseDic,error);
        }else{
            NSError *err = [NSError ErrorWithTitle:@"币种信息获取失败" Code:102708];
            !handler ?:handler(nil,err);
        }
    }];
}

/*
 综合市场
 */
+(void)GetMarketComprehensiveWithLang:(LangeuageType)lang completionHandler:(void (^)(id responseObj, NSError *error))handler{
    NSString *path = [NSString stringWithFormat:@"%@%@",NEW_BASE_URLV2,MARKET_COMPREHENSIVE];
    NSString *unitstr = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentCurrencySelected"];
    NSString *timestamp = [NetManager getNowTimeTimestamp];
    NSDictionary *dic = @{
                          @"lang":[NSNumber numberWithInt:lang],
                          @"unit":[unitstr isEqualToString:@"rmb"]?@1:@0,
                          @"timestamp":timestamp
                          };
    NSString *sign = [NetManager signParams:dic];
    NSDictionary *params = @{
                             @"lang":[NSNumber numberWithInt:lang],
                             @"unit":[unitstr isEqualToString:@"rmb"]?@1:@0,
                             @"timestamp":timestamp,
                             @"sign":sign
                             };
    [self POSTSetHeader:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
        if (!error) {
            NSDictionary *responseDic = ((NSData *)repsonseObj).jsonValueDecoded;
            !handler ?:handler(responseDic,error);
        }else{
            NSError *err = [NSError ErrorWithTitle:@"综合市场获取失败" Code:102705];
            !handler ?:handler(nil,err);
        }
    }];
}


/*
 板块列表
 */
+(void)GetPlateListCompletionHandler:(void (^)(id responseObj, NSError *error))handler{
    NSString *path = [NSString stringWithFormat:@"%@%@",NEW_BASE_URLV2,MARKET_PLATELIST];
    NSString *currentLanguage = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLanguageSelected"];
    NSString *unitstr = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentCurrencySelected"];
    NSString *timestamp = [NetManager getNowTimeTimestamp];
    NSDictionary *dic = @{
                          @"lang":[currentLanguage isEqualToString:@"english"]?@0:@1,
                          @"unit":[unitstr isEqualToString:@"rmb"]?@1:@0,
                          @"timestamp":timestamp
                          };
    NSString *sign = [NetManager signParams:dic];
    NSDictionary *params = @{
                             @"lang":[currentLanguage isEqualToString:@"english"]?@0:@1,
                             @"unit":[unitstr isEqualToString:@"rmb"]?@1:@0,
                             @"timestamp":timestamp,
                             @"sign":sign
                             };
    [self GETSetHeader:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
       // NSDictionary *responseDic = ((NSData *)repsonseObj).jsonValueDecoded;
        if (!error) {
            !handler ?:handler(repsonseObj,error);
        }else{
            NSError *err = [NSError ErrorWithTitle:@"板块列表获取失败" Code:102706];
            !handler ?:handler(nil,err);
        }
    }];
}


/*
 各种汇率
 */
+(void)GetMissionRateCompletionHandler:(void (^)(id responseObj, NSError *error))handler{
    NSString *path = [NSString stringWithFormat:@"%@%@",NEW_BASE_URLV2,MARKET_GETMISSIONRATE];
    NSString *timestamp = [NetManager getNowTimeTimestamp];
    NSDictionary *dic = @{
                          @"timestamp":timestamp
                          };
    NSString *sign = [NetManager signParams:dic];
    NSDictionary *params = @{
                             @"timestamp":timestamp,
                             @"sign":sign
                             };
    [self POSTSetHeader:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
        if (!error) {
            NSDictionary *responseDic = ((NSData *)repsonseObj).jsonValueDecoded;
            !handler ?:handler(responseDic,error);
        }else{
            NSError *err = [NSError ErrorWithTitle:@"汇率获取失败" Code:102707];
            !handler ?:handler(nil,err);
        }
    }];
}

/*
 币种信息
 */
+(void)GetSymbolInfoWithSearchSymbol:(NSString *)searchSymbol kLineType:(KLineType)kLineType Lang:(LangeuageType)lang completionHandler:(void (^)(id responseObj, NSError *error))handler{
    NSString *path = [NSString stringWithFormat:@"%@%@",NEW_BASE_URLV2,MARKET_SYMBOLINFO];
    NSString *unitstr = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentCurrencySelected"];
    NSString *timestamp = [NetManager getNowTimeTimestamp];
    NSDictionary *dic = @{
                          @"searchSymbol":searchSymbol == nil?@"":searchSymbol,
                          @"kLineType":[NSNumber numberWithInt:kLineType],
                          @"lang":[NSNumber numberWithInt:lang],
                          @"unit":[unitstr isEqualToString:@"rmb"]?@1:@0,
                          @"timestamp":timestamp
                          };
    NSString *sign = [NetManager signParams:dic];
    NSDictionary *params = @{
                             @"searchSymbol":searchSymbol == nil?@"":searchSymbol,
                             @"kLineType":[NSNumber numberWithInt:kLineType],
                             @"lang":[NSNumber numberWithInt:lang],
                             @"unit":[unitstr isEqualToString:@"rmb"]?@1:@0,
                             @"timestamp":timestamp,
                             @"sign":sign
                             };
    [self POSTSetHeader:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
        if (!error) {
            NSDictionary *responseDic = ((NSData *)repsonseObj).jsonValueDecoded;
            !handler ?:handler(responseDic,error);
        }else{
            NSError *err = [NSError ErrorWithTitle:@"币种信息获取失败" Code:102708];
            !handler ?:handler(nil,err);
        }
    }];
}

/*
 委买委卖列表
 */
+(void)GetBusinessWithMySymbol:(NSString *)mySymbol Lang:(LangeuageType)lang ExchangeId:(NSInteger)exchangeid completionHandler:(void (^)(id responseObj, NSError *error))handler{
    NSString *path = [NSString stringWithFormat:@"%@%@",NEW_BASE_URLV2,MARKET_BUSINESS];
    NSString *unitstr = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentCurrencySelected"];
    NSString *timestamp = [NetManager getNowTimeTimestamp];
    NSDictionary *dic = @{
                          @"mySymbol":mySymbol == nil?@"":mySymbol,
                          @"lang":[NSNumber numberWithInteger:lang],
                          @"unit":[unitstr isEqualToString:@"rmb"]?@1:@0,
                          @"timestamp":timestamp
                          };
    NSString *sign = [NetManager signParams:dic];
    NSDictionary *params = @{
                             @"mySymbol":mySymbol == nil?@"":mySymbol,
                             @"lang":[NSNumber numberWithInteger:lang],
                             @"unit":[unitstr isEqualToString:@"rmb"]?@1:@0,
                             @"timestamp":timestamp,
                             @"sign":sign
                             };
    [self POSTSetHeader:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
        if (!error) {
            NSDictionary *responseDic = ((NSData *)repsonseObj).jsonValueDecoded;
            !handler ?:handler(responseDic,error);
        }else{
            NSError *err = [NSError ErrorWithTitle:@"委买委卖列表获取失败" Code:102709];
            !handler ?:handler(nil,err);
        }
    }];
}

/*
 项目介绍
 */
+(void)GetMarketBaseInfoWithMySymbol:(NSString *)mySymbol Lang:(LangeuageType)lang completionHandler:(void (^)(id responseObj, NSError *error))handler{
    NSString *path = [NSString stringWithFormat:@"%@%@",NEW_BASE_URLV2,MARKET_BASEINFO];
    NSString *unitstr = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentCurrencySelected"];
    NSString *timestamp = [NetManager getNowTimeTimestamp];
    NSDictionary *dic = @{
                          @"mySymbol":mySymbol == nil?@"":mySymbol,
                          @"lang":[NSNumber numberWithInt:lang],
                          @"unit":[unitstr isEqualToString:@"rmb"]?@1:@0,
                          @"timestamp":timestamp
                          };
    NSString *sign = [NetManager signParams:dic];
    NSDictionary *params = @{
                             @"mySymbol":mySymbol == nil?@"":mySymbol,
                             @"lang":[NSNumber numberWithInt:lang],
                             @"unit":[unitstr isEqualToString:@"rmb"]?@1:@0,
                             @"timestamp":timestamp,
                             @"sign":sign
                             };
    [self POSTSetHeader:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
        if (!error) {
            NSDictionary *responseDic = ((NSData *)repsonseObj).jsonValueDecoded;
            !handler ?:handler(responseDic,error);
        }else{
            NSError *err = [NSError ErrorWithTitle:@"项目介绍获取失败" Code:102710];
            !handler ?:handler(nil,err);
        }
    }];
}




/*
 获取所有币种
 */
+(void)GetALLCOINCompletionHandler:(void (^)(id responseObj, NSError *error))handler{
    NSString *path = [NSString stringWithFormat:@"%@%@",NEW_BASE_URLV2,MARKET_GETALLCOIN];
    NSString *timestamp = [NetManager getNowTimeTimestamp];
    NSDictionary *dic = @{
                          @"timestamp":timestamp
                          };
    NSString *sign = [NetManager signParams:dic];
    NSDictionary *params = @{
                             @"timestamp":timestamp,
                             @"sign":sign
                             };
    [self POSTSetHeader:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
        if (!error) {
            NSDictionary *responseDic = ((NSData *)repsonseObj).jsonValueDecoded;
            !handler ?:handler(responseDic,error);
        }else{
            NSError *err = [NSError ErrorWithTitle:@"获取所有币种" Code:102711];
            !handler ?:handler(nil,err);
        }
    }];
}

/*
 创建MIS钱包
 */
+(void)CreateAccountWithAccountName:(NSString *)accountName publickey:(NSString *)publickey nodeUrl:(NSString *)nodeUrl completionHandler:(void (^)(id responseObj, NSError *error))handler{
    NSString *path = [NSString stringWithFormat:@"%@%@",MISBASEURL,WALLET_CREATEACCOUNT];
    NSString *timestamp = [NetManager getNowTimeTimestamp];
    NSDictionary *dic = @{
                          @"nodeUrl":nodeUrl == nil?@"":nodeUrl,
                          @"accountName":accountName == nil?@"":accountName,
                          @"publicKey":publickey == nil?@"":publickey,
                          @"timestamp":timestamp
                          };
    NSString *sign = [NetManager signParams:dic];
    NSDictionary *params = @{
                             @"nodeUrl":nodeUrl == nil?@"":nodeUrl,
                             @"accountName":accountName == nil?@"":accountName,
                             @"publicKey":publickey == nil?@"":publickey,
                             @"timestamp":timestamp,
                             @"sign":sign
                             };
    [self POSTSetHeader:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
        if (!error) {
            NSDictionary *responseDic = ((NSData *)repsonseObj).jsonValueDecoded;
            !handler ?:handler(responseDic,error);
        }else{
            NSError *err = [NSError ErrorWithTitle:@"创建MIS钱包失败" Code:102712];
            !handler ?:handler(nil,err);
        }
    }];
}
/*
 获取当前登录用户
 */
+(void)GETCurrentLoginUserCompletionHandler:(void (^)(id responseObj, NSError *error))handler{
    NSString *path = [NSString stringWithFormat:@"%@%@",MISBASEURL,USER_GETUSER];
    path = @"http://122.112.203.124:8088/missuser/api/user/getUser";
    NSString *timestamp = [NetManager getNowTimeTimestamp];
    NSDictionary *dic = @{
                          @"timestamp":timestamp
                          };
    NSString *sign = [NetManager signParams:dic];
    NSDictionary *params = @{
                             @"timestamp":timestamp,
                             @"sign":sign
                             };
    [self POSTSetHeader:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
        if (!error) {
            NSDictionary *responseDic = ((NSData *)repsonseObj).jsonValueDecoded;
            !handler ?:handler(responseDic,error);
        }else{
            NSError *err = [NSError ErrorWithTitle:@"账户信息获取失败，请稍后再试" Code:102700];
            !handler ?:handler(nil,err);
        }
    }];
}

/*
 人物标签
 */
+(void)
GETUserTagCompletionHandler:(void (^)(id responseObj, NSError *error))handler{
    NSString *path = [NSString stringWithFormat:@"%@%@",MISBASEURL,USER_TAG_API];
    NSString *timestamp = [NetManager getNowTimeTimestamp];
    NSDictionary *dic = @{
                          @"timestamp":timestamp
                          };
    NSString *sign = [NetManager signParams:dic];
    NSDictionary *params = @{
                             @"timestamp":timestamp,
                             @"sign":sign
                             };
    [self POSTSetHeader:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
        if (!error) {
            NSDictionary *responseDic = ((NSData *)repsonseObj).jsonValueDecoded;
            !handler ?:handler(responseDic,error);
        }else{
            NSError *err = [NSError ErrorWithTitle:@"人物标签获取失败，请稍后再试" Code:102804];
            !handler ?:handler(nil,err);
        }
    }];
}

/*
 人脸识别
 */
+(void)FaceCompareWithIdFront:(UIImage *)front IdRevers:(UIImage *)revers Face:(UIImage *)face CompletionHandler:(void (^)(id responseObj, NSError *error))handler{
    NSString *path = [NSString stringWithFormat:@"%@%@",MISBASEURL,FACE_COMPAREFILE];
    NSString *timestamp = [NetManager getNowTimeTimestamp];
    NSData *frontdata = UIImagePNGRepresentation(front);
    NSData *reversdata = UIImagePNGRepresentation(revers);
    NSData *facedata = UIImagePNGRepresentation(face);
    
    NSDictionary *dic = @{ @"idFront":frontdata,
                           @"idRevers":reversdata,
                           @"face":facedata,
                          @"timestamp":timestamp
                          };
    NSString *sign = [NetManager signParams:dic];
    NSDictionary *params = @{
                             @"idFront":frontdata,
                             @"idRevers":reversdata,
                             @"face":facedata,
                             @"timestamp":timestamp,
                             @"sign":sign
                             };
    [self POSTFileSetHeader:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
        if (!error) {
            NSDictionary *responseDic = ((NSData *)repsonseObj).jsonValueDecoded;
            !handler ?:handler(responseDic,error);
        }else{
            NSError *err = [NSError ErrorWithTitle:@"人脸识别接口错误，请稍后再试" Code:102713];
            !handler ?:handler(nil,err);
        }
    }];

}


/*
 人脸识别
 */
+(void)FaceCompareDataWithIdFront:(NSString *)front IdRevers:(NSString *)revers Face:(NSString *)face CompletionHandler:(void (^)(id responseObj, NSError *error))handler{
    NSString *path = [NSString stringWithFormat:@"%@%@",MISBASEURL,FACE_COMPARE];
    NSString *timestamp = [NetManager getNowTimeTimestamp];
    NSDictionary *dic = @{ @"idFront":front,
                           @"idRevers":revers,
                           @"face":face,
                           @"timestamp":timestamp
                           };
    NSString *sign = [NetManager signParams:dic];
    NSDictionary *params = @{
                             @"idFront":front,
                             @"idRevers":revers,
                             @"face":face,
                             @"timestamp":timestamp,
                             @"sign":sign
                             };
    [self POSTSetHeaderImage:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
        NSDictionary *responseDic = ((NSData *)repsonseObj).jsonValueDecoded;
        
        if (error) {
            NSError *err = [NSError ErrorWithTitle:@"人脸识别接口错误，请稍后再试" Code:102713];
            !handler ?:handler(responseDic,err);
        }else{
            !handler ?:handler(responseDic,error);
        }
        
    }];
}
//************************************** 旧接口  ******************************************

//+(id)GETCurrencyListWithMySymbol:(NSString *)mySymbol  completionHandler:(void (^)(id responseObj, NSError *error))handler{
//
//    NSString *path = [NSString stringWithFormat:@"%@%@",BASE_URL,@"/getMarketTickers"];
//    NSDictionary *params = @{@"mySymbol":mySymbol == nil?@"":mySymbol};
//    return [self GET:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
//        !handler ?:handler(repsonseObj,error);
//    }];
//}
////获取交易对详情
//+(void)GETKLineWthkSearchSymbol:(NSString*)symbol LineType:(KLineType)kLineType searchNum:(NSInteger)searchNum completionHandler:(void (^)(id responseObj, NSError *error))handler{
//    NSString *path = [NSString stringWithFormat:@"%@%@",BASE_URL,@"/getSymbolInfo"];
//    NSDictionary *params = @{@"searchSymbol":symbol == nil?@"":symbol,
//                             @"kLineType":[NSString stringWithFormat:@"%u", kLineType],
//                             @"searchNum":[NSString stringWithFormat:@"%ld",searchNum]
//                             };
//    [self GET:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
//        !handler ?:handler(repsonseObj,error);
//    }];
//}
////汇率
//+(void)GetAllCurrencyCompletionHandler:(void (^)(id responseObj, NSError *error))handler{
//    NSString *path = [NSString stringWithFormat:@"%@%@",BASE_URL,@"/getRates"];
//    [self GET:path parameters:nil completionHandler:^(id repsonseObj, NSError *error) {
//        !handler ?:handler(repsonseObj,error);
//    }];
//}

/*
 *****************************************  BTC  *******************************
 */



//比特币美元汇率
+(void)GetCurrencyCompletionHandler:(void (^)(id responseObj, NSError *error))handler{
    CurrentNodes *node = [CreateAll GetCurrentNodes];
    NSString *url = @"https://insight.bitpay.com";
    if ([node.nodeBtc containsString:@"http"]) {
        if ([node.nodeBtc containsString:@"insight"]) {
            url = @"https://insight.bitpay.com/api";
        }else{
            url = [NSString stringWithFormat:@"%@/insight-api", node.nodeBtc];
        }
    }
    NSString *path = [NSString stringWithFormat:@"%@",ChangeToTESTNET == 1?BTC_GETCurrency_URL_TESTNET : [NSString stringWithFormat:@"%@%@",url, BTC_GETCurrency_URL]];
    NSDictionary *params = nil;
    [self GET:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
        if (error) {
            NSError *err = [NSError ErrorWithTitle:@"比特币美元汇率错误" Code:102900];
            !handler ?:handler(repsonseObj,err);
        }else{
            !handler ?:handler(repsonseObj,error);
        }
    }];
}


//BTC查询余额https://insight.bitpay.com/api/addr/1D9NoaVRDVoGuUcCq735JSX52gcxvc1rf4
+(void)GetBalanceForBTCAdress:(NSString *)address noTxList:(int)noTxList completionHandler:(void (^)(id responseObj, NSError *error))handler{
    CurrentNodes *node = [CreateAll GetCurrentNodes];
    NSString *url = @"https://insight.bitpay.com/api";
    if ([node.nodeBtc containsString:@"http"]) {
        if ([node.nodeBtc containsString:@"insight"]) {
            url = @"https://insight.bitpay.com/api";
        }else{
            url = [NSString stringWithFormat:@"%@/insight-api", node.nodeBtc];
        }
    }
    NSString *path = [NSString stringWithFormat:@"%@",ChangeToTESTNET == 1?BTC_GETBalance_URL_TESTNET : [NSString stringWithFormat:@"%@%@",url, BTC_GETBalance_URL]];
    NSDictionary *params = noTxList == -1?nil : @{@"noTxList": [NSString stringWithFormat:@"%d",noTxList]};
    [self GET:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
        if (error) {
            NSError *err = [NSError ErrorWithTitle:@"BTC查询余额错误" Code:102901];
            !handler ?:handler(repsonseObj,err);
        }else{
            !handler ?:handler(repsonseObj,error);
        }
    }];
}
//BTC获取交易列表https://insight.bitpay.com/api/txs?address=1D9NoaVRDVoGuUcCq735JSX52gcxvc1rf4&pageNum=0
+(void)GetTXListBTCAdress:(NSString *)address pageNum:(int)pageNum completionHandler:(void (^)(id responseObj, NSError *error))handler{
    CurrentNodes *node = [CreateAll GetCurrentNodes];
    NSString *url = @"https://insight.bitpay.com";
    if ([node.nodeBtc containsString:@"http"]) {
        if ([node.nodeBtc containsString:@"insight"]) {
            url = @"https://insight.bitpay.com/api";
        }else{
            url = [NSString stringWithFormat:@"%@/insight-api", node.nodeBtc];
        }
    }
    NSString *path = [NSString stringWithFormat:@"%@",ChangeToTESTNET == 1?BTC_GETTXList_URL_TESTNET : [NSString stringWithFormat:@"%@%@",url, BTC_GETTXList_URL]];
    NSDictionary *params = @{@"address":address == nil?@"":address,
                             @"pageNum":[NSString stringWithFormat:@"%d", pageNum],
                             };
    [self GET:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
        if (error) {
            NSError *err = [NSError ErrorWithTitle:@"BTC获取交易列表错误" Code:102902];
            !handler ?:handler(repsonseObj,err);
        }else{
            !handler ?:handler(repsonseObj,error);
        }
    }];
}

//获取交易详情
+(void)GetTXDetailByTXID:(NSString *)txid completionHandler:(void (^)(id responseObj, NSError *error))handler{
    CurrentNodes *node = [CreateAll GetCurrentNodes];
    NSString *url = @"https://insight.bitpay.com";
    if ([node.nodeBtc containsString:@"http"]) {
        if ([node.nodeBtc containsString:@"insight"]) {
            url = @"https://insight.bitpay.com/api";
        }else{
            url = [NSString stringWithFormat:@"%@/insight-api", node.nodeBtc];
        }
    }
    NSString *path = [NSString stringWithFormat:@"%@%@",ChangeToTESTNET == 1?BTC_GETTXDetail_URL_TESTNET : [NSString stringWithFormat:@"%@%@",url, BTC_GETTXDetail_URL],txid];
    
    NSDictionary *params = nil;
    [self GET:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
        if (error) {
            NSError *err = [NSError ErrorWithTitle:@"BTC获取交易详情错误" Code:102903];
            !handler ?:handler(repsonseObj,err);
        }else{
            !handler ?:handler(repsonseObj,error);
        }
    }];
}

//获取UTXO https://insight.bitpay.com/api/addrs/1NcXPMRaanz43b1kokpPuYDdk6GGDvxT2T,...,.../utxo
+(void)GetUTXOByBTCAdress:(NSString *)address completionHandler:(void (^)(id responseObj, NSError *error))handler{
    CurrentNodes *node = [CreateAll GetCurrentNodes];
    NSString *url = @"https://insight.bitpay.com";
    if ([node.nodeBtc containsString:@"http"]) {
        if ([node.nodeBtc containsString:@"insight"]) {
            url = @"https://insight.bitpay.com/api";
        }else{
            url = [NSString stringWithFormat:@"%@/insight-api", node.nodeBtc];
        }
    }
    url = @"https://insight.bitpay.com/api";//gai
    NSString *path = [NSString stringWithFormat:@"%@%@/utxo",ChangeToTESTNET == 1?BTC_GETUTXO_URL_TESTNET : [NSString stringWithFormat:@"%@%@",url, BTC_GETUTXO_URL],address];
    NSDictionary *params = nil;
    [self GET:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
        if (error) {
            NSError *err = [NSError ErrorWithTitle:@"获取UTXO错误" Code:102904];
            !handler ?:handler(repsonseObj,err);
        }else{
            !handler ?:handler(repsonseObj,error);
        }
    }];
}


//交易广播 Rawtx参数为交易信息签名
+(void)BroadcastBTCTransactionData:(NSString *)transaction completionHandler:(void (^)(id responseObj, NSError *error))handler{
    CurrentNodes *node = [CreateAll GetCurrentNodes];
    NSString *url = @"https://insight.bitpay.com";
    if ([node.nodeBtc containsString:@"http"]) {
        if ([node.nodeBtc containsString:@"insight"]) {
            url = @"https://insight.bitpay.com/api";
        }else{
            url = [NSString stringWithFormat:@"%@/insight-api", node.nodeBtc];
        }
    }
    url = @"https://insight.bitpay.com/api";//gai
    NSString *path = [NSString stringWithFormat:@"%@",ChangeToTESTNET == 1?BTC_BroadcastTransaction_URL_TESTNET : [NSString stringWithFormat:@"%@%@",url, BTC_BroadcastTransaction_URL]];
    NSDictionary *params = @{@"rawtx": transaction};
    [self POSTImage:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
        if (error) {
//            NSError *err = [NSError ErrorWithTitle:@"BTC交易广播失败" Code:102905];
            !handler ?:handler(repsonseObj,error);
        }else{
            !handler ?:handler(repsonseObj,error);
        }
    }];
}

//***************** BTC Txlist BlockChain *************
//https://blockchain.info/multiaddr?active=139pMv3rXisEhubSd1SsZiHSpWRQFfCLqj|13cmPrDymiSQSoGP1Qt3i6ScbAemKn9xQ4|1M17Zb1S91cCfc9jM5x9TDGUEwP7o1yUQu&n=10&offset=10
//Optional limit parameter to show n transactions e.g. &n=50 (Default: 50, Max: 100)
//Optional offset parameter to skip the first n transactions e.g. &offset=100 (Page 2 for limit 50)
+(void)GetBTCTxFromBlockChainAddress:(NSString *)address PageSize:(NSInteger)n Offset:(NSInteger)offset completionHandler:(void (^)(id responseObj, NSError *error))handler{
    NSString *url = @"https://blockchain.info/multiaddr";
    NSDictionary *params = @{@"active":VALIDATE_STRING(address),
                             @"n":[NSNumber numberWithInteger:n],
                             @"offset":[NSNumber numberWithInteger:offset]
                             };
    [self GET:url parameters:params completionHandler:^(id repsonseObj, NSError *error) {
        if (error) {
            NSError *err = [NSError ErrorWithTitle:@"BTC获取交易列表错误" Code:102902];
            !handler ?:handler(repsonseObj,err);
        }else{
            !handler ?:handler(repsonseObj,error);
        }
    }];
}

//https://blockchain.info/unspent?confirmations=0&active=1CqDXZMP3vBBEADWSNXLKycpqzciVFY7pM|1ETYLZTGJj2tU9FqfD29XAfKwbgW2skPYf
/*{"unspent_outputs":[{"tx_hash":"b4affb64e9ae9b3549582a242f5ab472495f52f05678ddf723ae61326343667a","tx_hash_big_endian":"7a6643633261ae23f7dd7856f0525f4972b45a2f242a5849359baee964fbafb4","tx_output_n":0,"script":"76a914939e9bf4929611da68d8c4886cb879e06997d26188ac","value":546,"value_hex":"0222","confirmations":8148,"tx_index":437074323}]}
*/
+(void)GetBTCUTXOFromBlockChainAddress:(NSString *)address MinumConfirmations:(NSInteger)confirmations completionHandler:(void (^)(id responseObj, NSError *error))handler{
    NSString *url = @"https://blockchain.info/unspent";
    NSDictionary *params = @{
                             @"confirmations":[NSNumber numberWithInteger:confirmations],
                             @"active":VALIDATE_STRING(address)
                             };
    [self GET:url parameters:params completionHandler:^(id repsonseObj, NSError *error) {
        if (error) {
            NSError *err = [NSError ErrorWithTitle:@"获取UTXO错误" Code:102904];
            !handler ?:handler(repsonseObj,err);
        }else{
            !handler ?:handler(repsonseObj,error);
        }
    }];
    
}

//****************** ETH交易状态查询 ****************
/*
 Check Contract Execution Status
 https://api.etherscan.io/api?module=transaction&action=getstatus&txhash=0x15f8e5ea1079d9a0bb04a4c58ae5fe7654b5b2b4463375ff7ffb490aa0032f3a&apikey=YourApiKeyToken
 {"status":"1","message":"OK","result":{"isError":"1","errDescription":"Bad jump destination"}}
 Note: isError":"0" = Pass , isError":"1" = Error during Contract Execution

 Check Transaction Receipt Status
 https://api.etherscan.io/api?module=transaction&action=gettxreceiptstatus&txhash=0x513c1ba0bebf66436b5fed86ab668452b7805593c05073eb2d51d3a52f480a76&apikey=YourApiKeyToken
 {"status":"1","message":"OK","result":{"status":"1"}}
 Note: status: 0 = Fail, 1 = Pass. Will return null/empty value for pre-byzantium fork 
 */
+(void)GetETHTraRecordStatusWithHash:(NSString *)hash Check:(BOOL)checkcontract completionHandler:(void (^)(id responseObj, NSError *error))handler{
    NSString *path = @"https://api.etherscan.io/api";
    NSDictionary *params = @{@"module":@"transaction",
                             @"action":checkcontract == YES?@"getstatus":@"gettxreceiptstatus",
                             @"txhash":VALIDATE_STRING(hash),
                             @"apikey":EtherscanApiKey
                             };
    [self GET:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
        if (!error) {
           !handler ?:handler(repsonseObj,error);
        }else{
            NSError *err = [NSError ErrorWithTitle:@"ETH交易记录状态查询失败" Code:102910];
            !handler ?:handler(repsonseObj,err);
        }
    }];
    
}
/*
 查询eth地址判断是否是合约地址
 https://api.etherscan.io/api?module=contract&action=getabi&address=0xBB9bc244D798123fDe783fCc1C72d3Bb8C189413&apikey=YourApiKeyToken
 
 https://api.etherscan.io/api?module=contract&action=getabi&address=0x4d8F5F734821BcaA0436870b4Dc8394B3025EeA6
 {"status":"0","message":"NOTOK","result":"Contract source code not verified"}
 */
+(void)VerifyIFAddressIsContract:(NSString *)address completionHandler:(void (^)(id responseObj, NSError *error))handler{
    NSString *path = @"https://api.etherscan.io/api";
    NSDictionary *params = @{@"module":@"contract",
                             @"action":@"getabi",
                             @"address":VALIDATE_STRING(address),
                             @"apikey":EtherscanApiKey
                             };
    [self GET:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
        if (!error) {
            !handler ?:handler(repsonseObj,error);
        }else{
            NSError *err = [NSError ErrorWithTitle:@"查询eth地址类型查询判断失败" Code:102910];
            !handler ?:handler(repsonseObj,err);
        }
    }];
}

/*
 通过交易hash获取ETH交易
 https://api.etherscan.io/api?module=proxy&action=eth_getTransactionByHash&txhash=0x30488f2ae530892c79c5b821e3ca4d998c4ea2bbfab0efa20153f7fe7fa86117
 */
+(void)GetETHTransWithHash:(NSString *)hash completionHandler:(void (^)(id responseObj, NSError *error))handler{
    NSString *path = @"https://api.etherscan.io/api";
    NSDictionary *params = @{@"module":@"proxy",
                             @"action":@"eth_getTransactionByHash",
                             @"txhash":VALIDATE_STRING(hash),
                             @"apikey":EtherscanApiKey
                             };
    [self GET:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
        if (!error) {
            NSDictionary *responseDic = ((NSData *)repsonseObj).jsonValueDecoded;
            !handler ?:handler(responseDic,error);
        }else{
            NSError *err = [NSError ErrorWithTitle:@"通过hash获取ETH交易失败" Code:102910];
            !handler ?:handler(repsonseObj,err);
        }
    }];
}
/**
 获取chainID
 */
+(void)getChainIdHandler:(void (^)(id responseObj, NSError *error))handler{

    NSString *path = [CreateAll GetCurrentNodes].nodeEth;
    NSDictionary *params = @{@"jsonrpc":@"2.0",
                             @"method":@"eth_chainId",
                             @"params":@[],
                             @"id":@"1",
                             };
    [self POST:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
        if (!error) {

            NSString *temp = [NSString stringWithFormat:@"%lu",strtoul([repsonseObj[@"result"] UTF8String],0,16)];
            !handler ?:handler(temp,error);

        }else{
            !handler ?:handler(repsonseObj,error);
        }
        
    }];
    
}
/**
 获取ETH交易记录
 */
+(void)GetETHAccounttxList:(NSString *)address CompletionHandler:(void (^)(id responseObj, NSError *error))handler{
    
    NSString *path = [CreateAll GetCurrentNodes].nodeEth;
    path = @"http://api-cn.etherscan.com/api";
    NSDictionary *params = @{@"apikey":@"SK67PZQDFS6V4U5KCNVI2C61DJH53ZSJWZ",
                             @"module":@"account",
                             @"action":@"txlist",
                             @"sort":@"desc",
                             @"address":address,
                             @"offset":@"1",
                             @"page":@"0",
                        
    };
    [self GET:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
        if (!error) {
            !handler ?:handler(repsonseObj,error);
        }else{
            NSError *err = [NSError ErrorWithTitle:@"获取交易记录失败" Code:102910];
            !handler ?:handler(repsonseObj,err);
        }
    }];
    /*
    NSString *path = [CreateAll GetCurrentNodes].nodeEth;
    NSDictionary *params = @{@"jsonrpc":@"2.0",
                             @"method":@"eth_call",
                             @"params":@[@{@"from":address,@"to":@"0xb2054aDd212F19581aEB195FDa7644471a996134",@"data":[NSString stringWithFormat:@"0x70a08231000000000000000000000000%@",[address substringFromIndex:2]]},@"latest"],
                             @"id":@"1",
                             };
    [self POST:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
        if (!error) {

            NSString *temp = [NSString stringWithFormat:@"%lu",strtoul([repsonseObj[@"result"] UTF8String],0,16)];
            !handler ?:handler(temp,error);
            
        }else{
            !handler ?:handler(repsonseObj,error);
        }
        
    }];
    */
    
}

/*
 获取ETH gasprice
 https://api.etherscan.io/api?module=proxy&action=eth_gasPrice
 */
+(void)GetETHGasPriceCompletionHandler:(void (^)(id responseObj, NSError *error))handler{
    NSString *path = [CreateAll GetCurrentNodes].nodeEth;
//    NSDictionary *params = @{@"jsonrpc":@"2.0",
//                             @"method":@"eth_chainId",
//                             @"params":@[],
//                             @"id":@"1",
//                             };
//    [self GET:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
//        if (!error) {
//            !handler ?:handler(repsonseObj,error);
//        }else{
//            NSError *err = [NSError ErrorWithTitle:@"获取ETH gasprice失败" Code:102910];
//            !handler ?:handler(repsonseObj,err);
//        }
//    }];
    
    //    -d '{"jsonrpc":"2.0","method":"eth_gasPrice","params": [],"id":1}'
    //    -d '{"jsonrpc":"2.0","method":"eth_getTransactionCount","params": ["0xc94770007dda54cF92009BFF0dE90c06F603a09f","latest"],"id":1}'
    //    -d '{"jsonrpc":"2.0","method":"eth_chainId","params": [],"id":1}'
    

    path = @"http://api-cn.etherscan.com/api";
    NSDictionary *params = @{@"apikey":@"SK67PZQDFS6V4U5KCNVI2C61DJH53ZSJWZ",
                             @"module":@"account",
                             @"action":@"txlist",
                             @"sort":@"desc",
                             @"address":@"0xf4128a3E1da533C84A26a3Af5286c0ccF65EffD5",
                             @"offset":@"1",
                             @"page":@"0",
                        
    };
    [self GET:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
        if (!error) {
            NSLog(@"%@-----",repsonseObj);
            
         
            
        }else{
            NSLog(@"%@-----error",error);

        }
        
    }];
    
}

/*
获取ETH BTC  EOS MGP实时价格
 https://api.bkex.co/v1/q/ticker/price?pair=ETH_USDT
*/
+(void)GetWalletPrice:(NSString *)coinType completionHandler:(void (^)(id responseObj, NSError *error))handler{
    
    
    NSString *path = @"https://api.bkex.co/v1/q/ticker/price";
    NSDictionary *params = @{@"pair":coinType};
    [self GET:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
        if (!error) {
            !handler ?:handler(repsonseObj,error);
        }else{
            NSError *err = [NSError ErrorWithTitle:@"获取实时价格失败" Code:102910];
            !handler ?:handler(repsonseObj,err);
        }
    }];
    
}

/*
 *******************************  USDT **********************************
 */

/*
 查询usdt余额
 response:
 {
 "balance": [{
   "divisible": true,
   "frozen": "0",
   "id": "1",
   "pendingneg": "0",
   "pendingpos": "0",
   "reserved": "0",
   "symbol": "OMNI",
   "value": "3054147959984"
 }]
 }
 Returns the balance information for a given address. For multiple addresses in a single query use the v2 endpoint
 
 https://api.omniwallet.org/v1/address/addr/
 */
+(void)RequestUSDT_BalanceAddress:(NSString *)addr CompletionHandler:(void (^)(id responseObj, NSError *error))handler{
    NSString *path = [NSString stringWithFormat:@"%@%@",USDT_Node_URL,USDT_Addr];
    NSDictionary *params = @{@"addr":VALIDATE_STRING(addr)};
    [self POSTSetHeaderImage:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
        if (!error) {
            !handler ?:handler([repsonseObj jsonValueDecoded],error);
        }else{
            NSError *err = [NSError ErrorWithTitle:@"USDT余额查询错误" Code:102911];
            !handler ?:handler(repsonseObj,err);
        }
    }];
   
//    [self POST:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
//        if (!error) {
//            !handler ?:handler(repsonseObj,error);
//        }else{
//            NSError *err = [NSError ErrorWithTitle:@"USDT余额查询错误" Code:102911];
//            !handler ?:handler(repsonseObj,err);
//        }
//    }];
}
/*
 addr=1FoWyxwPXuj4C6abqwhjDWdz6D4PZgYRjA&addr=1KYiKJEfdJtap9QX2v9BXJMpz2SfU4pgZw" "https://api.omniwallet.org/v2/address/addr/"
 */
//addr
+(void)RequestUSDT_BalanceMutiAddress:(NSString *)addr CompletionHandler:(void (^)(id responseObj, NSError *error))handler{
    NSString *addrx;
    if (addr != nil && [addr containsString:@"|"]) {
        addrx = [addr stringByReplacingOccurrencesOfString:@"," withString:@"&addr="];
    }else{
        addrx = addr;
    }
    NSString *path = [NSString stringWithFormat:@"%@%@",USDT_Node_URL,USDT_MultiAddr];
    NSDictionary *params = @{@"addr":VALIDATE_STRING(addrx)};
    
    [self POST:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
        if (!error) {
            !handler ?:handler(repsonseObj,error);
        }else{
            NSError *err = [NSError ErrorWithTitle:@"USDT余额查询错误" Code:102911];
            !handler ?:handler(repsonseObj,err);
        }
    }];
}
/*
 Returns the balance information and transaction history list for a given address
 */
+(void)RequestUSDT_AddressDetails:(NSString *)addr CompletionHandler:(void (^)(id responseObj, NSError *error))handler{
    NSString *path = [NSString stringWithFormat:@"%@%@",USDT_Node_URL,USDT_Addr_Details];
    NSDictionary *params = @{@"addr":VALIDATE_STRING(addr)};
    [self POST:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
        if (!error) {
            !handler ?:handler(repsonseObj,error);
        }else{
            NSError *err = [NSError ErrorWithTitle:@"USDT地址信息查询错误" Code:102912];
            !handler ?:handler(repsonseObj,err);
        }
    }];
}
/*
 Decodes raw hex returning Omni and Bitcoin transaction information
 */
+(void)DecodeUSDTTxHex:(NSString *)hex CompletionHandler:(void (^)(id responseObj, NSError *error))handler{
    NSString *path = [NSString stringWithFormat:@"%@%@",USDT_Node_URL,USDT_Addr_Decode];
    NSDictionary *params = @{@"hex":VALIDATE_STRING(hex)};
    [self POST:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
        if (!error) {
            !handler ?:handler(repsonseObj,error);
        }else{
            NSError *err = [NSError ErrorWithTitle:@"USDT hex解码错误" Code:102913];
            !handler ?:handler(repsonseObj,err);
        }
    }];
}

/*
 Returns list of transactions for queried address. Data: addr : address to query page : cycle through available response pages (10 txs per page)
 https://api.omniexplorer.info/v1/transaction/address
 addr=1EXoDusjGwvnjZUyKkxZ4UHEf77z6A5S4P&page=0
 */
+(void)RequestUSDTTxListForAddress:(NSString *)addr Page:(NSInteger)page CompletionHandler:(void (^)(id responseObj, NSError *error))handler{
    NSString *path = [NSString stringWithFormat:@"%@%@",USDT_Node_URL,USDT_TxList];
    NSDictionary *params = @{@"addr":VALIDATE_STRING(addr),
                             @"page":[NSNumber numberWithInteger:page]
                             };
    [self POSTSetHeaderImage:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
        if (!error) {
            !handler ?:handler([repsonseObj jsonValueDecoded],error);
        }else{
            NSError *err = [NSError ErrorWithTitle:@"USDT 交易记录获取错误" Code:102914];
            !handler ?:handler(repsonseObj,err);
        }
    }];
 
}
/*
 Broadcast a signed transaction to the network. Data: signedTransaction : signed hex to broadcast
 */
+(void)PushUSDT_Tx:(NSString *)hexstr CompletionHandler:(void (^)(id responseObj, NSError *error))handler{
    NSString *path = [NSString stringWithFormat:@"%@%@",USDT_Node_URL,USDT_PushTx];
    NSDictionary *params = @{
                             @"signedTransaction":VALIDATE_STRING(hexstr)
                             };
    [self POST:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
        if (!error) {
            !handler ?:handler(repsonseObj,error);
        }else{
            NSError *err = [NSError ErrorWithTitle:@"USDT 交易广播错误" Code:102915];
            !handler ?:handler(repsonseObj,err);
        }
    }];
}

/*
 Returns transaction details of a queried transaction hash.
 */
+(void)GetUSDTTxDetail:(NSString *)hexstr CompletionHandler:(void (^)(id responseObj, NSError *error))handler{
    NSString *path = [NSString stringWithFormat:@"%@%@%@",USDT_Node_URL,USDT_Txdetail,VALIDATE_STRING(hexstr)];
    [self GET:path parameters:nil completionHandler:^(id repsonseObj, NSError *error) {
        if (!error) {
            !handler ?:handler(repsonseObj,error);
        }else{
            NSError *err = [NSError ErrorWithTitle:@"USDT 交易详情查询错误" Code:102916];
            !handler ?:handler(repsonseObj,err);
        }
    }];
//    [self GETSetHeader:path parameters:nil completionHandler:^(id repsonseObj, NSError *error) {
//        if (!error) {
//            !handler ?:handler(repsonseObj,error);
//        }else{
//            NSError *err = [NSError ErrorWithTitle:@"USDT 交易详情查询错误" Code:102916];
//            !handler ?:handler(repsonseObj,err);
//        }
//    }];
//    [self POSTSetHeaderImage:path parameters:nil completionHandler:^(id repsonseObj, NSError *error) {
//        if (!error) {
//            !handler ?:handler([repsonseObj jsonValueDecoded],error);
//        }else{
//            NSError *err = [NSError ErrorWithTitle:@"USDT 交易详情查询错误" Code:102916];
//            !handler ?:handler(repsonseObj,err);
//        }
//    }];
}


/*
 infornamation
 */
//资讯列表分页查询
+(void)GetInfoListType:(NSInteger)type CurrentPage:(NSInteger)page CompletionHandler:(void (^)(id responseObj, NSError *error))handler{
    NSString *path = [NSString stringWithFormat:@"%@%@",NewsBaseURL,InfoList];
    NSString *timestamp = [NetManager getNowTimeTimestamp];
    NSMutableDictionary *dic = [@{@"type":[NSString stringWithFormat:@"%ld",(NSInteger)type],
                                  @"currentPage":[NSString stringWithFormat:@"%ld",page],
                                  @"timestamp":timestamp
                                  } mutableCopy];
    NSString *sign = [NetManager signParams:dic];
    NSDictionary *params = @{@"type":[NSString stringWithFormat:@"%ld",(NSInteger)type],
                             @"currentPage":[NSString stringWithFormat:@"%ld",page],
                             @"timestamp":timestamp,
                             @"sign":sign
                             };
    [self GET:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
        if (!error) {
            !handler ?:handler(repsonseObj,error);
        }else{
            NSError *err = [NSError ErrorWithTitle:@"Get Information List Error" Code:1023000];
            !handler ?:handler(repsonseObj,err);
        }
    }];
   
}
//资讯详情页接口http://122.112.203.124:8081/serve/api/information/details
+(void)GetInfoDetailUserID:(NSString *)userId NewsID:(NSString *)newsId CompletionHandler:(void (^)(id responseObj, NSError *error))handler{
    NSString *path = [NSString stringWithFormat:@"%@%@",NewsBaseURL,InfoDetail];
    NSString *timestamp = [NetManager getNowTimeTimestamp];
    NSMutableDictionary *dic = [@{ @"userId":VALIDATE_STRING(userId),
                                   @"newsId":VALIDATE_STRING(newsId),
                                   @"timestamp":timestamp,
                                  } mutableCopy];
    NSString *sign = [NetManager signParams:dic];
    NSDictionary *params = @{ @"userId":VALIDATE_STRING(userId),
                              @"newsId":VALIDATE_STRING(newsId),
                             @"timestamp":timestamp,
                             @"sign":sign
                             };

    [self GET:path parameters:dic completionHandler:^(id repsonseObj, NSError *error) {
        if (!error) {
            !handler ?:handler(repsonseObj,error);
        }else{
            NSError *err = [NSError ErrorWithTitle:@"Get Information Detail Error" Code:1023000];
            !handler ?:handler(repsonseObj,err);
        }
    }];
}
//资讯添加收藏接口
+(void)GetInfoAddCollectionUserID:(NSString *)userId NewsID:(NSString *)newsId CompletionHandler:(void (^)(id responseObj, NSError *error))handler{
    NSString *path = [NSString stringWithFormat:@"%@%@",NewsBaseURL,InfoCollAdd];
    NSString *timestamp = [NetManager getNowTimeTimestamp];
    NSMutableDictionary *dic = [@{ @"userId":VALIDATE_STRING(userId),
                                   @"newsId":VALIDATE_STRING(newsId),
                                   @"timestamp":timestamp
                                   } mutableCopy];
    NSString *sign = [NetManager signParams:dic];
    NSDictionary *params = @{ @"userId":VALIDATE_STRING(userId),
                              @"newsId":VALIDATE_STRING(newsId),
                              @"timestamp":timestamp,
                              @"sign":sign
                              };
    [self GET:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
        if (!error) {
            !handler ?:handler(repsonseObj,error);
        }else{
            NSError *err = [NSError ErrorWithTitle:@"Get Information Detail Error" Code:1023000];
            !handler ?:handler(repsonseObj,err);
        }
    }];
}
//资讯删除收藏接口
+(void)GetInfoDeleteCollectionUserID:(NSString *)userId NewsID:(NSString *)newsId CompletionHandler:(void (^)(id responseObj, NSError *error))handler{
    NSString *path = [NSString stringWithFormat:@"%@%@",NewsBaseURL,InfoCollDel];
    NSString *timestamp = [NetManager getNowTimeTimestamp];
    NSMutableDictionary *dic = [@{ @"userId":VALIDATE_STRING(userId),
                                   @"newsId":VALIDATE_STRING(newsId),
                                   @"timestamp":timestamp
                                   } mutableCopy];
    NSString *sign = [NetManager signParams:dic];
    NSDictionary *params = @{ @"userId":VALIDATE_STRING(userId),
                              @"newsId":VALIDATE_STRING(newsId),
                              @"timestamp":timestamp,
                              @"sign":sign
                              };
    [self GET:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
        if (!error) {
            !handler ?:handler(repsonseObj,error);
        }else{
            NSError *err = [NSError ErrorWithTitle:@"Get Information Delete Error" Code:1023000];
            !handler ?:handler(repsonseObj,err);
        }
    }];
}
//资讯收藏查询接口
+(void)GetInfoCollectionListUserID:(NSString *)userId CurrentPage:(NSInteger)page CompletionHandler:(void (^)(id responseObj, NSError *error))handler{
    NSString *path = [NSString stringWithFormat:@"%@%@",NewsBaseURL,InfoCollList];
    NSString *timestamp = [NetManager getNowTimeTimestamp];
    NSMutableDictionary *dic = [@{ @"userId":VALIDATE_STRING(userId),
                                   @"currentPage":[NSString stringWithFormat:@"%ld",page],
                                   @"timestamp":timestamp
                                   } mutableCopy];
    NSString *sign = [NetManager signParams:dic];
    NSDictionary *params = @{ @"userId":VALIDATE_STRING(userId),
                              @"currentPage":[NSString stringWithFormat:@"%ld",page],
                              @"timestamp":timestamp,
                              @"sign":sign
                              };
    [self GET:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
        if (!error) {
            !handler ?:handler(repsonseObj,error);
        }else{
            NSError *err = [NSError ErrorWithTitle:@"Get Information Collection list Error" Code:1023000];
            !handler ?:handler(repsonseObj,err);
        }
    }];
}

//资讯批量删除收藏接口
+(void)GetInfoDelBatchCollectionUserID:(NSString *)userId NewsID:(NSString *)newsId CompletionHandler:(void (^)(id responseObj, NSError *error))handler{
    NSString *path = [NSString stringWithFormat:@"%@%@",NewsBaseURL,InfoCollDelBatch];
    NSString *timestamp = [NetManager getNowTimeTimestamp];
    NSMutableDictionary *dic = [@{ @"userId":VALIDATE_STRING(userId),
                                   @"newsId":VALIDATE_STRING(newsId),
                                   @"timestamp":timestamp
                                   } mutableCopy];
    NSString *sign = [NetManager signParams:dic];
    NSDictionary *params = @{ @"userId":VALIDATE_STRING(userId),
                              @"newsId":VALIDATE_STRING(newsId),
                              @"timestamp":timestamp,
                              @"sign":sign
                              };
    [self GET:path parameters:params completionHandler:^(id repsonseObj, NSError *error) {
        if (!error) {
            !handler ?:handler(repsonseObj,error);
        }else{
            NSError *err = [NSError ErrorWithTitle:@"Get Information Delete Error" Code:1023000];
            !handler ?:handler(repsonseObj,err);
        }
    }];
}
@end
