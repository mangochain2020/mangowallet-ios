//
//  AllHuobiOrdersVC.m
//  TaiYiToken
//
//  Created by 张元一 on 2019/3/19.
//  Copyright © 2019 admin. All rights reserved.
//

#import "AllHuobiOrdersVC.h"
#import "HuobiOrderCell.h"
#import "HuobiHistoryCell.h"
@interface AllHuobiOrdersVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UIButton *backBtn;
@property (nonatomic, assign)HUOBI_OrdersShowType currentType;

@property (nonatomic, strong)UIButton *allOrderBtn;
@property (nonatomic, strong)UIButton *allHistoryBtn;


@property(nonatomic,strong)UITableView *tableView;
//time
@property (nonatomic, strong)dispatch_source_t time;
@property(nonatomic)float TimeInterval;

@property(nonatomic,strong)NSMutableArray <HuobiOrderNowArrObj *>*orderdataArray;
@property(nonatomic,strong)NSMutableArray <HuobiOrderNowArrObj *>*historydataArray;
@end

@implementation AllHuobiOrdersVC


-(void)initHeadView{
    UIView *headBackView = [UIView new];
    headBackView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:headBackView];
    [headBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(0);
        make.height.equalTo(SafeAreaTopHeight);
    }];
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.backgroundColor = [UIColor clearColor];
    _backBtn.tintColor = [UIColor blackColor];
    [_backBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [_backBtn setImage:[[[UIImage imageNamed:@"ico_right_arrow"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backBtn];
    _backBtn.userInteractionEnabled = YES;
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(SafeAreaTopHeight - 34);
        make.height.equalTo(25);
        make.left.equalTo(10);
        make.width.equalTo(30);
    }];
    
}
- (void)popAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    self.navigationController.hidesBottomBarWhenPushed = YES;
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.hidesBottomBarWhenPushed = NO;
    MJWeakSelf
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"ifHasAccount"] == YES) {
        dispatch_cancel(weakSelf.time);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initHeadView];
    self.currentType = HuobiCurrentOrderType;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.allHistoryBtn addTarget:self action:@selector(AllHistorys) forControlEvents:UIControlEventTouchUpInside];
    [self.allOrderBtn addTarget:self action:@selector(AllOrders) forControlEvents:UIControlEventTouchUpInside];
    [self.allOrderBtn setSelected:YES];
    self.orderdataArray = [NSMutableArray new];
    self.historydataArray = [NSMutableArray new];
    self.TimeInterval = 4.0;
    [self InitTimerRequest];
    
}
-(void)NetRequest{
    MJWeakSelf
    NSString *savedsymbol = [[NSUserDefaults standardUserDefaults] objectForKey:CurrentHuobiSymbols];
    NSString *symbol = [[VALIDATE_STRING(savedsymbol) stringByReplacingOccurrencesOfString:@"/" withString:@""] lowercaseString];
    if (self.currentType == HuobiCurrentOrderType) {
        [HuobiManager HuobiGetOrderSymbol:VALIDATE_STRING(symbol) OrderStates:HUOBI_submitted CompletionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
            if (!error) {
                HuobiOrderNowModel *model = [HuobiOrderNowModel parse:responseObj];
                if (model.resultCode != 20000) {
                    [weakSelf.view showMsg:model.resultMsg];
                }else{
                    [weakSelf.orderdataArray removeAllObjects];
                    weakSelf.orderdataArray = [model.data.data mutableCopy];
                    dispatch_async_on_main_queue(^{
                        [weakSelf.tableView reloadData];
                    });
                }
            }else{
                [weakSelf.view showMsg:error.userInfo.description];
            }
        }];
    }else{
        [HuobiManager HuobiGetOrderSymbol:VALIDATE_STRING(symbol) OrderStates:-1 CompletionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
            if (!error) {
                HuobiOrderNowModel *model = [HuobiOrderNowModel parse:responseObj];
                if (model.resultCode != 20000) {
                    [weakSelf.view showMsg:model.resultMsg];
                }else{
                    [weakSelf.historydataArray removeAllObjects];
                    weakSelf.historydataArray = [model.data.data mutableCopy];
                    dispatch_async_on_main_queue(^{
                        [weakSelf.tableView reloadData];
                    });
                }
            }else{
                [weakSelf.view showMsg:error.userInfo.description];
            }
        }];
    }
    
}

