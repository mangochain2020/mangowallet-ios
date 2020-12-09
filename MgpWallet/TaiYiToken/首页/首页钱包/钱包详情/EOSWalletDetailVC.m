//
//  EOSWalletDetailVC.m
//  TaiYiToken
//
//  Created by Frued on 2018/10/24.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "EOSWalletDetailVC.h"

#import "WalletDetailVC.h"
#import "WBQRCodeVC.h"
#import "WalletDetailView.h"
#import "NewBaseInfoModel.h"
#import "DetailBtnsView.h"
#import "TransactionVC.h"
#import "ReceiptQRCodeVC.h"

#import "ExportWalletVC.h"
#import "BTCTransactionRecordModel.h"
#import "ETHTransactionRecordModel.h"
#import "MISTransactionRecordModel.h"
#import "TransactionRecordDetailVC.h"
#import "TransactionRecordCell.h"
#import "EOSDetailBtnsView.h"
#import "VTwoMarketDetailVC.h"
#import "MarketTicketModel.h"
#import "EOSAuthorityVC.h"
#import "EOSProManageVC.h"
#define EOSRecordShowTypes @"transfer,dice,delegatebw,receive-action,send-action,newaccount,buyrambytes,undelegatebw,sellram"
@interface EOSWalletDetailVC ()<UIImagePickerControllerDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIView *bridgeContentView;
@property(nonatomic,strong) UIButton *backBtn;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIButton *scanBtn;
@property(nonatomic,strong)WalletDetailView *detailview;
@property (strong, nonatomic)NewBaseInfoModel *baseInfoModel;
@property (strong, nonatomic)DetailBtnsView *detailbtnsview;
@property (strong, nonatomic)EOSDetailBtnsView *eosdetailbtnsview;

@property(nonatomic)UITableView *tableView;
@property(nonatomic)int page;

@property(nonatomic)NSMutableArray <MISTransactionRecordModel *>*misRecordArray;
@property(nonatomic)NSMutableArray <MISTransactionRecordModel *>*eosRecordArray;
@property(nonatomic)NSMutableArray <MISTransactionRecordModel *>*eosallRecordArray;//未过滤trid
@property(nonatomic)NSDateFormatter* formatter;

@end

@implementation EOSWalletDetailVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    self.navigationController.hidesBottomBarWhenPushed = YES;
    self.tabBarController.tabBar.hidden = YES;
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.hidesBottomBarWhenPushed = NO;
}
- (void)popAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.formatter = [[NSDateFormatter alloc] init];
    
    [_formatter setDateStyle:NSDateFormatterMediumStyle];
    [_formatter setTimeStyle:NSDateFormatterShortStyle];
    [_formatter setDateFormat:@"yyyy/MM/dd HH:MM:ss"];
    self.view.backgroundColor = [UIColor ExportBackgroundColor];
    [self initHeadView];
    [self scrollView];
