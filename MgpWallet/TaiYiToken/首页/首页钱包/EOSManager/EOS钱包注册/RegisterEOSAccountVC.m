//
//  RegisterEOSAccountVC.m
//  TaiYiToken
//
//  Created by 张元一 on 2018/12/18.
//  Copyright © 2018 admin. All rights reserved.
//

#import "RegisterEOSAccountVC.h"

@interface RegisterEOSAccountVC ()<UIScrollViewDelegate,UITextFieldDelegate>
@property(nonatomic,strong)UILabel *titlelabel;
@property(nonatomic,strong)UIButton *backBtn;
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIView *bridgeContentView;

@property(nonatomic,copy)NSString *accountName;

@property(nonatomic,strong)UILabel *remindLabel;
@property(nonatomic,strong)UIView *registerAccountView;
@property(nonatomic,strong)UIImageView *QRCodeImageView;
@property(nonatomic,strong)UIImage *qrcode;
@property(nonatomic,strong)UITextField *accountTextField;
@property(nonatomic,strong)UILabel *ownerLabel;
@property(nonatomic,strong)UILabel *activeLabel;
@property(nonatomic,strong)UIButton *shareBtn;

@property(nonatomic,strong)UIView *selectAccountView;

@end

@implementation RegisterEOSAccountVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
//    self.navigationController.navigationBar.hidden = YES;
//    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
//    self.navigationController.hidesBottomBarWhenPushed = YES;
//    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
//    self.tabBarController.tabBar.hidden = NO;
//    self.navigationController.navigationBar.hidden = NO;
//    self.navigationController.hidesBottomBarWhenPushed = NO;
}
- (void)popAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self scrollView];
    [self registerAccountView];
    self.remindLabel.text = self.wallet.coinType == EOS ? NSLocalizedString(@"EOS账户名称为a-z与1-5组合的12位字符", nil) : NSLocalizedString(@"MGP账户名称为a-z与1-5组合的12位字符", nil);
    self.accountTextField.text = self.wallet.address;
    [self textFieldDidEndEditing:self.accountTextField];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)shareAction{
    NSString *account = self.accountTextField.text;
    BOOL verifyaccount = [NSString checkEOSAccount:account];
    if (self.qrcode == nil || verifyaccount == NO) {
        return;
    }
    MJWeakSelf
    [self getAccountSuccess:^(id response) {
        NSMutableDictionary *dic = response;
        if (!dic) {
            NSArray *activityItemsArray = @[weakSelf.qrcode];
            
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
            
            [weakSelf presentViewController:activityVC animated:YES completion:nil];
            
        }else{
            [weakSelf.view showMsg:NSLocalizedString(@"账户名已存在", nil)];
        }
    }];
    
   
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL isAllowEdit = YES;
    if([string length]>range.length&&[textField.text length]+[string length]-range.length>12)
    {
        [textField resignFirstResponder];
        isAllowEdit = NO;
    }
    return isAllowEdit;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
{
    if (textField.text.length == 12){
        NSString *account = textField.text;
            BOOL verifyaccount = [NSString checkEOSAccount:account];
            if (verifyaccount == NO) {
                self.remindLabel.text = self.wallet.coinType == EOS ? NSLocalizedString(@"EOS账户名称为a-z与1-5组合的12位字符", nil) : NSLocalizedString(@"MGP账户名称为a-z与1-5组合的12位字符", nil);
                self.QRCodeImageView.image = [UIImage imageNamed:@""];
                [self.view showMsg:self.remindLabel.text];

            }else{
                [self.view showHUD];
                MJWeakSelf
                [self getAccountSuccess:^(id response) {
                    NSMutableDictionary *dic = response;
                    [self.view hideHUD];
                    if (!dic) {
                        self.remindLabel.text = @"";
                        self.accountName = account;
                        NSString *name = [self.wallet.walletName componentsSeparatedByString:@"_"].firstObject;
                        NSDictionary *dic = @{
                            @"account":VALIDATE_STRING(self.accountName),
                            @"owner":VALIDATE_STRING(self.wallet.publicKey),
                            @"active":VALIDATE_STRING(self.wallet.publicKey),
                            @"type":@"3",
                            @"blockchain":self.wallet.coinType == MGP ? @"MGP" : @"EOS",
                            
                        };
                        NSString *qrcodeStr = [self convertToJsonData:dic];
                        self.qrcode = [CreateAll CreateQRCodeForAddress:qrcodeStr];
                        self.QRCodeImageView.image = _qrcode;
                                            
                    }else{
                        self.remindLabel.text = NSLocalizedString(@"账户名已存在", nil);
                        [weakSelf.view showMsg:self.remindLabel.text];
                    }
                }];
            }
    }else{
        NSString *msg = self.wallet.coinType == EOS ? NSLocalizedString(@"EOS账户名称为a-z与1-5组合的12位字符", nil) : NSLocalizedString(@"MGP账户名称为a-z与1-5组合的12位字符", nil);
        [self.view showMsg:msg];
    }
    }
    
}
-(void)textFieldTextChange:(UITextField *)textField{

    if (textField.text.length > 0 && textField.text.length != 12) {
        self.remindLabel.text = self.wallet.coinType == EOS ? NSLocalizedString(@"EOS账户名称为a-z与1-5组合的12位字符", nil) : NSLocalizedString(@"MGP账户名称为a-z与1-5组合的12位字符", nil);
        self.QRCodeImageView.image = [UIImage imageNamed:@""];

    }
    
}


