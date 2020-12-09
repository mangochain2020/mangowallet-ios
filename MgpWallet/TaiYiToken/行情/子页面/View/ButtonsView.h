//
//  ButtonsView.h
//  TaiYiToken
//
//  Created by Frued on 2018/8/17.
//  Copyright © 2018年 Frued. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ButtonsView : UIView
@property(nonatomic)UIButton *FIVEMINBtn;
@property(nonatomic)UIButton *FIFTEENMINBtn;
@property(nonatomic)UIButton *ONEHOURBtn;
@property(nonatomic)UIButton *ONEDAYBtn;
@property(nonatomic)UIButton *ONEWEEKBtn;
@property(nonatomic)UIButton *ONEMONBtn;
@property(nonatomic)NSArray *btnArray;
-(void)initButtonsViewWidth:(CGFloat)width Height:(CGFloat)height;
@end
