//
//  SelectCurrencyTypeVC.m
//  TaiYiToken
//
//  Created by admin on 2018/9/26.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "SelectCurrencyTypeVC.h"
#import "UserConfigCell.h"
#import "NTVLocalized.h"
#import "CustomizedTabBarController.h"
@interface SelectCurrencyTypeVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UIButton *backBtn;
@property(nonatomic)UILabel *titleLabel;
@property(nonatomic)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *titleArray1;
@end

@implementation SelectCurrencyTypeVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
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
    [self initHeadView];
    if (self.configType == lANGUAGE_CONFIG_TYPE) {
        self.titleArray1 = [@[NSLocalizedString(@"中文", nil),NSLocalizedString(@"英文", nil)] mutableCopy];
    }else if (self.configType == COIN_CONFIG_TYPE){
        self.titleArray1 = [@[NSLocalizedString(@"人民币", nil),NSLocalizedString(@"美元", nil)] mutableCopy];
    }else{
        SystemInitModel *model = [CreateAll GetSystemData];
        [self.titleArray1 removeAllObjects];
        switch (self.coinType) {
            case BTC:
                self.titleArray1 = [model.nodeBtcList mutableCopy];
                [self.titleArray1 addObject:@"https://insight.bitpay.com"];
                break;
            case BTC_TESTNET:
                [self.titleArray1 addObject:@"https://test-insight.bitpay.com"];
                break;
            case ETH:
                self.titleArray1 = [model.nodeEthList mutableCopy];
                break;
            case EOS:
                self.titleArray1 = [model.nodeEosList mutableCopy];
                break;
            case MIS:
                self.titleArray1 = [model.nodeMisList mutableCopy];
                break;
            default:
                break;
        }
    }
    if (self.titleArray1.count > 0) {
        [self tableView];
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
//    [self.view addSubview:_backBtn];
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
    if (self.configType == lANGUAGE_CONFIG_TYPE) {
        [_titleLabel setText:NSLocalizedString(@"多语言", nil)];
    }else if (self.configType == COIN_CONFIG_TYPE){
        [_titleLabel setText:NSLocalizedString(@"货币单位", nil)];
    }else{
        [_titleLabel setText:NSLocalizedString(@"节点选择", nil)];
    }
    self.title = _titleLabel.text;
    _titleLabel.textAlignment = NSTextAlignmentLeft;
//    [self.view addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(SafeAreaTopHeight - 30);
        make.left.equalTo(45);
        make.width.equalTo(200);
        make.height.equalTo(20);
    }];
    
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray1.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.configType == lANGUAGE_CONFIG_TYPE){
        if (indexPath.row == 0) {
            [[NTVLocalized sharedInstance] setLanguage:@"zh-Hans"];
            [[NSUserDefaults standardUserDefaults] setObject:@"chinese" forKey:@"CurrentLanguageSelected"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }else{
            [[NTVLocalized sharedInstance] setLanguage:@"en"];
            [[NSUserDefaults standardUserDefaults] setObject:@"english" forKey:@"CurrentLanguageSelected"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        [[CustomizedTabBarController sharedCustomizedTabBarController] resetbartitle];
    }else if(self.configType == COIN_CONFIG_TYPE){
        if (indexPath.row == 0) {
            [[NSUserDefaults standardUserDefaults] setObject:@"rmb" forKey:@"CurrentCurrencySelected"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }else{
            [[NSUserDefaults standardUserDefaults] setObject:@"dollar" forKey:@"CurrentCurrencySelected"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }else{
        CurrentNodes *nodes = [CreateAll GetCurrentNodes];
        NSInteger indextype;
        switch (self.coinType) {
            case BTC:
                indextype = 0;
                nodes.nodeBtc = self.titleArray1[indexPath.row];
                break;
            case BTC_TESTNET:
                indextype = 0;
                nodes.nodeBtc = self.titleArray1[indexPath.row];
                break;
            case ETH:
                indextype = 1;
                nodes.nodeEth = self.titleArray1[indexPath.row];
                break;
            case EOS:
                indextype = 2;
                nodes.nodeEos = self.titleArray1[indexPath.row];
                break;
            case MIS:
                indextype = 3;
                nodes.nodeMis = self.titleArray1[indexPath.row];
                break;
            default:
                indextype = -1;
                break;
        }
        [self.delegate selectNode:self.titleArray1[indexPath.row] Index:indextype];
        [CreateAll SaveCurrentNodes:nodes];
    }
    [self.tableView reloadData];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserConfigCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserConfigCell" forIndexPath:indexPath];
    [cell.textlb setText:self.titleArray1[indexPath.row]];
    if(self.configType == lANGUAGE_CONFIG_TYPE){
        if (![[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLanguageSelected"]) {
            [[NSUserDefaults standardUserDefaults] setObject:@"chinese" forKey:@"CurrentLanguageSelected"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        NSString *current = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLanguageSelected"];
        if ([current isEqualToString:@"chinese"]) {
            if (indexPath.row == 0) {
                cell.checkIv.alpha = 1;
            }else{
                cell.checkIv.alpha = 0;
            }
        }else{
            if (indexPath.row == 1) {
                cell.checkIv.alpha = 1;
            }else{
                cell.checkIv.alpha = 0;
            }
        }
        
    }else if(self.configType == COIN_CONFIG_TYPE){
        if (![[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentCurrencySelected"]) {
            [[NSUserDefaults standardUserDefaults] setObject:@"rmb" forKey:@"CurrentCurrencySelected"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        NSString *current = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentCurrencySelected"];
        if ([current isEqualToString:@"rmb"]) {
            if (indexPath.row == 0) {
                cell.checkIv.alpha = 1;
            }else{
                cell.checkIv.alpha = 0;
            }
        }else{
            if (indexPath.row == 1) {
                cell.checkIv.alpha = 1;
            }else{
                cell.checkIv.alpha = 0;
            }
        }
    }else{
        CurrentNodes *nodes = [CreateAll GetCurrentNodes];
        NSString *current;
        switch (self.coinType) {
            case BTC:
                current = nodes.nodeBtc;
                break;
            case BTC_TESTNET:
                current = nodes.nodeBtc;
                break;
            case ETH:
                current = nodes.nodeEth;
                break;
            case EOS:
                current = nodes.nodeEos;
                break;
            case MIS:
                current = nodes.nodeMis;
                break;
            default:
                break;
        }
        if ([current isEqualToString:self.titleArray1[indexPath.row]]) {
            cell.checkIv.alpha = 1;
        }else{
            cell.checkIv.alpha = 0;
        }
    }
    cell.userInteractionEnabled = YES;
   
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

@end
