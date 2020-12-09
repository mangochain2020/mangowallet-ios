//
//  DCSureOrderViewController.m
//  CDDStoreDemo
//
//  Created by apple on 2017/4/9.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "DCSureOrderViewController.h"

#import "DCUserPayViewController.h"
#import "DCAdressItem.h"
#import "DCReceivingAddressViewController.h"
#import "PPNumberButton.h"
#import "DCUserPayViewController.h"
#import "OperationProcessTableViewController.h"

#import "BlockChain.h"
#import "CCPActionSheetView.h"

@interface DCSureOrderViewController ()<DCReceivingAddressDelegate,PPNumberButtonDelegate>
{
    NSString *coinType;
    NSString *payId;
}
/* 商品 */
@property (weak, nonatomic) IBOutlet UIImageView *shopIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *shopTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopChoseLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopBuyCount;

@property (weak, nonatomic) IBOutlet UITextField *msgLabel;
@property (weak, nonatomic) IBOutlet UILabel *megLeft;
/* 付款 */
@property (weak, nonatomic) IBOutlet UIButton *orderButton;
@property (weak, nonatomic) IBOutlet UILabel *totalNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *storePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastPayMoneyLabel;

/* 高 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topExViewH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *middleShopViewH;

/* 地址 */
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userPhone;
@property (weak, nonatomic) IBOutlet UILabel *userAdress;
@property (weak, nonatomic) IBOutlet UILabel *adressLabel;

@property (nonatomic, weak) XFDialogFrame *dialogView;
@property (weak, nonatomic) IBOutlet UILabel *postage; //运费

@property (weak, nonatomic) IBOutlet UILabel *postageLeft; //

@property (weak, nonatomic) IBOutlet UILabel *freeLeft;//手续费
@property (weak, nonatomic) IBOutlet UILabel *free;

@property (weak, nonatomic) IBOutlet UILabel * total; //商品总额
@property (weak, nonatomic) IBOutlet UILabel * totalMgp; //支付金额


@property (nonatomic, assign) double currency;
@property (nonatomic, copy) NSString *orderId;

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
@property(nonatomic,strong)NSNumber *currencyBalance;
@property(nonatomic,strong)DCAdressItem *adressItem;



@end

