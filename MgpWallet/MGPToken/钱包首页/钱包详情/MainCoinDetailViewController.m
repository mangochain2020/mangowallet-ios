//
//  MainCoinDetailViewController.m
//  TaiYiToken
//
//  Created by mac on 2020/7/15.
//  Copyright © 2020 admin. All rights reserved.
//

#import "MainCoinDetailViewController.h"
#import "TransactionRecordCell.h"
#import "ReceiptQRCodeVC.h"
#import "TransactionVC.h"
#import "TransactionRecordDetailVC.h"

#define EOSRecordShowTypes @"transfer,dice,delegatebw,receive-action,send-action,newaccount,buyrambytes,undelegatebw,sellram"
#define BTCRecordListPageSize 20

@interface MainCoinDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(weak, nonatomic) IBOutlet UITableView *tableview;
@property(weak, nonatomic) IBOutlet UIButton *leftBtn;
@property(weak, nonatomic) IBOutlet UIButton *rightBtn;
@property(weak, nonatomic) IBOutlet UISegmentedControl *segmented;
@property(weak, nonatomic) IBOutlet UIView *buttonBg;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *buttonBgHight;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *segmentedHight;

@property(nonatomic)NSMutableArray <MISTransactionRecordModel *>*recordArray;
@property(nonatomic)NSMutableArray <MISTransactionRecordModel *>*allRecordArray;//未过滤trid

@property(nonatomic,strong)NSMutableArray <Tx *>*btcRecordArray;
@property(nonatomic,strong)NSMutableArray <ETHTransactionRecordModel *>*ethRecordArray;
@property(nonatomic,strong)NSMutableArray <USDTTxListData *>*usdtRecordArray;
@property(nonatomic,strong)NSDateFormatter* formatter;


@property(nonatomic)int page;


@end

