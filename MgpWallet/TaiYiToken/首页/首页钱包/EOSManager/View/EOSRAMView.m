//
//  EOSRAMView.m
//  TaiYiToken
//
//  Created by 张元一 on 2018/12/24.
//  Copyright © 2018 admin. All rights reserved.
//

#import "EOSRAMView.h"

@implementation EOSRAMView

- (void)drawRect:(CGRect)rect {
    self.backgroundColor  = [UIColor whiteColor];
    UIFont *titlefont = [UIFont boldSystemFontOfSize:15];
    UIFont *font = [UIFont systemFontOfSize:13];
    
    [self addLineFromPoint:CGPointMake(0, rect.origin.y) ToPoint:CGPointMake(ScreenWidth, rect.origin.y) LineWidth:10.0];
    
    NSString *ramtext = NSLocalizedString(@"内存", nil);
    [ramtext drawInRect:CGRectMake(rect.origin.x+10, 10, 80, 20) withAttributes:@{NSFontAttributeName:titlefont,NSForegroundColorAttributeName:[UIColor textBlackColor]}];
    
    NSString *avliramtext = NSLocalizedString(@"可用", nil);
    [avliramtext drawInRect:CGRectMake(rect.origin.x+10, 35, 100, 20) withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor textGrayColor]}];
    NSString *avliramtext1 =[NSString stringWithFormat:@"%.2f KB/ %.2f KB" ,_ram/1000.0, _ramtotal/1000.0];
    CGFloat avliramtext1width = [avliramtext1 sizeWithAttributes:@{NSFontAttributeName:font}].width;
    [avliramtext1 drawInRect:CGRectMake(ScreenWidth - avliramtext1width - 10, 35, avliramtext1width, 20) withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor textGrayColor]}];
    
    [self addLineFromPoint:CGPointMake(0, 60) ToPoint:CGPointMake(ScreenWidth, 60) LineWidth:10.0];
    
    UIColor * color2 = [UIColor appBlueColor];
    [color2 setFill];
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(10, 80, ScreenWidth - 20, 30) cornerRadius:2];
    [path stroke];
    [path fill];
    
    NSString *t0 = NSLocalizedString(@"当前价格", nil);
    [t0 drawInRect:CGRectMake(15, 87, 100, 38) withAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:13],NSForegroundColorAttributeName:[UIColor textWhiteColor]}];
//    NSString *t01 = self.ramprice;
//    CGFloat t01l = [t01 sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]}].width;
//    [t01 drawInRect:CGRectMake(ScreenWidth - t01l - 15, 85, 100, 38) withAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15],NSForegroundColorAttributeName:[UIColor textBlackColor]}];
    
    [self buyBtn];
    [self saleBtn];
    NSString *t1 = NSLocalizedString(@"购买", nil);
    CGFloat t1l = [t1 sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}].width;
    [t1 drawInRect:CGRectMake(ScreenWidth/2 - 70, 140, t1l, 20) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor textGrayColor]}];
    NSString *t2 = NSLocalizedString(@"出售", nil);
    [t2 drawInRect:CGRectMake(ScreenWidth/2+30, 140, 100, 20) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor textGrayColor]}];
    
//    NSString *t3 = NSLocalizedString(@"EOS数量", nil);
//    [t3 drawInRect:CGRectMake(10, 165, 100, 20) withAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14],NSForegroundColorAttributeName:[UIColor textBlackColor]}];
    [self manageTitleLabel];
//    NSString *t4 =[NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"余额", nil),self.eosbalance];
//    CGFloat t4l = [t4 sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]}].width;
//    [t4 drawInRect:CGRectMake(ScreenWidth - t4l - 10, 160, t4l, 20) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:[UIColor textGrayColor]}];
    [self manageTextField];
//    [self addLineFromPoint:CGPointMake(0, 190) ToPoint:CGPointMake(ScreenWidth, 190) LineWidth:1.0];
    
    NSString *tx1 = NSLocalizedString(@"接收帐户", nil);
    [tx1 drawInRect:CGRectMake(10, 232, 100, 30) withAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14],NSForegroundColorAttributeName:[UIColor textBlackColor]}];
    [self reveiverTextField];
    [self addLineFromPoint:CGPointMake(0, 225) ToPoint:CGPointMake(ScreenWidth, 225) LineWidth:1.0];
}

-(UILabel *)balanceLabel{
    if (!_balanceLabel) {
        _balanceLabel = [UILabel new];
        _balanceLabel.textColor = [UIColor textGrayColor];
        _balanceLabel.font = [UIFont systemFontOfSize:10];
        _balanceLabel.textAlignment = NSTextAlignmentRight;
        _balanceLabel.numberOfLines = 0;
        [self addSubview:_balanceLabel];
        [_balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(160);
            make.width.equalTo(150);
            make.height.equalTo(20);
            make.right.equalTo(-15);
        }];
    }
    return _balanceLabel;
}