@implementation DCSureOrderViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self coinPriceType:@"MGP_USDT"];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    coinType = @"MGP";
//    [[UINavigationBar appearance] setTranslucent:NO];
    self.wallet = [MGPHttpRequest shareManager].curretWallet;
    self.postageLeft.text = NSLocalizedString(@"运费", nil);
    self.freeLeft.text = NSLocalizedString(@"手续费", nil);
    self.total.text = NSLocalizedString(@"商品总额", nil);
    self.totalMgp.text = NSLocalizedString(@"实付金额", nil);
    self.adressLabel.text = NSLocalizedString(@"地址", nil);
    self.megLeft.text = NSLocalizedString(@"订单备注:", nil);
    self.msgLabel.placeholder = NSLocalizedString(@"选填，请先和商家协商一致", nil);
    [self.orderButton setTitle:NSLocalizedString(@"提交订单", nil) forState:UIControlStateNormal];
    self.title = NSLocalizedString(@"订单确认", nil);

    
    
    
    
    WEAKSELF
    [[MGPHttpRequest shareManager]post:@"/appStoreUserAddr/findAddr" paramters:@{@"address":[MGPHttpRequest shareManager].curretWallet.address} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {

        if ([responseObj[@"code"]intValue] == 0) {

            for (NSDictionary *dic in responseObj[@"data"]) {
                if ([dic[@"isDefault"]boolValue] == YES) {

                    DCAdressItem *model = [DCAdressItem new];
                    model.userName = dic[@"userName"];
                    model.userPhone = dic[@"phone"];
                    model.chooseAdress = dic[@"city"];
                    model.userAdress = dic[@"detailedAddress"];
                    model.userName = dic[@"userName"];
                    model.isDefault = [dic[@"isDefault"]boolValue]?@"1":@"0";
                    model.ID = dic[@"addrID"];
                    model.userId = dic[@"userId"];
                    model.countyNum = dic[@"country"];
                    model.countyName = dic[@"countryName"];
                    self.adressItem = model;
                    
                    weakSelf.userName.text = model.userName;
                    weakSelf.userPhone.text = model.userPhone;
                    weakSelf.userAdress.text = [NSString stringWithFormat:@"%@ %@",VALIDATE_STRING(model.chooseAdress),VALIDATE_STRING(model.userAdress)];

                }
            }

        }
    }];
    
    NSString *name = [[MGPHttpRequest shareManager].curretWallet.walletName componentsSeparatedByString:@"_"].lastObject;
    NSDictionary *dic = @{@"account_name":name};
    [[HTTPRequestManager shareMgpManager] post:eos_get_account paramters:dic success:^(BOOL isSuccess, id responseObject) {
        
        if (isSuccess) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *balancestr = [(NSDictionary *)responseObject objectForKey:@"core_liquid_balance"];
                NSString *valuestring = [balancestr componentsSeparatedByString:@" "].firstObject;
                double balance = valuestring.doubleValue;
                self.currencyBalance = @(balance);
            });
            
        }
    } failure:^(NSError *error) {
        
    } superView:self.view showFaliureDescription:YES];
    
    
    PPNumberButton *numberButton = [PPNumberButton numberButtonWithFrame:CGRectMake(kScreenWidth - 100, 91+100, 80, 30)];
    numberButton.shakeAnimation = YES;
    numberButton.minValue = 1;
    numberButton.maxValue = self.proModel.stock;
    numberButton.inputFieldFont = 17;
    numberButton.increaseTitle = @"＋";
    numberButton.decreaseTitle = @"－";
    numberButton.currentNumber = 1;
    
    numberButton.resultBlock = ^(NSInteger num ,BOOL increaseStatus){
        self.buyNum = num;
        
        self.totalNumLabel.text = [NSString stringWithFormat:@"%zd %@",_buyNum, NSLocalizedString(@"件", nil)];
//        self.storePriceLabel.text = [NSString stringWithFormat:@"$%ld",self.proModel.price * self.buyNum];
        double count = ((self.proModel.price * self.buyNum) / _currency + self.proModel.postage);
        self.lastPayMoneyLabel.text = [NSString stringWithFormat:@"%.4f MGP",count+count*[self.proModel.serviceCharge doubleValue]];

        _storePriceLabel.text = [NSString stringWithFormat:@"%@%.2f",[CreateAll GetCurrentCurrency].symbol,([[CreateAll GetCurrentCurrency].price doubleValue] * (self.proModel.price * self.buyNum))];

        
    };
    [self.view addSubview:numberButton];
    
}
- (IBAction)userAdressBtnClick:(id)sender {
    DCReceivingAddressViewController *vc = [[DCReceivingAddressViewController alloc]init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)receivingAddressValue:(DCAdressItem *)value{
    self.userName.text = value.userName;
    self.userPhone.text = value.userPhone;
    self.userAdress.text = [NSString stringWithFormat:@"%@ %@",VALIDATE_STRING(value.chooseAdress),VALIDATE_STRING(value.userAdress)];
    self.adressItem = value;

    
    
}
- (void)coinPriceType:(NSString *)pair{
    [[MGPHttpRequest shareManager]post:@"/api/coinPrice" paramters:@{@"pair":pair} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
        if ([responseObj[@"code"]intValue] == 0) {
           _currency = ((NSString *)VALIDATE_STRING([responseObj[@"data"] objectForKey:@"price"])).doubleValue;
            [self setUpShopInfo];
        }
    }];
}

- (void)setUpShopInfo
{
    [_orderButton addTarget:self action:@selector(setUpJumpToPay) forControlEvents:UIControlEventTouchUpInside];
    
    _totalNumLabel.text = [NSString stringWithFormat:@"%zd %@",_buyNum,NSLocalizedString(@"件", nil)];
    _storePriceLabel.text = [NSString stringWithFormat:@"%@%.2f",[CreateAll GetCurrentCurrency].symbol,([[CreateAll GetCurrentCurrency].price doubleValue] * _showPriceStr)];

    //    支付mgp数量 = （（商品价格 * 件数） * （1 + 手续费比率） + 邮费 ）/ MGP实时价格
    //    支付USDT数量 = （（商品价格 * 件数） * （1 + 手续费比率） + 邮费 ）/ 1.0
        
    double count = ((self.proModel.price * self.buyNum) * (1.0+[self.proModel.serviceCharge doubleValue]) + self.proModel.postage) / _currency;
    self.lastPayMoneyLabel.text = [NSString stringWithFormat:@"%.4f MGP",count];
    

    _free.text = [NSString stringWithFormat:@"%.f%%",[self.proModel.serviceCharge doubleValue]*100];
    
    
    _shopIconImageView.image = [UIImage imageNamed:_iconimage];
    [_shopIconImageView sd_setImageWithURL:[NSURL URLWithString:self.proModel.image_url.firstObject]];
    _shopChoseLabel.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"规格", nil),_standard];
    _shopTitleLabel.text = _showShopStr;
    _shopBuyCount.text = @"";// [NSString stringWithFormat:@"× %zd",_buyNum];
    _shopMoneyLabel.text = [NSString stringWithFormat:@"$%.2f",_showPriceStr];
    
    _postage.text = self.proModel.postage > 0 ? [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"运费", nil),[NSString stringWithFormat:@"%@%.2f",[CreateAll GetCurrentCurrency].symbol,([[CreateAll GetCurrentCurrency].price doubleValue] * self.proModel.postage)]] : NSLocalizedString(@"免运费", nil);

    _shopMoneyLabel.text = _storePriceLabel.text;
    
}

