//
//  HuobiRightExchangeVC.m
//  TaiYiToken
//
//  Created by 张元一 on 2019/3/15.
//  Copyright © 2019 admin. All rights reserved.
//

#import "HuobiRightExchangeVC.h"
#import "HuobiRightTypeOneCell.h"
#import "HuobiRightTypTwoCell.h"
#import "HuobiBtn.h"
@interface HuobiRightExchangeVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,copy)NSString *currentSymbols;

//time
@property (nonatomic, strong)dispatch_source_t time;
@property(nonatomic)float TimeInterval;

//data
@property (nonatomic, strong)NSMutableArray <NSArray *>*bidArray;
@property (nonatomic, strong)NSMutableArray <NSArray *>*askArray;


@end

@implementation HuobiRightExchangeVC

-(void)viewWillDisappear:(BOOL)animated{
    MJWeakSelf
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"ifHasAccount"] == YES) {
        dispatch_cancel(weakSelf.time);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NSString *currentsymbol = [[NSUserDefaults standardUserDefaults] objectForKey:CurrentHuobiSymbols];
    if (VALIDATE_STRING(currentsymbol).length < 1) {
        currentsymbol = DefaultHuobiExchangeSymbol;
    }
    self.bidArray = [NSMutableArray new];
    self.askArray = [NSMutableArray new];
    self.currentSymbols = VALIDATE_STRING(currentsymbol).copy;
    self.currentDepth = 0;
    self.TimeInterval = 4.0;
    [self InitTimerRequest];
    self.showType = HUOBI_Default_Type;
    
    _depthBtn = [HuobiBtn HuobiTypeTwoBtn];
    _typeBtn = [HuobiBtn HuobiTypeThreeBtn];
    [self.view addSubview:_depthBtn];
    [self.view addSubview:_typeBtn];
    [_depthBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(1);
        make.bottom.equalTo(-2);
        make.width.equalTo(90);
        make.height.equalTo(22);
    }];
    [_typeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-8);
        make.bottom.equalTo(-2);
        make.width.equalTo(22);
        make.height.equalTo(22);
    }];
    
    
}
-(void)NetRequest{
    MJWeakSelf
    weakSelf.currentSymbols =  [[NSUserDefaults standardUserDefaults] objectForKey:CurrentHuobiSymbols];
    NSString *symbol = [[VALIDATE_STRING(weakSelf.currentSymbols) stringByReplacingOccurrencesOfString:@"/" withString:@""] lowercaseString];
    [HuobiManager HuobiGetDepthSymbol:symbol Depth:weakSelf.currentDepth CompletionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
        if (!error) {
            HuobiDepthModel *model = [HuobiDepthModel parse:responseObj];
            if (model.resultCode != 20000) {
                [weakSelf.view showMsg:model.resultMsg];
            }else{
                weakSelf.bidArray = [model.data.tick.bids mutableCopy];
                weakSelf.askArray = [model.data.tick.asks mutableCopy];
                //ask卖单 从低到高排序 bid买单 从高到低排序
                [weakSelf.bidArray sortUsingComparator:^NSComparisonResult(NSArray *obj1, NSArray *obj2) {
                    CGFloat p0 = ((NSString *)obj1[0]).doubleValue;//price
                    CGFloat p1 = ((NSString *)obj2[0]).doubleValue;
                    return p0 < p1;
                }];
                [weakSelf.askArray sortUsingComparator:^NSComparisonResult(NSArray *obj1, NSArray *obj2) {
                    CGFloat p0 = ((NSString *)obj1[0]).doubleValue;//price
                    CGFloat p1 = ((NSString *)obj2[0]).doubleValue;
                    return p0 > p1;
                }];
                dispatch_async_on_main_queue(^{
                    [weakSelf.tableView reloadData];
                });
            }
        }else{
            [weakSelf.view showMsg:error.userInfo.description];
        }
    }];
    [HuobiManager HuobiGetSymbolsCompletionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
        if (!error) {
            HuobiSymbolsModel *model = [HuobiSymbolsModel parse:responseObj];
            if (model.resultCode != 20000) {
                [weakSelf.view showMsg:model.resultMsg];
            }else{
                NSString *basesymbol = [weakSelf.currentSymbols componentsSeparatedByString:@"/"].lastObject;
                NSString *childsymbol = [weakSelf.currentSymbols componentsSeparatedByString:@"/"].firstObject;
                NSMutableArray *temp = [NSMutableArray new];
                if ([VALIDATE_STRING(basesymbol.lowercaseString) isEqualToString:@"btc"]) {
                    temp = [model.data.btc mutableCopy];
                }else if([VALIDATE_STRING(basesymbol.lowercaseString) isEqualToString:@"eth"]){
                    temp = [model.data.eth mutableCopy];
                }else if([VALIDATE_STRING(basesymbol.lowercaseString) isEqualToString:@"ht"]){
                    temp = [model.data.ht mutableCopy];
                }else if([VALIDATE_STRING(basesymbol.lowercaseString) isEqualToString:@"usdt"]){
                    temp = [model.data.usdt mutableCopy];
                }
                for (HuobiSymbolsDetail *obj in temp) {
                    if ([obj.symbol isEqualToString:VALIDATE_STRING(childsymbol)]) {
                        weakSelf.currentPrice = obj.close.stringValue;
                    }
                }
                dispatch_async_on_main_queue(^{
                    [weakSelf.tableView reloadData];
                });
            }
        }else{
            [weakSelf.view showMsg:error.userInfo.description];
        }
    }];
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
    if (indexPath.row == 0) {
        return 28;
    }
    switch (self.showType) {
        case HUOBI_Default_Type:
            if (indexPath.row == 6) {
                return 45;
            }else{
                return 23;
            }
            
            break;
        case HUOBI_Buy_Type:
            if (indexPath.row == 1) {
                return 45;
            }else{
                return 23;
            }
            break;
        case HUOBI_Sale_Type:
            if (indexPath.row == 11) {
                return 45;
            }else{
                return 23;
            }
            break;
        default:
            return 23;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 12;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row != 0) {
        NSMutableArray *data = [NSMutableArray new];
        NSInteger bigCellIndex = 6;
        switch (self.showType) {
            case HUOBI_Default_Type:
                if (indexPath.row < 6 && indexPath.row > 0 && self.askArray.count > 5 - indexPath.row) {
                    data = [self.askArray[5-indexPath.row] mutableCopy];
                }else if (indexPath.row > 6 && self.bidArray.count > indexPath.row - 7){
                    data = [self.bidArray[indexPath.row - 7] mutableCopy];
                }
                bigCellIndex = 6;
                break;
            case HUOBI_Buy_Type:
                if (indexPath.row > 1 && self.askArray.count > indexPath.row - 2) {
                    data = [self.bidArray[indexPath.row - 2] mutableCopy];
                }
                bigCellIndex = 1;
                break;
            case HUOBI_Sale_Type:
                if (indexPath.row > 0 && indexPath.row < 11 && self.bidArray.count > 11 - indexPath.row) {
                    data = [self.askArray[11 - indexPath.row] mutableCopy];
                }
                bigCellIndex = 11;
                break;
            default:
                break;
        }
        
        if (data.count > 1 || indexPath.row == bigCellIndex) {
            if (indexPath.row == bigCellIndex) {
                self.selectedPrice = self.currentPrice.copy;
            }else{
                self.selectedPrice = ((NSDecimalNumber *)[data objectAtIndex:0]).stringValue;
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectNewPrice" object:nil userInfo:nil];
        }
        
        
    }
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger bigCellIndex = 5;
    /*
     HUOBI_Default_Type
     1-5 bid 6 curr 7-11 ask
     HUOBI_Buy_Type
     1 curr 2-11 bid
     HUOBI_Sale_Type
     1-10 ask 11 curr
     */
    NSMutableArray *data = [NSMutableArray new];
    if (indexPath.row == 0) {
        data = [@[NSLocalizedString(@"价格", nil), NSLocalizedString(@"数量", nil)] mutableCopy];
    }
    //上面卖单 ask 下面买单 bid
    switch (self.showType) {
        case HUOBI_Default_Type:
            if (indexPath.row < 6 && indexPath.row > 0 && self.askArray.count > 5 - indexPath.row) {
                data = [self.askArray[5-indexPath.row] mutableCopy];
            }else if (indexPath.row > 6 && self.bidArray.count > indexPath.row - 7){
                data = [self.bidArray[indexPath.row - 7] mutableCopy];
            }
            bigCellIndex = 6;
            break;
        case HUOBI_Buy_Type:
            if (indexPath.row > 1 && self.askArray.count > indexPath.row - 2) {
                data = [self.bidArray[indexPath.row - 2] mutableCopy];
            }
            bigCellIndex = 1;
            break;
        case HUOBI_Sale_Type:
            if (indexPath.row > 0 && indexPath.row < 11 && self.bidArray.count > 11 - indexPath.row) {
                data = [self.askArray[11 - indexPath.row] mutableCopy];
            }
            bigCellIndex = 11;
            break;
        default:
            break;
    }
    if (data.count < 2) {
        data = [@[@"--",@"--"]mutableCopy];
    }
    if (indexPath.row == bigCellIndex) {//current
        HuobiRightTypeOneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HuobiRightTypeOneCell" forIndexPath:indexPath];
        [cell.toplb setText:VALIDATE_STRING(self.currentPrice)];
        CGFloat rmbcurr = [[NSUserDefaults standardUserDefaults] floatForKey:@"RMBDollarCurrency"];
        [cell.bottomlb setText:[NSString stringWithFormat:@"≈%@CHY",[self checkFloatToStr:rmbcurr * self.currentPrice.doubleValue / 100.0]]];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        return cell;
    }else{//data
        HuobiRightTypTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HuobiRightTypTwoCell" forIndexPath:indexPath];
        if (indexPath.row == 0) {
            [cell.leftlb setTextColor:[UIColor darkappGreenColor]];
            [cell.rightlb setTextColor:[UIColor darkappGreenColor]];
            [cell.leftlb setText:VALIDATE_STRING((NSString *)data[0])];
            [cell.rightlb setText:VALIDATE_STRING((NSString *)data[1])];
            cell.userInteractionEnabled = NO;
        }else{
            [cell.leftlb setTextColor:[UIColor darkappRedColor]];
            [cell.rightlb setTextColor:[UIColor darkappGreenColor]];
            cell.userInteractionEnabled = YES;
            switch (self.showType) {
                case HUOBI_Default_Type:
                    if (indexPath.row < 6 && indexPath.row > 0) {
                       [cell.leftlb setTextColor:[UIColor darkappRedColor]];
                    }else if (indexPath.row > 6){
                       [cell.leftlb setTextColor:[UIColor darkappGreenColor]];
                    }
                    break;
                case HUOBI_Buy_Type:
                    if (indexPath.row > 1) {
                        [cell.leftlb setTextColor:[UIColor darkappGreenColor]];
                    }
                    break;
                case HUOBI_Sale_Type:
                    if (indexPath.row < 11 && indexPath.row > 0) {
                        [cell.leftlb setTextColor:[UIColor darkappRedColor]];
                    }
                    break;
                default:
                    break;
            }
            if ([data[0] isKindOfClass:[NSString class]]) {
                [cell.leftlb setText:[data objectAtIndex:0]];
                [cell.rightlb setText:[NSString stringWithFormat:@"%@",[self checkFloatToStr:((NSString *)data[1]).doubleValue]]];
                [cell.rightlb setText:[data objectAtIndex:1]];
            }else if ([data[0] isKindOfClass:[NSDecimalNumber class]]){
                [cell.leftlb setText:((NSDecimalNumber *)[data objectAtIndex:0]).stringValue];
                [cell.rightlb setText:[NSString stringWithFormat:@"%@",[self checkFloatToStr:((NSString *)data[1]).doubleValue]]];
//                [cell.rightlb setText:((NSDecimalNumber *)[data objectAtIndex:1]).stringValue];
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        return cell;
    }
}

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
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        UIView *view = [[UIView alloc] init];
        _tableView.tableFooterView = view;
        [_tableView registerClass:[HuobiRightTypeOneCell class] forCellReuseIdentifier:@"HuobiRightTypeOneCell"];
         [_tableView registerClass:[HuobiRightTypTwoCell class] forCellReuseIdentifier:@"HuobiRightTypTwoCell"];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(0);
            make.left.right.equalTo(0);
            make.bottom.equalTo(-30);
        }];
    }
    return _tableView;
}


@end
