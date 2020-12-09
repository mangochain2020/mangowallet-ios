//
//  TransactionGasView.h
//  TaiYiToken
//
//  Created by admin on 2018/9/13.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransactionGasView : UIView
@property(nonatomic,strong)UILabel *namelb;
@property(nonatomic,strong)UILabel *minLabel;
@property(nonatomic,strong)UILabel *maxLabel;

@property(nonatomic,strong)UILabel *gaspricelb;
@property(nonatomic,strong)UISlider *gasSlider;
@property(nonatomic,strong)UILabel *valueLabel;
//@property(nonatomic,strong)UITextField *customBtcFeeTextField;
-(void)initUI;
-(void)updateLabelValues:(CGFloat)value;
@end
