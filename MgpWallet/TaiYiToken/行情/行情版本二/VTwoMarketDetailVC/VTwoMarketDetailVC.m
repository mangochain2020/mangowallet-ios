//
//  VTwoMarketDetailVC.m
//  TaiYiToken
//
//  Created by 张元一 on 2018/11/22.
//  Copyright © 2018 admin. All rights reserved.
//

#import "VTwoMarketDetailVC.h"
#import "ControlBtnsView.h"
#import "DataView.h"
#import "ButtonsView.h"
#import "DataPointView.h"
#import "YYStock.h"
#import "YYStockVariable.h"
#import "YYLineDataModel.h"
#import "MarketDetailTextCell.h"
#import "MarketDetailTextViewCell.h"
#import "WebVC.h"
#import "ShareMenuView.h"
#import "SymbolInfoModel.h"
#import "NewBaseInfoModel.h"
#import "BusinessModel.h"
#import "BuySaleRecordCell.h"
#import "VTwoDataView.h"
#import "CoinBaseInfoModel.h"
@interface VTwoMarketDetailVC ()<UIScrollViewDelegate,UIScrollViewAccessibilityDelegate,YYStockDataSource,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) id observer;
@property(nonatomic,strong) UIButton *shareBtn;
@property(nonatomic)NSInteger exchangeid;
@property(nonatomic,strong)CoinBaseInfoModel *coininfomodel;
@property(nonatomic)ControlBtnsView *exchangeButtonView;
/*** 上方行情基础信息，K线图选择按钮  ***/
@property(nonatomic,strong)UILabel *symbolsLabel;//交易对
@property(nonatomic,strong)UILabel *symbolLabel;
@property(nonatomic,strong)UIImageView *symbolIcon;
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIView *bridgeContentView;
@property(nonatomic,strong) UIButton *backBtn;
@property(nonatomic)VTwoDataView *dataView;
@property(nonatomic)ControlBtnsView *buttonView;
@property(nonatomic,strong)DataPointView *dataSelectView;
@property(nonatomic,strong)UIView *headBackgroundView;
@property(nonatomic,strong)UIButton *collectBtn;
@property(nonatomic,assign)KLineType linetype;
@property(nonatomic,copy)NSString *mysymbol;
@property(nonatomic,strong)NewSymbolInfo *symbolmodel;
/***** K线图 ****/
@property(nonatomic,strong)UILabel *showlabel;
@property(nonatomic,strong)NSMutableArray <KlineDataModel *>*kLinemodelArray;
@property (strong, nonatomic) YYStock *stock;
@property (strong, nonatomic) UIView *stockContainerView;

@property (strong, nonatomic) NSMutableDictionary *stockDatadict;
@property (copy, nonatomic) NSArray *stockDataKeyArray;
@property (copy, nonatomic) NSArray *stockTopBarTitleArray;
@property(nonatomic,strong)NSMutableArray <YYLineDataModel*> *linedataarray;
/**** 下方项目介绍  ****/
@property(nonatomic)ControlBtnsView *selectBaseInfoBtnView;//选择
@property(nonatomic,strong)UITableView *tableView;
@property (strong, nonatomic)NSMutableArray *leftarray;
@property (strong, nonatomic)NSMutableArray *rightarray;
@property (strong, nonatomic)NewBaseInfoModel *baseInfoModel;

@property(nonatomic,strong)UITableView *buyTableView;
@property(nonatomic,strong)BusinessModel *buymodel;
@property(nonatomic)NSInteger currentIndex;
@property(nonatomic)LangeuageType currentLanguageType;
@property(nonatomic)BOOL colorConfig;
@end
@implementation VTwoMarketDetailVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.hidesBottomBarWhenPushed = YES;
    self.colorConfig = [[NSUserDefaults standardUserDefaults] boolForKey:@"RiseColorConfig"];
    //截屏
    MJWeakSelf
    self.observer = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationUserDidTakeScreenshotNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        // executes after screenshot
        NSLog(@"截屏");
        [weakSelf shareAction];
    }];
    NSString *currentLanguage = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLanguageSelected"];
    if(currentLanguage == nil){
        currentLanguage = @"chinese";
        [[NSUserDefaults standardUserDefaults] setObject:@"chinese" forKey:@"CurrentLanguageSelected"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    self.currentLanguageType = [currentLanguage isEqualToString:@"english"]?USD_TYPE:CHY_TYPE;
    self.tabBarController.tabBar.hidden = YES;
    [self.stockContainerView showHUD];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.tabBarController.tabBar.hidden = NO;
    //离开页面时 存储自选
    _mysymbol = [[NSUserDefaults standardUserDefaults] objectForKey:@"MySymbol"];
    if (_mysymbol == nil) {
        _mysymbol = @"";
    }
    
    if (self.collectBtn.selected == YES && ![_mysymbol containsString:self.marketModel.coinCode]) {
        //yes : @"btc/eth,eos/bch,...," 最后一位加上“,”
        _mysymbol = [NSString stringWithFormat:@"%@,%@",self.marketModel.coinCode,_mysymbol];
    }else if(self.collectBtn.selected == NO && [_mysymbol containsString:self.marketModel.coinCode]){
        //no : @"btc/eth,eos/bch,...," 最后一位加上“,”
        NSString *str = [NSString stringWithFormat:@"%@,",self.marketModel.coinCode];
        NSString *forestr = [_mysymbol componentsSeparatedByString:str].firstObject;
        NSString *laststr = [_mysymbol componentsSeparatedByString:str].lastObject;
        _mysymbol = [NSString stringWithFormat:@"%@%@",forestr,laststr];
    }
    NSLog(@"mysymbol =  %@",_mysymbol);
    [[NSUserDefaults standardUserDefaults] setObject:_mysymbol forKey:@"MySymbol"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.hidesBottomBarWhenPushed = NO;
    if (self.observer) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.observer];
        self.observer = nil;
    }
}
- (void)popAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.exchangeid = 0;
    self.view.backgroundColor = [UIColor whiteColor];
    self.linetype = FIVE_MIN;
    self.kLinemodelArray = [NSMutableArray new];
    [self initHead];
    [self scrollView];
    _bridgeContentView = [UIView new];
    [self.scrollView addSubview:_bridgeContentView];
    [_bridgeContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.height.equalTo(self.scrollView.contentSize);
    }];
    [self initUI];
    
    _dataSelectView = [DataPointView new];
    _dataSelectView.backgroundColor = RGB(250, 250, 250);
    [_bridgeContentView addSubview:_dataSelectView];
    [_dataSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(0);
        make.top.equalTo(self.buttonView.mas_bottom);
        make.left.equalTo(0);
        make.height.equalTo(15);
    }];
    self.currentIndex = 2000;
    [self RequestKLineData];
    [self initStockView];
    NSMutableArray *leftarray;
    leftarray = [@[NSLocalizedString(@"发行时间", nil),NSLocalizedString(@"流通总量", nil),NSLocalizedString(@"众筹价格", nil),NSLocalizedString(@"全名", nil),NSLocalizedString(@"白皮书地址", nil),NSLocalizedString(@"区块查询", nil),NSLocalizedString(@"官网", nil),NSLocalizedString(@"发行总量", nil)] mutableCopy];
    self.leftarray = [leftarray mutableCopy];
    [self GetBaseInfo];
    [self GetBusinessList];
    [self RequestKLineData];
}

