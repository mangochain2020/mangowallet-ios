//
//  UIScrollView+Refresh.m
//  Day10_PodDemo
//
//  Created by tarena on 16/9/13.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "UIScrollView+Refresh.h"

@implementation UIScrollView (Refresh)
- (void)addHeaderRefresh:(void(^)(void))handler{
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:handler];
}

- (void)beginHeaderRefresh{
    [self.mj_header beginRefreshing];
}
- (void)endHeaderRefresh{
    [self.mj_header endRefreshing];
}

- (void)addFooterRefresh:(void(^)(void))handler{
    self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:handler];
}

- (void)endFooterRefresh{
    [self.mj_footer endRefreshing];
}
//结束刷新并且显示没有更多数据
- (void)endRefreshWithNoMoreData{
    [self.mj_footer endRefreshingWithNoMoreData];
}

- (void)resetNoMoreData{
    [self.mj_footer resetNoMoreData];
}
@end




