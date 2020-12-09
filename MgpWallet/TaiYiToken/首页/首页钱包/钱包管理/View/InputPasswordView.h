//
//  InputPasswordView.h
//  TaiYiToken
//
//  Created by admin on 2018/9/4.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputPasswordView : UIView
@property(nonatomic)UILabel *titleLabel;
@property(nonatomic)UITextField *passwordTextField;
@property(nonatomic)UIButton *confirmBtn;
-(void)initUI;
@end
