//
//  OverTheCounterPaymentTableViewController.m
//  TaiYiToken
//
//  Created by mac on 2020/12/30.
//  Copyright © 2020 admin. All rights reserved.
//

#import "OverTheCounterPaymentTableViewController.h"
#import "OverTheCounterPaymentTableViewCell.h"
#import "OverTheCounterAddPaymentViewController.h"

@interface OverTheCounterPaymentTableViewController ()

@property(strong, nonatomic)NSMutableArray *listArray;

@end

@implementation OverTheCounterPaymentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 110;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.mj_header = [DCHomeRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(setUpData)];
    [self.tableView.mj_header beginRefreshing];
    self.title = NSLocalizedString(@"收款方式", nil);

    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setUpData];
}
- (void)setUpData{
    [[MGPHttpRequest shareManager]post:@"/moPayInfo/list" isNewPath:YES paramters:@{@"mgpName":[MGPHttpRequest shareManager].curretWallet.address} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
        if ([responseObj[@"code"]intValue] == 0) {
            self.listArray = [NSMutableArray arrayWithArray:responseObj[@"data"]];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
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
    OverTheCounterPaymentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OverTheCounterPaymentTableViewCellIndex" forIndexPath:indexPath];
    
    NSDictionary *dic = self.listArray[indexPath.row];
    cell.payTypeLabel.text = VALIDATE_STRING(dic[@"name"]);
    cell.name.text = dic[@"username"];
    cell.account.text = dic[@"cardNum"];

    cell.collectionImageView.hidden = NO;
    switch ([dic[@"payId"]intValue]) {
        case 1:
            cell.collectionImageView.hidden = YES;
            cell.payImageView.image = [UIImage imageNamed:@"yl_"];
            break;
        case 2:
            cell.payImageView.image = [UIImage imageNamed:@"wx_"];
            break;
            
        default:
            cell.payImageView.image = [UIImage imageNamed:@"zfb_"];

            break;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OverTheCounterAddPaymentViewController *vc = [OverTheCounterAddPaymentViewController new];
    NSDictionary *dic = self.listArray[indexPath.row];
    vc.payType = [dic[@"payId"]intValue];
    vc.model = dic;
    [self.navigationController pushViewController:vc animated:YES];
}

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
