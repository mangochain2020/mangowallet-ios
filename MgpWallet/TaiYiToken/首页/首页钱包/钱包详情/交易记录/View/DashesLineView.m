//
//  DashesLineView.m
//  TaiYiToken
//
//  Created by admin on 2018/9/19.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "DashesLineView.h"


#define kInterval 10                                // 全局间距

@implementation DashesLineView



- (void)drawRect:(CGRect)rect {
   
    CGContextRef context =UIGraphicsGetCurrentContext();
    // 设置线条的样式
    CGContextSetLineCap(context, kCGLineCapRound);
    // 绘制线的宽度
    CGContextSetLineWidth(context, _lineWidth);
    // 线的颜色
    CGContextSetStrokeColorWithColor(context, _lineColor.CGColor);
    // 开始绘制
    CGContextBeginPath(context);
    // 设置虚线绘制起点
    CGContextMoveToPoint(context, self.origin.x, 0);
    // lengths的值｛10,10｝表示先绘制10个点，再跳过10个点，如此反复
    CGFloat lengths[] = {10,10};
    // 虚线的起始点
    CGContextSetLineDash(context, 0, lengths,2);
    // 绘制虚线的终点
    CGContextAddLineToPoint(context, self.origin.x + ScreenWidth, 0);
    // 绘制
    CGContextStrokePath(context);
    // 关闭图像
    CGContextClosePath(context);
    
}



@end
