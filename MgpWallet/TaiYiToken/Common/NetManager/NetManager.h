//
//  NetManager.h
//  TRProject


#import "BaseNetworking.h"
#import "Constant.h"
#import <ethers/Account.h>
#import "IPAddressGet.h"
@interface NetManager : BaseNetworking
//******************  新接口 ****************
//获取时间戳
+(NSString *)getNowTimeTimestamp;
/*
 三个基本参数（若需要）+ 请求带有的参数
("userid", "0");
("usertoken", "");
("timestamp", "");
 dic中传入请求本身参数
 */
+(NSString *)signParams:(NSDictionary *)dic;

/*
 用户注册
 */
+(void)RegisterAccountWithLoginName:(NSString*)loginName Password:(NSString *)password PasswordConfirm:(NSString *)passwordConfirm completionHandler:(void (^)(id responseObj, NSError *error))handler;
/*
 用户登录
 */
+(void)LoginWithLoginName:(NSString*)loginName Password:(NSString *)password completionHandler:(void (^)(id responseObj, NSError *error))handler;

/*
 发送验证码
 safeCode :安全码，超过3次必须填写,防止短信被刷
 */
+(void)SendVerifyCodeWithType:(VerifyCodeType)type MobileORMail:(NSString *)mobileOrMail  CheckDevice:(BOOL)checkDevice  SafeCode:(NSString *)safeCode completionHandler:(void (^)(id responseObj, NSError *error))handler;

/*
 绑定手机
 */
+(void)BindMobileWithMobile:(NSString *)mobile VerifyCode:(NSString *)verifyCode completionHandler:(void (^)(id responseObj, NSError *error))handler;

/*
 绑定邮箱
 */
+(void)BindMailWithMail:(NSString *)mail VerifyCode:(NSString *)verifyCode completionHandler:(void (^)(id responseObj, NSError *error))handler;

/*
 重置密码
 */
+(void)ResetPassWordWithPassword:(NSString *)password PasswordConfirm:(NSString *)passwordConfirm completionHandler:(void (^)(id responseObj, NSError *error))handler;

/*
 修改密码
 */
+(void)ModifyPassWordWithOldPassword:(NSString *)oldpassword NewPassword:(NSString *)newpassword completionHandler:(void (^)(id responseObj, NSError *error))handler;

/*
 系统初始化
 返回 eth节点,btc节点,eos节点,mis节点
 */
+(void)SysInitCompletionHandler:(void (^)(id responseObj, NSError *error))handler;

/*
 获取收益
 返回 涨跌幅 涨跌额
 */
+(void)GetProfitCompletionHandler:(void (^)(id responseObj, NSError *error))handler;

/*
 行情列表
 */
+(void)GetMarketListWithSearchType:(MarketSearchType)searchType MySymbol:(NSString *)mySymbol Lang:(LangeuageType)lang completionHandler:(void (^)(id responseObj, NSError *error))handler;

/*
 排行榜
 plateId  板块Id,如果是根据板块则必填
 */
+(void)GetMarketListSortWithSortSearchType:(MarketSortSearchType)searchType PlateId:(NSString *)plateId Lang:(LangeuageType)lang completionHandler:(void (^)(id responseObj, NSError *error))handler;

/*
 综合市场
 */
+(void)GetMarketComprehensiveWithLang:(LangeuageType)lang completionHandler:(void (^)(id responseObj, NSError *error))handler;

/*
 板块列表
 */
+(void)GetPlateListCompletionHandler:(void (^)(id responseObj, NSError *error))handler;

/*
 各种汇率
 */
+(void)GetMissionRateCompletionHandler:(void (^)(id responseObj, NSError *error))handler;

/*
 币种信息
 */
+(void)GetSymbolInfoWithSearchSymbol:(NSString *)searchSymbol kLineType:(KLineType)kLineType Lang:(LangeuageType)lang completionHandler:(void (^)(id responseObj, NSError *error))handler;


/*
 项目介绍
 */
+(void)GetMarketBaseInfoWithMySymbol:(NSString *)mySymbol Lang:(LangeuageType)lang completionHandler:(void (^)(id responseObj, NSError *error))handler;

///*
// 获取所有交易对
// */
//+(void)GetSymbolCompletionHandler:(void (^)(id responseObj, NSError *error))handler;

/*
 创建MIS钱包
 */
+(void)CreateAccountWithAccountName:(NSString *)accountName publickey:(NSString *)publickey nodeUrl:(NSString *)nodeUrl completionHandler:(void (^)(id responseObj, NSError *error))handler;

