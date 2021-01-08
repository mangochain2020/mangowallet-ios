//
//  LHSendTransactionViewController.m
//  TaiYiToken
//
//  Created by mac on 2020/7/28.
//  Copyright © 2020 admin. All rights reserved.
//

#import "LHSendTransactionViewController.h"
#import "BlockChain.h"
#import "CCPActionSheetView.h"
#import "OperationProcessTableViewController.h"

@interface LHSendTransactionViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIImageView *walletIconView;
@property (weak, nonatomic) IBOutlet UILabel *walletNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *walletAddressLabel;

@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UIButton *tokenBalanceButton;
@property (weak, nonatomic) IBOutlet UILabel *tokenTitleLabel;

@property (weak, nonatomic) IBOutlet UITextField *subAmountTextField;
@property (weak, nonatomic) IBOutlet UIButton *subTokenBalanceButton;
@property (weak, nonatomic) IBOutlet UILabel *subTokenTitleLabel;

@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UIButton *scanButton;
@property (weak, nonatomic) IBOutlet UILabel *addressTitleLabel;

@property (weak, nonatomic) IBOutlet UITextField *midTextField;
@property (weak, nonatomic) IBOutlet UIButton *midButton;
@property (weak, nonatomic) IBOutlet UILabel *midTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *levelLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelRightLabel;

@property (weak, nonatomic) IBOutlet UILabel *gasCostLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *gasCostRightLabel;

@property (weak, nonatomic) IBOutlet UIButton *netButton;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;


@property(strong, nonatomic) NSNumber *currencyPrice; //当前价格
@property(strong, nonatomic) NSNumber *currencyBalance; //当前余额
@property(strong, nonatomic) NSNumber *bondMinimum; //usdt最低额
@property(strong, nonatomic) NSNumber *hmio_pro; //HMIO比率


@property(nonatomic,strong)MissionWallet *wallet;


//MGP EOS trans
@property (nonatomic, strong) JSContext *context;
@property(nonatomic,strong)JavascriptWebViewController *jvc;

@property (nonatomic, copy) NSString *ref_block_prefix;
@property (nonatomic, copy) NSString *ref_block_num;
@property (nonatomic, strong) NSData *chain_Id;
@property (nonatomic, copy) NSString *expiration;
@property (nonatomic, copy) NSString *required_Publickey;
@property (nonatomic, copy) NSString *binargs;

@end

