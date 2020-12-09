//
//  LHCreateViewController.m
//  TaiYiToken
//
//  Created by mac on 2020/7/16.
//  Copyright © 2020 admin. All rights reserved.
//

#import "LHCreateViewController.h"
#import "RemindView.h"
#import "CreateMnemonicVC.h"

@interface LHCreateViewController ()

@property(nonatomic,strong) JVFloatLabeledTextField *accountTextField;
@property(nonatomic,strong) JVFloatLabeledTextField *passwordTextField;
@property(nonatomic,strong) JVFloatLabeledTextField *repasswordTextField;
@property(nonatomic)UIButton *createBtn;
@property(nonatomic)RemindView *remindView;
@property(nonatomic)UIView *shadowView;
@property(nonatomic)UIView *dimView;

@end

@implementation LHCreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    switch (self.coinType) {
        case ETH:
            self.title = NSLocalizedString(@"创建ETH钱包", nil);
            break;
        case BTC:
        case BTC_TESTNET:
            self.title = NSLocalizedString(@"创建BTC钱包", nil);

            break;
        case EOS:
            self.title = NSLocalizedString(@"创建EOS钱包", nil);

            break;
        case MGP:
            self.title = NSLocalizedString(@"创建MGP钱包", nil);

            break;
        default:
            break;
    }
    
    _accountTextField = [JVFloatLabeledTextField new];
    _accountTextField.borderStyle = UITextBorderStyleNone;
    _accountTextField.attributedPlaceholder =[[NSAttributedString alloc]initWithString: NSLocalizedString(@"钱包名称", nil)];
    _accountTextField.keepBaseline = YES;
    _accountTextField.backgroundColor = [UIColor whiteColor];
    _accountTextField.textAlignment = NSTextAlignmentLeft;
    _accountTextField.textColor = [UIColor lightGrayColor];
    _accountTextField.font = [UIFont systemFontOfSize:16];
    _accountTextField.floatingLabelYPadding = 3;
