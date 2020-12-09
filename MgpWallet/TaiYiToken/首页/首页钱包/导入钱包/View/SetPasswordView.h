//
//  SetPasswordView.h
//  TaiYiToken
//
//  Created by admin on 2018/9/6.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetPasswordView : UIView
@property(nonatomic)UITextField *passwordTextField;
@property(nonatomic)UITextField *repasswordTextField;
@property(nonatomic)UITextField *passwordHintTextField;
-(void)initSetPasswordViewUI;
@end
