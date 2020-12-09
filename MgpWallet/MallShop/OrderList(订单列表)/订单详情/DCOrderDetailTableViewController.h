//
//  DCOrderDetailTableViewController.h
//  TaiYiToken
//
//  Created by mac on 2020/8/26.
//  Copyright © 2020 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCOrderListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DCOrderDetailTableViewController : UITableViewController

@property(strong, nonatomic)DCOrderListModel *orderModel;
@property(assign, nonatomic)NSInteger row;
@property (assign, nonatomic)BOOL isManagement; //是否商家进来的订单列表
@property (nonatomic, strong) NSDictionary *tempDic;


@end

NS_ASSUME_NONNULL_END
