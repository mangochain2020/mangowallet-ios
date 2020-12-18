//
//  WalletManagerVC.m
//  TaiYiToken
//
//  Created by admin on 2018/9/4.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "WalletManagerVC.h"
#import "WalletManagerCell.h"
#import "ExportWalletVC.h"
#import "ImportWalletSwitchVC.h"
#import "SectionHeaderView.h"

#import "InputPasswordView.h"
@interface WalletManagerVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic)UICollectionView *collectionview;
@property(nonatomic,strong) UIButton *backBtn;
@property(nonatomic)UILabel *titleLabel;
//@property(nonatomic)UIButton *addAccountBtn;
@property(nonatomic)UIButton *addWalletBtn;
@property(nonatomic)NSMutableArray <MissionWallet*> *importWalletArray;
@property(nonatomic)UIView *shadowView;
@property(nonatomic,copy)NSString *password;
@property(nonatomic,strong)InputPasswordView *ipview;
@property(nonatomic,assign)NSInteger deleteIndex;
@end

@implementation WalletManagerVC

-(void)SearchLocalWalletList{
    if (_walletArray == nil || _walletArray.count < 3) {
        [_walletArray removeAllObjects];
        _walletArray = [NSMutableArray array];
        /*
        NSString *username = [CreateAll GetCurrentUserName];
        if (username) {
            MissionWallet *walletMIS = [CreateAll GetMissionWalletByName: [NSString stringWithFormat:@"MIS_%@",username]];
            if (walletMIS) {
                
                [self.walletArray addObject:walletMIS];
            }
        }*/
        NSString *localeosMgpname = [[NSUserDefaults standardUserDefaults] objectForKey:@"LocalMGPWalletName"];
        MissionWallet *walletMGP = [CreateAll GetMissionWalletByName:VALIDATE_STRING(localeosMgpname)];
        [self.walletArray addObject:walletMGP];

        NSString *localeosname = [[NSUserDefaults standardUserDefaults] objectForKey:@"LocalEOSWalletName"];
        MissionWallet *walletEOS = [CreateAll GetMissionWalletByName:VALIDATE_STRING(localeosname)];
        [self.walletArray addObject:walletEOS];

        
        MissionWallet *walletBTC = [CreateAll GetMissionWalletByName:@"BTC(0)"];
        MissionWallet *walletETH = [CreateAll GetMissionWalletByName:@"ETH(0)"];
        
        if (walletBTC) {
            [self.walletArray addObject:walletBTC];
        }
        if (walletETH) {
            [self.walletArray addObject:walletETH];
        }
    }
    /*
    NSMutableArray *temp = [_walletArray mutableCopy];
    for (MissionWallet *obj in temp) {
        for (MissionWallet *obj2 in temp) {
            if (obj.coinType == EOS && obj2.coinType == EOS && obj.walletType == LOCAL_WALLET && obj2.walletType == LOCAL_WALLET) {
                if (obj.address == nil || [NSString checkEOSAccount:obj.address] == NO) {
                    if ([obj2.publicKey isEqualToString:obj.publicKey]) {
                        [_walletArray removeObject:obj];
                    }
                }
            }
            if (obj.coinType == MGP && obj2.coinType == MGP && obj.walletType == LOCAL_WALLET && obj2.walletType == LOCAL_WALLET) {
                if (obj.address == nil || [NSString checkEOSAccount:obj.address] == NO) {
                    if ([obj2.publicKey isEqualToString:obj.publicKey]) {
                        [_walletArray removeObject:obj];
                    }
                }
            }
            
        }
    }*/
}

