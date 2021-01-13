//
//  DCMGPWalletTool.m
//  TaiYiToken
//
//  Created by mac on 2020/9/3.
//  Copyright © 2020 admin. All rights reserved.
//

#import "DCMGPWalletTool.h"
#import "BlockChain.h"


@interface DCMGPWalletTool ()

//MGP EOS trans
@property (nonatomic, strong) JSContext *context;
@property(nonatomic,strong)JavascriptWebViewController *jvc;

@property (nonatomic, copy) NSString *ref_block_prefix;
@property (nonatomic, copy) NSString *ref_block_num;
@property (nonatomic, strong) NSData *chain_Id;
@property (nonatomic, copy) NSString *expiration;
@property (nonatomic, copy) NSString *required_Publickey;
@property (nonatomic, copy) NSString *binargs;
@property(nonatomic,strong)MissionWallet *wallet;

//动作
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *action;

//交易转账参数
//@property (nonatomic, copy) NSString *amount;
//@property (nonatomic, copy) NSString *from;
//@property (nonatomic, copy) NSString *to;
//@property (nonatomic, copy) NSString *memo;

//合约参数
@property (nonatomic, strong) NSDictionary *parameter;

@property (nonatomic, strong) NSArray *parameters;
@property (nonatomic, strong) NSMutableArray *binargs_arr;



@end


@implementation DCMGPWalletTool
static DCMGPWalletTool * defualt_shareMananger = nil;

+ (instancetype)shareManager {
    //_dispatch_once(&onceToken, ^{
    if (defualt_shareMananger == nil) {
        defualt_shareMananger = [[self alloc] init];
    }
   // });
    return defualt_shareMananger;
}

/**
 交易转账
 */
- (void)transferAmount:(NSString *)amount andFrom:(NSString *)from andTo:(NSString *)to andMemo:(NSString *)memo andPassWord:(NSString *)passWord completionHandler:(void (^)(id responseObj, NSError *error))handler{
//    self.amount = amount;
//    self.from = from;
//    self.to = to;
//    self.memo = memo;
    
    self.parameter = @{
        @"from":VALIDATE_STRING(from),
        @"to":VALIDATE_STRING(to),
        @"memo":VALIDATE_STRING(memo),
        @"quantity":[NSString stringWithFormat:@"%.4f MGP", amount.doubleValue]
    };
    self.code = @"eosio.token";
    self.action = @"transfer";
   
    NSString *pass_word = [[NSUserDefaults standardUserDefaults]objectForKey:PassWordText];
    if (pass_word != nil){
        if ([passWord isEqualToString:pass_word]) {
            //解密钱包私钥
            if(![[MGPHttpRequest shareManager].curretWallet.privateKey isValidBitcoinPrivateKey]){
                NSString *depri = [AESCrypt decrypt:[MGPHttpRequest shareManager].curretWallet.privateKey password:passWord];
                if (depri != nil && ![depri isEqualToString:@""]) {
                    [MGPHttpRequest shareManager].curretWallet.privateKey = depri;
                }else{
                    [[[UIApplication sharedApplication].windows lastObject] showMsg:NSLocalizedString(@"钱包密码错误", nil)];
                    return;
                }
            }
            
        }else{
            [[[UIApplication sharedApplication].windows lastObject] showMsg:NSLocalizedString(@"钱包密码错误", nil)];
            return;
        }
    }else{
        //解密钱包私钥
        if(![[MGPHttpRequest shareManager].curretWallet.privateKey isValidBitcoinPrivateKey]){
            NSString *depri = [AESCrypt decrypt:[MGPHttpRequest shareManager].curretWallet.privateKey password:passWord];
            if (depri != nil && ![depri isEqualToString:@""]) {
                [MGPHttpRequest shareManager].curretWallet.privateKey = depri;
            }else{
                [[[UIApplication sharedApplication].windows lastObject] showMsg:NSLocalizedString(@"钱包密码错误", nil)];
                return;
            }
        }
    }

    self.wallet = [MGPHttpRequest shareManager].curretWallet;

    
    MJWeakSelf
    [self getJson:[self getAbiJsonToBinParamters] Binargs:^(id response) {
        if ([response isKindOfClass:[NSDictionary class]]) {
            NSDictionary *d = (NSDictionary *)response;
            weakSelf.binargs = [d objectForKey:@"binargs"];
            
            [weakSelf getInfoSuccess:^(id response) {
                BlockChain *model = [BlockChain parse:response];// [@"data"]
                weakSelf.expiration = [[[NSDate dateFromString: model.head_block_time] dateByAddingTimeInterval: 30] formatterToISO8601];
                weakSelf.ref_block_num = [NSString stringWithFormat:@"%@",model.head_block_num];
                
                NSString *js = @"function readUint32( tid, data, offset ){var hexNum= data.substring(2*offset+6,2*offset+8)+data.substring(2*offset+4,2*offset+6)+data.substring(2*offset+2,2*offset+4)+data.substring(2*offset,2*offset+2);var ret = parseInt(hexNum,16).toString(10);return(ret)}";
                [weakSelf.context evaluateScript:js];
                JSValue *n = [weakSelf.context[@"readUint32"] callWithArguments:@[@8,VALIDATE_STRING(model.head_block_id) , @8]];
                weakSelf.ref_block_prefix = [n toString];
                weakSelf.chain_Id = [NSData convertHexStrToData:model.chain_id];
                NSLog(@"get_block_info_success:%@, %@---%@-%@", weakSelf.expiration , weakSelf.ref_block_num, weakSelf.ref_block_prefix, weakSelf.chain_Id);
                
                [weakSelf getRequiredPublicKeyRequestOperationSuccess:^(id response) {
                    if ([response isKindOfClass:[NSDictionary class]]) {
                        weakSelf.required_Publickey = response[@"required_keys"][0];
                        [weakSelf pushTransactionRequestOperationSuccess:^(id response) {

                            if ([response isKindOfClass:[NSDictionary class]]) {
                                NSMutableDictionary *dic;
                                dic = [response mutableCopy];
                                handler(dic[@"transaction_id"],nil);
                            }
                        }];
                    }
                }];
            }];
        }
    }];
    
}
/**
 合约调用
 */
