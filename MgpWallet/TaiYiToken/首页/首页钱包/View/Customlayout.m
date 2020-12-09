//
//  Customlayout.m
//  TaiYiToken
//
//  Created by admin on 2018/9/5.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "Customlayout.h"

@implementation Customlayout
-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity

{
    
    //1.计算scrollview最后停留的范围
    
    CGRect lastRect ;
    
    lastRect.origin = proposedContentOffset;
    
    lastRect.size = self.collectionView.frame.size;
    
    //2.取出这个范围内的所有属性
    
    NSArray *array = [self layoutAttributesForElementsInRect:lastRect];
    
    //起始的x值，也即默认情况下要停下来的x值
    
    CGFloat startX = proposedContentOffset.x;
    
    
    
    //3.遍历所有的属性
    
    CGFloat adjustOffsetX = MAXFLOAT;
    
    for (UICollectionViewLayoutAttributes *attrs in array) {
        
        CGFloat attrsX = CGRectGetMinX(attrs.frame); //单元格x
        
        CGFloat attrsW = CGRectGetWidth(attrs.frame) ; //单元格宽度
        
        
        
        if (startX - attrsX  < attrsW/2) { //小于一半
            
            adjustOffsetX = -(startX - attrsX);
            
        }else{
            
            adjustOffsetX = attrsW - (startX - attrsX);
            
        }
        
        
        
        break ;//只循环数组中第一个元素即可，所以直接break了
        
    }
    
    return CGPointMake(proposedContentOffset.x + adjustOffsetX - 25, proposedContentOffset.y);
    
}
@end
