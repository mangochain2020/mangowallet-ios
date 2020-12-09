//
//  SearchResultVC.h
//  TaiYiToken
//
//  Created by 张元一 on 2018/11/13.
//  Copyright © 2018 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarketTicketModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SearchResultVC : UIViewController
//@property(nonatomic,strong)NSMutableArray <MarketTicketModel *> *dataArray;
@property(nonatomic,strong)NSMutableArray *searchdataarray;
@property(nonatomic)UITableView *tableView;
@property(nonatomic)CGFloat RMBDollarCurrency;//人民币汇率
//自选
@property(nonatomic)NSString *mysymbol;
@end

NS_ASSUME_NONNULL_END
