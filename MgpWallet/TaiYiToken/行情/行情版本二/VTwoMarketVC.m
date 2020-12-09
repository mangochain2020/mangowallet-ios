//
//  VTMarketVC.m
//  TaiYiToken
//
//  Created by 张元一 on 2018/11/21.
//  Copyright © 2018 admin. All rights reserved.
//

#import "VTwoMarketVC.h"
#import "VTwoMarketListCell.h"
#import "ControlBtnsView.h"
#import "MarketThreeBtnView.h"
#import "MarketCell.h"
#import "EditSelfChooseVC.h"
#import "CustomizedNavigationController.h"
#import "SearchResultVC.h"
#import "SortTypeSelectView.h"
#import "VTwoMarketDetailVC.h"
#import "MarketTicketModel.h"
#import "CoinBaseInfoModel.h"
#import "AddSelfChooseCell.h"
@interface VTwoMarketVC ()<UITableViewDelegate,UITableViewDataSource>
//选择排序View

@property(nonatomic,strong)UIView *shadowView;
@property(nonatomic,strong)SortTypeSelectView *selectView;
@property(nonatomic,strong)NSMutableArray *searchdataArray;
@property(nonatomic,strong)NSMutableArray <MarketTicketModel *> *dataArray;
@property(nonatomic)UITableView *tableView;
@property(nonatomic,strong)UIButton *searchBtn;
@property(nonatomic,strong)SearchResultVC *searchVC;
@property(nonatomic)CGFloat RMBDollarCurrency;//人民币汇率

@property (nonatomic, strong)dispatch_source_t time;
@property(nonatomic)float TimeInterval;
//** view
@property(nonatomic,strong)ControlBtnsView *buttonView;
@property(nonatomic,strong)MarketThreeBtnView *tableheaderBtnView;
@property(nonatomic)LangeuageType currentLanguageType;
@property(nonatomic,strong)NSString *unitstr;
//** datasource
//当前选择
@property(nonatomic)MarketSearchType currentSelectedType;
//自选
@property(nonatomic)NSString *mysymbol;
//标记cell的rateBtn显示的数据，0 - priceChange/1 - amount
@property(nonatomic)int dataChoose;

//
@property(nonatomic)CGFloat BTCCurrency;//btc 美元汇率
@property(nonatomic)CGFloat ETHCurrency;
@property(nonatomic)CGFloat EOSCurrency;
@property(nonatomic)CGFloat MISCurrency;

//@property(nonatomic,copy)NSString *currentPlateName;//选择的交易所
@property(nonatomic)BOOL rateSortAdd;
@property(nonatomic)BOOL priceSortAdd;
@property(nonatomic)MARKETLIST_SORT_TYPE currentSortType;
@property(nonatomic)BOOL colorConfig;
@property(nonatomic)int page;
@property(nonatomic)LangeuageType unittype;

@property(nonatomic,strong)AddSelfChooseCell *addCell;
@end

