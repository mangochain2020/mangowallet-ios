//
//  DCOrderListTableViewCell.m
//  TaiYiToken
//
//  Created by mac on 2020/8/6.
//  Copyright © 2020 admin. All rights reserved.
//

#import "DCOrderListTableViewCell.h"
#import "BlockChain.h"
#import "OperationProcessTableViewController.h"


@interface DCOrderListTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *storeShopName;
@property (weak, nonatomic) IBOutlet UILabel *mark;

@property (weak, nonatomic) IBOutlet UIImageView *shop_image;
@property (weak, nonatomic) IBOutlet UILabel *storeName;
@property (weak, nonatomic) IBOutlet UILabel *storeType;
@property (weak, nonatomic) IBOutlet UILabel *totalNum;
@property (weak, nonatomic) IBOutlet UILabel *price;

@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *button1Layout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *button2Layout;

@property (nonatomic, weak) XFDialogFrame *dialogView;


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


@end

@implementation DCOrderListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.wallet = [MGPHttpRequest shareManager].curretWallet;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.storeShopName.text = self.orderModel.username;
    [self.shop_image sd_setImageWithURL:[NSURL URLWithString:self.orderModel.pro.image_url.firstObject]];

    self.storeName.text = self.orderModel.pro.storeName;
    self.storeType.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"商品规格", nil),self.orderModel.pro.storeType];
    self.totalNum.text = [NSString stringWithFormat:@"%@:%ld",NSLocalizedString(@"商品件数", nil),(long)self.orderModel.order.totalNum];
