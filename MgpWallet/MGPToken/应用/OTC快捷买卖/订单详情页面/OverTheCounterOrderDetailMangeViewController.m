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
    OverTheCounterOrderDetailViewController *vc = [secondStoryboard instantiateViewControllerWithIdentifier:@"OverTheCounterOrderDetailViewControllerIndex"];
    vc.orderDetailType = self.orderDetailType;
    vc.dicData = self.dicData;
    
    
    
    
    
    OverTheCounterTitleView *titleView = [OverTheCounterTitleView dc_viewFromXib];
    titleView.rightIamge.hidden = YES;
    vc.titleView = titleView;
    self.listArray = @[vc];

    switch (self.orderDetailType) {
        case OrderDetailType_PaymentSeller://向卖家付款
        {
            self.title = NSLocalizedString(@"我的订单", nil);
            
            /*
            vc.orderPayType = 0;

            OverTheCounterOrderDetailViewController *vc1 = [secondStoryboard instantiateViewControllerWithIdentifier:@"OverTheCounterOrderDetailViewControllerIndex"];
            vc1.orderDetailType = self.orderDetailType;
            vc1.dicData = self.dicData;
            vc1.orderPayType = 1;
            vc1.titleView = titleView;

            OverTheCounterOrderDetailViewController *vc2 = [secondStoryboard instantiateViewControllerWithIdentifier:@"OverTheCounterOrderDetailViewControllerIndex"];
            vc2.orderDetailType = self.orderDetailType;
            vc2.dicData = self.dicData;
            vc2.orderPayType = 2;
            vc2.titleView = titleView;

            
            self.listArray = @[vc,vc1,vc2];*/
            NSMutableArray *tempArr = [NSMutableArray array];
            self.titleArray = [NSMutableArray array];
            
            [self.view showHUD];
            [[MGPHttpRequest shareManager]post:@"/moUsers/payInfo" isNewPath:YES paramters:@{@"mgpName":self.dicData[@"order_maker"]} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
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
                    self.listArray = tempArr;
                    [self addPageController];

                }
            }];
            

            
        }
            break;
        case OrderDetailType_WaitingSellerPass://等待卖家放行
            self.title = NSLocalizedString(@"我的订单", nil);

            
            break;
        case OrderDetailType_TransactionSuccessful://交易成功
            self.title = NSLocalizedString(@"我的订单", nil);

            
            break;
        case OrderDetailType_TransactionCancel://交易取消
            self.title = NSLocalizedString(@"我的订单", nil);

            
            break;
        case OrderDetailType_OnCommissionSale://委托出售中
            self.title = NSLocalizedString(@"委托出售MGP", nil);
            
            break;
        case OrderDetailType_Completed://已完成
            self.title = NSLocalizedString(@"委托出售MGP", nil);
            
            
            break;
        case OrderDetailType_BuyerPayment://待买家付款
            self.title = NSLocalizedString(@"我的订单", nil);
            
            
            break;
        case OrderDetailType_BuyerPaid://买家已付款
            self.title = NSLocalizedString(@"我的订单", nil);


            break;
        case OrderDetailType_Revoke://撤销
            self.title = NSLocalizedString(@"委托出售MGP", nil);
            
            
            break;
        default:
            break;
    }

    
    [self.view addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(0);
        make.height.equalTo(overTheCounterTitleViewheight);
    }];
    
    if (self.orderDetailType != OrderDetailType_PaymentSeller) {
        [self addPageController];
    }

    
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
    if (self.orderDetailType == OrderDetailType_PaymentSeller || self.orderDetailType == OrderDetailType_WaitingSellerPass) {
        return self.titleArray[index];

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
