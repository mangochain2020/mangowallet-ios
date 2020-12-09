//
//  MisHuobiExchangeVC.m
//  TaiYiToken
//
//  Created by 张元一 on 2019/3/8.
//  Copyright © 2019 admin. All rights reserved.
//

#import "MisHuobiExchangeVC.h"
#import "SelectHuobiSymbolsVC.h"
#import "HuobiRightExchangeVC.h"
#import "CurrentOrderVC.h"
#import "AllHuobiOrdersVC.h"
#import "HuobiUnAuthVC.h"
#import "HuobiPersonAssetsVC.h"
@interface MisHuobiExchangeVC ()<UITextFieldDelegate>
@property(nonatomic ,assign)BOOL opertionIsMarket;//限价市价
@property(nonatomic ,assign)BOOL opertionIsSale;
@property(nonatomic,strong)HuobiExchangeView *leftexchangeview;
@property(nonatomic,strong)SelectHuobiSymbolsVC *selectSymbolVC;
@property(nonatomic,strong)HuobiRightExchangeVC *rightExchangeVC;
@property(nonatomic,strong)CurrentOrderVC *currentOrderVC;
@property(nonatomic,copy)NSString *currentSymbols;

@property (nonatomic, strong)UIButton *assetsBtn;
@property (nonatomic, strong)UIButton *unauthBtn;

@property(nonatomic,strong)NSMutableArray <HuobiBalanceListObj *>*balancedataArray;
@property(nonatomic,copy)NSString *currentBalance;

@end

@implementation MisHuobiExchangeVC

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    MJWeakSelf
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [HuobiManager HuobiGetBalanceCompletionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
            if (!error) {
                NSLog(@"%@",responseObj);
                HuobiBalanceModel *model = [HuobiBalanceModel parse:responseObj];
                if (model.resultCode != 20000) {
                    [weakSelf.view showMsg:model.resultMsg];
                }else{
                    [weakSelf.balancedataArray removeAllObjects];
                    weakSelf.balancedataArray = [model.data.data.list mutableCopy];
                    dispatch_async_on_main_queue(^{
                        [self changeAvailableCurrency];
                    });
                }
            }else{
                [weakSelf.view showMsg:error.userInfo.description];
            }
            
        }];
        
        
    });
   
}