-(UILabel *)manageTitleLabel{
    if (!_manageTitleLabel) {
        _manageTitleLabel = [UILabel new];
        _manageTitleLabel.textColor = [UIColor textBlackColor];
        _manageTitleLabel.font = [UIFont boldSystemFontOfSize:14];
        _manageTitleLabel.textAlignment = NSTextAlignmentLeft;
        _manageTitleLabel.numberOfLines = 0;
        [_manageTitleLabel setText:NSLocalizedString(@"购买数量", nil)];
        [self addSubview:_manageTitleLabel];
        [_manageTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(165);
            make.left.equalTo(10);
            make.height.equalTo(20);
            make.right.equalTo(-15);
        }];
    }
    return _manageTitleLabel;
}

-(UILabel *)rampriceLabel{
    if (!_rampriceLabel) {
        _rampriceLabel = [UILabel new];
        _rampriceLabel.textColor = [UIColor textWhiteColor];
        _rampriceLabel.font = [UIFont systemFontOfSize:13];
        _rampriceLabel.textAlignment = NSTextAlignmentRight;
        _rampriceLabel.numberOfLines = 0;
        [_rampriceLabel setText:_ramprice];
        [self addSubview:_rampriceLabel];
        [_rampriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(85);
            make.height.equalTo(20);
            make.right.equalTo(-15);
            make.width.equalTo(200);
        }];
    }
    return _rampriceLabel;
}

-(UILabel *)amountLabel{
    if (!_amountLabel) {
        _amountLabel = [UILabel new];
        _amountLabel.textColor = [UIColor lightGrayColor];
        _amountLabel.font = [UIFont systemFontOfSize:14];
        _amountLabel.textAlignment = NSTextAlignmentRight;
        _amountLabel.numberOfLines = 0;
        [_amountLabel setText:NSLocalizedString(@"购买数量", nil)];
        [self.manageTextField addSubview:_amountLabel];
        [_amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.equalTo(-10);
            make.width.equalTo(100);
            make.height.equalTo(20);
        }];
    }
    return _amountLabel;
}

-(UITextField *)manageTextField{
    if (!_manageTextField) {
        _manageTextField = [UITextField new];
        _manageTextField.borderStyle = UITextBorderStyleNone;
        _manageTextField.placeholder = self.coinType == EOS ? NSLocalizedString(@"输入EOS数量", nil) : NSLocalizedString(@"输入MGP数量", nil);
        _manageTextField.backgroundColor = [UIColor whiteColor];
        _manageTextField.textAlignment = NSTextAlignmentLeft;
        _manageTextField.textColor = [UIColor darkGrayColor];
        _manageTextField.font = [UIFont systemFontOfSize:16];
        _manageTextField.userInteractionEnabled = YES;
        _manageTextField.keyboardType = UIKeyboardTypeDecimalPad;
        [self addSubview:_manageTextField];
        [_manageTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(190);
            make.height.equalTo(20);
            make.left.equalTo(10);
            make.right.equalTo(-10);
        }];
    }
    return _manageTextField;
}

-(UITextField *)reveiverTextField{
    if (!_reveiverTextField) {
        _reveiverTextField = [UITextField new];
        _reveiverTextField.borderStyle = UITextBorderStyleNone;
        _reveiverTextField.backgroundColor = [UIColor whiteColor];
        _reveiverTextField.textAlignment = NSTextAlignmentRight;
        _reveiverTextField.textColor = [UIColor darkGrayColor];
        _reveiverTextField.font = [UIFont systemFontOfSize:14];
        _reveiverTextField.userInteractionEnabled = YES;
        [self addSubview:_reveiverTextField];
        [_reveiverTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(230);
            make.height.equalTo(30);
            make.left.equalTo(100);
            make.right.equalTo(-10);
        }];
    }
    return _reveiverTextField;
}

-(UIButton *)buyBtn{
    if (!_buyBtn) {
        _buyBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        _buyBtn.userInteractionEnabled = YES;
        _buyBtn.backgroundColor = [UIColor clearColor];
        [_buyBtn setImage:[UIImage imageNamed:@"wxz"] forState:UIControlStateNormal];
        [_buyBtn setImage:[UIImage imageNamed:@"yxz"] forState:UIControlStateSelected];
        [_buyBtn setSelected:YES];
        _buyBtn.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 70);
        [self addSubview:_buyBtn];
        [_buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-ScreenWidth/2);
            make.top.equalTo(140);
            make.width.equalTo(100);
            make.height.equalTo(20);
        }];
        
    }
    
    return _buyBtn;
}

-(UIButton *)saleBtn{
    if (!_saleBtn) {
        _saleBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        _saleBtn.userInteractionEnabled = YES;
        _saleBtn.backgroundColor = [UIColor clearColor];
        [_saleBtn setImage:[UIImage imageNamed:@"wxz"] forState:UIControlStateNormal];
        [_saleBtn setImage:[UIImage imageNamed:@"yxz"] forState:UIControlStateSelected];
        [_saleBtn setSelected:NO];
        _saleBtn.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 70);
        [self addSubview:_saleBtn];
        [_saleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ScreenWidth/2);
            make.top.equalTo(140);
            make.width.equalTo(100);
            make.height.equalTo(20);
        }];
    }
    return _saleBtn;
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
