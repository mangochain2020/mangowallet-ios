//
//  CreateAccountVC.m
//  TaiYiToken
//
//  Created by Frued on 2018/8/14.
//  Copyright © 2018年 Frued. All rights reserved.
//

#import "CreateAccountVC.h"
#import "UIButton+Gradient.h"
#import "RemindView.h"
#import "CreateMnemonicVC.h"
#import "ImportHDWalletVC.h"

@interface CreateAccountVC ()
@property(nonatomic,strong)UILabel *headlabel;
@property(nonatomic,strong) JVFloatLabeledTextField *accountTextField;
@property(nonatomic,strong) JVFloatLabeledTextField *passwordTextField;
@property(nonatomic,strong) JVFloatLabeledTextField *repasswordTextField;
@property(nonatomic)UILabel *accountHintLabel;
@property(nonatomic,assign)BOOL isEffective;

@property(nonatomic)UIButton *createBtn;
@property(nonatomic,strong)UIButton *importBtn;
@property(nonatomic,strong) UIButton *backBtn;
@property(nonatomic)RemindView *remindView;
@property(nonatomic)UIView *shadowView;
@property(nonatomic)UIView *dimView;
@end

@implementation CreateAccountVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    _isEffective = NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
}
- (void)popAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    self.title = NSLocalizedString(@"创建/导入账号", nil);
    CurrentNodes *nodes = [CreateAll GetCurrentNodes];
    nodes = [CurrentNodes new];
    nodes.nodeBtc = [[DomainConfigManager share]getCurrentEvnDict][nodeBtc];
    nodes.nodeEth = [[DomainConfigManager share]getCurrentEvnDict][nodeEth];
    nodes.nodeEos = [[DomainConfigManager share]getCurrentEvnDict][nodeEos];
    nodes.nodeMgp = [[DomainConfigManager share]getCurrentEvnDict][nodeMgp];
    [CreateAll SaveCurrentNodes:nodes];
    
    /*
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.backgroundColor = [UIColor clearColor];
    
    [_backBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [_backBtn setImage:[UIImage imageNamed:@"ico_right_arrow"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_backBtn];
//    _backBtn.userInteractionEnabled = YES;
//    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(SafeAreaTopHeight - 34);
//        make.height.equalTo(25);
//        make.left.equalTo(10);
//        make.width.equalTo(30);
//    }];
    
    _headlabel = [[UILabel alloc] init];
    _headlabel.textColor = [UIColor blackColor];
    _headlabel.font = [UIFont systemFontOfSize:24];
    _headlabel.text = NSLocalizedString(@"创建账号", nil);
    _headlabel.textAlignment = NSTextAlignmentLeft;
    _headlabel.numberOfLines = 1;
//    [self.view addSubview:_headlabel];
//    [_headlabel mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.left.equalTo(16);
//        make.top.equalTo(SafeAreaTopHeight);
////        make.right.equalTo(-16);
//        make.height.equalTo(25);
//        make.centerX.equalTo(0);
//    }];*/
    
    _accountTextField = [JVFloatLabeledTextField new];
    _accountTextField.borderStyle = UITextBorderStyleNone;
//    _accountTextField.userInteractionEnabled = YES;
    _accountTextField.attributedPlaceholder =[[NSAttributedString alloc]initWithString: NSLocalizedString(@"请输入用户名", nil)];
//    _accountTextField.keepBaseline = YES;
    _accountTextField.layer.borderWidth = 0.5;
    _accountTextField.layer.borderColor = [UIColor colorWithRed:237/255.0 green:239/255.0 blue:241/255.0 alpha:1.0].CGColor;
    _accountTextField.backgroundColor = RGB(244, 246, 248);
    _accountTextField.layer.cornerRadius = 5;
    _accountTextField.textAlignment = NSTextAlignmentLeft;
    _accountTextField.textColor = [UIColor lightGrayColor];
    _accountTextField.font = [UIFont systemFontOfSize:16];
    _accountTextField.keyboardType = UIKeyboardTypeDefault;
    _accountTextField.floatingLabelYPadding = 3;
    _accountTextField.clearButtonMode = UITextFieldViewModeAlways;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidEndEditing) name:UITextFieldTextDidEndEditingNotification object:_accountTextField];
    [self.view addSubview:_accountTextField];
    [_accountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(10);
        make.height.equalTo(55);
        make.left.equalTo(17);
        make.right.equalTo(-16);
    }];
    
    _accountHintLabel = [UILabel new];
    _accountHintLabel.text = NSLocalizedString(@"MGP账户名称为a-z与1-5组合的12位字符", nil);
    _accountHintLabel.font = [UIFont systemFontOfSize:13];
    _accountHintLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:_accountHintLabel];
    [_accountHintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_accountTextField.mas_bottom).equalTo(0);
        make.left.equalTo(17);
        make.right.equalTo(-16);
        
    }];
    
    
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
        make.top.mas_equalTo(_accountHintLabel.mas_bottom).equalTo(20);
//        make.top.equalTo(10);
        make.height.equalTo(45);
        make.left.equalTo(17);
        make.right.equalTo(-16);
    }];
    UIView *link = [UIView new];
    link.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:link];
    [link mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_passwordTextField.mas_left);
        make.right.mas_equalTo(_passwordTextField.mas_right);
        make.top.mas_equalTo(_passwordTextField.mas_bottom);
        make.height.equalTo(1.3);
        

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
    UIView *link1 = [UIView new];
    link1.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:link1];
    [link1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_repasswordTextField.mas_left);
        make.right.mas_equalTo(_repasswordTextField.mas_right);
        make.top.mas_equalTo(_repasswordTextField.mas_bottom);
        make.height.equalTo(1.3);
        

    }];
    
