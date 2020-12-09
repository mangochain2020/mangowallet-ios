//
//  MangoDefiPayViewController.m
//  TaiYiToken
//
//  Created by mac on 2020/9/1.
//  Copyright © 2020 admin. All rights reserved.
//

#import "MangoDefiPayViewController.h"
#import <SDCycleScrollView.h>
#import "LHRecordTableViewController.h"

@interface MangoDefiPayViewController ()<STPickerSingleDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet SDCycleScrollView *cycleScrollView;
@property (weak, nonatomic) IBOutlet UIView *centerView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UITextField *priceTf;
@property (weak, nonatomic) IBOutlet UILabel *priceRightLabel;

@property (weak, nonatomic) IBOutlet UILabel *discountLabel;
@property (weak, nonatomic) IBOutlet UITextField *discountTf;
@property (weak, nonatomic) IBOutlet UIImageView *discountImage;

@property (weak, nonatomic) IBOutlet UILabel *giveLabel;
@property (weak, nonatomic) IBOutlet UITextField *giveTf;

@property (weak, nonatomic) IBOutlet UILabel *feeLabel;
@property (weak, nonatomic) IBOutlet UITextField *feeTf;

@property (weak, nonatomic) IBOutlet UILabel *accounLabel;
@property (weak, nonatomic) IBOutlet UITextField *accounTf;

@property (weak, nonatomic) IBOutlet UILabel *msgLabel;
@property (weak, nonatomic) IBOutlet UITextField *msgTf;

@property (weak, nonatomic) IBOutlet UILabel *payTitle;
@property (weak, nonatomic) IBOutlet UILabel *payNumLabel;

@property (weak, nonatomic) IBOutlet UIButton *buyBtn;

@property (strong,nonatomic)NSDictionary *orderPayDic;
@property (strong,nonatomic)NSDictionary *defaultModelDic;

@property (assign,nonatomic)double mgpPrice;
@property (assign,nonatomic)double discount;

@property (nonatomic, weak) XFDialogFrame *dialogView;



@end

@implementation MangoDefiPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"买单", nil);
    self.tableView.tableFooterView = [UIView new];
    self.priceLabel.text = [CreateAll GetCurrentCurrency].symbol;
    self.discountLabel.text = NSLocalizedString(@"让利折扣", nil);
    self.giveLabel.text = NSLocalizedString(@"赠送价值", nil);
    self.feeLabel.text = NSLocalizedString(@"手续费", nil);
    self.accounLabel.text = NSLocalizedString(@"接收账户", nil);
    self.msgLabel.text = NSLocalizedString(@"备注", nil);
    self.payTitle.text = NSLocalizedString(@"本次支付", nil);
    [self.buyBtn setTitle:NSLocalizedString(@"支付", nil) forState:UIControlStateNormal];
    self.priceTf.placeholder = NSLocalizedString(@"请输入金额", nil);
    self.msgTf.placeholder = NSLocalizedString(@"选填", nil);

    self.cycleScrollView.imageURLStringsGroup = self.dataDic[@"detailImg"];
    self.accounTf.text = [MGPHttpRequest shareManager].curretWallet.address;
    [self getSaleModelData];

    [_priceTf addTarget:self action:@selector(textChange) forControlEvents:
        UIControlEventEditingChanged];
    
}
- (void)getSaleModelData{
    MJWeakSelf
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);//
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [[MGPHttpRequest shareManager]post:@"/api/appStoreLife/order/payInit" paramters:@{@"storeId":self.dataDic[@"id"],@"address":[MGPHttpRequest shareManager].curretWallet.address} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
            dispatch_group_leave(group);
            
            if ([responseObj[@"code"]intValue] == 0) {
                weakSelf.orderPayDic = responseObj[@"data"];
                self.feeTf.text = [NSString stringWithFormat:@"%.f%%",[weakSelf.orderPayDic[@"serviceChargePro"] doubleValue]*100];

            }
        }];
    });
    dispatch_group_enter(group);//
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[MGPHttpRequest shareManager]post:@"/api/coinPrice" paramters:@{@"pair":@"MGP_USDT"} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
            dispatch_group_leave(group);
            if ([responseObj[@"code"]intValue] == 0) {
                weakSelf.mgpPrice =((NSString *)VALIDATE_STRING([responseObj[@"data"]objectForKey:@"price"])).doubleValue;
            }
        }];
    });
    //二个网络请求都完成统一处理
    dispatch_group_notify(group, queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{

            self.accounTf.enabled = [self.orderPayDic[@"isMer"]boolValue] ? YES : NO;
            self.discountImage.hidden = !self.accounTf.enabled;
            [weakSelf setDiscountData:[NSString stringWithFormat:@"%.2f",[self.orderPayDic[@"buyerPro"]doubleValue] *100.0]];
        });
        
    });
    
    UIButton *_scanBtn = [UIButton buttonWithType: UIButtonTypeRoundedRect];
    _scanBtn.frame = CGRectMake(0, 0, 100, 60);
    [_scanBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_scanBtn setTitle:NSLocalizedString(@"记录", nil) forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_scanBtn];
    _scanBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    
    
}
- (void)rightBtnClick{
    //LHPayOperationViewControllerIndexs
    UIStoryboard* secondStoryboard = [UIStoryboard storyboardWithName:@"ExchangeHome" bundle:[NSBundle mainBundle]];
    LHRecordTableViewController *secondNavigationController = [secondStoryboard instantiateViewControllerWithIdentifier:@"LHRecordTableViewControllerIndex"];
    secondNavigationController.type = appStoreLifeOrderList;
    [self.navigationController pushViewController:secondNavigationController animated:YES];
    
//    [[MGPHttpRequest shareManager]post:@"/api/appStoreLife/order/orderList" paramters:@{@"limit":@"100",@"page":@"1",@"address":[MGPHttpRequest shareManager].curretWallet.address} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
//
//        if ([responseObj[@"code"]intValue] == 0) {
//
//
//
//        }
//    }];
    
}
//让利折扣
- (IBAction)discountClick:(id)sender {
    [self.view endEditing:YES];
    if (![self.orderPayDic[@"isMer"]boolValue]) {
        return;
    }
    if (self.defaultModelDic) {
        [self showSTPickerSingle];
    }else{
        [self getDefaultModelData];
    }
}
- (void)getDefaultModelData{
    [[MGPHttpRequest shareManager]post:@"/appStore/saleModel/defaultModel" paramters:@{@"id":@"2"} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
        if ([responseObj[@"code"]intValue] == 0) {
            
            self.defaultModelDic = responseObj[@"data"];
            [self showSTPickerSingle];
            
        }
    }];
}
- (void)showSTPickerSingle{
    STPickerSingle *single = [[STPickerSingle alloc]init];
    [single setArrayData:[self.defaultModelDic objectForKey:@"buyerGainPros"]];
    [single setTitle:NSLocalizedString(@"请选择", nil)];
    [single setTitleUnit:@""];
    [single setDelegate:self];
    [single show];
}

