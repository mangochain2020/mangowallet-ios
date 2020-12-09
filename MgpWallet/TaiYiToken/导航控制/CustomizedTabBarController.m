//
//  CustomizedTabBarController.m
//  TRProject
//
//  Created by tarena on 16/10/9.
//  Copyright © 2016年 Tedu. All rights reserved.
//

#import "CustomizedTabBarController.h"
#import "CustomTabBar.h"
#import "CustomizedNavigationController.h"
#import "HomeWalletViewController.h"


#import "UserInfoVC.h"
#import "NewsListVC.h"
#import "NewHomePageVC.h"
#import "JavascriptWebViewController.h"
#import "DappVC.h"
#import "VTwoMarketVC.h"
#import "HomePageVTwoVC.h"
@interface CustomizedTabBarController ()<CustomTabBarDelegate>
@property(nonatomic)double anglesec;
@property(nonatomic)double angle;
@property(nonatomic)double anglehour;
@property(nonatomic)NSInteger num;
@property(nonatomic)NSInteger t;
@property(nonatomic,strong)UIImageView *iv1;
@property(nonatomic,strong)UIImageView *iv2;
@property(nonatomic,strong)UIImageView *iv3;
@property(nonatomic,strong)UIImageView *iv4;
@property(nonatomic,strong)UIImageView *iv5;
@property(nonatomic,strong)UIView *vi;
@property(nonatomic,strong)UIImageView *imv;
@property(nonatomic)CGFloat alp;

@property(nonatomic,strong)NSArray *imageHelightArr;

@property(nonatomic,strong)CustomizedNavigationController *manNaVC;
@property(nonatomic,strong)CustomizedNavigationController *manNaVC1;
@property(nonatomic,strong)CustomizedNavigationController *manNaVC11;
@property(nonatomic,strong)CustomizedNavigationController *manNaVC111;
@property(nonatomic,strong)CustomizedNavigationController *manNaVC2;
@end

@implementation CustomizedTabBarController
static CustomizedTabBarController* _customizedTabBarController;


+(CustomizedTabBarController*)sharedCustomizedTabBarController{
    if (_customizedTabBarController == nil) {
        _customizedTabBarController = [CustomizedTabBarController new];
    }
    return _customizedTabBarController;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadViewController];
}

- (void)loadViewController
{
    HomeWalletViewController *manVC = [HomeWalletViewController new];
    manVC.view.backgroundColor = kRGBA(255, 255, 255, 1);
    _manNaVC = [[CustomizedNavigationController alloc] initWithRootViewController:manVC];
    
    VTwoMarketVC *manVC1 = [VTwoMarketVC new];
    manVC1.ifNeedRequestData = YES;
    manVC1.view.backgroundColor = kRGBA(255, 255, 255, 1);
    _manNaVC1 = [[CustomizedNavigationController alloc] initWithRootViewController:manVC1];
    [_manNaVC1.titlelb setText:NSLocalizedString(@"行情", nil)];

    NewsListVC *manVC11 = [NewsListVC new];
    manVC11.view.backgroundColor = kRGBA(255, 255, 255, 1);
    _manNaVC11 = [[CustomizedNavigationController alloc] initWithRootViewController:manVC11];
    [_manNaVC11.titlelb setText:NSLocalizedString(@"资讯", nil)];

    UserInfoVC *manVC111 = [UserInfoVC new];
    manVC111.view.backgroundColor = kRGBA(255, 255, 255, 1);
    _manNaVC111 = [[CustomizedNavigationController alloc] initWithRootViewController:manVC111];
    [_manNaVC111.titlelb setText:NSLocalizedString(@"我的", nil)];
  
    
//    self.viewControllers = @[_manNaVC,_manNaVC1,_manNaVC11,_manNaVC111];
    self.viewControllers = @[_manNaVC,_manNaVC11,_manNaVC111];
    self.selectedIndex = 0;
    [self setupTabBar];
    
}