//    [self GetBaseInfo];
   
    [self detailview];
    
    
    if (self.wallet.coinType == EOS) {
        [self eosdetailbtnsview];
        self.eosRecordArray = [NSMutableArray new];
        self.eosallRecordArray = [NSMutableArray new];
        MJWeakSelf
        [self.scrollView addHeaderRefresh:^{
            NSString *namex = weakSelf.wallet.address;
            [[HTTPRequestManager shareEosManager] post:eos_get_actions paramters:@{@"account_name":namex ,@"pos":@0,@"offset":@100} success:^(BOOL isSuccess, id responseObject) {
                [weakSelf.scrollView endHeaderRefresh];
                [weakSelf.eosRecordArray removeAllObjects];
                [weakSelf.eosallRecordArray removeAllObjects];
                if (isSuccess) {
                    if ([responseObject isKindOfClass:[NSDictionary class]]) {
                        if ([[responseObject objectForKey:@"actions"] isKindOfClass:[NSArray class]]) {
                            for (NSDictionary *dic in [responseObject objectForKey:@"actions"]) {
                                if ([dic isKindOfClass:[NSDictionary class]]) {
                                    //[dic modelToJSONString];
                                    MISTransactionRecordModel *model = [MISTransactionRecordModel parse:dic];
                                    if (weakSelf.eosRecordArray.count == 0) {
                                        [weakSelf.eosRecordArray addObject:model];
                                        [weakSelf.eosallRecordArray addObject:model];
                                    }else{
                                        NSMutableArray *temp = [weakSelf.eosRecordArray mutableCopy];
                                        NSInteger num = 0;
                                        
                                        for (MISTransactionRecordModel *obj in temp) {
//                                            if ([obj.action_trace.trx_id isEqualToString:model.action_trace.trx_id]) {
//                                                break;
//                                            }else{
//                                                num++;
//                                            }
                                            if ([obj.action_trace.trx_id isEqualToString:model.action_trace.trx_id] && [obj.action_trace.act.name isEqualToString:model.action_trace.act.name]) {
                                                break;
                                            }else{
                                                num++;
                                            }
                                        }
                                        BOOL NotEOSType = ![model.action_trace.act.data.quantity containsString:@"EOS"] && ![model.action_trace.act.data.stake_cpu_quantity containsString:@"EOS"] && ![model.action_trace.act.data.unstake_cpu_quantity containsString:@"EOS"];
                                        if ([EOSRecordShowTypes containsString:model.action_trace.act.name]) {
                                            if ([@"transfer,delegatebw,undelegatebw" containsString:model.action_trace.act.name]) {
                                                if (NotEOSType == NO) {//其他币种的转账 抵押不加入
                                                    if (num >= temp.count) {
                                                        [weakSelf.eosRecordArray addObject:model];
                                                    }
                                                    [weakSelf.eosallRecordArray addObject:model];
                                                }
                                            }else{
                                                if (num >= temp.count) {
                                                    [weakSelf.eosRecordArray addObject:model];
                                                }
                                                [weakSelf.eosallRecordArray addObject:model];
                                            }
                                        }
                                        
                                        [temp removeAllObjects];
                                    }
                                    
                                }
                            }

                            [weakSelf.eosRecordArray sortUsingComparator:^NSComparisonResult(MISTransactionRecordModel * obj1,MISTransactionRecordModel * obj2) {
                                return obj1.account_action_seq < obj2.account_action_seq;
                            }];
                            dispatch_async_on_main_queue(^{
                                [weakSelf.tableView reloadData];
                            });
                            
                        }
                    }
                }
            } failure:^(NSError *error) {
                
                [weakSelf.view showAlert:@"error!" DetailMsg:error.description];
            }];
            
        }];
        [self.scrollView addFooterRefresh:^{
            NSString *namex = weakSelf.wallet.address;
            [[HTTPRequestManager shareEosManager] post:eos_get_actions paramters:@{@"account_name":namex ,@"pos":@0,@"offset":@100} success:^(BOOL isSuccess, id responseObject) {
                [weakSelf.scrollView endFooterRefresh];
                if (isSuccess) {
                    if ([responseObject isKindOfClass:[NSDictionary class]]) {
                        if ([[responseObject objectForKey:@"actions"] isKindOfClass:[NSArray class]]) {
                            for (NSDictionary *dic in [responseObject objectForKey:@"actions"]) {
                                if ([dic isKindOfClass:[NSDictionary class]]) {
                                    //[dic modelToJSONString];
                                    MISTransactionRecordModel *model = [MISTransactionRecordModel parse:dic];
                                    if (weakSelf.eosRecordArray.count == 0) {
                                        [weakSelf.eosRecordArray addObject:model];
                                        [weakSelf.eosallRecordArray addObject:model];
                                    }else{
                                        NSMutableArray *temp = [weakSelf.eosRecordArray mutableCopy];
                                        NSInteger num = 0;
                                        for (MISTransactionRecordModel *obj in temp) {

                                            if ([obj.action_trace.trx_id isEqualToString:model.action_trace.trx_id] && [obj.action_trace.act.name isEqualToString:model.action_trace.act.name]) {
                                                break;
                                            }else{
                                                num++;
                                            }
                                        }
                                        if (num >= temp.count) {
                                            BOOL NotEOSType = ![model.action_trace.act.data.quantity containsString:@"EOS"] && ![model.action_trace.act.data.stake_cpu_quantity containsString:@"EOS"] && ![model.action_trace.act.data.unstake_cpu_quantity containsString:@"EOS"];
                                            if ([EOSRecordShowTypes containsString:model.action_trace.act.name]) {
                                                if ([@"transfer,delegatebw,undelegatebw" containsString:model.action_trace.act.name]) {
                                                    if (NotEOSType == NO) {//其他币种的转账 抵押不加入
                                                        if (num >= temp.count) {
                                                            [weakSelf.eosRecordArray addObject:model];
                                                        }
                                                        [weakSelf.eosallRecordArray addObject:model];
                                                    }
                                                }else{
                                                    if (num >= temp.count) {
                                                        [weakSelf.eosRecordArray addObject:model];
                                                    }
                                                    [weakSelf.eosallRecordArray addObject:model];
                                                }
                                            }
                                        }
                                        [temp removeAllObjects];
                                    }
                                    
                                }
                            }

                            [weakSelf.eosRecordArray sortUsingComparator:^NSComparisonResult(MISTransactionRecordModel * obj1,MISTransactionRecordModel * obj2) {
                                return obj1.account_action_seq < obj2.account_action_seq;
                            }];
                            dispatch_async_on_main_queue(^{
                                [weakSelf.tableView reloadData];
                            });
                            
                        }
                    }
                }
            } failure:^(NSError *error) {
                [weakSelf.view showAlert:@"error!" DetailMsg:error.description];
            }];
            
            }];
        CurrentNodes *nodes = [CreateAll GetCurrentNodes];
        if (nodes && nodes.nodeEos.length>3) {
            [self.scrollView beginHeaderRefresh];
        }
    }else if (self.wallet.coinType == MGP){
            [self eosdetailbtnsview];
            self.eosRecordArray = [NSMutableArray new];
            self.eosallRecordArray = [NSMutableArray new];
            MJWeakSelf
            [self.scrollView addHeaderRefresh:^{
                NSString *namex = weakSelf.wallet.address;
                [[HTTPRequestManager shareMgpManager] post:eos_get_actions paramters:@{@"account_name":namex ,@"pos":@0,@"offset":@1000} success:^(BOOL isSuccess, id responseObject) {
                    [weakSelf.scrollView endHeaderRefresh];
                    [weakSelf.eosRecordArray removeAllObjects];
                    [weakSelf.eosallRecordArray removeAllObjects];
                    if (isSuccess) {
                        if ([responseObject isKindOfClass:[NSDictionary class]]) {
                            if ([[responseObject objectForKey:@"actions"] isKindOfClass:[NSArray class]]) {
                                for (NSDictionary *dic in [responseObject objectForKey:@"actions"]) {
                                    if ([dic isKindOfClass:[NSDictionary class]]) {
                                        //[dic modelToJSONString];
                                        MISTransactionRecordModel *model = [MISTransactionRecordModel parse:dic];
                                        if (weakSelf.eosRecordArray.count == 0) {
                                            [weakSelf.eosRecordArray addObject:model];
                                            [weakSelf.eosallRecordArray addObject:model];
                                        }else{
                                            NSMutableArray *temp = [weakSelf.eosRecordArray mutableCopy];
                                            NSInteger num = 0;
                                            
                                            for (MISTransactionRecordModel *obj in temp) {
    //                                            if ([obj.action_trace.trx_id isEqualToString:model.action_trace.trx_id]) {
    //                                                break;
    //                                            }else{
    //                                                num++;
    //                                            }
                                                if ([obj.action_trace.trx_id isEqualToString:model.action_trace.trx_id] && [obj.action_trace.act.name isEqualToString:model.action_trace.act.name]) {
                                                    break;
                                                }else{
                                                    num++;
                                                }
                                            }
                                            BOOL NotEOSType = ![model.action_trace.act.data.quantity containsString:@"MGP"] && ![model.action_trace.act.data.stake_cpu_quantity containsString:@"MGP"] && ![model.action_trace.act.data.unstake_cpu_quantity containsString:@"MGP"];
                                            if ([EOSRecordShowTypes containsString:model.action_trace.act.name]) {
                                                if ([@"transfer,delegatebw,undelegatebw" containsString:model.action_trace.act.name]) {
                                                    if (NotEOSType == NO) {//其他币种的转账 抵押不加入
                                                        if (num >= temp.count) {
                                                            [weakSelf.eosRecordArray addObject:model];
                                                        }
                                                        [weakSelf.eosallRecordArray addObject:model];
                                                    }
                                                }else{
                                                    if (num >= temp.count) {
                                                        [weakSelf.eosRecordArray addObject:model];
                                                    }
                                                    [weakSelf.eosallRecordArray addObject:model];
                                                }
                                            }
                                            
                                            [temp removeAllObjects];
                                        }
                                        
                                    }
                                }

                                [weakSelf.eosRecordArray sortUsingComparator:^NSComparisonResult(MISTransactionRecordModel * obj1,MISTransactionRecordModel * obj2) {
                                    return obj1.account_action_seq < obj2.account_action_seq;
                                }];
                                dispatch_async_on_main_queue(^{
                                    [weakSelf.tableView reloadData];
                                });
                                
                            }
                        }
                    }
                } failure:^(NSError *error) {
                    
                    [weakSelf.view showAlert:@"error!" DetailMsg:error.description];
                }];
                
            }];
            [self.scrollView addFooterRefresh:^{
                NSString *namex = weakSelf.wallet.address;
                [[HTTPRequestManager shareMgpManager] post:eos_get_actions paramters:@{@"account_name":namex ,@"pos":@0,@"offset":@1000} success:^(BOOL isSuccess, id responseObject) {
                    [weakSelf.scrollView endFooterRefresh];
                    if (isSuccess) {
                        if ([responseObject isKindOfClass:[NSDictionary class]]) {
                            if ([[responseObject objectForKey:@"actions"] isKindOfClass:[NSArray class]]) {
                                for (NSDictionary *dic in [responseObject objectForKey:@"actions"]) {
                                    if ([dic isKindOfClass:[NSDictionary class]]) {
                                        //[dic modelToJSONString];
                                        MISTransactionRecordModel *model = [MISTransactionRecordModel parse:dic];
                                        if (weakSelf.eosRecordArray.count == 0) {
                                            [weakSelf.eosRecordArray addObject:model];
                                            [weakSelf.eosallRecordArray addObject:model];
                                        }else{
                                            NSMutableArray *temp = [weakSelf.eosRecordArray mutableCopy];
                                            NSInteger num = 0;
                                            for (MISTransactionRecordModel *obj in temp) {

                                                if ([obj.action_trace.trx_id isEqualToString:model.action_trace.trx_id] && [obj.action_trace.act.name isEqualToString:model.action_trace.act.name]) {
                                                    break;
                                                }else{
                                                    num++;
                                                }
                                            }
                                            if (num >= temp.count) {
                                                BOOL NotEOSType = ![model.action_trace.act.data.quantity containsString:@"MGP"] && ![model.action_trace.act.data.stake_cpu_quantity containsString:@"MGP"] && ![model.action_trace.act.data.unstake_cpu_quantity containsString:@"MGP"];
                                                if ([EOSRecordShowTypes containsString:model.action_trace.act.name]) {
                                                    if ([@"transfer,delegatebw,undelegatebw" containsString:model.action_trace.act.name]) {
                                                        if (NotEOSType == NO) {//其他币种的转账 抵押不加入
                                                            if (num >= temp.count) {
                                                                [weakSelf.eosRecordArray addObject:model];
                                                            }
                                                            [weakSelf.eosallRecordArray addObject:model];
                                                        }
                                                    }else{
                                                        if (num >= temp.count) {
                                                            [weakSelf.eosRecordArray addObject:model];
                                                        }
                                                        [weakSelf.eosallRecordArray addObject:model];
                                                    }
                                                }
                                            }
                                            [temp removeAllObjects];
                                        }
                                        
                                    }
                                }

                                [weakSelf.eosRecordArray sortUsingComparator:^NSComparisonResult(MISTransactionRecordModel * obj1,MISTransactionRecordModel * obj2) {
                                    return obj1.account_action_seq < obj2.account_action_seq;
                                }];
                                dispatch_async_on_main_queue(^{
                                    [weakSelf.tableView reloadData];
                                });
                                
                            }
                        }
                    }
                } failure:^(NSError *error) {
                    [weakSelf.view showAlert:@"error!" DetailMsg:error.description];
                }];
                
                }];
            CurrentNodes *nodes = [CreateAll GetCurrentNodes];
            if (nodes && nodes.nodeMgp.length>3) {
                [self.scrollView beginHeaderRefresh];
            }
        }
    else if (self.wallet.coinType == MIS){
        [self detailbtnsview];
        self.misRecordArray = [NSMutableArray new];
        MJWeakSelf
        [self.scrollView addHeaderRefresh:^{
            NSString *name = [weakSelf.wallet.walletName componentsSeparatedByString:@"_"].lastObject;
            [[HTTPRequestManager shareManager] post:eos_get_actions paramters:@{@"account_name":name ,@"pos":@0,@"offset":@1000} success:^(BOOL isSuccess, id responseObject) {
                [weakSelf.scrollView endHeaderRefresh];
                [weakSelf.misRecordArray removeAllObjects];
                if (isSuccess) {
                    if ([responseObject isKindOfClass:[NSDictionary class]]) {
                        if ([[responseObject objectForKey:@"actions"] isKindOfClass:[NSArray class]]) {
                            for (NSDictionary *dic in [responseObject objectForKey:@"actions"]) {
                                if ([dic isKindOfClass:[NSDictionary class]]) {
                                    //[dic modelToJSONString];
                                    MISTransactionRecordModel *model = [MISTransactionRecordModel parse:dic];
                                    if (weakSelf.misRecordArray.count == 0) {
                                        [weakSelf.misRecordArray addObject:model];
                                    }else{
                                        NSMutableArray *temp = [weakSelf.misRecordArray mutableCopy];
                                        NSInteger num = 0;
                                        for (MISTransactionRecordModel *obj in temp) {
                                            if ([obj.action_trace.trx_id isEqualToString:model.action_trace.trx_id]) {
                                                break;
                                            }else{
                                                num++;
                                            }
                                        }if (num >= temp.count) {
                                            [weakSelf.misRecordArray addObject:model];
                                        }
                                        [temp removeAllObjects];
                                    }
                                   
                                }
                            }
                            NSMutableArray *arrCopy = [weakSelf.misRecordArray mutableCopy];
                            if (arrCopy == nil || !arrCopy || arrCopy.count == 0) {
                                return ;
                            }
                            for (int i = 0;i<arrCopy.count-1;i++) {
                                
                                MISTransactionRecordModel *modelx = arrCopy[i];
                                if (modelx) {
                                    
                                }
                                for (int j = i+1;j<arrCopy.count;j++) {
                                    MISTransactionRecordModel *modely = arrCopy[j];
                                    if ([modelx.action_trace.trx_id isEqualToString:modely.action_trace.trx_id]) {
                                        [weakSelf.misRecordArray removeObject:modely];
                                    }
                                }
                            }
                            [weakSelf.misRecordArray sortUsingComparator:^NSComparisonResult(MISTransactionRecordModel * obj1,MISTransactionRecordModel * obj2) {
                                return obj1.account_action_seq < obj2.account_action_seq;
                            }];
                            dispatch_async_on_main_queue(^{
                                [weakSelf.tableView reloadData];
                            });
                            
                        }
                    }
                }
            } failure:^(NSError *error) {
                
                 [weakSelf.view showAlert:@"error!" DetailMsg:error.description];
            }];
            
        }];
        [self.scrollView addFooterRefresh:^{
            NSString *name = [weakSelf.wallet.walletName componentsSeparatedByString:@"_"].lastObject;
            [[HTTPRequestManager shareManager] post:eos_get_actions paramters:@{@"account_name":name ,@"pos":@0,@"offset":@1000} success:^(BOOL isSuccess, id responseObject) {
                [weakSelf.scrollView endFooterRefresh];
                if (isSuccess) {
                    if ([responseObject isKindOfClass:[NSDictionary class]]) {
                        if ([[responseObject objectForKey:@"actions"] isKindOfClass:[NSArray class]]) {
                            for (NSDictionary *dic in [responseObject objectForKey:@"actions"]) {
                                if ([dic isKindOfClass:[NSDictionary class]]) {
                                    //[dic modelToJSONString];
                                    MISTransactionRecordModel *model = [MISTransactionRecordModel parse:dic];
                                    if (weakSelf.misRecordArray.count == 0) {
                                        [weakSelf.misRecordArray addObject:model];
                                    }else{
                                        NSMutableArray *temp = [weakSelf.misRecordArray mutableCopy];
                                        NSInteger num = 0;
                                        for (MISTransactionRecordModel *obj in temp) {
                                            if ([obj.action_trace.trx_id isEqualToString:model.action_trace.trx_id]) {
                                                break;
                                            }else{
                                                num++;
                                            }
                                        }if (num >= temp.count) {
                                            [weakSelf.misRecordArray addObject:model];
                                        }
                                        [temp removeAllObjects];
                                    }
                                    
                                }
                            }
                            NSMutableArray *arrCopy = [weakSelf.misRecordArray mutableCopy];
                            if (arrCopy == nil || !arrCopy || arrCopy.count == 0) {
                                return ;
                            }
                            for (int i = 0;i<arrCopy.count-1;i++) {
                                
                                MISTransactionRecordModel *modelx = arrCopy[i];
                                if (modelx) {
                                    
                                }
                                for (int j = i+1;j<arrCopy.count;j++) {
                                    MISTransactionRecordModel *modely = arrCopy[j];
                                    if ([modelx.action_trace.trx_id isEqualToString:modely.action_trace.trx_id]) {
                                        [weakSelf.misRecordArray removeObject:modely];
                                    }
                                }
                            }
                            [weakSelf.misRecordArray sortUsingComparator:^NSComparisonResult(MISTransactionRecordModel * obj1,MISTransactionRecordModel * obj2) {
                                return obj1.account_action_seq < obj2.account_action_seq;
                            }];
                            dispatch_async_on_main_queue(^{
                                [weakSelf.tableView reloadData];
                            });
                            
                        }
                    }
                }
            } failure:^(NSError *error) {
                [weakSelf.view showAlert:@"error!" DetailMsg:error.description];
            }];
        }];
        CurrentNodes *nodes = [CreateAll GetCurrentNodes];
        if (nodes && nodes.nodeMis.length>3) {
            [self.scrollView beginHeaderRefresh];
        }
    }
}