@implementation MainCoinDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.wallet.walletName;
    self.tableview.tableFooterView = [UIView new];
    self.tableview.rowHeight = 70;
    [_tableview registerClass:[TransactionRecordCell class] forCellReuseIdentifier:@"TransactionRecordCell"];

    self.formatter = [[NSDateFormatter alloc] init];
    [_formatter setDateStyle:NSDateFormatterMediumStyle];
    [_formatter setTimeStyle:NSDateFormatterShortStyle];
    [_formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    
    [self.leftBtn setTitle:NSLocalizedString(@"收款", nil) forState:UIControlStateNormal];
    [self.rightBtn setTitle:NSLocalizedString(@"转账", nil) forState:UIControlStateNormal];
    
    [self.segmented setTitle:NSLocalizedString(@"全部", nil) forSegmentAtIndex:0];
    [self.segmented setTitle:NSLocalizedString(@"转出", nil) forSegmentAtIndex:1];
    [self.segmented setTitle:NSLocalizedString(@"转入", nil) forSegmentAtIndex:2];
    [self.segmented setTitle:NSLocalizedString(@"失败", nil) forSegmentAtIndex:3];

    
    switch (self.wallet.coinType) {
        case ETH:
        {
            self.ethRecordArray = [NSMutableArray new];
            MJWeakSelf
            [self.tableview addHeaderRefresh:^{
                [NetManager GetETHAccounttxList:weakSelf.wallet.address CompletionHandler:^(id responseObj, NSError *error) {
                    [weakSelf.tableview endHeaderRefresh];
                    if (responseObj){
                        if ([responseObj[@"status"]intValue] == 1) {
                            [weakSelf.ethRecordArray removeAllObjects];
                            
                            for (NSDictionary *dic in responseObj[@"result"]) {
                                ETHTransactionRecordModel *model = [ETHTransactionRecordModel mj_objectWithKeyValues:dic];
                                [weakSelf.ethRecordArray addObject:model];
                            }
                            [weakSelf.tableview reloadData];

                        }
                    }
                    
                    
                    
                }];
                
                
            }];
            
        }
            break;
        case BTC:
        case BTC_TESTNET:
        {
            self.btcRecordArray = [NSMutableArray new];
            MJWeakSelf
            [self.tableview addHeaderRefresh:^{
                [weakSelf.btcRecordArray removeAllObjects];
                weakSelf.page = 0;
                NSString *addr;
                if (weakSelf.wallet.changeAddressArray != nil && weakSelf.wallet.changeAddressArray.count > 0) {
                    addr = [self.wallet.changeAddressStr stringByReplacingOccurrencesOfString:@"," withString:@"|"];
                    NSLog(@"addr %@",addr);
                }else{
                    addr = self.wallet.address;
                }
                [NetManager GetBTCTxFromBlockChainAddress:addr PageSize:BTCRecordListPageSize Offset:0 completionHandler:^(id responseObj, NSError *error) {
                    [weakSelf.tableview endHeaderRefresh];
                    if (error) {
                        [weakSelf.view showAlert:[NSString stringWithFormat:@"Error:%ld",error.code] DetailMsg:error.localizedDescription];
                    }else{
                        weakSelf.page ++;
                        if (responseObj) {
                            BTCBlockChainListModel *model = [BTCBlockChainListModel parse:responseObj];
                            NSArray *txsarr = responseObj[@"txs"];
                            NSMutableArray *arrcopyx = [NSMutableArray new];
                            for (NSInteger index = 0; index < txsarr.count && index < model.txs.count; index++) {
                                Tx *tx = model.txs[index];
                                NSDictionary *txdic = txsarr[index];
                                tx.hashs = (NSString *)(txdic[@"hash"]);
                                tx.outputs = [Output parse:txdic[@"out"] ];
                                [arrcopyx addObject:tx];
                            }
                            weakSelf.btcRecordArray = [arrcopyx mutableCopy];
                            NSMutableArray *arrCopy = [weakSelf.btcRecordArray mutableCopy];
                            if (arrCopy == nil || !arrCopy || arrCopy.count == 0) {
                                return ;
                            }
                            for (int i = 0;i<arrCopy.count-1;i++) {
                                Tx *modelx = arrCopy[i];
                                if (modelx) {
                                    NSLog(@"%ld",modelx.time);
                                }
                                for (int j = i+1;j<arrCopy.count;j++) {
                                    Tx *modely = arrCopy[j];
                                    if ([modelx.hashs isEqualToString:modely.hashs]) {
                                        [weakSelf.btcRecordArray removeObject:modely];
                                    }
                                }
                            }
                            [weakSelf.btcRecordArray sortUsingComparator:^NSComparisonResult(BTCTransactionRecordModel * obj1,BTCTransactionRecordModel * obj2) {
                                return obj1.time < obj2.time;
                            }];
                            dispatch_async_on_main_queue(^{
                                [weakSelf.tableview reloadData];
                            });
                        }
                    }
                }];
                
            }];
            
            [self.tableview addFooterRefresh:^{
    //            weakSelf.page ++;
                NSString *addr;
                if (weakSelf.wallet.changeAddressArray != nil && weakSelf.wallet.changeAddressArray.count > 0) {
                    addr = [self.wallet.changeAddressStr stringByReplacingOccurrencesOfString:@"," withString:@"|"];
                }else{
                    addr = self.wallet.address;
                }
                [NetManager GetBTCTxFromBlockChainAddress:addr PageSize:BTCRecordListPageSize Offset:BTCRecordListPageSize*weakSelf.page completionHandler:^(id responseObj, NSError *error) {
                    [weakSelf.tableview endFooterRefresh];
                    if (error) {
                        [weakSelf.view showAlert:[NSString stringWithFormat:@"Error:%ld",error.code] DetailMsg:error.localizedDescription];
                    }else{
                        weakSelf.page ++;
                        if (responseObj) {
                            BTCBlockChainListModel *model = [BTCBlockChainListModel parse:responseObj];
                            NSArray *txsarr = responseObj[@"txs"];
                            NSMutableArray *arrcopyx = [NSMutableArray new];
                            for (NSInteger index = 0; index < txsarr.count && index < model.txs.count; index++) {
                                Tx *tx = model.txs[index];
                                NSDictionary *txdic = txsarr[index];
                                tx.hashs = (NSString *)(txdic[@"hash"]);
                                tx.outputs = [Output parse:txdic[@"out"] ];
                                [arrcopyx addObject:tx];
                            }
                            
                            [weakSelf.btcRecordArray addObjectsFromArray:arrcopyx];
                            NSMutableArray *arrCopy = [weakSelf.btcRecordArray mutableCopy];
                            if (arrCopy == nil || !arrCopy || arrCopy.count == 0) {
                                return ;
                            }
                            for (int i = 0;i<arrCopy.count-1;i++) {
                                Tx *modelx = arrCopy[i];
                                if (modelx) {
                                    NSLog(@"%ld",modelx.time);
                                }
                                for (int j = i+1;j<arrCopy.count;j++) {
                                    Tx *modely = arrCopy[j];
                                    if ([modelx.hashs isEqualToString:modely.hashs]) {
                                        [weakSelf.btcRecordArray removeObject:modely];
                                    }
                                }
                            }
                            [weakSelf.btcRecordArray sortUsingComparator:^NSComparisonResult(BTCTransactionRecordModel * obj1,BTCTransactionRecordModel * obj2) {
                                return obj1.time < obj2.time;
                            }];
                            dispatch_async_on_main_queue(^{
                                [weakSelf.tableview reloadData];
                            });
                        }
                    }
                }];
                

            }];
        }
            break;
        case EOS:
        case MGP:
        {
            self.recordArray = [NSMutableArray new];
            self.allRecordArray = [NSMutableArray new];
            MJWeakSelf
            [self.tableview addHeaderRefresh:^{
                NSString *namex = weakSelf.wallet.address;
                HTTPRequestManager *manager = self.wallet.coinType == MGP ? [HTTPRequestManager shareMgpManager] : [HTTPRequestManager shareEosManager];
                [manager post:eos_get_actions paramters:@{@"account_name":namex ,@"pos":@0,@"offset":@1000} success:^(BOOL isSuccess, id responseObject) {
                    [weakSelf.tableview endHeaderRefresh];
                    [weakSelf.recordArray removeAllObjects];
                    [weakSelf.allRecordArray removeAllObjects];
                    if (isSuccess) {
                        if ([responseObject isKindOfClass:[NSDictionary class]]) {
                            if ([[responseObject objectForKey:@"actions"] isKindOfClass:[NSArray class]]) {
                                for (NSDictionary *dic in [responseObject objectForKey:@"actions"]) {
                                    if ([dic isKindOfClass:[NSDictionary class]]) {
                                        //[dic modelToJSONString];
                                        MISTransactionRecordModel *model = [MISTransactionRecordModel parse:dic];
                                        if (weakSelf.recordArray.count == 0) {
                                            [weakSelf.recordArray addObject:model];
                                            [weakSelf.allRecordArray addObject:model];
                                        }else{
                                            NSMutableArray *temp = [weakSelf.recordArray mutableCopy];
                                            NSInteger num = 0;
                                            
                                            for (MISTransactionRecordModel *obj in temp) {
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
                                                            [weakSelf.recordArray addObject:model];
                                                        }
                                                        [weakSelf.allRecordArray addObject:model];
                                                    }
                                                }else{
                                                    if (num >= temp.count) {
                                                        [weakSelf.recordArray addObject:model];
                                                    }
                                                    [weakSelf.allRecordArray addObject:model];
                                                }
                                            }
                                            
                                            [temp removeAllObjects];
                                        }
                                        
                                    }
                                }

                                [weakSelf.recordArray sortUsingComparator:^NSComparisonResult(MISTransactionRecordModel * obj1,MISTransactionRecordModel * obj2) {
                                    return obj1.account_action_seq < obj2.account_action_seq;
                                }];
                                dispatch_async_on_main_queue(^{
                                    [weakSelf.tableview reloadData];
                                });
                                
                            }
                        }
                    }
                } failure:^(NSError *error) {
                    
                    [weakSelf.view showAlert:@"error!" DetailMsg:error.description];
                }];
                
            }];
            [self.tableview addFooterRefresh:^{
                NSString *namex = weakSelf.wallet.address;
                HTTPRequestManager *manager = self.wallet.coinType == MGP ? [HTTPRequestManager shareMgpManager] : [HTTPRequestManager shareEosManager];
                [manager post:eos_get_actions paramters:@{@"account_name":namex ,@"pos":@1,@"offset":@1000} success:^(BOOL isSuccess, id responseObject) {
                    [weakSelf.tableview endFooterRefresh];
                    if (isSuccess) {
                        if ([responseObject isKindOfClass:[NSDictionary class]]) {
                            if ([[responseObject objectForKey:@"actions"] isKindOfClass:[NSArray class]]) {
                                for (NSDictionary *dic in [responseObject objectForKey:@"actions"]) {
                                    if ([dic isKindOfClass:[NSDictionary class]]) {
                                        //[dic modelToJSONString];
                                        MISTransactionRecordModel *model = [MISTransactionRecordModel parse:dic];
                                        if (weakSelf.recordArray.count == 0) {
                                            [weakSelf.recordArray addObject:model];
                                            [weakSelf.allRecordArray addObject:model];
                                        }else{
                                            NSMutableArray *temp = [weakSelf.recordArray mutableCopy];
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
                                                                [weakSelf.recordArray addObject:model];
                                                            }
                                                            [weakSelf.allRecordArray addObject:model];
                                                        }
                                                    }else{
                                                        if (num >= temp.count) {
                                                            [weakSelf.recordArray addObject:model];
                                                        }
                                                        [weakSelf.allRecordArray addObject:model];
                                                    }
                                                }
                                            }
                                            [temp removeAllObjects];
                                        }
                                        
                                    }
                                }

                                [weakSelf.recordArray sortUsingComparator:^NSComparisonResult(MISTransactionRecordModel * obj1,MISTransactionRecordModel * obj2) {
                                    return obj1.account_action_seq < obj2.account_action_seq;
                                }];
                                dispatch_async_on_main_queue(^{
                                    [weakSelf.tableview reloadData];
                                });
                                
                            }
                        }
                    }
                } failure:^(NSError *error) {
                    [weakSelf.view showAlert:@"error!" DetailMsg:error.description];
                }];
                
                }];
        }
            break;
        case USDT:
        {
            self.usdtRecordArray = [NSMutableArray new];
            MJWeakSelf
            [self.tableview addHeaderRefresh:^{
                [NetManager RequestUSDTTxListForAddress:weakSelf.wallet.address Page:0 CompletionHandler:^(id responseObj, NSError *error) {
                    [weakSelf.tableview endHeaderRefresh];
                    [weakSelf.usdtRecordArray removeAllObjects];
                    if (!error) {
                        weakSelf.page ++;
                        USDTTxListModel *model = [USDTTxListModel parse:responseObj];
                        weakSelf.usdtRecordArray = [model.transactions mutableCopy];
                        [weakSelf.usdtRecordArray sortUsingComparator:^NSComparisonResult(USDTTxListData * obj1,USDTTxListData * obj2) {
                            return obj1.blocktime < obj2.blocktime;
                        }];
                        dispatch_async_on_main_queue(^{
                            [weakSelf.tableview reloadData];
                        });
                    }else{
                        [weakSelf.view showMsg:error.userInfo.description];
                    }
                    
                }];
            }];
            [self.tableview addFooterRefresh:^{
                [NetManager RequestUSDTTxListForAddress:weakSelf.wallet.address Page:weakSelf.page CompletionHandler:^(id responseObj, NSError *error) {
                    [weakSelf.tableview endFooterRefresh];
                    if (!error) {
                        weakSelf.page ++;
                        USDTTxListModel *model = [USDTTxListModel parse:responseObj];
                        [weakSelf.usdtRecordArray addObjectsFromArray:model.transactions];
                        [weakSelf.usdtRecordArray sortUsingComparator:^NSComparisonResult(USDTTxListData * obj1,USDTTxListData * obj2) {
                            return obj1.blocktime < obj2.blocktime;
                        }];
                        dispatch_async_on_main_queue(^{
                            [weakSelf.tableview reloadData];
                        });
                    }else{
                        [weakSelf.view showMsg:error.userInfo.description];
                    }
                    
                }];
            }];
        }
            break;
        default:
            break;
    }
    [self.tableview beginHeaderRefresh];

    
}
/*
 ETH未打包的交易
 */
