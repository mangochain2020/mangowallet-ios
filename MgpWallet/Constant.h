//
//  Constant.h
//  TaiYiToken
//
//  Created by Frued on 2018/8/13.
//  Copyright © 2018年 Frued. All rights reserved.
//

#ifndef Constant_h
#define Constant_h
/**
 *  window object
 */
#define WINDOW [[[UIApplication sharedApplication] delegate] window]


/**
 *  object is not nil and null
 */
#define NotNilAndNull(_ref)  (((_ref) != nil) && (![(_ref) isEqual:[NSNull null]]))

/**
 *  object is nil or null
 */
#define IsNilOrNull(_ref)   (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) || ([(_ref) isEqual:[NSNull class]]))

/**
 *  string is nil or null or empty
 */
#define IsStrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref)isEqualToString:@""]))

/**
 *  Array is nil or null or empty
 */
#define IsArrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref) count] == 0))

/**
 *  validate string
 */
#define VALIDATE_STRING(str) (IsNilOrNull(str) ? @"" : str)

/**
 *  update string
 */
#define UPDATE_STRING(old, new) ((IsNilOrNull(new) || IsStrEmpty(new)) ? old : new)

/**
 *  validate NSNumber
 */
#define VALIDATE_NUMBER(number) (IsNilOrNull(number) ? @0 : number)

/**
 *  update NSNumber
 */
#define UPDATE_NUMBER(old, new) (IsNilOrNull(new) ? old : new)

/**
 *  validate NSArray
 */
#define VALIDATE_ARRAY(arr) (IsNilOrNull(arr) ? [NSArray array] : arr)

 /** 获取APP名称 */

#define APP_NAME ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"])

/** 程序版本号 */

#define APP_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

/** 获取APP build版本 */

#define APP_BUILD ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"])



/**
 *  validate NSMutableArray
 */
#define VALIDATE_MUTABLEARRAY(arr) (IsNilOrNull(arr) ? [NSMutableArray array] :     [NSMutableArray arrayWithArray: arr])
/**
 *  statusbar height
 */

typedef enum {
    BTC = 0,
    BTC_TESTNET = 1,
    USDT = 333,
    ETH = 60,
    MIS = 111,
    MGP = 200,
    EOS = 44,
    DAPP = 250,
    NOTDEFAULT = 260,
}CoinType;


typedef enum {
    ONE_MIN = 0,
    FIVE_MIN = 1,
    FIFTEEN_MIN = 2,
    THIRTY_MIN = 3,
    ONE_HOUR = 4,
    ONE_DAY = 5,
    ONE_WEEK = 6,
    ONE_MON = 7,
    ONE_YEAR = 8
}KLineType;

typedef enum {
    SELF_CHOOSE = 0,
    BTC_CHOOSE = 1,
    ETH_CHOOSE = 2,
    HT_CHOOSE = 3,
    USDT_CHOOSE = 4,
    SEARCH_CHOOSE = 5,
}MarketSelectType;

typedef enum : NSUInteger {
    BTCAPIChain,
    BTCAPIBlockchain,
} BTCAPI;

typedef enum : NSUInteger {
    IMPORT_WALLET = 0,
    LOCAL_WALLET = 1,
} WALLET_TYPE;

typedef enum : NSUInteger {
    LOCAL_CREATED_WALLET = 0,
    IMPORT_BY_MNEMONIC = 1,
    IMPORT_BY_KEYSTORE = 2,
    IMPORT_BY_PRIVATEKEY = 3,
} IMPORT_WALLET_TYPE;

typedef enum {
    OUT_Trans   = 1,
    IN_Trans    = 2,
    FAILD_Trans = 3,
    SELF_Trans  = 4,
}TranResultSelectType;

typedef enum {
    EOS_ACTIVE_KEY   = 1,
    EOS_OWNER_KEY    = 2,
}EOSKeyType;


typedef enum {
    SMS_Code   = 0,
    MAIL_Code    = 1,
}VerifyCodeType;

typedef enum{
    WALLET_SELECT_ALL = 0,
    WALLET_SELECT_MIS = 1,
    WALLET_SELECT_OTHERS = 2,
} WALLET_SELECT_TYPE;

typedef enum {
    SELFCHOOSE_SEARCH   = 0,
    MARKETVALUE_SEARCH    = 1,
    USDT_SEARCH = 2,
    BTC_SEARCH = 3,
    ETH_SEARCH = 4,
    HT_SEARCH = 5,
}MarketSearchType;

typedef enum {
    RISE_SORT   = 0,
    DOWN_SORT    = 0,
    IN_SORT = 0,
    OUT_SORT = 0,
    PLATE_SORT = 1,
}MarketSortSearchType;

typedef enum {
    USD_TYPE   = 0,
    CHY_TYPE    = 1,
}LangeuageType;

typedef enum {
    NONE_SELECT = 0,
    UP_SELECT = 1,
    DOWN_SELECT = 2,
}BTN_SELECT_TYPE;

typedef enum {
    NONE_SORT = 0,
    CHANGE_UP_SORT = 1,//
    CHANGE_DOWN_SORT = 2,
    LATESTPRICE_UP_SORT = 3,//
    LATESTPRICE_DOWN_SORT = 4,
    MARKETVALUE_SORT = 5,
    VOLUME_SORT = 6
}MARKETLIST_SORT_TYPE;

typedef enum {
    USERIDENTITY_VERIFY_NONE = 0,//未验证
    USERIDENTITY_VERIFY_FAILD = 1,
    USERIDENTITY_VERIFY_SUCCESS = 2,
}USERIDENTITY_VERIFY_STATUS;

typedef enum {
    lANGUAGE_CONFIG_TYPE = 0,
    COIN_CONFIG_TYPE = 1,
    NODE_CONFIG_TYPE = 2
} CONFIG_TYPE;

typedef enum {
    EXCHANGE_ID_HuoBi = 1,
    EXCHANGE_ID_FCoin = 2,
    EXCHANGE_ID_OKex = 3
} EXCHANGE_ID;

typedef enum {
    CREATE_LOG_TYPE = 0,
    IMPORT_LOG_TYPE = 1
} ADDACCOUNT_LOG_RECORD_TYPE;

typedef enum {
    HUOBI_GET = 0,
    HUOBI_POST = 1
} HUOBI_REQUEST_METHOD;

typedef enum {
    HUOBI_submitted = 0,
    HUOBI_partial_filled = 1,
    HUOBI_partial_canceled  = 2,
    HUOBI_filled = 3,
    HUOBI_canceled  = 4,
} HUOBI_Order_States;
//订单类型 1、限价买入：buy-limit；2、限价卖出：sell-limit；3、市价买入：buy-market；4：市价卖出：sell-market
typedef enum {
    HUOBI_OrderType_buy_limit = 0,
    HUOBI_OrderType_sell_limit = 1,
    HUOBI_OrderType_buy_market  = 2,
    HUOBI_OrderType_sell_market = 3,
} HUOBI_Order_Type;

typedef enum {
    HUOBI_Default_Type = 0,
    HUOBI_Buy_Type = 1,
    HUOBI_Sale_Type  = 2,
} HUOBI_PriceDataShowType;

typedef enum {
    HuobiCurrentOrderType = 0,
    HuobiHistoryOrderType = 1,
} HUOBI_OrdersShowType;

///分类（1-最新 2-政策 3-币圈 4-链圈 5-矿圈）/
typedef enum {
    InfoListType_Latest = 1,
    InfoListType_Policy = 2,
    InfoListType_Coins = 3,
    InfoListType_Chains = 4,
    InfoListType_Mines = 5,
} InfoListType;


#endif /* Constant_h */
