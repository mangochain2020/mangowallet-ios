//
//  WalletListViewController.m
//  TaiYiToken
//
//  Created by mac on 2020/7/10.
//  Copyright © 2020 admin. All rights reserved.
//
#import <HWPanModal/HWPanModal.h>
#import "WalletListViewController.h"
#import "WalletListTableViewCell.h"
#import "WalletListCollectionViewCell.h"

#import "ImportETHWalletVC.h"
#import "ImportBTCWalletVC.h"
#import "ImportEOSWalletVC.h"
#import "ImportMGPWalletVC.h"
#import "LHCreateViewController.h"


@interface WalletListViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSIndexPath *collectionSelectIndex;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *linkView;
@property (nonatomic, strong) NSArray *tableList;
@property (nonatomic, strong) NSArray *walletList;


@end

static NSString *const tableCellID = @"tableCell";

@implementation WalletListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.linkView];
    [self.collectionView registerNib:[UINib nibWithNibName:@"WalletListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    
//    self.tableList = @[@"MORE_coin",@"MGP_coin",@"ETH_coin",@"BTC_coin",@"EOS_coin",@"USDT_coin",@"CKB_coin",@"BCH_coin",@"DASH_coin",@"LTC_coin"];
    self.tableList = @[@"MORE_coin",@"MGP_coin",@"ETH_coin",@"EOS_coin"];
    //
    [self loadData];
    
}

- (void)loadData{
    NSArray *importwalletarray = [CreateAll GetImportWalletNameArray];

    NSArray *localwalletarray = [CreateAll GetWalletNameArray];
    
    switch (collectionSelectIndex.row) {
        case 0:
        {
            NSMutableArray *temp = [NSMutableArray array];
            for (NSString *s in importwalletarray) {
                MissionWallet *wallet = [CreateAll GetMissionWalletByName:s];
                [temp addObject:wallet];
            }
            
            NSMutableArray *temp1 = [NSMutableArray array];
            NSString *localeosMgpname = [[NSUserDefaults standardUserDefaults] objectForKey:@"LocalMGPWalletName"];
            MissionWallet *walletMGP = [CreateAll GetMissionWalletByName:VALIDATE_STRING(localeosMgpname)];
            [temp1 addObject:walletMGP];
            
            for (NSString *s in localwalletarray) {
                MissionWallet *wallet = [CreateAll GetMissionWalletByName:s];
//                [temp1 addObject:wallet];
                if (wallet.coinType == ETH) {
                    [temp1 addObject:wallet];
                }

            }
            

            NSString *localeosname = [[NSUserDefaults standardUserDefaults] objectForKey:@"LocalEOSWalletName"];
            MissionWallet *walletEOS = [CreateAll GetMissionWalletByName:VALIDATE_STRING(localeosname)];
            [temp1 addObject:walletEOS];
            
            self.walletList = @[temp1,temp];
        }
            break;
        case 1:
        {
            NSMutableArray *temp = [NSMutableArray array];
            NSString *localeosMgpname = [[NSUserDefaults standardUserDefaults] objectForKey:@"LocalMGPWalletName"];
            MissionWallet *walletMGP = [CreateAll GetMissionWalletByName:VALIDATE_STRING(localeosMgpname)];
            [temp addObject:walletMGP];
            for (NSString *s in importwalletarray) {
                MissionWallet *wallet = [CreateAll GetMissionWalletByName:s];
                if (wallet.coinType == MGP) {
                    [temp addObject:wallet];
                }
            }
            
//            for (NSString *s in localwalletarray) {
//                MissionWallet *wallet = [CreateAll GetMissionWalletByName:s];
//                if (wallet.coinType == MGP) {
//                    [temp addObject:wallet];
//                }
//            }
            self.walletList = @[temp];

        }
            break;
        case 2:
        {
            NSMutableArray *temp = [NSMutableArray array];
            for (NSString *s in importwalletarray) {
                MissionWallet *wallet = [CreateAll GetMissionWalletByName:s];
                if (wallet.coinType == ETH) {
                    [temp addObject:wallet];
                }
            }
            for (NSString *s in localwalletarray) {
                MissionWallet *wallet = [CreateAll GetMissionWalletByName:s];
                if (wallet.coinType == ETH) {
                    [temp addObject:wallet];
                }
            }
            self.walletList = @[temp];

        }
            break;
        case 4:
        {
            NSMutableArray *temp = [NSMutableArray array];
            for (NSString *s in importwalletarray) {
                MissionWallet *wallet = [CreateAll GetMissionWalletByName:s];
                if (wallet.coinType == BTC || wallet.coinType == BTC_TESTNET) {
                    [temp addObject:wallet];
                }
            }
            for (NSString *s in localwalletarray) {
                MissionWallet *wallet = [CreateAll GetMissionWalletByName:s];
                if (wallet.coinType == BTC || wallet.coinType == BTC_TESTNET) {
                    [temp addObject:wallet];
                }
            }
            self.walletList = @[temp];

        }
            break;
        case 3:
        {
            NSMutableArray *temp = [NSMutableArray array];
            NSString *localeosname = [[NSUserDefaults standardUserDefaults] objectForKey:@"LocalEOSWalletName"];
            MissionWallet *walletEOS = [CreateAll GetMissionWalletByName:VALIDATE_STRING(localeosname)];
            [temp addObject:walletEOS];
            for (NSString *s in importwalletarray) {
                MissionWallet *wallet = [CreateAll GetMissionWalletByName:s];
                if (wallet.coinType == EOS) {
                    [temp addObject:wallet];
                }
            }
//            for (NSString *s in localwalletarray) {
//                MissionWallet *wallet = [CreateAll GetMissionWalletByName:s];
//                if (wallet.coinType == EOS) {
//                    [temp addObject:wallet];
//                }
//            }
            self.walletList = @[temp];

        }
            break;
        default:
            break;
    }
    
    [self.tableView reloadData];
}

#pragma mark - lazy load

- (UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(self.collectionView.right, 0, self.view.width-self.collectionView.width, self.view.height-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 80;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor clearColor];

    }
    return _tableView;
}
- (UIView *)linkView{
    if (!_linkView) {
        _linkView = [[UIView alloc]initWithFrame:CGRectMake(self.collectionView.right-2, 0, 1, self.view.height)];
        _linkView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _linkView;
}

- (UICollectionView *)collectionView {

    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(60, 60);
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 0);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 75, self.view.frame.size.height) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
    }//
    return _collectionView;
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray *arr = self.walletList[section];
    return arr.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.walletList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    WalletListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WalletListTableViewCell"];
    if (!cell) {
        cell =  [[NSBundle mainBundle]loadNibNamed:@"WalletListTableViewCell" owner:self options:nil].firstObject;
    }
    cell.model = self.walletList[indexPath.section][indexPath.row];
    [cell.moreBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
    }

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.returnBlock(nil, self.walletList[indexPath.section][indexPath.row], ReloadDataWallet);
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)moreBtnClick:(UIButton *)sender{
    
    CGRect senderFrame = [sender convertRect:sender.bounds toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: senderFrame.origin];
    MissionWallet *model = self.walletList[indexPath.section][indexPath.row];
    self.returnBlock([LHCreateViewController new], model, PushWalletDetail);
    [self dismissViewControllerAnimated:YES completion:nil];

    
    
}
//自定义Header视图

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *view = [[UIView alloc]init];

    view.backgroundColor = [UIColor whiteColor];

    UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(5, 0, tableView.size.width-40, 30)];

    label1.text = collectionSelectIndex.row == 0 ? @[NSLocalizedString(@"身份下的钱包", nil),NSLocalizedString(@"创建/导入的钱包", nil)][section] : @[@"",@"mgpToken",@"Ethereum",@"eosio",@"Bitcoin"][collectionSelectIndex.row];

    
    label1.font = [UIFont systemFontOfSize:15.0f];

     UIButton *button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
     button1.frame = CGRectMake(label1.right, 0, 30, 30);
     [button1 setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    
     [button1 addTarget:self action:@selector(butClick:) forControlEvents:UIControlEventTouchUpInside];
    
     [view addSubview:button1];
    [view addSubview:label1];
    [button1 setHidden:collectionSelectIndex.row != 0 ? NO : YES];

    return view;



}
- (void)butClick:(UIButton*)btn
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction *alertT = [UIAlertAction actionWithTitle:NSLocalizedString(@"创建钱包", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        self.returnBlock([LHCreateViewController new], self.walletList.firstObject[0], PushCreateVC);
        
        
    }];
    UIAlertAction *alertR = [UIAlertAction actionWithTitle:NSLocalizedString(@"导入钱包", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
        
        if (collectionSelectIndex.row == 2) {
            self.returnBlock([ImportETHWalletVC new], nil, PushImportVC);
        }else if(collectionSelectIndex.row == 4){
            self.returnBlock([ImportBTCWalletVC new], nil, PushImportVC);
        }else if(collectionSelectIndex.row == 3){
            self.returnBlock([ImportEOSWalletVC new], nil, PushImportVC);
        }else if(collectionSelectIndex.row == 1){
            self.returnBlock([ImportMGPWalletVC new], nil, PushImportVC);
        }
        
    }];

    UIAlertAction *alertF = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];


    [actionSheet addAction:alertT];
    [actionSheet addAction:alertR];

    [actionSheet addAction:alertF];

    [self presentViewController:actionSheet animated:YES completion:nil];


}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.tableList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WalletListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.coinImage.image = [UIImage imageNamed:self.tableList[indexPath.row]];
    [cell.linkeView setHidden:collectionSelectIndex.row == indexPath.row ? NO : YES];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    collectionSelectIndex = indexPath;
    [self loadData];
    [self.collectionView reloadData];
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
//   [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)returnWithBlock:(ReturnBlock)block{
    self.returnBlock = block;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - HWPanModalPresentable

//- (PanModalHeight)shortFormHeight {
//
//    return PanModalHeightMake(PanModalHeightTypeContent, 500);
//}
- (CGFloat)topOffset{
    return SafeAreaTopHeight;
}
- (nullable UIScrollView *)panScrollable{
    return self.tableView;
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