-(void)initHeadView{
    UIView *headBackView = [UIView new];
    headBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headBackView];
    [headBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(0);
        make.height.equalTo(SafeAreaTopHeight);
    }];
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.backgroundColor = [UIColor clearColor];
    _backBtn.tintColor = [UIColor whiteColor];
    [_backBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [_backBtn setImage:[UIImage imageNamed:@"ico_right_arrow"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backBtn];
    _backBtn.userInteractionEnabled = YES;
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(SafeAreaTopHeight - 34);
        make.height.equalTo(25);
        make.left.equalTo(10);
        make.width.equalTo(30);
    }];
    
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont boldSystemFontOfSize:17];
    _titleLabel.textColor = [UIColor textBlackColor];
    if (self.wallet.coinType == MIS) {
        [_titleLabel setText:@"MIS"];
    }else if (self.wallet.coinType == EOS){
        [_titleLabel setText:@"EOS"];
    }
    
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(SafeAreaTopHeight - 30);
        make.left.equalTo(45);
        make.width.equalTo(200);
        make.height.equalTo(20);
    }];
    
    _scanBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    [_scanBtn setBackgroundImage:[UIImage imageNamed:@"wallet_scan"] forState:UIControlStateNormal];
    [_scanBtn addTarget:self action:@selector(scanBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_scanBtn];
    [_scanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-20);
        make.top.equalTo(SafeAreaTopHeight - 29);
        make.width.equalTo(16);
        make.height.equalTo(16);
    }];
    
}

