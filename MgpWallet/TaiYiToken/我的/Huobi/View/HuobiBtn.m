//
//  HuobiBtn.m
//  TaiYiToken
//
//  Created by 张元一 on 2019/3/14.
//  Copyright © 2019 admin. All rights reserved.
//

#import "HuobiBtn.h"

@implementation HuobiBtn
//登录，买入 卖出
+(UIButton *)HuobiTypeOneBtnBGColor:(BOOL)isGreen isOperationBtn:(BOOL)isOperBtn Title:(NSString *)title{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    if (!isOperBtn) {
        [btn setTitleColor:isGreen?[UIColor darkGrayColor]:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setBackgroundColor:[UIColor whiteColor]];
        if (isGreen) {
            [btn setBackgroundImage:[UIImage imageNamed:@"pl"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"pls"] forState:UIControlStateSelected];
        }else{
            [btn setBackgroundImage:[UIImage imageNamed:@"pr"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"prs"] forState:UIControlStateSelected];
        }
        
        
        [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [btn setTitle:title forState:UIControlStateNormal];
    }else{
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageWithColor:[UIColor darkappGreenColor]] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageWithColor:[UIColor darkappRedColor]] forState:UIControlStateSelected];
        [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [btn setTitle:title forState:UIControlStateNormal];
    }
   
    return btn;
}
//深度
+(UIButton *)HuobiTypeTwoBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.layer.borderColor = [UIColor lineGrayColor].CGColor;
    btn.layer.borderWidth = 1.0;
    [btn setTitleColor:[UIColor darkappGreenColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor darkappGreenColor] forState:UIControlStateSelected];
    btn.backgroundColor = [UIColor whiteColor];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:11]];
    [btn setTitle:[NSString stringWithFormat:@"%@1",NSLocalizedString(@"深度", nil)] forState:UIControlStateNormal];
    return btn;
}
//买盘卖盘
+(UIButton *)HuobiTypeThreeBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.imageEdgeInsets = UIEdgeInsetsMake(2, 2, 2, 2);
    btn.layer.borderColor = [UIColor lineGrayColor].CGColor;
    btn.layer.borderWidth = 1.0;
    [btn setImage:[UIImage imageNamed:@"aaa"] forState:UIControlStateNormal];
    return btn;
}
//个人资产
+(UIButton *)HuobiMyAssetsBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    [btn setImage:[UIImage imageNamed:@"balance"] forState:UIControlStateNormal];
    return btn;
}
//取消授权
+(UIButton *)HuobiUnAuthBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    [btn setImage:[UIImage imageNamed:@"unauth"] forState:UIControlStateNormal];
    return btn;
}

@end