-(void)QueryETHPendingTxs{
    NSMutableArray *arr = [[CreateAll GetETHTxhashForAddr:self.wallet.address] mutableCopy];
    if (arr.count > 0) {
        NSString *hash = arr[0];
        [self RequestETHTx:hash Index:0 ALLHash:arr];
    }
}
-(void)RequestETHTx:(NSString *)hash Index:(NSInteger)index ALLHash:(NSArray *)hasharr {
    if (index == hasharr.count) {
        return;
    }
    hash = hasharr[index];
    index++;
    MJWeakSelf
    [CreateAll GetTransactionDetaslByHash:hash Callback:^(TransactionInfoPromise *promise) {
        if (promise) {
            ETHTransactionRecordModel *model = [ETHTransactionRecordModel new];
            model.info = promise.value;
            model.selectType = OUT_Trans;
            if (model.info.blockNumber < 0) {
                [weakSelf.recordArray addObject:model];
                NSMutableArray *arrCopy = [weakSelf.recordArray mutableCopy];
                if (arrCopy == nil || !arrCopy) {
                    return ;
                }
                for (int i = 0;i<arrCopy.count-1;i++) {
                    
                    ETHTransactionRecordModel *modelx = arrCopy[i];
                    for (int j = i+1;j<arrCopy.count;j++) {
                        ETHTransactionRecordModel *modely = arrCopy[j];
                        if ([modelx.info.transactionHash.hexString isEqualToString:modely.info.transactionHash.hexString]) {
                            if ([weakSelf.recordArray containsObject:modelx]) {
                                [weakSelf.recordArray removeObject:modelx];
                            }
                        }
                    }
                }
                [weakSelf.recordArray sortUsingComparator:^NSComparisonResult(ETHTransactionRecordModel * obj1,ETHTransactionRecordModel * obj2) {
                    return obj1.info.timestamp < obj2.info.timestamp;
                }];
                [weakSelf RequestETHTx:hash Index:index ALLHash:hasharr];
                dispatch_async_on_main_queue(^{
                    [weakSelf.tableview reloadData];
                });
            }else{
                [CreateAll DeleteETHTxHash:hash ForAddr:weakSelf.wallet.address];
            }
        }
    }];

}