//点击复制地址
-(void)addressBtnAction:(UIButton *)btn{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _wallet.address;
    [self.view showMsg:NSLocalizedString(@"地址已复制", nil)];
    NSLog(@"addressBtn %ld %@",btn.tag,pasteboard.string);
}

//转账
-(void)trasAction{
    TransactionVC *tranvc = [TransactionVC new];
    tranvc.wallet = self.wallet;
    [self.navigationController pushViewController:tranvc animated:YES];
}
//收款
-(void)receiptAction{
    ReceiptQRCodeVC *revc = [ReceiptQRCodeVC new];
    revc.wallet = self.wallet;
    [self.navigationController pushViewController:revc animated:YES];
}
//行情
-(void)marketAction{
    VTwoMarketDetailVC *devc = [VTwoMarketDetailVC new];
    devc.RMBDollarCurrency = self.RMBDollarCurrency <= 0?6.8:self.RMBDollarCurrency;
    devc.marketModel = [MarketTicketModel new];
    NSString *symbol = nil;
    switch (self.wallet.coinType) {
        case BTC:
            symbol = @"BTC";
            break;
        case BTC_TESTNET:
            symbol = @"BTC";
            break;
        case ETH:
            symbol = @"ETH";
            break;
        case EOS:
            symbol = @"EOS";
            break;
        case MIS:
            symbol = @"MIS";
        case MGP:
            symbol = @"MGP";
            break;
            
        default:
            break;
    }
    devc.marketModel.coinCode = symbol;
    
//    [self.navigationController pushViewController:devc animated:YES];
    [self.view showMsg:@"暂未开启"];

}