@implementation LHSendTransactionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.mj_header = [DCHomeRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(setupUI)];
    [self.tableView.mj_header beginRefreshing];
    self.wallet = [MGPHttpRequest shareManager].curretWallet;
    [self.netButton setTitle:NSLocalizedString(@"下一步", nil) forState:UIControlStateNormal];
    [self.rightBtn setTitle:NSLocalizedString(@"记录", nil) forState:UIControlStateNormal];
    
}
/**
加载UI事件
*/
- (void)setupUI{

    MJWeakSelf
    //创建组队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_group_t group = dispatch_group_create();
    
    if (![[MGPHttpRequest shareManager].curretWallet.walletName isEqualToString:@"MGP_"]) {
       //组任务1
        dispatch_group_enter(group);//
        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *name = [[MGPHttpRequest shareManager].curretWallet.walletName componentsSeparatedByString:@"_"].lastObject;
            NSDictionary *dic = @{@"account_name":name};
            [[HTTPRequestManager shareMgpManager] post:eos_get_account paramters:dic success:^(BOOL isSuccess, id responseObject) {
                
                if (isSuccess) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSString *balancestr = [(NSDictionary *)responseObject objectForKey:@"core_liquid_balance"];
                        NSString *valuestring = [balancestr componentsSeparatedByString:@" "].firstObject;
                        double balance = valuestring.doubleValue;
                        self.currencyBalance = @(balance);
                        [self.tokenBalanceButton setTitle:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"余额:", nil),balancestr] forState:UIControlStateNormal];
                        
                    });
                    
                }
            } failure:^(NSError *error) {
                
            } superView:self.view showFaliureDescription:YES];
        });
        //组任务2
        dispatch_group_enter(group);//
        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[MGPHttpRequest shareManager]post:@"/api/coinPrice" paramters:@{@"pair":@"MGP_USDT"} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
                dispatch_group_leave(group);
                if ([responseObj[@"code"]intValue] == 0) {
                   weakSelf.currencyPrice =@(((NSString *)VALIDATE_STRING([responseObj[@"data"] objectForKey:@"price"])).doubleValue);

                }
            }];
        });
        //组任务3
        dispatch_group_enter(group);//
        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[MGPHttpRequest shareManager]post:@"/userCash/lower" paramters:@{@"address":[MGPHttpRequest shareManager].curretWallet.address} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
                dispatch_group_leave(group);
                if ([responseObj[@"code"]intValue] == 0) {
                    if (self.sendType == bondFirst || self.sendType == bond) {
                        self.desLabel.text = responseObj[@"msg"];
                        weakSelf.bondMinimum =@(((NSString *)VALIDATE_STRING(responseObj[@"data"])).doubleValue);

                    }
                    
                }
            }];
        });
        
        //二个网络请求都完成统一处理
        dispatch_group_notify(group, queue, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView.mj_header endRefreshing];
                if (self.sendType == earnMoney||self.sendType == bond||self.sendType == bondFirst) {
                    self.tokenBalanceButton.hidden = NO;
                }else{
                    self.tokenBalanceButton.hidden = YES;
                }
            });
            
        });
        
    }
    
    _walletNameLabel.text = [MGPHttpRequest shareManager].curretWallet.walletName;
    _walletAddressLabel.text = [MGPHttpRequest shareManager].curretWallet.address;
    
    switch (self.sendType) {
        case def:
            
            break;
        case bindMID:
            self.title = NSLocalizedString(@"MID绑定", nil);
            _midTitleLabel.text = NSLocalizedString(@"邀请人", nil);
            _midTextField.placeholder = NSLocalizedString(@"请输入MID", nil);
            _amountTextField.text = @"10";
            
            break;
        case bondFirst:
            self.title = NSLocalizedString(@"申请开通", nil);
            self.amountTextField.placeholder = NSLocalizedString(@"请输入数量", nil);
            self.tokenTitleLabel.text = NSLocalizedString(@"转账金额", nil);
            self.addressTitleLabel.text = NSLocalizedString(@"收款的USDT地址", nil);
            self.addressTextField.placeholder = NSLocalizedString(@"请输入USDT收款地址", nil);
            break;
        case bindEth:
            self.title = NSLocalizedString(@"绑定ETH地址", nil);
            self.addressTitleLabel.text = NSLocalizedString(@"收款地址", nil);
            self.addressTextField.placeholder = NSLocalizedString(@"收款地址", nil);
            break;
        case bond:
            self.title = NSLocalizedString(@"充值保证金", nil);
            self.amountTextField.placeholder = NSLocalizedString(@"请输入数量", nil);
            self.tokenTitleLabel.text = NSLocalizedString(@"转账金额", nil);
            [self.rightBtn setHidden:NO];
            break;
        case vote:
            self.title = NSLocalizedString(@"投票", nil);
            self.amountTextField.placeholder = NSLocalizedString(@"请输入数量", nil);
            self.tokenTitleLabel.text = NSLocalizedString(@"投票数量", nil);
            self.desLabel.text = NSLocalizedString(@"1.一币一票\n2.投票数量为整数", nil);

            break;
        case earnMoney:
        {
            self.title = self.remaining.doubleValue <= 0 ? NSLocalizedString(@"抵押发起", nil) : NSLocalizedString(@"追加抵押", nil);;
            self.amountTextField.placeholder = NSLocalizedString(@"请输入抵押数量", nil);
            self.tokenTitleLabel.text = NSLocalizedString(@"抵押发起", nil);
            self.addressTextField.text = @"addressbookt";
            self.levelLeftLabel.text = NSLocalizedString(@"订单价值", nil);
            self.gasCostLeftLabel.text = NSLocalizedString(@"订单星级", nil);
            self.levelRightLabel.text = NSLocalizedString(@"$0", nil);
            self.gasCostRightLabel.text = NSLocalizedString(@"M0", nil);
        }
            break;
        case redeem:
            self.title = NSLocalizedString(@"赎回", nil);
            self.tokenTitleLabel.text = NSLocalizedString(@"可赎回数量", nil);
            self.amountTextField.text = self.remaining;
            [self.tableView.mj_header endRefreshing];
            
            break;
        case extractEth:
        case extractMio:
        {
            self.title = self.sendType == extractEth ? NSLocalizedString(@"我的激励", nil) : NSLocalizedString(@"收益提取", nil);
            self.tokenTitleLabel.text = NSLocalizedString(@"可提取", nil);
            self.levelLeftLabel.text = NSLocalizedString(@"冻结", nil);
            self.gasCostLeftLabel.text = NSLocalizedString(@"手续费", nil);
            self.levelRightLabel.text = NSLocalizedString(@"$0", nil);
            self.gasCostRightLabel.text = NSLocalizedString(@"0", nil);
            self.amountTextField.placeholder = NSLocalizedString(@"拉取数据中...", nil);
            NSString *typeStr = self.sendType == extractEth ? @"2" : @"1";
            [[MGPHttpRequest shareManager]post:@"/order/withdraw/withdrawIndex" paramters:@{@"address":[MGPHttpRequest shareManager].curretWallet.address,@"moneyType":typeStr} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
                
                if ([responseObj[@"code"] intValue] == 0) {
                    self.amountTextField.text = [NSString stringWithFormat:@"%.4f",[[responseObj[@"data"]objectForKey:@"money"]doubleValue]];
                    self.gasCostRightLabel.text = [NSString stringWithFormat:@"%.4f %@",[[responseObj[@"data"]objectForKey:@"serviceCharge"]doubleValue],self.sendType == extractEth ? @"ETH" : @"MGP"];
                    self.levelRightLabel.text = [NSString stringWithFormat:@"%@ %@",[responseObj[@"data"]objectForKey:@"lockMoney"],self.sendType == extractEth ? @"ETH" : @"MGP"];
                    [self.tableView reloadData];
                }
                
            }];
        }
            break;
            
        default:
            break;
    }
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];

}

