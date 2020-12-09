//
//  VoteRecordTableViewController.m
//  TaiYiToken
//
//  Created by mac on 2020/10/20.
//  Copyright © 2020 admin. All rights reserved.
//

#import "VoteRecordTableViewController.h"
#import "LHMyExcitationTableViewCell.h"

@interface VoteRecordTableViewController ()
{
    int page;
}
@property(strong, nonatomic) NSMutableArray *listArray;

@end

@implementation VoteRecordTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"奖金记录", nil);
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = 80;
    self.tableView.mj_header = [DCHomeRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(upRecData)];
    [self.tableView.mj_header beginRefreshing];
    
    WEAKSELF
    [self.tableView addFooterRefresh:^{
        page += 1;
        [weakSelf loadData];

    }];
}


/// 加载数据
- (void)upRecData{
    page = 1;
    self.listArray = [NSMutableArray array];
    [self loadData];
}
- (void)loadData{
    [[MGPHttpRequest shareManager]post:@"/voteTheme/getAward" paramters:@{@"address":[MGPHttpRequest shareManager].curretWallet.address,@"page":@(page),@"limit":@"10"} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
        if ([responseObj[@"code"] intValue] == 0) {
            
            for (NSDictionary *dic in responseObj[@"data"]) {
                [self.listArray addObject:dic];
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
    
    cell.money.text = [NSString stringWithFormat:@"%@ MGP",dic[@"money"]];
    cell.createTime.text = dic[@"createTime"];
    cell.channelName.text = dic[@"typeName"];
    cell.channelImage.image = [UIImage imageNamed:@"MGP_coin"];
    
    return cell;
}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
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
