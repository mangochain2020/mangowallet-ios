//
//  LHRealdataViewController.m
//  TaiYiToken
//
//  Created by mac on 2020/7/23.
//  Copyright © 2020 admin. All rights reserved.
//

#import "LHRealdataViewController.h"
#import "WebVC.h"

@interface LHRealdataViewController ()

@property(weak, nonatomic) IBOutlet UILabel *valuelabel1;
@property(weak, nonatomic) IBOutlet UILabel *valuelabel2;
@property(weak, nonatomic) IBOutlet UILabel *valuelabel3;
@property(weak, nonatomic) IBOutlet UILabel *valuelabel4;
@property(weak, nonatomic) IBOutlet UILabel *valuelabel5;
@property(weak, nonatomic) IBOutlet UILabel *valuelabel6;
@property(weak, nonatomic) IBOutlet UILabel *valuelabel7;
@property(weak, nonatomic) IBOutlet UILabel *valuelabel8;
@property(weak, nonatomic) IBOutlet UILabel *valuelabel9;
@property(weak, nonatomic) IBOutlet UILabel *valuelabel10;
@property(weak, nonatomic) IBOutlet UILabel *valuelabel11;
@property(weak, nonatomic) IBOutlet UILabel *valuelabel12;
@property(weak, nonatomic) IBOutlet UILabel *valuelabel13;

@property(weak, nonatomic) IBOutlet UILabel *label1;
@property(weak, nonatomic) IBOutlet UIButton *detailBtn;
@property(weak, nonatomic) IBOutlet UILabel *label3;
@property(weak, nonatomic) IBOutlet UILabel *label4;
@property(weak, nonatomic) IBOutlet UILabel *label5;
@property(weak, nonatomic) IBOutlet UILabel *label6;
@property(weak, nonatomic) IBOutlet UILabel *label7;
@property(weak, nonatomic) IBOutlet UILabel *label8;
@property(weak, nonatomic) IBOutlet UILabel *label9;
@property(weak, nonatomic) IBOutlet UILabel *label10;
@property(weak, nonatomic) IBOutlet UILabel *label11;
@property(weak, nonatomic) IBOutlet UILabel *label12;
@property(weak, nonatomic) IBOutlet UILabel *label13;

@property(copy, nonatomic) NSNumber *realTime;
@property(strong, nonatomic) NSNumber *price;
@property(strong, nonatomic) NSNumber *eosioTokenBalance;
@property(strong, nonatomic) NSNumber *operationfund;
@property(strong, nonatomic) NSNumber *ecologicalfund;
@property(strong, nonatomic) NSNumber *teammotivation;
@property(strong, nonatomic) NSNumber *totalOrePool;
@property(strong, nonatomic) NSNumber *settlement;

@property(strong, nonatomic) NSNumber *supply;
@property(strong, nonatomic) NSNumber *temp1;
@property(strong, nonatomic) NSNumber *temp2;
@property(strong, nonatomic) NSNumber *temp3;
@property(strong, nonatomic) NSNumber *temp4;
@property(strong, nonatomic) NSNumber *temp5;
@property(strong, nonatomic) NSNumber *temp6;
@property(strong, nonatomic) NSNumber *temp7;



@end