-(void)GetCoinInfo{
    NSString *currentLanguage = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLanguageSelected"];
    if(currentLanguage == nil){
        currentLanguage = @"chinese";
        [[NSUserDefaults standardUserDefaults] setObject:@"chinese" forKey:@"CurrentLanguageSelected"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    MJWeakSelf
    [NetManager GetCoinPriceInfoCoinCode:self.marketModel.coinCode kLineType:self.linetype Lang:[currentLanguage isEqualToString:@"english"]?USD_TYPE:CHY_TYPE ExchangeId:self.exchangeid completionHandler:^(id responseObj, NSError *error) {
        [weakSelf.stockContainerView hideHUD];
        if (!error) {
            if (![[NSString stringWithFormat:@"%@",responseObj[@"resultCode"]] isEqualToString:@"20000"]) {
                [weakSelf.view showAlert:[NSString stringWithFormat:@"Error:%ld",error.code] DetailMsg:responseObj[@"resultMsg"]];
                return ;
            }
            id ddd = responseObj[@"data"];
            if([ddd isEqual:[NSNull null]]){
                [weakSelf.view showMsg:NSLocalizedString(@"没有数据", nil)];
                return;
            }
            weakSelf.coininfomodel = [CoinBaseInfoModel parse:ddd];
            if (weakSelf.coininfomodel) {
                dispatch_async_on_main_queue(^{
                    [weakSelf setDataToHeadView];
                    [weakSelf exchangeButtonView];
                    if ([weakSelf.coininfomodel.klineData isEqual:[NSNull null]] || !weakSelf.coininfomodel.klineData) {
                        [weakSelf showNoKlineDataRemark];
                        [weakSelf.kLinemodelArray removeAllObjects];
                        //转换为stockmodel
                        [weakSelf parseKlineData:weakSelf.kLinemodelArray];
                    }else{
                        [weakSelf hideNoKlineDataRemark];
                        [weakSelf.kLinemodelArray removeAllObjects];
                        weakSelf.kLinemodelArray = [weakSelf.coininfomodel.klineData mutableCopy];
                        //转换为stockmodel
                        [weakSelf parseKlineData:weakSelf.kLinemodelArray];
                        
                    }
                });
            }
            
            
        }else{
            [weakSelf.view showAlert:[NSString stringWithFormat:@"Error:%ld",error.code] DetailMsg:error.localizedDescription];
        }
    }];
    
}



/****************************************  截屏  ******************************************/
-(void)shareAction{
    //人为截屏, 模拟用户截屏行为, 获取所截图片
    UIImage *image = [self imageWithScreenshot];
    UIImage *resultimage = [self generateShareImageWithMasterImage:image];
    NSArray *activityItemsArray = @[resultimage];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItemsArray applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypePostToWeibo,UIActivityTypeMessage,UIActivityTypeMail,UIActivityTypePostToTencentWeibo,UIActivityTypeAirDrop];
    activityVC.completionWithItemsHandler = ^(NSString *activityType,BOOL completed,NSArray *returnedItems,NSError *activityError)
    {
        NSLog(@"%@", activityType);
        
        if (completed) { // 确定分享
            NSLog(@"分享成功");
        }
        else {
            NSLog(@"分享失败");
        }
    };
    
    [self presentViewController:activityVC animated:YES completion:nil];
    
}
/**
 *  返回截取到的图片
 *
 *  @return UIImage *
 */
- (UIImage *)imageWithScreenshot{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(ScreenWidth, ScreenHeight - 100), YES, 0.0);
    
    [self.view.layer renderInContext: UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    if (image != nil) {
        return image;
    }else {
        NSData *imageData = [self dataWithScreenshotInPNGFormat];
        return [UIImage imageWithData:imageData];
    }
    
    
}

/**
 *  截取当前屏幕
 *
 *  @return NSData *
 */
- (NSData *)dataWithScreenshotInPNGFormat{
    CGSize imageSize = CGSizeZero;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation))
        imageSize = CGSizeMake(ScreenWidth, ScreenHeight);
    else
        imageSize = CGSizeMake(ScreenHeight, ScreenWidth);
    
    UIGraphicsBeginImageContextWithOptions(imageSize, YES, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y-15);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if (orientation == UIInterfaceOrientationLandscapeLeft)
        {
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        }
        else if (orientation == UIInterfaceOrientationLandscapeRight)
        {
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
        {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        }
        else
        {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return UIImagePNGRepresentation(image);
}
- (UIImage *)screenShotWithSize:(CGSize)size{
    UIImage* image = nil;
    /*
     *UIGraphicsBeginImageContextWithOptions有三个参数
     *size    bitmap上下文的大小，就是生成图片的size
     *opaque  是否不透明，当指定为YES的时候图片的质量会比较好
     *scale   缩放比例，指定为0.0表示使用手机主屏幕的缩放比例
     */
    UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);
    
    [self.view.layer renderInContext: UIGraphicsGetCurrentContext()];
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    if (image != nil) {
        return image;
    }else {
        return nil;
    }
}
/*
 masterImage  主图片，生成的图片的宽度为masterImage的宽度
 slaveImage   从图片，拼接在masterImage的下面
 */
