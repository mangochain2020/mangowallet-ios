//
//  DCWalletTool.m
//  TaiYiToken
//
//  Created by mac on 2021/1/12.
//  Copyright © 2021 admin. All rights reserved.
//

#import "DCWalletTool.h"

#import "BlockChain.h"


@interface DCWalletTool ()

//MGP EOS trans
@property (nonatomic, strong) JSContext *context;

@property (nonatomic, copy) NSString *ref_block_prefix;
@property (nonatomic, copy) NSString *ref_block_num;
@property (nonatomic, strong) NSData *chain_Id;
@property (nonatomic, copy) NSString *expiration;
@property (nonatomic, copy) NSString *required_Publickey;

@property(nonatomic,strong)MissionWallet *wallet;

@property (nonatomic, strong) NSArray *parameters;
@property (nonatomic, strong) NSMutableArray *binargs_arr;



@end


@implementation DCWalletTool
static DCWalletTool * defualt_shareMananger = nil;

+ (instancetype)shareManager {
    //_dispatch_once(&onceToken, ^{
    if (defualt_shareMananger == nil) {
        defualt_shareMananger = [[self alloc] init];
    }
   // });
    return defualt_shareMananger;
}




- (void)contractParameters:(NSArray *)parameters andPassWord:(NSString *)passWord completionHandler:(void (^)(id responseObj, NSError *error))handler{
    self.parameters = parameters;
    self.binargs_arr = [NSMutableArray array];
    
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
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_group_t group = dispatch_group_create();
    
    
    for (int i = 0; i < parameters.count; i++) {
        dispatch_group_enter(group);//
        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [self getJson:[self getAbiJsonToBinParamter][i] Binargs:^(id response) {
                if ([response isKindOfClass:[NSDictionary class]]) {
                    dispatch_group_leave(group);
                    NSDictionary *d = (NSDictionary *)response;
                    [weakSelf.binargs_arr addObject:[d objectForKey:@"binargs"]];
                }
            }];
        });
    }
    //二个网络请求都完成统一处理
    dispatch_group_notify(group, queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{

            [weakSelf getInfoSuccess:^(id response) {
                if (response != nil) {
                    BlockChain *model = [BlockChain parse:response];// [@"data"]
                    weakSelf.expiration = [[[NSDate dateFromString: model.head_block_time] dateByAddingTimeInterval: 30] formatterToISO8601];
                    weakSelf.ref_block_num = [NSString stringWithFormat:@"%@",model.head_block_num];
                    
                    NSString *js = @"function readUint32( tid, data, offset ){var hexNum= data.substring(2*offset+6,2*offset+8)+data.substring(2*offset+4,2*offset+6)+data.substring(2*offset+2,2*offset+4)+data.substring(2*offset,2*offset+2);var ret = parseInt(hexNum,16).toString(10);return(ret)}";
                    [weakSelf.context evaluateScript:js];
                    //读区块id，转化成**格式  ref_block_prefix: 515467051
                    JSValue *n = [weakSelf.context[@"readUint32"] callWithArguments:@[@8,VALIDATE_STRING(model.head_block_id) , @8]];
                    weakSelf.ref_block_prefix = [n toString];
                    weakSelf.chain_Id = [NSData convertHexStrToData:model.chain_id];
                    NSLog(@"get_block_info_success:%@, %@---%@-%@", weakSelf.expiration , weakSelf.ref_block_num, weakSelf.ref_block_prefix, weakSelf.chain_Id);
                    [weakSelf getRequiredPublicKeyRequestOperationSuccess:^(id response) {
                        if ([response isKindOfClass:[NSDictionary class]]) {
                            weakSelf.required_Publickey = response[@"required_keys"][0];
                            //具体交易签名广播
                            [weakSelf pushTransactionRequestOperationSuccess:^(id response) {
                                if ([response isKindOfClass:[NSDictionary class]]) {
                                    NSMutableDictionary *dic;
                                    dic = [response mutableCopy];
                                    handler(dic[@"transaction_id"],nil);
                                }
                            }];
                        }
                    }];
                }
                            
            }];
        });
    });
    
    
    
    
    
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
        NSLog(@"URL_GET_REQUIRED_KEYS ==== %@",error.description);
    } superView:nil showFaliureDescription:YES];
    
}




- (NSDictionary *)getPramatersForRequiredKeys {
    NSString *from = VALIDATE_STRING(self.wallet.address);
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
    
    if (self.parameters.count == self.binargs_arr.count){
        NSMutableArray *transactionDict = [NSMutableArray array];
        NSMutableArray *availableDict = [NSMutableArray array];


        for (int i = 0; i < self.parameters.count; i++) {
            NSMutableDictionary *parameterDict = self.parameters[i];
            NSMutableDictionary *actionDict = [NSMutableDictionary dictionary];
            [actionDict setObject:parameterDict[@"code"] forKey:@"account"];

            NSDictionary *parametersDic = self.parameters[i];
            NSString *binargsStr = self.binargs_arr[i];
            [actionDict setObject:parametersDic[@"action"] forKey:@"name"];
            [actionDict setObject:VALIDATE_STRING(binargsStr) forKey:@"data"];

            NSMutableDictionary *authorizationDict = [NSMutableDictionary dictionary];
            [authorizationDict setObject:from forKey:@"actor"];
            [authorizationDict setObject:@"active" forKey:@"permission"];
            
            [actionDict setObject:@[authorizationDict] forKey:@"authorization"];

            [transactionDict addObject:actionDict];
            [availableDict addObject:self.wallet.publicKey];

        }
        [transacDic setObject:transactionDict forKey:@"actions"];
        
        [params setObject:transacDic forKey:@"transaction"];
        
        [params setObject:availableDict forKey:@"available_keys"];
        
        
    }else{
        NSLog(@"URL_GET_REQUIRED_KEYS ==== 参数个数不一致");
    }
    
    return params;
}


#pragma mark -
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
        NSLog(@"pushTransactionRequestOperationSuccess ============ %@",[responseObject modelToJSONString]);
        if (isSuccess) {
            handler(responseObject);
            
        }
    } failure:^(NSError *error) {
        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
        NSLog(@"responseObject----error--%@",serializedData);
        NSDictionary *err = [serializedData objectForKey:@"error"];
        NSArray *detail = [err objectForKey:@"details"];
        NSString *mesg = [[detail[0] objectForKey:@"message"] copy];
        [[[UIApplication sharedApplication].windows lastObject] showMsg:mesg];

    } superView:nil showFaliureDescription:YES];
    
    
    
}



- (NSArray *)getAbiJsonToBinParamter {
    // 交易JSON序列化
    NSMutableArray *temp = [NSMutableArray array];
    for (NSDictionary *dic in self.parameters) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:dic[@"code"] forKey:@"code"];
        [params setObject:dic[@"action"] forKey:@"action"];
        [params setObject:dic[@"parameter"] forKey:@"args"];
        [temp addObject:params];
    }
    return temp;
}


#pragma mark - getter

- (JSContext *)context {
    if (!_context) {
        _context = [[JSContext alloc] init];
    }
    return _context;
}

-(NSString *)convertToJsonData:(NSDictionary *)dict{

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
