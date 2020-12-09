
//
//  DCMyCenterViewController.m
//  CDDStoreDemo
//
//  Created by 陈甸甸 on 2017/12/5.
//Copyright © 2017年 RocketsChen. All rights reserved.
//

#import "DCMyCenterViewController.h"
#import "LHSendTransactionViewController.h"

// Controllers
#import "DCManagementViewController.h" //账户管理
#import "DCGMScanViewController.h"  //扫一扫
#import "DCSettingViewController.h" //设置
#import "WalletManagerVC.h"

// Models
#import "DCGridItem.h"
#import "DCStateItem.h"
// Views
                               //顶部和头部View
#import "DCCenterTopToolView.h"
#import "DCMyCenterHeaderView.h"
                               //四组Cell
#import "DCCenterItemCell.h"
#import "DCCenterServiceCell.h"
#import "DCCenterBeaShopCell.h"
#import "DCCenterBackCell.h"
#import "DCFiveTableViewCell.h"

// Vendors
#import <MJExtension.h>
// Categories
#import "DCOrderListViewController.h"
#import "CommodityManagementVC.h"
#import "DCReceivingAddressViewController.h"
#import "SettlementViewController.h"
#import "LHWalletViewController.h"
#import "MangoDefiAddViewController.h"


// Others

@interface DCMyCenterViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL isMer; //是否商家
}
/* headView */
@property (strong , nonatomic)DCMyCenterHeaderView *headView;
/* 头部背景图片 */
@property (nonatomic, strong) UIImageView *headerBgImageView;
/* tableView */
@property (strong , nonatomic)UITableView *tableView;
/* 顶部Nva */
@property (strong , nonatomic)DCCenterTopToolView *topToolView;

/* 服务数据 */
@property (strong , nonatomic)NSMutableArray<DCGridItem *> *serviceItem;

@property (strong , nonatomic)DCMyCenterModel *centerModel;

@property (strong , nonatomic)NSDictionary *data;


@end

static NSString *const DCCenterItemCellID = @"DCCenterItemCell";
static NSString *const DCCenterServiceCellID = @"DCCenterServiceCell";
static NSString *const DCCenterBeaShopCellID = @"DCCenterBeaShopCell";
static NSString *const DCCenterBackCellID = @"DCCenterBackCell";
static NSString *const DCFiveTableViewCellID = @"DCFiveTableViewCell";

@implementation DCMyCenterViewController

#pragma mark - LazyLoad
- (UITableView *)tableView
{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.frame = CGRectMake(0, 0, ScreenW, ScreenH);
        [self.view addSubview:_tableView];
        
        [_tableView registerClass:[DCCenterItemCell class] forCellReuseIdentifier:DCCenterItemCellID];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DCCenterServiceCell class]) bundle:nil] forCellReuseIdentifier:DCCenterServiceCellID];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DCCenterBeaShopCell class]) bundle:nil] forCellReuseIdentifier:DCCenterBeaShopCellID];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DCCenterBackCell class]) bundle:nil] forCellReuseIdentifier:DCCenterBackCellID];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DCFiveTableViewCell class]) bundle:nil] forCellReuseIdentifier:DCFiveTableViewCellID];

    }
    return _tableView;
}

- (UIImageView *)headerBgImageView{
    if (!_headerBgImageView) {
        _headerBgImageView = [[UIImageView alloc] init];
        NSInteger armNum = [DCSpeedy dc_GetRandomNumber:1 to:9];
        [_headerBgImageView setImage:[UIImage imageNamed:@"mine_main_bg_10"]];
        [_headerBgImageView setBackgroundColor:[UIColor greenColor]];
        [_headerBgImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_headerBgImageView setClipsToBounds:YES];
    }
    return _headerBgImageView;
}

- (DCMyCenterHeaderView *)headView
{
    if (!_headView) {
        _headView = [DCMyCenterHeaderView dc_viewFromXib];
        _headView.frame =  CGRectMake(0, 0, ScreenW, 200);
    }
    return _headView;
}


- (NSMutableArray<DCGridItem *> *)serviceItem
{
    if (!_serviceItem) {
        _serviceItem = [NSMutableArray array];
    }
    return _serviceItem;
}

