//
//  EOSReclaimView.m
//  TaiYiToken
//
//  Created by 张元一 on 2018/12/21.
//  Copyright © 2018 admin. All rights reserved.
//

#import "EOSReclaimView.h"

@implementation EOSReclaimView

- (void)drawRect:(CGRect)rect {
    self.backgroundColor  = [UIColor whiteColor];
    UIColor * color =[UIColor orangeColor];
    [color set];
    UIColor * color2 = RGB(255, 251, 237);
    [color2 setFill];
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(10, 1, ScreenWidth - 20, 40) cornerRadius:1];
    path.lineWidth = 1;
    [path stroke];
    [path fill];
    
    NSString *t0 = NSLocalizedString(@"提示：可赎回的资源=总量-已用资源-赎回操作需消耗的资源-由他人抵押不可赎回资源", nil);
    [t0 drawInRect:CGRectMake(10, 2, ScreenWidth - 20, 38) withAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:12],NSForegroundColorAttributeName:[UIColor textBlackColor]}];
    
    NSString *t3 = NSLocalizedString(@"赎回CPU", nil);
    [t3 drawInRect:CGRectMake(10, 80, 100, 20) withAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14],NSForegroundColorAttributeName:[UIColor textBlackColor]}];
    NSString *t4 =[NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"余额", nil),self.cpureclaim];
    CGFloat t4l = [t4 sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]}].width;
    [t4 drawInRect:CGRectMake(ScreenWidth - t4l - 10, 80, t4l, 20) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:[UIColor textGrayColor]}];
    [self cpuTextField];
    [self addLineFromPoint:CGPointMake(0, 145) ToPoint:CGPointMake(ScreenWidth, 145) LineWidth:1.0];
    
    NSString *t31 = NSLocalizedString(@"赎回NET", nil);
    [t31 drawInRect:CGRectMake(10, 160, 100, 20) withAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14],NSForegroundColorAttributeName:[UIColor textBlackColor]}];
    NSString *t41 =[NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"余额", nil),self.netreclaim];
    CGFloat t4l1 = [t41 sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]}].width;
    [t41 drawInRect:CGRectMake(ScreenWidth - t4l1 - 10, 160, t4l1, 20) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:[UIColor textGrayColor]}];
    [self netTextField];
    [self addLineFromPoint:CGPointMake(0, 225) ToPoint:CGPointMake(ScreenWidth, 225) LineWidth:1.0];

    NSString *tx1 = NSLocalizedString(@"接收帐户", nil);
    [tx1 drawInRect:CGRectMake(10, 240, 100, 30) withAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14],NSForegroundColorAttributeName:[UIColor textBlackColor]}];
    [self reveiverLabel];
}

-(UITextField *)cpuTextField{
    if (!_cpuTextField) {
        _cpuTextField = [UITextField new];
        _cpuTextField.borderStyle = UITextBorderStyleNone;
        if (self.coinType == EOS) {
            _cpuTextField.attributedPlaceholder =[[NSAttributedString alloc]initWithString: NSLocalizedString(@"输入EOS数量", nil)];

        }else{
            _cpuTextField.attributedPlaceholder =[[NSAttributedString alloc]initWithString: NSLocalizedString(@"输入MGP数量", nil)];

        }
        _cpuTextField.backgroundColor = [UIColor whiteColor];
        _cpuTextField.textAlignment = NSTextAlignmentLeft;
        _cpuTextField.textColor = [UIColor darkGrayColor];
        _cpuTextField.font = [UIFont systemFontOfSize:16];
        _cpuTextField.userInteractionEnabled = YES;
        _cpuTextField.keyboardType = UIKeyboardTypeDecimalPad;
        [self addSubview:_cpuTextField];
        [_cpuTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(110);
            make.height.equalTo(20);
            make.left.equalTo(10);
            make.right.equalTo(-10);
        }];
    }
    return _cpuTextField;
}

-(UITextField *)netTextField{
    if (!_netTextField) {
        _netTextField = [UITextField new];
        _netTextField.borderStyle = UITextBorderStyleNone;
        if (self.coinType == EOS) {
            _netTextField.attributedPlaceholder =[[NSAttributedString alloc]initWithString: NSLocalizedString(@"输入EOS数量", nil)];

        }else{
            _netTextField.attributedPlaceholder =[[NSAttributedString alloc]initWithString: NSLocalizedString(@"输入MGP数量", nil)];

        }
        _netTextField.backgroundColor = [UIColor whiteColor];
        _netTextField.textAlignment = NSTextAlignmentLeft;
        _netTextField.textColor = [UIColor darkGrayColor];
        _netTextField.font = [UIFont systemFontOfSize:16];
        _netTextField.userInteractionEnabled = YES;
        _netTextField.keyboardType = UIKeyboardTypeDecimalPad;
        [self addSubview:_netTextField];
        [_netTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(190);
            make.height.equalTo(20);
            make.left.equalTo(10);
            make.right.equalTo(-10);
        }];
    }
    return _netTextField;
}

-(UILabel *)reveiverLabel{
    if (!_reveiverLabel) {
        _reveiverLabel = [UILabel new];
        _reveiverLabel.textColor = [UIColor textBlackColor];
        _reveiverLabel.font = [UIFont systemFontOfSize:16];
        _reveiverLabel.textAlignment = NSTextAlignmentLeft;
        _reveiverLabel.numberOfLines = 0;
        _reveiverLabel.text = _reveiver;
        [self addSubview:_reveiverLabel];
        [_reveiverLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(260);
            make.height.equalTo(30);
            make.left.equalTo(10);
            make.width.equalTo(100);
        }];
    }
    return _reveiverLabel;
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
