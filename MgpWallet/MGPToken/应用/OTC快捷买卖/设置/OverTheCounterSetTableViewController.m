//
//  OverTheCounterSetTableViewController.m
//  TaiYiToken
//
//  Created by mac on 2020/12/29.
//  Copyright © 2020 admin. All rights reserved.
//

#import "OverTheCounterSetTableViewController.h"
#import "OverTheCounterContactViewController.h"

//
@interface OverTheCounterSetTableViewController ()

@property (nonatomic,assign) BOOL isOTCAdmin; //是否管理者

@end

@implementation OverTheCounterSetTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    self.title = NSLocalizedString(@"我的设置", nil);

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSString *mgp_otcstore = [[DomainConfigManager share]getCurrentEvnDict][otcstore];

    NSDictionary *dic = @{
        @"json": @1,
        @"code": mgp_otcstore,
        @"scope":mgp_otcstore,
        @"table":@"global",
    };
    
    [[HTTPRequestManager shareMgpManager] post:eos_get_table_rows paramters:dic success:^(BOOL isSuccess, id responseObject) {

        if (isSuccess) {
            NSDictionary *dic = ((NSArray *)responseObject[@"rows"]).firstObject;
            NSArray *arr = (NSArray *)dic[@"otc_arbiters"];
            self.isOTCAdmin = [arr containsObject:[MGPHttpRequest shareManager].curretWallet.address];
            
            [self.tableView reloadData];
        }
        NSLog(@"%@",responseObject);

    } failure:^(NSError *error) {
    } superView:self.view showFaliureDescription:YES];
    
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return [super numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return [super tableView:tableView numberOfRowsInSection:section];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{

    return indexPath.row == 2 ? (_isOTCAdmin ? [super tableView:tableView heightForRowAtIndexPath:indexPath] : 0) : [super tableView:tableView heightForRowAtIndexPath:indexPath];
    
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
