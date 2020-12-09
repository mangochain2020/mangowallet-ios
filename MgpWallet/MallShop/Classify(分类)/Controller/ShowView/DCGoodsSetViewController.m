//
//  DCGoodsSetViewController.m
//  CDDMall
//
//  Created by apple on 2017/6/12.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import "DCGoodsSetViewController.h"
#import "ProListItem.h"
#import "LrdSuperMenu.h"

// Controllers
#import "DCFootprintGoodsViewController.h"
#import "DCGoodDetailViewController.h"
// Models
#import "DCRecommendItem.h"
// Views
#import "DCNavSearchBarView.h"
#import "DCCustionHeadView.h"
#import "DCSwitchGridCell.h"
#import "DCListGridCell.h"
#import "DCColonInsView.h"
#import "DCSildeBarView.h"
#import "DCHoverFlowLayout.h"
// Vendors
#import <MJExtension.h>
#import "XWDrawerAnimator.h"
#import "UIViewController+XWTransition.h"
// Categories

// Others

@interface DCGoodsSetViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,LrdSuperMenuDataSource, LrdSuperMenuDelegate>
{
    int page;
}
@property (nonatomic, strong) LrdSuperMenu *menu;
/* scrollerVew */
@property (strong , nonatomic)UICollectionView *collectionView;
/* 搜索 */
@property (strong , nonatomic)UIView *topSearchView;
/* 搜索按钮 */
@property (strong , nonatomic)UIButton *searchButton;
/* 切换视图按钮 */
@property (strong , nonatomic)UIButton *switchViewButton;
/* 自定义头部View */
@property (strong , nonatomic)DCCustionHeadView *custionHeadView;
/* 具体商品数据 */
@property (strong , nonatomic)NSMutableArray<ProListItem *> *setItem;
/* 冒号工具View */
@property (strong , nonatomic)DCColonInsView *colonView;
/**
 0：列表视图，1：格子视图
 */
@property (nonatomic, assign) BOOL isSwitchGrid;
/* 滚回顶部按钮 */
@property (strong , nonatomic)UIButton *backTopButton;
/* 足迹按钮 */
@property (strong , nonatomic)UIButton *footprintButton;

@property (copy,nonatomic)NSString *price;//价格
@property (copy,nonatomic)NSString *sales;//销量
@property (copy,nonatomic)NSString *partition;//分区
@property (copy,nonatomic)NSString *recommend;//浏览量


@end

static CGFloat _lastContentOffset;

static NSString *const DCCustionHeadViewID = @"DCCustionHeadView";
static NSString *const DCSwitchGridCellID = @"DCSwitchGridCell";
static NSString *const DCListGridCellID = @"DCListGridCell";

@implementation DCGoodsSetViewController

#pragma mark  - 防止警告
- (NSString *)goodPlisName
{
    return nil;
}

#pragma mark - LazyLoad
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        DCHoverFlowLayout *layout = [DCHoverFlowLayout new];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.frame = CGRectMake(0, DCTopNavH+40, ScreenW, ScreenH - DCTopNavH);
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        

//        [_collectionView registerClass:[DCCustionHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DCCustionHeadViewID]; //头部View
        [_collectionView registerClass:[DCSwitchGridCell class] forCellWithReuseIdentifier:DCSwitchGridCellID];//cell
        [_collectionView registerClass:[DCListGridCell class] forCellWithReuseIdentifier:DCListGridCellID];//cell
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

#pragma mark - LifeCyle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.navigationController.navigationBar.barTintColor == DCBGColor)return;
    self.navigationController.navigationBar.barTintColor = DCBGColor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNav];
    
    [self setUpColl];

//    [self setUpSuspendView];
    
    self.collectionView.mj_header = [DCHomeRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(setUpData)];
    [self.collectionView.mj_header beginRefreshing];
    
    [self setUpUI];
    [self.collectionView addFooterRefresh:^{
        page += 1;
        [self filtrateButtonClick];

    }];
    
    
}

