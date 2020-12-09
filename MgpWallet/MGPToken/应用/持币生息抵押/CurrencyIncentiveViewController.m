//
//  CurrencyIncentiveViewController.m
//  TaiYiToken
//
//  Created by mac on 2020/7/27.
//  Copyright © 2020 admin. All rights reserved.
//

#import "CurrencyIncentiveViewController.h"
#import "LHSendTransactionViewController.h"

@interface CurrencyIncentiveViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(weak, nonatomic) IBOutlet UIButton *earnMoneyBotton;
@property(weak, nonatomic) IBOutlet UIButton *shuhuiButton;

@property(weak, nonatomic) IBOutlet UILabel *yesterday_pool;
@property(weak, nonatomic) IBOutlet UILabel *yesterdayValue;

@property(weak, nonatomic) IBOutlet UILabel *power;
@property(weak, nonatomic) IBOutlet UILabel *powerValue;

@property(weak, nonatomic) IBOutlet UILabel *center_title0;
@property(weak, nonatomic) IBOutlet UILabel *center_title1;
@property(weak, nonatomic) IBOutlet UILabel *center_title2;

@property(weak, nonatomic) IBOutlet UILabel *center_title3;
@property(weak, nonatomic) IBOutlet UILabel *center_title5;
@property(weak, nonatomic) IBOutlet UILabel *center_title6;
@property(weak, nonatomic) IBOutlet UILabel *center_title7;
@property(weak, nonatomic) IBOutlet UILabel *center_title8;

@property(weak, nonatomic) IBOutlet UILabel *center_title9;
@property(weak, nonatomic) IBOutlet UILabel *center_title10;
@property(weak, nonatomic) IBOutlet UILabel *center_title11;
@property(weak, nonatomic) IBOutlet UILabel *center_title12;
@property(weak, nonatomic) IBOutlet UILabel *center_title13;
@property(weak, nonatomic) IBOutlet UILabel *center_title14;
@property(weak, nonatomic) IBOutlet UILabel *center_title15;


@property(weak, nonatomic) IBOutlet UILabel *center_title0_right;
@property(weak, nonatomic) IBOutlet UILabel *center_title1_right;
@property(weak, nonatomic) IBOutlet UILabel *center_title2_right;

@property(weak, nonatomic) IBOutlet UILabel *center_title3_right;
@property(weak, nonatomic) IBOutlet UILabel *center_title5_right;
@property(weak, nonatomic) IBOutlet UILabel *center_title6_right;
@property(weak, nonatomic) IBOutlet UILabel *center_title7_right;
@property(weak, nonatomic) IBOutlet UILabel *center_title8_right;
@property(weak, nonatomic) IBOutlet UILabel *center_title9_right;
@property(weak, nonatomic) IBOutlet UILabel *center_title10_right;
@property(weak, nonatomic) IBOutlet UILabel *center_title11_right;
@property(weak, nonatomic) IBOutlet UILabel *center_title12_right;
@property(weak, nonatomic) IBOutlet UILabel *center_title13_right;
@property(weak, nonatomic) IBOutlet UILabel *center_title14_right;

@property(weak, nonatomic) IBOutlet UIView *orderView;

@property(weak, nonatomic) IBOutlet NSLayoutConstraint *btnSpacing;
@property(copy, nonatomic) NSString *remaining; //抵押的金额

@end

