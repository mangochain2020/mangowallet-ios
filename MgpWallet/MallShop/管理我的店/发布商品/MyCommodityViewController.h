//
//  MyCommodityViewController.h
//  TaiYiToken
//
//  Created by mac on 2020/8/3.
//  Copyright © 2020 admin. All rights reserved.
//

#import "JhFormTableViewVC.h"
#import "DCCommodityModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyCommodityViewController : JhFormTableViewVC

@property(strong, nonatomic)DCCommodityModel *model;

@property (nonatomic, copy) dispatch_block_t collectionBlock;

@end

NS_ASSUME_NONNULL_END
