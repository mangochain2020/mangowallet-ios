//
//  LHRecordTableViewController.m
//  TaiYiToken
//
//  Created by mac on 2020/10/10.
//  Copyright © 2020 admin. All rights reserved.
//

#import "LHRecordTableViewController.h"
#import "LHMyExcitationTableViewCell.h"

@interface LHRecordTableViewController ()
{
    int page;
}
@property(strong, nonatomic) NSMutableArray *listArray;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (nonatomic, weak) XFDialogFrame *dialogView;

@end

@implementation LHRecordTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"记录", nil);
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = 80;
    self.tableView.mj_header = [DCHomeRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(upRecData)];
    [self.tableView.mj_header beginRefreshing];
    
    [self.tableView addFooterRefresh:^{
        page += 1;
        [self loadData];

    }];
    self.rightBtn.hidden = YES;
    
    switch (self.type) {
        case appStoreLifeOrderList:
            
            break;
            
        default:
            self.rightBtn.hidden = NO;
            [self.rightBtn setTitle:NSLocalizedString(@"注销", nil) forState:UIControlStateNormal];
            break;
    }
    
}
- (IBAction)canlClick:(id)sender {
    WEAKSELF
    self.dialogView = [[XFDialogNotice dialogWithTitle:NSLocalizedString(@"温馨提示", nil)
             attrs:@{
                     XFDialogMaskViewAlpha:@(0.f),
                     XFDialogEnableBlurEffect:@YES,
                     XFDialogTitleColor: [UIColor blackColor],
                     XFDialogNoticeText: NSLocalizedString(@"注销后本账户下发布的商品将不再支持USDT，您确定要注销？", nil),
                     }
    commitCallBack:^(NSString *inputText) {
        [weakSelf.dialogView hideWithAnimationBlock:nil];
        [[MGPHttpRequest shareManager]post:@"/userCashRefundOrder/refund" paramters:@{@"address":[MGPHttpRequest shareManager].curretWallet.address} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {

            if ([responseObj[@"code"]intValue] == 0) {

                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            
        }];
        
    }] showWithAnimationBlock:nil];
}

/// 加载数据
- (void)upRecData{
    page = 1;
    self.listArray = [NSMutableArray array];
    [self loadData];
}
- (void)loadData{
    NSString *url = @"";
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"address":[MGPHttpRequest shareManager].curretWallet.address,@"page":@(page),@"limit":@"10"}];
    
    switch (self.type) {
        case appStoreLifeOrderList:
            url = @"/api/appStoreLife/order/orderList";
            break;
            
        default:
            url = @"/userCash/getLog";
            break;
    }
    
    [[MGPHttpRequest shareManager]post:url paramters:dic completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
        if ([responseObj[@"code"] intValue] == 0) {
            
            
            switch (self.type) {
                case appStoreLifeOrderList:
                    for (NSDictionary *dic in [responseObj[@"data"]objectForKey:@"list"]) {
                        [self.listArray addObject:dic];
                    }
                    break;
                    
                default:
                    for (NSDictionary *dic in responseObj[@"data"]) {
                        [self.listArray addObject:dic];
                    }
                    break;
            }
            
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView endFooterRefresh];

    }];
    
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
    LHMyExcitationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LHPayOperationViewControllerIndex" forIndexPath:indexPath];
    NSDictionary *dic = self.listArray[indexPath.row];

    switch (self.type) {
        case appStoreLifeOrderList:
            cell.money.text = [NSString stringWithFormat:@"%.4f MGP",[dic[@"payNum"]doubleValue]];
            cell.createTime.text = [NSString stringWithFormat:@"%@",VALIDATE_STRING(dic[@"createTime"])];
            cell.channelName.text = [NSString stringWithFormat:@"%@(%@)",dic[@"orderName"],VALIDATE_STRING(dic[@"msg"])];
            cell.channelImage.image = [UIImage imageNamed:@"MGP_coin"];
            
            break;
            
        default:
            cell.money.text = [NSString stringWithFormat:@"%@ MGP",dic[@"money_str"]];
            cell.createTime.text = dic[@"createTime"];
            cell.channelName.text = dic[@"mark"];
            cell.channelImage.image = [UIImage imageNamed:@"MGP_coin"];
            break;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