#pragma timer
-(void)InitTimerRequest{
    //获得队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    self.time = nil;
    //创建一个定时器
    self.time = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //设置开始时间
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC));
    //设置时间间隔
    uint64_t interval = (uint64_t)(self.TimeInterval* NSEC_PER_SEC);
    //设置定时器
    dispatch_source_set_timer(self.time, start, interval, 0);
    //设置回调
    MJWeakSelf
    dispatch_source_set_event_handler(self.time, ^{
        [weakSelf NetRequest];
        
    });
    //由于定时器默认是暂停的所以我们启动一下
    //启动定时器
    dispatch_resume(self.time);
}
#pragma top
-(void)AllOrders{
    [self.allOrderBtn setSelected:YES];
    [self.allHistoryBtn setSelected:NO];
    self.currentType = HuobiCurrentOrderType;
    [self NetRequest];
}

-(void)AllHistorys{
    [self.allOrderBtn setSelected:NO];
    [self.allHistoryBtn setSelected:YES];
    self.currentType = HuobiHistoryOrderType;
    [self NetRequest];
}


-(UIButton *)allHistoryBtn{
    if (!_allHistoryBtn) {
        _allHistoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_allHistoryBtn setTitleColor:[UIColor darkappGreenColor] forState:UIControlStateNormal];
        [_allHistoryBtn setTitleColor:[UIColor textBlackColor] forState:UIControlStateSelected];
        _allHistoryBtn.backgroundColor = [UIColor whiteColor];
        [_allHistoryBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
        [_allHistoryBtn setTitle:NSLocalizedString(@"历史记录", nil) forState:UIControlStateNormal];
        [self.view addSubview:_allHistoryBtn];
        [_allHistoryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(120);
            make.top.equalTo(SafeAreaTopHeight);
            make.width.equalTo(100);
            make.height.equalTo(20);
        }];
    }
    return _allHistoryBtn;
}

-(UIButton *)allOrderBtn{
    if (!_allOrderBtn) {
        _allOrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_allOrderBtn setTitleColor:[UIColor darkappGreenColor] forState:UIControlStateNormal];
        [_allOrderBtn setTitleColor:[UIColor textBlackColor] forState:UIControlStateSelected];
        _allOrderBtn.backgroundColor = [UIColor whiteColor];
        [_allOrderBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
        [_allOrderBtn setTitle:NSLocalizedString(@"全部委托", nil) forState:UIControlStateNormal];
        [self.view addSubview:_allOrderBtn];
        [_allOrderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(10);
            make.top.equalTo(SafeAreaTopHeight);
            make.width.equalTo(100);
            make.height.equalTo(20);
        }];
    }
    return _allOrderBtn;
}