- (UIImage *)generateShareImageWithMasterImage:(UIImage *)masterImage {
    //appiosdownload
    UIImage *topImage = [UIImage imageNamed:@"appiosdownload"];
    CGSize size;
    size.width = masterImage.size.width;
    size.height = masterImage.size.height + masterImage.size.width/topImage.size.width * topImage.size.height;
    
    UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);
    
    
    
    //Draw masterImage
    [topImage drawInRect:CGRectMake(0, -3, masterImage.size.width, masterImage.size.width/topImage.size.width * topImage.size.height + 5)];
    
    //Draw slaveImage
    [masterImage drawInRect:CGRectMake(0, masterImage.size.width/topImage.size.width * topImage.size.height, masterImage.size.width, masterImage.size.height)];
    
    UIImage *qrcodeimage = [CreateAll CreateQRCodeForAddress:@"http://misnetwork.io.s3-website-us-west-1.amazonaws.com"];
    [qrcodeimage drawInRect:CGRectMake(masterImage.size.width - 70, 20, 50, 50)];
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return resultImage;
}
/******************************************* 上方数据视图 ************************************************/
-(void)initHead{
    //头部背景
    _headBackgroundView = [UIView new];
    _headBackgroundView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_headBackgroundView];
    [_headBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(SafeAreaTopHeight - 64);
        make.height.equalTo(130);
    }];
    
    _symbolIcon  = [UIImageView new];
    _symbolIcon.contentMode = UIViewContentModeScaleAspectFit;
    [self.headBackgroundView addSubview:_symbolIcon];
    [_symbolIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ScreenWidth/2-40);
        make.centerY.equalTo(-15);
        make.width.equalTo(25);
        make.height.equalTo(25);
    }];
    
    _symbolLabel = [UILabel new];
    _symbolLabel.font = [UIFont boldSystemFontOfSize:20];
    _symbolLabel.textColor = [UIColor textBlackColor];
    _symbolLabel.textAlignment = NSTextAlignmentLeft;
    [self.headBackgroundView addSubview:_symbolLabel];
    [_symbolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ScreenWidth/2-5);
        make.centerY.equalTo(-15);
        make.width.equalTo(200);
        make.height.equalTo(30);
    }];
    
    
    _collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _collectBtn.tintColor = [UIColor appBlueColor];
    UIImage *image = [UIImage imageNamed:@"ico_focus_default"];
    image = [image imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
    UIImage *imagesel = [UIImage imageNamed:@"ico_focus_select"];
    imagesel = [imagesel imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
    [_collectBtn setImage:image forState:UIControlStateNormal];
    [_collectBtn setImage:imagesel forState:UIControlStateSelected];
    _mysymbol = [[NSUserDefaults standardUserDefaults] objectForKey:@"MySymbol"];
    if ([_mysymbol containsString:self.marketModel.coinCode]) {
        [self.collectBtn setSelected:YES];
    }else{
        [self.collectBtn setSelected:NO];
    }
    [_collectBtn addTarget:self action:@selector(collectToMySymbol) forControlEvents:UIControlEventTouchUpInside];
    [self.headBackgroundView addSubview:_collectBtn];
    [_collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-50);
        make.centerY.equalTo(-10);
        make.width.height.equalTo(30);
    }];
    
    _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _shareBtn.backgroundColor = [UIColor clearColor];
    _shareBtn.tintColor = [UIColor appBlueColor];
    
    UIImage *imageselshare = [UIImage imageNamed:@"ico_share"];
    imageselshare = [imageselshare imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
    [_shareBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [_shareBtn setImage:imageselshare forState:UIControlStateNormal];
    [_shareBtn setImage:imageselshare forState:UIControlStateHighlighted];
    [_shareBtn addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    [self.headBackgroundView addSubview:_shareBtn];
    _shareBtn.userInteractionEnabled = YES;
    [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-15);
        make.centerY.equalTo(-10);
        make.width.height.equalTo(30);
    }];
}

