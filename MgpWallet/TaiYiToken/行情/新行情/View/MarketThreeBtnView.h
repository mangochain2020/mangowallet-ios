//
//  MarketThreeBtnView.h
//  TaiYiToken
//
//  Created by admin on 2018/10/11.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MarketThreeBtnView : UIView
@property(nonatomic)UIButton *firstBtn;
@property(nonatomic)UIButton *secondBtn;
@property(nonatomic)UIButton *thirdBtn;
@property(nonatomic)BTN_SELECT_TYPE secSelectType;
@property(nonatomic)BTN_SELECT_TYPE thirSelectType;


@property(nonatomic)UIImageView *iv0;
@property(nonatomic)UIImageView *iv10;
@property(nonatomic)UIImageView *iv11;
@property(nonatomic)UIImageView *iv20;
@property(nonatomic)UIImageView *iv21;


-(UIButton *)firstBtnWithTitile:(NSString *)title ifHasImages:(BOOL)ifHasImages;
//selectType不是012取值时，按顺序+1循环
-(UIButton *)secondBtnWithTitle:(NSString *)title ifHasImages:(BOOL)ifHasImages SelectTYpe:(BTN_SELECT_TYPE)selectType;
//selectType不是012取值时，按顺序+1循环
-(UIButton *)thirdBtnWithTitle:(NSString *)title ifHasImages:(BOOL)ifHasImages SelectTYpe:(BTN_SELECT_TYPE)selectType;
@end