- (void)setUpJumpToPay
{
    if (self.userPhone.text.length <= 0) {
        [self.view showMsg:NSLocalizedString(@"请选择收货地址", nil)];
        return;
    }
    

    NSMutableArray *tempArr = [NSMutableArray array];
    for (PayConfigs *obj in self.proModel.payConfigs) {
        [tempArr addObject:obj.name];
    }
    [tempArr addObject:NSLocalizedString(@"取消", nil)];
      
    CCPActionSheetView *actionSheetView = [[CCPActionSheetView alloc]initWithActionSheetArray:tempArr];
      
      [actionSheetView cellDidSelectBlock:^(NSString *indexString, NSInteger index) {
          PayConfigs *obj = self.proModel.payConfigs[index];
          
          if (obj.payId == 1) {
              if (self.currencyBalance.doubleValue <= 0) {
                  [self.view showMsg:NSLocalizedString(@"当前钱包可用余额不足", nil)];
                  return;
              }
              NSString *mgpPrice = [self.lastPayMoneyLabel.text componentsSeparatedByString:@" "].firstObject;

              if (self.currencyBalance.doubleValue < [mgpPrice doubleValue]) {
                  [self.view showMsg:NSLocalizedString(@"当前钱包余额不足以支付", nil)];
                  return;
              }
              
              coinType = @"MGP";
              payId =[NSString stringWithFormat:@"%ld",obj.payId];
              [self coinPriceType:@"MGP_USDT"];
              [self addOrderSubmit];
          }else if (obj.payId == 2){
              coinType = @"USDT";
              payId =[NSString stringWithFormat:@"%ld",obj.payId];
              [self coinPriceType:@"USDT_USDT"];
              [self addOrderSubmit];
          }
          
    }];
     
}

- (void)inputPassWorldSubmit:(NSString *)orderId{
    WEAKSELF
    self.dialogView =
    [[XFDialogInput dialogWithTitle:NSLocalizedString(@"请输入密码", nil)
                                 attrs:@{
                                         XFDialogTitleViewBackgroundColor : [UIColor orangeColor],
                                         XFDialogTitleColor: [UIColor whiteColor],
                                         XFDialogLineColor: [UIColor orangeColor],
                                         XFDialogInputFields:@[
                                                 @{
                                                     XFDialogInputPlaceholderKey : NSLocalizedString(@"输入8位数以上密码", nil),
                                                     XFDialogInputTypeKey : @(UIKeyboardTypeDefault),
                                                     XFDialogInputIsPasswordKey : @(YES),
                                                     XFDialogInputPasswordEye : @{
                                                             XFDialogInputEyeOpenImage : @"ic_eye",
                                                             XFDialogInputEyeCloseImage : @"ic_eye_close"
                                                             }
                                                     },
                                                 ],
                                         XFDialogInputHintColor : [UIColor purpleColor],
                                         XFDialogInputTextColor: [UIColor orangeColor],
                                         XFDialogCommitButtonTitleColor: [UIColor orangeColor]
                                         }
                        commitCallBack:^(NSString *inputText) {
                            [weakSelf.dialogView hideWithAnimationBlock:nil];

        NSArray *arr = (NSArray *)inputText;
        NSString *pwd = arr.firstObject;

        NSString *amount =[self.lastPayMoneyLabel.text componentsSeparatedByString:@" "].firstObject;
        NSDictionary *memoDic = @{@"orderSn":self.orderId,
                              @"currencyPrice":[NSString stringWithFormat:@"%.2f",self.currency],
                              @"dollar":[NSString stringWithFormat:@"%f",self.proModel.price * self.buyNum]
        };
        
        [[DCMGPWalletTool shareManager]transferAmount:amount andFrom:[MGPHttpRequest shareManager].curretWallet.address andTo:@"mgpchainshop" andMemo:[[DCMGPWalletTool shareManager]convertToJsonData:memoDic] andPassWord:pwd completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
            
            if (responseObj) {
                NSDictionary *p = @{
                    @"address":[MGPHttpRequest shareManager].curretWallet.address,
                    @"productId":[NSString stringWithFormat:@"%ld",self.proModel.proID],
                    @"detailedAddress":[self.userAdress.text componentsSeparatedByString:@" "].lastObject,
                    @"userName":self.userName.text,
                    @"productNum":[NSString stringWithFormat:@"%ld",_buyNum],
                    @"city":[self.userAdress.text componentsSeparatedByString:@" "].firstObject,
                    @"productPrice":[NSString stringWithFormat:@"%f",self.proModel.price],
                    @"totalPostage":[NSString stringWithFormat:@"%f",self.proModel.postage],
                    @"mark":@"",
                    @"phone":self.userPhone.text,
                    @"payMgp":[self.lastPayMoneyLabel.text componentsSeparatedByString:@" "].firstObject,
                    @"mgpPrice":[NSString stringWithFormat:@"%.4f",self.currency],
                    @"hash":responseObj,
                    @"orderId":self.orderId,
                };
                [[MGPHttpRequest shareManager]post:@"/appStoreOrder/buyOrder" paramters:p completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
                    self.orderButton.userInteractionEnabled = YES;
                    if ([responseObj[@"code"]intValue] == 0) {
                        [weakSelf.view showMsg:NSLocalizedString(@"支付成功", nil)];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [weakSelf.navigationController popViewControllerAnimated:YES];
                        });
                    }
                }];
                
            }
        }];
        
        } errorCallBack:^(NSString *errorMessage) {
            NSLog(@"error -- %@",errorMessage);
            
        }] showWithAnimationBlock:nil];
}

