//
//  OverTheCounterSellHomeViewController.m
//  TaiYiToken
//
//  Created by mac on 2020/12/29.
//  Copyright © 2020 admin. All rights reserved.
//

#import "OverTheCounterSellHomeViewController.h"
#import "PPNumberButton.h"
#import "OverTheCounterOrderDetailViewController.h"
#import "LHCurrencyModel.h"
#import "HQStepper.h"
#import "LHSendTransactionViewController.h"
#import "CCPActionSheetView.h"


@interface OverTheCounterSellHomeViewController ()
{
    double price;
    double balance;
    int isOverTheCounterContact;
    NSString *remaining;
    BOOL typeSwitcNum;
}
@property (nonatomic, weak) XFDialogFrame *dialogView;
@property(nonatomic,strong)LHCurrencyModel *selectModel;
@property (nonatomic, strong) HQStepper *stepper2;


@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIView *numberButtonBg;
@property (weak, nonatomic) IBOutlet UITextField *sellNumberTF;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeSwitchLabel;
@property (weak, nonatomic) IBOutlet UITextField *min_sellNumberTF;
@property (weak, nonatomic) IBOutlet UIButton *min_sellNumberUnit;
@property (weak, nonatomic) IBOutlet UITextField *totalLabelR;
@property (weak, nonatomic) IBOutlet UIButton *sellButton;


@end

@implementation OverTheCounterSellHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"我要卖", nil);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.sellNumberTF];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidEnd) name:UITextFieldTextDidEndEditingNotification object:self.sellNumberTF];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(min_sellNumber_textChange) name:UITextFieldTextDidChangeNotification object:self.min_sellNumberTF];
    

    //金额步进按钮
    CGRect frame2 = CGRectMake(kScreenWidth-140, 15, 120, 30);
    self.stepper2 = [HQStepper stepperWithFrame:frame2 min:0.0f max:1000.00f step:0.5f value:0];
    [self.stepper2 setFont:@"HelveticaNeue-Light" size:17.0f];
    [self.stepper2 setTintColor:RGB(194, 194, 194)];
    [self.stepper2 setCornerRadius:0.0f];
    [self.stepper2 addTarget:self action:@selector(stepperChanged:) forControlEvents:UIControlEventValueChanged];
    [self.numberButtonBg addSubview:self.stepper2];
    
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //判断是否绑定
    [[MGPHttpRequest shareManager]post:@"/moUsers/isBind" isNewPath:YES paramters:@{@"mgpName":[MGPHttpRequest shareManager].curretWallet.address,@"type":@"1"} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
        if ([responseObj[@"code"] intValue] == 0) {
            isOverTheCounterContact = [responseObj[@"data"] intValue];
            [self.tableView reloadData];
        }
    }];
 
    //判断是否POS抵押
    NSDictionary *dic = @{@"json": @1,@"code": @"addressbookt",@"scope":@"addressbookt",@"table_key":@"",@"table":@"balances",@"lower_bound":[MGPHttpRequest shareManager].curretWallet.address,@"upper_bound":[MGPHttpRequest shareManager].curretWallet.address};
    
    [[HTTPRequestManager shareMgpManager] post:eos_get_table_rows paramters:dic success:^(BOOL isSuccess, id responseObject) {
        
        if (isSuccess) {
            NSArray *arr = (NSArray *)responseObject[@"rows"];
            NSDictionary *dic = arr.firstObject;
            remaining = [dic[@"remaining"] componentsSeparatedByString:@" "].firstObject;
        }
    } failure:^(NSError *error) {
        
    } superView:self.view showFaliureDescription:YES];
    
    
    //获取当前mgp价格
    [[MGPHttpRequest shareManager]post:@"/api/coinPrice" paramters:@{@"pair":@"MGP_USDT"} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {

        if ([responseObj[@"code"]intValue] == 0) {
            price = ((NSString *)VALIDATE_STRING([responseObj[@"data"]objectForKey:@"price"])).doubleValue;
            //获取当前CNY价格
            NSMutableArray *titleArray = [NSMutableArray array];
            [[MGPHttpRequest shareManager]post:@"/api/coin_symbol" paramters:nil completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
                if ([responseObj[@"code"]intValue] == 0) {
                    for (NSDictionary *dic in responseObj[@"data"]) {
                        [titleArray addObject:[LHCurrencyModel mj_objectWithKeyValues:dic]];
                    }
                    self.selectModel = titleArray.firstObject;
                    float f = ([self.selectModel.price doubleValue] * price);

                    self.priceLabel.text = [NSString stringWithFormat:@"%@￥%.2f",NSLocalizedString(@"当前MGP价格", nil),f];
                    [self.stepper2 setValue:f];
                }
            }];
        }
        
    }];
    
    //获取余额
    [[HTTPRequestManager shareMgpManager] post:eos_get_currency_balance paramters:@{@"code":@"eosio.token",@"currency":@"MGP",@"account":[MGPHttpRequest shareManager].curretWallet.address} success:^(BOOL isSuccess, id responseObject) {
        
        NSString *balancestr = ((NSArray *)responseObject).firstObject;
        NSString *valuestring = [balancestr componentsSeparatedByString:@" "].firstObject;
        balance = valuestring.doubleValue;
        self.balanceLabel.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"剩余", nil),balancestr];

        
    } failure:^(NSError *error) {

    } superView:self.view showFaliureDescription:YES];
    
}

