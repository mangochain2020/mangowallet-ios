//
//  ThemeVoteHomeTableViewController.m
//  TaiYiToken
//
//  Created by mac on 2020/10/19.
//  Copyright © 2020 admin. All rights reserved.
//

#import "ThemeVoteHomeTableViewController.h"
#import "ThemeVoteTableViewCell.h"
#import "ThemeVoteDetailViewController.h"
#import "LHSendThemeViewController.h"

@interface ThemeVoteHomeTableViewController ()
{
    int page;
    int buttonY;
}
@property(strong, nonatomic) NSMutableArray *listArray;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property(strong, nonatomic) UIButton *flowButton;


@end

@implementation ThemeVoteHomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"方案投票", nil);
    [self.rightBtn setTitle:NSLocalizedString(@"我的", nil) forState:UIControlStateNormal];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = 110;
    self.tableView.mj_header = [DCHomeRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(upRecData)];
//    [self.tableView.mj_header beginRefreshing];
    
    WEAKSELF
    [self.tableView addFooterRefresh:^{
        page += 1;
        [weakSelf loadData];

    }];
    [self setup];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self upRecData];

}


/// 加载数据
- (void)upRecData{
    page = 1;
    self.listArray = [NSMutableArray array];
    [self loadData];
}
- (void)loadData{
    [[MGPHttpRequest shareManager]post:@"/voteTheme/themes" paramters:@{@"address":[MGPHttpRequest shareManager].curretWallet.address,@"page":@(page),@"limit":@"10"} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
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
    ThemeVoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ThemeVoteTableViewCellIndex" forIndexPath:indexPath];
    
    NSDictionary *dic = self.listArray[indexPath.row];
    
    cell.rank.text = [NSString stringWithFormat:@"%d",[dic[@"sort"]intValue]];
    cell.address.text =dic[@"voteTitle"];
    cell.voteTitle.text = dic[@"voteContent"];
    cell.voteNum.text = [NSString stringWithFormat:@"%.2f%%",[dic[@"rate"] floatValue]*100];
    cell.voteP.progress = [dic[@"rate"] floatValue];
    NSString *type = @"";
    switch ([dic[@"type"]intValue]) {
        case 3:
            type = NSLocalizedString(@"投票", nil);

            break;
        case 4:
            type = NSLocalizedString(@"投票结束", nil);

            break;
        case 5:
            type = NSLocalizedString(@"待投票", nil);

            break;
        default:
            break;
    }
    cell.voteType.text = type;

    switch ([dic[@"sort"]intValue]) {
        case 1:
            cell.rank.textColor = RGB(254, 45, 70);
            break;
        case 2:
            cell.rank.textColor = RGB(255, 102, 0);

            break;
        case 3:
            cell.rank.textColor = RGB(250, 169, 14);

            break;
            
        default:
            cell.rank.textColor = RGB(145, 149, 163);

            break;
    }
    return cell;
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSDictionary *dic = self.listArray.firstObject;
    return dic == nil ? @"" : [NSString stringWithFormat:@"%@ / %@",VALIDATE_STRING(dic[@"voteStartTime"]),VALIDATE_STRING(dic[@"voteEndTime"])];
}

-(void)setup
{
    
//  添加悬浮按钮
    _flowButton=[[UIButton alloc]initWithFrame:CGRectMake(ScreenW-60, ScreenH-130, 50, 50) ];
    [_flowButton setImage:[UIImage imageNamed:@"icon_fenxiang2"] forState:UIControlStateNormal];
    [_flowButton addTarget:self action:@selector(sendClick:) forControlEvents:UIControlEventTouchUpInside];
    _flowButton.backgroundColor = [UIColor cyanColor];
    _flowButton.layer.masksToBounds = YES;
    _flowButton.layer.cornerRadius = 25;
    
    [self.tableView addSubview:_flowButton];
    [self.tableView bringSubviewToFront:_flowButton];
    buttonY=(int)_flowButton.frame.origin.y;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
   _flowButton.frame = CGRectMake(_flowButton.frame.origin.x, buttonY+self.tableView.contentOffset.y , _flowButton.frame.size.width, _flowButton.frame.size.height);
}
- (void)sendClick:(UIButton *)btn {
    
    
    btn.userInteractionEnabled = NO;
    [[MGPHttpRequest shareManager]post:@"/voteTheme/isScheme" paramters:@{@"address":[MGPHttpRequest shareManager].curretWallet.address} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
        btn.userInteractionEnabled = YES;

        if ([responseObj[@"code"]intValue] == 0) {

            [self.navigationController pushViewController:[LHSendThemeViewController new] animated:YES];
        }
        
    }];
    

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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.destinationViewController isKindOfClass:[ThemeVoteDetailViewController class]]) {
        ThemeVoteDetailViewController *vc = segue.destinationViewController;
        vc.dic = self.listArray[self.tableView.indexPathForSelectedRow.row];
    }
    
    
}


@end