@implementation VTwoMarketVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    self.navigationController.hidesBottomBarWhenPushed = YES;
    self.tabBarController.tabBar.hidden = NO;
    
    self.currentSortType = NONE_SORT;
    self.colorConfig = [[NSUserDefaults standardUserDefaults] boolForKey:@"RiseColorConfig"];
    
    [_buttonView resettitles:@[NSLocalizedString(@"自选", nil),NSLocalizedString(@"市值", nil)]];
    [self resetBtnsTag:self.currentSelectedType ifinit:YES];
    if(self.ifNeedRequestData == YES){
        self.TimeInterval = 8.0;
        [self InitTimerRequest];
        if(self.currentSelectedType == MARKETVALUE_SEARCH){
            if (self.dataArray == nil || self.dataArray.count == 0) {
                [self.view showMsg:NSLocalizedString(@"没有数据", nil)];
            }
        }
    }else{
        if (self.dataArray != nil) {
            [self.tableView reloadData];
        }
    }
    if ([_unitstr isEqualToString:@"rmb"]) {
        _unittype = CHY_TYPE;
    }else{
        _unittype = USD_TYPE;
    }
    [self GetALLCoins];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    if(self.ifNeedRequestData == YES){
        dispatch_cancel(self.time);
    }else{
        
    }
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.hidesBottomBarWhenPushed = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentSortType = NONE_SORT;
    [self GetCurrentRate];
    self.view.backgroundColor = [UIColor ExportBackgroundColor];
    self.mysymbol = @"";
    self.dataChoose = 0;
    self.rateSortAdd = NO;
    self.priceSortAdd = NO;
    if(self.ifNeedRequestData == YES){
        self.dataArray = [NSMutableArray new];
        self.searchdataArray = [NSMutableArray new];
        [self buttonView];
        [self tableheaderBtnView];
        [self setupHeadBtnView];
    }else{
        
    }
    NSString *currentLanguage = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLanguageSelected"];
    if(currentLanguage == nil){
        currentLanguage = @"chinese";
        [[NSUserDefaults standardUserDefaults] setObject:@"chinese" forKey:@"CurrentLanguageSelected"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    self.currentLanguageType = [currentLanguage isEqualToString:@"english"]?USD_TYPE:CHY_TYPE;
    _unitstr = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentCurrencySelected"];
    
    
    self.mysymbol = [[NSUserDefaults standardUserDefaults] objectForKey:@"MySymbol"];
    self.page = 1;
    MJWeakSelf
    [self.tableView addHeaderRefresh:^{
        weakSelf.page = 1;
        [weakSelf.dataArray removeAllObjects];
        if (self.currentSelectedType == SELFCHOOSE_SEARCH) {
            if (weakSelf.mysymbol.length < 2) {
                dispatch_async_on_main_queue(^{
                    
                    [weakSelf.tableView reloadData];
                });
                return ;
            }
            NSString *symbol = [weakSelf.mysymbol substringToIndex:weakSelf.mysymbol.length - 1];
            [NetManager GetOptionalListMySymbol:symbol Lang:weakSelf.currentLanguageType completionHandler:^(id responseObj, NSError *error) {
                [weakSelf.tableView endHeaderRefresh];
                if (!error) {
                    if (![[NSString stringWithFormat:@"%@",responseObj[@"resultCode"]] isEqualToString:@"20000"]) {
                        [weakSelf.view showAlert:[NSString stringWithFormat:@"Error:%ld",error.code] DetailMsg:responseObj[@"resultMsg"]];
                        return ;
                    }
                    NSArray *ddd = responseObj[@"data"];
                    if([ddd isEqual:[NSNull null]]){
                        [weakSelf.view showMsg:NSLocalizedString(@"没有数据", nil)];
                        return;
                    }
                    [weakSelf.dataArray removeAllObjects];
                    for (NSInteger i = 0; i < ddd.count; i++) {
                        MarketTicketModel *model = [MarketTicketModel parse:ddd[i]];
                        [weakSelf.dataArray addObject:model];
                    }
                   
                    //按自选名称排序
                    if (weakSelf.currentSelectedType != MARKETVALUE_SEARCH){
                        //按名称排序时，如果是自选，则按本地存储的自选顺序排序
                        if(weakSelf.currentSortType == NONE_SORT && self.currentSelectedType == SELFCHOOSE_SEARCH){
                            [weakSelf sortSelfChoose];
                        }else{
                            [weakSelf sortMarketListSortType:weakSelf.currentSortType];
                        }
                        
                    }else{
                        [weakSelf sortMarketListSortType:weakSelf.currentSortType];
                    }
                    [weakSelf.tableView reloadData];
                    
                }else{
                    [weakSelf.view showAlert:[NSString stringWithFormat:@"Error:%ld",error.code] DetailMsg:error.localizedDescription];
                }
            }];
        }else{
            NSLog(@"header page = %d",weakSelf.page);
            
            [NetManager GetMarketTicketsPage:weakSelf.page PageSize:20 Lang:weakSelf.currentLanguageType completionHandler:^(id responseObj, NSError *error) {
                [weakSelf.tableView endHeaderRefresh];
                if (!error) {
                    if (![[NSString stringWithFormat:@"%@",responseObj[@"resultCode"]] isEqualToString:@"20000"]) {
                        [weakSelf.view showAlert:[NSString stringWithFormat:@"Error:%ld",error.code] DetailMsg:responseObj[@"resultMsg"]];
                        return ;
                    }
                    NSArray *ddd = responseObj[@"data"];
                    if([ddd isEqual:[NSNull null]]){
                        [weakSelf.view showMsg:NSLocalizedString(@"没有数据", nil)];
                        return;
                    }
                    [weakSelf.dataArray removeAllObjects];
                    for (NSInteger i = 0; i < ddd.count; i++) {
                        MarketTicketModel *model = [MarketTicketModel parse:ddd[i]];
                        [weakSelf.dataArray addObject:model];
                    }
                    
                    //按自选名称排序
                    if (weakSelf.currentSelectedType != MARKETVALUE_SEARCH){
                        //按名称排序时，如果是自选，则按本地存储的自选顺序排序
                        if(weakSelf.currentSortType == NONE_SORT && weakSelf.currentSelectedType == SELFCHOOSE_SEARCH){
                            [weakSelf sortSelfChoose];
                        }else{
                            [weakSelf sortMarketListSortType:weakSelf.currentSortType];
                        }
                    }else{
                        [weakSelf sortMarketListSortType:weakSelf.currentSortType];
                    }
                    [weakSelf.tableView reloadData];
                    
                }else{
                    [weakSelf.view showAlert:[NSString stringWithFormat:@"Error:%ld",error.code] DetailMsg:error.localizedDescription];
                }
            }];
        }
        
    }];
    [self.tableView addFooterRefresh:^{
        if (self.currentSelectedType == SELFCHOOSE_SEARCH) {
            if (weakSelf.mysymbol.length < 2) {
                [weakSelf.dataArray removeAllObjects];
                dispatch_async_on_main_queue(^{
                    [weakSelf.tableView endFooterRefresh];
                    [weakSelf.tableView reloadData];
                });
                return ;
            }
            [NetManager GetOptionalListMySymbol:weakSelf.mysymbol Lang:weakSelf.currentLanguageType completionHandler:^(id responseObj, NSError *error) {
                [weakSelf.tableView endFooterRefresh];
                if (!error) {
                    if (![[NSString stringWithFormat:@"%@",responseObj[@"resultCode"]] isEqualToString:@"20000"]) {
                        [weakSelf.view showMsg:responseObj[@"resultMsg"]];
                        return ;
                    }
                    NSArray *ddd = responseObj[@"data"];
                    if([ddd isEqual:[NSNull null]]){
                        [weakSelf.view showMsg:NSLocalizedString(@"没有更多数据", nil)];
                        return;
                    }
                    [weakSelf.dataArray removeAllObjects];
                    for (NSInteger i = 0; i < ddd.count; i++) {
                        MarketTicketModel *model = [MarketTicketModel parse:ddd[i]];
                        [weakSelf.dataArray addObject:model];
                    }
                    //按自选名称排序
                    if (weakSelf.currentSelectedType != MARKETVALUE_SEARCH){
                        //按名称排序时，如果是自选，则按本地存储的自选顺序排序
                        if(weakSelf.currentSortType == NONE_SORT && weakSelf.currentSelectedType == SELFCHOOSE_SEARCH){
                            [weakSelf sortSelfChoose];
                        }else{
                            [weakSelf sortMarketListSortType:weakSelf.currentSortType];
                        }
                    }else{
                        [weakSelf sortMarketListSortType:weakSelf.currentSortType];
                    }
                    [weakSelf.tableView reloadData];
                    
                }else{
                    [weakSelf.view showAlert:[NSString stringWithFormat:@"Error:%ld",error.code] DetailMsg:error.localizedDescription];
                }
            }];
        }else{
            
            weakSelf.page ++;
            NSLog(@"foot page = %d",weakSelf.page);
            [NetManager GetMarketTicketsPage:weakSelf.page PageSize:20 Lang:weakSelf.currentLanguageType completionHandler:^(id responseObj, NSError *error) {
                [weakSelf.tableView endFooterRefresh];
                if (!error) {
                    if (![[NSString stringWithFormat:@"%@",responseObj[@"resultCode"]] isEqualToString:@"20000"]) {
                        [weakSelf.view showMsg:responseObj[@"resultMsg"]];
                        weakSelf.page --;
                        return ;
                    }
                    NSArray *ddd = responseObj[@"data"];
                    if([ddd isEqual:[NSNull null]]){
                        [weakSelf.view showMsg:NSLocalizedString(@"没有更多数据", nil)];
                        weakSelf.page --;
                        return;
                    }
                   
                    for (NSInteger i = 0; i < ddd.count; i++) {
                        MarketTicketModel *model = [MarketTicketModel parse:ddd[i]];
                        [weakSelf.dataArray addObject:model];
                    }
                    //按自选名称排序
                    if (weakSelf.currentSelectedType != MARKETVALUE_SEARCH){
                        //按名称排序时，如果是自选，则按本地存储的自选顺序排序
                        if(weakSelf.currentSortType == NONE_SORT && weakSelf.currentSelectedType == SELFCHOOSE_SEARCH){
                            [weakSelf sortSelfChoose];
                        }else{
                            [weakSelf sortMarketListSortType:weakSelf.currentSortType];
                        }
                    }else{
                        [weakSelf sortMarketListSortType:weakSelf.currentSortType];
                    }
                    [weakSelf.tableView reloadData];
                    
                }else{
                    [weakSelf.view showAlert:[NSString stringWithFormat:@"Error:%ld",error.code] DetailMsg:error.localizedDescription];
                }
            }];
        }
        
    }];
    
    [self.tableView beginHeaderRefresh];
}

#pragma 请求数据

-(void)GetCurrentRate{
    MJWeakSelf
    //汇率只获取一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NetManager GetMissionRateCompletionHandler:^(id responseObj, NSError *error) {
            if (!error) {
                /*{"code":0,"message":"成功","result":{"rmbRate":685.21002197265625,"btcToDollar":6388.67,"ethToDollar":209.9}}*/
                /*
                 "usdtocnyRate": "1",
                 "eostousdRate": "12",
                 "btctousdRate":"6536.05",
                 "ethtousdRate":"142",
                 "mistousdRate":"142"
                 */
                NSDictionary *dic;
                
                if ([responseObj containsObjectForKey:@"data"]) {
                    dic = responseObj[@"data"];
                    if([dic isEqual:[NSNull null]]){
                        //备用汇率
                        weakSelf.ETHCurrency = [[NSUserDefaults standardUserDefaults] floatForKey:@"ETHCurrency"];
                        weakSelf.BTCCurrency = [[NSUserDefaults standardUserDefaults] floatForKey:@"BTCCurrency"];
                        weakSelf.EOSCurrency = [[NSUserDefaults standardUserDefaults] floatForKey:@"EOSCurrency"];
                        weakSelf.MISCurrency = [[NSUserDefaults standardUserDefaults] floatForKey:@"MISCurrency"];
                        //RMB汇率取上次的
                        weakSelf.RMBDollarCurrency = [[NSUserDefaults standardUserDefaults] floatForKey:@"RMBDollarCurrency"];
                        return;
                    }
                    if ([dic containsObjectForKey:@"usdtocnyRate"]) {
                        weakSelf.RMBDollarCurrency = ((NSString *)VALIDATE_STRING([dic objectForKey:@"usdtocnyRate"])).doubleValue;
                        [[NSUserDefaults standardUserDefaults] setFloat:weakSelf.RMBDollarCurrency forKey:@"RMBDollarCurrency"];
                    }
                    if ([dic containsObjectForKey:@"eostousdRate"]) {
                        weakSelf.EOSCurrency = ((NSString *)VALIDATE_STRING([dic objectForKey:@"eostousdRate"])).doubleValue;
                        [[NSUserDefaults standardUserDefaults] setFloat:weakSelf.EOSCurrency forKey:@"EOSCurrency"];
                    }
                    if ([dic containsObjectForKey:@"btctousdRate"]) {
                        weakSelf.BTCCurrency = ((NSString *)VALIDATE_STRING([dic objectForKey:@"btctousdRate"])).doubleValue;
                        [[NSUserDefaults standardUserDefaults] setFloat:weakSelf.BTCCurrency forKey:@"BTCCurrency"];
                    }
                    if ([dic containsObjectForKey:@"ethtousdRate"]) {
                        weakSelf.ETHCurrency = ((NSString *)VALIDATE_STRING([dic objectForKey:@"ethtousdRate"])).doubleValue;
                        [[NSUserDefaults standardUserDefaults] setFloat:weakSelf.ETHCurrency forKey:@"ETHCurrency"];
                    }
                    if ([dic containsObjectForKey:@"mistousdRate"]) {
                        weakSelf.MISCurrency = ((NSString *)VALIDATE_STRING([dic objectForKey:@"mistousdRate"])).doubleValue;
                        [[NSUserDefaults standardUserDefaults] setFloat:weakSelf.MISCurrency forKey:@"MISCurrency"];
                    }
                }
                
            }else{
                //备用汇率
                weakSelf.ETHCurrency = [[NSUserDefaults standardUserDefaults] floatForKey:@"ETHCurrency"];
                weakSelf.BTCCurrency = [[NSUserDefaults standardUserDefaults] floatForKey:@"BTCCurrency"];
                weakSelf.EOSCurrency = [[NSUserDefaults standardUserDefaults] floatForKey:@"EOSCurrency"];
                weakSelf.MISCurrency = [[NSUserDefaults standardUserDefaults] floatForKey:@"MISCurrency"];
                //RMB汇率取上次的
                weakSelf.RMBDollarCurrency = [[NSUserDefaults standardUserDefaults] floatForKey:@"RMBDollarCurrency"];
            }
        }];
    });
}