-(void)setDataToHeadView{
   
    NSString *unitstr = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentCurrencySelected"];
    [_symbolIcon sd_setImageWithURL:self.coininfomodel.coinLogo.STR_URLString];
    _symbolLabel.text = self.coininfomodel.coinCode;
    if (!_dataView) {
        _dataView = [VTwoDataView new];
        _dataView.backgroundColor = [UIColor whiteColor];
        [_bridgeContentView addSubview:_dataView];
        [_dataView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.top.equalTo(SafeAreaTopHeight - 64);
            make.height.equalTo(100);
        }];
    }
    [_dataView.commentlabel setText:[NSString stringWithFormat:@"%@%@",self.coininfomodel.coinCode,NSLocalizedString(@"全网实时价格，24h涨幅", nil)]];
    [_dataView.infolabel setText:[NSString stringWithFormat:@"≈%@%.2f  ≈%.4fBTC  ≈%.4fETH",[unitstr isEqualToString:@"rmb"]?@"$":@"$",[unitstr isEqualToString:@"rmb"]?self.coininfomodel.coinDollarPrice:self.coininfomodel.coinDollarPrice,_coininfomodel.coinBTCPrice,_coininfomodel.coinETHPrice]];
    if (self.colorConfig == YES) {
        [_dataView.ratelabel setTextColor:self.coininfomodel.coinChangeRate.floatValue > 0? BTNFALLCOLOR : BTNRISECOLOR];
        [_dataView.pricelabel setTextColor:self.coininfomodel.coinChangeRate.floatValue > 0? BTNFALLCOLOR : BTNRISECOLOR];
        [_dataView.lowpricelabel setTextColor:BTNRISECOLOR];
        [_dataView.highpricelabel setTextColor:BTNFALLCOLOR];
    }else{
        [_dataView.ratelabel setTextColor:self.coininfomodel.coinChangeRate.floatValue > 0? BTNRISECOLOR : BTNFALLCOLOR];
        [_dataView.pricelabel setTextColor:self.coininfomodel.coinChangeRate.floatValue > 0? BTNRISECOLOR : BTNFALLCOLOR];
        [_dataView.lowpricelabel setTextColor:BTNFALLCOLOR];
        [_dataView.highpricelabel setTextColor:BTNRISECOLOR];
    }
    NSString *retestr = [NSString stringWithFormat:@"%@%@",self.coininfomodel.coinChangeRate.floatValue>0?@"+":@"",self.coininfomodel.coinChangeRate];
    _dataView.ratelabel.text = [NSString stringWithFormat:@"%.2f   %@",self.coininfomodel.coinChangePrice,retestr];
    
    _dataView.lowpricelabel.text = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%lf",self.coininfomodel.lowPrice].convertedstr];
    _dataView.highpricelabel.text = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%lf",self.coininfomodel.highPrice].convertedstr];
    _dataView.marketVolumelabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"市值", nil),self.coininfomodel.marketValue];
    _dataView.volumelabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"额", nil),self.coininfomodel.volStr];
//    _dataView.changeratelabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"涨跌幅", nil),retestr];
    _dataView.ranklabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"排名", nil),VALIDATE_STRING(self.rank)];
    _dataView.pricelabel.text = [NSString stringWithFormat:@"%@%.2f",[unitstr isEqualToString:@"rmb"]?@"¥":@"$",[unitstr isEqualToString:@"rmb"]?self.coininfomodel.coinRmbPrice:self.coininfomodel.coinDollarPrice];
    if (self.coininfomodel.defaultExchangeId < self.exchangeButtonView.btnArray.count) {
        [self.exchangeButtonView setBtnSelectedWithTag:self.coininfomodel.defaultExchangeId - 1];
    }
}

-(void)initUI{
    
    //基本数据
    _dataView = [[VTwoDataView alloc]init];
    _dataView.backgroundColor = [UIColor whiteColor];
    [_bridgeContentView addSubview:_dataView];
    [_dataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(0);
        make.height.equalTo(100);
    }];
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _backBtn.tintColor = [UIColor appBlueColor];
    [_backBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    UIImage *image = [UIImage imageNamed:@"ico_right_arrow"];
    image = [image imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
    [_backBtn setImage:image forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backBtn];
    _backBtn.userInteractionEnabled = YES;
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(SafeAreaTopHeight - 24);
        make.height.equalTo(25);
        make.left.equalTo(10);
        make.width.equalTo(30);
    }];
    
}

/*
 加入/移除 自选
 */
-(void)collectToMySymbol{
    if (_collectBtn.selected == YES) {
        [_collectBtn setSelected:NO];
    }else{
        [_collectBtn setSelected:YES];
    }
}

/******************************************* K线图 ************************************************/

-(void)showNoKlineDataRemark{
    
    if (!_showlabel) {
        _showlabel = [UILabel new];
        _showlabel.backgroundColor = [UIColor whiteColor];
        _showlabel.textColor = [UIColor grayColor];
        _showlabel.font = [UIFont systemFontOfSize:13];
        _showlabel.textAlignment = NSTextAlignmentCenter;
        _showlabel.text = NSLocalizedString(@"暂不支持趋势图", nil);
        _showlabel.numberOfLines = 1;
    }
    
    self.showlabel.alpha = 1;
    [self.stockContainerView addSubview:_showlabel];
    [_showlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.top.bottom.equalTo(0);
        make.right.equalTo(0);
    }];
}
-(void)hideNoKlineDataRemark{
    self.showlabel.alpha = 0;
}
/*
 选择k线图时间
 */
-(void)switchBtnClick:(UIButton*)button{
    [_buttonView setBtnSelected:button];
    KLineType type;
    /* ONE_MIN = 0,
     FIVE_MIN = 1,
     FIFTEEN_MIN = 2,
     THIRTY_MIN = 3,
     ONE_HOUR = 4,
     ONE_DAY = 5,
     ONE_WEEK = 6,
     ONE_MON = 7,
     ONE_YEAR = 8*/
    switch (button.tag) {
        case 0:
            type = 0;
            break;
        case 1:
            type = 1;
            break;
        case 2:
            type = 2;
            break;
        case 3:
            type = 4;
            break;
        case 4:
            type = 5;
            break;
        case 5:
            type = 6;
            break;
        default:
            type = 0;
            break;
    }
    
    self.linetype = type;
    //修改数据
    [self RequestKLineData];
}

