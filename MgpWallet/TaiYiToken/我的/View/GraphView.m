//
//  GraphView.m
//  TaiYiToken
//
//  Created by 张元一 on 2018/12/7.
//  Copyright © 2018 admin. All rights reserved.
//

#import "GraphView.h"

#define kCount self.dataDic.count // 传入的数据中的个数
#define GraphViewWidth 200.0
#define GraphViewHeight 200.0 
#define GraphViewX ScreenWidth/2
#define GraphViewY ScreenHeight/2 - 230

@implementation GraphView

- (void)drawRect:(CGRect)rect

{
    
    //一个不透明类型的Quartz 2D绘画环境,相当于一个画布,你可以在上面任意绘画
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 2.0); // 线宽
    
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);// 线框颜色
    
    UIColor *aColor = [UIColor colorWithRed:1 green:0.5 blue:0.2 alpha:0.2];
    
    CGContextSetFillColorWithColor(context, aColor.CGColor);// 填充颜色
    
    
    //
    
    CGPoint center = CGPointMake(GraphViewX, GraphViewY+20);
    
    // 从一个点开始
    CGPoint point = [self getXAndYWithScores:_dataDic[_nameArr[0]] integer:1];
    CGContextMoveToPoint(context, center.x + point.x, center.y + point.y);
    
    for(int i = 1; i <= kCount; ++i)
    {
        CGPoint point = [self getXAndYWithScores:_dataDic[_nameArr[i - 1]] integer:i];
        
        // 记录上一个点，并连接到这个点；
        
        CGContextAddLineToPoint(context, center.x + point.x, center.y + point.y);
        
    }
    
    
    CGContextClosePath(context); // 结束一次画图
    
    CGContextDrawPath(context, kCGPathFillStroke);// 图形内容填充颜色方式（填满）
    
    CGContextStrokePath(context); // 可不要
    
    
    // 如果是画两组不同的图形， 重新创建一次 CGContextRef
    
    CGContextRef context2 = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBStrokeColor(context2, 28, 132, 250, 1);
    
    CGContextSetLineWidth(context2, 1.0);
    
    CGContextSetStrokeColorWithColor(context2, [UIColor lightGrayColor].CGColor);// 线框颜色
    
    
    // 几条射线，和注释
    
    for(int i = 1; i <= kCount; i++)
        
    {
        
        CGContextMoveToPoint(context2, center.x, center.y);
        
        
        CGFloat x = GraphViewWidth/2.0 * sinf(i * 2.0 * M_PI / kCount);
        
        CGFloat y = GraphViewHeight/2.0 * cosf(i * 2.0 * M_PI / kCount);
        
        CGContextAddLineToPoint(context2, center.x + x, center.y + y);
        
        UILabel *nameLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 20)];
        nameLb.textAlignment = NSTextAlignmentCenter;
        nameLb.font = [UIFont systemFontOfSize:13];
        nameLb.text = self.nameArr[i - 1];
        nameLb.textColor = [UIColor textBlackColor];
        nameLb.center = CGPointMake(center.x + x*1.2, center.y + y*1.2);
        
        [self addSubview:nameLb];
        
    }
    
    
    CGContextClosePath(context2);
    
    CGContextDrawPath(context2, kCGPathFillStroke);
    
    CGContextStrokePath(context2);
    
     //画网格线
    for (NSInteger index = 1; index <= self.maxvalue; ++index) {
       
        
        CGContextRef context3 = UIGraphicsGetCurrentContext();
        
        CGContextSetLineWidth(context3, 1.5); // 线宽
        
        CGContextSetStrokeColorWithColor(context3, [UIColor grayColor].CGColor);// 线框颜色
        
        UIColor *aColor3 = [UIColor colorWithRed:1 green:0.5 blue:0.2 alpha:0.2];
        
        CGContextSetFillColorWithColor(context3, aColor3.CGColor);// 填充颜色
        
        
        // 从一个点开始
        CGPoint point3 = [self getXAndYWithScores:[NSString stringWithFormat:@"%ld",index] integer:1];
        
        CGContextMoveToPoint(context3, center.x + point3.x, center.y + point3.y);
        for(int i = 1; i <= kCount; ++i)
        {
            CGPoint point = [self getXAndYWithScores:[NSString stringWithFormat:@"%ld",index] integer:i];
            
            // 记录上一个点，并连接到这个点；
            
            CGContextAddLineToPoint(context3, center.x + point.x, center.y + point.y);
            
        }
        
        
        CGContextClosePath(context3); // 结束一次画图
        
        CGContextDrawPath(context3, kCGPathStroke);
        
        CGContextStrokePath(context3);
    }
    
    
    
}


//

- (CGPoint)getXAndYWithScores:(NSString *)scores integer:(NSInteger)integer

{
    
    CGFloat x = GraphViewHeight/2.0 * ([scores floatValue] / self.maxvalue) * sinf(integer * 2.0 * M_PI / kCount
                                                           
                                                           );
    
    CGFloat y = GraphViewHeight/2.0 * ([scores floatValue] / self.maxvalue) * cosf(integer * 2.0 * M_PI / kCount);
    
    CGPoint point = CGPointMake(x, y);
    
    return point;
    
}

@end