-(void)GetALLCoins{
    MJWeakSelf
    [NetManager GetALLCOINCompletionHandler:^(id responseObj, NSError *error) {
        if (!error) {
            if (![[NSString stringWithFormat:@"%@",responseObj[@"resultCode"]] isEqualToString:@"20000"]) {
                [weakSelf.view showAlert:[NSString stringWithFormat:@"Error:%ld",error.code] DetailMsg:responseObj[@"resultMsg"]];
                return ;
            }
            NSArray *ddd = responseObj[@"data"];
            if([ddd isEqual:[NSNull null]]){
                [weakSelf.view showMsg:NSLocalizedString(@"没有数据", nil)];
                return;
            }
            [weakSelf.searchdataArray removeAllObjects];
            for (NSInteger i = 0; i < ddd.count; i++) {
                NSString *coin = [NSString parse:ddd[i]];
                if (![weakSelf.searchdataArray containsObject:coin]) {
                    [weakSelf.searchdataArray addObject:coin];
                }
            }
        }else{
            [weakSelf.view showAlert:[NSString stringWithFormat:@"Error:%ld",error.code] DetailMsg:error.localizedDescription];
        }
    }];
}


-(void)GetMarketListData{
  
    NSString *currentLanguage = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLanguageSelected"];
    if(currentLanguage == nil){
        currentLanguage = @"chinese";
        [[NSUserDefaults standardUserDefaults] setObject:@"chinese" forKey:@"CurrentLanguageSelected"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    self.currentLanguageType = [currentLanguage isEqualToString:@"english"]?USD_TYPE:CHY_TYPE;
    _unitstr = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentCurrencySelected"];
    MJWeakSelf
    if (self.currentSelectedType == SELFCHOOSE_SEARCH) {
        _mysymbol = [[NSUserDefaults standardUserDefaults] objectForKey:@"MySymbol"];
        if (_mysymbol.length < 2) {
            [self.dataArray removeAllObjects];
            dispatch_sync_on_main_queue(^{
                [self.tableView reloadData];
            });
            return ;
        }
        
        [NetManager GetOptionalListMySymbol:_mysymbol Lang:self.currentLanguageType completionHandler:^(id responseObj, NSError *error) {
            [weakSelf.tableView endHeaderRefresh];
            [weakSelf.tableView endFooterRefresh];
            if (!error) {
                if (![[NSString stringWithFormat:@"%@",responseObj[@"resultCode"]] isEqualToString:@"20000"]) {
                    [weakSelf.view showAlert:[NSString stringWithFormat:@"Error:%ld",error.code] DetailMsg:responseObj[@"resultMsg"]];
                    return ;
                }
                NSArray *ddd = responseObj[@"data"];
                if([ddd isEqual:[NSNull null]]){
                    [weakSelf.view showMsg:NSLocalizedString(@"没有数据", nil)];
                    return;
                }
                [weakSelf.dataArray removeAllObjects];
                for (NSInteger i = 0; i < ddd.count; i++) {
                    MarketTicketModel *model = [MarketTicketModel parse:ddd[i]];
                    [weakSelf.dataArray addObject:model];
                }
                //按自选名称排序
                if (weakSelf.currentSelectedType != MARKETVALUE_SEARCH){
                    //按名称排序时，如果是自选，则按本地存储的自选顺序排序
                    if(weakSelf.currentSortType == NONE_SORT && weakSelf.currentSelectedType == SELFCHOOSE_SEARCH){
                        [weakSelf sortSelfChoose];
                    }else{
                        [weakSelf sortMarketListSortType:weakSelf.currentSortType];
                    }
                }else{
                    [weakSelf sortMarketListSortType:weakSelf.currentSortType];
                }
                dispatch_sync_on_main_queue(^{
                    [weakSelf.tableView reloadData];
                });
                
            }else{
                [weakSelf.view showAlert:[NSString stringWithFormat:@"Error:%ld",error.code] DetailMsg:error.localizedDescription];
            }
        }];
    }else{
        NSLog(@"page = %d",self.page);
        [NetManager GetMarketTicketsPage:self.page PageSize:20 Lang:self.currentLanguageType completionHandler:^(id responseObj, NSError *error) {
            [weakSelf.tableView endHeaderRefresh];
            [weakSelf.tableView endFooterRefresh];
            if (!error) {
                if (![[NSString stringWithFormat:@"%@",responseObj[@"resultCode"]] isEqualToString:@"20000"]) {
                    [weakSelf.view showAlert:[NSString stringWithFormat:@"Error:%ld",error.code] DetailMsg:responseObj[@"resultMsg"]];
                    return ;
                }
                NSArray *ddd = responseObj[@"data"];
                if([ddd isEqual:[NSNull null]]){
                    [weakSelf.view showMsg:NSLocalizedString(@"没有数据", nil)];
                    return;
                }
                NSInteger index = weakSelf.page*20;
                if (weakSelf.dataArray.count >= index) {
                    [weakSelf.dataArray removeObjectsInRange:NSMakeRange(index - 20, weakSelf.dataArray.count - index + 20)];
                }else if(weakSelf.dataArray.count < 20){
                    [weakSelf.dataArray removeAllObjects];
                }
                for (NSInteger i = 0; i < ddd.count; i++) {
                    MarketTicketModel *model = [MarketTicketModel parse:ddd[i]];
                    [weakSelf.dataArray addObject:model];
                }
                
                dispatch_sync_on_main_queue(^{
                    [weakSelf.tableView reloadData];
                });
            }else{
                [weakSelf.view showAlert:[NSString stringWithFormat:@"Error:%ld",error.code] DetailMsg:error.localizedDescription];
            }
        }];
    }
}
-(void)InitTimerRequest{
    [self GetCurrentRate];
    //获得队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    //创建一个定时器
    self.time = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //设置开始时间
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC));
    //设置时间间隔
    uint64_t interval = (uint64_t)(self.TimeInterval* NSEC_PER_SEC);
    //设置定时器
    dispatch_source_set_timer(self.time, start, interval, 0);
    //设置回调
    MJWeakSelf
    dispatch_source_set_event_handler(self.time, ^{
        [weakSelf GetMarketListData];
    });
    //由于定时器默认是暂停的所以我们启动一下
    //启动定时器
    dispatch_resume(self.time);
}


