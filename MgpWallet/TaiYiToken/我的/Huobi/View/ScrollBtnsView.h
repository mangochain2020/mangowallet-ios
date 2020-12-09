//
//  ScrollBtnsView.h
//  TaiYiToken
//
//  Created by 张元一 on 2019/3/11.
//  Copyright © 2019 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScrollBtnsView : UIView
@property(nonatomic,strong)UIScrollView *backScrollView;
@property(nonatomic)CGFloat fontsize;
@property(nonatomic,strong)UIView *lineView;
@property(nonatomic,strong)NSMutableArray *btnArray;
//点击改变列表形式
@property(nonatomic,strong)UIButton *changeBtn;
-(void)initButtonsViewAndChangeBtnWithTitles:(NSArray *)array Width:(CGFloat)width Height:(CGFloat)height;
-(void)initButtonsViewWithTitles:(NSArray *)array Width:(CGFloat)width Height:(CGFloat)height;
-(void)setBtnSelected:(UIButton *)button;
-(void)setBtnSelectedWithTag:(NSInteger)tag;

-(void)resettitles:(NSArray *)array;
@end

NS_ASSUME_NONNULL_END
