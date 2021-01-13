//
//  UIButton+HXExtension.m
//  照片选择器
//
//  Created by 洪欣 on 17/2/16.
//  Copyright © 2017年 洪欣. All rights reserved.
//

#import "UIButton+HXExtension.h"
#import <objc/runtime.h>

@implementation UIButton (HXExtension)

static char topNameKey;
static char rightNameKey;
static char bottomNameKey;
static char leftNameKey;

- (void)hx_setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left
{
    objc_setAssociatedObject(self, &topNameKey, [NSNumber numberWithFloat:top], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:right], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:bottom], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftNameKey, [NSNumber numberWithFloat:left], OBJC_ASSOCIATION_COPY_NONATOMIC);
}


- (CGRect)enlargedRect{
    NSNumber* topEdge    = objc_getAssociatedObject(self, &topNameKey);
    NSNumber* rightEdge  = objc_getAssociatedObject(self, &rightNameKey);
    NSNumber* bottomEdge = objc_getAssociatedObject(self, &bottomNameKey);
    NSNumber* leftEdge   = objc_getAssociatedObject(self, &leftNameKey);
    
    if (topEdge && rightEdge && bottomEdge && leftEdge){
        return CGRectMake(self.bounds.origin.x - leftEdge.floatValue,
                          self.bounds.origin.y - topEdge.floatValue,
                          self.bounds.size.width  + leftEdge.floatValue + rightEdge.floatValue,
                          self.bounds.size.height + topEdge.floatValue + bottomEdge.floatValue);
    } else{
        return self.bounds;
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    CGRect rect = [self enlargedRect];
    
    if (CGRectEqualToRect(rect, self.bounds)){
        return [super pointInside:point withEvent:event];
    }else{
        return CGRectContainsPoint(rect, point);
    }
}



- (void)refreshTopBottom{
    CGFloat btnH=self.frame.size.height;
    CGFloat btnW=self.frame.size.width;
    
    CGFloat ivX=self.imageView.frame.origin.x;
    CGFloat ivY=self.imageView.frame.origin.y;
    CGFloat ivW=self.imageView.frame.size.width;
    
    CGFloat titX=self.titleLabel.frame.origin.x;
    CGFloat titY=self.titleLabel.frame.origin.y;
    CGFloat titW=self.titleLabel.frame.size.width;
    CGFloat titH=self.titleLabel.frame.size.height;
    
    //top
    CGFloat t1=-ivY;
    CGFloat l1=btnW*0.5-(ivX+ivW*0.5);
    CGFloat b1=-t1;
    CGFloat r1=-l1;
    self.imageEdgeInsets=UIEdgeInsetsMake(t1,l1,b1,r1);
    
    CGFloat t2=btnH-titY-titH;
    CGFloat l2=btnW*0.5-(titX+titW*0.5);
    CGFloat b2=-t2;
    CGFloat r2=-l2;
    
    self.titleEdgeInsets=UIEdgeInsetsMake(t2,l2,b2,r2);
}

- (void)refreshRightLeft{
    CGFloat ivW=self.imageView.frame.size.width;
    CGFloat titW=self.titleLabel.frame.size.width;
    
    CGFloat t1=0;
    CGFloat l1=titW;
    CGFloat b1=-t1;
    CGFloat r1=-l1;
    self.imageEdgeInsets=UIEdgeInsetsMake(t1,l1,b1,r1);
    
    CGFloat t2=0;
    CGFloat l2=-ivW;
    CGFloat b2=-t2;
    CGFloat r2=-l2;
    self.titleEdgeInsets=UIEdgeInsetsMake(t2,l2,b2,r2);
}

- (void)refreshBottomTop{
    
}

- (void)refreshImageViewWithTop:(CGFloat)top andBottom:(CGFloat)bottom andLeft:(CGFloat)left andRight:(CGFloat)right{
    UIEdgeInsets edg=self.imageEdgeInsets;
    edg.top+=top;
    edg.bottom+=bottom;
    edg.left+=left;
    edg.right+=right;
    self.imageEdgeInsets=edg;
}

- (void)refreshTitleLabelWithTop:(CGFloat)top andBottom:(CGFloat)bottom andLeft:(CGFloat)left andRight:(CGFloat)right{
    UIEdgeInsets edg=self.titleEdgeInsets;
    edg.top+=top;
    edg.bottom+=bottom;
    edg.left+=left;
    edg.right+=right;
    self.titleEdgeInsets=edg;
}

- (void)verticalImageAndTitle:(CGFloat)spacing
{
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    CGSize textSize = [self.titleLabel.text sizeWithFont:self.titleLabel.font];
    CGSize frameSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
    if (titleSize.width + 0.5 < frameSize.width) {
        titleSize.width = frameSize.width;
    }
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    self.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, - imageSize.width, - (totalHeight - titleSize.height), 0);

}


@end
