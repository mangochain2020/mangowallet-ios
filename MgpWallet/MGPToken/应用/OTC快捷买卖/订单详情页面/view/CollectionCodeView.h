//
//  CollectionCodeView.h
//  TaiYiToken
//
//  Created by mac on 2021/1/11.
//  Copyright © 2021 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CollectionCodeView : UIView

/**
 是否需要动画显示和隐藏（动画方向为从上往下）
 */
@property(assign, nonatomic) BOOL animated;

@property (weak, nonatomic) IBOutlet UIView *bgAdView;


@property (weak, nonatomic) IBOutlet UIImageView *imageView;

/**
 弹出广告插件

 @param animated 是否需要动画
 */
- (void)popADWithAnimated:(BOOL)animated;



@end

NS_ASSUME_NONNULL_END
