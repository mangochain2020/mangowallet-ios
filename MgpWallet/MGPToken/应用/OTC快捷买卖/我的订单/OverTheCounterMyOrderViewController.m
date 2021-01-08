//
//  OverTheCounterMyOrderViewController.m
//  TaiYiToken
//
//  Created by mac on 2020/12/29.
//  Copyright © 2020 admin. All rights reserved.
//

#import "OverTheCounterMyOrderViewController.h"
#import "OverTheCounterMyOrderTableViewController.h"

@interface OverTheCounterMyOrderViewController ()

@end

@implementation OverTheCounterMyOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpAllChildViewController];
    self.title = NSLocalizedString(@"我的订单", nil);

    [self setUpDisplayStyle:^(UIColor *__autoreleasing *titleScrollViewBgColor, UIColor *__autoreleasing *norColor, UIColor *__autoreleasing *selColor, UIColor *__autoreleasing *proColor, UIFont *__autoreleasing *titleFont, CGFloat *titleButtonWidth, BOOL *isShowPregressView, BOOL *isOpenStretch, BOOL *isOpenShade) {
        
        *titleFont = PFR16Font;      //字体尺寸 (默认fontSize为15)        
        /*
         以下BOOL值默认都为NO
         */
        *isShowPregressView = YES;                      //是否开启标题下部Pregress指示器
        *isOpenStretch = YES;                           //是否开启指示器拉伸效果
        *isOpenShade = YES;                             //是否开启字体渐变
        
        
    }];

    
}
#pragma mark - 添加所有子控制器 OverTheCounterHomeViewControllerIndex
- (void)setUpAllChildViewController
{
    
    UIStoryboard* secondStoryboard = [UIStoryboard storyboardWithName:@"OverTheCounter" bundle:[NSBundle mainBundle]];
    OverTheCounterMyOrderTableViewController *vc00 = [secondStoryboard instantiateViewControllerWithIdentifier:@"OverTheCounterMyOrderTableViewControllerIndex"];
    vc00.title = NSLocalizedString(@"购买MGP", nil);
    vc00.myOrderType = OverTheCounterMyOrderType_buy;
    [self addChildViewController:vc00];
    
    OverTheCounterMyOrderTableViewController *vc01 = [secondStoryboard instantiateViewControllerWithIdentifier:@"OverTheCounterMyOrderTableViewControllerIndex"];
    vc01.title = NSLocalizedString(@"出售MGP", nil);
    vc01.myOrderType = OverTheCounterMyOrderType_sell;
    [self addChildViewController:vc01];

    OverTheCounterMyOrderTableViewController *vc02 = [secondStoryboard instantiateViewControllerWithIdentifier:@"OverTheCounterMyOrderTableViewControllerIndex"];
    vc02.title = NSLocalizedString(@"我的委托", nil);
    vc02.myOrderType = OverTheCounterMyOrderType_myPos;
    [self addChildViewController:vc02];

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
