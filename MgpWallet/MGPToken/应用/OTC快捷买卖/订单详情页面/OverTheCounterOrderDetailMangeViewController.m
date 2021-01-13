//
//  OverTheCounterOrderDetailMangeViewController.m
//  TaiYiToken
//
//  Created by mac on 2021/1/5.
//  Copyright © 2021 admin. All rights reserved.
//

#import "OverTheCounterOrderDetailMangeViewController.h"
#import "ERSegmentController.h"
#import "OverTheCounterOrderDetailViewController.h"
#import "OverTheCounterTitleView.h"

static int overTheCounterTitleViewheight = 70;

@interface OverTheCounterOrderDetailMangeViewController ()<ERPageViewControllerDataSource,ERSegmentControllerDelegte>

@property(strong, nonatomic)NSArray *listArray;
@property(strong, nonatomic)NSMutableArray *titleArray;

@end

@implementation OverTheCounterOrderDetailMangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIStoryboard* secondStoryboard = [UIStoryboard storyboardWithName:@"OverTheCounter" bundle:[NSBundle mainBundle]];

    OverTheCounterTitleView *titleView = [OverTheCounterTitleView dc_viewFromXib];
    titleView.rightIamge.hidden = YES;
    NSMutableArray *tempArr = [NSMutableArray array];
    self.titleArray = [NSMutableArray array];
    NSString *mgpName = @"";
    if (self.orderDetailType == OrderDetailType_OnCommissionSale
        || self.orderDetailType == OrderDetailType_Completed || self.orderDetailType == OrderDetailType_Revoke) {
        mgpName = self.dicData[@"owner"];
        self.title = NSLocalizedString(@"委托出售MGP", nil);

        OverTheCounterOrderDetailViewController *vc = [secondStoryboard instantiateViewControllerWithIdentifier:@"OverTheCounterOrderDetailViewControllerIndex"];
        vc.orderDetailType = self.orderDetailType;
        vc.dicData = self.dicData;
        vc.titleView = titleView;
        self.listArray = @[vc];
        [self addPageController];

    }else{
        mgpName = self.dicData[@"order_maker"];
        self.title = NSLocalizedString(@"我的订单", nil);
        [self.view showHUD];
        [[MGPHttpRequest shareManager]post:@"/moUsers/payInfo" isNewPath:YES paramters:@{@"mgpName":mgpName} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
            [self.view hideHUD];
            if ([responseObj[@"code"] intValue] == 0) {
                
                for (NSDictionary *dict in [responseObj[@"data"]objectForKey:@"payInfos"]) {
                    
                    OverTheCounterOrderDetailViewController *vc = [secondStoryboard instantiateViewControllerWithIdentifier:@"OverTheCounterOrderDetailViewControllerIndex"];
                    vc.orderDetailType = self.orderDetailType;
                    vc.dicData = self.dicData;
                    vc.orderPayType = [dict[@"payId"] intValue];
                    vc.titleView = titleView;
                    vc.sellPayInfo = dict;
                    vc.sellUserInfo = [responseObj[@"data"]objectForKey:@"userInfo"];
                    [tempArr addObject:vc];
                    if (vc.orderPayType == 1) {
                        [self.titleArray addObject:NSLocalizedString(@"银行卡", nil)];
                    }else if (vc.orderPayType == 2){
                        [self.titleArray addObject:NSLocalizedString(@"微信支付", nil)];

                    }else if (vc.orderPayType == 3){
                        [self.titleArray addObject:NSLocalizedString(@"支付宝", nil)];

                    }
                }

                if (self.orderDetailType == OrderDetailType_PaymentSeller) {
                    self.listArray = tempArr;

                }else if ([self.dicData[@"pay_type"] intValue] > 0){
                    int index = ([self.dicData[@"pay_type"] intValue]);
                    for (OverTheCounterOrderDetailViewController *vc in tempArr) {
                        if (vc.orderPayType == index) {
                            self.listArray = @[vc];
                        }
                    }

                }else{
                    self.listArray = @[tempArr.firstObject];

                }
                [self addPageController];

            }
        }];
    }
    
    
    
   
    [self.view addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(0);
        make.height.equalTo(overTheCounterTitleViewheight);
    }];
    
}




- (void)addPageController{
    
    ERSegmentController *pageVC = [[ERSegmentController alloc] init];
    pageVC.view.frame = CGRectMake(CGRectGetMinX(self.view.frame), overTheCounterTitleViewheight, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - SafeAreaBottomHeight-overTheCounterTitleViewheight);
    pageVC.segmentHeight = (self.orderDetailType == OrderDetailType_PaymentSeller || self.orderDetailType == OrderDetailType_WaitingSellerPass) ? 40 : 0;
    pageVC.progressWidth = (self.orderDetailType == OrderDetailType_PaymentSeller || self.orderDetailType == OrderDetailType_WaitingSellerPass) ? 80 : 0;
    pageVC.progressHeight = (self.orderDetailType == OrderDetailType_PaymentSeller || self.orderDetailType == OrderDetailType_WaitingSellerPass) ? 2 : 0;
    pageVC.itemMinimumSpace = (self.orderDetailType == OrderDetailType_PaymentSeller || self.orderDetailType == OrderDetailType_WaitingSellerPass) ? 10 : 0;
    pageVC.normalTextFont = [UIFont systemFontOfSize:17];
    pageVC.selectedTextFont = [UIFont systemFontOfSize:20];
    pageVC.normalTextColor = [UIColor blackColor];
    pageVC.selectedTextColor = [UIColor orangeColor];
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
    if (self.orderDetailType == OrderDetailType_PaymentSeller) {
        return self.titleArray[index];

    }else if (self.orderDetailType == OrderDetailType_WaitingSellerPass) {
        return self.titleArray[([self.dicData[@"pay_type"] intValue])];

    }else{
        return nil;
    }
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