- (void)stepperChanged:(id)sender
{
    [self calculation:[self.sellNumberTF.text doubleValue]];
}
/**
 *  文本框的文字发生改变的时候调用
 */
- (void)textChange
{
    if ([self.sellNumberTF.text doubleValue] <= balance) {
        [self calculation:[self.sellNumberTF.text doubleValue]];

    }else{
        self.sellNumberTF.text = @"";
        [self.view endEditing:YES];
        [self.view showMsg:NSLocalizedString(@"余额不足", nil)];
    }

}
- (void)min_sellNumber_textChange{
    
    double min_sell = typeSwitcNum ? [self.min_sellNumberTF.text doubleValue]*[self.stepper2 value] : [self.min_sellNumberTF.text doubleValue];
    if (min_sell > ([self.sellNumberTF.text doubleValue]*[self.stepper2 value])) {
        self.min_sellNumberTF.text = @"";
        [self.view endEditing:YES];
        [self.view showMsg:NSLocalizedString(@"最小金额不能大于总金额", nil)];
        
    }
    [self calculation:[self.sellNumberTF.text doubleValue]];

}
/**
 *  文本框的文字结束编辑
 */
- (void)textDidEnd
{
    
    if ([self.sellNumberTF.text doubleValue] <= balance) {
        [self calculation:[self.sellNumberTF.text doubleValue]];

    }else{
        self.sellNumberTF.text = @"";
        [self.view endEditing:YES];
        [self.view showMsg:NSLocalizedString(@"余额不足", nil)];
    }
    
}

- (void)calculation:(double)mgpNumber{

    self.balanceLabel.text = [NSString stringWithFormat:@"%@%.4f MGP",NSLocalizedString(@"剩余", nil),balance-mgpNumber];
    
    self.totalLabelR.text = [NSString getMoneyStringWithMoneyNumber:mgpNumber*[self.stepper2 value]];
    if (mgpNumber > 0 && isOverTheCounterContact == 0 && remaining.doubleValue > 0 && [self.min_sellNumberTF.text doubleValue] > 0) {
        [self.sellButton setEnabled:YES];
        self.sellButton.backgroundColor = RGB(0, 141, 237);

    }else{
        [self.sellButton setEnabled:NO];
        self.sellButton.backgroundColor = RGB(194, 194, 194);

    }
}
- (IBAction)posClick:(id)sender {
    UIStoryboard* secondStoryboard = [UIStoryboard storyboardWithName:@"ExchangeHome" bundle:[NSBundle mainBundle]];
    LHSendTransactionViewController *secondNavigationController = [secondStoryboard instantiateViewControllerWithIdentifier:@"LHSendTransactionViewController"];
    secondNavigationController.sendType = earnMoney;
//    [self.navigationController pushViewController:secondNavigationController animated:YES];
}