-(void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.balancedataArray = [NSMutableArray new];
    self.currentSymbols = DefaultHuobiExchangeSymbol;
    [[NSUserDefaults standardUserDefaults] setObject:DefaultHuobiExchangeSymbol forKey:CurrentHuobiSymbols];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.opertionIsSale = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:@"ToolViewShouldHide" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeNewPrice:) name:@"SelectNewPrice" object:nil];
    //手势控制toolview
    UISwipeGestureRecognizer *swipeGestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    [swipeGestureRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.bridgeContentView addGestureRecognizer:swipeGestureRight];
    
    UISwipeGestureRecognizer *swipeGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    [swipeGestureLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.bridgeContentView addGestureRecognizer:swipeGestureLeft];
 
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [self.bridgeContentView addGestureRecognizer:tapGesture];
    
    //leftexchangeview
    _leftexchangeview = [HuobiExchangeView new];
    [_leftexchangeview loadLeftView];
    [_leftexchangeview.buyBtn addTarget:self action:@selector(selectBuy:) forControlEvents:UIControlEventTouchUpInside];
    [_leftexchangeview.saleBtn addTarget:self action:@selector(selectSale:) forControlEvents:UIControlEventTouchUpInside];
    [_leftexchangeview.operationBtn addTarget:self action:@selector(doOperation:) forControlEvents:UIControlEventTouchUpInside];
    [_leftexchangeview.buychooseBtn addTarget:self action:@selector(showBuyChooseAlert:) forControlEvents:UIControlEventTouchUpInside];
    [_leftexchangeview.priceTF.toolview.addBtn addTarget:self action:@selector(addPrice) forControlEvents:UIControlEventTouchUpInside];
    [_leftexchangeview.priceTF.toolview.subBtn addTarget:self action:@selector(reducePrice) forControlEvents:UIControlEventTouchUpInside];
    [_leftexchangeview.showSelectSymbolViewBtn addTarget:self action:@selector(showToolView) forControlEvents:UIControlEventTouchUpInside];
    [_leftexchangeview.symbolLb setText:VALIDATE_STRING(self.currentSymbols)];
    _leftexchangeview.priceTF.huobiTF.delegate = self;
    _leftexchangeview.priceTF.huobiTF.tag = 1039;
    _leftexchangeview.quantityTF.huobiTF.delegate = self;
    _leftexchangeview.quantityTF.huobiTF.tag = 1040;
    NSString *symbol = [self.currentSymbols componentsSeparatedByString:@"/"].firstObject;
    NSString *basesymbol = [self.currentSymbols componentsSeparatedByString:@"/"].lastObject;
    [_leftexchangeview.quantityTF.coinLb setText:VALIDATE_STRING(basesymbol)];
    [_leftexchangeview.operationBtn setTitle:[NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"买入", nil),VALIDATE_STRING(symbol)] forState:UIControlStateNormal];
    [self.bridgeContentView addSubview:_leftexchangeview];
    [_leftexchangeview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.top.equalTo(10);
        make.right.equalTo(-130);
        make.height.equalTo(450);
    }];
    [self rightExchangeVC];
    [_rightExchangeVC.typeBtn addTarget:self action:@selector(rightTypeChange) forControlEvents:UIControlEventTouchUpInside];
    [_rightExchangeVC.depthBtn addTarget:self action:@selector(depthChange) forControlEvents:UIControlEventTouchUpInside];
    [self selectSymbolVC];
    
    _assetsBtn = [HuobiBtn HuobiMyAssetsBtn];
    _unauthBtn = [HuobiBtn HuobiUnAuthBtn];
    [_assetsBtn addTarget:self action:@selector(goToSeeAssets) forControlEvents:UIControlEventTouchUpInside];
    [_unauthBtn addTarget:self action:@selector(goToUnAuth) forControlEvents:UIControlEventTouchUpInside];
    [self.bridgeContentView addSubview:_assetsBtn];
    [self.bridgeContentView addSubview:_unauthBtn];
    [_assetsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-45);
        make.top.equalTo(10);
        make.width.equalTo(30);
        make.height.equalTo(30);
    }];
    [_unauthBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-10);
        make.top.equalTo(10);
        make.width.equalTo(30);
        make.height.equalTo(30);
    }];
    [self currentOrderVC];
    self.navigationController.title = @"";
}

