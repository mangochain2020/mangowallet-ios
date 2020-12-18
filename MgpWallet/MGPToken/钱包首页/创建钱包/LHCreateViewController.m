//
//  LHCreateViewController.m
//  TaiYiToken
//
//  Created by mac on 2020/7/16.
//  Copyright © 2020 admin. All rights reserved.
//

#import "LHCreateViewController.h"
#import "CreateMnemonicVC.h"

@interface LHCreateViewController ()

@property(nonatomic,strong) JVFloatLabeledTextField *accountTextField;
@property(nonatomic,strong) JVFloatLabeledTextField *passwordTextField;
@property(nonatomic,strong) JVFloatLabeledTextField *repasswordTextField;
@property(nonatomic)UIButton *createBtn;

@property(nonatomic)UILabel *accountHintLabel;
@property(nonatomic,assign)BOOL isEffective;



@end

@implementation LHCreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _accountTextField = [JVFloatLabeledTextField new];
    _accountTextField.borderStyle = UITextBorderStyleNone;
    _accountTextField.attributedPlaceholder =[[NSAttributedString alloc]initWithString: NSLocalizedString(@"钱包名称", nil)];
    _accountTextField.keepBaseline = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidEndEditing) name:UITextFieldTextDidEndEditingNotification object:_accountTextField];
    _accountTextField.backgroundColor = [UIColor whiteColor];
    _accountTextField.textAlignment = NSTextAlignmentLeft;
    _accountTextField.textColor = [UIColor lightGrayColor];
    _accountTextField.font = [UIFont systemFontOfSize:16];
    _accountTextField.floatingLabelYPadding = 3;
    
    _accountTextField.layer.borderWidth = 0.5;
    _accountTextField.layer.borderColor = [UIColor colorWithRed:237/255.0 green:239/255.0 blue:241/255.0 alpha:1.0].CGColor;
    _accountTextField.backgroundColor = RGB(244, 246, 248);
    _accountTextField.layer.cornerRadius = 5;
    
    
    _accountHintLabel = [UILabel new];
    _accountHintLabel.font = [UIFont systemFontOfSize:13];
    _accountHintLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:_accountHintLabel];


    switch (self.coinType) {
        case ETH:
        {
            self.title = NSLocalizedString(@"创建ETH钱包", nil);
            [_accountHintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(10);
                make.left.equalTo(17);
                make.right.equalTo(-16);
            }];
        }
            break;
        case BTC:
        case BTC_TESTNET:
        {
            self.title = NSLocalizedString(@"创建BTC钱包", nil);
            [_accountHintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(10);
                make.left.equalTo(17);
                make.right.equalTo(-16);
            }];
        }
            break;
        case EOS:
        {
            self.title = NSLocalizedString(@"创建EOS钱包", nil);
            _accountHintLabel.text = NSLocalizedString(@"a-z与1-5的12位字符组合", nil);
            [self.view addSubview:_accountTextField];
            [_accountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(10);
                make.height.equalTo(55);
                make.left.equalTo(17);
                make.right.equalTo(-16);
            }];
            [_accountHintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.accountTextField.mas_bottom).equalTo(0);
                make.left.equalTo(17);
                make.right.equalTo(-16);
            }];
        }
            break;
        case MGP:
        {
            self.title = NSLocalizedString(@"创建MGP钱包", nil);
            _accountHintLabel.text = NSLocalizedString(@"a-z与1-5的12位字符组合", nil);
            [self.view addSubview:_accountTextField];
            _accountTextField.attributedPlaceholder =[[NSAttributedString alloc]initWithString: NSLocalizedString(@"设置您的MGP钱包地址", nil)];
            [_accountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(10);
                make.height.equalTo(55);
                make.left.equalTo(17);
                make.right.equalTo(-16);
            }];
            [_accountHintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.accountTextField.mas_bottom).equalTo(5);
                make.left.equalTo(17);
                make.right.equalTo(-16);
            }];
        }
            break;
        default:
            break;
    }

    _passwordTextField = [JVFloatLabeledTextField new];
    _passwordTextField.borderStyle = UITextBorderStyleNone;
    _passwordTextField.attributedPlaceholder =[[NSAttributedString alloc]initWithString: NSLocalizedString(@"设置您的密码", nil)];
    _passwordTextField.backgroundColor = [UIColor whiteColor];
    _passwordTextField.textAlignment = NSTextAlignmentLeft;
    _passwordTextField.textColor = [UIColor darkGrayColor];
    _passwordTextField.font = [UIFont systemFontOfSize:16];
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.floatingLabelYPadding = 3;
    [self.view addSubview:_passwordTextField];
    [_passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.accountHintLabel.mas_bottom).equalTo(20);
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
    _repasswordTextField.attributedPlaceholder =[[NSAttributedString alloc]initWithString: NSLocalizedString(@"再次输入您的密码", nil)];
    
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
        make.top.mas_equalTo(self.repasswordTextField.mas_bottom).equalTo(100);
        make.height.equalTo(45);
        make.left.equalTo(17);
        make.right.equalTo(-16);
    }];
//    _accountTextField.text = @"aaaaaaaaaaa1";
//    _passwordTextField.text = @"12345678";
//    _repasswordTextField.text = @"12345678";
}
-(void)createAccount{

    switch (self.coinType) {
        case EOS:
        case MGP:
            if (![NSString checkEOSAccount:VALIDATE_STRING(self.accountTextField.text)]) {
                [self.view showMsg:NSLocalizedString(@"请输入正确的账户名称！", nil)];
                return;
            }
            if (_isEffective) {
                [self.view showMsg:NSLocalizedString(@"请输入正确的账户名称！", nil)];
                return;
            }
            break;
        default:
            break;
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
    if (self.passwordTextField.text.length <= 0) {
        [self.view showMsg:NSLocalizedString(@"请输入密码！", nil)];
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:self.accountTextField.text forKey:AccountName];
    [[NSUserDefaults standardUserDefaults]setObject:_passwordTextField.text forKey:PassWordText];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    CreateMnemonicVC *cmvc = [CreateMnemonicVC new];
    cmvc.password = self.passwordTextField.text;
    cmvc.coinType = self.coinType;
    [self.navigationController pushViewController:cmvc animated:YES];
    
    
    
}

- (void)textFieldTextDidEndEditing{
    self.isEffective = NO;
    NSString *account = VALIDATE_STRING(self.accountTextField.text);
    BOOL verifyaccount = [NSString checkEOSAccount:account];
    _accountHintLabel.textColor = verifyaccount ? [UIColor lightGrayColor] : [UIColor redColor];
    _accountHintLabel.text = NSLocalizedString(@"a-z与1-5的12位字符组合", nil);

    if (([_accountTextField.text isEqualToString:@""])||(_accountTextField.text == nil)) {
        [self.view showMsg:NSLocalizedString(@"请输入名称！", nil)];
        return;
    }
    if (!verifyaccount) {return;}
    
    HTTPRequestManager *manager = self.coinType == EOS ? [HTTPRequestManager shareEosManager] : [HTTPRequestManager shareMgpManager];
    [manager post:eos_get_account paramters:@{@"account_name":account} success:^(BOOL isSuccess, id responseObject) {
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
