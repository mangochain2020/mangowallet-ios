//
//  EOSHelpRegisterView.m
//  TaiYiToken
//
//  Created by 张元一 on 2018/12/27.
//  Copyright © 2018 admin. All rights reserved.
//

#import "EOSHelpRegisterView.h"
#define LargeLineSpace 25
#define DefaultLineSpace 10

@implementation EOSHelpRegisterView


- (void)drawRect:(CGRect)rect {
    UIFont *titlefont = [UIFont boldSystemFontOfSize:15];
    UIFont *font = [UIFont systemFontOfSize:13];
    
    //
    NSString *s0 = NSLocalizedString(@"费用", nil);
    [s0 drawInRect:CGRectMake(10, 5, 130, 20) withAttributes:@{NSFontAttributeName:titlefont,NSForegroundColorAttributeName:[UIColor textBlackColor]}];
    NSString *s1 =[NSString stringWithFormat:@"%@" ,_totaleos];
    CGFloat s1w = [s1 sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}].width;
    [s1 drawInRect:CGRectMake(ScreenWidth - s1w - 10, 5, s1w, 20) withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor textBlueColor]}];
    
    NSString *s2 = [NSString stringWithFormat:@"%@ %@" ,NSLocalizedString(@"RAM", nil),_ramamount];
    [s2 drawInRect:CGRectMake(10, 15 + LargeLineSpace, 80, 20) withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor textBlackColor]}];
    NSString *s3 =[NSString stringWithFormat:@"%@" ,_rameos];
    CGFloat s3w = [s3 sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}].width;
    [s3 drawInRect:CGRectMake(ScreenWidth - s3w - 10, 15 + LargeLineSpace, s3w, 20) withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor textBlueColor]}];
   
    NSString *s4 = [NSString stringWithFormat:@"%@ %@" ,NSLocalizedString(@"CPU", nil),_cpuamount];
    [s4 drawInRect:CGRectMake(10, 15 + LargeLineSpace + (20 + DefaultLineSpace) , 80, 20) withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor textBlackColor]}];
    NSString *s5 =[NSString stringWithFormat:@"%@" ,_cpueos];
    CGFloat s5w = [s5 sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}].width;
    [s5 drawInRect:CGRectMake(ScreenWidth - s5w - 10, 15 + LargeLineSpace + (20 + DefaultLineSpace), s5w, 20) withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor textBlueColor]}];
    
    NSString *s6 = [NSString stringWithFormat:@"%@ %@" ,NSLocalizedString(@"NET", nil),_netamount];
    [s6 drawInRect:CGRectMake(10, 15 + LargeLineSpace  + (20 + DefaultLineSpace)*2, 80, 20) withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor textBlackColor]}];
    NSString *s7 =[NSString stringWithFormat:@"%@" ,_neteos];
    CGFloat s7w = [s7 sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}].width;
    [s7 drawInRect:CGRectMake(ScreenWidth - s7w - 10, 15 + LargeLineSpace + (20 + DefaultLineSpace)*2, s7w, 20) withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor textBlueColor]}];
    
    //
    [self addLineFromPoint:CGPointMake(0, 15 + LargeLineSpace  + (20 + DefaultLineSpace)*3) ToPoint:CGPointMake(ScreenWidth, 15 + LargeLineSpace  + (20 + DefaultLineSpace)*3) LineWidth:10.0];
    
    //
    CGFloat bTop = 15 + LargeLineSpace  + (20 + DefaultLineSpace)*3 + 20;
    
    NSString *b0 = NSLocalizedString(@"账户名", nil);
    [b0 drawInRect:CGRectMake(10, bTop, 130, 20) withAttributes:@{NSFontAttributeName:titlefont,NSForegroundColorAttributeName:[UIColor textBlackColor]}];
    [self.accountTextField setText:_eosAccount];
    
    NSString *b1 = NSLocalizedString(@"Owner Key", nil);
    [b1 drawInRect:CGRectMake(10, bTop + 50 + LargeLineSpace , 150, 20) withAttributes:@{NSFontAttributeName:titlefont,NSForegroundColorAttributeName:[UIColor textBlackColor]}];
    NSString *b2 =[NSString stringWithFormat:@"%@" ,_eosAccountOwnerKey];
    [b2 drawInRect:CGRectMake(10, bTop + 50 + LargeLineSpace + (20 + DefaultLineSpace), ScreenWidth - 20, 40) withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor textGrayColor]}];
    
    NSString *b3 = NSLocalizedString(@"Active Key", nil);
    [b3 drawInRect:CGRectMake(10, bTop + 50 + LargeLineSpace*2 + (20 + DefaultLineSpace)*2, 150, 20) withAttributes:@{NSFontAttributeName:titlefont,NSForegroundColorAttributeName:[UIColor textBlackColor]}];
    NSString *b4 =[NSString stringWithFormat:@"%@" ,_eosAccountActiveKey];
    [b4 drawInRect:CGRectMake(10, bTop + 50 + LargeLineSpace*2 + (20 + DefaultLineSpace)*3, ScreenWidth - 20, 40) withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor textGrayColor]}];
    
    NSString *b5 = NSLocalizedString(@"付款帐号", nil);
    [b5 drawInRect:CGRectMake(10, bTop + 50 + LargeLineSpace*3 + (20 + DefaultLineSpace)*4, 150, 20) withAttributes:@{NSFontAttributeName:titlefont,NSForegroundColorAttributeName:[UIColor textBlackColor]}];
    [self.selectPayerBtn setTitle:VALIDATE_STRING(_payerAccount) forState:UIControlStateNormal];
    
}