@implementation CurrencyIncentiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"POS抵押", nil);
    [_earnMoneyBotton setTitle:NSLocalizedString(@"抵押发起", nil) forState:UIControlStateNormal];
    [_shuhuiButton setTitle:NSLocalizedString(@"赎回", nil) forState:UIControlStateNormal];
    _yesterday_pool.text = NSLocalizedString(@"全网抵押量", nil);
    _power.text = NSLocalizedString(@"累计销毁", nil);
    /*
    _yesterDayPower.text = [NSString stringWithFormat:@"%@:0(M0)",NSLocalizedString(@"昨日MPool", nil)];
    _yesterDayExcitation.text = [NSString stringWithFormat:@"%@:0",NSLocalizedString(@"昨日全网算力", nil)];
    _yesterDayMeExcitation.text = [NSString stringWithFormat:@"%@:0",NSLocalizedString(@"昨日我的算力", nil)];
    _yesterDaymejili.text = [NSString stringWithFormat:@"%@:0",NSLocalizedString(@"昨日我的激励", nil)];
    _today_pool.text = [NSString stringWithFormat:@"%@:0(M0)",NSLocalizedString(@"我的抵押", nil)];
    _earnMoneyType.text = [NSString stringWithFormat:@"%@:Nature",NSLocalizedString(@"抵押类型", nil)];
    _earnMoneyTime.text = [NSString stringWithFormat:@"%@:0D [0.0%]",NSLocalizedString(@"时间加成", nil)];*/

    _center_title0.text = NSLocalizedString(@"昨日订单价值", nil);
    _center_title1.text = NSLocalizedString(@"昨日激励", nil);
    _center_title2.text = NSLocalizedString(@"激励指数", nil);
    _center_title3.text = NSLocalizedString(@"我的抵押", nil);
    _center_title5.text = NSLocalizedString(@"币量", nil);
    _center_title6.text = NSLocalizedString(@"价值", nil);
    _center_title7.text = NSLocalizedString(@"开启时间", nil);
    _center_title8.text = NSLocalizedString(@"币天值", nil);
    

    [self.earnMoneyBotton setHidden:YES];
    [self.shuhuiButton setHidden:YES];

    self.tableView.mj_header = [DCHomeRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(realData)];
//    [self.tableView.mj_header beginRefreshing];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];

}