/**
 右上角按钮事件
 */
- (IBAction)rightButtonClick:(id)sender {
    [self performSegueWithIdentifier:@"pushLHRecordTableViewController" sender:nil];
}

/**
 按钮点击事件
 */
- (IBAction)boutomClick:(id)sender {
    if (![self verifyInformation]) {return;}
    if (self.sendType == earnMoney){
        NSArray *dataArray = [NSArray arrayWithObjects:@"MGP", @"MGP+HMIO",@"取消",nil];
          
        CCPActionSheetView *actionSheetView = [[CCPActionSheetView alloc]initWithActionSheetArray:dataArray];
          
          [actionSheetView cellDidSelectBlock:^(NSString *indexString, NSInteger index) {
              if (index == 0) {
                  [self showPActionSheetView];
              }else{
                  if (self.amountTextField.text.doubleValue > self.currencyBalance.doubleValue*2) {
                      [self.view showMsg:NSLocalizedString(@"输入的金额大于可用余额", nil)];
                      return;
                  }
                  [[MGPHttpRequest shareManager]post:@"/api/userOrder/blend/blendOrderRatioByDollar" paramters:@{@"address":[MGPHttpRequest shareManager].curretWallet.address,@"num":self.amountTextField.text} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
                      
                      if ([responseObj[@"code"] intValue] == 0) {
                          self.hmio_pro = [NSNumber numberWithDouble:[[responseObj[@"data"]objectForKey:@"hmio_pro"]doubleValue]];
                          [self performSegueWithIdentifier:@"OperationProcessTableViewController" sender:nil];

                      }
                      
                  }];

              }
              
        }];
    }else{
        [self showPActionSheetView];
    }
    
    
    
    
    
}
- (void)showPActionSheetView{

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"请输入密码！", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = NSLocalizedString(@"密码(8-18位字符)", nil);
        textField.secureTextEntry = YES;
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *pass = alertController.textFields.firstObject;

        if([pass.text isEqualToString:@""] || pass == nil){
            [self.view showMsg:NSLocalizedString(@"请输入密码！", nil)];
        }else{
            //解密钱包私钥
            if(![[MGPHttpRequest shareManager].curretWallet.privateKey isValidBitcoinPrivateKey]){
                NSString *depri = [AESCrypt decrypt:[MGPHttpRequest shareManager].curretWallet.privateKey password:pass.text];
                if (depri != nil && ![depri isEqualToString:@""]) {
                    [MGPHttpRequest shareManager].curretWallet.privateKey = depri;
                    [self transfer:pass.text];
                }else{
                    [self.view showMsg:@"Wallet Error"];
                }
            }else{
                [self transfer:pass.text];
            }
        }
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
/**
验证数据的准确合法性
*/
- (BOOL)verifyInformation{

    
    switch (self.sendType) {
        case bindMID:
            if (self.midTextField.text.length <= 0) {
                [self.view showMsg:NSLocalizedString(@"请输入邀请码", nil)];
                return NO;
            }
            break;
        case bindEth:
            if (self.addressTextField.text.length <= 0) {
                [self.view showMsg:NSLocalizedString(@"请输入ETH地址", nil)];
                return NO;
            }
            break;
        case earnMoney:
            if (self.amountTextField.text.doubleValue > self.currencyBalance.doubleValue) {
                [self.view showMsg:NSLocalizedString(@"输入的金额大于可用余额", nil)];
                return NO;
            }
            if (self.amountTextField.text.doubleValue < 10) {
                [self.view showMsg:NSLocalizedString(@"最低抵押10MGP", nil)];
                return NO;
            }/*
            if (((self.remaining.doubleValue + self.amountTextField.text.doubleValue) * self.currencyPrice.doubleValue) < 100) {
                [self.view showMsg:NSLocalizedString(@"最低抵押$100.00", nil)];
                return NO;
            }*/
            break;
        case bondFirst:
            if (self.amountTextField.text.doubleValue < self.bondMinimum.doubleValue) {
                [self.view showMsg:[NSString stringWithFormat:@"%@%@MGP",NSLocalizedString(@"最低抵押", nil),self.bondMinimum]];
                return NO;
            }
            
            if (self.addressTextField.text.length <= 0) {
                [self.view showMsg:NSLocalizedString(@"请输入USDT收款地址", nil)];
                return NO;
            }
            break;
        case vote:
            if (self.amountTextField.text.doubleValue > self.currencyBalance.doubleValue) {
                [self.view showMsg:NSLocalizedString(@"输入的金额大于可用余额", nil)];
                return NO;
            }
            if (self.amountTextField.text.doubleValue <= 0) {
                [self.view showMsg:NSLocalizedString(@"请输入投票数量", nil)];
                return NO;
            }
            
            if (![self isPureInt:self.amountTextField.text]) {
                [self.view showMsg:NSLocalizedString(@"投票数量为整数", nil)];
                return NO;
            }
            break;
        case bond:
            
            if (self.amountTextField.text.doubleValue < self.bondMinimum.doubleValue) {
                [self.view showMsg:[NSString stringWithFormat:@"%@%@MGP",NSLocalizedString(@"最低抵押", nil),self.bondMinimum]];
                return NO;
            }
            break;
            
        default:
            break;
    }
    return YES;
}
//判断是否为整形：
- (BOOL)isPureInt:(NSString*)string{

   NSScanner* scan = [NSScanner scannerWithString:string];

   int val;

   return[scan scanInt:&val] && [scan isAtEnd];

}
- (void)transfer:(NSString *)pwd{

    switch (self.sendType) {
        case bindMID:
            {
                [[MGPHttpRequest shareManager]post:@"/userTransactionRecord/find" paramters:@{@"address":[MGPHttpRequest shareManager].curretWallet.address,@"type":@"1"} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
                        if ([responseObj[@"code"] intValue] == 0) {
                            [[MGPHttpRequest shareManager]post:@"/user/bindMgp" paramters:@{@"mgpName":[MGPHttpRequest shareManager].curretWallet.address,@"parentMid":self.midTextField.text} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
                                    if ([responseObj[@"code"] intValue] == 0) {
                                        [self.view showMsg:NSLocalizedString(@"身份标识绑定成功", nil)];
                                        [self.navigationController popViewControllerAnimated:YES];
                                    }
                            }];
                        }
                }];
            }
            break;
        case bindEth:
            {
                [[MGPHttpRequest shareManager]post:@"/userTransactionRecord/newCheckAddr" paramters:@{@"address":[MGPHttpRequest shareManager].curretWallet.address,@"bindAdress":self.addressTextField.text,@"type":@"2"} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
                        if ([responseObj[@"code"] intValue] == 0) {
                            if ([responseObj[@"data"] intValue] == 2) {
                                
                                [[DCMGPWalletTool shareManager]contractCode:@"addressbookt" andAction:@"bindaddress" andParameters:@{@"account":VALIDATE_STRING(self.wallet.address),@"address":VALIDATE_STRING(self.addressTextField.text)} andPassWord:pwd completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
                                         
                                    if (responseObj) {
                                        NSDictionary *dic = @{
                                            @"currentAddr":[MGPHttpRequest shareManager].curretWallet.address,
                                            @"hash":VALIDATE_STRING(responseObj),
                                            @"bindAddr":VALIDATE_STRING(self.addressTextField.text),
                                            @"type":@"2",
                                            @"money":@"0",

                                        };
                                        
                                        [[MGPHttpRequest shareManager]post:@"/userTransactionRecord/add" paramters:dic completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
                                                if ([responseObj[@"code"] intValue] == 0) {
                                                    [self.view showMsg:NSLocalizedString(@"ETH绑定成功", nil)];
                                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                        [self.navigationController popViewControllerAnimated:YES];
                                                    });
                                                    
                                                }
                                        }];
                                        
                                    }
                                }];
                                
                            }

                        }
                }];
            }
            break;
        case extractEth:
        case extractMio:
            {
                NSString *typeStr = self.sendType == extractEth ? @"2" : @"1";
                [[MGPHttpRequest shareManager]post:@"/order/withdraw/addOrder" paramters:@{@"address":[MGPHttpRequest shareManager].curretWallet.address,@"moneyType":typeStr} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
                        if ([responseObj[@"code"] intValue] == 0) {
                           
                            [self.view showMsg:NSLocalizedString(@"提取成功", nil)];
                            [self.navigationController popViewControllerAnimated:YES];
                        }else{
                            [self.view showMsg:responseObj[@"msg"]];
                        }
                }];
            }
            break;
        case earnMoney:
        {
            [[DCMGPWalletTool shareManager]transferAmount:VALIDATE_STRING(self.amountTextField.text) andFrom:[MGPHttpRequest shareManager].curretWallet.address andTo:VALIDATE_STRING(self.addressTextField.text) andMemo:nil andPassWord:pwd completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
                
                if (responseObj) {
                    [self.view showMsg:NSLocalizedString(@"抵押成功", nil)];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }
                
            }];
        }
            break;
        case redeem:
        {
            [[DCMGPWalletTool shareManager]contractCode:@"addressbookt" andAction:@"redeem" andParameters:@{@"account":VALIDATE_STRING(self.wallet.address)} andPassWord:pwd completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
                     
                if (responseObj) {
                    [self.view showMsg:NSLocalizedString(@"赎回成功", nil)];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }
            }];
 
        }
            break;
        case bondFirst:
        case bond:
        {
            [[DCMGPWalletTool shareManager]transferAmount:VALIDATE_STRING(self.amountTextField.text) andFrom:[MGPHttpRequest shareManager].curretWallet.address andTo:@"mgpchainbond" andMemo:nil andPassWord:pwd completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
                
                if (responseObj) {
                    [[MGPHttpRequest shareManager]post:@"/userBindUsdt/bindUsdt" paramters:@{@"mgpName":[MGPHttpRequest shareManager].curretWallet.address,@"usdtAddr":VALIDATE_STRING(self.addressTextField.text),@"hash":VALIDATE_STRING(responseObj),@"money":VALIDATE_STRING(self.amountTextField.text),@"type":(self.sendType == bond) ? @"1" : @"0"} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {

                        if ([responseObj[@"code"]intValue] == 0) {
                            [self.view showMsg:responseObj[@"msg"]];
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [self.navigationController popViewControllerAnimated:YES];
                            });
                            
                        }
                                                
                    }];
                }
                
            }];
        }
            break;
        case vote:
        {
            [[DCMGPWalletTool shareManager]transferAmount:VALIDATE_STRING(self.amountTextField.text) andFrom:[MGPHttpRequest shareManager].curretWallet.address andTo:@"mgpchainvote" andMemo:[NSString stringWithFormat:@"%@,1",self.remaining] andPassWord:pwd completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
                
                if (responseObj) {
                    [self.view showMsg:NSLocalizedString(@"投票成功", nil)];
                }
                
            }];
        }
            break;
        default:
            break;
    }
    
}
- (void)setOrderInfo:(double)price{
    self.levelRightLabel.text = [NSString stringWithFormat:@"$%.2f",price];
    int dengji = 0;
    if (price >= 0 && price < 100) {
        dengji = 0;
    }else if (price >= 100 && price < 500){
        dengji = 1;
    }else if (price >= 500 && price < 2000){
        dengji = 2;
    }else if (price >= 2000 && price < 5000){
        dengji = 3;
    }else if (price > 5000){
        dengji = 4;
    }
    self.gasCostRightLabel.textColor = dengji <= 0 ? [UIColor redColor] : [UIColor blueColor];
    self.levelRightLabel.textColor = dengji <= 0 ? [UIColor redColor] : [UIColor blueColor];
    self.gasCostRightLabel.text = [NSString stringWithFormat:@"M%d",dengji];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (self.sendType) {
        case bindMID:
            return indexPath.row == 3 ? [super tableView:tableView heightForRowAtIndexPath:indexPath] : 0;
            break;
        case bondFirst:
            return (indexPath.row == 0 || indexPath.row == 2) ? [super tableView:tableView heightForRowAtIndexPath:indexPath] : 0;
            break;
        case earnMoney:
            return (indexPath.row == 0 || indexPath.row == 4 || indexPath.row == 5) ? [super tableView:tableView heightForRowAtIndexPath:indexPath] : 0;
            break;
        case redeem:
        case bond:
        case vote:
            return (indexPath.row == 0) ? [super tableView:tableView heightForRowAtIndexPath:indexPath] : 0;
            break;
        case extractEth:
            return (indexPath.row == 0 || indexPath.row == 5) ? [super tableView:tableView heightForRowAtIndexPath:indexPath] : 0;
            break;
        case extractMio:
            return (indexPath.row == 0 || indexPath.row == 4 || indexPath.row == 5) ? [super tableView:tableView heightForRowAtIndexPath:indexPath] : 0;
            break;
        case bindEth:
            return (indexPath.row == 2) ? [super tableView:tableView heightForRowAtIndexPath:indexPath] : 0;

            break;
        default:
            break;
    }
    return 0;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    switch (self.sendType) {
        case bindMID:
        case bindEth:
            return YES;
            break;
        case earnMoney:
            return YES;
            break;
        case redeem:
        case extractEth:
        case extractMio:
            return NO;
            break;
            
        default:
            break;
    }
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    if (textField == self.amountTextField) {

        NSMutableString *str = [NSMutableString stringWithString:textField.text];

        [str replaceCharactersInRange:range withString:string];

        double price = (self.remaining.doubleValue + str.doubleValue) * self.currencyPrice.doubleValue;
        [self setOrderInfo:price];
        NSLog(@"%@",str);

    }

    return YES;

}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.destinationViewController isKindOfClass:[OperationProcessTableViewController class]]) {
        OperationProcessTableViewController *vc = segue.destinationViewController;
        vc.num = [NSString stringWithFormat:@"%.4f",[self.amountTextField.text doubleValue]*[self.hmio_pro doubleValue]];
        vc.transferType = transferHMIO_First;

        
    }
    
}




@end


