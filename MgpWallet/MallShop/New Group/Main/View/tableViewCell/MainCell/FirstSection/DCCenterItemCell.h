//
//  DCCenterItemCell.h
//  CDDStoreDemo
//
//  Created by 陈甸甸 on 2017/12/12.
//Copyright © 2017年 RocketsChen. All rights reserved.
//

#import <UIKit/UIKit.h>
// Models
#import "DCStateItem.h"

typedef void(^CallBackBlock)(NSInteger tag); // 定义带有参数text的block

@interface DCCenterItemCell : UITableViewCell

@property (nonatomic, copy)CallBackBlock callBackBlock;

/* 数据 */
@property (strong , nonatomic)NSMutableArray<DCStateItem *> *stateItem;

@end