//重置tableView上方三个按钮
-(void)resetBtnsTag:(NSInteger)tag ifinit:(BOOL)ifinit{
    if (tag == 0) {
        [self.tableheaderBtnView firstBtnWithTitile:NSLocalizedString(@"编辑", nil) ifHasImages:YES];
        [self.tableheaderBtnView secondBtnWithTitle:NSLocalizedString(@"最新价", nil) ifHasImages:NO SelectTYpe:-1];
        [self.tableheaderBtnView thirdBtnWithTitle:NSLocalizedString(@"24h涨跌", nil) ifHasImages:NO SelectTYpe:-1];
        self.tableheaderBtnView.firstBtn.userInteractionEnabled = YES;
        self.tableheaderBtnView.secondBtn.userInteractionEnabled = NO;
        self.tableheaderBtnView.thirdBtn.userInteractionEnabled = NO;
    }else if (tag == 1){
        [self.tableheaderBtnView firstBtnWithTitile:NSLocalizedString(@"按市值", nil) ifHasImages:NO];
        [self.tableheaderBtnView secondBtnWithTitle:NSLocalizedString(@"最新价", nil) ifHasImages:NO SelectTYpe:-1];
        [self.tableheaderBtnView thirdBtnWithTitle:NSLocalizedString(@"24h涨跌", nil) ifHasImages:NO SelectTYpe:-1];
        self.tableheaderBtnView.firstBtn.userInteractionEnabled = NO;
        self.tableheaderBtnView.secondBtn.userInteractionEnabled = NO;
        self.tableheaderBtnView.thirdBtn.userInteractionEnabled = NO;
        
    }
    
}
//选择上方按钮 自选，市值，BTC,..
-(void)selectTypeAction:(UIButton *)btn{
    [_buttonView setBtnSelected:btn];
    [self resetBtnsTag:btn.tag ifinit:YES];
    self.currentSelectedType = (MarketSearchType)btn.tag;
    self.page = 1;
    [self.dataArray removeAllObjects];
    [self.tableView reloadData];
    [self GetMarketListData];
}

