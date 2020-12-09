//
//  DCGoodsGridCell.h
//  CDDMall
//
//  Created by apple on 2017/6/5.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DCGridItem;

@interface DCGoodsGridCell : UICollectionViewCell

@property (strong , nonatomic)UIButton *button;

/* 10个属性数据 */
@property (strong , nonatomic)DCGridItem *gridItem;

/** 找相似点击回调 */
@property (nonatomic, copy) dispatch_block_t lookSameBlock;


@end