#pragma lazy
-(UIView *)registerAccountView{
    if (!_registerAccountView) {
        _registerAccountView = [UIView new];
        _registerAccountView.backgroundColor = [UIColor whiteColor];
        [self.bridgeContentView addSubview:_registerAccountView];
        [_registerAccountView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(0);
            make.left.right.bottom.equalTo(0);
        }];

        NSString *name = [self.wallet.walletName componentsSeparatedByString:@"_"].firstObject;
        NSDictionary *dic = @{
            @"account":VALIDATE_STRING(self.accountName),
            @"owner":VALIDATE_STRING(self.wallet.publicKey),
            @"active":VALIDATE_STRING(self.wallet.publicKey),
            @"type":@"3",
            @"blockchain":self.wallet.coinType == MGP ? @"MGP" : @"EOS",
            
        };
        NSString *qrcodeStr = [self convertToJsonData:dic];
//        NSString *qrcodeStr = [NSString stringWithFormat:@"%@:new_eos_account-?accountName=%@&activeKey=%@&ownerKey=%@",VALIDATE_STRING(name),VALIDATE_STRING(self.accountName),VALIDATE_STRING(self.wallet.publicKey),VALIDATE_STRING(self.wallet.publicKey)];
        self.qrcode = [CreateAll CreateQRCodeForAddress:qrcodeStr];
        self.QRCodeImageView = [UIImageView new];
//        self.QRCodeImageView.image = _qrcode;
        [self.registerAccountView addSubview:_QRCodeImageView];
        [_QRCodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.top.equalTo(10);
            make.width.height.equalTo(150);
        }];
        
        UILabel *namelb = [UILabel new];
        namelb.font = [UIFont boldSystemFontOfSize:14];
        namelb.textColor = [UIColor textBlackColor];
        [namelb setText:NSLocalizedString(@"账户名", nil)];
        namelb.textAlignment = NSTextAlignmentLeft;
        [self.registerAccountView addSubview:namelb];
        [namelb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.QRCodeImageView.mas_bottom).equalTo(30);
            make.left.equalTo(16);
            make.right.equalTo(-16);
            make.height.equalTo(20);
        }];
        
        _accountTextField = [UITextField new];
        _accountTextField.placeholder = self.wallet.coinType == EOS ? NSLocalizedString(@"EOS账户名称为a-z与1-5组合的12位字符", nil) : NSLocalizedString(@"MGP账户名称为a-z与1-5组合的12位字符", nil);
        _accountTextField.backgroundColor = [UIColor whiteColor];
        _accountTextField.textAlignment = NSTextAlignmentLeft;
        _accountTextField.textColor = [UIColor textBlackColor];
        _accountTextField.font = [UIFont systemFontOfSize:13];
        [_accountTextField addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
        [_accountTextField addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
        _accountTextField.delegate = self;
        [self.registerAccountView addSubview:_accountTextField];
        [_accountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(namelb.mas_bottom).equalTo(5);
            make.left.equalTo(16);
            make.right.equalTo(-16);
            make.height.equalTo(20);
        }];
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = RGBACOLOR(224, 224, 224, 1);
        [self.registerAccountView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.accountTextField.mas_bottom).equalTo(10);
            make.left.equalTo(16);
            make.right.equalTo(-16);
            make.height.equalTo(1);
        }];
        
        _remindLabel = [UILabel new];
        _remindLabel.font = [UIFont boldSystemFontOfSize:13];
        _remindLabel.textColor = [UIColor redColor];
        _remindLabel.textAlignment = NSTextAlignmentLeft;
        [self.registerAccountView addSubview:_remindLabel];
        [_remindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lineView.mas_bottom).equalTo(5);
            make.left.equalTo(16);
            make.right.equalTo(-16);
            make.height.equalTo(15);
        }];
        
        UILabel *ownerlb = [UILabel new];
        ownerlb.font = [UIFont boldSystemFontOfSize:13];
        ownerlb.textColor = [UIColor textBlackColor];
        [ownerlb setText:NSLocalizedString(@"owner公钥", nil)];
        ownerlb.textAlignment = NSTextAlignmentLeft;
        [self.registerAccountView addSubview:ownerlb];
        [ownerlb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.remindLabel.mas_bottom).equalTo(10);
            make.left.equalTo(16);
            make.right.equalTo(-16);
            make.height.equalTo(20);
        }];
        
        UILabel *ownerpublb = [UILabel new];
        ownerpublb.font = [UIFont systemFontOfSize:14];
        ownerpublb.textColor = [UIColor lightGrayColor];
        ownerpublb.numberOfLines = 0;
        [ownerpublb setText:self.wallet.publicKey];
        ownerpublb.textAlignment = NSTextAlignmentLeft;
        [self.registerAccountView addSubview:ownerpublb];
        [ownerpublb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ownerlb.mas_bottom).equalTo(5);
            make.left.equalTo(16);
            make.right.equalTo(-16);
            make.height.equalTo(35);
        }];
        
        UILabel *activelb = [UILabel new];
        activelb.font = [UIFont boldSystemFontOfSize:13];
        activelb.textColor = [UIColor textBlackColor];
        [activelb setText:NSLocalizedString(@"active公钥", nil)];
        activelb.textAlignment = NSTextAlignmentLeft;
        [self.registerAccountView addSubview:activelb];
        [activelb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ownerpublb.mas_bottom).equalTo(10);
            make.left.equalTo(16);
            make.right.equalTo(-16);
            make.height.equalTo(20);
        }];
        
        UILabel *activepublb = [UILabel new];
        activepublb.font = [UIFont systemFontOfSize:14];
        activepublb.numberOfLines = 0;
        activepublb.textColor = [UIColor lightGrayColor];
        [activepublb setText:self.wallet.publicKey];
        activepublb.textAlignment = NSTextAlignmentLeft;
        [self.registerAccountView addSubview:activepublb];
        [activepublb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(activelb.mas_bottom).equalTo(5);
            make.left.equalTo(16);
            make.right.equalTo(-16);
            make.height.equalTo(35);
        }];
        
        _shareBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _shareBtn.titleLabel.textColor = [UIColor textBlackColor];
        _shareBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _shareBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _shareBtn.layer.cornerRadius = 5;
        _shareBtn.layer.masksToBounds = YES;
        [_shareBtn gradientButtonWithSize:CGSizeMake(ScreenWidth, 44) colorArray:@[[UIColor colorWithHexString:@"#4090F7"],[UIColor colorWithHexString:@"#57A8FF"]] percentageArray:@[@(0.3),@(1)] gradientType:GradientFromLeftTopToRightBottom];
        _shareBtn.tintColor = [UIColor textWhiteColor];
        _shareBtn.userInteractionEnabled = YES;
        [_shareBtn setTitle:NSLocalizedString(@"分享二维码", nil) forState:UIControlStateNormal];
        [_shareBtn addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_shareBtn];
        [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(activepublb.mas_bottom).equalTo(10);
            make.left.equalTo(16);
            make.right.equalTo(-16);
            make.height.equalTo(44);
        }];
    }
    return _registerAccountView;
}

