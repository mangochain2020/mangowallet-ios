//
//  TransactionAmountView.h
//  TaiYiToken
//
//  Created by admin on 2018/9/13.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransactionAmountView : UIView
@property(nonatomic,strong)UITextField *amountTextField;
@property(nonatomic,strong)UITextField *remarkTextField;
@property(nonatomic,strong)UILabel *pricelb;
@property(nonatomic,strong)UILabel *balancelb;
@property(nonatomic,strong)UILabel *namelb;
@property(nonatomic,strong)UILabel *btcAvailableLb;
-(void)initUI;
@end
