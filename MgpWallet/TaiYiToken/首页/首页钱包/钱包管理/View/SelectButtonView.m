//
//  SelectButtonView.m
//  TaiYiToken
//
//  Created by admin on 2018/9/5.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "SelectButtonView.h"
#define BtnColor RGB(256, 256, 256)
#define SelectColor [UIColor textBlueColor]
#define DeSelectColor [UIColor textGrayColor]
@implementation SelectButtonView

-(void)initButtonsViewWidth:(CGFloat)width Height:(CGFloat)height{

    self.backgroundColor = [UIColor whiteColor];
    
    _KeystoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _KeystoreBtn.backgroundColor = BtnColor;
    _KeystoreBtn.tintColor = [UIColor blackColor];
    _KeystoreBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    _KeystoreBtn.tag = 1;
    [_KeystoreBtn setTitleColor:SelectColor forState:UIControlStateSelected];
    [_KeystoreBtn setTitleColor:DeSelectColor forState:UIControlStateNormal];
    [_KeystoreBtn setTitle:@"Keystore" forState:UIControlStateNormal];
    [self addSubview:_KeystoreBtn];
    _KeystoreBtn.userInteractionEnabled = YES;
    [_KeystoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(0);
        make.width.equalTo(width/2);
        make.height.equalTo(height - 2);
    }];
    
    
    
    
    _QRCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _QRCodeBtn.backgroundColor = BtnColor;
    _QRCodeBtn.tintColor = [UIColor blackColor];
    _QRCodeBtn.tag = 2;
    _QRCodeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [_QRCodeBtn setTitleColor:SelectColor forState:UIControlStateSelected];
    [_QRCodeBtn setTitleColor:DeSelectColor forState:UIControlStateNormal];
    [_QRCodeBtn setTitle:NSLocalizedString(@"二维码", nil) forState:UIControlStateNormal];
    [self addSubview:_QRCodeBtn];
    _QRCodeBtn.userInteractionEnabled = YES;
    [_QRCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(0);
        make.left.equalTo(width/2);
        make.width.equalTo(width/2);
        make.height.equalTo(height - 2);
    }];
    
    _lineView = [UIView new];
    _lineView.backgroundColor = [UIColor textBlueColor];
    [self addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(0);
        make.left.equalTo(ScreenWidth/4 - 31);
        make.width.equalTo(62);
        make.height.equalTo(2);
    }];
    
     self.btnArray = [NSArray arrayWithObjects:_KeystoreBtn,_QRCodeBtn,nil];
}
-(void)setBtnSelected:(UIButton *)button{
    CGRect oldFrame = self.lineView.frame;
    if (button.tag == 1) {
        [UIView animateWithDuration:0.3f animations:^{
           self.lineView.frame = CGRectMake(ScreenWidth/4 - 31, oldFrame.origin.y, oldFrame.size.width, oldFrame.size.height);
        }];
    }else{
        [UIView animateWithDuration:0.3f animations:^{
            self.lineView.frame = CGRectMake(ScreenWidth/4 - 31 + ScreenWidth/2, oldFrame.origin.y, oldFrame.size.width, oldFrame.size.height);
        }];
    }

    for (UIButton *btn in self.btnArray) {
        if(btn.tag != button.tag){
            [btn setSelected:NO];
        }
    }
    [button setSelected:YES];
}

@end
