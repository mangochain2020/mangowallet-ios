//
//  DCOrderListViewController.m
//  TaiYiToken
//
//  Created by mac on 2020/8/6.
//  Copyright © 2020 admin. All rights reserved.
//

#import "DCOrderListViewController.h"
#import "DCOrderListTableViewController.h"

@interface DCOrderListViewController ()

@end

@implementation DCOrderListViewController


#pragma mark - LifeCyle
- (void)viewDidLoad {
    
    [super viewDidLoad];

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
    self.selectIndex = self.tag;
    self.title = self.isManagement ? NSLocalizedString(@"商家订单中心", nil) : NSLocalizedString(@"订单中心", nil);
    for (DCOrderListTableViewController *vc in self.childViewControllers) {
        vc.isManagement = self.isManagement;
    }
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [[UINavigationBar appearance] setTranslucent:NO];
    
}
#pragma mark - 添加所有子控制器
- (void)setUpAllChildViewController
{
    DCOrderListTableViewController *vc00 = [DCOrderListTableViewController new];
    vc00.title = NSLocalizedString(@"全部", nil);
//    vc00.isManagement = self.isManagement;
    vc00.buyerRequestType = HYOrderBuyerRequestAll;
    [self addChildViewController:vc00];
    
    DCOrderListTableViewController *vc001 = [DCOrderListTableViewController new];
    vc001.title = NSLocalizedString(@"待支付", nil);
    vc001.buyerRequestType = HYOrderBuyerRequestWaitPay;
    [self addChildViewController:vc001];
    
    DCOrderListTableViewController *vc01 = [DCOrderListTableViewController new];
    vc01.title = NSLocalizedString(@"入账中", nil);
//    vc01.isManagement = self.isManagement;
    vc01.buyerRequestType = HYOrderBuyerRequestAccount;
    [self addChildViewController:vc01];
    
    DCOrderListTableViewController *vc02 = [DCOrderListTableViewController new];
    vc02.title = NSLocalizedString(@"待发货", nil);
//    vc02.isManagement = self.isManagement;
    vc02.buyerRequestType = HYOrderBuyerRequestWaitSend;
    [self addChildViewController:vc02];
    
    DCOrderListTableViewController *vc03 = [DCOrderListTableViewController new];
    vc03.title = NSLocalizedString(@"待收货", nil);
//    vc03.isManagement = self.isManagement;
    vc03.buyerRequestType = HYOrderBuyerRequestAlreadySend;
    [self addChildViewController:vc03];
    
    DCOrderListTableViewController *vc04 = [DCOrderListTableViewController new];
    vc04.title = NSLocalizedString(@"已完成", nil);
//    vc04.isManagement = self.isManagement;
    vc04.buyerRequestType = HYOrderBuyerRequestFirist;
    [self addChildViewController:vc04];
    
    DCOrderListTableViewController *vc05 = [DCOrderListTableViewController new];
    vc05.title = NSLocalizedString(@"退款/售后", nil);
//    vc05.isManagement = self.isManagement;
    vc05.buyerRequestType = HYOrderBuyerRequestReturn;
    [self addChildViewController:vc05];

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
