//
//  HuobiTypeTwoTF.h
//  TaiYiToken
//
//  Created by 张元一 on 2019/3/14.
//  Copyright © 2019 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HuobiToolView.h"
NS_ASSUME_NONNULL_BEGIN

@interface HuobiTypeTwoTF : UIView
//数量输入框
@property(nonatomic,strong)UITextField *huobiTF;
@property(nonatomic,strong)UILabel *coinLb;//eos
@property(nonatomic,strong)UILabel *remindLb;//可用** usdt

//数量输入框
-(void)HuobiQuantityTF;
@end

NS_ASSUME_NONNULL_END