-(void)RefreshImportWalletList{
    NSArray *importwalletarray = [CreateAll GetImportWalletNameArray];
    self.importWalletArray = [NSMutableArray array];
    for (NSString *importwalletname in importwalletarray) {
        MissionWallet *wallet = [CreateAll GetMissionWalletByName:importwalletname];
        [self.importWalletArray addObject:wallet];
    }
    [self.collectionview reloadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
//    self.navigationController.navigationBar.hidden = YES;
//    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
//    self.navigationController.hidesBottomBarWhenPushed = YES;
//    self.tabBarController.tabBar.hidden = YES;
    [self SearchLocalWalletList];
    [self RefreshImportWalletList];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
//    self.tabBarController.tabBar.hidden = NO;
//    self.navigationController.navigationBar.hidden = NO;
//    self.navigationController.hidesBottomBarWhenPushed = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.importWalletArray = [NSMutableArray new];
    [self SearchLocalWalletList];
    [self RefreshImportWalletList];
//    [self initHeadView];
    self.title = NSLocalizedString(@"钱包管理", nil);
    [self.collectionview registerClass:[WalletManagerCell class] forCellWithReuseIdentifier:@"WalletManagerCell"];
}
- (void)popAction{
    [self.navigationController popViewControllerAnimated:YES];
}
//导入钱包
- (void)addWalletBtnAction{
    ImportWalletSwitchVC *isvc = [ImportWalletSwitchVC new];
    [self.navigationController pushViewController:isvc animated:YES];
}
////创建新账户
//- (void)createNewAccountBtnAction{
//
//    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"此操作将会移除钱包，请提前做好备份！", nil) message:@"" preferredStyle:(UIAlertControllerStyleAlert)];
//    UIAlertAction *alertA = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
//
//    }];
//    UIAlertAction *alertB = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
//        SwitchAccountVc *switchvc = [SwitchAccountVc new];
//        UINavigationController *navivc = [[UINavigationController alloc]initWithRootViewController:switchvc];
//        [navivc.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//        navivc.navigationBar.shadowImage = [UIImage new];
//        navivc.navigationBar.translucent = YES;
//        navivc.navigationBar.alpha = 0;
//        [self presentViewController:navivc animated:YES completion:^{
//
//        }];
//    }];
//
//    [alertC addAction:alertA];
//    [alertC addAction:alertB];
//    [self presentViewController:alertC animated:YES completion:nil];
//}
-(void)initHeadView{
    UIView *headBackView = [UIView new];
    headBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headBackView];
    [headBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(0);
        make.height.equalTo(SafeAreaTopHeight);
    }];
    
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont boldSystemFontOfSize:17];
    _titleLabel.textColor = [UIColor textBlackColor];
    [_titleLabel setText:NSLocalizedString(@"钱包管理", nil)];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(SafeAreaTopHeight - 30);
        make.left.equalTo(45);
        make.width.equalTo(150);
        make.height.equalTo(20);
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
    
    _addWalletBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    [_addWalletBtn setBackgroundImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [_addWalletBtn addTarget:self action:@selector(addWalletBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_addWalletBtn];
    [_addWalletBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-20);
        make.top.equalTo(SafeAreaTopHeight - 29);
        make.width.equalTo(16);
        make.height.equalTo(16);
    }];
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.shadowView removeFromSuperview];
    [self.ipview removeFromSuperview];
    self.shadowView = nil;
    self.ipview = nil;
}

-(void)confirmBtnAction{
    self.password = self.ipview.passwordTextField.text;
    [self.view endEditing:YES];
    MJWeakSelf
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.shadowView.alpha = 0;
        
    } completion:^(BOOL finished) {
        if (weakSelf.password == nil || [weakSelf.password isEqualToString:@""]) {
            [weakSelf.view showMsg:NSLocalizedString(@"请输入密码", nil)];
            return;
        }
        BOOL passwordisright = [CreateAll VerifyPassword:weakSelf.password ForWalletAddress:[CreateAll GetCurrentUserName]];
        [weakSelf.view hideHUD];
        if (passwordisright == YES && weakSelf.deleteIndex >=0 && weakSelf.deleteIndex<weakSelf.importWalletArray.count) {
            MissionWallet *wallet = weakSelf.importWalletArray[weakSelf.deleteIndex];
            NSString *result = [CreateAll RemoveImportedWallet:wallet];
            [weakSelf.view showMsg:result];
            if ([result isEqualToString:NSLocalizedString(@"Delete Successed!", nil)]) {
                [weakSelf.importWalletArray removeObject:wallet];
                [weakSelf.collectionview reloadData];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                });
            }
        }else{
            [weakSelf.view showMsg:NSLocalizedString(@"密码错误", nil)];
        }
    }];
    
}