-(void)seeAllOrders{
    
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
    if (self.currentType == HuobiCurrentOrderType) {
        return 90;
    }else{
        return 130;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//只显示一条
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.currentType == HuobiCurrentOrderType) {
        return self.orderdataArray.count;
    }else{
        return self.historydataArray.count;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.currentType == HuobiCurrentOrderType) {
        HuobiOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HuobiOrderCell" forIndexPath:indexPath];
        HuobiOrderNowArrObj *model = self.orderdataArray[indexPath.row];
        NSMutableAttributedString *text1 = [[NSMutableAttributedString alloc]initWithString:[model.type containsString:@"sell"]? NSLocalizedString(@"卖出", nil):NSLocalizedString(@"买入", nil)];
        NSMutableAttributedString *text2 = [[NSMutableAttributedString alloc]initWithString:[self getDayStringWithTimeStr:model.createdat]];
        [text1 addAttribute:NSFontAttributeName
                      value:[UIFont boldSystemFontOfSize:17]
                      range:NSMakeRange(0, text1.length)];
        [text1 addAttribute:NSForegroundColorAttributeName
                      value:[model.type containsString:@"sell"]?[UIColor darkappRedColor]:[UIColor darkappGreenColor]
                      range:NSMakeRange(0, text1.length)];
        
        [text2 addAttribute:NSFontAttributeName
                      value:[UIFont systemFontOfSize:11]
                      range:NSMakeRange(0, text2.length)];
        [text2 addAttribute:NSForegroundColorAttributeName
                      value:[UIColor textLightGrayColor]
                      range:NSMakeRange(0, text2.length)];
        [text1 appendAttributedString:text2];
        [cell.leftlb setAttributedText:text1];
        [cell.cancelBtn addTarget:self action:@selector(cancelOrder:) forControlEvents:UIControlEventTouchUpInside];
        cell.cancelBtn.tag = indexPath.row;
        NSString *savedsymbol = [[NSUserDefaults standardUserDefaults] objectForKey:CurrentHuobiSymbols];
        NSString *basesymbol = [VALIDATE_STRING(savedsymbol)componentsSeparatedByString:@"/"].lastObject;
        NSString *thesymbol = [VALIDATE_STRING(savedsymbol)componentsSeparatedByString:@"/"].firstObject;
        [cell.bottomA.toplb setText:[NSString stringWithFormat:@"%@(%@)",NSLocalizedString(@"价格", nil),basesymbol]];
        [cell.bottomA.bottomlb setText:[self checkFloatToStr:model.price.doubleValue]];
        [cell.bottomB.toplb setText:[NSString stringWithFormat:@"%@(%@)",NSLocalizedString(@"数量", nil),thesymbol]];
        [cell.bottomB.bottomlb setText:[self checkFloatToStr:model.amount.doubleValue]];
        [cell.bottomC.toplb setText:[NSString stringWithFormat:@"%@(%@)",NSLocalizedString(@"实际成交", nil),thesymbol]];
        [cell.bottomC.bottomlb setText:[self checkFloatToStr:model.fieldcashamount.doubleValue]];
        return cell;
    }else{
        HuobiHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HuobiHistoryCell" forIndexPath:indexPath];
        HuobiOrderNowArrObj *model = self.historydataArray[indexPath.row];
        NSString *savedsymbol = [[NSUserDefaults standardUserDefaults] objectForKey:CurrentHuobiSymbols];
        NSString *basesymbol = [VALIDATE_STRING(savedsymbol)componentsSeparatedByString:@"/"].lastObject;
        NSString *thesymbol = [VALIDATE_STRING(savedsymbol)componentsSeparatedByString:@"/"].firstObject;
        
        NSMutableAttributedString *text1 = [[NSMutableAttributedString alloc]initWithString:[model.type containsString:@"sell"]? NSLocalizedString(@"卖出", nil):NSLocalizedString(@"买入", nil)];
        NSMutableAttributedString *text2 = [[NSMutableAttributedString alloc]initWithString:VALIDATE_STRING(savedsymbol)];
        [text1 addAttribute:NSFontAttributeName
                      value:[UIFont boldSystemFontOfSize:17]
                      range:NSMakeRange(0, text1.length)];
        [text1 addAttribute:NSForegroundColorAttributeName
                      value:[model.type containsString:@"sell"]?[UIColor darkappRedColor]:[UIColor darkappGreenColor]
                      range:NSMakeRange(0, text1.length)];
        
        [text2 addAttribute:NSFontAttributeName
                      value:[UIFont boldSystemFontOfSize:17]
                      range:NSMakeRange(0, text2.length)];
        [text2 addAttribute:NSForegroundColorAttributeName
                      value:[UIColor darkGrayColor]
                      range:NSMakeRange(0, text2.length)];
        [text1 appendAttributedString:[[NSAttributedString alloc]initWithString:@" "]];
        [text1 appendAttributedString:text2];
        [cell.leftlb setAttributedText:text1];
        [cell.rightlb setText:NSLocalizedString(model.state, nil)];
        [cell.topA.toplb setText:NSLocalizedString(@"时间", nil)];
        [cell.topA.bottomlb setText:[self getDayStringWithTimeStr:model.createdat]];
        [cell.topB.toplb setText:[NSString stringWithFormat:@"%@(%@)",NSLocalizedString(@"委托价", nil),basesymbol]];
        [cell.topB.bottomlb setText:[self checkFloatToStr:model.price.doubleValue]];
        [cell.topC.toplb setText:[NSString stringWithFormat:@"%@(%@)",NSLocalizedString(@"委托量", nil),[model.type containsString:@"sell"]?thesymbol : basesymbol]];
        [cell.topC.bottomlb setText:[self checkFloatToStr:model.amount.doubleValue]];
        [cell.bottomA.toplb setText:[NSString stringWithFormat:@"%@(%@)",NSLocalizedString(@"成交总额", nil),basesymbol]];
        [cell.bottomA.bottomlb setText:[self checkFloatToStr:model.fieldcashamount.doubleValue]];
        [cell.bottomB.toplb setText:[NSString stringWithFormat:@"%@(%@)",NSLocalizedString(@"成交均价", nil),basesymbol]];
        [cell.bottomB.bottomlb setText:[self checkFloatToStr:model.fieldamount.doubleValue == 0?0:model.fieldcashamount.doubleValue/model.fieldamount.doubleValue]];
        [cell.bottomC.toplb setText:[NSString stringWithFormat:@"%@(%@)",NSLocalizedString(@"成交量", nil),thesymbol]];
        [cell.bottomC.bottomlb setText:[self checkFloatToStr:model.fieldamount.doubleValue]];
        return cell;
    }
    
}
-(void)cancelOrder:(UIButton *)btn{
    if (btn.tag > self.orderdataArray.count || btn.tag < 0) {
        return;
    }
    HuobiOrderNowArrObj *model = self.orderdataArray[btn.tag];
    MJWeakSelf
    [HuobiManager HuobiCancelOrderWithID:model.ID CompletionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
        if (!error) {
            HuobiCancelOrderModel *model = [HuobiCancelOrderModel parse:responseObj];
            [weakSelf.view showMsg:model.resultMsg];
        }else{
            [weakSelf.view showMsg:error.userInfo.description];
        }
    }];
}
#pragma tool
-(NSString *)checkFloatToStr:(CGFloat)num{
    if ([[NSString stringWithFormat:@"%.8f",num] isEqualToString:@"0.00000000"]) {
        return @"--";
    }
    if (num < 0.001) {
        return [NSString stringWithFormat:@"%.8f",num];
    }else if (num < 1.0){
        return [NSString stringWithFormat:@"%.6f",num];
    }else if (num < 10.0){
        return [NSString stringWithFormat:@"%.4f",num];
    }else if (num < 1000.0){
        return [NSString stringWithFormat:@"%.2f",num];
    }else if(num < 10000){
        return [NSString stringWithFormat:@"%.2fK",num/1000.0];
    }else if(num < 1000000){
        return [NSString stringWithFormat:@"%.0fK",num/1000.0];
    }else if(num < 10000000){
        return [NSString stringWithFormat:@"%.0fM",num/1000000.0];
    }else{
        return [NSString stringWithFormat:@"%.0fB",num/1000000000.0];
    }
}

// 时间戳转时间,时间戳为13位是精确到毫秒的，10位精确到秒
- (NSString *)getDayStringWithTimeStr:(NSString *)str{
    NSTimeInterval time=[str doubleValue]/1000;//传入的时间戳str如果是精确到毫秒的记得要/1000
    NSDate *detailDate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; //实例化一个NSDateFormatter对象
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"HH:mm MM/dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detailDate];
    return currentDateStr;
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins  = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        UIView *view = [[UIView alloc] init];
        _tableView.tableFooterView = view;
        [_tableView registerClass:[HuobiOrderCell class] forCellReuseIdentifier:@"HuobiOrderCell"];
        [_tableView registerClass:[HuobiHistoryCell class] forCellReuseIdentifier:@"HuobiHistoryCell"];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(SafeAreaTopHeight+30);
            make.left.right.equalTo(0);
            make.bottom.equalTo(0);
        }];
    }
    return _tableView;
}


@end