//导出
-(void)exportAction{
    ExportWalletVC *evc = [ExportWalletVC new];
    evc.wallet = _wallet;
    [self.navigationController pushViewController:evc animated:YES];
}

//扫描二维码 ??
-(void)scanBtnAction{
    WBQRCodeVC *WBVC = [[WBQRCodeVC alloc] init];
    [self QRCodeScanVC:WBVC];
    MJWeakSelf
    [WBVC setGetQRCodeResult:^(NSString *string) {
        if(VALIDATE_STRING(string)){
            TransactionVC *tranvc = [TransactionVC new];
            if([string isValidBitcoinAddress]){
                for (MissionWallet *wallet in weakSelf.walletArray) {
                    if (wallet.walletType == LOCAL_WALLET && (wallet.coinType == BTC ||wallet.coinType == BTC_TESTNET)) {
                        tranvc.wallet = wallet;
                    }
                }
                tranvc.toAddress = string;
                [weakSelf.navigationController pushViewController:tranvc animated:YES];
            }else if ([CreateAll ValidHexString:string]){
                for (MissionWallet *wallet in weakSelf.walletArray) {
                    if (wallet.walletType == LOCAL_WALLET && (wallet.coinType == ETH)) {
                        tranvc.wallet = wallet;
                    }
                }
                tranvc.toAddress = string;
                [weakSelf.navigationController pushViewController:tranvc animated:YES];
            }else if([string containsString:@"MIS"]){
                for (MissionWallet *wallet in weakSelf.walletArray) {
                    if (wallet.walletType == LOCAL_WALLET && (wallet.coinType == MIS)) {
                        tranvc.wallet = wallet;
                    }
                }
                tranvc.toAddress = [string componentsSeparatedByString:@"@MIS@"].lastObject;
                [weakSelf.navigationController pushViewController:tranvc animated:YES];
            }else if([NSString checkEOSAccount:string]){
                for (MissionWallet *wallet in weakSelf.walletArray) {
                    if (wallet.walletType == LOCAL_WALLET && (wallet.coinType == EOS)) {
                        tranvc.wallet = wallet;
                    }
                    if (wallet.walletType == LOCAL_WALLET && (wallet.coinType == MGP)) {
                        tranvc.wallet = wallet;
                    }
                }
                tranvc.toAddress = string;
                [weakSelf.navigationController pushViewController:tranvc animated:YES];
            }else{
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = string;
                [weakSelf.view showMsg:[NSString stringWithFormat:@"\"%@\" %@",string, NSLocalizedString(@"已复制", nil)]];
            }
            
            
            NSLog(@"QRCode result = %@",string);
        }
    }];
}

//扫码判断权限
- (void)QRCodeScanVC:(UIViewController *)scanVC {
    MJWeakSelf
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        switch (status) {
            case AVAuthorizationStatusNotDetermined: {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    if (granted) {
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            // [weakSelf.navigationController pushViewController:scanVC animated:YES];
                            UINavigationController *navisc = [[UINavigationController alloc]initWithRootViewController:scanVC];
                            [weakSelf presentViewController:navisc animated:YES completion:^{
                                
                            }];
                        });
                        NSLog(NSLocalizedString(@"用户第一次同意了访问相机权限 - - %@", nil), [NSThread currentThread]);
                    } else {
                        NSLog(NSLocalizedString(@"用户第一次拒绝了访问相机权限 - - %@", nil), [NSThread currentThread]);
                    }
                }];
                break;
            }
            case AVAuthorizationStatusAuthorized: {
                // [weakSelf.navigationController pushViewController:scanVC animated:YES];
                UINavigationController *navisc = [[UINavigationController alloc]initWithRootViewController:scanVC];
                [weakSelf presentViewController:navisc animated:YES completion:^{
                    
                }];
                break;
            }
            case AVAuthorizationStatusDenied: {
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:NSLocalizedString(@"请去-> [设置 - 隐私 - 相机 - MisToken] 打开访问开关", nil) preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *alertA = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                
                [alertC addAction:alertA];
                [weakSelf presentViewController:alertC animated:YES completion:nil];
                break;
            }
            case AVAuthorizationStatusRestricted: {
                NSLog(NSLocalizedString(@"因为系统原因, 无法访问相册", nil));
                break;
            }
                
            default:
                break;
        }
        return;
    }
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:NSLocalizedString(@"未检测到您的摄像头", nil) preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *alertA = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertC addAction:alertA];
    [self presentViewController:alertC animated:YES completion:nil];
}