//    for (JVFloatLabeledTextField *tf in @[_accountTextField,_passwordTextField,_repasswordTextField]) {
//        tf.layer.cornerRadius = 4;
//        tf.clipsToBounds = YES;
//    }
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
//        make.centerY.equalTo(30);
        make.top.mas_equalTo(link1.mas_bottom).equalTo(150);
        make.height.equalTo(45);
        make.left.equalTo(17);
        make.right.equalTo(-16);
    }];

    _importBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _importBtn.backgroundColor = [UIColor whiteColor];
    _importBtn.tintColor = [UIColor whiteColor];
    _importBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    _importBtn.layer.cornerRadius = 4;
    _importBtn.clipsToBounds = YES;
    [_importBtn gradientButtonWithSize:CGSizeMake(ScreenWidth - 34, 45) colorArray:@[RGB(255, 222, 137),RGB(255, 222, 137)] percentageArray:@[@(0.3),@(1)] gradientType:GradientFromLeftTopToRightBottom];
    [_importBtn setTitle:NSLocalizedString(@"导入", nil) forState:UIControlStateNormal];
    [_importBtn addTarget:self action:@selector(importAccount) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_importBtn];
    [_importBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(80);
        make.top.mas_equalTo(self.createBtn.mas_bottom).equalTo(10);
        make.height.equalTo(45);
        make.left.equalTo(17);
        make.right.equalTo(-16);
    }];
    
//    _accountTextField.text = @"aaaaaaaaaaa1";
//    _passwordTextField.text = @"12345678";
//    _repasswordTextField.text = @"12345678";

}
- (void)textFieldTextDidEndEditing{
    self.isEffective = NO;
    NSString *account = VALIDATE_STRING(self.accountTextField.text);
    BOOL verifyaccount = [NSString checkEOSAccount:account];
    _accountHintLabel.textColor = verifyaccount ? [UIColor lightGrayColor] : [UIColor redColor];
    _accountHintLabel.text = NSLocalizedString(@"MGP账户名称为a-z与1-5组合的12位字符", nil);

    if (([_accountTextField.text isEqualToString:@""])||(_accountTextField.text == nil)) {
        [self.view showMsg:NSLocalizedString(@"请输入名称！", nil)];
        return;
    }
    if (!verifyaccount) {return;}
    
    [[HTTPRequestManager shareMgpManager] post:eos_get_account paramters:@{@"account_name":account} success:^(BOOL isSuccess, id responseObject) {
        if (isSuccess) {
            self.accountHintLabel.textColor = [UIColor redColor];
            self.isEffective = YES;
            self.accountHintLabel.text = NSLocalizedString(@"账户已存在", nil);

        }
    } failure:^(NSError *error) {
        self.accountHintLabel.textColor = [UIColor lightGrayColor];
        self.accountHintLabel.text = NSLocalizedString(@"账户可用", nil);
    } superView:self.view showFaliureDescription:YES];
    
    
    
}
-(void)importAccount{
    ImportHDWalletVC *imvc = [ImportHDWalletVC new];
    imvc.ifverify = 2000;
    [self.navigationController pushViewController:imvc animated:YES];
    
}
-(void)createAccount{
    if (![NSString checkEOSAccount:VALIDATE_STRING(self.accountTextField.text)]) {
        [self.view showMsg:NSLocalizedString(@"请输入正确的账户名称！", nil)];
        return;
    }
    if (_isEffective) {
        [self.view showMsg:NSLocalizedString(@"请输入正确的账户名称！", nil)];
        return;
    }
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
    
    [[NSUserDefaults standardUserDefaults] setObject:self.accountTextField.text forKey:AccountName];
    [[NSUserDefaults standardUserDefaults]setObject:_passwordTextField.text forKey:PassWordText];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.accountTextField.text forKey:@"account"];

    
    CreateMnemonicVC *cmvc = [CreateMnemonicVC new];
    cmvc.password = self.passwordTextField.text;
    cmvc.coinType = NOTDEFAULT;
    [self.navigationController pushViewController:cmvc animated:YES];
    
    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    if (self.shadowView.alpha == 1) {
        [UIView animateWithDuration:0.5 animations:^{
            self.dimView.alpha = 0;
            self.shadowView.alpha = 0;
        } completion:^(BOOL finished) {
            [self.shadowView removeFromSuperview];
            [self.remindView removeFromSuperview];
            self.shadowView = nil;
            self.remindView = nil;
            self.backBtn.userInteractionEnabled = YES;
            self.passwordTextField.userInteractionEnabled = YES;
            self.repasswordTextField.userInteractionEnabled = YES;
            self.createBtn.userInteractionEnabled = YES;
        }];
    }
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
        self.backBtn.userInteractionEnabled = YES;
        self.passwordTextField.userInteractionEnabled = YES;
        self.repasswordTextField.userInteractionEnabled = YES;
        self.createBtn.userInteractionEnabled = YES;
    }];
    CreateMnemonicVC *cmvc = [CreateMnemonicVC new];
    cmvc.password = self.passwordTextField.text;
    cmvc.coinType = NOTDEFAULT;
    [self.navigationController pushViewController:cmvc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
