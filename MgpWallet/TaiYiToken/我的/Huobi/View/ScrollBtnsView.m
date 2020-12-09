//
//  ScrollBtnsView.m
//  TaiYiToken
//
//  Created by 张元一 on 2019/3/11.
//  Copyright © 2019 admin. All rights reserved.
//

#import "ScrollBtnsView.h"
#define BtnColor RGB(256, 256, 256)
#define SelectColor [UIColor darkBlueColor]
#define DeSelectColor [UIColor textGrayColor]
@interface ScrollBtnsView()
@property(nonatomic,assign)CGFloat widthOfBtn;
@property(nonatomic,assign)CGFloat lineViewWidth;
@end
@implementation ScrollBtnsView

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

-(void)initButtonsViewAndChangeBtnWithTitles:(NSArray *)array Width:(CGFloat)width Height:(CGFloat)height{
    [self initButtonsViewAndChangeBtnWithTitles:array Width:width - 50 Height:height];
    if (!_changeBtn) {
        _changeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_changeBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_changeBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
        [self addSubview:_changeBtn];
        [_changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(0);
            make.width.equalTo(50);
        }];
    }//
}

-(void)initButtonsViewWithTitles:(NSArray *)array Width:(CGFloat)width Height:(CGFloat)height{
    [self.btnArray removeAllObjects];
    
    CGFloat currentWidth = width*1.0/array.count > 60?width*1.0/array.count:60;
    
    _backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    _backScrollView.backgroundColor = [UIColor whiteColor];
    _backScrollView.showsVerticalScrollIndicator = NO;
    _backScrollView.showsHorizontalScrollIndicator = NO;
    _backScrollView.scrollEnabled = YES;
    _backScrollView.alwaysBounceHorizontal = YES;
    _backScrollView.alwaysBounceVertical = NO;
    _backScrollView.userInteractionEnabled = YES;
    _backScrollView.contentSize = CGSizeMake(array.count*currentWidth, height);
    //        [_backScrollView scrollToLeft];
    [self addSubview:_backScrollView];
    [_backScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(0);
        make.height.equalTo(height);
    }];
    
    
    
    if (self.fontsize <=0 ||self.fontsize >20) {
        self.fontsize = 17;
    }
    self.backgroundColor = [UIColor whiteColor];
    if (array == nil || array.count == 0) {
        return;
    }
    self.btnArray = [NSMutableArray new];
    NSInteger numOfBtns = array.count;
    //    CGFloat widthOfBtn = width/numOfBtns;
    CGFloat widthOfBtn = currentWidth;
    CGFloat lineViewWidth = widthOfBtn * 0.7;
    self.widthOfBtn = widthOfBtn;
    self.lineViewWidth = lineViewWidth;
    for (int i = 0; i < numOfBtns; i++) {
        UIButton *Btn = [UIButton buttonWithType:UIButtonTypeCustom];
        Btn.backgroundColor = BtnColor;
        Btn.tintColor = [UIColor blackColor];
        Btn.titleLabel.font = [UIFont boldSystemFontOfSize:self.fontsize];
        //        Btn.tag = i;
        [Btn setTitleColor:SelectColor forState:UIControlStateSelected];
        [Btn setTitleColor:DeSelectColor forState:UIControlStateNormal];
        [Btn setTitle:array[i] forState:UIControlStateNormal];
        [self.backScrollView addSubview:Btn];
        Btn.userInteractionEnabled = YES;
        [Btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(0);
            make.left.equalTo(widthOfBtn*i);
            make.width.equalTo(widthOfBtn);
            make.height.equalTo(height - 2);
        }];
        [self.btnArray addObject:Btn];
    }
    [self lineView];
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
         _lineView.backgroundColor = SelectColor;
        [self.backScrollView addSubview:_lineView];
        self.lineView.frame = CGRectMake(self.widthOfBtn/2 - self.lineViewWidth/2, self.backScrollView.height - 2 , 80, 2);
    }
    return _lineView;
}

-(void)setBtnSelected:(UIButton *)button{
    if (self.lineView.hidden == NO) {
        CGRect oldFrame = self.lineView.frame;
        [UIView animateWithDuration:0.3f animations:^{
            self.lineView.frame = CGRectMake(self.widthOfBtn/2 - self.lineViewWidth/2 + (button.tag % 100) * (self.widthOfBtn) , oldFrame.origin.y, oldFrame.size.width, oldFrame.size.height);
        }];
    }
    
    for (UIButton *btn in self.btnArray) {
        if(btn.tag != button.tag){
            [btn setSelected:NO];
//            [btn setHighlighted:NO];
        }
    }
    [button setSelected:YES];
//    [button setHighlighted:YES];
}
-(void)setBtnSelectedWithTag:(NSInteger)tag{
    if (self.lineView.hidden == NO) {
        CGRect oldFrame = self.lineView.frame;
        [UIView animateWithDuration:0.3f animations:^{
            [self.lineView setFrame:CGRectMake(self.widthOfBtn/2 - self.lineViewWidth/2 + (tag % 100) * (self.widthOfBtn) , oldFrame.origin.y, oldFrame.size.width, oldFrame.size.height)];
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