-(void)seeAllOrders{
    AllHuobiOrdersVC *vc = [AllHuobiOrdersVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma TopAction
-(void)goToSeeAssets{
    HuobiPersonAssetsVC *vc = [HuobiPersonAssetsVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)goToUnAuth{
    HuobiUnAuthVC *vc = [HuobiUnAuthVC new];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma left tool view methods
-(void)selectBuy:(UIButton *)btn{
    self.opertionIsSale = NO;
    [_leftexchangeview.buyBtn setSelected:YES];
    [_leftexchangeview.saleBtn setSelected:NO];
    [_leftexchangeview.operationBtn setSelected:NO];
    NSString *symbol = [self.currentSymbols componentsSeparatedByString:@"/"].firstObject;
    NSString *basesymbol = [self.currentSymbols componentsSeparatedByString:@"/"].lastObject;
    [_leftexchangeview.quantityTF.coinLb setText:VALIDATE_STRING(basesymbol)];
    [_leftexchangeview.operationBtn setTitle:[NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"买入", nil),VALIDATE_STRING(symbol)] forState:UIControlStateNormal];
    [self changeAvailableCurrency];
}
-(void)selectSale:(UIButton *)btn{
    self.opertionIsSale = YES;
    [_leftexchangeview.buyBtn setSelected:NO];
    [_leftexchangeview.saleBtn setSelected:YES];
    [_leftexchangeview.operationBtn setSelected:YES];
    NSString *symbol = [self.currentSymbols componentsSeparatedByString:@"/"].firstObject;
    [_leftexchangeview.quantityTF.coinLb setText:VALIDATE_STRING(symbol)];
    [_leftexchangeview.operationBtn setTitle:[NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"卖出", nil),VALIDATE_STRING(symbol)] forState:UIControlStateNormal];
    [self changeAvailableCurrency];
}
-(void)doOperation:(UIButton *)btn{
    /*
     HUOBI_OrderType_buy_limit = 0,
     HUOBI_OrderType_sell_limit = 1,
     HUOBI_OrderType_buy_market  = 2,
     HUOBI_OrderType_sell_market = 3,
     */
    HUOBI_Order_Type type = -1;
    if (self.opertionIsSale) {
        if (self.opertionIsMarket) {
            type = HUOBI_OrderType_sell_market;
        }else{
            type = HUOBI_OrderType_sell_limit;
        }
    }else{
        if (self.opertionIsMarket) {
            type = HUOBI_OrderType_buy_market;
        }else{
            type = HUOBI_OrderType_buy_limit;
        }
    }
    NSString *price = self.leftexchangeview.priceTF.huobiTF.text;
    NSString *amount = self.leftexchangeview.quantityTF.huobiTF.text;
    NSString *symbol = [[VALIDATE_STRING(self.currentSymbols) stringByReplacingOccurrencesOfString:@"/" withString:@""] lowercaseString];
    MJWeakSelf
    [HuobiManager HuobiCreateOrderAmount:VALIDATE_STRING(amount) Price:price Symbol:symbol Type:type CompletionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
        if (!error) {
            NSLog(@"%@",responseObj);
            HuobiBalanceModel *model = [HuobiBalanceModel parse:responseObj];
            if (model.resultCode != 20000) {
                [weakSelf.view showMsg:model.resultMsg];
            }else{
                if (model.data.errCode) {
                    if ([model.data.errMsg containsString:@"precision"]) {
                        NSString *errproperty;
                        NSString *correntprecision;
                        NSString *precision = NSLocalizedString(@"精度", nil);
                        if([model.data.errMsg containsString:@"amount"]){
                            errproperty = NSLocalizedString(@"数量", nil);
                        }else if ([model.data.errMsg containsString:@"price"]){
                            errproperty = NSLocalizedString(@"价格", nil);
                        }
                        correntprecision = [model.data.errMsg componentsSeparatedByString:@"scale:"].lastObject;
                        [weakSelf.view showMsg:[NSString stringWithFormat:@"%@%@%@,%@%@",errproperty,precision,NSLocalizedString(@"错误", nil),NSLocalizedString(@"应当为", nil),correntprecision]];
                    }else if ([model.data.errMsg containsString:@"trade account balance is not enough"]){
                        NSString *balance = [model.data.errMsg componentsSeparatedByString:@"left: "].lastObject;
                        [weakSelf.view showMsg:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"余额不足,剩余:", nil),balance]];
                    }else{
                        [weakSelf.view showMsg:model.data.errMsg];
                    }
                    
                }else{
                    
                    [weakSelf.view showMsg:NSLocalizedString(@"操作成功", nil)];
                }
            }
        }else{
            [weakSelf.view showMsg:error.userInfo.description];
        }
    }];
}
//限价 市价
-(void)showBuyChooseAlert:(UIButton *)btn{
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
        
    }];
    MJWeakSelf
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:NSLocalizedString(@"限价", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        weakSelf.opertionIsMarket = NO;
//        [weakSelf.leftexchangeview.buychooseBtn setTitle:NSLocalizedString(@"限价", nil) forState:UIControlStateNormal];
        NSTextAttachment *attchment = [[NSTextAttachment alloc]init];
        attchment.bounds = CGRectMake(0, 0, 8, 8);//设置frame
        attchment.image = [UIImage imageNamed:@"ico_down_select"];//设置图片
        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attchment];
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"限价", nil)];
        [attributedString appendAttributedString:string];
        [attributedString addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor grayColor]
                                 range:NSMakeRange(0, attributedString.length)];
        [weakSelf.leftexchangeview.buychooseBtn setAttributedTitle:attributedString forState:UIControlStateNormal];
        [weakSelf.leftexchangeview.priceTF.toolview setAlpha:1.0];
        [weakSelf.leftexchangeview.priceTF.huobiTF setText:VALIDATE_STRING(weakSelf.rightExchangeVC.currentPrice)];
        [weakSelf.leftexchangeview.priceTF.huobiTF setUserInteractionEnabled:YES];
        weakSelf.leftexchangeview.priceTF.huobiTF.textAlignment = NSTextAlignmentLeft;
        [weakSelf.leftexchangeview.priceTF.huobiTF setTextColor:[UIColor darkGrayColor]];
        weakSelf.leftexchangeview.priceTF.huobiTF.backgroundColor = [UIColor whiteColor];
        NSString *symbol = [weakSelf.currentSymbols componentsSeparatedByString:@"/"].firstObject;
        [weakSelf.leftexchangeview.operationBtn setTitle:[NSString stringWithFormat:@"%@ %@",self.opertionIsSale? NSLocalizedString(@"卖出", nil): NSLocalizedString(@"买入", nil),VALIDATE_STRING(symbol)] forState:UIControlStateNormal];
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:NSLocalizedString(@"市价", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        weakSelf.opertionIsMarket = YES;
        NSTextAttachment *attchment = [[NSTextAttachment alloc]init];
        attchment.bounds = CGRectMake(0, 0, 8, 8);//设置frame
        attchment.image = [UIImage imageNamed:@"ico_down_select"];//设置图片
        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attchment];
        
        NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"市价", nil)];
        [attributedString2 appendAttributedString:string];
        [attributedString2 addAttribute:NSForegroundColorAttributeName
                                  value:[UIColor grayColor]
                                  range:NSMakeRange(0, attributedString2.length)];
        [weakSelf.leftexchangeview.buychooseBtn setAttributedTitle:attributedString2 forState:UIControlStateNormal];
        [weakSelf.leftexchangeview.priceTF.toolview setAlpha:0];
        [weakSelf.leftexchangeview.priceTF.huobiTF setText:NSLocalizedString(@"以当前最优价格交易", nil)];
        [weakSelf.leftexchangeview.priceTF.huobiTF setUserInteractionEnabled:NO];
        weakSelf.leftexchangeview.priceTF.huobiTF.textAlignment = NSTextAlignmentCenter;
        [weakSelf.leftexchangeview.priceTF.huobiTF setTextColor:[UIColor lightGrayColor]];
        weakSelf.leftexchangeview.priceTF.huobiTF.backgroundColor = [UIColor huobilightbgColor];
        NSString *symbol = [weakSelf.currentSymbols componentsSeparatedByString:@"/"].firstObject;
        [weakSelf.leftexchangeview.operationBtn setTitle:[NSString stringWithFormat:@"%@ %@",self.opertionIsSale? NSLocalizedString(@"卖出", nil): NSLocalizedString(@"买入", nil),VALIDATE_STRING(symbol)] forState:UIControlStateNormal];
        
    }];
    [alertVc addAction:cancle];
    [alertVc addAction:action1];
    [alertVc addAction:action2];
    [self presentViewController:alertVc animated:YES completion:nil];
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

