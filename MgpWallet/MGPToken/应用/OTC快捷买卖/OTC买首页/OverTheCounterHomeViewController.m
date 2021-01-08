//
//  OverTheCounterHomeViewController.m
//  TaiYiToken
//
//  Created by mac on 2020/12/29.
//  Copyright © 2020 admin. All rights reserved.
//

#import "OverTheCounterHomeViewController.h"
#import "OverTheCounterHomeTableViewCell.h"
#import <HWPanModal/HWPanModal.h>
#import "OverTheCounterOrderDetailMangeViewController.h"
#import "OverTheCounterMyOrderViewController.h"

#import "OverTheCounterBuyManageViewController.h"
#import "OverTheCounterSellHomeViewController.h"
#import "OverTheCounterSetTableViewController.h"

#import "OverTheCounterBuyViewController.h"


@interface OverTheCounterHomeViewController ()
{
    int buttonY;
    int isOverTheCounterContact;

}
@property(strong, nonatomic)NSMutableArray *listArray;
@property(strong, nonatomic) UIButton *flowButton;
@property (nonatomic, weak) XFDialogFrame *dialogView;

@end

@implementation OverTheCounterHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"快捷买卖MGP", nil);
    [[MGPHttpRequest shareManager]post:@"/moUsers/isBind" isNewPath:YES paramters:@{@"mgpName":[MGPHttpRequest shareManager].curretWallet.address,@"type":@"0"} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
        if ([responseObj[@"code"] intValue] == 0) {
            isOverTheCounterContact = [responseObj[@"data"] intValue];
            isOverTheCounterContact=0;
        }
    }];
    
   self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = 130;
   self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
   self.tableView.showsVerticalScrollIndicator = NO;
   [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 65, 0)];

   self.tableView.mj_header = [DCHomeRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(setUpData)];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(overTheCounterBuyNotification:) name:@"OverTheCounterBuyNotification" object:nil];
    
    [self setup];
    
    
}
-(void)dealloc{
    NSLog(@"0000");
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setUpData];    
}