- (IBAction)allButtonClick:(id)sender {
    [self.view endEditing:YES];
    self.sellNumberTF.text = [NSString stringWithFormat:@"%.4f",balance];
    [self calculation:[self.sellNumberTF.text doubleValue]];
}
- (IBAction)typeSwitchClick:(id)sender {
    [self.view endEditing:YES];

    NSArray *dataArray = [NSArray arrayWithObjects:NSLocalizedString(@"最小出售金额", nil), NSLocalizedString(@"最小出售数量", nil),NSLocalizedString(@"取消", nil),nil];
      
    CCPActionSheetView *actionSheetView = [[CCPActionSheetView alloc]initWithActionSheetArray:dataArray];
      
    [actionSheetView cellDidSelectBlock:^(NSString *indexString, NSInteger index) {
        switch (index) {
            case 0:
                typeSwitcNum = NO;
                self.typeSwitchLabel.text = NSLocalizedString(@"最小出售金额", nil);
                [self.min_sellNumberUnit setTitle:@"CNY" forState:UIControlStateNormal];
                self.min_sellNumberTF.text = @"";
                self.min_sellNumberTF.placeholder = NSLocalizedString(@"请输入最小出售金额", nil);
                break;
            case 1:
                typeSwitcNum = YES;
                self.typeSwitchLabel.text = NSLocalizedString(@"最小出售数量", nil);
                [self.min_sellNumberUnit setTitle:@"MGP" forState:UIControlStateNormal];
                self.min_sellNumberTF.text = @"";
                self.min_sellNumberTF.placeholder = NSLocalizedString(@"请输入最小出售数量", nil);

                break;
                
            default:
                break;
        }
          
    }];
}
- (IBAction)sellClick:(id)sender {
    WEAKSELF
    self.dialogView =
    [[XFDialogInput dialogWithTitle:NSLocalizedString(@"请输入密码！", nil)
                                 attrs:@{
                                         XFDialogTitleViewBackgroundColor : [UIColor orangeColor],
                                         XFDialogTitleColor: [UIColor whiteColor],
                                         XFDialogLineColor: [UIColor orangeColor],
                                         XFDialogNoticeText: NSLocalizedString(@"0.00 MGP将转账至OTC合约，在未产生买单前可以随时撤销委托订单赎回MGP", nil),
                                         XFDialogInputFields:@[
                                                 @{
                                                     XFDialogInputPlaceholderKey : NSLocalizedString(@"密码(8-18位字符)", nil),
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
                            [self.view showHUD];
                            
        
                            NSString *mgp_otcstore = [[DomainConfigManager share]getCurrentEvnDict][otcstore];
                            NSString *quantity = [NSString stringWithFormat:@"%.4f MGP",[self.sellNumberTF.text doubleValue]];
        
                            NSString *price = [NSString stringWithFormat:@"%.2f CNY",[self.stepper2 value]];
                            
                            double min_sell = typeSwitcNum ? [self.min_sellNumberTF.text doubleValue]*[self.stepper2 value] : [self.min_sellNumberTF.text doubleValue];
                            NSString *min_accept_quantity = [NSString stringWithFormat:@"%.2f CNY",min_sell];

                            NSDictionary *p = @{
                                @"owner":[MGPHttpRequest shareManager].curretWallet.address,
                                @"quantity":quantity,
                                @"price":price,
                                @"min_accept_quantity":min_accept_quantity
                                
                            };
        
        NSDictionary *dic = @{
            @"code":@"eosio.token",
            @"action":@"transfer",
            @"parameter":@{
                    @"from":VALIDATE_STRING([MGPHttpRequest shareManager].curretWallet.address),
                    @"to":VALIDATE_STRING(mgp_otcstore),
                    @"memo":VALIDATE_STRING(@""),
                    @"quantity":[NSString stringWithFormat:@"%.4f MGP", self.sellNumberTF.text.doubleValue]
                }
        };
        NSDictionary *dic1 = @{
            @"code":mgp_otcstore,
            @"action":@"openorder",
            @"parameter":@{
                    @"owner":[MGPHttpRequest shareManager].curretWallet.address,
                    @"quantity":quantity,
                    @"price":price,
                    @"min_accept_quantity":min_accept_quantity
                    
                }
        };
        
        [[DCWalletTool shareManager]contractParameters:@[dic,dic1] andPassWord:pwd completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
                
            if (responseObj) {
                [self.view showMsg:NSLocalizedString(@"出售挂单成功", nil)];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                    
                });
            }

        }];
        
        
        /*
                            [[DCMGPWalletTool shareManager]transferAmount:VALIDATE_STRING(self.sellNumberTF.text) andFrom:[MGPHttpRequest shareManager].curretWallet.address andTo:mgp_otcstore andMemo:nil andPassWord:pwd completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
                                
                                if (responseObj) {
                                    
                                    [[DCMGPWalletTool shareManager]contractCode:mgp_otcstore andAction:@"openorder" andParameters:p andPassWord:pwd completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
                                        [self.view hideHUD];
                                        if (responseObj) {
                                            [self.view showMsg:NSLocalizedString(@"出售挂单成功", nil)];
                                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                [self.navigationController popViewControllerAnimated:YES];
                                                
                                            });
                                            
                                        }
                                    }];
                             
                                    
                                }
                            }];
        */
                           
                        } errorCallBack:^(NSString *errorMessage) {
                            NSLog(@"error -- %@",errorMessage);
                            
                        }] showWithAnimationBlock:nil];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return [super numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return [super tableView:tableView numberOfRowsInSection:section];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return isOverTheCounterContact == 0 ? 0 : 30;
    }if (indexPath.row == 1) {
        return remaining.doubleValue > 0 ? 0 : 30;
    }else{
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
