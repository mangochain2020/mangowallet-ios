//
//  SortTypeSelectView.h
//  TaiYiToken
//
//  Created by 张元一 on 2018/11/22.
//  Copyright © 2018 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SortTypeSelectView : UIView
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,strong)NSMutableArray <UIButton *> *btnArray;

/*
 height view总高
 */
-(void)initBtnsWithWidth:(CGFloat)width Height:(CGFloat)height;
@end

NS_ASSUME_NONNULL_END
