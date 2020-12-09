//
//  LHStakeVoteRecordTableViewController.m
//  TaiYiToken
//
//  Created by mac on 2020/11/17.
//  Copyright © 2020 admin. All rights reserved.
//

#import "LHStakeVoteRecordTableViewController.h"
#import "LHMyExcitationTableViewCell.h"

@interface LHStakeVoteRecordTableViewController ()

@property(strong, nonatomic) NSMutableArray *listArray;

@end

@implementation LHStakeVoteRecordTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"投票列表", nil);
    self.tableView.rowHeight = 90;

    self.tableView.mj_header = [DCHomeRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(upRecData)];
    [self.tableView.mj_header beginRefreshing];
    
    
    
    
}
/// 加载数据
- (void)upRecData{
    self.listArray = [NSMutableArray array];
    NSString *mgp_bpvoting = [[DomainConfigManager share]getCurrentEvnDict][bpvoting];

    NSDictionary *dic = @{
        @"json": @1,
        @"code": mgp_bpvoting,
        @"scope":mgp_bpvoting,
        @"index_position":@"3",
        @"table":@"votes",
        @"key_type":@"i64",
        @"limit":@"500",
        @"lower_bound":[MGPHttpRequest shareManager].curretWallet.address,
        @"upper_bound":[MGPHttpRequest shareManager].curretWallet.address
    };

    [[HTTPRequestManager shareMgpManager] post:eos_get_table_rows paramters:dic success:^(BOOL isSuccess, id responseObject) {

        NSLog(@"voters：%@",responseObject);

        if (isSuccess) {
            NSArray *arr = (NSArray *)responseObject[@"rows"];
            for (NSDictionary *p in arr) {
//                if ([p[@"unvoted_at"]isEqualToString:@"1970-01-01T00:00:00.000"]) {
//                }
                [self.listArray insertObject:p atIndex:0];

            }
            
            [self.tableView reloadData];


        }
        [self.tableView.mj_header endRefreshing];

    } failure:^(NSError *error) {
        NSLog(@"%@",error);
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LHStakeVoteRecordTableViewCellIndex" forIndexPath:indexPath];
    UILabel *titleLabel = [cell.contentView viewWithTag:2020112001];
    UILabel *subTitleLabel = [cell.contentView viewWithTag:2020112002];
    NSDictionary *d = self.listArray[indexPath.row];

    titleLabel.text = d[@"owner"];
    subTitleLabel.text = d[@"quantity"];


    // Configure the cell...
    
    return cell;
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
