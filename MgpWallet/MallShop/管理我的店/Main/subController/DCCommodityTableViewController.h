//
//  DCCommodityTableViewController.h
//  TaiYiToken
//
//  Created by mac on 2020/8/7.
//  Copyright © 2020 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
/**卖家
 0，销售中
 1，已售空
 2，仓库中
 2，审核中

 */
typedef NS_ENUM(NSInteger, DCCommodityType) {
    
    DCCommodityOnSale = 1,
    DCCommoditySoldEmpty,
    DCCommodityInWarehouse,
    DCCommodityExamine

};
NS_ASSUME_NONNULL_BEGIN

@interface DCCommodityTableViewController : UITableViewController

@property (nonatomic, assign) DCCommodityType type;


@end

NS_ASSUME_NONNULL_END