#pragma mark - initialize
- (void)setUpColl
{
    // 默认列表视图
    _isSwitchGrid = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = DCBGColor;
    self.collectionView.backgroundColor = self.view.backgroundColor;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

#pragma mark - 加载数据
- (void)setUpData
{
    self.price = @"";
    self.sales = @"";
    self.partition = @"";
    self.recommend = @"1";
    page = 1;
    _setItem = [NSMutableArray array];

    [self filtrateButtonClick];

    
}
#pragma mark - 导航栏
- (void)setUpNav
{
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -15;
    
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:@"flzq_nav_jiugongge"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"flzq_nav_list"] forState:UIControlStateSelected];
    button.frame = CGRectMake(0, 0, 44, 44);
    [button addTarget:self action:@selector(switchViewButtonBarItemClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, backButton];
    
    
    _topSearchView = [[UIView alloc] init];
    _topSearchView.backgroundColor = [UIColor whiteColor];
    _topSearchView.layer.cornerRadius = 16;
    [_topSearchView.layer masksToBounds];
    _topSearchView.frame = CGRectMake(50, 6, ScreenW - 110, 32);
    self.navigationItem.titleView = _topSearchView;
    
    _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_searchButton setTitle:NSLocalizedString(@"搜索商品/店铺", nil) forState:0];
    [_searchButton setTitleColor:[UIColor lightGrayColor] forState:0];
    _searchButton.titleLabel.font = PFR13Font;
    [_searchButton setImage:[UIImage imageNamed:@"group_home_search_gray"] forState:0];
    [_searchButton adjustsImageWhenHighlighted];
    _searchButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _searchButton.titleEdgeInsets = UIEdgeInsetsMake(0, 2 * DCMargin, 0, 0);
    _searchButton.imageEdgeInsets = UIEdgeInsetsMake(0, DCMargin, 0, 0);
    [_searchButton addTarget:self action:@selector(searchButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _searchButton.frame = CGRectMake(0, 0, _topSearchView.dc_width - 2 * DCMargin, _topSearchView.dc_height);
    [_topSearchView addSubview:_searchButton];
}

#pragma mark - 悬浮按钮
- (void)setUpSuspendView
{
    _backTopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_backTopButton];
    [_backTopButton addTarget:self action:@selector(ScrollToTop) forControlEvents:UIControlEventTouchUpInside];
    [_backTopButton setImage:[UIImage imageNamed:@"btn_UpToTop"] forState:UIControlStateNormal];
    _backTopButton.hidden = YES;
    _backTopButton.frame = CGRectMake(ScreenW - 50, ScreenH - 60, 40, 40);
    
    _footprintButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_footprintButton];
    [_footprintButton addTarget:self action:@selector(footprintButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_footprintButton setImage:[UIImage imageNamed:@"ptgd_icon_zuji"] forState:UIControlStateNormal];
    _footprintButton.frame = CGRectMake(ScreenW - 50, ScreenH - 60, 40, 40);
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _setItem.count;
}