#pragma mark - LifeCyle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView reloadData];

    [self setUpBase];
    
    [self setUpData];

    [self setUpNavTopView];
    
    [self setUpHeaderCenterView];
    
    self.tableView.mj_header = [DCHomeRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(setUpData)];
//    [self.tableView.mj_header beginRefreshing];
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setUpData];
}

#pragma mark - 获取数据
- (void)setUpData
{
    isMer = YES;
    self.headView.messageLabel.text = @"";
    [[MGPHttpRequest shareManager]post:@"/appStore/isMers" paramters:@{@"address":[MGPHttpRequest shareManager].curretWallet.address} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
        if ([responseObj[@"code"]intValue] == 0) {

            self.data = responseObj;
            switch ([responseObj[@"data"]intValue]) {
                case 0:
                {
                    isMer = NO;
                    NSString *msg = responseObj[@"msg"];
                    self.headView.messageLabel.text = msg.length > 0 ? msg : @"";
                    [self.headView.leftItemButton setTitle:NSLocalizedString(@"钱包管理", nil) forState:UIControlStateNormal];

                }
                    break;
                case 1:
                {
                    isMer = YES;
                    [self.headView.leftItemButton setTitle:NSLocalizedString(@"商家入驻", nil) forState:UIControlStateNormal];
                    self.headView.messageLabel.text = responseObj[@"msg"];

                }
                    break;
                case 2:
                {
                    isMer = YES;
                    [self.headView.leftItemButton setTitle:NSLocalizedString(@"钱包管理", nil) forState:UIControlStateNormal];
                    self.headView.messageLabel.text = responseObj[@"msg"];

                }
                    break;
                case 3:
                {
                    isMer = NO;
                    [self.headView.leftItemButton setTitle:NSLocalizedString(@"商家入驻", nil) forState:UIControlStateNormal];
                    self.headView.messageLabel.text = responseObj[@"msg"];

                }
                    break;
                case 4:
                {
                    isMer = NO;
                    [self.headView.leftItemButton setTitle:NSLocalizedString(@"钱包管理", nil) forState:UIControlStateNormal];
                    self.headView.messageLabel.text = responseObj[@"msg"];

                }
                    break;
                case 5:
                {
                    isMer = NO;
                    [self.headView.leftItemButton setTitle:NSLocalizedString(@"商家入驻", nil) forState:UIControlStateNormal];
                    self.headView.messageLabel.text = responseObj[@"msg"];

                }
                    break;
                
                case 6:
                {
                    isMer = NO;
                    [self.headView.leftItemButton setTitle:NSLocalizedString(@"钱包管理", nil) forState:UIControlStateNormal];
                    self.headView.messageLabel.text = responseObj[@"msg"];

                }
                    break;
                default:
                    break;
            }
            
        }
        

        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }];
    self.headView.userName.text = [MGPHttpRequest shareManager].curretWallet.address;
    
    [[MGPHttpRequest shareManager]post:@"/appStore/getIncome" paramters:@{@"address":[MGPHttpRequest shareManager].curretWallet.address} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
        if ([responseObj[@"code"]intValue] == 0) {
            self.centerModel = [DCMyCenterModel mj_objectWithKeyValues:responseObj[@"data"]];
        }
        
        self.headView.userTypeImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"vip_shop%@",[responseObj[@"data"]objectForKey:@"partition"]]];
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }];
    
    
    
}

#pragma mark - 导航栏处理
- (void)setUpNavTopView
{
    _topToolView = [[DCCenterTopToolView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 64)];
    WEAKSELF
    _topToolView.leftItemClickBlock = ^{ //点击了扫描
//        [weakSelf.navigationController pushViewController:[DCGMScanViewController new] animated:YES];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    _topToolView.rightItemClickBlock = ^{ //点击设置
        [weakSelf.navigationController pushViewController:[DCSettingViewController new] animated:YES];
    };
   
    
    [self.view addSubview:_topToolView];
    
}


#pragma mark - initialize
- (void)setUpBase {
    
    self.view.backgroundColor = DCBGColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.tableFooterView = [UIView new]; //去除多余分割线
}