//    self.price.text = [NSString stringWithFormat:@"%@:$%ld",NSLocalizedString(@"价格", nil),(long)self.orderModel.pro.price];
    self.price.text = [NSString stringWithFormat:@"%@:%@%.2f",NSLocalizedString(@"价格", nil),[CreateAll GetCurrentCurrency].symbol,([[CreateAll GetCurrentCurrency].price doubleValue] * self.orderModel.pro.price)];
    [self.butto_bgView setHidden:NO];
    self.button2Layout.constant = self.button1Layout.constant;

    if (self.isManagement) {//卖家
        if (self.orderModel.order.payStatus == 0) {
            if (self.orderModel.order.isDeliver == 0) {
                self.mark.text = NSLocalizedString(@"待发货", nil);
                self.button2Layout.constant = 0;
                [self.button1 setTitle:NSLocalizedString(@"发货", nil) forState:UIControlStateNormal];
            }else if(self.orderModel.order.isDeliver == 1){
                self.mark.text = NSLocalizedString(@"发货中", nil);
                [self.butto_bgView setHidden:YES];
            }else if(self.orderModel.order.isDeliver == 2){
                self.mark.text = NSLocalizedString(@"交易完成", nil);
                [self.butto_bgView setHidden:YES];
            }
        }else if (self.orderModel.order.payStatus == 1){
            self.mark.text = NSLocalizedString(@"入账中", nil);
            if ([self.orderModel.order.pay intValue] == 1) {
                [self.butto_bgView setHidden:YES];
            }else{
                [self.button1 setTitle:NSLocalizedString(@"确认收款", nil) forState:UIControlStateNormal];
                self.button2Layout.constant = 0;
            }
        }else if (self.orderModel.order.payStatus == 2){
            self.mark.text = NSLocalizedString(@"买家支付失败", nil);
            [self.butto_bgView setHidden:YES];
        }else if (self.orderModel.order.payStatus == 3){
            self.mark.text = NSLocalizedString(@"退款中", nil);
            [self.butto_bgView setHidden:YES];
        }else if (self.orderModel.order.payStatus == 4){
            self.mark.text = NSLocalizedString(@"已退款", nil);
            [self.butto_bgView setHidden:YES];
        }else if (self.orderModel.order.payStatus == 5){
            self.mark.text = NSLocalizedString(@"退款失败", nil);
            [self.butto_bgView setHidden:YES];
        }else if (self.orderModel.order.payStatus == 6){
            self.mark.text = NSLocalizedString(@"买家取消订单", nil);
            [self.butto_bgView setHidden:YES];
        }else if (self.orderModel.order.payStatus == 7){
            self.mark.text = NSLocalizedString(@"待买家支付", nil);
            [self.butto_bgView setHidden:YES];
        }
    }else{//买家
        if (self.orderModel.order.payStatus == 0) {
            if (self.orderModel.order.isDeliver == 0) {
                self.mark.text = NSLocalizedString(@"待发货", nil);
                [self.butto_bgView setHidden:YES];
            }else if(self.orderModel.order.isDeliver == 1){
                self.mark.text = NSLocalizedString(@"发货中", nil);
                self.button2Layout.constant = 0;
                [self.button1 setTitle:NSLocalizedString(@"确认收货", nil) forState:UIControlStateNormal];
            }else if(self.orderModel.order.isDeliver == 2){
                self.mark.text = NSLocalizedString(@"交易完成", nil);
                [self.butto_bgView setHidden:YES];
            }
        }else if (self.orderModel.order.payStatus == 1){
            self.mark.text = NSLocalizedString(@"入账中", nil);
            [self.butto_bgView setHidden:YES];
        }else if (self.orderModel.order.payStatus == 2){
            self.mark.text = NSLocalizedString(@"支付失败", nil);
            [self.butto_bgView setHidden:YES];
        }else if (self.orderModel.order.payStatus == 3){
            self.mark.text = NSLocalizedString(@"退款中", nil);
            [self.butto_bgView setHidden:YES];
        }else if (self.orderModel.order.payStatus == 4){
            self.mark.text = NSLocalizedString(@"已退款", nil);
            [self.butto_bgView setHidden:YES];
        }else if (self.orderModel.order.payStatus == 5){
            self.mark.text = NSLocalizedString(@"退款失败", nil);
            [self.butto_bgView setHidden:YES];
        }else if (self.orderModel.order.payStatus == 6){
            self.mark.text = NSLocalizedString(@"取消订单", nil);
            [self.butto_bgView setHidden:YES];
        }else if (self.orderModel.order.payStatus == 7){
            self.mark.text = NSLocalizedString(@"待支付", nil);
            [self.button1 setTitle:NSLocalizedString(@"去支付", nil) forState:UIControlStateNormal];
            [self.button2 setTitle:NSLocalizedString(@"取消订单", nil) forState:UIControlStateNormal];

        }
    }
    
    
}

- (IBAction)button1Click:(id)sender {
    
    if (self.isManagement) {//卖家
        if (self.orderModel.order.payStatus == 0) {
            if (self.orderModel.order.isDeliver == 0) {
                [self appStoreOrder_merConfirm:self.orderModel.order.orderId];
            }
        }else if (self.orderModel.order.payStatus == 1){
            if ([self.orderModel.order.pay intValue] != 1) {
                [self usdtCollectionSuccessful:self.orderModel.order.orderId];
            }
        }
    }else{//买家
        if (self.orderModel.order.payStatus == 0) {
            if(self.orderModel.order.isDeliver == 1){
                [self buyerConfirm:self.orderModel.order.orderId];
            }else if(self.orderModel.order.isDeliver == 2){
                //退款
            }
        }else if (self.orderModel.order.payStatus == 1){
            [self inputPassWorldSubmit:self.orderModel.order.orderId];
        }else if (self.orderModel.order.payStatus == 2){
            [self inputPassWorldSubmit:self.orderModel.order.orderId];
        }else if (self.orderModel.order.payStatus == 7){
            [self inputPassWorldSubmit:self.orderModel.order.orderId];
        }
        
    }
    
}
- (IBAction)button2Click:(id)sender {
    if (self.isManagement) {//卖家
        
    }else{//买家
        if (self.orderModel.order.payStatus == 0) {
            if (self.orderModel.order.isDeliver == 0) {
                [self appStoreOrderRefund_startRefund:self.orderModel.order.orderId];
            }else if(self.orderModel.order.isDeliver == 2){
                if(self.orderModel.order.refund == 1){
                    [self appStoreOrderRefund_startRefund:self.orderModel.order.orderId];
                }
            }
        }else if (self.orderModel.order.payStatus == 1){
            [self delOrder:self.orderModel.order.orderId];
        }else if (self.orderModel.order.payStatus == 2){
            [self delOrder:self.orderModel.order.orderId];
        }else if (self.orderModel.order.payStatus == 7){
            [self delOrder:self.orderModel.order.orderId];
        }
        
    }
}