#pragma mark - <UICollectionViewDelegate>
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DCListGridCell *cell = nil;
    cell = (_isSwitchGrid) ? [collectionView dequeueReusableCellWithReuseIdentifier:DCListGridCellID forIndexPath:indexPath] : [collectionView dequeueReusableCellWithReuseIdentifier:DCSwitchGridCellID forIndexPath:indexPath];
    
    ProListItem *proItem = _setItem[indexPath.row];

    DCRecommendItem *model = [DCRecommendItem new];
    model.main_title = proItem.storeName;
    model.image_url = proItem.image_url.firstObject;
    model.price = [NSString stringWithFormat:@"%.2f",proItem.price];
    model.stock = [NSString stringWithFormat:@"%d",(int)proItem.browse];
    cell.youSelectItem = model;
    
    WEAKSELF
    if (_isSwitchGrid) { //列表Cell
        __weak typeof(cell)weakCell = cell;
        cell.colonClickBlock = ^{ // 冒号点击
            __strong typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf setUpColonInsView:weakCell];
            [strongSelf.colonView setUpUI]; // 初始化
            strongSelf.colonView.collectionBlock = ^{
                NSLog(@"点击了收藏%zd",indexPath.row);
            };
            strongSelf.colonView.addShopCarBlock = ^{
                NSLog(@"点击了加入购物车%zd",indexPath.row);
            };
            strongSelf.colonView.sameBrandBlock = ^{
                NSLog(@"点击了同品牌%zd",indexPath.row);
            };
            strongSelf.colonView.samePriceBlock = ^{
                NSLog(@"点击了同价格%zd",indexPath.row);
            };
        };
    }
    
    return cell;
}
/*
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader){
        
        DCCustionHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DCCustionHeadViewID forIndexPath:indexPath];
        WEAKSELF
        headerView.filtrateClickBlock = ^{//点击了筛选
//            [weakSelf filtrateButtonClick:<#(NSString *)#> andSales:<#(NSString *)#>];
        };
        headerView.tuijianClickBlock = ^{//点击
            [weakSelf filtrateButtonClick:@"1" AndPrice:nil andSales:nil];
        };
        headerView.priceClickBlock = ^{//点击了
            [weakSelf filtrateButtonClick:nil AndPrice:@"1" andSales:nil];
        };
        headerView.browseClickBlock = ^{//点击了
            [weakSelf filtrateButtonClick:nil AndPrice:nil andSales:@"1"];
        };
        reusableview = headerView;
    }
    return reusableview;
}
*/
#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return (_isSwitchGrid) ? CGSizeMake(ScreenW, 120) : CGSizeMake((ScreenW - 4)/2, (ScreenW - 4)/2 + 60);//列表、网格Cell
}
/*
#pragma mark - head宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(ScreenW, 40); //头部
}
*/
#pragma mark - 边间距属性默认为0
#pragma mark - X间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 4;
    
}
#pragma mark - Y间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return (_isSwitchGrid) ? 0 : 4;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ProListItem *proModel = self.setItem[indexPath.row];

    DCGoodDetailViewController *dcVc = [[DCGoodDetailViewController alloc] init];
    dcVc.proModel = proModel;
    dcVc.goodTitle = proModel.storeName;
    dcVc.goodPrice = [NSString stringWithFormat:@"%.2f",proModel.price];
    dcVc.goodSubtitle = proModel.storeInfo;
    dcVc.shufflingArray = proModel.sliderImages;
    dcVc.goodImageView = proModel.image_url.firstObject;
    dcVc.postage = [NSString stringWithFormat:@"%ld",proModel.postage];
    dcVc.storeUnit = [NSString stringWithFormat:@"%@",proModel.storeType];
    dcVc.goodId = [NSString stringWithFormat:@"%ld",proModel.proID];
    [self.navigationController pushViewController:dcVc animated:YES];
    
    
    WEAKSELF
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.colonView.dc_x = ScreenW;
    }completion:^(BOOL finished) {
        [weakSelf.colonView removeFromSuperview];
    }];
}


#pragma mark - 滑动代理
//开始滑动的时候记录位置
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    _lastContentOffset = scrollView.contentOffset.y;
    
}
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    
    if(scrollView.contentOffset.y > _lastContentOffset){
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        self.collectionView.frame = CGRectMake(0, 20+40, ScreenW, ScreenH - 20-40);
        self.view.backgroundColor = [UIColor whiteColor];
    }else{
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        self.collectionView.frame = CGRectMake(0, DCTopNavH+40, ScreenW, ScreenH - DCTopNavH-40);
        self.view.backgroundColor = DCBGColor;
    }
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //判断回到顶部按钮是否隐藏
    _backTopButton.hidden = (scrollView.contentOffset.y > ScreenH) ? NO : YES;

    WEAKSELF
    [UIView animateWithDuration:0.25 animations:^{
        __strong typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.footprintButton.dc_y = (strongSelf.backTopButton.hidden == YES) ? ScreenH - 60 : ScreenH - 110;
    }];
    
}

#pragma mark - 冒号工具View
- (void)setUpColonInsView:(UICollectionViewCell *)cell
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ //单列
        _colonView = [[DCColonInsView alloc] init];
        
    });
    [cell addSubview:_colonView];
    
    _colonView.frame = CGRectMake(cell.dc_width, 0, cell.dc_width - 120, cell.dc_height);
    
    [UIView animateWithDuration:0.5 animations:^{
        _colonView.dc_x = 120;
    }];
}

#pragma mark - 点击事件

#pragma mark - 切换视图按钮点击
- (void)switchViewButtonBarItemClick:(UIButton *)button
{
    button.selected = !button.selected;
    _isSwitchGrid = !_isSwitchGrid;
    
    [_colonView removeFromSuperview];
    
    [self.collectionView reloadData];
}

