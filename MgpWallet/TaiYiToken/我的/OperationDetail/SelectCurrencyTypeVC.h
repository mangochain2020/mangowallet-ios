//
//  SelectCurrencyTypeVC.h
//  TaiYiToken
//
//  Created by admin on 2018/9/26.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SelectNodeDelegate <NSObject>
@optional
-(void)selectNode:(NSString *)nodes Index:(NSInteger)index;
@end

@interface SelectCurrencyTypeVC : UIViewController
@property(nonatomic)CONFIG_TYPE configType;
@property(nonatomic)CoinType coinType;
@property(nonatomic,assign) NSObject<SelectNodeDelegate> *delegate;
@end