- (void)contractCode:(NSString *)code andAction:(NSString *)action andParameters:(NSDictionary *)parameters andPassWord:(NSString *)passWord completionHandler:(void (^)(id responseObj, NSError *error))handler{
    self.parameter = parameters;
    self.code = code;
    self.action = action;
    
    NSString *pass_word = [[NSUserDefaults standardUserDefaults]objectForKey:PassWordText];
    if (pass_word != nil){
        if ([passWord isEqualToString:pass_word]) {
            //解密钱包私钥
            if(![[MGPHttpRequest shareManager].curretWallet.privateKey isValidBitcoinPrivateKey]){
                NSString *depri = [AESCrypt decrypt:[MGPHttpRequest shareManager].curretWallet.privateKey password:passWord];
                if (depri != nil && ![depri isEqualToString:@""]) {
                    [MGPHttpRequest shareManager].curretWallet.privateKey = depri;
                }else{
                    [[[UIApplication sharedApplication].windows lastObject] showMsg:NSLocalizedString(@"钱包密码错误", nil)];
                    return;
                }
            }
            
        }else{
            [[[UIApplication sharedApplication].windows lastObject] showMsg:NSLocalizedString(@"钱包密码错误", nil)];
            return;
        }
    }else{
        //解密钱包私钥
        if(![[MGPHttpRequest shareManager].curretWallet.privateKey isValidBitcoinPrivateKey]){
            NSString *depri = [AESCrypt decrypt:[MGPHttpRequest shareManager].curretWallet.privateKey password:passWord];
            if (depri != nil && ![depri isEqualToString:@""]) {
                [MGPHttpRequest shareManager].curretWallet.privateKey = depri;
            }else{
                [[[UIApplication sharedApplication].windows lastObject] showMsg:NSLocalizedString(@"钱包密码错误", nil)];
                return;
            }
        }
    }
    self.wallet = [MGPHttpRequest shareManager].curretWallet;
    
    MJWeakSelf
    [self getJson:[self getAbiJsonToBinParamters] Binargs:^(id response) {
        if ([response isKindOfClass:[NSDictionary class]]) {
            NSDictionary *d = (NSDictionary *)response;
            weakSelf.binargs = [d objectForKey:@"binargs"];
            
            [weakSelf getInfoSuccess:^(id response) {
                BlockChain *model = [BlockChain parse:response];// [@"data"]
                weakSelf.expiration = [[[NSDate dateFromString: model.head_block_time] dateByAddingTimeInterval: 30] formatterToISO8601];
                weakSelf.ref_block_num = [NSString stringWithFormat:@"%@",model.head_block_num];
                
                NSString *js = @"function readUint32( tid, data, offset ){var hexNum= data.substring(2*offset+6,2*offset+8)+data.substring(2*offset+4,2*offset+6)+data.substring(2*offset+2,2*offset+4)+data.substring(2*offset,2*offset+2);var ret = parseInt(hexNum,16).toString(10);return(ret)}";
                [weakSelf.context evaluateScript:js];
                JSValue *n = [weakSelf.context[@"readUint32"] callWithArguments:@[@8,VALIDATE_STRING(model.head_block_id) , @8]];
                weakSelf.ref_block_prefix = [n toString];
                weakSelf.chain_Id = [NSData convertHexStrToData:model.chain_id];
                NSLog(@"get_block_info_success:%@, %@---%@-%@", weakSelf.expiration , weakSelf.ref_block_num, weakSelf.ref_block_prefix, weakSelf.chain_Id);
                
                [weakSelf getRequiredPublicKeyRequestOperationSuccess:^(id response) {
                    if ([response isKindOfClass:[NSDictionary class]]) {
                        weakSelf.required_Publickey = response[@"required_keys"][0];
                        [weakSelf pushTransactionRequestOperationSuccess:^(id response) {

                            if ([response isKindOfClass:[NSDictionary class]]) {
                                NSMutableDictionary *dic;
                                dic = [response mutableCopy];
                                handler(dic[@"transaction_id"],nil);
                            }
                        }];
                    }
                }];
            }];
        }
    }];
    
    
}