//转账
- (IBAction)trasAction:(id)sender {
    TransactionVC *tranvc = [TransactionVC new];
    tranvc.wallet = self.wallet;
    [self.navigationController pushViewController:tranvc animated:YES];
}
//收款
- (IBAction)receiptAction:(id)sender {
    ReceiptQRCodeVC *revc = [ReceiptQRCodeVC new];
    revc.wallet = self.wallet;
    [self.navigationController pushViewController:revc animated:YES];
}



#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (self.wallet.coinType) {
        case ETH:
            return self.ethRecordArray.count;
            break;
        case BTC:
        case BTC_TESTNET:
            return self.btcRecordArray.count;
            break;
        case EOS:
        case MGP:
            return self.recordArray.count;
            break;
        case USDT:
            return self.usdtRecordArray.count;
            break;
        default:
            return 0;
            break;
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    TransactionRecordCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"TransactionRecordCell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    if (cell == nil) {
        cell = [TransactionRecordCell new];
    }
    switch (self.wallet.coinType) {
        case ETH:
        {
            [cell.iconImageView setImage:[UIImage imageNamed:@"ico_eth-1"]];
            ETHTransactionRecordModel *info;
            if (self.ethRecordArray.count > indexPath.row) {
                info = self.ethRecordArray[indexPath.row];

                
                NSString *str = [info.to isEqualToString:[@"" stringToLower:self.wallet.address]] ? @"+" : @"-";
                NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:[info.timeStamp integerValue]];
                NSString *timeStr=[_formatter stringFromDate:currentDate];
                [cell.timelb setText:[NSString stringWithFormat:@"%@",timeStr]];
                cell.addresslb.text = info.blockHash;
                CGFloat amount = info.value.integerValue * 1.0 / pow(10, 18);
                cell.amountlb.text = [NSString stringWithFormat:@"%@%.5f",str, amount];
                //判断交易是否有错
                if ([info.isError boolValue]) {
                     cell.resultlb.text = NSLocalizedString(@"失败", nil);
                    [cell.resultlb setTextColor:[UIColor redColor]];

                }else{
                      cell.resultlb.text = NSLocalizedString(@"成功", nil);
                    [cell.resultlb setTextColor:[UIColor textGrayColor]];

                }
            }
        }
            break;
        case BTC:
        case BTC_TESTNET:
        {
            [cell.iconImageView setImage:[UIImage imageNamed:@"ico_btc"]];
            if (self.btcRecordArray.count > indexPath.row) {
                Tx *model = self.btcRecordArray[indexPath.row];
                NSString *addr = nil;
                CGFloat amountmax = 0;
                NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:model.time];
                NSString *timeStr=[_formatter stringFromDate:currentDate];
                [cell.timelb setText:[NSString stringWithFormat:@"%@",timeStr]];
                
                if (model.result + model.fee == 0) {
                    if (model.block_height <= 0) {
                        cell.resultlb.text = NSLocalizedString(@"未打包", nil);
                    }else{
                        cell.resultlb.text = NSLocalizedString(@"已确认", nil);
                    }
                    [cell.amountlb setTextColor:[UIColor textBlueColor]];
                    [cell.resultlb setTextColor:[UIColor textLightGrayColor]];
                    addr = self.wallet.address;
                    amountmax = 0;
                    for (Output *vout in model.outputs) {//转出
                        amountmax+=vout.value;
                    }
                    amountmax = amountmax * 1.0/pow(10, 8);
                    cell.amountlb.text = [NSString stringWithFormat:@"-%.8f", amountmax];
                }else{
                    if (model.block_height <= 0) {
                        cell.resultlb.text = NSLocalizedString(@"未打包", nil);
                    }else{
                        cell.resultlb.text = NSLocalizedString(@"已确认", nil);
                    }
                    [cell.amountlb setTextColor:[UIColor textBlueColor]];
                    [cell.resultlb setTextColor:[UIColor textLightGrayColor]];
                    
                    if (model.result > 0) {//转入
                        [cell.amountlb setTextColor:[UIColor textBlueColor]];
                        amountmax = model.result * 1.0/pow(10, 8);
                        addr = ((Input *)model.inputs[0]).prev_out.addr;
                        cell.amountlb.text = [NSString stringWithFormat:@"+%.8f", amountmax];
                        NSString *str1 = [addr substringToIndex:9];
                        NSString *str2 = [addr substringFromIndex:addr.length - 10];
                        cell.addresslb.text = [NSString stringWithFormat:@"%@...%@",str1,str2];
                    }else if(model.result < 0){
                        [cell.amountlb setTextColor:[UIColor textOrangeColor]];
                        amountmax = (model.result + model.fee) * 1.0/pow(10, 8);
                        for (Output *vout in model.outputs) {//转出
                            if (![self.wallet.changeAddressStr containsString:vout.addr]) {
                                addr = vout.addr;
                                break;
                            }
                        }
                        cell.amountlb.text = [NSString stringWithFormat:@"%.8f", amountmax];
                    }else{
                        addr = self.wallet.address;
                        cell.amountlb.text = [NSString stringWithFormat:@"0.00000000"];
                        [cell.amountlb setTextColor:[UIColor textGrayColor]];
                    }
                   
                }
                if (addr.length > 10) {
                    NSString *str1 = [addr substringToIndex:9];
                    NSString *str2 = [addr substringFromIndex:addr.length - 10];
                    cell.addresslb.text = [NSString stringWithFormat:@"%@...%@",str1,str2];
                }
            }
        }
            break;
        case EOS:
        case MGP:
        {
            [cell.iconImageView setImage:[UIImage imageNamed:self.wallet.coinType == MGP?@"ico_mis":@"ico_eos"]];
            MISTransactionRecordModel *model;
            model = self.recordArray[indexPath.row];
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
            break;
       case USDT:
        {
            [cell.iconImageView setImage:[UIImage imageNamed:@"usdticon"]];
            if (self.usdtRecordArray.count > indexPath.row) {
                USDTTxListData *model = self.usdtRecordArray[indexPath.row];
                NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:model.blocktime];
                NSString *timeStr=[_formatter stringFromDate:currentDate];
                [cell.timelb setText:[NSString stringWithFormat:@"%@",timeStr]];
                if (model.confirmations <= 0) {
                    cell.resultlb.text = NSLocalizedString(@"未打包", nil);
                }else if(model.confirmations <= 6){
                    cell.resultlb.text = NSLocalizedString(@"确认中", nil);
                }else{
                    cell.resultlb.text = NSLocalizedString(@"已确认", nil);
                }
                [cell.amountlb setTextColor:[UIColor textBlueColor]];
                [cell.resultlb setTextColor:[UIColor textLightGrayColor]];
                if(model.type_int == 0){//转出
                    [cell.amountlb setTextColor:[UIColor textOrangeColor]];
                    cell.amountlb.text = [NSString stringWithFormat:@"-%.8f", model.amount.doubleValue];
                
                }else if (model.type_int == 3){//转入
                    [cell.amountlb setTextColor:[UIColor textBlueColor]];
                    cell.amountlb.text = [NSString stringWithFormat:@"+%.8f", model.amount.doubleValue];
                }else{
                    cell.amountlb.text = [NSString stringWithFormat:@"%.8f", model.amount.doubleValue];
                    [cell.amountlb setTextColor:[UIColor textGrayColor]];
                }
                
                if (model.sendingaddress.length > 10) {
                    NSString *str1 = [model.sendingaddress substringToIndex:9];
                    NSString *str2 = [model.sendingaddress substringFromIndex:model.sendingaddress.length - 10];
                    cell.addresslb.text = [NSString stringWithFormat:@"%@...%@",str1,str2];
                }
            }
        }
            break;
        default:
            break;
    }
    
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TransactionRecordDetailVC *dvc = [TransactionRecordDetailVC new];
    dvc.wallet = self.wallet;
    switch (self.wallet.coinType) {
        case ETH:
        {
            ETHTransactionRecordModel *model = self.ethRecordArray[indexPath.row];
            dvc.ethRecord = model;
            dvc.fromAddress = model.from;
            dvc.toAddress = model.to;
        }
            break;
        case BTC:
        case BTC_TESTNET:
        {
            Tx *model = self.btcRecordArray[indexPath.row];
            dvc.btcRecord = model;
            NSString *fromaddr;
            NSString *toaddr;
            CGFloat amountmax = 0;
            if (model.result + model.fee == 0) {
                for (Output *vout in model.outputs) {
                    amountmax+=vout.value;
                }
                amountmax = amountmax * 1.0/pow(10, 8);
                fromaddr = self.wallet.address;
                NSString *addr;
                for (Output *vout in model.outputs) {//转出
                    if (![self.wallet.changeAddressStr containsString:vout.addr]) {
                        toaddr = vout.addr;
                        break;
                    }else{
                        addr = vout.addr;
                    }
                }
                if (toaddr == nil) {
                    toaddr = addr;
                }
                
            }else{
                if (model.result > 0) {//转入
                    amountmax = model.result * 1.0/pow(10, 8);
                    fromaddr = ((Input *)model.inputs[0]).prev_out.addr;
                    toaddr = self.wallet.address;
                    
                }else{
                    amountmax = (model.result + model.fee) * 1.0/pow(10, 8);
                    fromaddr = self.wallet.address;
                    NSString *addr;
                    for (Output *vout in model.outputs) {//转出
                        if (![self.wallet.changeAddressStr containsString:vout.addr]) {
                            toaddr = vout.addr;
                            break;
                        }else{
                            addr = vout.addr;
                        }
                    }
                    if (toaddr == nil) {
                        toaddr = addr;
                    }
                        
                }
            }
            dvc.fromAddress = fromaddr;
            dvc.toAddress = toaddr;
            dvc.amount = amountmax;
        }
            break;
        case EOS:
        case MGP:
            dvc.misRecord = self.recordArray[indexPath.row];
            dvc.fromAddress = dvc.misRecord.action_trace.act.data.from;
            dvc.toAddress = dvc.misRecord.action_trace.act.data.to;
            break;
        case USDT:
        {
            USDTTxListData *model = self.usdtRecordArray[indexPath.row];
            dvc.usdtRecord = model;
            if(model.type_int == 0){
                dvc.fromAddress = self.wallet.address;
                dvc.toAddress = model.sendingaddress;
            }else if (model.type_int == 3){
                dvc.fromAddress = model.sendingaddress;
                dvc.toAddress = self.wallet.address;
            }
            
            dvc.amount = model.amount.doubleValue;
        }
            break;
        default:
            break;
    }
    
    [self.navigationController pushViewController:dvc animated:YES];
    
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
