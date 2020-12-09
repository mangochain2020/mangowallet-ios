//
//  SortTypeSelectView.m
//  TaiYiToken
//
//  Created by 张元一 on 2018/11/22.
//  Copyright © 2018 admin. All rights reserved.
//

#import "SortTypeSelectView.h"

@implementation SortTypeSelectView

/*
 height view总高
 */
-(void)initBtnsWithWidth:(CGFloat)width Height:(CGFloat)height{
    if (!_btnArray) {
        CGFloat btnheight = height/_titleArray.count;
        _btnArray = [NSMutableArray new];
        for (int index = 0; index < _titleArray.count; index ++) {
            NSString *title = _titleArray[index];
            UIButton *btn = [UIButton buttonWithType: UIButtonTypeSystem];
            btn.tintColor = [UIColor textBlackColor];
            btn.backgroundColor = [UIColor whiteColor];
            [btn setTitle:title forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
            btn.titleLabel.textAlignment = NSTextAlignmentLeft;
            btn.tag = index + 6400;
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            btn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            btn.titleEdgeInsets = UIEdgeInsetsMake(4, 4, -4, -4);
            [self addSubview:btn];
            CGFloat topheight = index * width;
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(0);
                make.height.equalTo(btnheight);
                make.top.equalTo(topheight);
            }];
            [self.btnArray addObject:btn];
        }
    }
}

@end
