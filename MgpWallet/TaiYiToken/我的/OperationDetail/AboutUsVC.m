//
//  AboutUsVC.m
//  TaiYiToken
//
//  Created by 张元一 on 2018/10/30.
//  Copyright © 2018 admin. All rights reserved.
//

#import "AboutUsVC.h"
#import "TextLabelCell.h"
#import "WebVC.h"
@interface AboutUsVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UIButton *backBtn;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)SystemInitModel *sysinfo;
@property(nonatomic,strong) UIButton *protocolBtn;
@end

@implementation AboutUsVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
   // [self.tableView reloadData];
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
    self.view.backgroundColor = RGB(250, 250, 250);
    [self initUI];
    [self loadData];
    if (self.sysinfo) {
        [self.tableView reloadData];
    }
}
-(void)initUI{
    /*
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
    [_titleLabel setText:NSLocalizedString(@"关于我们", nil)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(SafeAreaTopHeight - 30);
        make.right.equalTo(-33);
        make.left.equalTo(33);
        make.height.equalTo(20);
    }];
    */
    self.title = NSLocalizedString(@"关于我们", nil);
    UIImageView *iv = [UIImageView new];
    iv.image = [UIImage imageNamed:@"MGP_coin"];
    [self.view addSubview:iv];
    [iv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(100);
        make.centerX.equalTo(0);
        make.width.height.equalTo(80);
    }];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // CFShow((__bridge CFTypeRef)(infoDictionary));
    /*  系统公共参数  */
    //appVersion
    NSString *appCurVersionNum = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    UILabel * versionlb = [UILabel new];
    versionlb.font = [UIFont boldSystemFontOfSize:14];
    versionlb.textColor = [UIColor textBlackColor];
    [versionlb setText:[NSString stringWithFormat:@"v%@",appCurVersionNum]];
    versionlb.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:versionlb];
    [versionlb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(200);
        make.centerX.equalTo(0);
        make.width.equalTo(80);
        make.height.equalTo(20);
    }];
    
   
}

-(void)loadData{
    SystemInitModel *sysinfo = [CreateAll GetSystemData];
    if (sysinfo) {
        self.sysinfo = sysinfo;
    }
}

//隐私政策
-(void)seeProtocol{
    WebVC *vc = [WebVC new];
    NSString *current = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLanguageSelected"];
    if ([current isEqualToString:@"chinese"]) {
       vc.urlstring = PrivacyPolicyURL_CHS;
    }else{
       vc.urlstring = PrivacyPolicyURL_EN;
    }
    [self.navigationController pushViewController:vc animated:YES];
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
    return 6;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *url = nil;
    if (indexPath.row == 0) {
        url = self.sysinfo.aboutUs.website;
    }else if (indexPath.row == 1){
        url = self.sysinfo.aboutUs.twitter;
    }else if (indexPath.row == 2){
        url = self.sysinfo.aboutUs.wechat;
    }else{
        url = self.sysinfo.aboutUs.telegram;
    }
//    if (url != nil && [url containsString:@"http"]) {
//        WebVC *vc = [WebVC new];
//        vc.headcolor = [UIColor whiteColor];
//        vc.backBtnTintColor = [UIColor blackColor];
//        vc.urlstring = url;
//        [self.navigationController pushViewController:vc animated:YES];
//    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TextLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextLabelCell" forIndexPath:indexPath];
    
    cell.detailTextLabel.textColor = [UIColor darkBlueColor];
    if (indexPath.row == 0) {
        cell.textlb.text = @"Website";
        cell.detaillb.text = self.sysinfo.aboutUs.website;
    }else if (indexPath.row == 1){
        cell.textlb.text = @"Twitter";
        cell.detaillb.text = self.sysinfo.aboutUs.twitter?self.sysinfo.aboutUs.twitter : @"@MissionNetwork @network_mission";
    }else if (indexPath.row == 2){
        cell.textlb.text = @"FB";
        cell.detaillb.text = self.sysinfo.aboutUs.fb?self.sysinfo.aboutUs.fb : @"@MissionNetwork";
    }else if (indexPath.row == 3){
        cell.textlb.text = @"Telegram";
        cell.detaillb.text = self.sysinfo.aboutUs.telegram?self.sysinfo.aboutUs.telegram : @"@MissionNetwork";
    }else if (indexPath.row == 4){
        cell.textlb.text = @"Wechat";
        cell.detaillb.text = self.sysinfo.aboutUs.wechat?self.sysinfo.aboutUs.wechat : @"@MissionNetwork";
    }else{
        cell.textlb.text = @"Weibo";
        cell.detaillb.text = self.sysinfo.aboutUs.weibo?self.sysinfo.aboutUs.weibo : @"@MissionNetwork";
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
        _tableView.backgroundColor = RGB(250, 250, 250);
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle =NO;
        UIView *view = [[UIView alloc] init];
        _tableView.tableFooterView = view;
        [_tableView registerClass:[TextLabelCell class] forCellReuseIdentifier:@"TextLabelCell"];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(264);
            make.left.right.equalTo(0);
            make.bottom.equalTo(-SafeAreaBottomHeight-30);
        }];
        
        _protocolBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _protocolBtn.backgroundColor = [UIColor clearColor];
        _protocolBtn.tintColor = RGB(100, 100, 255);
        _protocolBtn.titleLabel.textColor = [UIColor textBlueColor];
        _protocolBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _protocolBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_protocolBtn setTitle:NSLocalizedString(@"《隐私政策》", nil) forState:UIControlStateNormal];
        [_protocolBtn addTarget:self action:@selector(seeProtocol) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_protocolBtn];
        _protocolBtn.userInteractionEnabled = YES;
        [_protocolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.tableView.mas_bottom).equalTo(10);
            make.left.right.equalTo(0);
            make.height.equalTo(20);
        }];
    }
    return _tableView;
}
@end