#pragma mark - 获取帐号信息
- (void)getAccountSuccess:(void(^)(id response))handler {
    NSString *account = self.accountTextField.text;
    NSDictionary *dic = @{@"account_name":account};
    HTTPRequestManager *manager = self.wallet.coinType == MGP ? [HTTPRequestManager shareMgpManager] : [HTTPRequestManager shareEosManager];
    [manager post:eos_get_account paramters:dic success:^(BOOL isSuccess, id responseObject) {
        
        if (isSuccess) {
            handler(responseObject);
            
        }
    } failure:^(NSError *error) {
        handler(nil);
        NSLog(@"URL_GET_INFO_ERROR ==== %@",error.description);
    } superView:self.view showFaliureDescription:YES];
}


-(UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.scrollEnabled = YES;
        _scrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight + 100);
        _scrollView.delegate =self;
        _scrollView.scrollsToTop = YES;
        [self.view addSubview:_scrollView];
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.top.equalTo(0);
            make.bottom.equalTo(-SafeAreaBottomHeight);
        }];
        _bridgeContentView = [UIView new];
        _bridgeContentView.backgroundColor = [UIColor ExportBackgroundColor];
        [self.scrollView addSubview:_bridgeContentView];
        [_bridgeContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.scrollView);
            make.width.height.equalTo(self.scrollView.contentSize);
        }];
    }
    
    return _scrollView;
}

// 字典转json字符串方法

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
