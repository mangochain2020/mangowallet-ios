//
//  HuobiTypeOneTF.h
//  TaiYiToken
//
//  Created by 张元一 on 2019/3/14.
//  Copyright © 2019 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HuobiToolView.h"
NS_ASSUME_NONNULL_BEGIN

@interface HuobiTypeOneTF : UIView
//价格输入框
@property(nonatomic,strong)UITextField *huobiTF;
@property(nonatomic,strong)UILabel *remindLb;
@property(nonatomic,strong)HuobiToolView *toolview;

//价格输入框
-(void)HuobiPriceTF;
@end

NS_ASSUME_NONNULL_END