/*
 获取所有币种
 */
+(void)GetALLCOINCompletionHandler:(void (^)(id responseObj, NSError *error))handler;

/*
 获取当前登录用户
 */
+(void)GETCurrentLoginUserCompletionHandler:(void (^)(id responseObj, NSError *error))handler;


/*
 人脸识别
 */
+(void)FaceCompareWithIdFront:(UIImage *)front IdRevers:(UIImage *)revers Face:(UIImage *)face CompletionHandler:(void (^)(id responseObj, NSError *error))handler;

/*
 人脸识别
 */
+(void)FaceCompareDataWithIdFront:(NSString *)front IdRevers:(NSString *)revers Face:(NSString *)face CompletionHandler:(void (^)(id responseObj, NSError *error))handler;

/*
 交易数据统计
 */
+(void)AddTradeWithuserName:(NSString *)userName TradeAmount:(CGFloat)tradeAmount Poundage:(CGFloat)poundage CoinCode:(NSString *)coinCode From:(NSString *)fromToken To:(NSString *)toToken  CompletionHandler:(void (^)(id responseObj, NSError *error))handler;

/*
 保存账号创建导入记录
 */
+(void)AddAccountLogWithuserName:(NSString *)userName AccountInfo:(NSString *)accountInfo RecordType:(ADDACCOUNT_LOG_RECORD_TYPE)recordType CompletionHandler:(void (^)(id responseObj, NSError *error))handler;

/*
 人物标签
 */
+(void)GETUserTagCompletionHandler:(void (^)(id responseObj, NSError *error))handler;

//*****************  行情版本2  **********************
/*
 委买委卖列表
 */
+(void)GetBusinessWithMySymbol:(NSString *)mySymbol Lang:(LangeuageType)lang ExchangeId:(NSInteger)exchangeid completionHandler:(void (^)(id responseObj, NSError *error))handler;

/*
 市值列表接口
 */
+(void)GetMarketTicketsPage:(NSInteger)pageindex PageSize:(NSInteger)pagesize Lang:(LangeuageType)lang completionHandler:(void (^)(id responseObj, NSError *error))handler;

/*
 自选列表接口
 */
+(void)GetOptionalListMySymbol:(NSString *)mySymbol  Lang:(LangeuageType)lang completionHandler:(void (^)(id responseObj, NSError *error))handler;


/*
 币种详情接口
 */
+(void)GetCoinPriceInfoCoinCode:(NSString *)coinCode kLineType:(KLineType)kLineType  Lang:(LangeuageType)lang  ExchangeId:(NSInteger)exchangeid  completionHandler:(void (^)(id responseObj, NSError *error))handler;




//******************  行情 ****************
//+(id)GETCurrencyListWithMySymbol:(NSString *)mySymbol  completionHandler:(void (^)(id responseObj, NSError *error))handler;
//+(void)GETKLineWthkSearchSymbol:(NSString*)symbol LineType:(KLineType)kLineType searchNum:(NSInteger)searchNum completionHandler:(void (^)(id responseObj, NSError *error))handler;
////汇率
//+(void)GetAllCurrencyCompletionHandler:(void (^)(id responseObj, NSError *error))handler;


//****************** BTC交易 ****************
//比特币美元汇率
+(void)GetCurrencyCompletionHandler:(void (^)(id responseObj, NSError *error))handler;
//BTC查询余额
+(void)GetBalanceForBTCAdress:(NSString *)address noTxList:(int)noTxList completionHandler:(void (^)(id responseObj, NSError *error))handler;
//BTC获取交易列表
+(void)GetTXListBTCAdress:(NSString *)address pageNum:(int)pageNum completionHandler:(void (^)(id responseObj, NSError *error))handler;
//获取交易详情
+(void)GetTXDetailByTXID:(NSString *)txid completionHandler:(void (^)(id responseObj, NSError *error))handler;
//获取UTXO
+(void)GetUTXOByBTCAdress:(NSString *)address completionHandler:(void (^)(id responseObj, NSError *error))handler;
//交易广播 Rawtx参数为交易信息签名
+(void)BroadcastBTCTransactionData:(NSString *)transaction completionHandler:(void (^)(id responseObj, NSError *error))handler;

//***************** BTC Txlist BlockChain *************
+(void)GetBTCTxFromBlockChainAddress:(NSString *)address PageSize:(NSInteger)n Offset:(NSInteger)offset completionHandler:(void (^)(id responseObj, NSError *error))handler;

