//
//  HuobiPersonAssetsVC.m
//  TaiYiToken
//
//  Created by 张元一 on 2019/3/20.
//  Copyright © 2019 admin. All rights reserved.
//

#import "HuobiPersonAssetsVC.h"
#import "HuobiPersonAssetsCell.h"
#import "HuobiPersonAssetsHeaderView.h"
@interface HuobiPersonAssetsVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate>
@property(nonatomic,strong)UILabel *headlabel;
@property(nonatomic,strong) UIButton *backBtn;
@property(nonatomic,copy)NSString *currentSearchText;
@property(nonatomic,assign)BOOL priConfig;

@property(nonatomic,strong)HuobiPersonAssetsHeaderView *headerview;
@property(nonatomic,strong)NSMutableArray <NSString *>*currentsymbolArray;
@property(nonatomic,strong)NSMutableArray <HuobiBalanceListObj *>*dataArray;

@property(nonatomic,strong)NSMutableArray <HuobiBalanceCollectModel *>*collectdataArray;
@property(nonatomic,strong)NSMutableArray <HuobiBalanceCollectModel *>*allcollectdataArray;
//top
@property(nonatomic,assign)CGFloat btcprice;
@property(nonatomic,assign)CGFloat ethprice;
@property(nonatomic,assign)CGFloat htprice;

@property(nonatomic,assign)CGFloat totalbalanceBTC;

//time
@property (nonatomic, strong)dispatch_source_t time;
@property(nonatomic)float TimeInterval;
@end

@implementation HuobiPersonAssetsVC
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
    _backBtn.tintColor = [UIColor whiteColor];
    [_backBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [_backBtn setImage:[[UIImage imageNamed:@"ico_right_arrow"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
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
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.priConfig = NO;
    [self.collectionview registerClass:[HuobiPersonAssetsCell class] forCellWithReuseIdentifier:@"HuobiPersonAssetsCell"];
    [self initHeadView];
    self.dataArray = [NSMutableArray new];
    self.collectdataArray = [NSMutableArray new];
    self.currentsymbolArray = [NSMutableArray new];
    self.allcollectdataArray = [NSMutableArray new];
    self.TimeInterval = 4.0;
    MJWeakSelf
    [HuobiManager HuobiGetSymbolsCompletionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
        if (!error) {
            HuobiSymbolsModel *model = [HuobiSymbolsModel parse:responseObj];
            if (model.resultCode != 20000) {
                [weakSelf.view showMsg:model.resultMsg];
            }else{
                CGFloat rmbcurr = [[NSUserDefaults standardUserDefaults] floatForKey:@"RMBDollarCurrency"] / 100.0;
                //usdt需要单独加
                [weakSelf.currentsymbolArray addObject:@"USDT"];
                HuobiBalanceCollectModel *us = [HuobiBalanceCollectModel new];
                us.symbol = @"usdt";
                us.chybalance = @"0";
                us.chyprice = [NSString stringWithFormat:@"%lf",rmbcurr];
                [weakSelf.collectdataArray addObject:us];
                for (HuobiSymbolsDetail *obj in model.data.usdt) {
                    [weakSelf.currentsymbolArray addObject:VALIDATE_STRING(obj.symbol)];
                    HuobiBalanceCollectModel *model = [HuobiBalanceCollectModel new];
                    model.symbol = VALIDATE_STRING(obj.symbol);
                    model.chybalance = @"0";
                    model.chyprice = [NSString stringWithFormat:@"%lf",obj.close.doubleValue * rmbcurr];
                    [weakSelf.collectdataArray addObject:model];
                    if ([obj.symbol.lowercaseString isEqualToString:@"btc"]) {
                        weakSelf.btcprice = obj.close.doubleValue;
                    }
                    if ([obj.symbol.lowercaseString isEqualToString:@"eth"]) {
                        weakSelf.ethprice = obj.close.doubleValue;
                    }
                    if ([obj.symbol.lowercaseString isEqualToString:@"ht"]) {
                        weakSelf.htprice = obj.close.doubleValue;
                    }
                    
                }
                for (HuobiSymbolsDetail *obj in model.data.btc) {
                    if (![weakSelf.currentsymbolArray containsObject:VALIDATE_STRING(obj.symbol)]) {
                        [weakSelf.currentsymbolArray addObject:VALIDATE_STRING(obj.symbol)];
                        HuobiBalanceCollectModel *model = [HuobiBalanceCollectModel new];
                        model.symbol = VALIDATE_STRING(obj.symbol);
                        model.chybalance = @"0";
                        model.chyprice = [NSString stringWithFormat:@"%lf",obj.close.doubleValue * rmbcurr * weakSelf.btcprice];
                        [weakSelf.collectdataArray addObject:model];
                    }
                }
                for (HuobiSymbolsDetail *obj in model.data.eth) {
                    if (![weakSelf.currentsymbolArray containsObject:VALIDATE_STRING(obj.symbol)]) {
                        [weakSelf.currentsymbolArray addObject:VALIDATE_STRING(obj.symbol)];
                        HuobiBalanceCollectModel *model = [HuobiBalanceCollectModel new];
                        model.symbol = VALIDATE_STRING(obj.symbol);
                        model.chybalance = @"0";
                        model.chyprice = [NSString stringWithFormat:@"%lf",obj.close.doubleValue * rmbcurr * weakSelf.ethprice];
                        [weakSelf.collectdataArray addObject:model];
                    }
                }
                for (HuobiSymbolsDetail *obj in model.data.ht) {
                    if (![weakSelf.currentsymbolArray containsObject:VALIDATE_STRING(obj.symbol)]) {
                        [weakSelf.currentsymbolArray addObject:VALIDATE_STRING(obj.symbol)];
                        HuobiBalanceCollectModel *model = [HuobiBalanceCollectModel new];
                        model.symbol = VALIDATE_STRING(obj.symbol);
                        model.chybalance = @"0";
                        model.chyprice = [NSString stringWithFormat:@"%lf",obj.close.doubleValue * rmbcurr * weakSelf.htprice];
                        [weakSelf.collectdataArray addObject:model];
                    }
                }
                weakSelf.allcollectdataArray = [weakSelf.collectdataArray mutableCopy];
                [self InitTimerRequest];
            }
        }else{
            [weakSelf.view showMsg:error.userInfo.description];
        }
    }];
    
    UIButton *hideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    hideBtn.imageEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8);
    [hideBtn setImage:[UIImage imageNamed:@"show"] forState:UIControlStateNormal];
    [hideBtn setImage:[UIImage imageNamed:@"hide"] forState:UIControlStateSelected];
    [hideBtn addTarget:self action:@selector(priMode:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:hideBtn];
    [hideBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-10);
        make.top.equalTo(SafeAreaTopHeight -34);
        make.width.equalTo(40);
        make.height.equalTo(40);
    }];
   
}