-(void)selectSortType:(UIButton *)btn{
    if (btn.tag == 6400) {
        [self sortMarketListSortType:MARKETVALUE_SORT];
        self.currentSortType = MARKETVALUE_SORT;
        [self.tableheaderBtnView firstBtnWithTitile:NSLocalizedString(@"按市值", nil) ifHasImages:NO];
    }else{
        [self sortMarketListSortType:VOLUME_SORT];
        self.currentSortType = VOLUME_SORT;
        [self.tableheaderBtnView firstBtnWithTitile:NSLocalizedString(@"按成交量", nil) ifHasImages:NO];
    }
    MJWeakSelf
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.shadowView.alpha = 0.0;
        weakSelf.selectView.alpha =  0.0;
    } completion:^(BOOL finished) {
        [weakSelf.selectView removeFromSuperview];
        [weakSelf.shadowView removeFromSuperview];
        weakSelf.selectView = nil;
        weakSelf.shadowView = nil;
    }];
   
}

//tableView上方三个按钮
//编辑自选
-(void)firstBtnAction{
    //edit selfchoose
    MJWeakSelf
    if (self.currentSelectedType == MARKETVALUE_SEARCH) {
        [self selectView];
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.shadowView.alpha = 1.0;
            weakSelf.selectView.alpha =  1.0;
        }];
    }else if (self.currentSelectedType == SELFCHOOSE_SEARCH){
        EditSelfChooseVC *edvc = [EditSelfChooseVC new];
        edvc.dataArray = [NSMutableArray new];
        edvc.dataArray = [self.dataArray mutableCopy];
        [self presentViewController:edvc animated:YES completion:^{
            
        }];
    }
   
}




