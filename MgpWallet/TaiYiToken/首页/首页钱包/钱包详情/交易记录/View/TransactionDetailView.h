//
//  TransactionDetailView.h
//  TaiYiToken
//
//  Created by admin on 2018/9/18.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordDetailLabel.h"
@interface TransactionDetailView : UIView
@property(nonatomic)UIImageView *iconImageView;
@property(nonatomic,strong)UILabel *amountlb;//0.01 ether
@property(nonatomic,strong)UILabel *timelb;//2018/05/11 15:33:11
@property(nonatomic,strong)UILabel *resultlb;//收款成功

@property(nonatomic,strong)RecordDetailLabel *feelb;
@property(nonatomic,strong)RecordDetailLabel *tolb;
@property(nonatomic,strong)RecordDetailLabel *fromlb;
@property(nonatomic,strong)RecordDetailLabel *remarklb;
@property(nonatomic,strong)RecordDetailLabel *tranNumberlb;
@property(nonatomic,strong)RecordDetailLabel *blockNumberlb;
@end