#pragma mark - 获取数据
- (void)setUpData
{
    _listArray = [NSMutableArray array];
    NSString *mgp_otcstore = [[DomainConfigManager share]getCurrentEvnDict][otcstore];

    NSDictionary *dic = @{@"json": @1,@"code": mgp_otcstore,@"scope":mgp_otcstore,@"limit":@"500",@"table":@"selorders"};
    [[HTTPRequestManager shareMgpManager] post:eos_get_table_rows paramters:dic success:^(BOOL isSuccess, id responseObject) {
                
        if (isSuccess) {
            NSArray *arr = (NSArray *)responseObject[@"rows"];
            for (NSDictionary *dic in arr) {
                if (![dic[@"closed"]intValue]) {
                    [self.listArray insertObject:dic atIndex:0];
                }
            }
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    } superView:self.view showFaliureDescription:YES];
    
    
    
    
    
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.listArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OverTheCounterHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OverTheCounterHomeTableViewCellIndex" forIndexPath:indexPath];
    
    NSDictionary *dic = self.listArray[indexPath.row];
    
    //用户商家
    cell.ownerLabel.text = VALIDATE_STRING(dic[@"owner"]);
    //数量
    double quantity_str = [[dic[@"quantity"] componentsSeparatedByString:@" "].firstObject doubleValue];
    double frozen_quantity_str = [[dic[@"frozen_quantity"] componentsSeparatedByString:@" "].firstObject doubleValue];
    double fufilled_quantity_str = [[dic[@"fulfilled_quantity"] componentsSeparatedByString:@" "].firstObject doubleValue];
    double quantity = quantity_str - fufilled_quantity_str - frozen_quantity_str;
    
    cell.quantityLabel.text = [NSString stringWithFormat:@"%.4f MGP",quantity];
    cell.quantityLeftLabel.text = NSLocalizedString(@"数量", nil);

    //价格
    double price = [[dic[@"price"] componentsSeparatedByString:@" "].firstObject doubleValue];
    cell.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",price];
    cell.priceAssetLabel.text = @"/MGP";
   
    //限额
    double min_accept_quantity = [[dic[@"min_accept_quantity"] componentsSeparatedByString:@" "].firstObject doubleValue];
    cell.min_accept_quantityLabel.text = [NSString stringWithFormat:@"￥%.2f-￥%.2f",min_accept_quantity,quantity * price];
    cell.min_accept_quantityLeftLabel.text = NSLocalizedString(@"限额", nil);
    
    
    
    cell.buyButton.tag = indexPath.row;
    [cell.buyButton addTarget:self action:@selector(buyButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}
- (void)buyButtonClick:(UIButton *)btn {
    
    if (isOverTheCounterContact==0) {
        OverTheCounterBuyManageViewController *vc = [OverTheCounterBuyManageViewController new];
        vc.dic = self.listArray[btn.tag];
        [self presentPanModal:vc];
    }else{
        WEAKSELF; //
        NSDictionary *attrs = @{XFDialogNoticeText:NSLocalizedString(@"您还未添加联系方式，添加后方可进行购买MGP", nil), XFDialogCancelButtonTitle: NSLocalizedString(@"取消", nil), XFDialogCommitButtonTitle: NSLocalizedString(@"添加联系方式", nil),XFDialogTitleViewBackgroundColor:[UIColor whiteColor]};
        
        self.dialogView = [[[XFDialogNotice dialogWithTitle:NSLocalizedString(@"添加联系方式", nil) attrs:attrs commitCallBack:^(NSString *inputText) {
                        
            [weakSelf.dialogView hideWithAnimationBlock:nil];
            [self performSegueWithIdentifier:@"OverTheCounterSetTableViewControllerIndex" sender:nil];

        }] showWithAnimationBlock:nil]setCancelCallBack:nil];
        
    }
    
   
}
- (void)overTheCounterBuyNotification:(NSNotification *)notification{

//    OverTheCounterOrderDetailMangeViewController *vc = [OverTheCounterOrderDetailMangeViewController new];
//    vc.orderDetailType = OrderDetailType_PaymentSeller;
//    [self.navigationController pushViewController:vc animated:YES];

    OverTheCounterOrderDetailMangeViewController *vc = [OverTheCounterOrderDetailMangeViewController new];
    vc.orderDetailType = OrderDetailType_PaymentSeller;
    vc.dicData = notification.object;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}
- (IBAction)myOrderClickAction:(id)sender {
    [self.navigationController pushViewController:[OverTheCounterMyOrderViewController new] animated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(void)setup
{
    
//  添加悬浮按钮
    _flowButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _flowButton.alpha = 0.7;
    _flowButton.frame = CGRectMake(ScreenW-80, ScreenH - SafeAreaBottomHeight - 150, 70, 70);
    [_flowButton setBackgroundImage:[UIImage imageNamed:@"sellButtonImage_ch"] forState:UIControlStateNormal];
    [_flowButton addTarget:self action:@selector(sendClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView addSubview:_flowButton];
    [self.tableView bringSubviewToFront:_flowButton];
    buttonY=(int)_flowButton.frame.origin.y;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
   _flowButton.frame = CGRectMake(_flowButton.frame.origin.x, buttonY+self.tableView.contentOffset.y , _flowButton.frame.size.width, _flowButton.frame.size.height);
}
- (void)sendClick:(UIButton *)btn {
    
    UIStoryboard* secondStoryboard = [UIStoryboard storyboardWithName:@"OverTheCounter" bundle:[NSBundle mainBundle]];
    OverTheCounterSellHomeViewController *vc01 = [secondStoryboard instantiateViewControllerWithIdentifier:@"OverTheCounterSellHomeViewControllerIndex"];
    [self.navigationController pushViewController:vc01 animated:YES];

}




@end