- (void)pickerSingle:(STPickerSingle *)pickerSingle selectedTitle:(NSString *)selectedTitle
{

    [self setDiscountData:selectedTitle];
    

}


- (void)setDiscountData:(NSString *)selectedTitle{
    
    self.discount = [selectedTitle doubleValue] / 100;
    self.discountTf.text = [NSString stringWithFormat:@"%@%%",selectedTitle];
    [self textChange];
}
- (void)textChange{
//    self.priceRightLabel.text = [NSString stringWithFormat:@"≈%@%.2f",[CreateAll GetCurrentCurrency].symbol,([[CreateAll GetCurrentCurrency].price doubleValue] / _priceTf.text.doubleValue)];
//    self.payNumLabel.text = [NSString stringWithFormat:@"%.4f MGP",_priceTf.text.doubleValue / self.mgpPrice * self.discount];
//    self.giveTf.text = [NSString stringWithFormat:@"%@%.2f",[CreateAll GetCurrentCurrency].symbol,([[CreateAll GetCurrentCurrency].price doubleValue] * (_priceTf.text.doubleValue / self.mgpPrice * self.discount * 3.0))];

    //价格
    self.priceRightLabel.text = [NSString stringWithFormat:@"≈$%.2f",(_priceTf.text.doubleValue / [[CreateAll GetCurrentCurrency].price doubleValue])];
    
    //赠送价值
    self.giveTf.text = [NSString stringWithFormat:@"%@%.2f",[CreateAll GetCurrentCurrency].symbol,(_priceTf.text.doubleValue * self.discount * 3.0)];

    
    
    if ([self.orderPayDic[@"isMer"]boolValue]) {
        //支付mgp
        NSString *s = [NSString stringWithFormat:@"%.2f",(_priceTf.text.doubleValue / [[CreateAll GetCurrentCurrency].price doubleValue])];
        NSString *discount = [NSString stringWithFormat:@"%f",[s doubleValue] / self.mgpPrice * self.discount];
        
        self.payNumLabel.text = [NSString stringWithFormat:@"%.4f MGP",discount.doubleValue + (discount.doubleValue*[self.orderPayDic[@"serviceChargePro"] doubleValue])];
        
    }else{
        //支付mgp
        NSString *s = [NSString stringWithFormat:@"%.2f",(_priceTf.text.doubleValue / [[CreateAll GetCurrentCurrency].price doubleValue])];
        NSString *discount = [NSString stringWithFormat:@"%f",[s doubleValue] / self.mgpPrice];
        
        self.payNumLabel.text = [NSString stringWithFormat:@"%.4f MGP",discount.doubleValue + (discount.doubleValue*[self.orderPayDic[@"serviceChargePro"] doubleValue])];
        
    }
    
    
    
    
}