//选交易所
-(void)switchExchanges:(UIButton*)button{
    [_exchangeButtonView setBtnSelected:button];
    self.exchangeid = self.coininfomodel.exchangeItems[button.tag].exchangeId;
    //修改数据
    [self RequestKLineData];
}

//请求数据
-(void)RequestKLineData{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self GetCoinInfo];
    });
}
//解析KlineData数组
-(void)parseKlineData:(NSMutableArray *)kLineDataArray{
    [self setDataToHeadView];
    NSMutableArray <YYLineDataModel *> *array = [NSMutableArray new];
    self.linedataarray = [NSMutableArray new];
    YYLineDataModel *premodel = [YYLineDataModel new];
    int i1 = 0;
    int i2 = 1;
    if(!_symbolsLabel){
        _symbolsLabel = [UILabel new];
        _symbolsLabel.font = [UIFont boldSystemFontOfSize:13];
        _symbolsLabel.textColor = [UIColor textBlackColor];
        _symbolsLabel.text  = [NSString stringWithFormat:@"| %@",self.coininfomodel.defaultSymbol];
        _symbolsLabel.textAlignment = NSTextAlignmentRight;
        [self.bridgeContentView addSubview:_symbolsLabel];
        [_symbolsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.dataView.mas_bottom).equalTo(54);
            make.right.equalTo(-10);
            make.width.equalTo(100);
            make.height.equalTo(44);
        }];
    }
    if (kLineDataArray.count == 0 || [kLineDataArray isEqual:[NSNull null]] || kLineDataArray == nil) {
        
        return;
    }
    
    for (KlineDataModel *model in kLineDataArray) {
        @autoreleasepool {
            if (i1==3) {
                i1 = 0;
            }
            if (i2 == 10) {
                i2 = 0;
            }
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            NSString *daystr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:model.ID]];
            
            NSDictionary *dicmodel= @{ @"amount" : [NSNumber numberWithFloat:model.amount == 0?0:model.amount],
                                       @"close" : [NSNumber numberWithFloat:model.closePrice == 0?0:model.closePrice],
                                       @"day" : daystr,
                                       @"high" : [NSNumber numberWithFloat:model.highPrice == 0?0:model.highPrice],
                                       @"id" : @0,
                                       @"low" : [NSNumber numberWithFloat:model.lowPrice == 0?0:model.lowPrice],
                                       @"open" : [NSNumber numberWithFloat:model.openPrice == 0?0:model.openPrice],
                                       @"volume" :[NSNumber numberWithFloat:model.vol == 0?0:model.vol],
                                       @"ma5":[NSNumber numberWithFloat:model.fiveData == 0?0:model.fiveData],
                                       @"ma10":[NSNumber numberWithFloat:model.tenData == 0?0:model.tenData],
                                       @"ma20":[NSNumber numberWithFloat:model.thirtyData == 0?0:model.thirtyData],
                                       };
            i1++;
            i2++;
            
            YYLineDataModel *ymodel = [[YYLineDataModel alloc]initWithDict:dicmodel];
            ymodel.preDataModel = premodel;
            premodel = ymodel;
            [array addObject:ymodel];
            
            ////
            [ymodel updateMA:nil index:0];
        }
    }
    self.linedataarray = [array mutableCopy];
    [self.stockDatadict setObject:array forKey:@"5minutes"];
    
    [self.stock.mainView layoutSubviews];
    [self.stock draw];
    
}
- (void)initStockView {
    
    self.stockContainerView = [UIView new];
    self.stockContainerView.backgroundColor = [UIColor whiteColor];
    [self.bridgeContentView addSubview:_stockContainerView];
    [_stockContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dataSelectView.mas_bottom).equalTo(0);
        make.left.right.equalTo(0);
        make.height.equalTo(300);
    }];
    
    
    [YYStockVariable setStockLineWidthArray:@[@6,@6,@6,@6]];
    
    YYStock *stock = [[YYStock alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 300) dataSource:self];
    _stock = stock;
    [_stockContainerView addSubview:stock.mainView];
    [stock.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.stockContainerView);
    }];
    
    [self.stock.containerView.subviews setValue:@1 forKeyPath:@"userInteractionEnabled"];
}
/*******************************************股票数据源代理*********************************************/
-(NSArray <NSString *> *) titleItemsOfStock:(YYStock *)stock {
    return self.stockTopBarTitleArray;
}

-(NSArray *) YYStock:(YYStock *)stock stockDatasOfIndex:(NSInteger)index {
    return self.stockDatadict[self.stockDataKeyArray[index]];
}

-(YYStockType)stockTypeOfIndex:(NSInteger)index {
    return YYStockTypeLine;
}

- (id<YYStockFiveRecordProtocol>)fiveRecordModelOfIndex:(NSInteger)index {
    return nil;
}
//
- (BOOL)isShowfiveRecordModelOfIndex:(NSInteger)index {
    return NO;
}
/*******************************************getter*********************************************/
- (NSMutableDictionary *)stockDatadict {
    if (!_stockDatadict) {
        _stockDatadict = [NSMutableDictionary dictionary];
    }
    return _stockDatadict;
}

- (NSArray *)stockDataKeyArray {
    if (!_stockDataKeyArray) {
        _stockDataKeyArray = @[@"5minutes"];
    }
    return _stockDataKeyArray;
}

- (NSArray *)stockTopBarTitleArray {
    if (!_stockTopBarTitleArray) {
        _stockTopBarTitleArray = @[NSLocalizedString(@"5分", nil)];
    }
    return _stockTopBarTitleArray;
}

