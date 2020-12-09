//
//  MisBaseViewController.h
//  TaiYiToken
//
//  Created by 张元一 on 2019/3/8.
//  Copyright © 2019 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MisBaseViewController : UIViewController
@property(nonatomic,strong)UIScrollView *thescrollView;
@property(nonatomic,strong)UIView *bridgeContentView;

@property(nonatomic)CGSize scrollViewcontentSize;
@end

NS_ASSUME_NONNULL_END