- (void)setupTabBar
{
//    NSArray *titleArr = @[NSLocalizedString(@"首页", nil),NSLocalizedString(@"行情", nil),NSLocalizedString(@"资讯", nil),NSLocalizedString(@"我的", nil)];
//    NSArray *imageArr = @[@"wallet_default",@"hp_market_default",@"apps_default",@"own_default"];
//    NSArray *imageHelightArr = @[@"hp_asset_select",@"hp_market_select",@"apps_select",@"own_select"];
    NSArray *titleArr = @[NSLocalizedString(@"钱包", nil),NSLocalizedString(@"应用", nil),NSLocalizedString(@"我的", nil)];
    NSArray *imageArr = @[@"wallet_default",@"hp_market_default",@"own_default"];
    NSArray *imageHelightArr = @[@"hp_asset_select",@"hp_market_select",@"own_select"];
    for (int i = 0 ; i < titleArr.count; i++) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width/titleArr.count;
        CustomTabBar *bar = [[CustomTabBar alloc] initWithFrame:CGRectMake(0 + width * i, 0, width, 49) WithImage:[UIImage imageNamed:imageArr[i]] WithTitle:titleArr[i]];
        
        bar.imageHelight = [UIImage imageNamed:imageHelightArr[i]];
        bar.imageDefault = [UIImage imageNamed:imageArr[i]];
        [bar.titleLabel setFont:[UIFont boldSystemFontOfSize:10]];
        bar.index = i;
        bar.delegate = self;
       
        [self.tabBar addSubview:bar];
        self.tabBar.backgroundColor = [UIColor whiteColor];
        if (i == 0) {
            bar.selected = YES;
            [bar.iv setImage:bar.imageHelight];
            [bar.lb setTextColor:[UIColor textBlueColor]];
        }
    }
}


-(void)didSelectBarItemAtIndex:(NSInteger)index{
    [self resignBatStateExpectIndex:index];
    if (index == 0) {
        NSArray *arr = [self.tabBar subviews];
        for (CustomTabBar *bar in arr) {
            if ([bar isKindOfClass:[CustomTabBar class]] && bar.index == 0) {
                [bar setSelected:YES];
                [bar.lb setTextColor:[UIColor textBlueColor]];
                [bar.iv setImage:bar.imageHelight];
            }
        }
    }
    self.selectedViewController = self.viewControllers[index];
}

-(void)resetbartitle{
    NSArray *titleArr = @[NSLocalizedString(@"首页", nil),NSLocalizedString(@"行情", nil),NSLocalizedString(@"我的", nil)];
    NSArray *arr = [self.tabBar subviews];
    NSInteger i = 0;
    for (id bar in arr) {
        if ([bar isKindOfClass:[CustomTabBar class]]) {
            [((CustomTabBar *)bar).lb setText:titleArr[i]];
            i++;
        }
    }
}

-(void)resignBatStateExpectIndex:(NSInteger)index{
    NSArray *arr = [self.tabBar subviews];
    for (id bar in arr) {
        if ([bar isKindOfClass:[CustomTabBar class]]) {
            CustomTabBar *item = ((CustomTabBar *)bar);
            if (item.index != index) {
                [item setSelected:NO];
                [item.lb setTextColor:[UIColor lightGrayColor]];
                [item.iv setImage:item.imageDefault];
            }else{
                [item setSelected:YES];
                [item.lb setTextColor:[UIColor textBlueColor]];
                [item.iv setImage:item.imageHelight];
            }
        }
    }
}

- (void)changeViewController:(UIButton *)button
{
    self.selectedIndex = button.tag;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (UIView *)vi {
    if(_vi == nil) {
        _vi = [[UIView alloc] init];
        _vi.backgroundColor = [UIColor whiteColor];
        _imv = [UIImageView new];
        _imv.image = [UIImage imageNamed:@"LaunchImage"];
        [_vi addSubview:_imv];
        [_imv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
        
        [self.view addSubview:_vi];
        [_vi mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.top.equalTo(0);
            make.bottom.equalTo(49);
        }];
    }
    return _vi;
}

@end
