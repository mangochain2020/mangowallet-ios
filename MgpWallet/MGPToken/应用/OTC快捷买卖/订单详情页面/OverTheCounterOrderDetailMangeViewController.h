//
//  OverTheCounterOrderDetailMangeViewController.h
//  TaiYiToken
//
//  Created by mac on 2021/1/5.
//  Copyright © 2021 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OverTheCounterOrderDetailViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface OverTheCounterOrderDetailMangeViewController : UIViewController

@property (nonatomic,assign) OverTheCounterOrderDetailType orderDetailType; //订单类型
@property (nonatomic,strong) NSDictionary *dicData; //数据


@end

NS_ASSUME_NONNULL_END
