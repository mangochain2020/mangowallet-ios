//
//  TransactionRecordDetailVC.h
//  TaiYiToken
//
//  Created by admin on 2018/9/18.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTCTransactionRecordModel.h"
#import "ETHTransactionRecordModel.h"
#import "MISTransactionRecordModel.h"
#import "BTCBlockChainListModel.h"
#import "USDTTxListModel.h"
@interface TransactionRecordDetailVC : UIViewController
//@property(nonatomic)NSString *btcTxid;
//@property(nonatomic)NSString *ethtransactionHash;

@property(nonatomic)NSString *fromAddress;
@property(nonatomic)NSString *toAddress;
@property(nonatomic)CGFloat amount;
@property(nonatomic,strong)MISTransactionRecordModel *misRecord;
@property(nonatomic,strong)Tx *btcRecord;
@property(nonatomic,strong)ETHTransactionRecordModel *ethRecord;
@property(nonatomic,strong)USDTTxListData *usdtRecord;
@property(nonatomic)MissionWallet *wallet;
@end