//调整价格
-(void)addPrice{
    //精度
    NSInteger pric = [self.leftexchangeview.priceTF.huobiTF.text componentsSeparatedByString:@"."].lastObject.length;
    NSString *ori = self.leftexchangeview.priceTF.huobiTF.text;
    if ([NSString checkNumber:ori]) {
        CGFloat newprice = (ori.doubleValue*pow(10, pric) + 1)/pow(10, pric);
        NSString *new;
        switch (pric) {
            case 0:
                new = [NSString stringWithFormat:@"%.0f",newprice];
                break;
            case 1:
                new = [NSString stringWithFormat:@"%.1f",newprice];
                break;
            case 2:
                new = [NSString stringWithFormat:@"%.2f",newprice];
                break;
            case 3:
                new = [NSString stringWithFormat:@"%.3f",newprice];
                break;
            case 4:
                new = [NSString stringWithFormat:@"%.4f",newprice];
                break;
            case 5:
                new = [NSString stringWithFormat:@"%.5f",newprice];
                break;
            case 6:
                new = [NSString stringWithFormat:@"%.6f",newprice];
                break;
            case 7:
                new = [NSString stringWithFormat:@"%.7f",newprice];
                break;
            case 8:
                new = [NSString stringWithFormat:@"%.8f",newprice];
                break;
            default:
                new = @"0.0000";
                break;
        }
        self.leftexchangeview.priceTF.huobiTF.text = new;
        CGFloat rmbcurr = [[NSUserDefaults standardUserDefaults] floatForKey:@"RMBDollarCurrency"];
        [self.leftexchangeview.priceTF.remindLb setText:[NSString stringWithFormat:@"≈%@CHY",[self checkFloatToStr:rmbcurr * ori.doubleValue / 100.0]]];
        [self changeTotalAmount];
    }else{
        [self.view showMsg:@"Price Error!"];
    }
}

