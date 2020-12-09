//
//  HuobiPersonAssetsCell.h
//  TaiYiToken
//
//  Created by 张元一 on 2019/3/20.
//  Copyright © 2019 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HuobiTwolbView.h"
NS_ASSUME_NONNULL_BEGIN

@interface HuobiPersonAssetsCell : UICollectionViewCell
@property(nonatomic,strong)UILabel *leftlb;

@property(nonatomic,strong)HuobiTwolbView *bottomA;
@property(nonatomic,strong)HuobiTwolbView *bottomB;
@property(nonatomic,strong)HuobiTwolbView *bottomC;
@end

NS_ASSUME_NONNULL_END