- (IBAction)buyClick:(id)sender {
        
    if (_priceTf.text.doubleValue < 0 ) {
        [self.view showMsg:NSLocalizedString(@"美金数不足0", nil)];
        return;

    }else if(_accounTf.text.length <= 0 ){
        [self.view showMsg:NSLocalizedString(@"接收账户不可为空", nil)];
        return;

    }else if(_accounTf.text.length != 12 ){
        [self.view showMsg:NSLocalizedString(@"非法账户名", nil)];
        return;
    }
    // 提示框
    // 提示框的样式只有两种  中间 下方
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确认支付？" preferredStyle:UIAlertControllerStyleAlert];
    // 添加按钮
    // 参数1 : 标题
    // 参数2 : 样式
    // 参数3 : 当点击按钮回自动进入参数3的block中进行处理
    UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 点击确认改变背景颜色
        NSString *money = [NSString stringWithFormat:@"%.2f",(_priceTf.text.doubleValue / [[CreateAll GetCurrentCurrency].price doubleValue])];

        [[MGPHttpRequest shareManager]post:@"/api/appStoreLife/order/addOrder" paramters:@{@"money":money,@"gainAddress":self.accounTf.text,@"address":[MGPHttpRequest shareManager].curretWallet.address,@"storeId":self.dataDic[@"id"],@"buyerPro":@(self.discount),@"msg":VALIDATE_STRING(_msgTf.text)} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
            if ([responseObj[@"code"]intValue] == 0) {
                [self inputPassWorldSubmit:[responseObj[@"data"]objectForKey:@"orderSn"]];
            }
        }];

    }];
    UIAlertAction *alertB = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    // 将按钮添加到提示框
    [alertC addAction:alertB];
    [alertC addAction:alertA];
    // 弹出提示框
    [self presentViewController:alertC animated:YES completion:nil];
    
    
    
    
    
    
    
}

- (void)inputPassWorldSubmit:(NSString *)orderId{
    
    WEAKSELF
    self.dialogView =
    [[XFDialogInput dialogWithTitle:NSLocalizedString(@"请输入密码！", nil)
                                 attrs:@{
                                         XFDialogTitleViewBackgroundColor : [UIColor orangeColor],
                                         XFDialogTitleColor: [UIColor whiteColor],
                                         XFDialogLineColor: [UIColor orangeColor],
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
        
                            NSDictionary *memoDic = @{@"orderSn":orderId,
                                                  @"currencyPrice":@(self.mgpPrice),
                                                  @"dollar":self.priceTf.text
                            };
                            
        [[DCMGPWalletTool shareManager]transferAmount:[self.payNumLabel.text componentsSeparatedByString:@" "].firstObject andFrom:[MGPHttpRequest shareManager].curretWallet.address andTo:@"mgpchainshop" andMemo:[[DCMGPWalletTool shareManager]convertToJsonData:memoDic] andPassWord:pwd completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
                                
                                if (responseObj) {
                                    [[MGPHttpRequest shareManager]post:@"/api/appStoreLife/order/payOrder" paramters:@{@"orderSn":orderId,@"payNum":[self.payNumLabel.text componentsSeparatedByString:@" "].firstObject,@"payPrice":@(self.mgpPrice),@"hash":responseObj,@"address":[MGPHttpRequest shareManager].curretWallet.address} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
                                        if ([responseObj[@"code"]intValue] == 0) {
                                            [weakSelf.view showMsg:NSLocalizedString(@"交易成功", nil)];
                                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                [self.navigationController popToRootViewControllerAnimated:YES];
                                            });
                                        }
                                    }];
                                    
                                }
                            }];
        
                            
        
                        } errorCallBack:^(NSString *errorMessage) {
                            NSLog(@"error -- %@",errorMessage);
                            
                        }] showWithAnimationBlock:nil];
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
