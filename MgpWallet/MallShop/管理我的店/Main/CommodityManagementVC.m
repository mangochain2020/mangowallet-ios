//
//  CommodityManagementVC.m
//  TaiYiToken
//
//  Created by mac on 2020/8/7.
//  Copyright © 2020 admin. All rights reserved.
//

#import "CommodityManagementVC.h"
#import "DCCommodityTableViewController.h"
#import "MyCommodityViewController.h"

@interface CommodityManagementVC ()

@end

@implementation CommodityManagementVC

#pragma mark - LifeCyle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = NSLocalizedString(@"商品管理", nil);
//    [[UINavigationBar appearance] setTranslucent:YES];
    UIButton *_scanBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    [_scanBtn setBackgroundImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [_scanBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_scanBtn];

    
    [self setUpAllChildViewController];

    [self setUpDisplayStyle:^(UIColor *__autoreleasing *titleScrollViewBgColor, UIColor *__autoreleasing *norColor, UIColor *__autoreleasing *selColor, UIColor *__autoreleasing *proColor, UIFont *__autoreleasing *titleFont, CGFloat *titleButtonWidth, BOOL *isShowPregressView, BOOL *isOpenStretch, BOOL *isOpenShade) {
        
        *titleFont = PFR16Font;      //字体尺寸 (默认fontSize为15)
        *norColor = [UIColor darkGrayColor];
        
        /*
         以下BOOL值默认都为NO
         */
        *isShowPregressView = YES;                      //是否开启标题下部Pregress指示器
        *isOpenStretch = YES;                           //是否开启指示器拉伸效果
        *isOpenShade = YES;                             //是否开启字体渐变
    }];

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [[UINavigationBar appearance] setTranslucent:NO];
    
}
- (void)rightBtnAction{
    MyCommodityViewController *vc = [MyCommodityViewController new];
    vc.collectionBlock = ^{
        self.selectIndex = 3;
        DCCommodityTableViewController *vc = self.childViewControllers[self.selectIndex];
        [vc.tableView.mj_header beginRefreshing];

    };
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark - 添加所有子控制器
- (void)setUpAllChildViewController
{
    DCCommodityTableViewController *vc00 = [DCCommodityTableViewController new];
    vc00.title = NSLocalizedString(@"销售中", nil);
    vc00.type = DCCommodityOnSale;
    [self addChildViewController:vc00];
    
    DCCommodityTableViewController *vc01 = [DCCommodityTableViewController new];
    vc01.title = NSLocalizedString(@"已售空", nil);
    vc01.type = DCCommoditySoldEmpty;
    [self addChildViewController:vc01];
    
    DCCommodityTableViewController *vc02 = [DCCommodityTableViewController new];
    vc02.title = NSLocalizedString(@"仓库中", nil);
    vc02.type = DCCommodityInWarehouse;
    [self addChildViewController:vc02];
    
    DCCommodityTableViewController *vc03 = [DCCommodityTableViewController new];
    vc03.title = NSLocalizedString(@"审核中", nil);
    vc03.type = DCCommodityExamine;
    [self addChildViewController:vc03];


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