- (void)appStoreOrder_merConfirm:(NSString *)orderId{
    WEAKSELF
    self.dialogView =
    [[XFDialogInput dialogWithTitle:NSLocalizedString(@"请输入快递单号", nil)
                                 attrs:@{
                                         XFDialogTitleViewBackgroundColor : [UIColor orangeColor],
                                         XFDialogTitleColor: [UIColor whiteColor],
                                         XFDialogLineColor: [UIColor orangeColor],
                                         XFDialogInputFields:@[
                                                 @{
                                                     XFDialogInputPlaceholderKey : NSLocalizedString(@"请输入物流快递公司名称", nil),
                                                     XFDialogInputTypeKey : @(UIKeyboardTypeDefault),
                                                     XFDialogInputIsPasswordKey : @(NO),
                                                     XFDialogInputPasswordEye : @{
                                                             XFDialogInputEyeOpenImage : @"ic_eye",
                                                             XFDialogInputEyeCloseImage : @"ic_eye_close"
                                                             }
                                                     },
                                                     @{
                                                     XFDialogInputPlaceholderKey : NSLocalizedString(@"请输入快递单号", nil),
                                                     XFDialogInputTypeKey : @(UIKeyboardTypeDefault),
                                                     XFDialogInputIsPasswordKey : @(NO),
                                                     XFDialogInputPasswordEye : @{
                                                             XFDialogInputEyeOpenImage : @"ic_eye",
                                                             XFDialogInputEyeCloseImage : @"ic_eye_close"
                                                             }
                                                     }
                                                 ],
                                         XFDialogInputHintColor : [UIColor purpleColor],
                                         XFDialogInputTextColor: [UIColor orangeColor],
                                         XFDialogCommitButtonTitleColor: [UIColor orangeColor]
                                         }
                        commitCallBack:^(NSString *inputText) {
                            NSArray *array = (NSArray*)inputText;

        [[MGPHttpRequest shareManager]post:@"/appStoreOrder/merConfirm" paramters:@{@"address":[MGPHttpRequest shareManager].curretWallet.address,@"orderId":orderId,@"company":array.firstObject,@"num":array.lastObject} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
                                [weakSelf.dialogView hideWithAnimationBlock:nil];

                                if ([responseObj[@"code"]intValue] == 0) {
                                    !_collectionBlock ? : _collectionBlock();
  
                                }
                            }];
                            
        
        
                        } errorCallBack:^(NSString *errorMessage) {
                            NSLog(@"error -- %@",errorMessage);
                            
                        }] showWithAnimationBlock:nil];
    
    
    
}

