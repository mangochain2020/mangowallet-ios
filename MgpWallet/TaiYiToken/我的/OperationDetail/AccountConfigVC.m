//
//  AccountConfigVC.m
//  TaiYiToken
//
//  Created by admin on 2018/9/25.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "AccountConfigVC.h"
#import "UserConfigCell.h"
#import "SelectCurrencyTypeVC.h"
#import "BindPhoneVC.h"
#import "BindMailVC.h"
#import "UserInfoModel.h"
#import "NodeSettingVC.h"
#import "InputPasswordView.h"
@interface AccountConfigVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UIButton *backBtn;
@property(nonatomic)UIView *shadowView;
@property(nonatomic,copy)NSString *password;
@property(nonatomic)InputPasswordView *ipview;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *titleArray1;
@property(nonatomic,strong)NSArray *titleArray2;
@property(nonatomic,strong)NSArray *titleArray3;
@property(nonatomic,strong) UIButton *quitAccountBtn;
@property(nonatomic,strong)UserInfoModel *usermodel;
@end

@implementation AccountConfigVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if ([CreateAll isLogin]) {
        self.usermodel = [CreateAll GetCurrentUser];
    }
    [self initHeadView];
    [self.tableView reloadData];
    [self initQuitBtn];
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    self.navigationController.hidesBottomBarWhenPushed = YES;
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.hidesBottomBarWhenPushed = NO;
}
- (void)popAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    //,NSLocalizedString(@"多语言", nil),NSLocalizedString(@"货币单位", nil)
    self.titleArray1 = @[NSLocalizedString(@"当前账号", nil)];
    self.titleArray2 = @[NSLocalizedString(@"涨红跌绿", nil),NSLocalizedString(@"隐私模式", nil),NSLocalizedString(@"节点设置", nil)];
    self.titleArray3 = @[NSLocalizedString(@"邮箱绑定", nil),NSLocalizedString(@"手机绑定", nil)];
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentCurrencySelected"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"rmb" forKey:@"CurrentCurrencySelected"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
   
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.shadowView removeFromSuperview];
    [self.ipview removeFromSuperview];
    self.shadowView = nil;
    self.ipview = nil;
}

-(void)confirmBtnAction{
        [UIView animateWithDuration:0.5 animations:^{
            self.shadowView.alpha = 0;
        } completion:^(BOOL finished) {
            self.password = self.ipview.passwordTextField.text;
            [self.shadowView removeFromSuperview];
            [self.ipview removeFromSuperview];
            self.shadowView = nil;
            self.ipview = nil;
            [self quitAccount];
        }];
}

-(void)quitAccount{
    if (self.password == nil || [self.password isEqualToString:@""]) {
        [self.view showMsg:NSLocalizedString(@"请输入密码", nil)];
        return;
    }
    //验证mis钱包的密码
    BOOL passwordisright = [CreateAll VerifyPassword:self.password ForWalletAddress:[CreateAll GetCurrentUserName]];
    [self.view hideHUD];
    if (passwordisright == YES) {
        //
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ifHasAccount"];
        [CreateAll LogOut];
        [CreateAll RemoveAllWallet];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"userlogout" object:nil];
        [self.tableView reloadData];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.view showMsg:NSLocalizedString(@"密码错误", nil)];
    }
}

//退出账号 清除信息
-(void)quitAccountBtnAction{
//    if (self.usermodel.mailStatus == 0 && self.usermodel.mobileStatus == 0) {
//        [self.view showAlert:NSLocalizedString(@"手机/邮箱还没有绑定!", nil) DetailMsg:NSLocalizedString(@"忘记密码时将无法找回", nil)];
//    }
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"ifHasAccount"] == YES){//有钱包才验证密码
        if (!_shadowView) {
            _shadowView = [UIView new];
            _shadowView.layer.shadowColor = [UIColor grayColor].CGColor;
            _shadowView.layer.shadowOffset = CGSizeMake(0, 0);
            _shadowView.layer.shadowOpacity = 1;
            _shadowView.layer.shadowRadius = 3.0;
            _shadowView.layer.cornerRadius = 3.0;
            _shadowView.clipsToBounds = NO;
        }
        
        _shadowView.alpha = 0;
        [self.tableView addSubview:_shadowView];
        [_shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(0);
            make.width.equalTo(300);
            make.height.equalTo(120);
        }];
        if (!_ipview) {
            _ipview = [InputPasswordView new];
            [_ipview initUI];
            [_ipview.confirmBtn addTarget:self action:@selector(confirmBtnAction) forControlEvents:UIControlEventTouchUpInside];
        }
        [_shadowView addSubview:_ipview];
        [_ipview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
        
        [UIView animateWithDuration:0.5 animations:^{
            self.shadowView.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
    }else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ifHasAccount"];
        [CreateAll LogOut];
        [CreateAll RemoveAllWallet];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"userlogout" object:nil];
        [self.tableView reloadData];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
    
}
-(void)initQuitBtn{
    if (!_quitAccountBtn) {
        _quitAccountBtn = [UIButton buttonWithType: UIButtonTypeSystem];
        _quitAccountBtn.titleLabel.textColor = [UIColor redColor];
        _quitAccountBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _quitAccountBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _quitAccountBtn.backgroundColor = [UIColor whiteColor];
        _quitAccountBtn.tintColor = [UIColor redColor];
        _quitAccountBtn.userInteractionEnabled = YES;
        [_quitAccountBtn setTitle:NSLocalizedString(@"退出当前身份", nil) forState:UIControlStateNormal];
        [_quitAccountBtn addTarget:self action:@selector(quitAccountBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_quitAccountBtn];
        [_quitAccountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.bottom.equalTo(-SafeAreaBottomHeight);
            make.height.equalTo(44);
        }];
    }
}

