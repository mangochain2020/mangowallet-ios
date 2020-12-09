//
//  EOSCNDetailView.m
//  TaiYiToken
//
//  Created by 张元一 on 2018/12/20.
//  Copyright © 2018 admin. All rights reserved.
//

#import "EOSCNDetailView.h"

@implementation EOSCNDetailView

-(void)drawRect:(CGRect)rect{
    self.backgroundColor  = [UIColor whiteColor];
    //cpu
    UIFont *titlefont = [UIFont boldSystemFontOfSize:15];
    UIFont *font = [UIFont systemFontOfSize:13];
    
    [self addLineFromPoint:CGPointMake(0, rect.origin.y) ToPoint:CGPointMake(ScreenWidth, rect.origin.y) LineWidth:10.0];
    
    NSString *cputext = NSLocalizedString(@"CPU", nil);
    [cputext drawInRect:CGRectMake(rect.origin.x+10, rect.origin.y+15, 80, 20) withAttributes:@{NSFontAttributeName:titlefont,NSForegroundColorAttributeName:[UIColor textBlackColor]}];
    
    NSString *cpueos = NSLocalizedString(@"抵押", nil);
    [cpueos drawInRect:CGRectMake(rect.origin.x+10, rect.origin.y+40, 100, 20) withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor textGrayColor]}];
    NSString *avlicputext1 =[NSString stringWithFormat:@"%@" ,_cpuStakeEOS];
    CGFloat avlicputext1width = [avlicputext1 sizeWithAttributes:@{NSFontAttributeName:font}].width;
    [avlicputext1 drawInRect:CGRectMake(ScreenWidth - avlicputext1width - 10, rect.origin.y+40, avlicputext1width, 20) withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor textGrayColor]}];
    
    NSString *cputext1 = NSLocalizedString(@"可用", nil);
    [cputext1 drawInRect:CGRectMake(rect.origin.x+10, rect.origin.y+60, 100, 20) withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor textGrayColor]}];
    NSString *cpu = [NSString stringWithFormat:@"%.2f ms/ %.2f ms" ,_cpu/1000.0, _cputotal/1000.0];
    CGFloat avliramtext1width = [cpu sizeWithAttributes:@{NSFontAttributeName:font}].width;
    [cpu drawInRect:CGRectMake(ScreenWidth - avliramtext1width - 10, rect.origin.y+60, avliramtext1width, 20) withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor textGrayColor]}];
    
    
    [self addLineFromPoint:CGPointMake(10, rect.origin.y+60) ToPoint:CGPointMake(ScreenWidth, rect.origin.y+60) LineWidth:1.0];
    
    
    [self addLineFromPoint:CGPointMake(0, rect.origin.y+100) ToPoint:CGPointMake(ScreenWidth, rect.origin.y+100) LineWidth:5.0];
    //net
    NSString *cntext = NSLocalizedString(@"NET", nil);
    [cntext drawInRect:CGRectMake(rect.origin.x+10, rect.origin.y+110, 80, 20) withAttributes:@{NSFontAttributeName:titlefont,NSForegroundColorAttributeName:[UIColor textBlackColor]}];
    
    NSString *avlinettext = NSLocalizedString(@"抵押", nil);
    [avlinettext drawInRect:CGRectMake(rect.origin.x+10, rect.origin.y+135, 100, 20) withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor textGrayColor]}];
    NSString *avlinettext1 = [NSString stringWithFormat:@"%@" ,_netStakeEOS];
    CGFloat avlinettext1width = [avlinettext1 sizeWithAttributes:@{NSFontAttributeName:font}].width;
    [avlinettext1 drawInRect:CGRectMake(ScreenWidth - avlinettext1width - 10, rect.origin.y+135, avlinettext1width, 20) withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor textGrayColor]}];
    
    NSString *nettext1 = NSLocalizedString(@"可用", nil);
    [nettext1 drawInRect:CGRectMake(rect.origin.x+10, rect.origin.y+165, 100, 20) withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor textGrayColor]}];
    NSString *net = [NSString stringWithFormat:@"%.2f KB/ %.2f KB" ,_net/1000.0, _nettotal/1000.0];
    CGFloat avlinettext1width2 = [net sizeWithAttributes:@{NSFontAttributeName:font}].width;
    [net drawInRect:CGRectMake(ScreenWidth - avlinettext1width2 - 10, rect.origin.y+165, avlinettext1width2, 20) withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor textGrayColor]}];
    
    [self addLineFromPoint:CGPointMake(10, rect.origin.y+125) ToPoint:CGPointMake(ScreenWidth, rect.origin.y+125) LineWidth:1.0];
    [self addLineFromPoint:CGPointMake(10, rect.origin.y+155) ToPoint:CGPointMake(ScreenWidth, rect.origin.y+155) LineWidth:1.0];
  
    [self stakeBtn];
    [self reclaimBtn];
    //stake/recalming
    [self addLineFromPoint:CGPointMake(0, 195) ToPoint:CGPointMake(ScreenWidth, 195) LineWidth:8.0];
    
    NSString *t1 = NSLocalizedString(@"抵押", nil);
    CGFloat t1l = [t1 sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}].width;
    [t1 drawInRect:CGRectMake(ScreenWidth/2 - 70, 210, t1l, 20) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor textGrayColor]}];
    NSString *t2 = NSLocalizedString(@"赎回", nil);
    [t2 drawInRect:CGRectMake(ScreenWidth/2+30, 210, 100, 20) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor textGrayColor]}];
    
}


-(UIButton *)stakeBtn{
    if (!_stakeBtn) {
        _stakeBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        _stakeBtn.userInteractionEnabled = YES;
        _stakeBtn.backgroundColor = [UIColor clearColor];
        [_stakeBtn setImage:[UIImage imageNamed:@"wxz"] forState:UIControlStateNormal];
        [_stakeBtn setImage:[UIImage imageNamed:@"yxz"] forState:UIControlStateSelected];
        [_stakeBtn setSelected:YES];
        _stakeBtn.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 70);
        [self addSubview:_stakeBtn];
        [_stakeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-ScreenWidth/2);
            make.top.equalTo(210);
            make.width.equalTo(100);
            make.height.equalTo(20);
        }];
       
    }
   
    return _stakeBtn;
}

-(UIButton *)reclaimBtn{
    if (!_reclaimBtn) {
        _reclaimBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        _reclaimBtn.userInteractionEnabled = YES;
        _reclaimBtn.backgroundColor = [UIColor clearColor];
        [_reclaimBtn setImage:[UIImage imageNamed:@"wxz"] forState:UIControlStateNormal];
        [_reclaimBtn setImage:[UIImage imageNamed:@"yxz"] forState:UIControlStateSelected];
        [_reclaimBtn setSelected:NO];
        _reclaimBtn.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 70);
        [self addSubview:_reclaimBtn];
        [_reclaimBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ScreenWidth/2);
            make.top.equalTo(210);
            make.width.equalTo(100);
            make.height.equalTo(20);
        }];
    }
    return _reclaimBtn;
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