-(void)sortMarketListSortType:(MARKETLIST_SORT_TYPE)type{
    self.currentSortType = type;
    self.dataArray = [[self.dataArray sortedArrayUsingComparator:^NSComparisonResult(MarketTicketModel *obj1, MarketTicketModel *obj2) {
        switch (type) {
            case NONE_SORT:
                return NO;
                break;
            case CHANGE_UP_SORT:
                return NO;
                break;
            case CHANGE_DOWN_SORT:
                return NO;
                break;
            case LATESTPRICE_UP_SORT:
                return obj1.coinPrice > obj2.coinPrice;
                break;
            case LATESTPRICE_DOWN_SORT:
                return obj1.coinPrice < obj2.coinPrice;
                break;
            case MARKETVALUE_SORT:
                return obj1.marketValStr.floatValue < obj2.marketValStr.floatValue;
                break;
            case VOLUME_SORT:
                return obj1.coinPrice < obj2.coinPrice;
                break;
            default:
                return NO;
                break;
        }
    }] mutableCopy];
    [self.tableView reloadData];
}

-(void)sortSelfChoose{
    __block NSString *mysymbol = [[NSUserDefaults standardUserDefaults] objectForKey:@"MySymbol"];
    if (mysymbol == nil) {
        mysymbol = @"";
        return;
    }
    
    NSMutableArray *tempArr = [NSMutableArray new];
    NSMutableArray *symbolArr = [[mysymbol componentsSeparatedByString:@","] mutableCopy];
    [symbolArr removeLastObject];
    for (NSInteger i = 0; i < symbolArr.count; i++) {
        for (NSInteger j = 0; j < self.dataArray.count; j++) {
            MarketTicketModel *temp = self.dataArray[j];
            if ([temp.coinCode isEqualToString:(NSString *)symbolArr[i]]) {
                [tempArr addObject:temp];
            }
        }
    }
    self.dataArray = [tempArr mutableCopy];
    [self.tableView reloadData];
}
#pragma tableView

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.currentSelectedType == SELFCHOOSE_SEARCH) {
         return self.dataArray == nil?1:self.dataArray.count + 1;
    }else{
         return self.dataArray == nil?0:self.dataArray.count;
    }
   
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray == nil || indexPath.row == self.dataArray.count) {
        [self searchAction];
    }else{
        if (indexPath.row < self.dataArray.count) {
            
            VTwoMarketDetailVC *devc = [VTwoMarketDetailVC new];
            devc.RMBDollarCurrency = self.RMBDollarCurrency <= 0?6.8:self.RMBDollarCurrency;
            devc.marketModel = self.dataArray[indexPath.row];
            if(self.currentSelectedType == SELFCHOOSE_SEARCH){
                devc.rank = @"-1";
            }else{
                MarketTicketModel *model = self.dataArray[indexPath.row];
                devc.rank = model.coinNum;
            }
            [self.navigationController pushViewController:devc animated:YES];
        }
    }
}