#pragma mark - 初始化头部
- (void)setUpHeaderCenterView{
    
    self.tableView.tableHeaderView = self.headView;
    self.headerBgImageView.frame = self.headView.bounds;
    [self.headView insertSubview:self.headerBgImageView atIndex:0]; //将背景图片放到最底层
    
    WEAKSELF
    self.headView.headClickBlock = ^{
//        DCManagementViewController *dcMaVc = [DCManagementViewController new];
//        [weakSelf.navigationController pushViewController:dcMaVc animated:YES];
    };
    self.headView.myFriendClickBlock = ^{
        [weakSelf.navigationController pushViewController:[DCReceivingAddressViewController new] animated:YES];
    };
    self.headView.friendCircleClickBlock = ^{
        /*
        if (!isMer) {
            if (weakSelf.centerModel.appUser) {
                [weakSelf.view showMsg:NSLocalizedString(@"已入驻", nil)];

            }else{
                [weakSelf.navigationController pushViewController:[SettlementViewController new] animated:YES];
            }
        }else{
            [weakSelf.navigationController pushViewController:[WalletManagerVC new] animated:YES];

        }*/
        int temp = [weakSelf.data[@"data"]intValue];
        if (temp == 1 || temp == 3 || temp == 5) {
            [weakSelf.navigationController pushViewController:[SettlementViewController new] animated:YES];

        }else{
            [weakSelf.navigationController pushViewController:[WalletManagerVC new] animated:YES];
        }
        

    };
}


