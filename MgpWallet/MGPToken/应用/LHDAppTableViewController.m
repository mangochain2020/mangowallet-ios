//
//  LHDAppTableViewController.m
//  TaiYiToken
//
//  Created by mac on 2020/7/22.
//  Copyright © 2020 admin. All rights reserved.
//

#import "LHDAppTableViewController.h"
#import <SDCycleScrollView.h>
#import "LHSendTransactionViewController.h"
#import "LHDAppModel.h"
#import "LHDAppTableViewCell.h"

@interface LHDAppTableViewController ()
{
    BOOL isPushClick;
    BOOL isLockAddress;
    BOOL showInvitation;
    BOOL showCommunityIncentivesNode;

}
@property(weak, nonatomic) IBOutlet UIView *storyBoardBanner;

@property(weak, nonatomic) IBOutlet UIButton *leftButton;
@property(weak, nonatomic) IBOutlet UIButton *rightButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnConstraint;

@property(strong, nonatomic) SDCycleScrollView *cycleScrollView;
@property(strong, nonatomic) NSMutableArray *listArray;
@property(copy, nonatomic) NSString *midNumber;

@end

@implementation LHDAppTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isPushClick = YES;
    isLockAddress = NO;
    showInvitation = NO;
    showCommunityIncentivesNode = NO;
    self.tableView.tableFooterView = [UIView new];
    self.title = NSLocalizedString(@"POS抵押", nil);
    [self.leftButton setTitle:NSLocalizedString(@"实时数据", nil) forState:UIControlStateNormal];
    [self.rightButton setTitle:NSLocalizedString(@"激励提取", nil) forState:UIControlStateNormal];

    
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:_storyBoardBanner.bounds delegate:nil placeholderImage:nil];
    cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    cycleScrollView.autoScrollTimeInterval = 5.0;
    cycleScrollView.imageURLStringsGroup = @[@"banner1",@"banner3"];
    self.cycleScrollView = cycleScrollView;
    [self.storyBoardBanner addSubview:cycleScrollView];
    self.tableView.mj_header = [DCHomeRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(upRecData)];
    [self.tableView.mj_header beginRefreshing];

    self.btnConstraint.constant = -(ScreenW-20);

}



- (void)upRecData{
    self.midNumber = @"";
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);//
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [[MGPHttpRequest shareManager]post:@"/user/show" paramters:@{@"mgpName":[MGPHttpRequest shareManager].curretWallet.address} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
            dispatch_group_leave(group);
            
            showCommunityIncentivesNode = [responseObj[@"code"] intValue] == 0 ? YES : NO;
            
        }];
    });
    dispatch_group_enter(group);//
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.listArray = [NSMutableArray array];
        [[MGPHttpRequest shareManager]post:@"/application/home" paramters:@{@"address":[MGPHttpRequest shareManager].curretWallet.address,@"type":@"0",@"lang":[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLanguageSelected"]} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
            dispatch_group_leave(group);
            
            if ([responseObj[@"code"] intValue] == 0) {
                for (NSDictionary *dic in [responseObj[@"data"]objectForKey:@"app"]) {
                    
                    [self.listArray addObject:[LHDAppModel mj_objectWithKeyValues:dic]];
                }
                self.cycleScrollView.imageURLStringsGroup = [responseObj[@"data"]objectForKey:@"slider"];
            }
            
        }];
    });
    dispatch_group_enter(group);//
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [[MGPHttpRequest shareManager]post:@"/user/findMgp" paramters:@{@"mgpName":[MGPHttpRequest shareManager].curretWallet.address} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
            dispatch_group_leave(group);
            
            showInvitation = [responseObj[@"code"] intValue] == 0 ? NO : YES;
            if ([responseObj[@"code"] intValue] == 0) {
                self.midNumber = [responseObj[@"data"]objectForKey:@"lnvitationCode"];
                isPushClick = YES;
                
            }else{
                isPushClick = NO;
            }
            self.btnConstraint.constant = isPushClick ? 0 : -(ScreenW-20);

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
- (IBAction)letfButtonClick:(id)sender {

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
    if (model.type == 2) {
        cell.titleRightLabel.text = isPushClick ? self.midNumber : @"";
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    LHDAppModel *model = self.listArray[indexPath.row];
    switch (model.type) {
        case 2:
        {
            if (isPushClick) {
                [UIPasteboard generalPasteboard].string = self.midNumber;
                [self.view showMsg:NSLocalizedString(@"已复制", nil)];
            }else{
                //跳转抵押页面
                [self performSegueWithIdentifier:@"LHSendTransactionViewController" sender:nil];
            }
        }
            break;
        case 1:
            [self performSegueWithIdentifier:@"CurrencyIncentiveViewControllerIndex" sender:nil];

            break;
        case 3:
            [self performSegueWithIdentifier:@"CommunityIncentivesViewControllerIndex" sender:nil];

            break;
        case 4:
            [self performSegueWithIdentifier:@"LHNodeViewControllerIndex" sender:nil];

            break;
            
        default:
            break;
    }
    
    
}
/*
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return [super numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return [super tableView:tableView numberOfRowsInSection:section];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        if (isPushClick) {
            [UIPasteboard generalPasteboard].string = self.midNumber.text;
            [self.view showMsg:NSLocalizedString(@"复制成功", nil)];
        }else{
            //跳转抵押页面
            [self performSegueWithIdentifier:@"LHSendTransactionViewController" sender:nil];
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
    case 0:
            return showInvitation ? 0 : showCommunityIncentivesNode ? [super tableView:tableView heightForRowAtIndexPath:indexPath] : 0;
    case 2:
            return showCommunityIncentivesNode ? [super tableView:tableView heightForRowAtIndexPath:indexPath] : 0;
    case 3:
            return showCommunityIncentivesNode ? [super tableView:tableView heightForRowAtIndexPath:indexPath] : 0;
    default:
            return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
 
    switch (section) {
    case 0:
            return showInvitation ? 0 : showCommunityIncentivesNode ? [super tableView:tableView heightForHeaderInSection:section] : 0;
    case 2:
            return showCommunityIncentivesNode ? [super tableView:tableView heightForHeaderInSection:section] : 0;
    case 3:
            return showCommunityIncentivesNode ? [super tableView:tableView heightForHeaderInSection:section] : 0;
    default:
            return [super tableView:tableView heightForHeaderInSection:section];
    }
}*/
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.destinationViewController isKindOfClass:[LHSendTransactionViewController class]]) {
        LHSendTransactionViewController *vc = segue.destinationViewController;
        vc.sendType = bindMID;
    }
}


@end