-(void)reducePrice{
    NSInteger pric = [self.leftexchangeview.priceTF.huobiTF.text componentsSeparatedByString:@"."].lastObject.length;
    NSString *ori = self.leftexchangeview.priceTF.huobiTF.text;
    if ([NSString checkNumber:ori]) {
        CGFloat newprice = (ori.doubleValue*pow(10, pric) + 1)/pow(10, pric);
        NSString *new;
        switch (pric) {
            case 0:
                new = [NSString stringWithFormat:@"%.0f",newprice];
                break;
            case 1:
                new = [NSString stringWithFormat:@"%.1f",newprice];
                break;
            case 2:
                new = [NSString stringWithFormat:@"%.2f",newprice];
                break;
            case 3:
                new = [NSString stringWithFormat:@"%.3f",newprice];
                break;
            case 4:
                new = [NSString stringWithFormat:@"%.4f",newprice];
                break;
            case 5:
                new = [NSString stringWithFormat:@"%.5f",newprice];
                break;
            case 6:
                new = [NSString stringWithFormat:@"%.6f",newprice];
                break;
            case 7:
                new = [NSString stringWithFormat:@"%.7f",newprice];
                break;
            case 8:
                new = [NSString stringWithFormat:@"%.8f",newprice];
                break;
            default:
                new = @"0.0000";
                break;
        }
        self.leftexchangeview.priceTF.huobiTF.text = new;
        CGFloat rmbcurr = [[NSUserDefaults standardUserDefaults] floatForKey:@"RMBDollarCurrency"];
        [self.leftexchangeview.priceTF.remindLb setText:[NSString stringWithFormat:@"≈%@CHY",[self checkFloatToStr:rmbcurr * ori.doubleValue / 100.0]]];
        [self changeTotalAmount];
    }else{
        [self.view showMsg:@"Price Error!"];
    }
}

#pragma textfiled delegate
//调整内容
-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSInteger pric = 0;
    if (textField.tag == 1039) {
        pric = [self.leftexchangeview.priceTF.huobiTF.text componentsSeparatedByString:@"."].lastObject.length;
    }else if (textField.tag == 1040){
        pric = [self.leftexchangeview.quantityTF.huobiTF.text componentsSeparatedByString:@"."].lastObject.length;
    }
    if ([NSString checkNumber:textField.text]) {
        CGFloat newqu = (textField.text.doubleValue*pow(10, pric))/pow(10, pric);
        NSString *new;
        switch (pric) {
            case 0:
                new = [NSString stringWithFormat:@"%.0f",newqu];
                break;
            case 1:
                new = [NSString stringWithFormat:@"%.1f",newqu];
                break;
            case 2:
                new = [NSString stringWithFormat:@"%.2f",newqu];
                break;
            case 3:
                new = [NSString stringWithFormat:@"%.3f",newqu];
                break;
            case 4:
                new = [NSString stringWithFormat:@"%.4f",newqu];
                break;
            case 5:
                new = [NSString stringWithFormat:@"%.5f",newqu];
                break;
            case 6:
                new = [NSString stringWithFormat:@"%.6f",newqu];
                break;
            case 7:
                new = [NSString stringWithFormat:@"%.7f",newqu];
                break;
            case 8:
                new = [NSString stringWithFormat:@"%.8f",newqu];
                break;
            default:
                new = @"0.0000";
                break;
        }
        if (textField.tag == 1039) {
            self.leftexchangeview.priceTF.huobiTF.text = new;
            CGFloat rmbcurr = [[NSUserDefaults standardUserDefaults] floatForKey:@"RMBDollarCurrency"];
            [self.leftexchangeview.priceTF.remindLb setText:[NSString stringWithFormat:@"≈%@CHY",[self checkFloatToStr:rmbcurr * textField.text.doubleValue / 100.0]]];
        }else if (textField.tag == 1040){
            self.leftexchangeview.quantityTF.huobiTF.text = new;
        }
        [self changeTotalAmount];
    }else{
        if (textField.tag == 1039) {
            [self.view showMsg:@"Price Error!"];
        }else if (textField.tag == 1040){
            [self.view showMsg:@"Quantity Error!"];
        }
    }
}