-(AddSelfChooseCell *)addCell{
    if (!_addCell) {
        _addCell = [AddSelfChooseCell new];
        _addCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _addCell.backgroundColor = [UIColor whiteColor];
        _addCell.tintColor = [UIColor grayColor];
        UIImage *image = [UIImage imageNamed:@"tz"];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_addCell.iconIV setImage:image];
    }
    _addCell.namelb.text = NSLocalizedString(@"添加自选", nil);
    return _addCell;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.currentSelectedType == SELFCHOOSE_SEARCH) {
        if (self.dataArray == nil || indexPath.row == self.dataArray.count) {
            
            return self.addCell;
        }
    }
    
    VTwoMarketListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VTwoMarketListCell"];
    if (cell == nil) {
        cell = [VTwoMarketListCell new];
    }
    if(indexPath.row>self.dataArray.count - 1||indexPath.row<0){
        return cell;
    }
    
    MarketTicketModel *model = self.dataArray[indexPath.row];
    NSString *imageurl = model.coinIconURL;
    [[NSUserDefaults standardUserDefaults] synchronize];
    [cell.iconImageView sd_setImageWithURL:imageurl.STR_URLString];
    [cell.coinNamelabel setText:model.coinCode];
    [cell.namelabel setText:model.coinName];
    [cell.pricelabel setText:[NSString stringWithFormat:@"%@%.2f",[_unitstr isEqualToString:@"rmb"]?@"¥":@"$", model.coinPrice]];
    NSString *marketvalue = [NSString stringWithFormat:@"%@%@",[_unitstr isEqualToString:@"rmb"]?@"¥":@"$",model.marketValStr];
    
    [cell.rateBtn setTitle:model.coinChangeRate.floatValue >0 ?[NSString stringWithFormat:@"+%@%%",model.coinChangeRate]:[NSString stringWithFormat:@"%@%%",model.coinChangeRate] forState:UIControlStateNormal];
    cell.rateBtn.userInteractionEnabled = NO;

    if(model.coinChangeRate.floatValue == 0){
        [cell.rateBtn setBackgroundColor:[UIColor colorWithHexString:@"#DBDBDB"]];//priceChangeRate = 0 灰色
    }else{
        if (self.colorConfig == YES) {
            [cell.rateBtn setBackgroundColor:model.coinChangeRate.floatValue > 0? BTNFALLCOLOR : BTNRISECOLOR];
        }else{
            [cell.rateBtn setBackgroundColor:model.coinChangeRate.floatValue > 0? BTNRISECOLOR : BTNFALLCOLOR];
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.currentSelectedType == SELFCHOOSE_SEARCH) {
        [cell.coinNameDetaillabel setText:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"市值", nil),marketvalue]];
        UIView *bcView = [UIView new];
        bcView.backgroundColor = [UIColor clearColor];
        cell.selectedBackgroundView = bcView;
    }else{
        [cell.coinNameDetaillabel setText:[NSString stringWithFormat:@"%@,%@%@",VALIDATE_STRING(model.coinNum),NSLocalizedString(@"市值", nil),marketvalue]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins  = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
}
-(void)LookOtherDataOfCell:(UIButton *)btn{
    if (self.dataChoose > 3) {
        self.dataChoose = 0;
    }else{
        self.dataChoose ++;
    }
    ////0 priceChangeRate, 1 amount ,2 vol, 3 marketValue
    if (self.dataChoose == 0) {
        [self.tableheaderBtnView thirdBtnWithTitle:NSLocalizedString(@"涨跌幅", nil) ifHasImages:NO SelectTYpe:NONE_SELECT];
    }else if (self.dataChoose == 1){
        [self.tableheaderBtnView thirdBtnWithTitle:NSLocalizedString(@"24h成交量", nil) ifHasImages:NO SelectTYpe:NONE_SELECT];
    }else if (self.dataChoose == 2){
        [self.tableheaderBtnView thirdBtnWithTitle:NSLocalizedString(@"24h交易额", nil) ifHasImages:NO SelectTYpe:NONE_SELECT];
    }else if (self.dataChoose == 3){
        [self.tableheaderBtnView thirdBtnWithTitle:NSLocalizedString(@"市值", nil) ifHasImages:NO SelectTYpe:NONE_SELECT];
    }

    [self.tableView reloadData];
}

-(void)searchAction{
    // 1. 创建热门搜索数组
    NSArray *hotSeaches = @[@"BTC",@"ETH"];
    // 2. 创建搜索控制器

    __block NSMutableArray *arr = [NSMutableArray new];
    __block NSMutableArray *arrcopy = [NSMutableArray new];
    
    arrcopy = [self.searchdataArray mutableCopy];
    arr = [self.searchdataArray mutableCopy];
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:NSLocalizedString(@"请输入币种搜索", nil)];
    [searchViewController setHotSearchTitle:NSLocalizedString(@"热门搜索", nil)];
    [searchViewController setSearchHistoryTitle:NSLocalizedString(@"搜索历史", nil)];
    [searchViewController.emptySearchHistoryLabel setText:NSLocalizedString(@"清空搜索历史", nil)];
    [searchViewController.cancelButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [searchViewController.cancelButton setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
    MJWeakSelf
    [searchViewController setDidSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        [weakSelf.searchVC.searchdataarray removeAllObjects];
        weakSelf.searchVC.searchdataarray = [weakSelf.searchdataArray mutableCopy];
        weakSelf.searchVC.RMBDollarCurrency = weakSelf.RMBDollarCurrency;
        arr = [weakSelf.searchdataArray mutableCopy];
        [weakSelf.searchVC.tableView reloadData];
        for (NSString *str in arrcopy) {
            NSString *symbol = str;
            if(![symbol containsString:[searchText uppercaseString]]){
                [arr removeObject:str];
            }
        }
        
        weakSelf.searchVC.searchdataarray = [arr mutableCopy];
        [weakSelf.searchVC.tableView reloadData];
        [searchViewController addChildViewController:weakSelf.searchVC];
        [searchViewController.view addSubview:weakSelf.searchVC.view];
        [weakSelf.searchVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(0);
            make.top.equalTo(SafeAreaTopHeight + 10);
        }];
        // [searchViewController.navigationController pushViewController:weakSelf.searchVC animated:YES];
    }];
    // 3. 跳转到搜索控制器
    CustomizedNavigationController *nav = [[CustomizedNavigationController alloc] initWithRootViewController:searchViewController];
    
    [self presentViewController:nav  animated:NO completion:nil];
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    if (_selectView && _shadowView) {
        [self.view bringSubviewToFront:_shadowView];
    }
}