-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    NSLog(@"%@",searchBar.text);
    self.currentSearchText = searchBar.text;
    NSMutableArray *temparray = [NSMutableArray new];
    temparray = [self.allcollectdataArray mutableCopy];
    for (HuobiBalanceCollectModel *obj in self.allcollectdataArray) {
        if (![obj.symbol.lowercaseString containsString:searchBar.text.lowercaseString]) {
            [temparray removeObject:obj];
        }
    }
    if ([VALIDATE_STRING(searchBar.text) isEqualToString:@""]) {
        temparray = [self.allcollectdataArray mutableCopy];
    }
    [self.collectdataArray removeAllObjects];
    self.collectdataArray = [temparray mutableCopy];
    [self.collectionview reloadData];
   
    return YES;
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

/*
 type    String    trade: 交易余额，frozen: 冻结余额
 */
-(NSString *)collectTradeBalanceSymbol:(NSString *)symbol{
    for (HuobiBalanceListObj *obj in self.dataArray) {
        if ([obj.type isEqualToString:@"trade"] && [[obj.currency lowercaseString] isEqualToString:[symbol lowercaseString]]) {
            return VALIDATE_STRING(obj.balance);
        }
    }
    return @"";
}

-(NSString *)collectFrozenBalanceSymbol:(NSString *)symbol{
    for (HuobiBalanceListObj *obj in self.dataArray) {
        if ([obj.type isEqualToString:@"frozen"] && [[obj.currency lowercaseString] isEqualToString:[symbol lowercaseString]]) {
            return VALIDATE_STRING(obj.balance);
        }
    }
    return @"";
}

