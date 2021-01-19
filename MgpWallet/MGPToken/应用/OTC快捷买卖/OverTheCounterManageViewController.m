//
//  OverTheCounterManageViewController.m
//  TaiYiToken
//
//  Created by mac on 2020/12/29.
//  Copyright © 2020 admin. All rights reserved.
//

#import "OverTheCounterManageViewController.h"
#import "OverTheCounterHomeViewController.h"
#import "OverTheCounterSetTableViewController.h"
#import "JXButton.h"
#import "OverTheCounterMyOrderViewController.h"
#import "OverTheCounterSellHomeViewController.h"

#import "GQGridManagerView.h"

@interface OverTheCounterManageViewController ()<__GQGridManageDelegate>
@property (nonatomic, strong) GQGridManagerView *gridControl;

@end

@implementation OverTheCounterManageViewController

/**添加按钮点击代理*/
- (void)addItemButtonAction{
    for (int i =0 ; i<100; i++) {
        UIImage *image = [UIImage imageNamed:@"gridcontrol_add"];
        [_gridControl addItemWithImage:image];
    }
}

/**单击代理*/
- (void)gridItemDidClickedWithIndex:(NSInteger)index{
    
}

/*删除代理*/
- (void)gridItemDidDeleteWithIndex:(NSInteger)index{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _gridControl = [[GQGridManagerView alloc] initWithframe:CGRectMake(0, 0, 320, 480) withCanEdit:YES withDelegate:self];
    [_gridControl setItemWidth:50 withItemHeight:60 withRowMaxCount:4 ];
    [self.view addSubview:_gridControl];
    
    
    self.title = NSLocalizedString(@"快捷买卖MGP", nil);
    UIButton *_scanBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    [_scanBtn setBackgroundImage:[UIImage imageNamed:@"own_set"] forState:UIControlStateNormal];
    [_scanBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_scanBtn];

    
    [self setUpAllChildViewController];

    [self setUpDisplayStyle:^(UIColor *__autoreleasing *titleScrollViewBgColor, UIColor *__autoreleasing *norColor, UIColor *__autoreleasing *selColor, UIColor *__autoreleasing *proColor, UIFont *__autoreleasing *titleFont, CGFloat *titleButtonWidth, BOOL *isShowPregressView, BOOL *isOpenStretch, BOOL *isOpenShade) {
        
        *titleFont = PFR16Font;      //字体尺寸 (默认fontSize为15)
        *norColor = [UIColor darkGrayColor];
        *titleButtonWidth = 100;
        *selColor = [UIColor blackColor];
    }];
    
    [self setUpTitleScale:^(CGFloat *titleScale) {
        *titleScale = 0.85;
    }];
    
    
    
    
    JXButton *orderBtn = [[JXButton alloc] initWithFrame:CGRectMake(kScreenWidth-50, 1, 50, 40)];
    [orderBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [orderBtn setTitle:NSLocalizedString(@"订单", nil) forState:UIControlStateNormal];
    [orderBtn setImage:[UIImage imageNamed:@"quanbudindan"] forState:UIControlStateNormal];
    [orderBtn addTarget:self action:@selector(myOrderClickAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:orderBtn];
        
    
}

- (void)myOrderClickAction{
    [self.navigationController pushViewController:[OverTheCounterMyOrderViewController new] animated:YES];
}

- (void)rightBtnAction{
    UIStoryboard* secondStoryboard = [UIStoryboard storyboardWithName:@"OverTheCounter" bundle:[NSBundle mainBundle]];
    OverTheCounterSetTableViewController *vc = [secondStoryboard instantiateViewControllerWithIdentifier:@"OverTheCounterSetTableViewControllerIndex"];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 添加所有子控制器 
- (void)setUpAllChildViewController
{
    UIStoryboard* secondStoryboard = [UIStoryboard storyboardWithName:@"OverTheCounter" bundle:[NSBundle mainBundle]];
    OverTheCounterHomeViewController *vc00 = [secondStoryboard instantiateViewControllerWithIdentifier:@"OverTheCounterHomeViewControllerIndex"];
    vc00.title = NSLocalizedString(@"我要买", nil);
    [self addChildViewController:vc00];
    
    OverTheCounterSellHomeViewController *vc01 = [secondStoryboard instantiateViewControllerWithIdentifier:@"OverTheCounterSellHomeViewControllerIndex"];
    vc01.title = NSLocalizedString(@"我要卖", nil);
    [self addChildViewController:vc01];


}

/*
#pragma mark - Navigation [MallstoreADView dc_viewFromXib]

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
