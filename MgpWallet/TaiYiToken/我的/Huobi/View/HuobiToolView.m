//
//  TwoBtnView.m
//  TaiYiToken
//
//  Created by 张元一 on 2019/3/14.
//  Copyright © 2019 admin. All rights reserved.
//

#import "HuobiToolView.h"

@implementation HuobiToolView
//+ , -
-(void)HuobiTwoBtnView{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tintColor = [UIColor lightGrayColor];
    btn.backgroundColor = [UIColor whiteColor];
    UIImage *image = [[UIImage imageNamed:@"add"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [btn setImage:image forState:UIControlStateNormal];
    self.addBtn = btn;
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.tintColor = [UIColor lightGrayColor];
    btn2.backgroundColor = [UIColor whiteColor];
    btn2.contentMode = UIViewContentModeCenter;
    [btn2 setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    UIImage *image2 = [[UIImage imageNamed:@"subtract"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [btn2 setImage:image2 forState:UIControlStateNormal];
    self.subBtn = btn2;
    
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderColor = [UIColor grayColor].CGColor;
    self.layer.borderWidth = ToolViewBorderWidth;
    [self addSubview:btn];
    [self addSubview:btn2];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(0);
        make.right.equalTo(self.mas_centerX);
    }];
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(0);
        make.left.equalTo(btn.mas_right);
    }];
}


@end
