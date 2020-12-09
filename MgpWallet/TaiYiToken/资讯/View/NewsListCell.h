//
//  NewsListCell.h
//  TaiYiToken
//
//  Created by 张元一 on 2019/4/1.
//  Copyright © 2019 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewsListCell : UITableViewCell
@property(nonatomic,strong)UILabel *titlelb;
@property(nonatomic,strong)UILabel *contentlb;
@property(nonatomic,strong)UILabel *timelb;
@property(nonatomic,strong)UIImageView *cellImageView;
@property(nonatomic,strong)UIImageView *iconImageView;
@end

NS_ASSUME_NONNULL_END
