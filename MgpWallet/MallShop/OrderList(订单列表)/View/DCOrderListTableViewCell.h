//
//  DCOrderListTableViewCell.h
//  TaiYiToken
//
//  Created by mac on 2020/8/6.
//  Copyright © 2020 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCOrderListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DCOrderListTableViewCell : UITableViewCell

@property(strong, nonatomic)DataItem *orderModel;
@property (weak, nonatomic) IBOutlet UIView *butto_bgView;

@property (assign, nonatomic)BOOL isManagement; //是否商家进来的订单列表
@property (nonatomic, assign) double currency;

@property (nonatomic, copy) dispatch_block_t collectionBlock;



@end

NS_ASSUME_NONNULL_END