#pragma bin_to_json
-(void)getBinToJson:(NSString *)datastring Handler:(void(^)(id response))handler{
    //NSString *from = self.addressView.fromAddressTextField.text;
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject: @"eosio" forKey:@"code"];
    [params setObject:@"sign" forKey:@"action"];
    [params setObject:datastring forKey:@"binargs"];
    HTTPRequestManager *manager = self.wallet.coinType == EOS ? [HTTPRequestManager shareEosManager] : [HTTPRequestManager shareMgpManager];

    [manager post:eos_abi_bin_to_json paramters:params success:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            handler(responseObject);
        }
    } failure:^(NSError *error) {
        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
        NSLog(@"error--%@",serializedData);
        NSDictionary *err = [serializedData objectForKey:@"error"];
        NSArray *detail = [err objectForKey:@"details"];
        NSString *mesg = [[detail[0] objectForKey:@"message"] copy];
        [[[UIApplication sharedApplication].windows lastObject] showMsg:mesg];
    } superView:nil showFaliureDescription:YES];
    
    
}

#pragma mark - 获取行动代码

- (void)getJson:(NSDictionary *)dic Binargs:(void(^)(id response))handler {
    HTTPRequestManager *manager = self.wallet.coinType == EOS ? [HTTPRequestManager shareEosManager] : [HTTPRequestManager shareMgpManager];

    [manager post:eos_abi_json_to_bin paramters:dic success:^(BOOL isSuccess, id responseObject) {
        
        if (isSuccess) {
            handler(responseObject);
        }
    } failure:^(NSError *error) {
        handler(nil);
        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
        NSLog(@"error--%@",serializedData);
        NSDictionary *err = [serializedData objectForKey:@"error"];
        NSArray *detail = [err objectForKey:@"details"];
        NSString *mesg = [[detail[0] objectForKey:@"message"] copy];
        [[[UIApplication sharedApplication].windows lastObject] showMsg:mesg];
    } superView:nil showFaliureDescription:YES];
    
}