- (void)realData{
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);//
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [[MGPHttpRequest shareManager]post:@"/user/findMgp" paramters:@{@"mgpName":[MGPHttpRequest shareManager].curretWallet.address} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
            dispatch_group_leave(group);
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([responseObj[@"code"] intValue] == 0) {
                    [self.earnMoneyBotton setHidden:NO];
                    [self.shuhuiButton setHidden:NO];
                }
           });
            
        }];
    });
    dispatch_group_enter(group);//
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary *dic = @{@"account_name":@"eosio.token"};
        [[HTTPRequestManager shareMgpManager] post:eos_get_account paramters:dic success:^(BOOL isSuccess, id responseObject) {
            
            if (isSuccess) {
                dispatch_group_leave(group);
                 dispatch_async(dispatch_get_main_queue(), ^{
                     NSString *balancestr = [(NSDictionary *)responseObject objectForKey:@"core_liquid_balance"];
                     NSString *valuestring = [balancestr componentsSeparatedByString:@" "].firstObject;
                     self.powerValue.text = valuestring;
                     
                });
            }
        } failure:^(NSError *error) {
            
        } superView:self.view showFaliureDescription:YES];
        
        
    });
    dispatch_group_enter(group);//
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary *dic = @{@"json": @1,@"code": @"addressbookt",@"scope":@"addressbookt",@"table_key":@"",@"table":@"balances",@"lower_bound":[MGPHttpRequest shareManager].curretWallet.address,@"upper_bound":[MGPHttpRequest shareManager].curretWallet.address};
        
        
        [[HTTPRequestManager shareMgpManager] post:eos_get_table_rows paramters:dic success:^(BOOL isSuccess, id responseObject) {
            
            if (isSuccess) {
                dispatch_group_leave(group);
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     NSArray *arr = (NSArray *)responseObject[@"rows"];
                     NSDictionary *dic = arr.firstObject;
                     NSString *remaining = [dic[@"remaining"] componentsSeparatedByString:@" "].firstObject;
                     self.remaining = remaining;
                     self.center_title5_right.text = [NSString stringWithFormat:@"%.4f MGP",self.remaining.doubleValue * 2];
                     if (remaining.doubleValue <= 0) {
                         [self.earnMoneyBotton setTitle:NSLocalizedString(@"抵押发起", nil) forState:UIControlStateNormal];
                         self.btnSpacing.constant = -(ScreenW-20);
                     }else{
                         [self.earnMoneyBotton setTitle:NSLocalizedString(@"追加抵押", nil) forState:UIControlStateNormal];
                         self.btnSpacing.constant = 0;
                     }
                     
                });
            }
        } failure:^(NSError *error) {
            
        } superView:self.view showFaliureDescription:YES];
        
    });
    dispatch_group_enter(group);//
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [[MGPHttpRequest shareManager]post:@"/user/orderIndex" paramters:@{@"address":[MGPHttpRequest shareManager].curretWallet.address} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
            dispatch_group_leave(group);
            dispatch_async(dispatch_get_main_queue(), ^{

                
                if ([responseObj[@"code"] intValue] == 0) {
                       
                    self.yesterdayValue.text = [responseObj[@"data"]objectForKey:@"sysMgpNum"];
//                    self.center_title0_right.text = [NSString stringWithFormat:@"$%@",[[responseObj[@"data"]objectForKey:@"yesterdayOrder"]objectForKey:@"orderValue"]];
                    
                    self.center_title0_right.text = [NSString stringWithFormat:@"%@%.2f",[CreateAll GetCurrentCurrency].symbol,([[CreateAll GetCurrentCurrency].price doubleValue] * [[[responseObj[@"data"]objectForKey:@"yesterdayOrder"]objectForKey:@"orderValue"]doubleValue])];
                    self.center_title1_right.text = [NSString stringWithFormat:@"%@ MGP",[[responseObj[@"data"]objectForKey:@"yesterdayOrder"]objectForKey:@"money"]];
                    self.center_title2_right.text = [NSString stringWithFormat:@"%@%",[[responseObj[@"data"]objectForKey:@"yesterdayOrder"]objectForKey:@"pro"]];

                    NSString *s = [[responseObj[@"data"]objectForKey:@"order"]objectForKey:@"createTime"];
                    if (s.length > 0) {
                        self.center_title3_right.text = [NSString stringWithFormat:@"%@",[[responseObj[@"data"]objectForKey:@"order"]objectForKey:@"orderLevel"]];

                        self.center_title5_right.text = [NSString stringWithFormat:@"%@ MGP",[[responseObj[@"data"]objectForKey:@"order"]objectForKey:@"mgpNum"]];
                        self.center_title6_right.text = [NSString stringWithFormat:@"$%@",[[responseObj[@"data"]objectForKey:@"order"]objectForKey:@"orderValue"]];
                        self.center_title7_right.text = [NSString stringWithFormat:@"%@",[[responseObj[@"data"]objectForKey:@"order"]objectForKey:@"createTime"]];
                        
                        NSString *ss = [[responseObj[@"data"]objectForKey:@"order"]objectForKey:@"dailyPro"];
                        
                        self.center_title8_right.text = [NSString stringWithFormat:@"%.4f%",ss.doubleValue * 100.0];
                        
                        self.center_title9_right.text = [[responseObj[@"data"]objectForKey:@"calPower"]objectForKey:@"userPower"];
                        self.center_title10_right.text = [[responseObj[@"data"]objectForKey:@"calPower"]objectForKey:@"pushPower"];
                        self.center_title11_right.text = [[responseObj[@"data"]objectForKey:@"calPower"]objectForKey:@"teamPower"];
                        self.center_title12_right.text = [[responseObj[@"data"]objectForKey:@"calPower"]objectForKey:@"lightNodePower"];
                        self.center_title13_right.text = [[responseObj[@"data"]objectForKey:@"calPower"]objectForKey:@"lightPower"];
                        self.center_title14_right.text = [[responseObj[@"data"]objectForKey:@"calPower"]objectForKey:@"powerIndex"];


                    }
                   
                }
                

            });
            
            
        }];
    });
    //二个网络请求都完成统一处理
    dispatch_group_notify(group, queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{

//            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];

        });
        
    });
    
    
            
    
}

- (IBAction)buttonClick:(UIButton *)sender {

    [self performSegueWithIdentifier:@"LHSendTransactionViewController" sender:sender];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.destinationViewController isKindOfClass:[LHSendTransactionViewController class]]) {
        LHSendTransactionViewController *vc = segue.destinationViewController;
        vc.sendType = sender == self.earnMoneyBotton ? earnMoney : redeem;
        vc.remaining = self.remaining;

    }
}

@end