#pragma Gesture
-(void)swipeGesture:(UISwipeGestureRecognizer *)swipeGestureRecognizer {
    [self.view endEditing:YES];
    CALayer *layer = [self.view layer];
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOffset = CGSizeMake(1, 1);
    layer.shadowOpacity = 1;
    layer.shadowRadius = 20.0;
    if (swipeGestureRecognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        [self showToolView];
    }
    if (swipeGestureRecognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self closeToolView];
    }
}
-(void)tapGesture:(UISwipeGestureRecognizer *)tapGesture{
    [self.view endEditing:YES];
    if (![tapGesture.view isEqual:self.selectSymbolVC.view]) {
        [self closeToolView];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

#pragma toolview control
//交易额
-(void)changeTotalAmount{
    NSString *price = self.leftexchangeview.priceTF.huobiTF.text;
    NSString *amount = self.leftexchangeview.quantityTF.huobiTF.text;
    NSString *current;
    current = [self.currentSymbols componentsSeparatedByString:@"/"].lastObject.uppercaseString;
    [self.leftexchangeview.amountLb setText:[NSString stringWithFormat:@"%@ %@%@",NSLocalizedString(@"交易额2", nil),[self checkFloatToStr:price.doubleValue * amount.doubleValue],current]];
}

//可用
-(void)changeAvailableCurrency{
    NSString *current;
    if (self.opertionIsSale) {
        current = [self.currentSymbols componentsSeparatedByString:@"/"].firstObject.uppercaseString;
    }else{
        current = [self.currentSymbols componentsSeparatedByString:@"/"].lastObject.uppercaseString;
    }
    for (HuobiBalanceListObj *obj in self.balancedataArray) {
        if ([obj.currency.lowercaseString isEqualToString:current.lowercaseString] && [obj.type isEqualToString:@"trade"]) {
            self.currentBalance =  [self checkFloatToStr:obj.balance.doubleValue];
            [self.leftexchangeview.quantityTF.remindLb setText:[NSString stringWithFormat:@"%@%@%@",NSLocalizedString(@"可用", nil),self.currentBalance,current]];
        }
    }
}

-(void)receiveNotification:(NSNotification *)infoNotification {
    NSString *currentsymbol = [[NSUserDefaults standardUserDefaults] objectForKey:CurrentHuobiSymbols];
    self.currentSymbols = VALIDATE_STRING(currentsymbol).copy;
    NSLog(@"%@",self.currentSymbols);
    [self closeToolView];
    NSString *symbol = [self.currentSymbols componentsSeparatedByString:@"/"].firstObject;
    [self.leftexchangeview.operationBtn setTitle:[NSString stringWithFormat:@"%@ %@",self.opertionIsSale? NSLocalizedString(@"卖出", nil): NSLocalizedString(@"买入", nil),VALIDATE_STRING(symbol)] forState:UIControlStateNormal];
    [_leftexchangeview.symbolLb setText:VALIDATE_STRING(self.currentSymbols)];
    [self changeAvailableCurrency];
    NSString *basesymbol = [self.currentSymbols componentsSeparatedByString:@"/"].lastObject;
    [_leftexchangeview.quantityTF.coinLb setText:VALIDATE_STRING(basesymbol)];
}

-(void)changeNewPrice:(NSNotification *)infoNotification {
    CGFloat rmbcurr = [[NSUserDefaults standardUserDefaults] floatForKey:@"RMBDollarCurrency"];
    if (self.opertionIsMarket) {
        self.leftexchangeview.priceTF.remindLb.text = [NSString stringWithFormat:@"≈%@CHY",[self checkFloatToStr:rmbcurr * self.rightExchangeVC.currentPrice.doubleValue / 100.0]];
    }else{
        [self.leftexchangeview.priceTF.huobiTF setText:VALIDATE_STRING(self.rightExchangeVC.selectedPrice)];
        self.leftexchangeview.priceTF.remindLb.text = [NSString stringWithFormat:@"≈%@CHY",[self checkFloatToStr:rmbcurr * self.rightExchangeVC.selectedPrice.doubleValue / 100.0]];
    }
    
    [self changeTotalAmount];
}

-(void)closeToolView{
    MJWeakSelf
    self.selectSymbolVC.view.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.5f animations:^{
        weakSelf.bridgeContentView.backgroundColor = RGBACOLOR(255, 255, 255, 1.0);
        weakSelf.selectSymbolVC.view.frame = CGRectMake(-ScreenWidth, 0, ScreenWidth/2 *1.5, ScreenHeight - SafeAreaTopHeight);
    } completion:^(BOOL finished) {
        
    }];
}

-(void)showToolView{
    MJWeakSelf
    [UIView animateWithDuration:0.5f animations:^{
        weakSelf.bridgeContentView.backgroundColor = RGBACOLOR(180, 180, 180, 0.7);
        weakSelf.selectSymbolVC.view.frame = CGRectMake(0, 0, ScreenWidth/2 *1.5, ScreenHeight - SafeAreaTopHeight);
    } completion:^(BOOL finished) {
        weakSelf.selectSymbolVC.view.backgroundColor = RGBACOLOR(180, 180, 180, 0.8);
    }];
}
#pragma rightVC
-(void)rightTypeChange{
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
        
    }];
    MJWeakSelf
    UIAlertAction *action0 = [UIAlertAction actionWithTitle:NSLocalizedString(@"默认", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        weakSelf.rightExchangeVC.showType = HUOBI_Default_Type;
        [weakSelf.rightExchangeVC NetRequest];
    }];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:NSLocalizedString(@"买盘", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        weakSelf.rightExchangeVC.showType = HUOBI_Buy_Type;
        [weakSelf.rightExchangeVC NetRequest];
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:NSLocalizedString(@"卖盘", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        weakSelf.rightExchangeVC.showType = HUOBI_Sale_Type;
        [weakSelf.rightExchangeVC NetRequest];
    }];
    [alertVc addAction:cancle];
    [alertVc addAction:action0];
    [alertVc addAction:action1];
    [alertVc addAction:action2];
    [self presentViewController:alertVc animated:YES completion:nil];
}