- (void)inputPassWorldSubmit:(NSString *)orderId{
    if ([self.orderModel.order.pay intValue] == 1) {
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
            
                                //解密钱包私钥
                                if(![[MGPHttpRequest shareManager].curretWallet.privateKey isValidBitcoinPrivateKey]){
                                    NSString *depri = [AESCrypt decrypt:[MGPHttpRequest shareManager].curretWallet.privateKey password:pwd];
                                        if (depri != nil && ![depri isEqualToString:@""]) {
                                            [MGPHttpRequest shareManager].curretWallet.privateKey = depri;
                                            [self transferMGP];
                                        }
                                    }else{
                                        [self transferMGP];
                                    }
                            } errorCallBack:^(NSString *errorMessage) {
                                NSLog(@"error -- %@",errorMessage);
                                
                            }] showWithAnimationBlock:nil];
    }else if ([self.orderModel.order.pay intValue] == 2){
        
        UIStoryboard* secondStoryboard = [UIStoryboard storyboardWithName:@"ExchangeHome" bundle:[NSBundle mainBundle]];
        OperationProcessTableViewController *secondNavigationController = [secondStoryboard instantiateViewControllerWithIdentifier:@"OperationProcessTableViewController"];
        secondNavigationController.usdtAdd = self.orderModel.order.usdtAddr;
        secondNavigationController.orderId = self.orderModel.order.orderId;
        secondNavigationController.num = self.orderModel.order.payMgp;
        secondNavigationController.transferType = transferHMIO_USDT;
        [[[MGPHttpRequest shareManager]jsd_findVisibleViewController].navigationController pushViewController:secondNavigationController animated:YES];;
        
        
    }
    
}


- (void)buyerConfirm:(NSString *)orderId{
   WEAKSELF
   self.dialogView = [[XFDialogNotice dialogWithTitle:NSLocalizedString(@"温馨提示", nil)
            attrs:@{
                    XFDialogMaskViewAlpha:@(0.f),
                    XFDialogEnableBlurEffect:@YES,
                    XFDialogTitleColor: [UIColor blackColor],
//                    XFDialogCommitButtonCancelDisable:@YES, // 禁用取消按钮
                    XFDialogNoticeText: NSLocalizedString(@"确认您已收到货", nil),
                    }
   commitCallBack:^(NSString *inputText) {
       [weakSelf.dialogView hideWithAnimationBlock:nil];
       [[MGPHttpRequest shareManager]post:@"/appStoreOrder/buyerConfirm" paramters:@{@"address":[MGPHttpRequest shareManager].curretWallet.address,@"orderId":orderId} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
           [weakSelf.dialogView hideWithAnimationBlock:nil];

           if ([responseObj[@"code"]intValue] == 0) {
               !_collectionBlock ? : _collectionBlock();
               
           }
       }];
       
   }] showWithAnimationBlock:nil];
    
    
}


- (void)delOrder:(NSString *)orderId{
    WEAKSELF
    self.dialogView = [[XFDialogNotice dialogWithTitle:NSLocalizedString(@"温馨提示", nil)
             attrs:@{
                     XFDialogMaskViewAlpha:@(0.f),
                     XFDialogEnableBlurEffect:@YES,
                     XFDialogTitleColor: [UIColor blackColor],
//                     XFDialogCommitButtonCancelDisable:@YES, // 禁用取消按钮
                     XFDialogNoticeText: NSLocalizedString(@"您确定要取消订单?", nil),
                     }
    commitCallBack:^(NSString *inputText) {
        [weakSelf.dialogView hideWithAnimationBlock:nil];
        [[MGPHttpRequest shareManager]post:@"/appStoreOrder/delOrder" paramters:@{@"address":[MGPHttpRequest shareManager].curretWallet.address,@"orderId":orderId} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
            [weakSelf.dialogView hideWithAnimationBlock:nil];

            if ([responseObj[@"code"]intValue] == 0) {
                !_collectionBlock ? : _collectionBlock();
            }
        }];
        
    }] showWithAnimationBlock:nil];
    
}

