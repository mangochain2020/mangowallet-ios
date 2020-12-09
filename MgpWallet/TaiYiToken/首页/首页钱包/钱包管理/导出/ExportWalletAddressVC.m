//
//  ExportWalletAddressVC.m
//  TaiYiToken
//
//  Created by admin on 2018/9/5.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "ExportWalletAddressVC.h"
#import "AnnounceView.h"
#import "AddBTCAddressCell.h"
@interface ExportWalletAddressVC ()<UITableViewDelegate ,UITableViewDataSource>
@property(nonatomic)NSString *selectedAddress;
@property(nonatomic,strong) UIButton *backBtn;
@property(nonatomic)UILabel *titleLabel;
@property(nonatomic)AnnounceView *announceView;
@property(nonatomic)UITableView *tableView;

@property(nonatomic)UIButton *addAddressBtn;
@property(nonatomic)NSMutableArray *existAddressArray;
@property(nonatomic)NSIndexPath *selectedIndexPath;
@end

@implementation ExportWalletAddressVC
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
    //离开页面，更新选择的地址
    self.wallet.selectedBTCAddress = self.existAddressArray[self.selectedIndexPath.row];
    [CreateAll SaveWallet:self.wallet Name:self.wallet.walletName WalletType:self.wallet.walletType Password:nil];
}
- (void)popAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    [self initHeadView];
    self.title = NSLocalizedString(@"钱包地址", nil);
    [self initUI];
    [self loadExistAddress];
    if (self.existAddressArray != nil) {
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
    [_titleLabel setText:[NSString stringWithFormat:NSLocalizedString(@"钱包地址", nil)]];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(SafeAreaTopHeight - 30);
        make.left.equalTo(45);
        make.width.equalTo(200);
        make.height.equalTo(20);
    }];
    
}
-(void)loadExistAddress{
    self.existAddressArray = [self.wallet.addressarray mutableCopy];
    self.selectedAddress = [self.wallet.selectedBTCAddress isEqualToString:@""]?self.wallet.address:self.wallet.selectedBTCAddress;
}

-(void)initUI{
    _announceView = [AnnounceView new];
    [_announceView initAnnounceView];
    _announceView.textView.text = NSLocalizedString(@"你可以在一个比特币钱包下添加多个不同的子地址来避免地址重用以及保护您的隐私\n"
    " 标记 * 为未使用过的地址\n"
    "选中的地址将作为默认地址显示在收款页面", nil);
    [self.view addSubview:_announceView];
    [_announceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.top.equalTo(84);
        make.right.equalTo(-16);
        make.height.equalTo(120);
    }];
    
    UILabel *leftlabel = [UILabel new];
    leftlabel.font = [UIFont boldSystemFontOfSize:15];
    leftlabel.textColor = [UIColor textBlackColor];
    [leftlabel setText:NSLocalizedString(@"子地址", nil)];
    leftlabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:leftlabel];
    [leftlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(210);
        make.left.equalTo(16);
        make.width.equalTo(100);
        make.height.equalTo(20);
    }];
    
    _addAddressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addAddressBtn setImage:[UIImage imageNamed:@"ico_add_"] forState:UIControlStateNormal];
    [_addAddressBtn addTarget:self action:@selector(addAddress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_addAddressBtn];
    [_addAddressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(210);
        make.left.equalTo(leftlabel.mas_right).equalTo(5);
        make.width.equalTo(50);
        make.height.equalTo(20);
    }];
    
}
-(void)addAddress{
    //对导入的钱包另外考虑
    //TODO
   // BTCPrivateKeyAddress *pkaddr = [BTCPrivateKeyAddress addressWithString:self.wallet.privateKey];
   // BTCKey* key1 = [[BTCKey alloc]initWithPrivateKeyAddress:pkaddr];

    UInt32 index = (UInt32) self.existAddressArray.count;
    BTCKey *key = [CreateAll CreateBTCAddressAtIndex:index ExtendKey:self.wallet.BIP32ExtendedPublicKey];
    [self.wallet.addressarray addObject:key.compressedPublicKeyAddress.string];
    [CreateAll SaveWallet:self.wallet Name:self.wallet.walletName WalletType:self.wallet.walletType Password:nil];
    [self.existAddressArray addObject:key.compressedPublicKeyAddress.string];
    [self.tableView reloadData];
    NSLog(@"add address = %@",key.compressedPublicKeyAddress.string);
}


#pragma tableView

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *lineview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    lineview.backgroundColor = kRGBA(230, 230, 230, 1);
    return lineview;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 2;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.existAddressArray == nil?0 : self.existAddressArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    for (int i = 0; i < self.existAddressArray.count; i++) {
        if (i != indexPath.row) {
            AddBTCAddressCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:indexPath.section]];
            [cell.selectBtn setSelected:NO];
        }
    }
    AddBTCAddressCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell.selectBtn setSelected:YES];
    self.selectedIndexPath = indexPath;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    AddBTCAddressCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell.selectBtn setSelected:NO];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddBTCAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddBTCAddressCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [AddBTCAddressCell new];
    }
    NSString *address = self.existAddressArray[indexPath.row];
    NSString *str1 = [address substringToIndex:9];
    NSString *str2 = [address substringFromIndex:address.length - 10];
    if (self.selectedAddress != nil && [address isEqualToString:self.selectedAddress]) {
        [cell.selectBtn setSelected:YES];
        self.selectedIndexPath = indexPath;
    }
    cell.addresslb.text = [NSString stringWithFormat:@"* %@...%@",str1,str2];
    cell.xpubIndexlb.text = [NSString stringWithFormat:@"xpub 0/%ld",indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma lazy

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        UIView *view = [[UIView alloc] init];
        _tableView.tableFooterView = view;
        [_tableView registerClass:[AddBTCAddressCell class] forCellReuseIdentifier:@"AddBTCAddressCell"];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(240);
            make.left.right.equalTo(0);
            make.bottom.equalTo(0);
        }];
    }
    return _tableView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
