//
//  MallstoreADView.h
//  TaiYiToken
//
//  Created by mac on 2020/9/16.
//  Copyright © 2020 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProListItem.h"
#import <SDCycleScrollView.h>

NS_ASSUME_NONNULL_BEGIN

@interface MallstoreADView : UIView

@property (strong,nonatomic)ProListItem *model;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;



@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

/** 点击去看看按钮之后的回调 */
@property (nonatomic, copy) dispatch_block_t goNextBlock;

/**
 弹出广告插件

 @param animated 是否需要动画
 */
- (void)popADWithAnimated:(BOOL)animated;



@end

NS_ASSUME_NONNULL_END