- (void)appStoreOrderRefund_startRefund:(NSString *)orderId{
    WEAKSELF
    self.dialogView =
    [[XFDialogInput dialogWithTitle:NSLocalizedString(@"您确定要发起退款?", nil)
                                 attrs:@{
                                         XFDialogTitleViewBackgroundColor : [UIColor orangeColor],
                                         XFDialogTitleColor: [UIColor whiteColor],
                                         XFDialogLineColor: [UIColor orangeColor],
                                         XFDialogInputFields:@[
                                                 @{
                                                     XFDialogInputPlaceholderKey : NSLocalizedString(@"请输入退款原因", nil),
                                                     XFDialogInputTypeKey : @(UIKeyboardTypeDefault),
                                                     },
                                                 ],
                                         XFDialogInputHintColor : [UIColor purpleColor],
                                         XFDialogInputTextColor: [UIColor orangeColor],
                                         XFDialogCommitButtonTitleColor: [UIColor orangeColor]
                                         }
                        commitCallBack:^(NSString *inputText) {
                            NSArray *array = (NSArray*)inputText;
        
                            NSDictionary *dic = @{
                                @"address":[MGPHttpRequest shareManager].curretWallet.address,
                                @"orderId":orderId,
                                @"money":[NSString stringWithFormat:@"%ld",self.orderModel.pro.price],
                                @"mark":@"退款原因",
                                @"msg":array.firstObject,
                                @"image":@"image",
                            };
        
        [[MGPHttpRequest shareManager]post:@"/appStoreOrderRefund/startRefund" paramters:dic completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
                                [weakSelf.dialogView hideWithAnimationBlock:nil];

                                if ([responseObj[@"code"]intValue] == 0) {
                                    !_collectionBlock ? : _collectionBlock();
                                }
                            }];
                            
        
                        } errorCallBack:^(NSString *errorMessage) {
                            NSLog(@"error -- %@",errorMessage);
                            
                        }] showWithAnimationBlock:nil];
    
}

- (void)usdtCollectionSuccessful:(NSString *)orderId{
   WEAKSELF
   self.dialogView = [[XFDialogNotice dialogWithTitle:NSLocalizedString(@"温馨提示", nil)
            attrs:@{
                    XFDialogMaskViewAlpha:@(0.f),
                    XFDialogEnableBlurEffect:@YES,
                    XFDialogTitleColor: [UIColor blackColor],
                    XFDialogNoticeText: NSLocalizedString(@"确认您的USDT已收款", nil),
                    }
   commitCallBack:^(NSString *inputText) {
       [weakSelf.dialogView hideWithAnimationBlock:nil];
       [[MGPHttpRequest shareManager]post:@"/appStoreOrder/confirm" paramters:@{@"address":[MGPHttpRequest shareManager].curretWallet.address,@"orderId":orderId} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
           [weakSelf.dialogView hideWithAnimationBlock:nil];

           if ([responseObj[@"code"]intValue] == 0) {
               !_collectionBlock ? : _collectionBlock();
               
           }
       }];
       
   }] showWithAnimationBlock:nil];
    
    
}