-(WalletDetailView *)detailview{
    if (!_detailview) {
        _detailview = [WalletDetailView new];
        _detailview.cointype = _wallet.coinType;
        _detailview.wallettype = _wallet.walletType;
        _detailview.iconImageView.image = self.iconimage;
        NSString *misname = [_wallet.walletName componentsSeparatedByString:@"_"].firstObject;
        NSString *name = [_wallet.walletName componentsSeparatedByString:@"_"].lastObject;
        _detailview.symbolNamelb.text = misname;
        _detailview.symboldetaillb.text = self.symbolname;
        _detailview.amountlb.text = self.amountstring;
        _detailview.balancelb.text = self.balancestring;
        if (_wallet.coinType == MGP || _wallet.coinType == EOS){
            [_detailview.addressBtn setTitle:name forState:UIControlStateNormal];
        }
        [_detailview.addressBtn addTarget:self action:@selector(copyAddress:) forControlEvents:UIControlEventTouchUpInside];
        if(self.wallet.coinType != MIS){
//            _detailview.infotextView.text = NSLocalizedString(@"无", nil);
        }
        [self.bridgeContentView addSubview:_detailview];
        if(self.wallet.coinType != MIS){
            [_detailview mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(0);
                make.left.right.equalTo(0);
                make.height.equalTo(100);
            }];
        }else{
            [_detailview mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(0);
                make.left.right.equalTo(0);
                make.height.equalTo(70);
            }];
        }
        
    }
    return _detailview;
}


//点击复制地址
-(void)copyAddress:(UIButton *)btn{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _wallet.address;
    [self.view showMsg:NSLocalizedString(@"地址已复制", nil)];
    NSLog(@"addressBtn %ld %@",btn.tag,pasteboard.string);
}

-(DetailBtnsView *)detailbtnsview{
    if (!_detailbtnsview) {
        _detailbtnsview = [DetailBtnsView new];
        _detailbtnsview.backgroundColor = [UIColor whiteColor];
        [_detailbtnsview.transBtn setTitle:NSLocalizedString(@"我要转账", nil) forState:UIControlStateNormal];
        [_detailbtnsview.transBtn addTarget:self action:@selector(trasAction) forControlEvents:UIControlEventTouchUpInside];
        [_detailbtnsview.receiptBtn setTitle:NSLocalizedString(@"我的收款码", nil) forState:UIControlStateNormal];
        [_detailbtnsview.receiptBtn addTarget:self action:@selector(receiptAction) forControlEvents:UIControlEventTouchUpInside];
        [_detailbtnsview.marketBtn setTitle:NSLocalizedString(@"导出钱包", nil) forState:UIControlStateNormal];
        [_detailbtnsview.marketBtn addTarget:self action:@selector(exportAction) forControlEvents:UIControlEventTouchUpInside];
        [self.bridgeContentView addSubview:_detailbtnsview];
        if(self.wallet.coinType != MIS){
            [_detailbtnsview mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.detailview.mas_bottom).equalTo(5);
                make.left.right.equalTo(0);
                make.height.equalTo(110);
            }];
        }else{
            [_detailbtnsview mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.detailview.mas_bottom).equalTo(5);
                make.left.right.equalTo(0);
                make.height.equalTo(110);
            }];
        }
       
    }
    return _detailbtnsview;
}

-(void)proManageAction{
    EOSProManageVC *vc = [EOSProManageVC new];
    vc.wallet = self.wallet;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)perCheckAction{
    EOSAuthorityVC *vc = [EOSAuthorityVC new];
    vc.wallet = self.wallet;
    [self.navigationController pushViewController:vc animated:YES];
}


-(EOSDetailBtnsView *)eosdetailbtnsview{
    if (!_eosdetailbtnsview) {
        _eosdetailbtnsview = [EOSDetailBtnsView new];
        _eosdetailbtnsview.backgroundColor = [UIColor whiteColor];
        [_eosdetailbtnsview.transBtn setTitle:NSLocalizedString(@"我要转账", nil) forState:UIControlStateNormal];
        [_eosdetailbtnsview.transBtn addTarget:self action:@selector(trasAction) forControlEvents:UIControlEventTouchUpInside];
        [_eosdetailbtnsview.receiptBtn setTitle:NSLocalizedString(@"我的收款码", nil) forState:UIControlStateNormal];
        [_eosdetailbtnsview.receiptBtn addTarget:self action:@selector(receiptAction) forControlEvents:UIControlEventTouchUpInside];
        [_eosdetailbtnsview.proManageBtn setTitle:NSLocalizedString(@"资源管理", nil) forState:UIControlStateNormal];
        [_eosdetailbtnsview.proManageBtn addTarget:self action:@selector(proManageAction) forControlEvents:UIControlEventTouchUpInside];
        [_eosdetailbtnsview.marketBtn setTitle:NSLocalizedString(@"投票管理", nil) forState:UIControlStateNormal];
        [_eosdetailbtnsview.marketBtn addTarget:self action:@selector(marketAction) forControlEvents:UIControlEventTouchUpInside];
        [_eosdetailbtnsview.exportBtn setTitle:NSLocalizedString(@"导出钱包", nil) forState:UIControlStateNormal];
        [_eosdetailbtnsview.exportBtn addTarget:self action:@selector(exportAction) forControlEvents:UIControlEventTouchUpInside];
        [_eosdetailbtnsview.perCheckBtn setTitle:NSLocalizedString(@"权限查看", nil) forState:UIControlStateNormal];
        [_eosdetailbtnsview.perCheckBtn addTarget:self action:@selector(perCheckAction) forControlEvents:UIControlEventTouchUpInside];
        [self.bridgeContentView addSubview:_eosdetailbtnsview];
        [_eosdetailbtnsview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.detailview.mas_bottom).equalTo(5);
            make.left.right.equalTo(0);
            make.height.equalTo(110);
        }];
        
    }
    return _eosdetailbtnsview;
}