#pragma mark - 获取帐号信息
- (void)getAccountSuccess:(void(^)(id response))handler {
    NSString *account = [self.wallet.walletName componentsSeparatedByString:@"_"].lastObject;
    NSDictionary *dic = @{@"account_name":account};
    HTTPRequestManager *manager = self.wallet.coinType == EOS ? [HTTPRequestManager shareEosManager] : [HTTPRequestManager shareMgpManager];

    [manager post:eos_get_account paramters:dic success:^(BOOL isSuccess, id responseObject) {
        
        if (isSuccess) {
            handler(responseObject);
            
        }
    } failure:^(NSError *error) {
        handler(nil);
        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
        NSLog(@"error--%@",serializedData);
        NSDictionary *err = [serializedData objectForKey:@"error"];
        NSArray *detail = [err objectForKey:@"details"];
        NSString *mesg = [[detail[0] objectForKey:@"message"] copy];
        [[[UIApplication sharedApplication].windows lastObject] showMsg:mesg];
        NSLog(@"URL_GET_INFO_ERROR ==== %@",error.description);
    } superView:nil showFaliureDescription:YES];
}


#pragma mark - 获取最新区块

- (void)getInfoSuccess:(void(^)(id response))handler {
    HTTPRequestManager *manager = self.wallet.coinType == EOS ? [HTTPRequestManager shareEosManager] : [HTTPRequestManager shareMgpManager];
    [manager post:eos_get_info paramters:nil success:^(BOOL isSuccess, id responseObject) {
        
        if (isSuccess) {
            handler(responseObject);
        }
    } failure:^(NSError *error) {
        handler(nil);
        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
        NSLog(@"error--%@",serializedData);
        NSDictionary *err = [serializedData objectForKey:@"error"];
        NSArray *detail = [err objectForKey:@"details"];
        NSString *mesg = [[detail[0] objectForKey:@"message"] copy];
        [[[UIApplication sharedApplication].windows lastObject] showMsg:mesg];
        NSLog(@"URL_GET_INFO_ERROR ==== %@",error.description);
    } superView:nil showFaliureDescription:YES];
    
}

#pragma mark - 获取公钥

- (void)getRequiredPublicKeyRequestOperationSuccess:(void(^)(id response))handler {
    NSLog(@"URL_GET_REQUIRED_KEYS parameters ============ %@",[[self getPramatersForRequiredKeys] modelToJSONString]);
    HTTPRequestManager *manager = self.wallet.coinType == EOS ? [HTTPRequestManager shareEosManager] : [HTTPRequestManager shareMgpManager];

    [manager post:eos_get_required_keys paramters:[self getPramatersForRequiredKeys] success:^(BOOL isSuccess, id responseObject) {
        
        if (isSuccess) {
            handler(responseObject);
        }
    } failure:^(NSError *error) {
        handler(nil);
        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
        NSLog(@"error--%@",serializedData);
        NSDictionary *err = [serializedData objectForKey:@"error"];
        NSArray *detail = [err objectForKey:@"details"];
        NSString *mesg = [[detail[0] objectForKey:@"message"] copy];
        [[[UIApplication sharedApplication].windows lastObject] showMsg:mesg];

    } superView:nil showFaliureDescription:YES];
    
    
}
#pragma mark -----df