- (void)transferMGP{
    MJWeakSelf
    [self getJson:[self getAbiJsonToBinParamters] Binargs:^(id response) {
        if ([response isKindOfClass:[NSDictionary class]]) {
            NSDictionary *d = (NSDictionary *)response;
            weakSelf.binargs = [d objectForKey:@"binargs"];
            
            [weakSelf getInfoSuccess:^(id response) {
                BlockChain *model = [BlockChain parse:response];// [@"data"]
                weakSelf.expiration = [[[NSDate dateFromString: model.head_block_time] dateByAddingTimeInterval: 30] formatterToISO8601];
                weakSelf.ref_block_num = [NSString stringWithFormat:@"%@",model.head_block_num];
                
                NSString *js = @"function readUint32( tid, data, offset ){var hexNum= data.substring(2*offset+6,2*offset+8)+data.substring(2*offset+4,2*offset+6)+data.substring(2*offset+2,2*offset+4)+data.substring(2*offset,2*offset+2);var ret = parseInt(hexNum,16).toString(10);return(ret)}";
                [weakSelf.context evaluateScript:js];
                JSValue *n = [weakSelf.context[@"readUint32"] callWithArguments:@[@8,VALIDATE_STRING(model.head_block_id) , @8]];
                weakSelf.ref_block_prefix = [n toString];
                weakSelf.chain_Id = [NSData convertHexStrToData:model.chain_id];
                NSLog(@"get_block_info_success:%@, %@---%@-%@", weakSelf.expiration , weakSelf.ref_block_num, weakSelf.ref_block_prefix, weakSelf.chain_Id);
                
                [weakSelf getRequiredPublicKeyRequestOperationSuccess:^(id response) {
                    if ([response isKindOfClass:[NSDictionary class]]) {
                        weakSelf.required_Publickey = response[@"required_keys"][0];
                        [weakSelf pushTransactionRequestOperationSuccess:^(id response) {

                            if ([response isKindOfClass:[NSDictionary class]]) {
                                NSMutableDictionary *dic;
                                dic = [response mutableCopy];
                                
                                NSDictionary *p = @{
                                    @"address":[MGPHttpRequest shareManager].curretWallet.address,
                                    @"productId":[NSString stringWithFormat:@"%ld",self.orderModel.pro.proID],
                                    @"detailedAddress":self.orderModel.order.appStoreUserDelivery[@"detailedAddress"],
                                    @"userName":self.orderModel.order.appStoreUserDelivery[@"userName"],
                                    @"productNum":[NSString stringWithFormat:@"%ld",self.orderModel.order.totalNum],
                                    @"city":self.orderModel.order.appStoreUserDelivery[@"city"],
                                    @"productPrice":[NSString stringWithFormat:@"%ld",self.orderModel.pro.price],
                                    @"totalPostage":[NSString stringWithFormat:@"%ld",self.orderModel.pro.postage],
                                    @"mark":@"",
                                    @"phone":self.orderModel.order.appStoreUserDelivery[@"phone"],
                                    @"payMgp":self.orderModel.order.payMgp,
                                    @"mgpPrice":self.orderModel.order.mgpPrice,
                                    @"hash":dic[@"transaction_id"],
                                    @"orderId":self.orderModel.order.orderId
                                };
         
                                [[MGPHttpRequest shareManager]post:@"/appStoreOrder/buyOrder" paramters:p completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {

                                    if ([responseObj[@"code"]intValue] == 0) {
                                        !weakSelf.collectionBlock ? : weakSelf.collectionBlock();
                                        
                                    }
                                }];
                                
                                
                            }
                        }];
                    }
                }];
            }];
        }
    }];
}


#pragma bin_to_json
-(void)getBinToJson:(NSString *)datastring Handler:(void(^)(id response))handler{
    //NSString *from = self.addressView.fromAddressTextField.text;
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject: @"eosio" forKey:@"code"];
    [params setObject:@"sign" forKey:@"action"];
    [params setObject:datastring forKey:@"binargs"];
    HTTPRequestManager *manager = self.wallet.coinType == EOS ? [HTTPRequestManager shareEosManager] : [HTTPRequestManager shareMgpManager];

    [manager post:eos_abi_bin_to_json paramters:params success:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            handler(responseObject);
        }
    } failure:^(NSError *error) {
        
    } superView:nil showFaliureDescription:YES];
    
    
}

#pragma mark - 获取行动代码

- (void)getJson:(NSDictionary *)dic Binargs:(void(^)(id response))handler {
    HTTPRequestManager *manager = self.wallet.coinType == EOS ? [HTTPRequestManager shareEosManager] : [HTTPRequestManager shareMgpManager];

    [manager post:eos_abi_json_to_bin paramters:dic success:^(BOOL isSuccess, id responseObject) {
        
        if (isSuccess) {
            handler(responseObject);
        }
    } failure:^(NSError *error) {
        handler(nil);
    } superView:nil showFaliureDescription:YES];
    
}

#pragma mark - 获取帐号信息
- (void)getAccountSuccess:(void(^)(id response))handler {
    NSString *account = [self.wallet.walletName componentsSeparatedByString:@"_"].lastObject;
    NSDictionary *dic = @{@"account_name":account};
    HTTPRequestManager *manager = self.wallet.coinType == EOS ? [HTTPRequestManager shareEosManager] : [HTTPRequestManager shareMgpManager];

    [manager post:eos_get_account paramters:dic success:^(BOOL isSuccess, id responseObject) {
        
        if (isSuccess) {
            handler(responseObject);
            
        }
    } failure:^(NSError *error) {
        handler(nil);
        NSLog(@"URL_GET_INFO_ERROR ==== %@",error.description);
    } superView:nil showFaliureDescription:YES];
}


