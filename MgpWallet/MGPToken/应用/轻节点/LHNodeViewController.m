//
//  LHNodeViewController.m
//  TaiYiToken
//
//  Created by mac on 2020/7/24.
//  Copyright © 2020 admin. All rights reserved.
//

#import "LHNodeViewController.h"

@interface LHNodeViewController ()

@property(weak, nonatomic) IBOutlet UITableView *tableView;

@property(weak, nonatomic) IBOutlet UILabel *left_top_title1;
@property(weak, nonatomic) IBOutlet UILabel *left_top_value1;

@property(weak, nonatomic) IBOutlet UILabel *left_top_title2;
@property(weak, nonatomic) IBOutlet UILabel *left_top_value2;

@property(weak, nonatomic) IBOutlet UILabel *center0_title1;
@property(weak, nonatomic) IBOutlet UILabel *center0_title2;
@property(weak, nonatomic) IBOutlet UILabel *center0_title3;
@property(weak, nonatomic) IBOutlet UILabel *center0_title4;
@property(weak, nonatomic) IBOutlet UILabel *center0_title5;


@end

@implementation LHNodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Mango节点", nil);

    self.left_top_title1.text = NSLocalizedString(@"昨日激励", nil);
    self.left_top_title2.text = NSLocalizedString(@"全网节点", nil);
    self.center0_title1.text = NSLocalizedString(@"昨日业绩", nil);
    self.center0_title4.text = NSLocalizedString(@"当前等级", nil);

    // Do any additional setup after loading the view.
    self.tableView.mj_header = [DCHomeRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(realData)];
    [self.tableView.mj_header beginRefreshing];
}
- (void)realData{
    [[MGPHttpRequest shareManager]post:@"/user/nodeIndex" paramters:@{@"address":[MGPHttpRequest shareManager].curretWallet.address} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {

        if ([responseObj[@"code"]intValue] == 0){
            LHNodeModel *model = [LHNodeModel parse:responseObj[@"data"]];
            self.left_top_value1.text = model.yesterdayMoney;
            self.left_top_value2.text = model.nodeNum;

            self.center0_title2.text = model.teamMoney;
//            self.center0_title3.text = [NSString stringWithFormat:@"$%@",model.teamValue];
            self.center0_title3.text = [NSString stringWithFormat:@"%@%.2f",[CreateAll GetCurrentCurrency].symbol,([[CreateAll GetCurrentCurrency].price doubleValue] * [model.teamValue doubleValue])];
            self.center0_title5.text = model.nodeLevel;

        }
        [self.tableView.mj_header endRefreshing];

    }];
    
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

@implementation LHNodeModel

@end