-(void)NetRequest{
    MJWeakSelf
    [HuobiManager HuobiGetBalanceCompletionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
        if (!error) {
            HuobiBalanceModel *model = [HuobiBalanceModel parse:responseObj];
            if (model.resultCode != 20000) {
                [weakSelf.view showMsg:model.resultMsg];
            }else{
                [weakSelf.dataArray removeAllObjects];
                weakSelf.dataArray = [model.data.data.list mutableCopy];
                CGFloat total = 0;
                CGFloat rmbcurr = [[NSUserDefaults standardUserDefaults] floatForKey:@"RMBDollarCurrency"] / 100.0;
                for (HuobiBalanceCollectModel *obj in weakSelf.allcollectdataArray) {
                    obj.trade = [weakSelf collectTradeBalanceSymbol:obj.symbol];
                    obj.frozen = [weakSelf collectFrozenBalanceSymbol:obj.symbol];
                    obj.chybalance = [NSString stringWithFormat:@"%lf",(obj.trade.doubleValue+obj.frozen.doubleValue)*obj.chyprice.doubleValue];
                    total += obj.chybalance.doubleValue/rmbcurr/weakSelf.btcprice;//资产换算btc
                }
                for (HuobiBalanceCollectModel *obj in weakSelf.collectdataArray) {
                    obj.trade = [weakSelf collectTradeBalanceSymbol:obj.symbol];
                    obj.frozen = [weakSelf collectFrozenBalanceSymbol:obj.symbol];
                }
                weakSelf.totalbalanceBTC = total;
                
                dispatch_async_on_main_queue(^{
                    [weakSelf.collectionview reloadData];
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
#pragma mark - UICollectionViewDelegate
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)priMode:(UIButton *)btn{
    [btn setSelected:!btn.isSelected];
    self.priConfig = btn.isSelected;
    [self.collectionview reloadData];
}

#pragma collectionview *****************************
- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    HuobiPersonAssetsHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HuobiPersonAssetsHeaderView" forIndexPath:indexPath];
    [headerView toplb];
    [headerView.meduimlb setText:[self checkFloatToStr:self.totalbalanceBTC]];
    CGFloat rmbcurr = [[NSUserDefaults standardUserDefaults] floatForKey:@"RMBDollarCurrency"] / 100.0;
    CGFloat chybalance = self.btcprice*rmbcurr*self.totalbalanceBTC;
    [headerView.bottomlb setText:[NSString stringWithFormat:@"≈%@CHY",[self checkFloatToStr:chybalance]]];
    headerView.searchBar.delegate = self;
    headerView.searchBar.text = self.currentSearchText;
    
    
    
    if (self.priConfig == YES) {
        headerView.bottomlb.text = @"≈***CHY";
        headerView.meduimlb.text = @"********";
    }
    return headerView;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(30, 10, 50, 10);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(ScreenWidth, 145);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(1, 1);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(ScreenWidth - 20 , 80);
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.collectdataArray.count > 0) {
        return self.collectdataArray.count;
    }else{
        return 0;
    }
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HuobiPersonAssetsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HuobiPersonAssetsCell" forIndexPath:indexPath];
    if (indexPath.row < self.collectdataArray.count && indexPath.row >= 0) {
        HuobiBalanceCollectModel *model = [self.collectdataArray objectAtIndex:indexPath.row];
        if (self.priConfig) {
            [cell.leftlb setText:VALIDATE_STRING(model.symbol)];
            [cell.bottomA.toplb setText:NSLocalizedString(@"可用", nil)];
            [cell.bottomA.bottomlb setText:@"***"];
            [cell.bottomB.toplb setText:NSLocalizedString(@"冻结", nil)];
            [cell.bottomB.bottomlb setText:@"***"];
            [cell.bottomC.toplb setText:NSLocalizedString(@"折合(CHY)", nil)];
            [cell.bottomC.bottomlb setText:@"***"];
        }else{
            [cell.leftlb setText:VALIDATE_STRING(model.symbol)];
            [cell.bottomA.toplb setText:NSLocalizedString(@"可用", nil)];
            [cell.bottomA.bottomlb setText:[self checkFloatToStr:model.trade.doubleValue]];
            [cell.bottomB.toplb setText:NSLocalizedString(@"冻结", nil)];
            [cell.bottomB.bottomlb setText:[self checkFloatToStr:model.frozen.doubleValue]];
            [cell.bottomC.toplb setText:NSLocalizedString(@"折合(CHY)", nil)];
            [cell.bottomC.bottomlb setText:[self checkFloatToStr:model.chybalance.doubleValue]];
        }
    }
    
    return cell;
}

-(UICollectionView *)collectionview{
    if (!_collectionview) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.headerReferenceSize = CGSizeMake(ScreenWidth, 145.0f);  //设置headerView大小
        _collectionview = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionview.dataSource = self;
        _collectionview.delegate = self;
        _collectionview.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionview.backgroundColor = [UIColor backgroundGrayColor];
        _collectionview.showsVerticalScrollIndicator = NO;
        _collectionview.showsHorizontalScrollIndicator = NO;
        //解决categoryView在吸顶状态下，且collectionView的显示内容不满屏时，出现竖直方向滑动失效的问题
        _collectionview.alwaysBounceVertical = YES;
        [_collectionview registerClass:[HuobiPersonAssetsHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HuobiPersonAssetsHeaderView"];
        [self.view addSubview:_collectionview];
        [_collectionview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.width.equalTo(ScreenWidth);
            make.top.equalTo(0);
            make.bottom.equalTo(-SafeAreaBottomHeight);
        }];
       
    }
    return _collectionview;
}

@end