-(void)depthChange{
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
        
    }];
    [alertVc addAction:cancle];
    MJWeakSelf
    for (NSInteger index = 1; index < 7; index ++) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%ld",index] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            weakSelf.rightExchangeVC.currentDepth = index;
            [weakSelf.rightExchangeVC.depthBtn setTitle:[NSString stringWithFormat:@"%@%ld",NSLocalizedString(@"深度", nil),index] forState:UIControlStateNormal];
            [weakSelf.rightExchangeVC NetRequest];
        }];
        [alertVc addAction:action];
    }
    [self presentViewController:alertVc animated:YES completion:nil];
}



#pragma lazy
-(CurrentOrderVC *)currentOrderVC{
    if (!_currentOrderVC) {
        _currentOrderVC = [CurrentOrderVC new];
        [self addChildViewController:_currentOrderVC];
        [_currentOrderVC.allOrderBtn addTarget:self action:@selector(seeAllOrders) forControlEvents:UIControlEventTouchUpInside];
        [self.bridgeContentView addSubview:_currentOrderVC.view];
        [_currentOrderVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.top.equalTo(self.rightExchangeVC.view.mas_bottom).equalTo(10);
            make.right.equalTo(0);
            make.height.equalTo(330);
        }];
    }
    return _currentOrderVC;
}

-(HuobiRightExchangeVC *)rightExchangeVC{
    if (!_rightExchangeVC) {
        _rightExchangeVC = [HuobiRightExchangeVC new];
        [self addChildViewController:_rightExchangeVC];
        [self.thescrollView addSubview:_rightExchangeVC.view];
        [_rightExchangeVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ScreenWidth - 130);
            make.top.equalTo(45);
            make.right.equalTo(0);
            make.height.equalTo(330);
        }];
    }
    return _rightExchangeVC;
}

-(SelectHuobiSymbolsVC *)selectSymbolVC{
    if (!_selectSymbolVC) {
        _selectSymbolVC = [[SelectHuobiSymbolsVC alloc] init];
        _selectSymbolVC.view.backgroundColor = RGBACOLOR(180, 180, 180, 0.8);
        [self addChildViewController:_selectSymbolVC];
        [self.view addSubview:_selectSymbolVC.view];
        _selectSymbolVC.view.frame = CGRectMake(-ScreenWidth, 0, ScreenWidth/2 *1.5, ScreenHeight - SafeAreaTopHeight);
    }
    return _selectSymbolVC;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
