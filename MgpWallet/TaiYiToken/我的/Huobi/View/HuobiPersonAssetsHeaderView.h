//
//  HuobiPersonAssetsHeaderView.h
//  TaiYiToken
//
//  Created by 张元一 on 2019/3/20.
//  Copyright © 2019 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HuobiPersonAssetsHeaderView : UICollectionReusableView
@property(nonatomic,strong)UIView *backView;
@property(nonatomic,strong)UILabel *toplb;
@property(nonatomic,strong)UILabel *meduimlb;
@property(nonatomic,strong)UILabel *bottomlb;
@property(nonatomic,strong)UIButton *hideBtn;
@property(nonatomic,strong) UISearchBar *searchBar;
@end

NS_ASSUME_NONNULL_END
