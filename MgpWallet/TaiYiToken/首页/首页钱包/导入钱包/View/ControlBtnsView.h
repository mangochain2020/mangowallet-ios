//
//  ControlBtnsView.h
//  TaiYiToken
//
//  Created by admin on 2018/9/6.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ControlBtnsView : UIView
@property(nonatomic)CGFloat fontsize;
@property(nonatomic)UIView *lineView;
@property(nonatomic)NSMutableArray *btnArray;
-(void)initButtonsViewWithTitles:(NSArray *)array Width:(CGFloat)width Height:(CGFloat)height;
-(void)setBtnSelected:(UIButton *)button;
-(void)setBtnSelectedWithTag:(NSInteger)tag;

-(void)resettitles:(NSArray *)array;
@end