-(void)deleteWallet:(UIButton *)btn{
    self.deleteIndex = btn.tag;
    if (!_shadowView) {
        _shadowView = [UIView new];
        _shadowView.layer.shadowColor = [UIColor grayColor].CGColor;
        _shadowView.layer.shadowOffset = CGSizeMake(0, 0);
        _shadowView.layer.shadowOpacity = 1;
        _shadowView.layer.shadowRadius = 3.0;
        _shadowView.layer.cornerRadius = 3.0;
        _shadowView.clipsToBounds = NO;
    }
    [self.view addSubview:_shadowView];
    _shadowView.alpha = 0;
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
    MJWeakSelf
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.shadowView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}
#pragma collectionview *****************************
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    SectionHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerV" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        [view.remindlb setText:NSLocalizedString(@"当前身份下钱包", nil)];
    }else{
        [view.remindlb setText:NSLocalizedString(@"导入的钱包", nil)];
    }
    return view;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(ScreenWidth, 20);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(1, 1);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(ScreenWidth -36 , 120);//CGSizeMake(width, 300);
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return self.walletArray == nil? 0:self.walletArray.count;
    }else{
        return self.importWalletArray == nil? 0:self.importWalletArray.count;
    }
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WalletManagerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WalletManagerCell" forIndexPath:indexPath];
    MissionWallet *wallet = nil;
    if (indexPath.section == 0) {
        wallet = self.walletArray[indexPath.row];
    }else{
        wallet = self.importWalletArray[indexPath.row];
    }
    NSString *address = @"";
    if(wallet.address.length > 20){
        NSString *str1 = [wallet.address substringToIndex:9];
        NSString *str2 = [wallet.address substringFromIndex:wallet.address.length - 10];
        address = [NSString stringWithFormat:@"%@...%@",str1,str2];
    }
    if (wallet && (wallet.coinType == BTC || wallet.coinType == BTC_TESTNET)) {
        UIImage *backImage = [[UIImage alloc]createImageWithSize:CGSizeMake(312, 155) gradientColors:@[[UIColor colorWithHexString:@"#F29F00"],[UIColor colorWithHexString:@"#FDBF47"]] percentage:@[@(0.3),@(1)] gradientType:GradientFromLeftTopToRightBottom];
        [cell.backImageViewLeft setImage:backImage];
        [cell.backImageViewRight setImage:[UIImage imageNamed:@"bglogo1"]];
        if (wallet.walletType == IMPORT_WALLET && [wallet.walletName containsString:@"("]) {
            NSString *str0 = [wallet.walletName componentsSeparatedByString:@"("].lastObject;
            NSString *str1 = [str0 componentsSeparatedByString:@")"].firstObject;
            cell.namelb.text = [NSString stringWithFormat:@"BTC_wallet(%@)",str1];
        }else{
            cell.namelb.text = @"BTC_wallet";
        }
        
        cell.addressBtn.hidden = NO;
        cell.shortaddressBtn.hidden = YES;
        [cell.addressBtn setTitle:address forState:UIControlStateNormal];
        cell.addressBtn.tag =  indexPath.section * 100 + indexPath.row;
        [cell.addressBtn addTarget:self action:@selector(addressBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }else if(wallet && wallet.coinType == ETH){
        UIImage *backImage = [[UIImage alloc]createImageWithSize:CGSizeMake(312, 155) gradientColors:@[[UIColor colorWithHexString:@"#54D595"],[UIColor colorWithHexString:@"#76D9A8"]] percentage:@[@(0.3),@(1)] gradientType:GradientFromLeftTopToRightBottom];
        [cell.backImageViewLeft setImage:backImage];
        [cell.backImageViewRight setImage:[UIImage imageNamed:@"bglogo2"]];
        if (wallet.walletType == IMPORT_WALLET && [wallet.walletName containsString:@"("]) {
            NSString *str0 = [wallet.walletName componentsSeparatedByString:@"("].lastObject;
            NSString *str1 = [str0 componentsSeparatedByString:@")"].firstObject;
            cell.namelb.text = [NSString stringWithFormat:@"ETH_wallet(%@)",str1];
        }else{
            cell.namelb.text = @"ETH_wallet";
        }
        cell.addressBtn.hidden = NO;
        cell.shortaddressBtn.hidden = YES;
        [cell.addressBtn setTitle:address forState:UIControlStateNormal];
        cell.addressBtn.tag = indexPath.section  * 100 + indexPath.row;
        [cell.addressBtn addTarget:self action:@selector(addressBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }else if(wallet && wallet.coinType == MIS){
        UIImage *backImage = [[UIImage alloc]createImageWithSize:CGSizeMake(312, 155) gradientColors:@[[UIColor colorWithHexString:@"#4090F7"],[UIColor colorWithHexString:@"#57A8FF"]] percentage:@[@(0.3),@(1)] gradientType:GradientFromLeftTopToRightBottom];
        [cell.backImageViewLeft setImage:backImage];
        [cell.backImageViewRight setImage:[UIImage imageNamed:@"MIS"]];
        if (wallet.walletType == IMPORT_WALLET && [wallet.walletName containsString:@"("]) {
            NSString *str0 = [wallet.walletName componentsSeparatedByString:@"("].lastObject;
            NSString *str1 = [str0 componentsSeparatedByString:@")"].firstObject;
            cell.namelb.text = [NSString stringWithFormat:@"MIS_wallet(%@)",str1];
        }else{
            cell.namelb.text = @"MIS_wallet";
        }
        cell.addressBtn.hidden = YES;
        cell.shortaddressBtn.hidden = NO;
        [cell.shortaddressBtn setTitle:[wallet.walletName componentsSeparatedByString:@"_"].lastObject forState:UIControlStateNormal];
        cell.shortaddressBtn.tag = indexPath.section  * 100 + indexPath.row;
        [cell.shortaddressBtn addTarget:self action:@selector(addressBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }else if(wallet && wallet.coinType == EOS){
        UIImage *backImage = [[UIImage alloc]createImageWithSize:CGSizeMake(312, 155) gradientColors:@[RGB(56, 53, 84),RGB(56, 53, 84)] percentage:@[@(0.3),@(1)] gradientType:GradientFromLeftTopToRightBottom];
        [cell.backImageViewLeft setImage:backImage];
        [cell.backImageViewRight setImage:[UIImage imageNamed:@"EOS"]];
        if (wallet.walletType == IMPORT_WALLET) {
            cell.namelb.text = [NSString stringWithFormat:@"EOS_wallet(%d)",wallet.index];
        }else{
            cell.namelb.text = @"EOS_wallet";
        }
        cell.addressBtn.hidden = YES;
        cell.shortaddressBtn.hidden = NO;
        [cell.shortaddressBtn setTitle:[wallet.walletName componentsSeparatedByString:@"_"].lastObject forState:UIControlStateNormal];
        cell.shortaddressBtn.tag = indexPath.section  * 100 + indexPath.row;
        [cell.shortaddressBtn addTarget:self action:@selector(addressBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }else if(wallet && wallet.coinType == MGP){
        UIImage *backImage = [[UIImage alloc]createImageWithSize:CGSizeMake(312, 155) gradientColors:@[[UIColor colorWithHexString:@"#4090F7"],[UIColor colorWithHexString:@"#57A8FF"]] percentage:@[@(0.3),@(1)] gradientType:GradientFromLeftTopToRightBottom];
        [cell.backImageViewLeft setImage:backImage];
        [cell.backImageViewRight setImage:[UIImage imageNamed:@"MIS"]];
        if (wallet.walletType == IMPORT_WALLET) {
            cell.namelb.text = [NSString stringWithFormat:@"MGP_wallet(%d)",wallet.index];
        }else{
            cell.namelb.text = @"MGP_wallet";
        }
        cell.addressBtn.hidden = YES;
        cell.shortaddressBtn.hidden = NO;
        [cell.shortaddressBtn setTitle:[wallet.walletName componentsSeparatedByString:@"_"].lastObject forState:UIControlStateNormal];
        cell.shortaddressBtn.tag = indexPath.section  * 100 + indexPath.row;
        [cell.shortaddressBtn addTarget:self action:@selector(addressBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    if (indexPath.section == 0) {
        cell.deleteBtn.hidden = YES;
    }else{
        cell.deleteBtn.tag = indexPath.row;
        cell.deleteBtn.hidden = NO;
        [cell.deleteBtn addTarget:self action:@selector(deleteWallet:) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.exportBtn.tag =  indexPath.section * 100  + indexPath.row;
    [cell.exportBtn addTarget:self action:@selector(exportBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

//导出钱包
-(void)exportBtnAction:(UIButton *)btn{
    ExportWalletVC *evc = [ExportWalletVC new];
    MissionWallet *wallet = nil;
    if (btn.tag < 100) {
        wallet = self.walletArray[btn.tag];
    }else{
        wallet = self.importWalletArray[btn.tag - 100];
    }
    evc.wallet = wallet;
    [self.navigationController pushViewController:evc animated:YES];
}


//点击复制地址
-(void)addressBtnAction:(UIButton *)btn{
    MissionWallet *wallet = nil;
    if (btn.tag < 100) {
        wallet = self.walletArray[btn.tag];
    }else{
        wallet = self.importWalletArray[btn.tag - 100];
    }
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (wallet.coinType == BTC || wallet.coinType == ETH) {
        pasteboard.string = wallet.address;
        [self.view showMsg:NSLocalizedString(@"地址已复制", nil)];

    }else if(btn.titleLabel.text.length > 0){
        pasteboard.string = btn.titleLabel.text;
        [self.view showMsg:NSLocalizedString(@"地址已复制", nil)];

    }
    
//    NSLog(@"addressBtn %ld %@",btn.tag,pasteboard.string);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.collectionview selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    [self.collectionview scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    MissionWallet *wallet = nil;
    if (indexPath.section == 0) {
        wallet = self.walletArray[indexPath.row];
    }else{
        wallet = self.importWalletArray[indexPath.row];
    }
    [MGPHttpRequest shareManager].curretWallet = wallet;
    [[NSNotificationCenter defaultCenter]postNotificationName:CHANGECURRETWALLET object:nil];
    [[MGPHttpRequest shareManager]post:@"/user/userLogin" paramters:nil completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {

    }];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma lazy

-(UICollectionView *)collectionview{
    if (!_collectionview) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionview = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionview.dataSource = self;
        _collectionview.delegate = self;
        _collectionview.contentInset = UIEdgeInsetsMake(5, 5, -5, -5);
        _collectionview.backgroundColor = [UIColor whiteColor];
        _collectionview.showsVerticalScrollIndicator = NO;
        _collectionview.showsHorizontalScrollIndicator = NO;
        [_collectionview registerClass:[SectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerV"];
        [self.view addSubview:_collectionview];
        [_collectionview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.width.equalTo(ScreenWidth);
            make.top.equalTo(0);
            make.bottom.equalTo(0);
        }];
    }
    return _collectionview;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
