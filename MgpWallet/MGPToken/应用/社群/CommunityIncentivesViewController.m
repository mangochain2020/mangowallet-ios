//
//  CommunityIncentivesViewController.m
//  TaiYiToken
//
//  Created by mac on 2020/7/24.
//  Copyright © 2020 admin. All rights reserved.
//

#import "CommunityIncentivesViewController.h"
#import "CommunityIncentivesTableViewCell.h"

@interface CommunityIncentivesViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(weak, nonatomic) IBOutlet UITableView *tableView;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;
@property(weak, nonatomic) IBOutlet UIView *topViewLeft;
@property(weak, nonatomic) IBOutlet UIView *topViewRight;
@property(weak, nonatomic) IBOutlet UIView *buttonSearch;

@property(weak, nonatomic) IBOutlet UILabel *left_top_title1;
@property(weak, nonatomic) IBOutlet UILabel *left_top_value1;

@property(weak, nonatomic) IBOutlet UILabel *left_top_title2;
@property(weak, nonatomic) IBOutlet UILabel *left_top_value2;

@property(weak, nonatomic) IBOutlet UILabel *left_top_title3;
@property(weak, nonatomic) IBOutlet UILabel *left_top_value3;

@property(weak, nonatomic) IBOutlet UILabel *left_top_title4;
@property(weak, nonatomic) IBOutlet UILabel *left_top_value4;

@property(weak, nonatomic) IBOutlet UILabel *center_title1;
@property(weak, nonatomic) IBOutlet UILabel *center_title2;
@property(weak, nonatomic) IBOutlet UILabel *center_title3;
@property(weak, nonatomic) IBOutlet UILabel *center_title4;
@property(weak, nonatomic) IBOutlet UILabel *center_title5;
@property(weak, nonatomic) IBOutlet UILabel *center_title6;
@property(weak, nonatomic) IBOutlet UILabel *center_title7;
@property(weak, nonatomic) IBOutlet UILabel *center_title8;
@property(weak, nonatomic) IBOutlet UILabel *center_title9;
@property(weak, nonatomic) IBOutlet UILabel *center_title5_right;
@property(weak, nonatomic) IBOutlet UILabel *center_title6_right;
@property(weak, nonatomic) IBOutlet UILabel *center_title7_right;
@property(weak, nonatomic) IBOutlet UILabel *center_title8_right;
@property(weak, nonatomic) IBOutlet UILabel *center_title9_right;

@property(weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, copy) NSMutableArray *teamListModel;
@property (nonatomic, strong) CommunityIncentiveModel *model;

@end

@implementation CommunityIncentivesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.teamListModel = [NSMutableArray array];
    self.title = NSLocalizedString(@"Mango社群", nil);
    self.left_top_title1.text = NSLocalizedString(@"昨日激励", nil);
    self.left_top_title2.text = NSLocalizedString(@"昨日分享激励", nil);
    self.left_top_title3.text = NSLocalizedString(@"昨日团队激励", nil);
    self.left_top_title4.text = NSLocalizedString(@"昨日轻节点激励", nil);
    self.center_title5.text = NSLocalizedString(@"我的分享指数", nil);
    self.center_title6.text = NSLocalizedString(@"层级指数", nil);
    self.center_title7.text = NSLocalizedString(@"轻节点", nil);
    self.center_title8.text = NSLocalizedString(@"小区业绩(币量)", nil);
    self.center_title9.text = NSLocalizedString(@"小区业绩(市值)", nil);
    self.textField.placeholder = NSLocalizedString(@"请输入MID", nil);
    
    
    
    
    self.tableView.mj_header = [DCHomeRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(realData)];
    [self.tableView.mj_header beginRefreshing];
}
- (void)realData{
    [[MGPHttpRequest shareManager]post:@"/user/mortgage" paramters:@{@"address":[MGPHttpRequest shareManager].curretWallet.address} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {

        if ([responseObj[@"code"]intValue] == 0){
            CommunityIncentiveModel *model = [CommunityIncentiveModel parse:responseObj[@"data"]];
            self.model = model;
            
            self.left_top_value1.text = model.yesterdayMoney;
            self.left_top_value2.text = model.yesterdayPushMoney;
            self.left_top_value3.text = model.yesterdayTeamMoney;
            self.left_top_value4.text = model.yesterdayLightNodeMoney;

            self.center_title5_right.text = model.myPushPro;
            self.center_title6_right.text = model.myFloor;
            self.center_title7_right.text = model.lightNodeFlag.boolValue ? NSLocalizedString(@"是", nil) : NSLocalizedString(@"否", nil);
            
            self.center_title8_right.text =  model.teamNum;
//            self.center_title9_right.text =  [NSString stringWithFormat:@"$%.2f",model.teamValue.doubleValue];
            self.center_title9_right.text = [NSString stringWithFormat:@"%@%.2f",[CreateAll GetCurrentCurrency].symbol,([[CreateAll GetCurrentCurrency].price doubleValue] * model.teamValue.doubleValue)];
            self.teamListModel = [NSMutableArray arrayWithArray:model.teamList];
            [self.tableView reloadData];

        }
        [self.tableView.mj_header endRefreshing];

    }];
    
}
- (IBAction)buttonClick:(id)sender {
    [self.teamListModel removeAllObjects];
    [self.view endEditing:YES];
    for (NSDictionary *dic in self.model.teamList) {
        if ([dic[@"code"] isEqualToString:self.textField.text]) {
            [self.teamListModel addObject:dic];
        }
    }
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.teamListModel.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommunityIncentivesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommunityIncentivesTableViewCellIndex" forIndexPath:indexPath];
    
    NSDictionary *dict = self.teamListModel[indexPath.row];
    
    [cell.titleLabel setTitle:dict[@"code"] forState:UIControlStateNormal];
    NSArray *arr = dict[@"roleList"];
    if (arr.count == 1) {
        NSString *s = arr.firstObject;
        cell.roleListLabel.text = [NSString stringWithFormat:@"(%@)",s];
    }else if (arr.count == 2){
        NSString *first = arr.firstObject;
        NSString *last = arr.lastObject;

        cell.roleListLabel.text = [NSString stringWithFormat:@"(%@)(%@)",first,last];
    }
    [cell.subTitleLabel setTitle:dict[@"teamAddress"] forState:UIControlStateNormal];
    cell.bottomLeftLabel.text = [NSString stringWithFormat:@"%@ MGP",dict[@"coinNum"]];
    NSString *d = dict[@"coinValue"];
    cell.bottomRightLabel.text = [NSString stringWithFormat:@"$%.2f",d.doubleValue];

    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

@implementation CommunityIncentiveModel


@end