#pragma mark - collectionView滚回顶部
- (void)ScrollToTop
{
    [self.collectionView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}
#pragma mark - 商品浏览足迹
- (void)footprintButtonClick
{
    [self setUpAlterViewControllerWith:[DCFootprintGoodsViewController alloc] WithDistance:ScreenW * 0.4];
}

#pragma mark - 商品筛选
- (void)filtrateButtonClick
{
    WEAKSELF
    [[MGPHttpRequest shareManager]post:@"/appStoreProduct/proList" paramters:@{@"cateId":self.cateId,@"page":@(page),@"limit":@"20",@"price":self.price,@"sales":self.sales,@"recommend":self.recommend,@"partition":self.partition} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {

        if ([responseObj[@"code"] intValue] == 0) {
            
            
            for (NSDictionary *dic in [responseObj[@"data"]objectForKey:@"proList"]) {
                [self.setItem addObject:[ProListItem mj_objectWithKeyValues:dic]];
            }
            
            [weakSelf.collectionView reloadData];

        }
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView endFooterRefresh];


        
    }];
    
    
    
    
//    [DCSildeBarView dc_showSildBarViewController];
}

#pragma mark - 点击搜索
- (void)searchButtonClick
{
    
}


#pragma mark - 转场动画弹出控制器
- (void)setUpAlterViewControllerWith:(UIViewController *)vc WithDistance:(CGFloat)distance
{
    XWDrawerAnimatorDirection direction = XWDrawerAnimatorDirectionRight;
    XWDrawerAnimator *animator = [XWDrawerAnimator xw_animatorWithDirection:direction moveDistance:distance];
    animator.parallaxEnable = YES;
    [self xw_presentViewController:vc withAnimator:animator];
    WEAKSELF
    [animator xw_enableEdgeGestureAndBackTapWithConfig:^{
        [weakSelf selfAlterViewback];
    }];
}

#pragma 退出界面
- (void)selfAlterViewback{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)setUpUI
{
    _menu = [[LrdSuperMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:44];
    _menu.delegate = self;
    _menu.dataSource = self;
    [self.view addSubview:_menu];
    
//    [_menu selectDeafultIndexPath];
}

- (NSInteger)numberOfColumnsInMenu:(LrdSuperMenu *)menu {
    return 2;
}
//每个column有多少行
- (NSInteger)menu:(LrdSuperMenu *)menu numberOfRowsInColumn:(NSInteger)column{
    switch (column) {
        case 0:
            return 5;
            break;
        case 1:
            return 6;
            break;
        default:
            break;
    }
    return 0;

}
//每个column中每行的title
- (NSString *)menu:(LrdSuperMenu *)menu titleForRowAtIndexPath:(LrdIndexPath *)indexPath{
    switch (indexPath.column) {
        case 0:
            return @[NSLocalizedString(@"推荐", nil),NSLocalizedString(@"价格升序", nil),NSLocalizedString(@"价格降序", nil),NSLocalizedString(@"销量升序", nil),NSLocalizedString(@"销量降序", nil)][indexPath.row];
            break;
        case 1:
            return @[NSLocalizedString(@"默认", nil),NSLocalizedString(@"A区", nil),NSLocalizedString(@"B区", nil),NSLocalizedString(@"C区", nil),NSLocalizedString(@"D区", nil),NSLocalizedString(@"E区", nil)][indexPath.row];
            break;
        default:
            break;
    }
    return @"";
}
- (void)menu:(LrdSuperMenu *)menu didSelectRowAtIndexPath:(LrdIndexPath *)indexPath {
    
    self.price = @"";
    self.sales = @"";
    self.partition = @"";
    self.recommend = @"";
    
    switch (indexPath.column) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    self.recommend = @"1";
                    break;
                case 1:
                    self.price = @"0";
                    break;
                case 2:
                    self.price = @"1";
                    break;
                case 3:
                    self.sales = @"0";
                    break;
                case 4:
                    self.sales = @"1";
                    break;
                    
                default:
                    break;
            }
            break;
        case 1:
            if (indexPath.row != 0) {
                self.recommend = @"1";
                self.partition = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
            }
            break;
        default:
            break;
    }
       
    [self filtrateButtonClick];
}

@end
