//
//  TransactionAddressView.h
//  TaiYiToken
//
//  Created by admin on 2018/9/13.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransactionAddressView : UIView
@property(nonatomic,strong)UITextField *fromAddressTextField;
@property(nonatomic,strong)UITextField *toAddressTextField;
@property(nonatomic,strong)UIButton *selectWalletBtn;
-(void)initUI;
@end