- (void)addOrderSubmit{
    _orderButton.userInteractionEnabled = NO;
    NSDictionary *p = @{
        @"address":[MGPHttpRequest shareManager].curretWallet.address,
        @"productId":[NSString stringWithFormat:@"%ld",self.proModel.proID],
        @"detailedAddress":[self.userAdress.text componentsSeparatedByString:@" "].lastObject,
        @"userName":self.userName.text,
        @"productNum":[NSString stringWithFormat:@"%ld",_buyNum],
        @"city":[self.userAdress.text componentsSeparatedByString:@" "].firstObject,
        @"productPrice":[NSString stringWithFormat:@"%f",(self.proModel.price * self.buyNum)],
        @"totalPostage":[NSString stringWithFormat:@"%ld",self.proModel.postage],
        @"mark":@"",
        @"country":self.adressItem.countyNum,
        @"phone":self.userPhone.text,
        @"payMgp":[self.lastPayMoneyLabel.text componentsSeparatedByString:@" "].firstObject,
        @"mgpPrice":[NSString stringWithFormat:@"%.4f",self.currency],
        @"buyMark":VALIDATE_STRING(self.msgLabel.text),
        @"pay":VALIDATE_STRING(payId)

    };
    
    [[MGPHttpRequest shareManager]post:@"/appStoreOrder/addOrder" paramters:p completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
        self.orderButton.userInteractionEnabled = YES;
        if ([responseObj[@"code"]intValue] == 0) {
            NSString *orderId = responseObj[@"data"];
            if (orderId.length > 0) {
                self.orderId = orderId;
                if ([coinType isEqualToString:@"MGP"]) {
                    [self inputPassWorldSubmit:@""];
                }else{
                    UIStoryboard* secondStoryboard = [UIStoryboard storyboardWithName:@"ExchangeHome" bundle:[NSBundle mainBundle]];
                    OperationProcessTableViewController *secondNavigationController = [secondStoryboard instantiateViewControllerWithIdentifier:@"OperationProcessTableViewController"];
                    secondNavigationController.usdtAdd = self.proModel.usdtAddr;
                    secondNavigationController.orderId = orderId;
                    double count = ((self.proModel.price * self.buyNum) * (1.0+[self.proModel.serviceCharge doubleValue]) + self.proModel.postage) / 1.0;
                    secondNavigationController.num = [NSString stringWithFormat:@"%.4f",count];
                    secondNavigationController.transferType = transferHMIO_USDT;
                    [self.navigationController pushViewController:secondNavigationController animated:YES];
                }
            }
        }
    }];
    
}

@end