//    [self.view addSubview:_accountTextField];
//    [_accountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(10);
//        make.height.equalTo(45);
//        make.left.equalTo(17);
//        make.right.equalTo(-16);
//    }];
    
    _passwordTextField = [JVFloatLabeledTextField new];
    _passwordTextField.borderStyle = UITextBorderStyleNone;
    _passwordTextField.attributedPlaceholder =[[NSAttributedString alloc]initWithString: NSLocalizedString(@"密码(8-18位字符)", nil)];
    _passwordTextField.backgroundColor = [UIColor whiteColor];
    _passwordTextField.textAlignment = NSTextAlignmentLeft;
    _passwordTextField.textColor = [UIColor darkGrayColor];
    _passwordTextField.font = [UIFont systemFontOfSize:16];
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.floatingLabelYPadding = 3;
    [self.view addSubview:_passwordTextField];
    [_passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.accountTextField.mas_bottom).equalTo(20);
        make.top.equalTo(10);
        make.height.equalTo(45);
        make.left.equalTo(17);
        make.right.equalTo(-16);
    }];
    
    _repasswordTextField = [JVFloatLabeledTextField new];
    _repasswordTextField.borderStyle = UITextBorderStyleNone;
    _repasswordTextField.attributedPlaceholder =[[NSAttributedString alloc]initWithString: NSLocalizedString(@"请再次输入密码", nil)];
    
    _repasswordTextField.backgroundColor = [UIColor whiteColor];
    _repasswordTextField.textAlignment = NSTextAlignmentLeft;
    _repasswordTextField.textColor = [UIColor darkGrayColor];
    _repasswordTextField.font = [UIFont systemFontOfSize:16];
    _repasswordTextField.secureTextEntry = YES;
    _repasswordTextField.floatingLabelYPadding = 3;
    [self.view addSubview:_repasswordTextField];
    [_repasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.passwordTextField.mas_bottom).equalTo(20);
        make.height.equalTo(45);
        make.left.equalTo(17);
        make.right.equalTo(-16);
    }];
    
    _createBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _createBtn.backgroundColor = [UIColor whiteColor];
    _createBtn.tintColor = [UIColor whiteColor];
    _createBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    _createBtn.layer.cornerRadius = 4;
    _createBtn.clipsToBounds = YES;
    [_createBtn gradientButtonWithSize:CGSizeMake(ScreenWidth - 34, 45) colorArray:@[RGB(150, 160, 240),RGB(170, 170, 240)] percentageArray:@[@(0.3),@(1)] gradientType:GradientFromLeftTopToRightBottom];
    [_createBtn setTitle:NSLocalizedString(@"创建", nil) forState:UIControlStateNormal];
    [_createBtn addTarget:self action:@selector(createAccount) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_createBtn];
    _createBtn.userInteractionEnabled = YES;
    [_createBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(30);
        make.height.equalTo(45);
        make.left.equalTo(17);
        make.right.equalTo(-16);
    }];
    
}
-(void)createAccount{
//    if (([_accountTextField.text isEqualToString:@""])||(_accountTextField.text == nil)) {
//        [self.view showMsg:NSLocalizedString(@"请输入名称！", nil)];
//        return;
//    }
    if (([_passwordTextField.text isEqualToString:@""])||(_passwordTextField.text == nil)) {
        [self.view showMsg:NSLocalizedString(@"请输入密码！", nil)];
        return;
    }
    if(![NSString checkPassword:_passwordTextField.text]){
        [self.view showMsg:NSLocalizedString(@"请输入8-18位字符！", nil)];
        return;
    }
    if (![_repasswordTextField.text isEqualToString:_passwordTextField.text]) {
        [self.view showMsg:NSLocalizedString(@"两次密码输入不一致！", nil)];
        return;
    }
    if (self.passwordTextField.text.length <= 0) {
        [self.view showMsg:NSLocalizedString(@"请输入密码！", nil)];
        return;
    }
    [[NSUserDefaults standardUserDefaults]setObject:_passwordTextField.text forKey:PassWordText];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    _dimView = [UIView new];
    _dimView.backgroundColor = [UIColor grayColor];
    _dimView.alpha =0;
    [self.view addSubview:_dimView];
    [_dimView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
    
    _shadowView = [UIView new];
    _shadowView.layer.shadowColor = [UIColor grayColor].CGColor;
    _shadowView.layer.shadowOffset = CGSizeMake(5, 5);
    _shadowView.layer.shadowOpacity = 1;
    _shadowView.layer.shadowRadius = 5.0;
    _shadowView.layer.cornerRadius = 5.0;
    _shadowView.clipsToBounds = NO;
    _shadowView.alpha = 0;
    [self.view addSubview:_shadowView];
    [_shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(0);
        make.width.equalTo(ScreenWidth-100);
        make.height.equalTo(140);
    }];

    
    _remindView = [RemindView new];
    [_shadowView addSubview:_remindView];
    [_remindView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(0);
    }];
    [_remindView initRemainViewWithTitle:NSLocalizedString(@"备份钱包", nil) message:NSLocalizedString(@"  没有妥善备份就无法保障资产安全。删除程序或钱包后，您需要备份文件恢复钱包。", nil)];
    [_remindView.quitBtn addTarget:self action:@selector(quitRemindView) forControlEvents:UIControlEventTouchUpInside];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.dimView.alpha = 0.5;
        self.shadowView.alpha = 1;
    } completion:^(BOOL finished) {
        [self.view endEditing:YES];
        self.passwordTextField.userInteractionEnabled = NO;
        self.repasswordTextField.userInteractionEnabled = NO;
        self.createBtn.userInteractionEnabled = NO;
    }];
    
}

-(void)quitRemindView{
    
    [UIView animateWithDuration:0.5 animations:^{
        self.dimView.alpha = 0;
        self.shadowView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.shadowView removeFromSuperview];
        [self.remindView removeFromSuperview];
        self.shadowView = nil;
        self.remindView = nil;
        self.passwordTextField.userInteractionEnabled = YES;
        self.repasswordTextField.userInteractionEnabled = YES;
        self.createBtn.userInteractionEnabled = YES;
    }];
    CreateMnemonicVC *cmvc = [CreateMnemonicVC new];
    cmvc.password = self.passwordTextField.text;
    cmvc.coinType = self.coinType;
    [self.navigationController pushViewController:cmvc animated:YES];
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
