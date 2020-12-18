//
//  CreateMnemonicVC.m
//  TaiYiToken
//
//  Created by Frued on 2018/8/20.
//  Copyright © 2018年 Frued. All rights reserved.
//

#import "CreateMnemonicVC.h"
#import "NYMnemonic.h"
#import "RemindView.h"
#import "AppDelegate.h"
#import "CYLMainRootViewController.h"

#import "VerifyMnemonicVC.h"
@interface CreateMnemonicVC ()
@property(nonatomic,strong)UILabel *remindlabel;

@property(nonatomic,strong) UIButton *nextBtn;
@property(nonatomic,strong) UIButton *skipBtn;
@property(nonatomic,copy)NSString *mnemonic;

@end

@implementation CreateMnemonicVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSLocalizedString(@"备份助记词", nil);

    UILabel *remindlabel = [[UILabel alloc] init];
    remindlabel.textColor = [UIColor textGrayColor];
    remindlabel.font = [UIFont systemFontOfSize:14];
    remindlabel.text = [NSString stringWithFormat:@"%@\n\n%@",NSLocalizedString(@"  没有妥善备份就无法保障资产安全。删除程序或钱包后，您需要备份文件恢复钱包。", nil),NSLocalizedString(@"请仔细抄写下方助记词，我们将在下一步验证", nil)];
    
    remindlabel.textAlignment = NSTextAlignmentLeft;
    remindlabel.numberOfLines = 0;
    [self.view addSubview:remindlabel];
    [remindlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(20);
        make.top.equalTo(30);
        make.right.equalTo(-20);
    }];
    self.remindlabel = remindlabel;
    
    [self CreateMnemonic];
  
}
-(void)CreateMnemonic{
    if (self.baseWallet) {
        [CreateAll ExportMnemonicByPassword:[[NSUserDefaults standardUserDefaults]objectForKey:PassWordText]  WalletAddress:self.baseWallet.address callback:^(NSString *mnemonic, NSError *error) {

            if (!error && mnemonic != nil) {
                self.mnemonic = mnemonic;
            }else{
                [self.view showMsg:NSLocalizedString(@"密码错误", nil)];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
        
    }else{
        self.mnemonic = [NYMnemonic generateMnemonicString:@128 language:@"english"];
    }
    UIView *shadowView = [UIView new];
    [self.view addSubview:shadowView];
    [shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(20);
        make.top.equalTo(self.remindlabel.mas_bottom).equalTo(10);
        make.right.equalTo(-20);
        make.height.equalTo(100);
    }];
    
    
    UITextView *mnemonicTextView = [UITextView new];
    mnemonicTextView.textColor = [UIColor textBlackColor];
    mnemonicTextView.font = [UIFont systemFontOfSize:17];
    mnemonicTextView.text = self.mnemonic;
    mnemonicTextView.textAlignment = NSTextAlignmentNatural;
    mnemonicTextView.userInteractionEnabled = NO;
    [shadowView addSubview:mnemonicTextView];
    [mnemonicTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
    mnemonicTextView.layer.borderWidth = 0.5;
    mnemonicTextView.layer.borderColor = [UIColor colorWithRed:237/255.0 green:239/255.0 blue:241/255.0 alpha:1.0].CGColor;
    mnemonicTextView.backgroundColor = RGB(244, 246, 248);
    mnemonicTextView.layer.cornerRadius = 5;
    
    
    _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextBtn.backgroundColor = [UIColor textBlueColor];
    _nextBtn.layer.cornerRadius = 5;
    _nextBtn.layer.masksToBounds = YES;
    [_nextBtn gradientButtonWithSize:CGSizeMake(ScreenWidth, 49) colorArray:@[RGB(150, 160, 240),RGB(170, 170, 240)] percentageArray:@[@(0.3),@(1)] gradientType:GradientFromLeftTopToRightBottom];
    [_nextBtn setTitle:NSLocalizedString(@"下一步", nil) forState:UIControlStateNormal];
    [_nextBtn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextBtn];
    _nextBtn.userInteractionEnabled = YES;
    [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(shadowView.mas_bottom).equalTo(150);
        make.left.mas_equalTo(shadowView.mas_left).equalTo(0);
        make.right.mas_equalTo(shadowView.mas_right).equalTo(0);
        make.height.equalTo(49);
        
    }];
    
    _skipBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _skipBtn.backgroundColor = [UIColor clearColor];
    [_skipBtn setTitleColor:RGB(134, 134, 134) forState:UIControlStateNormal];
    [_skipBtn setTitle:NSLocalizedString(@"跳过", nil) forState:UIControlStateNormal];
    [_skipBtn addTarget:self action:@selector(skipAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_skipBtn];
    _skipBtn.userInteractionEnabled = YES;
    [_skipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_nextBtn.mas_bottom).equalTo(0);
        make.left.mas_equalTo(_nextBtn.mas_left).equalTo(0);
        make.right.mas_equalTo(_nextBtn.mas_right).equalTo(0);
        make.height.mas_equalTo(_nextBtn.mas_height).equalTo(0);
    }];
    
    
    
    
    NSLog(@"%@---",self.mnemonic);
}
-(void)nextAction{
    VerifyMnemonicVC *vmvc = [VerifyMnemonicVC new];
    vmvc.mnemonic = self.mnemonic;
    vmvc.password = self.password;
    vmvc.coinType = self.coinType;
    vmvc.baseWallet = self.baseWallet;
    [self.navigationController pushViewController:vmvc animated:YES];
}
-(void)skipAction{
    if (self.baseWallet) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.view showHUD];
        NSString *addressName = [[NSUserDefaults standardUserDefaults]objectForKey:AccountName];
        int walletType = self.coinType == NOTDEFAULT ? LOCAL_WALLET : IMPORT_WALLET;
        int importType = self.coinType == NOTDEFAULT ? LOCAL_CREATED_WALLET : IMPORT_BY_MNEMONIC;

        NSString *seed = [CreateAll CreateSeedByMnemonic:self.mnemonic Password:self.password];
        
        [[CreateAccountTool shareManager]CreateWalletSeed:seed PassWord:self.password PassHint:@"" Mnemonic:self.mnemonic isSkip:NO WalletAddressName:addressName WalletType:walletType ImportType:importType CoinType:self.coinType completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
            
            [self.view hideHUD];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:AccountName];
            [[NSUserDefaults standardUserDefaults]synchronize];
            if (error) {
                [self.view showMsg:NSLocalizedString(@"创建出错！", nil)];
            }else{
                [self.view showMsg:NSLocalizedString(@"创建成功！", nil)];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (self.coinType == NOTDEFAULT) {
                        UIWindow *window = ((AppDelegate*)([UIApplication sharedApplication].delegate)).window;
                        CYLMainRootViewController *csVC = [[CYLMainRootViewController alloc] init];
                        window.rootViewController = csVC;
                    }else{
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                });
            }
        }];
    }
    
    
    
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
