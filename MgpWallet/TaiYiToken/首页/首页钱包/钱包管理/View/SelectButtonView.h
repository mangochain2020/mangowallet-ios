//
//  SelectButtonView.h
//  TaiYiToken
//
//  Created by admin on 2018/9/5.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectButtonView : UIView
@property(nonatomic)UIButton *KeystoreBtn;
@property(nonatomic)UIButton *QRCodeBtn;
@property(nonatomic)UIView *lineView;

@property(nonatomic)NSArray *btnArray;
-(void)initButtonsViewWidth:(CGFloat)width Height:(CGFloat)height;
-(void)setBtnSelected:(UIButton *)button;
@end
