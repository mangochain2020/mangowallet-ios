//
//  DCTopLineFootView.h
//  CDDMall
//
//  Created by apple on 2017/6/5.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCHandModel.h"

@interface DCTopLineFootView : UICollectionReusableView

/* 顶部广告宣传图片 */
@property (strong , nonatomic)UIImageView *topAdImageView;

@property (strong , nonatomic)DCHandModel *handModel;

@end