-(UIButton *)selectPayerBtn{
    if (!_selectPayerBtn) {
        _selectPayerBtn = [UIButton buttonWithType: UIButtonTypeSystem];
        _selectPayerBtn.userInteractionEnabled = YES;
        _selectPayerBtn.backgroundColor = [UIColor whiteColor];
        [_selectPayerBtn setTitle:VALIDATE_STRING(_payerAccount) forState:UIControlStateNormal];
        _selectPayerBtn.tintColor = [UIColor grayColor];
        [_selectPayerBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:_selectPayerBtn];
        [_selectPayerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-10);
            make.top.equalTo(15 + LargeLineSpace  + (20 + DefaultLineSpace)*3 + 20 + 50 + LargeLineSpace*3 + (20 + DefaultLineSpace)*4);
            make.width.equalTo(130);
            make.height.equalTo(20);
        }];
        UIImage *icon = [UIImage imageNamed:@"ico_left_arrow"];
        UIImageView *iv = [UIImageView new];
        iv.image = icon;
        [_selectPayerBtn addSubview:iv];
        [iv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(2);
            make.height.equalTo(15);
            make.width.equalTo(15);
            make.right.equalTo(0);
        }];
    }
    return _selectPayerBtn;
}


-(UITextField *)accountTextField{
    if (!_accountTextField) {
        _accountTextField = [UITextField new];
        _accountTextField.borderStyle = UITextBorderStyleNone;
        _accountTextField.backgroundColor = [UIColor whiteColor];
        _accountTextField.textAlignment = NSTextAlignmentLeft;
        _accountTextField.textColor = [UIColor darkGrayColor];
        _accountTextField.font = [UIFont systemFontOfSize:14];
        _accountTextField.userInteractionEnabled = YES;
        [self addSubview:_accountTextField];
        [_accountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(15 + LargeLineSpace  + (20 + DefaultLineSpace)*3 + 20 + 30);
            make.height.equalTo(30);
            make.left.equalTo(10);
            make.right.equalTo(-10);
        }];
    }
    return _accountTextField;
}

-(void)addLineFromPoint:(CGPoint)p0 ToPoint:(CGPoint)p1 LineWidth:(CGFloat)width{
    UIBezierPath *path = [UIBezierPath bezierPath];
    //2、设置起点
    [path moveToPoint:p0];
    //设置终点
    [path addLineToPoint:p1];
    
    [path setLineWidth:width];
    [path setLineJoinStyle:kCGLineJoinBevel];
    [path setLineCapStyle:kCGLineCapButt];
    [kRGBA(248, 248, 248, 1) setStroke];
    
    //3、渲染上下文到View的layer
    [path stroke];
}
@end
