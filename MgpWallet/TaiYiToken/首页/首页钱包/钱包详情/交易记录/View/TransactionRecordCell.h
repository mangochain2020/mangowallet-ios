//
//  TransactionRecordCell.h
//  TaiYiToken
//
//  Created by admin on 2018/9/17.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransactionRecordCell : UITableViewCell
@property(nonatomic)UIImageView *iconImageView;
@property(nonatomic,strong)UILabel *addresslb;//
@property(nonatomic,strong)UILabel *timelb;//
@property(nonatomic,strong)UILabel *amountlb;//
@property(nonatomic,strong)UILabel *resultlb;//


@end
