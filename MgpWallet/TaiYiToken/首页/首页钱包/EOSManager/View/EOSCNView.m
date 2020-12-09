//
//  EOSCNView.m
//  TaiYiToken
//
//  Created by 张元一 on 2018/12/19.
//  Copyright © 2018 admin. All rights reserved.
//

#import "EOSCNView.h"

@implementation EOSCNView

-(void)drawRect:(CGRect)rect{
    self.backgroundColor  = [UIColor whiteColor];
    //ram
    UIFont *titlefont = [UIFont boldSystemFontOfSize:15];
    UIFont *font = [UIFont systemFontOfSize:13];
    
    [self addLineFromPoint:CGPointMake(0, rect.origin.y) ToPoint:CGPointMake(ScreenWidth, rect.origin.y) LineWidth:10.0];
    
    NSString *ramtext = NSLocalizedString(@"内存", nil);
    [ramtext drawInRect:CGRectMake(rect.origin.x+10, rect.origin.y+15, 80, 20) withAttributes:@{NSFontAttributeName:titlefont,NSForegroundColorAttributeName:[UIColor textBlackColor]}];
    
    NSString *avliramtext =[NSString stringWithFormat:@"%@%@" ,NSLocalizedString(@"可用", nil), NSLocalizedString(@"内存", nil)];
    [avliramtext drawInRect:CGRectMake(rect.origin.x+10, rect.origin.y+40, 100, 20) withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor textGrayColor]}];
    NSString *avliramtext1 =[NSString stringWithFormat:@"%.2f KB/ %.2f KB" ,_ram/1000.0, _ramtotal/1000.0];
    CGFloat avliramtext1width = [avliramtext1 sizeWithAttributes:@{NSFontAttributeName:font}].width;
    [avliramtext1 drawInRect:CGRectMake(ScreenWidth - avliramtext1width - 10, rect.origin.y+40, avliramtext1width, 20) withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor textGrayColor]}];
    
    
    NSString *ramremindtext = self.coinType == EOS ? NSLocalizedString(@"说明：内存需要使用EOS购买", nil) : NSLocalizedString(@"说明：内存需要使用MGP购买", nil);
    [ramremindtext drawInRect:CGRectMake(rect.origin.x+10, rect.origin.y+70, ScreenWidth, 20) withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor textGrayColor]}];
    
    [self addLineFromPoint:CGPointMake(10, rect.origin.y+60) ToPoint:CGPointMake(ScreenWidth, rect.origin.y+60) LineWidth:1.0];
    
    [self addLineFromPoint:CGPointMake(0, rect.origin.y+100) ToPoint:CGPointMake(ScreenWidth, rect.origin.y+100) LineWidth:5.0];
    //cpu net
    NSString *cntext = NSLocalizedString(@"带宽", nil);
    [cntext drawInRect:CGRectMake(rect.origin.x+10, rect.origin.y+110, 80, 20) withAttributes:@{NSFontAttributeName:titlefont,NSForegroundColorAttributeName:[UIColor textBlackColor]}];
    
    NSString *avlicputext =[NSString stringWithFormat:@"%@ CPU" ,NSLocalizedString(@"可用", nil)];
    [avlicputext drawInRect:CGRectMake(rect.origin.x+10, rect.origin.y+140, 100, 20) withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor textGrayColor]}];
    NSString *avlicputext1 =[NSString stringWithFormat:@"%.2f ms/ %.2f ms" ,_cpu/1000.0, _cputotal/1000.0];
    CGFloat avlicputext1width = [avlicputext1 sizeWithAttributes:@{NSFontAttributeName:font}].width;
    [avlicputext1 drawInRect:CGRectMake(ScreenWidth - avlicputext1width - 10, rect.origin.y+140, avlicputext1width, 20) withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor textGrayColor]}];
    
    NSString *avlinettext =[NSString stringWithFormat:@"%@ NET" ,NSLocalizedString(@"可用", nil)];
    [avlinettext drawInRect:CGRectMake(rect.origin.x+10, rect.origin.y+170, 100, 20) withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor textGrayColor]}];
    NSString *avlinettext1 =[NSString stringWithFormat:@"%.2f KB/ %.2f KB" ,_net/1000.0, _nettotal/1000.0];
    CGFloat avlinettext1width = [avlinettext1 sizeWithAttributes:@{NSFontAttributeName:font}].width;
    [avlinettext1 drawInRect:CGRectMake(ScreenWidth - avlinettext1width - 10, rect.origin.y+170, avlinettext1width, 20) withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor textGrayColor]}];
    
//    NSString *cnremindtext = [NSString stringWithFormat:NSLocalizedString(@"说明：带宽需要抵押%@换取", nil),self.coinType == EOS ? @"EOS" : @"MGP"];
    NSString *cnremindtext = self.coinType == EOS ? NSLocalizedString(@"说明：带宽需要抵押EOS换取", nil) : NSLocalizedString(@"说明：带宽需要抵押MGP换取", nil);

//    NSString *cnremindtext = NSLocalizedString(@"说明：带宽需要抵押EOS换取", nil);
    [cnremindtext drawInRect:CGRectMake(rect.origin.x+10, rect.origin.y+200, ScreenWidth, 20) withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor textGrayColor]}];
    
    [self addLineFromPoint:CGPointMake(10, rect.origin.y+160) ToPoint:CGPointMake(ScreenWidth, rect.origin.y+160) LineWidth:1.0];
    [self addLineFromPoint:CGPointMake(10, rect.origin.y+190) ToPoint:CGPointMake(ScreenWidth, rect.origin.y+190) LineWidth:1.0];
   
    
    
}

-(UIButton *)ramBtn{
    if (!_ramBtn) {
        _ramBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        _ramBtn.userInteractionEnabled = YES;
        _ramBtn.backgroundColor = [UIColor clearColor];
        [_ramBtn setImage:[UIImage imageNamed:@"ico_left_arrow"] forState:UIControlStateNormal];
        _ramBtn.imageEdgeInsets=UIEdgeInsetsMake(0, 130, 30, 0);
        [self addSubview:_ramBtn];
        [_ramBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(0);
            make.top.equalTo(10);
            make.width.equalTo(150);
            make.height.equalTo(50);
        }];
    }
    return _ramBtn;
}

-(UIButton *)cnBtn{
    if (!_cnBtn) {
        _cnBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        _cnBtn.userInteractionEnabled = YES;
        _cnBtn.backgroundColor = [UIColor clearColor];
        [_cnBtn setImage:[UIImage imageNamed:@"ico_left_arrow"] forState:UIControlStateNormal];
        _cnBtn.imageEdgeInsets=UIEdgeInsetsMake(0, 130, 30, 0);
        [self addSubview:_cnBtn];
        [_cnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(0);
            make.top.equalTo(110);
            make.width.equalTo(150);
            make.height.equalTo(50);
        }];
    }
    return _cnBtn;
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