+(void)GetBTCUTXOFromBlockChainAddress:(NSString *)address MinumConfirmations:(NSInteger)confirmations completionHandler:(void (^)(id responseObj, NSError *error))handler;

//****************** ETH交易状态查询 ****************
+(void)GetETHTraRecordStatusWithHash:(NSString *)hash Check:(BOOL)checkcontract completionHandler:(void (^)(id responseObj, NSError *error))handler;

+(void)VerifyIFAddressIsContract:(NSString *)address completionHandler:(void (^)(id responseObj, NSError *error))handler;

+(void)GetETHTransWithHash:(NSString *)hash completionHandler:(void (^)(id responseObj, NSError *error))handler;

+(void)GetETHGasPriceCompletionHandler:(void (^)(id responseObj, NSError *error))handler;

+(void)GetWalletPrice:(NSString *)coinType completionHandler:(void (^)(id responseObj, NSError *error))handler;
//获取链ID
+(void)getChainIdHandler:(void (^)(id responseObj, NSError *error))handler;

/**
 获取ETH交易记录
 */
+(void)GetETHAccounttxList:(NSString *)address CompletionHandler:(void (^)(id responseObj, NSError *error))handler;



// *******************************  USDT **********************************
/*
 Returns the balance information for a given address. For multiple addresses in a single query use the v2 endpoint
 */
+(void)RequestUSDT_BalanceAddress:(NSString *)addr CompletionHandler:(void (^)(id responseObj, NSError *error))handler;

/*https://api.omniwallet.org/v2/address/addr=1FoWyxwPXuj4C6abqwhjDWdz6D4PZgYRjA&addr=1KYiKJEfdJtap9QX2v9BXJMpz2SfU4pgZw
 addr=1FoWyxwPXuj4C6abqwhjDWdz6D4PZgYRjA&addr=1KYiKJEfdJtap9QX2v9BXJMpz2SfU4pgZw" "https://api.omniwallet.org/v2/address/addr/"
 */
//addr
+(void)RequestUSDT_BalanceMutiAddress:(NSString *)addr CompletionHandler:(void (^)(id responseObj, NSError *error))handler;
/*
 Returns the balance information and transaction history list for a given address
 */
+(void)RequestUSDT_AddressDetails:(NSString *)addr CompletionHandler:(void (^)(id responseObj, NSError *error))handler;
/*
 Decodes raw hex returning Omni and Bitcoin transaction information
 */
+(void)DecodeUSDTTxHex:(NSString *)hex CompletionHandler:(void (^)(id responseObj, NSError *error))handler;

/*
 Returns list of transactions for queried address. Data: addr : address to query page : cycle through available response pages (10 txs per page)
 */
+(void)RequestUSDTTxListForAddress:(NSString *)addr Page:(NSInteger)page CompletionHandler:(void (^)(id responseObj, NSError *error))handler;
/*
 Broadcast a signed transaction to the network. Data: signedTransaction : signed hex to broadcast
 */
+(void)PushUSDT_Tx:(NSString *)hexstr CompletionHandler:(void (^)(id responseObj, NSError *error))handler;

/*
 Returns transaction details of a queried transaction hash.
 */
+(void)GetUSDTTxDetail:(NSString *)hexstr CompletionHandler:(void (^)(id responseObj, NSError *error))handler;
/*
 资讯
 */
//资讯列表分页查询
+(void)GetInfoListType:(NSInteger)type CurrentPage:(NSInteger)page CompletionHandler:(void (^)(id responseObj, NSError *error))handler;

//资讯详情页接口
+(void)GetInfoDetailUserID:(NSString *)userId NewsID:(NSString *)newsId CompletionHandler:(void (^)(id responseObj, NSError *error))handler;

//资讯添加收藏接口
+(void)GetInfoAddCollectionUserID:(NSString *)userId NewsID:(NSString *)newsId CompletionHandler:(void (^)(id responseObj, NSError *error))handler;

//资讯删除收藏接口
+(void)GetInfoDeleteCollectionUserID:(NSString *)userId NewsID:(NSString *)newsId CompletionHandler:(void (^)(id responseObj, NSError *error))handler;

//资讯收藏查询接口
+(void)GetInfoCollectionListUserID:(NSString *)userId CurrentPage:(NSInteger)page CompletionHandler:(void (^)(id responseObj, NSError *error))handler;

//资讯批量删除收藏接口
+(void)GetInfoDelBatchCollectionUserID:(NSString *)userId NewsID:(NSString *)newsId CompletionHandler:(void (^)(id responseObj, NSError *error))handler;
@end