- (void)pushTransactionRequestOperationSuccess:(void(^)(id response))handler {
    
    // NSDictionary *transacDic = [self getPramatersForRequiredKeys];
    NSString *wif = self.wallet.privateKey;
    const int8_t *private_key = [[EosEncode getRandomBytesDataWithWif:wif] bytes];
    if (!private_key) {
        return;
    }
    if (![self.wallet.publicKey isEqualToString:self.required_Publickey] && self.wallet.coinType == MIS) {
//        [self.view showMsg:NSLocalizedString(@"EOS公钥不匹配！", nil)];
    }
    NSString *signatureStr = @"";
    NSString *packed_trxHexStr = @"";
    
    NSData *d = [EosByteWriter getBytesForSignature:self.chain_Id andParams:[[self getPramatersForRequiredKeys] objectForKey:@"transaction"] andCapacity:255];
    signatureStr = [EosSignature initWithbytesForSignature:d privateKey:(int8_t *)private_key];
    packed_trxHexStr = [[EosByteWriter getBytesForSignature:nil andParams:[[self getPramatersForRequiredKeys] objectForKey:@"transaction"] andCapacity:512] hexadecimalString];
    
    
    NSMutableDictionary *pushDic = [NSMutableDictionary dictionary];
    [pushDic setObject:VALIDATE_STRING(packed_trxHexStr) forKey:@"packed_trx"];
    [pushDic setObject:@[signatureStr] forKey:@"signatures"];
    [pushDic setObject:@"none" forKey:@"compression"];
    [pushDic setObject:@"" forKey:@"packed_context_free_data"];
    NSLog(@"push = \n%@",pushDic);
    MJWeakSelf
    HTTPRequestManager *manager = self.wallet.coinType == EOS ? [HTTPRequestManager shareEosManager] : [HTTPRequestManager shareMgpManager];

    [manager post:eos_push_transaction paramters:pushDic success:^(BOOL isSuccess, id responseObject) {
        NSLog(@"tran response %@",responseObject);
        if (isSuccess) {
            handler(responseObject);
            
        }
    } failure:^(NSError *error) {
        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
        NSLog(@"error--%@",serializedData);
        NSDictionary *err = [serializedData objectForKey:@"error"];
        NSArray *detail = [err objectForKey:@"details"];
        NSString *mesg = [[detail[0] objectForKey:@"message"] copy];
        [[[UIApplication sharedApplication].windows lastObject] showMsg:mesg];

    } superView:nil showFaliureDescription:YES];
    
    
    
}


- (NSDictionary *)getPramatersForRequiredKeys {
    NSString *from = self.wallet.address;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *transacDic = [NSMutableDictionary dictionary];
    [transacDic setObject:VALIDATE_STRING(self.ref_block_prefix) forKey:@"ref_block_prefix"];
    [transacDic setObject:VALIDATE_STRING(self.ref_block_num) forKey:@"ref_block_num"];
    [transacDic setObject:VALIDATE_STRING(self.expiration) forKey:@"expiration"];
    
    [transacDic setObject:@[] forKey:@"context_free_data"];
    [transacDic setObject:@[] forKey:@"signatures"];
    [transacDic setObject:@[] forKey:@"context_free_actions"];
    [transacDic setObject:@0 forKey:@"delay_sec"];
    [transacDic setObject:@0 forKey:@"max_cpu_usage_ms"];//max_cpu_usage_ms  max_kcpu_usage
    [transacDic setObject:@0 forKey:@"max_net_usage_words"];
    
    
    NSMutableDictionary *actionDict = [NSMutableDictionary dictionary];
//    [actionDict setObject:@"eosio.token" forKey:@"account"];
//    [actionDict setObject:@"transfer" forKey:@"name"];
    [actionDict setObject:self.code forKey:@"account"];
    [actionDict setObject:self.action forKey:@"name"];
    [actionDict setObject:VALIDATE_STRING(self.binargs) forKey:@"data"];
    
    NSMutableDictionary *authorizationDict = [NSMutableDictionary dictionary];
    [authorizationDict setObject:from forKey:@"actor"];
    [authorizationDict setObject:@"active" forKey:@"permission"];
    [actionDict setObject:@[authorizationDict] forKey:@"authorization"];
    [transacDic setObject:@[actionDict] forKey:@"actions"];
    
    [params setObject:transacDic forKey:@"transaction"];
    
    [params setObject:@[self.wallet.publicKey] forKey:@"available_keys"];
    return params;
    
}
#pragma mark - Get Paramter

- (NSDictionary *)getAbiJsonToBinParamters {
    // 交易JSON序列化
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject: self.code forKey:@"code"];
    [params setObject:self.action forKey:@"action"];
    [params setObject:self.parameter forKey:@"args"];

    return params;
}


#pragma mark - getter

- (JSContext *)context {
    if (!_context) {
        _context = [[JSContext alloc] init];
    }
    return _context;
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

//数组转为json字符串
- (NSString *)arrayToJSONString:(NSArray *)array {
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *jsonTemp = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return jsonTemp;
}


@end