#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return isMer ? 1 : 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cusCell = [UITableViewCell new];
    if (indexPath.section == 0) {
        DCCenterItemCell *cell = [tableView dequeueReusableCellWithIdentifier:DCCenterItemCellID forIndexPath:indexPath];
        
        NSArray *arr = [DCStateItem mj_objectArrayWithFilename:@"MyCenterFlow.plist"];
        DCStateItem *item0 = arr[0];
        item0.num = [NSString stringWithFormat:@"%ld",(long)self.centerModel.orders.prepay];

        DCStateItem *item1 = arr[1];
        item1.num = [NSString stringWithFormat:@"%ld",(long)self.centerModel.orders.prepare];

        DCStateItem *item2 = arr[2];
        item2.num = [NSString stringWithFormat:@"%ld",(long)self.centerModel.orders.goods];

        DCStateItem *item3 = arr[3];
        item3.num = [NSString stringWithFormat:@"%ld",(long)self.centerModel.orders.refund];
        
        cell.stateItem = [NSMutableArray arrayWithArray:@[item0,item1,item2,item3,arr[4]]];

        cell.callBackBlock = ^(NSInteger tag) {
            DCOrderListViewController *VC = [DCOrderListViewController new];
            switch (tag) {
                case 1:
                    VC.tag = 1;
                    break;
                case 2:
                    VC.tag = 3;
                    break;
                case 3:
                    VC.tag = 4;
                    break;
                case 4:
                    VC.tag = 6;
                    break;
                case 5:
                    VC.tag = 0;
                    break;
                    
                default:
                    break;
            }
            VC.isManagement = NO;
            [self.navigationController pushViewController:VC animated:YES];

        };
        cusCell = cell;
    }else if(indexPath.section == 5){
        DCCenterServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:DCCenterServiceCellID forIndexPath:indexPath];
        cell.serviceItemArray = [NSMutableArray arrayWithArray:_serviceItem];
        cusCell = cell;
    }else if (indexPath.section == 1){
        DCCenterBeaShopCell *cell = [tableView dequeueReusableCellWithIdentifier:DCCenterBeaShopCellID forIndexPath:indexPath];
        cell.isShop = NO;
        cell.orderBtn.tag = indexPath.section;
        cell.shopBtn.tag = indexPath.section;
        cell.mgpButton.tag = indexPath.section;
        [cell.orderBtn addTarget:self action:@selector(pushOrderListVC:) forControlEvents:UIControlEventTouchUpInside];
        [cell.shopBtn addTarget:self action:@selector(pushShopMango:) forControlEvents:UIControlEventTouchUpInside];
        [cell.mgpButton addTarget:self action:@selector(pushMgpMango:) forControlEvents:UIControlEventTouchUpInside];
        [cell.bondBtn addTarget:self action:@selector(pushbond:) forControlEvents:UIControlEventTouchUpInside];
        cell.myCenterModel = self.centerModel;
        cusCell = cell;
    }else if (indexPath.section == 3){
        DCCenterBackCell *cell = [tableView dequeueReusableCellWithIdentifier:DCCenterBackCellID forIndexPath:indexPath];
        cell.myCenterModel = self.centerModel;
        cusCell = cell;
    }else if (indexPath.section == 2){
        DCCenterBeaShopCell *cell = [tableView dequeueReusableCellWithIdentifier:DCCenterBeaShopCellID forIndexPath:indexPath];
        cell.orderBtn.tag = indexPath.section;
        cell.shopBtn.tag = indexPath.section;
        cell.mgpButton.tag = indexPath.section;
        [cell.controlButton addTarget:self action:@selector(pushShopMangoDefi) forControlEvents:UIControlEventTouchUpInside];
        cell.isShop = YES;
        cell.myCenterModel = self.centerModel;
        cusCell = cell;
    }
    
    return cusCell;
}
- (void)pushOrderListVC:(UIButton *)button{
    if (button.tag == 2) {return;}
    DCOrderListViewController *VC = [DCOrderListViewController new];
    VC.isManagement = YES;
    [self.navigationController pushViewController:VC animated:YES];
}
- (void)pushShopMango:(UIButton *)button{
    if (button.tag == 2) {return;}
    [self.navigationController pushViewController:[CommodityManagementVC new] animated:YES];
}
- (void)pushShopMangoDefi{
    MangoDefiAddViewController *vc = [MangoDefiAddViewController new];
    vc.model = self.centerModel;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)pushbond:(UIButton *)button{

    if (self.centerModel.top.isBindUsdt != 2) {
        UIStoryboard* secondStoryboard = [UIStoryboard storyboardWithName:@"ExchangeHome" bundle:[NSBundle mainBundle]];
        LHSendTransactionViewController *secondNavigationController = [secondStoryboard instantiateViewControllerWithIdentifier:@"LHSendTransactionViewController"];
        secondNavigationController.sendType = self.centerModel.top.isBindUsdt == 0 ? bondFirst : bond;
        [self.navigationController pushViewController:secondNavigationController animated:YES];
    }
    
}
- (void)pushMgpMango:(UIButton *)button{
    if (button.tag == 2) {return;}
    UIStoryboard* secondStoryboard = [UIStoryboard storyboardWithName:@"ExchangeHome" bundle:[NSBundle mainBundle]];
    LHWalletViewController *secondNavigationController = [secondStoryboard instantiateViewControllerWithIdentifier:@"LHWalletViewControllerIndex"];
    [self.navigationController pushViewController:secondNavigationController animated:YES];
}

#pragma mark - <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {//待付款Item组
//        return 300;
        return 90;
    }else if (indexPath.section == 5 && !isMer){
        return 215;
    }else if (indexPath.section == 1 && !isMer){
        return 280;
    }else if (indexPath.section == 3 && !isMer){
        return 200;
    }else if (indexPath.section == 2 && !isMer){
        return 280;
    }
    return 0;
}


#pragma mark - 滚动tableview 完毕之后
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
//    _topToolView.hidden = (scrollView.contentOffset.y < 0) ? YES : NO;
    
    _topToolView.backgroundColor = (scrollView.contentOffset.y > SafeAreaTopHeight) ? [UIColor whiteColor] : [UIColor clearColor];
    
    //图片高度
    CGFloat imageHeight = self.headView.dc_height;
    //图片宽度
    CGFloat imageWidth = ScreenW;
    //图片上下偏移量
    CGFloat imageOffsetY = scrollView.contentOffset.y;
    //上移
    if (imageOffsetY < 0) {
        CGFloat totalOffset = imageHeight + ABS(imageOffsetY);
        CGFloat f = totalOffset / imageHeight;
        self.headerBgImageView.frame = CGRectMake(-(imageWidth * f - imageWidth) * 0.5, imageOffsetY, imageWidth * f, totalOffset);
    }
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

    
}


@end