#pragma init

-(SortTypeSelectView *)selectView{
    if (!_selectView) {
        _selectView = [SortTypeSelectView new];
        _selectView.backgroundColor = [UIColor whiteColor];
        _selectView.layer.cornerRadius = 4;
        _selectView.layer.masksToBounds = YES;
        _selectView.alpha = 0;
        _selectView.titleArray = @[NSLocalizedString(@"按市值", nil),NSLocalizedString(@"按成交量", nil)];
        [_selectView initBtnsWithWidth:40 Height:60];
        for (UIButton *btn in _selectView.btnArray) {
            [btn addTarget:self action:@selector(selectSortType:) forControlEvents:UIControlEventTouchUpInside];
        }
        [self.shadowView addSubview:_selectView];
        [_selectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
    }
    return _selectView;
}
-(UIView *)shadowView{
    if (!_shadowView) {
        _shadowView = [UIView new];
        _shadowView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        _shadowView.layer.shadowOffset = CGSizeMake(0, 0);
        _shadowView.layer.shadowOpacity = 1;
        _shadowView.layer.shadowRadius = 5.0;
        _shadowView.layer.cornerRadius = 5.0;
        _shadowView.clipsToBounds = NO;
        _shadowView.alpha = 0;
        [self.view addSubview:_shadowView];
        [_shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(20);
            make.top.equalTo(SafeAreaTopHeight);
            make.height.equalTo(80);
            make.width.equalTo(80);
        }];
    }
    return _shadowView;
}

-(void)setupHeadBtnView{
    if (!_tableheaderBtnView) {
        _tableheaderBtnView = [MarketThreeBtnView new];
        [self.view addSubview:_tableheaderBtnView];
        [_tableheaderBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.top.equalTo(SafeAreaTopHeight + 6);
            make.height.equalTo(30);
        }];
        [self resetBtnsTag:0 ifinit:YES];
        [self.tableheaderBtnView.firstBtn addTarget:self action:@selector(firstBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        UIView *view = [[UIView alloc] init];
        _tableView.tableFooterView = view;
        [_tableView registerClass:[VTwoMarketListCell class] forCellReuseIdentifier:@"VTwoMarketListCell"];
        [self.view addSubview:_tableView];
        if(self.ifNeedRequestData == YES){
            [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(SafeAreaTopHeight + 36);
                make.left.right.equalTo(0);
                make.bottom.equalTo(-49);
            }];
        }else{
            [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(0);
                make.left.right.equalTo(0);
                make.bottom.equalTo(0);
            }];
        }
        
    }
    return _tableView;
}
-(ControlBtnsView *)buttonView{
    if (!_buttonView) {
        _buttonView = [ControlBtnsView new];
        
        [_buttonView initButtonsViewWithTitles:@[NSLocalizedString(@"自选", nil),NSLocalizedString(@"市值", nil)] Width:130 Height:44];
        NSInteger index = 0;
        for (UIButton *btn in _buttonView.btnArray) {
            btn.tag = index;
            index++;
            [btn addTarget:self action:@selector(selectTypeAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        self.currentSelectedType = 0;
        [self.view addSubview:_buttonView];
        [_buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(SafeAreaTopHeight - 42);
            make.left.right.equalTo(0);
            make.height.equalTo(44);
        }];
    }
    [self searchBtn];
    return _buttonView;
}

-(UIButton *)searchBtn{
    if(!_searchBtn){
        _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _searchBtn.tintColor = [UIColor appBlueColor];
        UIImage *image = [UIImage imageNamed:@"ico_market_search"];
        image = [image imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
        [_searchBtn setImage:image forState:UIControlStateNormal];
        [_searchBtn setImage:image forState:UIControlStateHighlighted];
        [_searchBtn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_searchBtn];
        [_searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-20);
            make.top.equalTo(SafeAreaTopHeight - 42);
            make.width.equalTo(30);
            make.height.equalTo(40);
        }];
    }
    return _searchBtn;
}

-(SearchResultVC *)searchVC{
    if (_searchVC==nil) {
        _searchVC = [[SearchResultVC alloc]init];
        _searchVC.searchdataarray = [NSMutableArray new];
    }
    return _searchVC;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self.dataArray removeAllObjects];
}


@end
