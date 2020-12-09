//
//  DCHandPickViewController.h
//  CDDMall
//
//  Created by apple on 2017/5/26.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import "DCBaseSetViewController.h"

@interface DCHandPickViewController : DCBaseSetViewController

@end
/**

 #pragma mark - 刷新
 - (void)setUpRecData
 {
     WEAKSELF
     [[MGPHttpRequest shareManager]post:@"/appStoreCategory/getCategoryProduct" paramters:@{@"lang":@"zh_CN",@"page":@"1",@"limit":@"100"} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {

         if ([responseObj[@"code"] intValue] == 0) {
             weakSelf.handModel = [DCHandModel mj_objectWithKeyValues:responseObj[@"data"]];
             [weakSelf.collectionView reloadData];
             [weakSelf.collectionView.mj_header endRefreshing];

         }
         

         
     }];

 }
 
 */

