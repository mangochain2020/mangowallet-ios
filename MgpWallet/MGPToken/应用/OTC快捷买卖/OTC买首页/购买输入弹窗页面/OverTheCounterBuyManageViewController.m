//
//  OverTheCounterBuyManageViewController.m
//  TaiYiToken
//
//  Created by mac on 2020/12/29.
//  Copyright © 2020 admin. All rights reserved.
//

#import "OverTheCounterBuyManageViewController.h"
#import "OverTheCounterBuyViewController.h"
#import <HWPanModal/HWPanModal.h>
#import "ERSegmentController.h"
#import "OverTheCounterTitleView.h"

static int overTheCounterTitleViewheight = 70;

@interface OverTheCounterBuyManageViewController ()<ERPageViewControllerDataSource,ERSegmentControllerDelegte>

@property(strong, nonatomic)NSArray *listArray;

@end

@implementation OverTheCounterBuyManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIStoryboard* secondStoryboard = [UIStoryboard storyboardWithName:@"OverTheCounter" bundle:[NSBundle mainBundle]];
    OverTheCounterBuyViewController *vc00 = [secondStoryboard instantiateViewControllerWithIdentifier:@"OverTheCounterBuyViewControllerIndex"];
    vc00.isBuy = YES;
    vc00.dic = self.dic;

    OverTheCounterBuyViewController *vc01 = [secondStoryboard instantiateViewControllerWithIdentifier:@"OverTheCounterBuyViewControllerIndex"];
    vc01.isBuy = NO;
    vc01.dic = self.dic;

    self.listArray = @[vc00,vc01];
    
    [self addPageController];

    double price = [[self.dic[@"price"] componentsSeparatedByString:@" "].firstObject doubleValue];

    OverTheCounterTitleView *titleView = [OverTheCounterTitleView dc_viewFromXib];
    titleView.titleLabelR.text = NSLocalizedString(@"购买MGP", nil);
    titleView.subTitleLabelL.text = NSLocalizedString(@"单价", nil);
    titleView.subTitleLabelR.text = [NSString stringWithFormat:@"￥%.2f",price];
    titleView.subTitleLabelR.textColor = [UIColor orangeColor];
    titleView.titleLabelR.textColor = [UIColor blackColor];

    [self.view addSubview:titleView];
    
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(0);
        make.height.equalTo(overTheCounterTitleViewheight);
    }];
    
    
}




- (void)addPageController{
    
    ERSegmentController *pageVC = [[ERSegmentController alloc] init];
    pageVC.view.frame = CGRectMake(CGRectGetMinX(self.view.frame), overTheCounterTitleViewheight, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - SafeAreaBottomHeight-overTheCounterTitleViewheight);
    pageVC.segmentHeight = 40;
    pageVC.progressWidth = 80;
    pageVC.progressHeight = 2;
    pageVC.itemMinimumSpace = 3;
    pageVC.normalTextFont = [UIFont systemFontOfSize:16];
    pageVC.selectedTextFont = [UIFont systemFontOfSize:20];
//    pageVC.normalTextColor = [UIColor blackColor];
//    pageVC.selectedTextColor = [UIColor redColor];
    pageVC.delegate = self;
    pageVC.dataSource = self;
    [self.view addSubview:pageVC.view];
    [self addChildViewController:pageVC];

}


#pragma mark - ERPageViewControllerDataSource

- (NSInteger)numberOfControllersInPageViewController:(ERPageViewController *)pageViewController{
    return self.listArray.count;
}

- (UIViewController *)pageViewController:(ERPageViewController *)pageViewController childControllerAtIndex:(NSInteger)index{
    return self.listArray[index];
}
- (NSString *)pageViewController:(ERPageViewController *)pageViewController titleForChildControllerAtIndex:(NSInteger)index{
    return @[NSLocalizedString(@"按金额购买", nil),NSLocalizedString(@"按数量购买", nil)][index];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - HWPanModalPresentable

- (PanModalHeight)longFormHeight {

    return PanModalHeightMake(PanModalHeightTypeContent, 430);
}
- (BOOL)anchorModalToLongForm{
    return NO;
}

@end
