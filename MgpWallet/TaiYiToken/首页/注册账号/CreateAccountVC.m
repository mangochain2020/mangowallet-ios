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
    self.view.backgroundColor = [UIColor whiteColor];
    self.accountTextField.backgroundColor =[UIColor whiteColor];
    self.passwordTextField.backgroundColor = [UIColor whiteColor];
    self.repasswordTextField.backgroundColor = [UIColor whiteColor];
//    self.createBtn.alpha = 1.0;
//    self.navigationController.navigationBar.hidden = YES;
//    self.navigationController.hidesBottomBarWhenPushed = YES;
//    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
//    self.navigationController.navigationBar.hidden = NO;
//    self.navigationController.hidesBottomBarWhenPushed = NO;
//    self.tabBarController.tabBar.hidden = NO;
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
//    _accountTextField.text = @"aaaaaaaaaaa1";//[CreateAll GetCurrentUserName];
    _accountTextField.userInteractionEnabled = YES;
    _accountTextField.attributedPlaceholder =[[NSAttributedString alloc]initWithString: NSLocalizedString(@"请输入用户名", nil)];
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
        make.centerY.equalTo(80);
        make.height.equalTo(45);
        make.left.equalTo(17);
        make.right.equalTo(-16);
    }];
    
}

-(void)importAccount{
    ImportHDWalletVC *imvc = [ImportHDWalletVC new];
    imvc.ifverify = 2000;
    [self.navigationController pushViewController:imvc animated:YES];
    
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
    [[NSUserDefaults standardUserDefaults]setObject:_passwordTextField.text forKey:PassWordText];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.accountTextField.text forKey:@"account"];
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
        self.backBtn.userInteractionEnabled = NO;
        self.passwordTextField.userInteractionEnabled = NO;
        self.repasswordTextField.userInteractionEnabled = NO;
        self.createBtn.userInteractionEnabled = NO;
    }];
    
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