@implementation LHRealdataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"实时数据", nil);
    self.tableView.tableFooterView = [UIView new];
    [self loadData];
    
    self.label1.text = NSLocalizedString(@"总量", nil);
    self.label3.text = NSLocalizedString(@"累计销毁", nil);
    self.label4.text = NSLocalizedString(@"实时价格", nil);
    self.label5.text = NSLocalizedString(@"实时流通", nil);
    self.label6.text = NSLocalizedString(@"流通市场", nil);
    self.label7.text = NSLocalizedString(@"全网抵押", nil);
    self.label8.text = NSLocalizedString(@"抵押市值", nil);
    self.label9.text = NSLocalizedString(@"运营建设", nil);
    self.label10.text = NSLocalizedString(@"生态基金", nil);
    self.label11.text = NSLocalizedString(@"生态激励", nil);
    self.label12.text = NSLocalizedString(@"矿池总量", nil);
    self.label13.text = NSLocalizedString(@"昨日全网算力", nil);

  
}
- (void)loadData{
    
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_group_t group = dispatch_group_create();
    MJWeakSelf

    dispatch_group_enter(group);//
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ///运营基金
        [[HTTPRequestManager shareMgpManager] post:eos_get_account paramters:@{@"account_name":@"mangochain33"} success:^(BOOL isSuccess, id responseObject) {
            dispatch_group_leave(group);
            if (isSuccess) {
                NSString *balancestr = [(NSDictionary *)responseObject objectForKey:@"core_liquid_balance"];
                NSString *valuestring = [balancestr componentsSeparatedByString:@" "].firstObject;
                double balance = valuestring.doubleValue;
                self.operationfund = @(balance);
                self.valuelabel9.text = [NSString getMoneyStringWithMoneyNumber:self.operationfund.doubleValue];//[NSString stringWithFormat:@"%.4f",self.operationfund.doubleValue];

            }
        } failure:^(NSError *error) {
            
        } superView:self.view showFaliureDescription:YES];
        
    });
    dispatch_group_enter(group);//
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ///结算的地址
        [[HTTPRequestManager shareMgpManager] post:eos_get_account paramters:@{@"account_name":@"mgpchain2222"} success:^(BOOL isSuccess, id responseObject) {
            dispatch_group_leave(group);
            if (isSuccess) {
                NSString *balancestr = [(NSDictionary *)responseObject objectForKey:@"core_liquid_balance"];
                NSString *valuestring = [balancestr componentsSeparatedByString:@" "].firstObject;
                double balance = valuestring.doubleValue;
                self.settlement = @(balance);
            }
        } failure:^(NSError *error) {
            
        } superView:self.view showFaliureDescription:YES];
        
    });
    
    dispatch_group_enter(group);//
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[HTTPRequestManager shareMgpManager] post:eos_get_account paramters:@{@"account_name":@"mangochain15"} success:^(BOOL isSuccess, id responseObject) {
            dispatch_group_leave(group);
            if (isSuccess) {
                NSString *balancestr = [(NSDictionary *)responseObject objectForKey:@"core_liquid_balance"];
                NSString *valuestring = [balancestr componentsSeparatedByString:@" "].firstObject;
                double balance = valuestring.doubleValue;
                self.temp1 = @(balance);

            }
        } failure:^(NSError *error) {
            
        } superView:self.view showFaliureDescription:YES];
        
    });
    dispatch_group_enter(group);//
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[HTTPRequestManager shareMgpManager] post:eos_get_account paramters:@{@"account_name":@"masteraychen"} success:^(BOOL isSuccess, id responseObject) {
            dispatch_group_leave(group);
            if (isSuccess) {
                NSString *balancestr = [(NSDictionary *)responseObject objectForKey:@"core_liquid_balance"];
                NSString *valuestring = [balancestr componentsSeparatedByString:@" "].firstObject;
                double balance = valuestring.doubleValue;
                self.temp2 = @(balance);

            }
        } failure:^(NSError *error) {
            
        } superView:self.view showFaliureDescription:YES];
        
    });
    dispatch_group_enter(group);//
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[HTTPRequestManager shareMgpManager] post:eos_get_account paramters:@{@"account_name":@"mgp.bpvoting"} success:^(BOOL isSuccess, id responseObject) {
            dispatch_group_leave(group);
            if (isSuccess) {
                NSString *balancestr = [(NSDictionary *)responseObject objectForKey:@"core_liquid_balance"];
                NSString *valuestring = [balancestr componentsSeparatedByString:@" "].firstObject;
                double balance = valuestring.doubleValue;
                self.temp3 = @(balance);

            }
        } failure:^(NSError *error) {
            
        } superView:self.view showFaliureDescription:YES];
        
    });
    
    dispatch_group_enter(group);//
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSDictionary *dic = @{@"code":@"eosio.token",@"symbol":@"MGP"};
        [[HTTPRequestManager shareMgpManager] post:eos_get_currency_stats paramters:dic success:^(BOOL isSuccess, id responseObject) {
            dispatch_group_leave(group);

            NSLog(@"%@",responseObject);
            NSString *valuestring = [[responseObject[@"MGP"]objectForKey:@"supply"] componentsSeparatedByString:@" "].firstObject;
            self.supply = @(valuestring.doubleValue);

        } failure:^(NSError *error) {
            
        } superView:self.view showFaliureDescription:YES];
        
    });
    dispatch_group_enter(group);//
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ///生态基金
        [[HTTPRequestManager shareMgpManager] post:eos_get_account paramters:@{@"account_name":@"mangochain22"} success:^(BOOL isSuccess, id responseObject) {
            dispatch_group_leave(group);
            if (isSuccess) {
                NSString *balancestr = [(NSDictionary *)responseObject objectForKey:@"core_liquid_balance"];
                NSString *valuestring = [balancestr componentsSeparatedByString:@" "].firstObject;
                double balance = valuestring.doubleValue;
                self.ecologicalfund = @(balance);
                self.valuelabel10.text = [NSString getMoneyStringWithMoneyNumber:self.ecologicalfund.doubleValue];//[NSString stringWithFormat:@"%.4f",self.ecologicalfund.doubleValue];

            }
        } failure:^(NSError *error) {
            
        } superView:self.view showFaliureDescription:YES];
        
    });
    dispatch_group_enter(group);//
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ///生态激励
        [[HTTPRequestManager shareMgpManager] post:eos_get_account paramters:@{@"account_name":@"mangochain11"} success:^(BOOL isSuccess, id responseObject) {
            dispatch_group_leave(group);
            if (isSuccess) {
                NSString *balancestr = [(NSDictionary *)responseObject objectForKey:@"core_liquid_balance"];
                NSString *valuestring = [balancestr componentsSeparatedByString:@" "].firstObject;
                double balance = valuestring.doubleValue;
                self.teammotivation = @(balance);
                self.valuelabel11.text = [NSString getMoneyStringWithMoneyNumber:self.teammotivation.doubleValue];//[NSString stringWithFormat:@"%.4f",self.teammotivation.doubleValue];

            }
        } failure:^(NSError *error) {
            
        } superView:self.view showFaliureDescription:YES];
        
    });
    /*
    dispatch_group_enter(group);//
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ///累计销毁
        [[HTTPRequestManager shareMgpManager] post:eos_get_account paramters:@{@"account_name":@"eosio.token"} success:^(BOOL isSuccess, id responseObject) {
            dispatch_group_leave(group);
            if (isSuccess) {
                NSString *balancestr = [(NSDictionary *)responseObject objectForKey:@"core_liquid_balance"];
                NSString *valuestring = [balancestr componentsSeparatedByString:@" "].firstObject;
                double balance = valuestring.doubleValue;
                self.eosioTokenBalance = @(balance);
                self.valuelabel3.text = [NSString stringWithFormat:@"%.4f",self.eosioTokenBalance.doubleValue];
                self.valuelabel1.text = [NSString stringWithFormat:@"%.4f",500000000 - self.eosioTokenBalance.doubleValue];

            }
        } failure:^(NSError *error) {
            
        } superView:self.view showFaliureDescription:YES];
        
    });*/
    dispatch_group_enter(group);//
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ///全网抵押和市值
        [[MGPHttpRequest shareManager]post:@"/user/realTimeIndex" paramters:nil completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
            dispatch_group_leave(group);
            if ([responseObj[@"code"]intValue] == 0) {
                self.realTime = @(((NSString *)VALIDATE_STRING([responseObj[@"data"]objectForKey:@"mgpNum"])).doubleValue);
                self.valuelabel7.text = [NSString getMoneyStringWithMoneyNumber:self.realTime.doubleValue];//[NSString stringWithFormat:@"%.4f",self.realTime.doubleValue];
                self.valuelabel8.text = [NSString stringWithFormat:@"%@%@",[CreateAll GetCurrentCurrency].symbol,[NSString getMoneyStringWithMoneyNumber:([[CreateAll GetCurrentCurrency].price doubleValue] * [[responseObj[@"data"]objectForKey:@"mapValue"]doubleValue])]];
                self.valuelabel13.text = [NSString getMoneyStringWithMoneyNumber:((NSString *)VALIDATE_STRING([responseObj[@"data"]objectForKey:@"totalPower"])).doubleValue];//[NSString stringWithFormat:@"%@",@(((NSString *)VALIDATE_STRING([responseObj[@"data"]objectForKey:@"totalPower"])).doubleValue)];
                
                self.eosioTokenBalance = @(((NSString *)VALIDATE_STRING([responseObj[@"data"]objectForKey:@"destroyMgpNum"])).doubleValue);
                self.valuelabel3.text = [NSString getMoneyStringWithMoneyNumber:self.eosioTokenBalance.doubleValue];//[NSString stringWithFormat:@"%.4f",self.eosioTokenBalance.doubleValue];
                self.valuelabel1.text = [NSString getMoneyStringWithMoneyNumber:(500000000.0 - self.eosioTokenBalance.doubleValue)];
                
                
                
                //矿池临时的
                self.totalOrePool = @(((NSString *)VALIDATE_STRING([responseObj[@"data"]objectForKey:@"minerPoolNum"])).doubleValue);
                self.valuelabel12.text = [NSString getMoneyStringWithMoneyNumber:self.totalOrePool.doubleValue];//[NSString stringWithFormat:@"%.4f",self.totalOrePool.doubleValue];
                

            }
            
        }];
        
    });
    dispatch_group_enter(group);//
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //当前mgp价格
        [[MGPHttpRequest shareManager]post:@"/api/coinPrice" paramters:@{@"pair":@"MGP_USDT"} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
            dispatch_group_leave(group);
            if ([responseObj[@"code"]intValue] == 0) {
                NSDictionary *dic = responseObj[@"data"];
                weakSelf.price =@(((NSString *)VALIDATE_STRING([dic objectForKey:@"price"])).doubleValue);
                weakSelf.valuelabel4.text = [NSString stringWithFormat:@"%@%.2f",[CreateAll GetCurrentCurrency].symbol,([[CreateAll GetCurrentCurrency].price doubleValue] * self.price.doubleValue)];
            }
        }];
        
    });
    //多个网络请求都完成统一处理
    dispatch_group_notify(group, queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{

            //总量
            double total = 500000000.0 - self.eosioTokenBalance.doubleValue;

            
            self.valuelabel2.text = [NSString stringWithFormat:@"%@%@",[CreateAll GetCurrentCurrency].symbol,[NSString getMoneyStringWithMoneyNumber:([[CreateAll GetCurrentCurrency].price doubleValue] * (total*self.price.doubleValue))]];

 
            //实时流通 = 目前币量(eosio.token) - 全网抵押(接口返回) - 运营(mangochain33) - 团队(mangochain11) - mgpchain2222(余额) - mangochain15(余额) - masteraychen(余额) - 做市币量（固定110万）- 抵押投票总量(mgp.bpvoting)
            
            double circulation = self.supply.doubleValue - self.realTime.doubleValue - self.operationfund.doubleValue - self.teammotivation.doubleValue - self.settlement.doubleValue - self.temp1.doubleValue - self.temp2.doubleValue - self.temp3.doubleValue;
            
            
            NSLog(@"%.4f---%.4f---%.4f---%.4f---%.4f---%.4f---%.4f---%.4f",self.supply.doubleValue,self.realTime.doubleValue,self.operationfund.doubleValue,self.teammotivation.doubleValue,self.settlement.doubleValue,self.temp1.doubleValue,self.temp2.doubleValue,self.temp3.doubleValue);

            self.valuelabel5.text = [NSString getMoneyStringWithMoneyNumber:circulation];// [NSString stringWithFormat:@"%.4f",circulation];
            self.valuelabel6.text = [NSString stringWithFormat:@"%@%@",[CreateAll GetCurrentCurrency].symbol,[NSString getMoneyStringWithMoneyNumber:([[CreateAll GetCurrentCurrency].price doubleValue] * (circulation*self.price.doubleValue))]];
            
            
        });
        
    });
    
    
    
}
/*
- (void)loadData1{
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_group_t group = dispatch_group_create();
    MJWeakSelf

    dispatch_group_enter(group);//
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ///运营基金
        [[HTTPRequestManager shareMgpManager] post:eos_get_account paramters:@{@"account_name":@"mangochain33"} success:^(BOOL isSuccess, id responseObject) {
            dispatch_group_leave(group);
            if (isSuccess) {
                NSString *balancestr = [(NSDictionary *)responseObject objectForKey:@"core_liquid_balance"];
                NSString *valuestring = [balancestr componentsSeparatedByString:@" "].firstObject;
                double balance = valuestring.doubleValue;
                self.operationfund = @(balance);
                self.valuelabel9.text = [NSString stringWithFormat:@"%.4f",self.operationfund.doubleValue];

            }
        } failure:^(NSError *error) {
            
        } superView:self.view showFaliureDescription:YES];
        
    });
    dispatch_group_enter(group);//
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ///结算的地址
        [[HTTPRequestManager shareMgpManager] post:eos_get_account paramters:@{@"account_name":@"mgpchain2222"} success:^(BOOL isSuccess, id responseObject) {
            dispatch_group_leave(group);
            if (isSuccess) {
                NSString *balancestr = [(NSDictionary *)responseObject objectForKey:@"core_liquid_balance"];
                NSString *valuestring = [balancestr componentsSeparatedByString:@" "].firstObject;
                double balance = valuestring.doubleValue;
                self.settlement = @(balance);
            }
        } failure:^(NSError *error) {
            
        } superView:self.view showFaliureDescription:YES];
        
    });
    
    dispatch_group_enter(group);//
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ///矿池总量
        [[HTTPRequestManager shareMgpManager] post:eos_get_account paramters:@{@"account_name":@"uuuuuuu12345"} success:^(BOOL isSuccess, id responseObject) {
            dispatch_group_leave(group);
            if (isSuccess) {
                NSString *balancestr = [(NSDictionary *)responseObject objectForKey:@"core_liquid_balance"];
                NSString *valuestring = [balancestr componentsSeparatedByString:@" "].firstObject;
                double balance = valuestring.doubleValue;
                self.totalOrePool = @(balance);
                self.valuelabel12.text = [NSString stringWithFormat:@"%.4f",self.totalOrePool.doubleValue];

            }
        } failure:^(NSError *error) {
            
        } superView:self.view showFaliureDescription:YES];
        
    });
    
    dispatch_group_enter(group);//
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ///生态激励
        [[HTTPRequestManager shareMgpManager] post:eos_get_account paramters:@{@"account_name":@"mangochain11"} success:^(BOOL isSuccess, id responseObject) {
            dispatch_group_leave(group);
            if (isSuccess) {
                NSString *balancestr = [(NSDictionary *)responseObject objectForKey:@"core_liquid_balance"];
                NSString *valuestring = [balancestr componentsSeparatedByString:@" "].firstObject;
                double balance = valuestring.doubleValue;
                self.teammotivation = @(balance);
                self.valuelabel11.text = [NSString stringWithFormat:@"%.4f",self.teammotivation.doubleValue];

            }
        } failure:^(NSError *error) {
            
        } superView:self.view showFaliureDescription:YES];
        
    });
    dispatch_group_enter(group);//
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ///生态基金
        [[HTTPRequestManager shareMgpManager] post:eos_get_account paramters:@{@"account_name":@"mangochain22"} success:^(BOOL isSuccess, id responseObject) {
            dispatch_group_leave(group);
            if (isSuccess) {
                NSString *balancestr = [(NSDictionary *)responseObject objectForKey:@"core_liquid_balance"];
                NSString *valuestring = [balancestr componentsSeparatedByString:@" "].firstObject;
                double balance = valuestring.doubleValue;
                self.ecologicalfund = @(balance);
                self.valuelabel10.text = [NSString stringWithFormat:@"%.4f",self.ecologicalfund.doubleValue];

            }
        } failure:^(NSError *error) {
            
        } superView:self.view showFaliureDescription:YES];
        
    });
    dispatch_group_enter(group);//
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ///累计销毁
        [[HTTPRequestManager shareMgpManager] post:eos_get_account paramters:@{@"account_name":@"eosio.token"} success:^(BOOL isSuccess, id responseObject) {
            dispatch_group_leave(group);
            if (isSuccess) {
                NSString *balancestr = [(NSDictionary *)responseObject objectForKey:@"core_liquid_balance"];
                NSString *valuestring = [balancestr componentsSeparatedByString:@" "].firstObject;
                double balance = valuestring.doubleValue;
                self.eosioTokenBalance = @(balance);
                self.valuelabel3.text = [NSString stringWithFormat:@"%.4f",self.eosioTokenBalance.doubleValue];
                self.valuelabel1.text = [NSString stringWithFormat:@"%.4f",500000000 - self.eosioTokenBalance.doubleValue];

            }
        } failure:^(NSError *error) {
            
        } superView:self.view showFaliureDescription:YES];
        
    });
    dispatch_group_enter(group);//
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ///全网抵押和市值
        [[MGPHttpRequest shareManager]post:@"/user/realTimeIndex" paramters:nil completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
            dispatch_group_leave(group);
            if ([responseObj[@"code"]intValue] == 0) {
                self.realTime = @(((NSString *)VALIDATE_STRING([responseObj[@"data"]objectForKey:@"mgpNum"])).doubleValue);
                self.valuelabel7.text = [NSString stringWithFormat:@"%.4f",self.realTime.doubleValue];
                self.valuelabel8.text = [NSString stringWithFormat:@"%@%.2f",[CreateAll GetCurrentCurrency].symbol,([[CreateAll GetCurrentCurrency].price doubleValue] * [[responseObj[@"data"]objectForKey:@"mapValue"]doubleValue])];
                self.valuelabel13.text = [NSString stringWithFormat:@"%@",@(((NSString *)VALIDATE_STRING([responseObj[@"data"]objectForKey:@"totalPower"])).doubleValue)];
                
            }
            
        }];
        
    });
    dispatch_group_enter(group);//
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //当前mgp价格
        [[MGPHttpRequest shareManager]post:@"/api/coinPrice" paramters:@{@"pair":@"MGP_USDT"} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
            dispatch_group_leave(group);
            if ([responseObj[@"code"]intValue] == 0) {
                NSDictionary *dic = responseObj[@"data"];
                weakSelf.price =@(((NSString *)VALIDATE_STRING([dic objectForKey:@"price"])).doubleValue);
                weakSelf.valuelabel4.text = [NSString stringWithFormat:@"%@%.2f",[CreateAll GetCurrentCurrency].symbol,([[CreateAll GetCurrentCurrency].price doubleValue] * self.price.doubleValue)];
            }
        }];
        
    });
    //多个网络请求都完成统一处理
    dispatch_group_notify(group, queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{

            //矿池临时的
            self.totalOrePool = @(350000000);
            self.valuelabel12.text = [NSString stringWithFormat:@"%.4f",self.totalOrePool.doubleValue];
            
            //总量
            double total = 500000000.0 - self.eosioTokenBalance.doubleValue;
//            self.valuelabel2.text = [NSString stringWithFormat:@"$%.2f",total*self.price.doubleValue];
            self.valuelabel2.text = [NSString stringWithFormat:@"%@%.2f",[CreateAll GetCurrentCurrency].symbol,([[CreateAll GetCurrentCurrency].price doubleValue] * (total*self.price.doubleValue))];

            
            //实时流通 = 5亿 - 销毁(eosioTokenBalance) - 全网抵押(realTime) - 运营(operationfund) - 生态基金(ecologicalfund) - 生态激励(teammotivation) - 矿池(totalOrePool) - mgpchain2222余额(settlement) - 2100000
            //实时流通 = 5亿 - 销毁(eosio.token) - 全网抵押(接口返回) - 运营建设(mangochain33) - 生态基金(mangochain22) - 生态激励(mangochain11) - 矿池(固定3.5亿) - mgpchain2222余额(0.00) - 2100000

            
            //实时流通 = 目前币量(eosio.token) - 全网抵押(接口返回) - 运营(？) - 团队(？) - mgpchain2222(余额) - mangochain15(余额) - masteraychen(余额) - 做市币量（固定110万）- 抵押投票总量(mgp.bpvoting)
            
            
            double circulation = total - self.realTime.doubleValue - self.operationfund.doubleValue - self.ecologicalfund.doubleValue - self.teammotivation.doubleValue - self.totalOrePool.doubleValue - self.settlement.doubleValue - 2100000.0;

            self.valuelabel5.text = [NSString stringWithFormat:@"%.4f",circulation];
//            self.valuelabel6.text = [NSString stringWithFormat:@"$%.2f",circulation*self.price.doubleValue];
            
            self.valuelabel6.text = [NSString stringWithFormat:@"%@%.2f",[CreateAll GetCurrentCurrency].symbol,([[CreateAll GetCurrentCurrency].price doubleValue] * (circulation*self.price.doubleValue))];
            

            
        });
        
    });
    
    
    
}
 */
- (IBAction)button12Click:(id)sender {
    WebVC *webvc = [WebVC new];
    webvc.urlstring = @"https://explorer.mgpchain.io/account/*****";
//    [self.navigationController pushViewController:webvc animated:YES];
    
}

- (IBAction)button11Click:(id)sender {
    WebVC *webvc = [WebVC new];
    webvc.urlstring = @"https://explorer.mgpchain.io/account/mangochain11";
    [self.navigationController pushViewController:webvc animated:YES];
    
}

- (IBAction)button10Click:(id)sender {
    WebVC *webvc = [WebVC new];
    webvc.urlstring = @"https://explorer.mgpchain.io/account/mangochain22";
    [self.navigationController pushViewController:webvc animated:YES];
}


- (IBAction)button9Click:(id)sender {
    WebVC *webvc = [WebVC new];
    webvc.urlstring = @"https://explorer.mgpchain.io/account/mangochain33";
    [self.navigationController pushViewController:webvc animated:YES];
}

- (IBAction)button3Click:(id)sender {
    WebVC *webvc = [WebVC new];
    webvc.urlstring = @"https://explorer.mgpchain.io/account/eosio.token";
    [self.navigationController pushViewController:webvc animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
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
