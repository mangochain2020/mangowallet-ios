//
//  DCOrderListViewController.h
//  TaiYiToken
//
//  Created by mac on 2020/8/6.
//  Copyright © 2020 admin. All rights reserved.
//

#import "DCPagerController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DCOrderListViewController : DCPagerController

@property (assign, nonatomic)NSInteger tag;//默认选中
@property (assign, nonatomic)BOOL isManagement; //是否商家进来的订单列表

@end

NS_ASSUME_NONNULL_END
