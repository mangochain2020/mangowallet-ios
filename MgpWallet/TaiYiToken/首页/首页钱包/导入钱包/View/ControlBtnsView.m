//
//  ControlBtnsView.m
//  TaiYiToken
//
//  Created by admin on 2018/9/6.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "ControlBtnsView.h"
#define BtnColor RGB(256, 256, 256)
#define SelectColor [UIColor textBlueColor]
#define DeSelectColor [UIColor textGrayColor]
@interface ControlBtnsView()
@property(nonatomic)CGFloat widthOfBtn;
@property(nonatomic)CGFloat lineViewWidth;
@end

@implementation ControlBtnsView
-(void)resettitles:(NSArray *)array{
    NSInteger numOfBtns = array.count;
    if (array.count != self.btnArray.count) {
        return;
    }
    for (int i = 0; i < numOfBtns; i++) {
        UIButton *btn = self.btnArray[i];
        [btn setTitle:array[i] forState:UIControlStateNormal];
    }
}


-(void)initButtonsViewWithTitles:(NSArray *)array Width:(CGFloat)width Height:(CGFloat)height{
    if (self.fontsize <=0 ||self.fontsize >20) {
        self.fontsize = 15;
    }
    self.backgroundColor = [UIColor whiteColor];
    if (array == nil || array.count == 0) {
        return;
    }
    self.btnArray = [NSMutableArray new];
    NSInteger numOfBtns = array.count;
    CGFloat widthOfBtn = width/numOfBtns;
    CGFloat lineViewWidth = width/numOfBtns * 0.7;
    self.widthOfBtn = widthOfBtn;
    self.lineViewWidth = lineViewWidth;
    for (int i = 0; i < numOfBtns; i++) {
        UIButton *Btn = [UIButton buttonWithType:UIButtonTypeCustom];
        Btn.backgroundColor = BtnColor;
        Btn.tintColor = [UIColor blackColor];
        Btn.titleLabel.font = [UIFont boldSystemFontOfSize:self.fontsize];
        Btn.tag = i;
        [Btn setTitleColor:SelectColor forState:UIControlStateSelected];
        [Btn setTitleColor:DeSelectColor forState:UIControlStateNormal];
        [Btn setTitle:array[i] forState:UIControlStateNormal];
        [self addSubview:Btn];
        Btn.userInteractionEnabled = YES;
        [Btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(0);
            make.left.equalTo(widthOfBtn*i);
            make.width.equalTo(widthOfBtn);
            make.height.equalTo(height - 2);
        }];
        [self.btnArray addObject:Btn];
    }
    
    _lineView = [UIView new];
    _lineView.backgroundColor = [UIColor textBlueColor];
    [self addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(0);
        make.left.equalTo(widthOfBtn/2 - lineViewWidth/2);
        make.width.equalTo(lineViewWidth);
        make.height.equalTo(2);
    }];
    
    
    
    
}
-(void)setBtnSelected:(UIButton *)button{
    if (self.lineView.hidden == NO) {
        CGRect oldFrame = self.lineView.frame;
        [UIView animateWithDuration:0.3f animations:^{
            self.lineView.frame = CGRectMake(self.widthOfBtn/2 - self.lineViewWidth/2 + button.tag * (self.widthOfBtn) , oldFrame.origin.y, oldFrame.size.width, oldFrame.size.height);
        }];
    }
   
    for (UIButton *btn in self.btnArray) {
        if(btn.tag != button.tag){
            [btn setSelected:NO];
        }
    }
    [button setSelected:YES];
   
}
-(void)setBtnSelectedWithTag:(NSInteger)tag{
    if (self.lineView.hidden == NO) {
        CGRect oldFrame = self.lineView.frame;
        [UIView animateWithDuration:0.3f animations:^{
            [self.lineView setFrame:CGRectMake(self.widthOfBtn/2 - self.lineViewWidth/2 + tag * (self.widthOfBtn) , oldFrame.origin.y, oldFrame.size.width, oldFrame.size.height)];
            //        self.lineView.frame = CGRectMake(self.widthOfBtn/2 - self.lineViewWidth/2 + tag * (self.widthOfBtn) , oldFrame.origin.y, oldFrame.size.width, oldFrame.size.height);
        }];
    }
    
    for (UIButton *btn in self.btnArray) {
        if(btn.tag != tag){
            [btn setSelected:NO];
        }else{
            [btn setSelected:YES];
        }
    }
}

@end