- (NSString *)getToday {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyyMMdd";
    return [dateFormatter stringFromDate:[NSDate date]];
}

#pragma lazy

-(UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _scrollView.backgroundColor = RGB(230, 230, 230);
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.scrollEnabled = YES;
        _scrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight + 400);
        _scrollView.delegate =self;
        _scrollView.scrollsToTop = YES;
        //  _scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self.view addSubview:_scrollView];
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.top.equalTo(SafeAreaTopHeight + 16);
            make.bottom.equalTo(0);
        }];
        
    }
    
    return _scrollView;
}
-(ControlBtnsView *)exchangeButtonView{
    if (!_exchangeButtonView) {
        _exchangeButtonView = [ControlBtnsView new];
       
        NSMutableArray *arr = [NSMutableArray new];
        if (self.coininfomodel) {
            for (ExchangeItem *item in self.coininfomodel.exchangeItems) {
                [arr addObject:item.exchangeName];
            }
        }
        [_exchangeButtonView initButtonsViewWithTitles:arr Width:ScreenWidth Height:44];
        
        NSInteger index = 0;
        for (UIButton *btn in _exchangeButtonView.btnArray) {
            btn.tag = index;
            if (index == 0) {
                [_exchangeButtonView setBtnSelectedWithTag:0];
            }
            [btn addTarget:self action:@selector(switchExchanges:) forControlEvents:UIControlEventTouchUpInside];
            index++;
        }
         _exchangeButtonView.lineView.hidden = YES;
        [self.bridgeContentView addSubview:_exchangeButtonView];
        [_exchangeButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.dataView.mas_bottom).equalTo(5);
            make.left.right.equalTo(0);
            make.height.equalTo(44);
        }];
        
        
    }
    
    return _exchangeButtonView;
}
-(ControlBtnsView *)buttonView{
    if (!_buttonView) {
        _buttonView = [ControlBtnsView new];
        [_buttonView initButtonsViewWithTitles:@[NSLocalizedString(@"1分", nil),NSLocalizedString(@"5分", nil),NSLocalizedString(@"15分", nil),NSLocalizedString(@"1时", nil),NSLocalizedString(@"日", nil),NSLocalizedString(@"周", nil)] Width:ScreenWidth-120 Height:44];
        
        NSInteger index = 0;
        for (UIButton *btn in _buttonView.btnArray) {
            btn.tag = index;
            if (index == 0) {
                [_buttonView setBtnSelectedWithTag:0];
            }
            [btn addTarget:self action:@selector(switchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            index++;
        }
        [self.bridgeContentView addSubview:_buttonView];
        [_buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.dataView.mas_bottom).equalTo(54);
            make.left.right.equalTo(0);
            make.height.equalTo(44);
        }];
        
    }
    
    return _buttonView;
}
/***************************    下方项目介绍      **********************************/
-(void)GetBusinessList{
    MJWeakSelf
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *currentLanguage = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLanguageSelected"];
        if(currentLanguage == nil){
            currentLanguage = @"chinese";
            [[NSUserDefaults standardUserDefaults] setObject:@"chinese" forKey:@"CurrentLanguageSelected"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        [NetManager GetBusinessWithMySymbol:[NSString stringWithFormat:@"%@/USDT", weakSelf.marketModel.coinCode] Lang:[currentLanguage isEqualToString:@"english"]?USD_TYPE:CHY_TYPE ExchangeId:weakSelf.exchangeid completionHandler:^(id responseObj, NSError *error) {
            if (!error) {
                if (![[NSString stringWithFormat:@"%@",responseObj[@"resultCode"]] isEqualToString:@"20000"]) {
                    [weakSelf.view showAlert:[NSString stringWithFormat:@"Error:%ld",error.code] DetailMsg:responseObj[@"resultMsg"]];
                    return ;
                }
                NSDictionary *dic;
                dic = responseObj[@"data"];
                if (![dic isEqual:[NSNull null]]) {
                    weakSelf.buymodel = [BusinessModel parse:dic];
                    dispatch_async_on_main_queue(^{
                        weakSelf.buyTableView.hidden = NO;
                        [weakSelf.buyTableView reloadData];
                    });
                }
              
            }else{
                [weakSelf.view showAlert:[NSString stringWithFormat:@"Error:%ld",error.code] DetailMsg:error.localizedDescription];
            }

        }];

    });
}
-(void)GetBaseInfo{
    MJWeakSelf
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *currentLanguage = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLanguageSelected"];
        if(currentLanguage == nil){
            currentLanguage = @"chinese";
            [[NSUserDefaults standardUserDefaults] setObject:@"chinese" forKey:@"CurrentLanguageSelected"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        [NetManager GetMarketBaseInfoWithMySymbol:weakSelf.marketModel.coinCode Lang:[currentLanguage isEqualToString:@"english"]?USD_TYPE:CHY_TYPE completionHandler:^(id responseObj, NSError *error) {
            if (!error) {
                if (![[NSString stringWithFormat:@"%@",responseObj[@"resultCode"]] isEqualToString:@"20000"]) {
                    [weakSelf.view showAlert:[NSString stringWithFormat:@"Error:%ld",error.code] DetailMsg:responseObj[@"resultMsg"]];
                    return ;
                }
                NSDictionary *dic;
                dic = responseObj[@"data"];
                weakSelf.baseInfoModel = [NewBaseInfoModel parse:dic];
                if (weakSelf.baseInfoModel && ![weakSelf.baseInfoModel isEqual:[NSNull null]]) {
                    dispatch_async_on_main_queue(^{
                        [weakSelf CreateTableView];
                    });
                }
                
            }else{
                [weakSelf.view showAlert:[NSString stringWithFormat:@"Error:%ld",error.code] DetailMsg:error.localizedDescription];
            }
        }];
    });
}
-(void)CreateTableView{
    
    NSString *whitepaperstring = self.baseInfoModel.whitePaper == nil?@"":self.baseInfoModel.whitePaper;
    NSString *whitepaperurl = [[whitepaperstring componentsSeparatedByString:@"\">"].lastObject componentsSeparatedByString:@"</a>"].firstObject;
    NSString *blockQuerystring = self.baseInfoModel.blockQuery == nil?@"":self.baseInfoModel.blockQuery;
    NSString *blockQueryurl = [[blockQuerystring componentsSeparatedByString:@"\">"].lastObject componentsSeparatedByString:@"</a>"].firstObject;
    NSString *officialWebsitestring = self.baseInfoModel.officialWebsite == nil?@"":self.baseInfoModel.officialWebsite;
    NSString *officialWebsiteurl = [[officialWebsitestring componentsSeparatedByString:@"\">"].lastObject componentsSeparatedByString:@"</a>"].firstObject;
    
    NSMutableArray *rightarray = [NSMutableArray new];
    [rightarray addObject:self.baseInfoModel.publishTime == nil?@"":self.baseInfoModel.publishTime];
    [rightarray addObject:self.baseInfoModel.circulateVolume == nil?@"":self.baseInfoModel.circulateVolume];
    [rightarray addObject:self.baseInfoModel.crowdFundingPrice == nil?@"":self.baseInfoModel.crowdFundingPrice];
    [rightarray addObject:self.baseInfoModel.fullName == nil?@"":self.baseInfoModel.fullName];
    [rightarray addObject:whitepaperurl == nil?@"":whitepaperurl];
    [rightarray addObject:blockQueryurl == nil?@"":blockQueryurl];
    [rightarray addObject:officialWebsiteurl == nil?@"":officialWebsiteurl];
    [rightarray addObject:self.baseInfoModel.publishVolume == nil?@"":self.baseInfoModel.publishVolume];
    
    [self.rightarray removeAllObjects];
    
    self.rightarray = [rightarray mutableCopy];
    
    [self.tableView reloadData];
    UITextView *textview = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
    textview.font = [UIFont systemFontOfSize:15];
    textview.text = self.baseInfoModel.summary;
    float newheight = self.bridgeContentView.height;
    CGSize oldFrame = self.scrollView.contentSize;
    [self.scrollView setContentSize:CGSizeMake(oldFrame.width, newheight)];
    [self.scrollView layoutSubviews];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.currentIndex == 2001){
        if (indexPath.row >= 5) {
            MarketDetailTextCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            if (![cell.rightLabel.text isEqualToString:@""]) {
                WebVC *webvc = [WebVC new];
                webvc.urlstring = cell.rightLabel.text;
                [self.navigationController pushViewController:webvc animated:YES];
            }
            
        }
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}
- (float) heightForString:(UITextView *)textView andWidth:(float)width{
    CGSize sizeToFit = [textView sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    return sizeToFit.height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.currentIndex == 2001){
        if (indexPath.row == 0) {
            UITextView *textview = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
            textview.font = [UIFont systemFontOfSize:15];
            textview.text = self.baseInfoModel.summary;
            return  [self heightForString:textview andWidth:ScreenWidth];
        }
        return UITableViewAutomaticDimension;
    }else{
        return 35;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.currentIndex == 2001){
        return 8;//9
    }else{
        if (self.buymodel == nil || !self.buymodel.buyInfo ||!self.buymodel.saleInfo) {
            return 0;
        }
        NSInteger count = self.buymodel.buyInfo.count > self.buymodel.saleInfo.count?self.buymodel.buyInfo.count:self.buymodel.saleInfo.count;
        return count + 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.currentIndex == 2001){
        if (indexPath.row == 0) {
            MarketDetailTextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MarketDetailTextViewCell"];
            if (cell == nil) {
                cell = [MarketDetailTextViewCell new];
            }
            [cell.celltextView setText:self.baseInfoModel.summary == nil?@"":self.baseInfoModel.summary];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            MarketDetailTextCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"MarketDetailTextCell"];
            if (cell == nil) {
                cell = [MarketDetailTextCell new];
            }
            if (indexPath.row - 1 < self.rightarray.count - 1) {
                [cell.leftLabel setText:self.leftarray[indexPath.row - 1]];
                [cell.rightLabel setText:self.rightarray[indexPath.row - 1]];
            }
            cell.leftLabel.textColor = [UIColor grayColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.leftLabel.font = [UIFont systemFontOfSize:15];
            if (indexPath.row >= 5) {
                cell.rightLabel.textColor = [UIColor textBlueColor];
            }
            return cell;
        }
    }else{
        if (indexPath.row == 0) {
            BuySaleRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BuySaleRecordCell"];
            if (cell == nil) {
                cell = [BuySaleRecordCell new];
            }
            [cell.buyPricelb setText:NSLocalizedString(@"买入价", nil)];
            [cell.buyAmoutlb setText:NSLocalizedString(@"买入量", nil)];
            [cell.salePricelb setText:NSLocalizedString(@"卖出价", nil)];
            [cell.saleAmoutlb setText:NSLocalizedString(@"卖出量", nil)];
            cell.buyPricelb.textColor = [UIColor textBlackColor];
            cell.buyAmoutlb.textColor = [UIColor textBlackColor];
            cell.salePricelb.textColor = [UIColor textBlackColor];
            cell.saleAmoutlb.textColor = [UIColor textBlackColor];
            cell.buyPricelb.font = [UIFont boldSystemFontOfSize:13];
            cell.buyAmoutlb.font = [UIFont boldSystemFontOfSize:13];
            cell.saleAmoutlb.font = [UIFont boldSystemFontOfSize:13];
            cell.salePricelb.font = [UIFont boldSystemFontOfSize:13];
            cell.backgroundColor = kRGBA(255, 250, 240, 1);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            BuySaleRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BuySaleRecordCell"];
            cell.backgroundColor = kRGBA(255, 255, 255, 1);
            if (cell == nil) {
                cell = [BuySaleRecordCell new];
            }
            NSArray *buyarr = @[@"",@""];
            NSArray *salearr = @[@"",@""];
            if (indexPath.row - 1 < self.buymodel.buyInfo.count) {
                buyarr = self.buymodel.buyInfo[indexPath.row - 1];
            }
            if (indexPath.row - 1 < self.buymodel.saleInfo.count) {
                salearr = self.buymodel.saleInfo[indexPath.row - 1];
            }
            NSString *unitstr = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentCurrencySelected"];
            
            NSString *unit = [unitstr isEqualToString:@"rmb"]?@"¥":@"$";
            CGFloat currency = [unitstr isEqualToString:@"rmb"]?self.RMBDollarCurrency:1.0;
            [cell.buyAmoutlb setText:[NSString stringWithFormat:@"%@",buyarr[1]].convertedstr];
            [cell.buyPricelb setText:[NSString stringWithFormat:@"%@%@",unit, [NSString stringWithFormat:@"%.2f",((NSString *)buyarr[0]).floatValue*currency].convertedstr]];
            [cell.saleAmoutlb setText:[NSString stringWithFormat:@"%@",salearr[1]].convertedstr];
            [cell.salePricelb setText:[NSString stringWithFormat:@"%@%@",unit, [NSString stringWithFormat:@"%.2f",((NSString *)buyarr[0]).floatValue*currency].convertedstr]];
            cell.buyPricelb.textColor = [UIColor textOrangeColor];
            cell.buyAmoutlb.textColor = [UIColor textGrayColor];
            cell.salePricelb.textColor = [UIColor textOrangeColor];
            cell.saleAmoutlb.textColor = [UIColor textGrayColor];
            cell.buyPricelb.font = [UIFont systemFontOfSize:13];
            cell.buyAmoutlb.font = [UIFont systemFontOfSize:13];
            cell.saleAmoutlb.font = [UIFont systemFontOfSize:13];
            cell.salePricelb.font = [UIFont systemFontOfSize:13];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    }
    
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins  = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
}

-(UITableView *)tableView{
    if (!_tableView) {
        [self selectBaseInfoBtnView];
        _tableView = [UITableView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        UIView *view = [[UIView alloc] init];
        _tableView.tableFooterView = view;
        _tableView.hidden = YES;//一开始先隐藏
        [_tableView registerClass:[MarketDetailTextCell class] forCellReuseIdentifier:@"MarketDetailTextCell"];
        [_tableView registerClass:[MarketDetailTextViewCell class] forCellReuseIdentifier:@"MarketDetailTextViewCell"];
        [self.bridgeContentView addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.stockContainerView.mas_bottom).equalTo(40);
            make.left.right.equalTo(0);
            make.bottom.equalTo(0);
        }];
    }
    
    return _tableView;
}


