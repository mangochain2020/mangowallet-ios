//
//  EOSStakeView.m
//  TaiYiToken
//
//  Created by 张元一 on 2018/12/21.
//  Copyright © 2018 admin. All rights reserved.
//

#import "EOSStakeView.h"

@implementation EOSStakeView

- (void)drawRect:(CGRect)rect {
    NSString *t3 = self.coinType == EOS ? NSLocalizedString(@"EOS数量", nil) : NSLocalizedString(@"MGP数量", nil);
    
    [t3 drawInRect:CGRectMake(10, 10, 100, 20) withAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14],NSForegroundColorAttributeName:[UIColor textBlackColor]}];
    NSString *t4 =[NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"余额", nil),self.balance];
    CGFloat t4l = [t4 sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]}].width;
    [t4 drawInRect:CGRectMake(ScreenWidth - t4l - 10, 10, t4l, 20) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:[UIColor textGrayColor]}];
    [self cnTextField];
    [self addLineFromPoint:CGPointMake(0, 65) ToPoint:CGPointMake(ScreenWidth, 65) LineWidth:1.0];
    
    NSString *t5 = NSLocalizedString(@"比例", nil);
    [t5 drawInRect:CGRectMake(10, 80, 100, 20) withAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14],NSForegroundColorAttributeName:[UIColor textBlackColor]}];
    
    [self cnLabel];
    
    [self addLineFromPoint:CGPointMake(0, 160) ToPoint:CGPointMake(ScreenWidth, 160) LineWidth:5.0];
    
    NSString *tx1 = NSLocalizedString(@"接收帐户", nil);
    [tx1 drawInRect:CGRectMake(10, 175, 100, 30) withAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14],NSForegroundColorAttributeName:[UIColor textBlackColor]}];
    
    [self addLineFromPoint:CGPointMake(0, 210) ToPoint:CGPointMake(ScreenWidth, 210) LineWidth:5.0];
}

-(UILabel *)cnLabel{
    if (!_cnLabel) {
        _cnLabel = [UILabel new];
        _cnLabel.textColor = [UIColor textBlueColor];
        _cnLabel.font = [UIFont systemFontOfSize:10];
        _cnLabel.textAlignment = NSTextAlignmentRight;
        _cnLabel.numberOfLines = 0;
        [self addSubview:_cnLabel];
        [_cnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(70);
            make.height.equalTo(30);
            make.right.equalTo(-10);
            make.width.equalTo(100);
        }];
    }
    return _cnLabel;
}

-(UITextField *)cnTextField{
    if (!_cnTextField) {
        _cnTextField = [UITextField new];
        _cnTextField.borderStyle = UITextBorderStyleNone;
        if (self.coinType == EOS) {
            _cnTextField.attributedPlaceholder =[[NSAttributedString alloc]initWithString: NSLocalizedString(@"输入EOS数量", nil)];

        }else{
            _cnTextField.attributedPlaceholder =[[NSAttributedString alloc]initWithString: NSLocalizedString(@"输入MGP数量", nil)];
        }
        _cnTextField.backgroundColor = [UIColor whiteColor];
        _cnTextField.textAlignment = NSTextAlignmentLeft;
        _cnTextField.textColor = [UIColor darkGrayColor];
        _cnTextField.font = [UIFont systemFontOfSize:16];
        _cnTextField.userInteractionEnabled = YES;
        _cnTextField.keyboardType = UIKeyboardTypeDecimalPad;
        [self addSubview:_cnTextField];
        [_cnTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(40);
            make.height.equalTo(20);
            make.left.equalTo(10);
            make.right.equalTo(-10);
        }];
    }
    return _cnTextField;
}

-(UITextField *)accountTextField{
    if (!_accountTextField) {
        _accountTextField = [UITextField new];
        _accountTextField.borderStyle = UITextBorderStyleNone;
        _accountTextField.backgroundColor = [UIColor whiteColor];
        _accountTextField.textAlignment = NSTextAlignmentRight;
        _accountTextField.textColor = [UIColor darkGrayColor];
        _accountTextField.font = [UIFont systemFontOfSize:14];
        _accountTextField.userInteractionEnabled = YES;
        [self addSubview:_accountTextField];
        [_accountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(170);
            make.height.equalTo(30);
            make.left.equalTo(100);
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
