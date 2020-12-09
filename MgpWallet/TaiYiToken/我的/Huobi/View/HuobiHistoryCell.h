//
//  HuobiHistoryCell.h
//  TaiYiToken
//
//  Created by 张元一 on 2019/3/18.
//  Copyright © 2019 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HuobiTwolbView.h"
NS_ASSUME_NONNULL_BEGIN
//历史记录
@interface HuobiHistoryCell : UITableViewCell
@property(nonatomic,strong)UILabel *leftlb;
@property(nonatomic,strong)UILabel *rightlb;

@property(nonatomic,strong)HuobiTwolbView *topA;
@property(nonatomic,strong)HuobiTwolbView *topB;
@property(nonatomic,strong)HuobiTwolbView *topC;
@property(nonatomic,strong)HuobiTwolbView *bottomA;
@property(nonatomic,strong)HuobiTwolbView *bottomB;
@property(nonatomic,strong)HuobiTwolbView *bottomC;
@end

NS_ASSUME_NONNULL_END
