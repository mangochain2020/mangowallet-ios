//
//  LHDApp1TableViewController.m
//  TaiYiToken
//
//  Created by mac on 2020/8/11.
//  Copyright © 2020 admin. All rights reserved.
//

#import "LHDApp1TableViewController.h"
#import "LHDAppTableViewController.h"
#import <SDCycleScrollView.h>
#import "LHDAppTableViewCell.h"
#import "DCHandPickViewController.h"
#import "LHDAppModel.h"
#import "MangoDefiMainViewController.h"

@interface LHDApp1TableViewController ()

@property(weak, nonatomic) IBOutlet UIView *storyBoardBanner;
@property(strong, nonatomic) SDCycleScrollView *cycleScrollView;
@property(strong, nonatomic) NSMutableArray *listArray;


@end

@implementation LHDApp1TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"应用", nil);
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:_storyBoardBanner.bounds delegate:nil placeholderImage:nil];
    cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    cycleScrollView.autoScrollTimeInterval = 5.0;
    cycleScrollView.imageURLStringsGroup = @[@"banner1",@"banner3"];
    self.cycleScrollView = cycleScrollView;
    [self.storyBoardBanner addSubview:cycleScrollView];
    self.tableView.mj_header = [DCHomeRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(upRecData)];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.tableFooterView = [UIView new];
}

- (void)upRecData{

    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);//
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.listArray = [NSMutableArray array];
        [[MGPHttpRequest shareManager]post:@"/application/home" paramters:@{@"address":[MGPHttpRequest shareManager].curretWallet.address,@"type":@"1",@"lang":[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLanguageSelected"]} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
            dispatch_group_leave(group);
            
            if ([responseObj[@"code"] intValue] == 0) {
                            
                for (NSDictionary *dic in [responseObj[@"data"]objectForKey:@"app"]) {
                    
                    [self.listArray addObject:[LHDAppModel mj_objectWithKeyValues:dic]];
                }
                self.cycleScrollView.imageURLStringsGroup = [responseObj[@"data"]objectForKey:@"slider"];
            }
            
        }];
    });
   
    //二个网络请求都完成统一处理
    dispatch_group_notify(group, queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{

            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];

        });
        
    });
    
    
    
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
    LHDAppTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LHDAppTableViewCellIndex" forIndexPath:indexPath];

    LHDAppModel *model = self.listArray[indexPath.row];
    cell.tabLabel.text = model.tab;
    cell.titleLabel.text = model.title;
    cell.childTitleLabel.text = model.childTitle;
    [cell.cellImage sd_setImageWithURL:[NSURL URLWithString:model.img]];
    [cell.tabImage sd_setImageWithURL:[NSURL URLWithString:model.tabImg]];

    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    LHDAppModel *model = self.listArray[indexPath.row];
    switch (model.type) {
        case 1:
            [self performSegueWithIdentifier:@"LHDAppTableViewController" sender:nil];

            break;
        case 2:
        {
            DCHandPickViewController *vc = [[DCHandPickViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {
            MangoDefiMainViewController *vc = [MangoDefiMainViewController new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 5:
            [self performSegueWithIdentifier:@"ThemeVoteHomeTableViewControllerIndex" sender:nil];

            break;
            
        default:
            [self.view showMsg:NSLocalizedString(@"即将开放", nil)];

            break;
    }
    
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