#pragma mark - 获取最新区块

- (void)getInfoSuccess:(void(^)(id response))handler {
    HTTPRequestManager *manager = self.wallet.coinType == EOS ? [HTTPRequestManager shareEosManager] : [HTTPRequestManager shareMgpManager];
    [manager post:eos_get_info paramters:nil success:^(BOOL isSuccess, id responseObject) {
        
        if (isSuccess) {
            handler(responseObject);
        }
    } failure:^(NSError *error) {
        handler(nil);
        NSLog(@"URL_GET_INFO_ERROR ==== %@",error.description);
    } superView:nil showFaliureDescription:YES];
    
}

#pragma mark - 获取公钥

- (void)getRequiredPublicKeyRequestOperationSuccess:(void(^)(id response))handler {
    NSLog(@"URL_GET_REQUIRED_KEYS parameters ============ %@",[[self getPramatersForRequiredKeys] modelToJSONString]);
    HTTPRequestManager *manager = self.wallet.coinType == EOS ? [HTTPRequestManager shareEosManager] : [HTTPRequestManager shareMgpManager];

    [manager post:eos_get_required_keys paramters:[self getPramatersForRequiredKeys] success:^(BOOL isSuccess, id responseObject) {
        
        if (isSuccess) {
            handler(responseObject);
        }
    } failure:^(NSError *error) {
        handler(nil);
        NSLog(@"URL_GET_REQUIRED_KEYS ==== %@",error.description);
    } superView:nil showFaliureDescription:YES];
    
    
}
#pragma mark -----df

- (void)pushTransactionRequestOperationSuccess:(void(^)(id response))handler {
    
    // NSDictionary *transacDic = [self getPramatersForRequiredKeys];
    NSString *wif = self.wallet.privateKey;
    const int8_t *private_key = [[EosEncode getRandomBytesDataWithWif:wif] bytes];
    if (!private_key) {
        return;
    }
    if (![self.wallet.publicKey isEqualToString:self.required_Publickey] && self.wallet.coinType == MIS) {
//        [self.view showMsg:NSLocalizedString(@"EOS公钥不匹配！", nil)];
    }
    NSString *signatureStr = @"";
    NSString *packed_trxHexStr = @"";
    
    NSData *d = [EosByteWriter getBytesForSignature:self.chain_Id andParams:[[self getPramatersForRequiredKeys] objectForKey:@"transaction"] andCapacity:255];
    signatureStr = [EosSignature initWithbytesForSignature:d privateKey:(int8_t *)private_key];
    packed_trxHexStr = [[EosByteWriter getBytesForSignature:nil andParams:[[self getPramatersForRequiredKeys] objectForKey:@"transaction"] andCapacity:512] hexadecimalString];
    
    
    NSMutableDictionary *pushDic = [NSMutableDictionary dictionary];
    [pushDic setObject:VALIDATE_STRING(packed_trxHexStr) forKey:@"packed_trx"];
    [pushDic setObject:@[signatureStr] forKey:@"signatures"];
    [pushDic setObject:@"none" forKey:@"compression"];
    [pushDic setObject:@"" forKey:@"packed_context_free_data"];
    NSLog(@"push = \n%@",pushDic);
    MJWeakSelf
    HTTPRequestManager *manager = self.wallet.coinType == EOS ? [HTTPRequestManager shareEosManager] : [HTTPRequestManager shareMgpManager];

    [manager post:eos_push_transaction paramters:pushDic success:^(BOOL isSuccess, id responseObject) {
        NSLog(@"tran response %@",responseObject);
        if (isSuccess) {
            handler(responseObject);
            
        }
    } failure:^(NSError *error) {
        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
        NSLog(@"error--%@",serializedData);
        NSDictionary *err = [serializedData objectForKey:@"error"];
        NSArray *detail = [err objectForKey:@"details"];
        NSString *mesg = [[detail[0] objectForKey:@"message"] copy];
//        [weakSelf.view showAlert:@"Error" DetailMsg:mesg];
    } superView:nil showFaliureDescription:YES];
    
    
    
}