-(UITableView *)buyTableView{
    if (!_buyTableView) {
        [self selectBaseInfoBtnView];
        _buyTableView = [UITableView new];
        _buyTableView.backgroundColor = [UIColor whiteColor];
        _buyTableView.delegate = self;
        _buyTableView.dataSource = self;
        _buyTableView.showsVerticalScrollIndicator = NO;
        UIView *view = [[UIView alloc] init];
        _buyTableView.tableFooterView = view;
        _buyTableView.hidden = YES;//一开始先隐藏
        [_buyTableView registerClass:[BuySaleRecordCell class] forCellReuseIdentifier:@"BuySaleRecordCell"];
        [self.bridgeContentView addSubview:_buyTableView];
        [_buyTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.stockContainerView.mas_bottom).equalTo(40);
            make.left.right.equalTo(0);
            make.bottom.equalTo(0);
        }];
    }
    return _buyTableView;
}
-(void)selectBaseInfo:(UIButton *)btn{
    [_selectBaseInfoBtnView setBtnSelected:btn];
    if (btn.tag == 0) {
        self.currentIndex = 2000;
        [self.tableView setHidden:YES];
        [self.buyTableView setHidden:NO];
        [self.buyTableView reloadData];
    }else{
        self.currentIndex = 2001;
        [self.tableView setHidden:NO];
        [self.buyTableView setHidden:YES];
        [self CreateTableView];
    }
}
-(ControlBtnsView *)selectBaseInfoBtnView{
    if (!_selectBaseInfoBtnView) {
        _selectBaseInfoBtnView = [ControlBtnsView new];
        [_selectBaseInfoBtnView initButtonsViewWithTitles:@[NSLocalizedString(@"买卖", nil),NSLocalizedString(@"项目介绍", nil)] Width:ScreenWidth Height:44];
        NSInteger index = 0;
        for (UIButton *btn in _selectBaseInfoBtnView.btnArray) {
            btn.tag = index;
            
            if (index == 0) {
                [_selectBaseInfoBtnView setBtnSelected:btn];
            }
            
            [btn addTarget:self action:@selector(selectBaseInfo:) forControlEvents:UIControlEventTouchUpInside];
            index++;
        }
        [self.bridgeContentView addSubview:_selectBaseInfoBtnView];
        [_selectBaseInfoBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.stockContainerView.mas_bottom).equalTo(5);
            make.left.right.equalTo(0);
            make.bottom.equalTo(0);
        }];
    }
    
    return _selectBaseInfoBtnView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self.kLinemodelArray removeAllObjects];
    
}

@end