#pragma tableView - delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    view.frame = CGRectMake(0, 0, ScreenWidth, 40);
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor textDarkColor];
    label.text = NSLocalizedString(@"交易记录", nil);
    [view addSubview:label];
    [label  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.centerY.equalTo(0);
        make.width.equalTo(150);
        make.height.equalTo(15);
    }];
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor lineGrayColor];
    [view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.bottom.equalTo(0);
        make.height.equalTo(1);
    }];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.wallet.coinType == MIS) {
        return self.misRecordArray.count;
    }else if(self.wallet.coinType == EOS){
        return self.eosRecordArray.count;
    }else if(self.wallet.coinType == MGP){
        return self.eosRecordArray.count;
    }else{
        return 0;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TransactionRecordDetailVC *dvc = [TransactionRecordDetailVC new];
    dvc.wallet = self.wallet;
    if (self.wallet.coinType == MIS) {
        dvc.misRecord = self.misRecordArray[indexPath.row];
        dvc.fromAddress = dvc.misRecord.action_trace.act.data.from;
        dvc.toAddress = dvc.misRecord.action_trace.act.data.to;
    }else if(self.wallet.coinType == EOS){
        dvc.misRecord = self.eosRecordArray[indexPath.row];
        dvc.fromAddress = dvc.misRecord.action_trace.act.data.from;
        dvc.toAddress = dvc.misRecord.action_trace.act.data.to;
    }else if(self.wallet.coinType == MGP){
        dvc.misRecord = self.eosRecordArray[indexPath.row];
        dvc.fromAddress = dvc.misRecord.action_trace.act.data.from;
        dvc.toAddress = dvc.misRecord.action_trace.act.data.to;
    }
    [self.navigationController pushViewController:dvc animated:YES];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TransactionRecordCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"TransactionRecordCell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    if (cell == nil) {
        cell = [TransactionRecordCell new];
    }
    
    if (self.wallet.coinType == MIS){
        [cell.iconImageView setImage:[UIImage imageNamed:@"ico_mis"]];
        MISTransactionRecordModel *model;
        model = self.misRecordArray[indexPath.row];
        //2018-10-26T01:59:45.000
        NSDate *date = [NSDate dateFromString:model.block_time];
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
        NSTimeInterval time = [timeSp doubleValue];
        
        NSDate *date2=[NSDate dateWithTimeIntervalSince1970:time];
        NSDate *date3 = [date2 dateByAddingHours:8];
        NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
        
        [dateformatter setDateFormat:@"YYYY/MM/dd HH:mm:ss"];
        
        NSString *staartstr=[dateformatter stringFromDate:date3];
        [cell.timelb setText:staartstr];

        NSString *from = model.action_trace.act.data.from;
        NSString *to =  model.action_trace.act.data.to;
        NSString *amount = [model.action_trace.act.data.quantity componentsSeparatedByString:@" "].firstObject;
        NSString *name = [self.wallet.walletName componentsSeparatedByString:@"_"].lastObject;
        if ([from isEqualToString:name] && [to isEqualToString:name]) {
            cell.amountlb.text = [NSString stringWithFormat:@"+%@", amount];
            [cell.amountlb setTextColor:[UIColor textGrayColor]];
            cell.addresslb.text = from;
        }else if([from isEqualToString:name]){
            cell.amountlb.text = [NSString stringWithFormat:@"-%@", amount];
             [cell.amountlb setTextColor:[UIColor textOrangeColor]];
            cell.addresslb.text = to;
        }else if([to isEqualToString:name]){
            cell.amountlb.text = [NSString stringWithFormat:@"+%@", amount];
            [cell.amountlb setTextColor:[UIColor textBlueColor]];
            cell.addresslb.text = from;
        }else{
            cell.amountlb.text = [NSString stringWithFormat:@"0.0000 MGP"];
            [cell.amountlb setTextColor:[UIColor textGrayColor]];
            cell.addresslb.text = to;
        }
       
        if (amount.doubleValue <= 0) {
             cell.resultlb.text = NSLocalizedString(@"失败", nil);
        }else{
             cell.resultlb.text = NSLocalizedString(@"成功", nil);
        }
        
    }else if (self.wallet.coinType == EOS || self.wallet.coinType == MGP){
        [cell.iconImageView setImage:[UIImage imageNamed:self.wallet.coinType == MGP?@"ico_mis":@"ico_eos"]];
        MISTransactionRecordModel *model;
        model = self.eosRecordArray[indexPath.row];
        //2018-10-26T01:59:45.000
        NSDate *date = [NSDate dateFromString:model.block_time];
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
        NSTimeInterval time = [timeSp doubleValue];
        
        NSDate *date2=[NSDate dateWithTimeIntervalSince1970:time];
        NSDate *date3 = [date2 dateByAddingHours:8];
        NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
        
        [dateformatter setDateFormat:@"YYYY/MM/dd HH:mm:ss"];
        
        NSString *staartstr=[dateformatter stringFromDate:date3];
        [cell.timelb setText:staartstr];
        
        NSString *from = model.action_trace.act.data.from;
        NSString *to =  model.action_trace.act.data.to;
        NSString *amount = [model.action_trace.act.data.quantity componentsSeparatedByString:@" "].firstObject;
        
        NSString *name = [self.wallet.walletName componentsSeparatedByString:@"_"].lastObject;
        
        //@"transfer,dice,delegatebw,receive-action,send-action,newaccount,buyrambytes,undelegatebw,sellram"
        if ([@"transfer" containsString:VALIDATE_STRING(model.action_trace.act.name)]){
            if ([from isEqualToString:name] && [to isEqualToString:name]) {
                cell.amountlb.text = [NSString stringWithFormat:@"+%@ %@", amount,self.wallet.coinType == MGP?@"MGP":@"EOS"];
                [cell.amountlb setTextColor:[UIColor textGrayColor]];
                cell.addresslb.text = from;
            }else if([from isEqualToString:name]){
                cell.amountlb.text = [NSString stringWithFormat:@"-%@ %@", amount,self.wallet.coinType == MGP?@"MGP":@"EOS"];
                [cell.amountlb setTextColor:[UIColor textOrangeColor]];
                cell.addresslb.text = to;
            }else if([to isEqualToString:name]){
                cell.amountlb.text = [NSString stringWithFormat:@"+%@ %@", amount,self.wallet.coinType == MGP?@"MGP":@"EOS"];
                [cell.amountlb setTextColor:[UIColor textBlueColor]];
                cell.addresslb.text = from;
            }
        }else if([@"delegatebw" containsString:VALIDATE_STRING(model.action_trace.act.name)]){
            amount = [NSString stringWithFormat:@"%.4f",([model.action_trace.act.data.stake_cpu_quantity componentsSeparatedByString:@" "].firstObject.doubleValue+[model.action_trace.act.data.stake_net_quantity componentsSeparatedByString:@" "].firstObject.doubleValue)];
            cell.amountlb.text = [NSString stringWithFormat:@"-%@ %@", amount,self.wallet.coinType == MGP?@"MGP":@"EOS"];
            cell.addresslb.text = model.action_trace.act.data.receiver;
            [cell.amountlb setTextColor:[UIColor textOrangeColor]];
           
        }else if([@"undelegatebw" containsString:VALIDATE_STRING(model.action_trace.act.name)]){
            amount = [NSString stringWithFormat:@"%.4f",([model.action_trace.act.data.unstake_cpu_quantity componentsSeparatedByString:@" "].firstObject.doubleValue+[model.action_trace.act.data.unstake_net_quantity componentsSeparatedByString:@" "].firstObject.doubleValue)];
            cell.amountlb.text = [NSString stringWithFormat:@"+%@ %@", amount,self.wallet.coinType == MGP?@"MGP":@"EOS"];
            cell.addresslb.text = model.action_trace.act.data.receiver;
            [cell.amountlb setTextColor:[UIColor textBlueColor]];
        }else if([@"receive-action" containsString:VALIDATE_STRING(model.action_trace.act.name)]){
            
        }else if([@"send-action" containsString:VALIDATE_STRING(model.action_trace.act.name)]){
            
        }else if([@"newaccount" containsString:VALIDATE_STRING(model.action_trace.act.name)]){
            NSMutableDictionary *dic = ([model.action_trace.account_ram_deltas isKindOfClass:[NSArray class]] && model.action_trace.account_ram_deltas.count > 0)?[model.action_trace.account_ram_deltas[0] mutableCopy]:nil;
            if (dic) {
                NSString *toaccount = [dic objectForKey:@"account"];
                cell.addresslb.text = VALIDATE_STRING(toaccount);
            }
            cell.amountlb.text = @"0.000 ";
        }else if([VALIDATE_STRING(model.action_trace.act.name) isEqualToString:@"buyram"]){
            amount = model.action_trace.act.data.quant;
            cell.amountlb.text = [NSString stringWithFormat:@"-%@", amount];
            cell.addresslb.text = [model.action_trace.act.data.receiver isEqualToString:_wallet.address]?model.action_trace.act.data.payer:model.action_trace.act.data.receiver;
            [cell.amountlb setTextColor:[UIColor textBlueColor]];
        }else if([VALIDATE_STRING(model.action_trace.act.name) containsString:@"sellram"]){
//            NSString *eosamount = nil;
//            for (MISTransactionRecordModel *obj in self.eosallRecordArray) {
//                if ([obj.action_trace.trx_id isEqualToString:model.action_trace.trx_id]) {
//                    if ([obj.action_trace.inline_traces isKindOfClass:[NSArray class]] && obj.action_trace.inline_traces.count >0) {
//                        if ([obj.action_trace.inline_traces[0].act.data.memo isEqualToString:@"sell ram"]) {
//                            eosamount = obj.action_trace.inline_traces[0].act.data.quantity;
//                        }else if ([obj.action_trace.inline_traces[1].act.data.memo isEqualToString:@"sell ram"]){
//                            eosamount = obj.action_trace.inline_traces[1].act.data.quantity;
//                        }
//                    }
//                }
//            }
            amount = model.action_trace.act.data.bytes;
            cell.amountlb.text = [NSString stringWithFormat:@"-%@ bytes", amount];
            cell.addresslb.text = model.action_trace.act.data.account;
            [cell.amountlb setTextColor:[UIColor textBlueColor]];
            
            
        }else if([@"dice" containsString:VALIDATE_STRING(model.action_trace.act.name)]){
            cell.amountlb.text = @"+eos";
            cell.addresslb.text = from;
        }else if([VALIDATE_STRING(model.action_trace.act.name) containsString:@"buyrambytes"]){
            amount = model.action_trace.act.data.bytes;
            cell.amountlb.text = [NSString stringWithFormat:@"-%@ bytes", amount];
            cell.addresslb.text = [model.action_trace.act.data.receiver isEqualToString:_wallet.address]?model.action_trace.act.data.payer:model.action_trace.act.data.receiver;
            [cell.amountlb setTextColor:[UIColor textBlueColor]];
        }
        
        
        cell.resultlb.text = VALIDATE_STRING(model.action_trace.act.name);
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins  = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        UIView *view = [[UIView alloc] init];
        _tableView.tableFooterView = view;
        [_tableView registerClass:[TransactionRecordCell class] forCellReuseIdentifier:@"TransactionRecordCell"];
        [self.bridgeContentView addSubview:_tableView];
        if (self.wallet.coinType == MIS) {
            [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.detailbtnsview.mas_bottom).equalTo(5);
                make.left.right.equalTo(0);
                make.bottom.equalTo(0);
            }];
        }else{
            [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.eosdetailbtnsview.mas_bottom).equalTo(5);
                make.left.right.equalTo(0);
                make.bottom.equalTo(0);
            }];
        }
       
    }
    return _tableView;
}

-(UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.scrollEnabled = YES;
        _scrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight + 350);
        _scrollView.delegate =self;
        _scrollView.scrollsToTop = YES;
        [self.view addSubview:_scrollView];
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.top.equalTo(SafeAreaTopHeight);
            make.bottom.equalTo(-SafeAreaBottomHeight);
        }];
        _bridgeContentView = [UIView new];
        _bridgeContentView.backgroundColor = [UIColor ExportBackgroundColor];
        [self.scrollView addSubview:_bridgeContentView];
        [_bridgeContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.scrollView);
            make.width.height.equalTo(self.scrollView.contentSize);
        }];
    }
    
    return _scrollView;
}

@end