-(void)initHeadView{
    UIView *headBackView = [UIView new];
    headBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headBackView];
    [headBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(0);
        make.height.equalTo(SafeAreaTopHeight);
    }];
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.backgroundColor = [UIColor clearColor];
    _backBtn.tintColor = [UIColor whiteColor];
    [_backBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [_backBtn setImage:[UIImage imageNamed:@"ico_right_arrow"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backBtn];
    _backBtn.userInteractionEnabled = YES;
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(SafeAreaTopHeight - 34);
        make.height.equalTo(25);
        make.left.equalTo(10);
        make.width.equalTo(30);
    }];
    
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont boldSystemFontOfSize:17];
    _titleLabel.textColor = [UIColor textBlackColor];
    [_titleLabel setText:NSLocalizedString(@"账户设置", nil)];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(SafeAreaTopHeight - 30);
        make.left.equalTo(45);
        make.width.equalTo(200);
        make.height.equalTo(20);
    }];

}
#pragma configOptions
-(void)selectCurrency:(CONFIG_TYPE)configType{
    SelectCurrencyTypeVC *svc = [SelectCurrencyTypeVC new];
    svc.configType = configType;
    [self.navigationController pushViewController:svc animated:YES];
}

#pragma mark - Table view data source
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return self.titleArray1.count;
            break;
        case 1:
            return self.titleArray2.count;
        default:
            return self.titleArray3.count;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1&&indexPath.row == 2) {
        NodeSettingVC *vc = [NodeSettingVC new];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(indexPath.section == 2 && indexPath.row == 0){
        BindMailVC *vc = [BindMailVC new];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(indexPath.section == 2 && indexPath.row == 1){
        BindPhoneVC *vc = [BindPhoneVC new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(void)switchConfig:(UISwitch *)switchbtn{
    if (switchbtn.tag == 10001) {
        [[NSUserDefaults standardUserDefaults] setBool:!switchbtn.isOn forKey:@"RiseColorConfig"];
    }else if (switchbtn.tag == 10003){
        [[NSUserDefaults standardUserDefaults] setBool:switchbtn.isOn forKey:@"PrivacyModeON"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserConfigCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserConfigCell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        [cell.textlb setText:self.titleArray1[indexPath.row]];
        NSString *username = @"MissionWallet";
        if (indexPath.row == 0) {
            if ([CreateAll isLogin]) {
                username = [CreateAll GetCurrentUserName]?[CreateAll GetCurrentUserName]:@"MissionWallet";
            }
            [cell.detailtextlb setText:username];
        }
        
    }else if(indexPath.section == 1){
        [cell.textlb setText:self.titleArray2[indexPath.row]];
        [cell.detailtextlb setText:@""];
        if (indexPath.row == 0) {//涨跌红绿设置
            [cell switchBtn];
            BOOL colorConfig = [[NSUserDefaults standardUserDefaults] boolForKey:@"RiseColorConfig"];
            if (colorConfig == YES) {
                [cell.switchBtn setOn:NO];
            }else{
                [cell.switchBtn setOn:YES];
            }
            cell.switchBtn.tag = 10001;
            [cell.switchBtn addTarget:self action:@selector(switchConfig:) forControlEvents:UIControlEventTouchUpInside];
        }else if(indexPath.row == 1){
            [cell switchBtn];
            BOOL priConfig = [[NSUserDefaults standardUserDefaults] boolForKey:@"PrivacyModeON"];
            if (priConfig == YES) {
                [cell.switchBtn setOn:YES];
            }else{
                [cell.switchBtn setOn:NO];
            }
            cell.switchBtn.tag = 10003;
            [cell.switchBtn addTarget:self action:@selector(switchConfig:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [cell rightIconIv];
        }
        
        
    }else{
        [cell.textlb setText:self.titleArray3[indexPath.row]];
        if(indexPath.row == 2){
            [cell.detailtextlb setText:@""];
        }else{
            if ([CreateAll isLogin]) {
                if (indexPath.row == 0) {
                    if (self.usermodel.mailStatus > 0 && ![self.usermodel.mail isEqualToString:@""]) {
                        [cell.detailtextlb setText:self.usermodel.mail];
                    }else{
                        [cell.detailtextlb setText:NSLocalizedString(@"未绑定", nil)];
                    }
                }else if (indexPath.row == 1){
                    if (self.usermodel.mobileStatus > 0 && ![self.usermodel.mobile isEqualToString:@""]) {
                        [cell.detailtextlb setText:self.usermodel.mobile];
                    }else{
                        [cell.detailtextlb setText:NSLocalizedString(@"未绑定", nil)];
                    }
                }else{
                    [cell.detailtextlb setText:NSLocalizedString(@"未绑定", nil)];
                }
               
            }else{
                
            }
        }
        [cell rightIconIv];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins  = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
}

#pragma lazy
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        UIView *view = [[UIView alloc] init];
        _tableView.tableFooterView = view;
        [_tableView registerClass:[UserConfigCell class] forCellReuseIdentifier:@"UserConfigCell"];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(SafeAreaTopHeight);
            make.left.right.equalTo(0);
            make.bottom.equalTo(0);
        }];
    }
    return _tableView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