- (NSDictionary *)getPramatersForRequiredKeys {
    NSString *from = self.wallet.address;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *transacDic = [NSMutableDictionary dictionary];
    [transacDic setObject:VALIDATE_STRING(self.ref_block_prefix) forKey:@"ref_block_prefix"];
    [transacDic setObject:VALIDATE_STRING(self.ref_block_num) forKey:@"ref_block_num"];
    [transacDic setObject:VALIDATE_STRING(self.expiration) forKey:@"expiration"];
    
    [transacDic setObject:@[] forKey:@"context_free_data"];
    [transacDic setObject:@[] forKey:@"signatures"];
    [transacDic setObject:@[] forKey:@"context_free_actions"];
    [transacDic setObject:@0 forKey:@"delay_sec"];
    [transacDic setObject:@0 forKey:@"max_cpu_usage_ms"];//max_cpu_usage_ms  max_kcpu_usage
    [transacDic setObject:@0 forKey:@"max_net_usage_words"];
    
    
    NSMutableDictionary *actionDict = [NSMutableDictionary dictionary];
    [actionDict setObject:@"eosio.token" forKey:@"account"];
    [actionDict setObject:@"transfer" forKey:@"name"];
    [actionDict setObject:VALIDATE_STRING(self.binargs) forKey:@"data"];
    
    NSMutableDictionary *authorizationDict = [NSMutableDictionary dictionary];
    [authorizationDict setObject:from forKey:@"actor"];
    [authorizationDict setObject:@"active" forKey:@"permission"];
    [actionDict setObject:@[authorizationDict] forKey:@"authorization"];
    [transacDic setObject:@[actionDict] forKey:@"actions"];
    
    [params setObject:transacDic forKey:@"transaction"];
    
    [params setObject:@[self.wallet.publicKey] forKey:@"available_keys"];
    return params;
    
}
#pragma mark - Get Paramter

- (NSDictionary *)getAbiJsonToBinParamters {
    NSString *amount = self.orderModel.order.payMgp;
    NSString *from = self.wallet.address;
    NSString *to = @"mgpchainshop";
    NSDictionary *dic = @{@"orderSn":self.orderModel.order.orderId,
                          @"currencyPrice":self.orderModel.order.mgpPrice,
                          @"dollar":self.orderModel.order.payMgp
    };

    NSString *memo = [self convertToJsonData:dic];
    // 交易JSON序列化
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject: @"eosio.token" forKey:@"code"];
    [params setObject:@"transfer" forKey:@"action"];
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    [args setObject:VALIDATE_STRING(from) forKey:@"from"];
    [args setObject:VALIDATE_STRING(to) forKey:@"to"];
    [args setObject:VALIDATE_STRING(memo) forKey:@"memo"];//备注
    [args setObject:[NSString stringWithFormat:@"%.4f MGP", amount.doubleValue] forKey:@"quantity"];
    
    [params setObject:args forKey:@"args"];
    
    return params;
}

#pragma mark - getter

- (JSContext *)context {
    if (!_context) {
        _context = [[JSContext alloc] init];
    }
    return _context;
}

-(NSString *)convertToJsonData:(NSDictionary *)dict

{

    NSError *error;


    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];

    NSString *jsonString;

    if (!jsonData) {

        NSLog(@"%@",error);

    }else{

        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];

    }

    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];

    NSRange range = {0,jsonString.length};

    //去掉字符串中的空格

    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];

    NSRange range2 = {0,mutStr.length};

    //去掉字符串中的换行符

    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];

    return mutStr;

}

@end
