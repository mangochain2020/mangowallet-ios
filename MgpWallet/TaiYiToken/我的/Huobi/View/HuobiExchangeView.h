//
//  HuobiExchangeView.h
//  TaiYiToken
//
//  Created by 张元一 on 2019/3/14.
//  Copyright © 2019 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HuobiBtn.h"
#import "HuobiToolView.h"
#import "HuobiTypeOneTF.h"
#import "HuobiTypeTwoTF.h"
NS_ASSUME_NONNULL_BEGIN

@interface HuobiExchangeView : UIView
/*
 left
 */
@property(nonatomic,strong)UIButton *buyBtn;
@property(nonatomic,strong)UIButton *saleBtn;
@property(nonatomic,strong)UIButton *operationBtn;
//限价
@property(nonatomic,strong)UIButton *buychooseBtn;

@property(nonatomic,strong)HuobiTypeOneTF *priceTF;
@property(nonatomic,strong)HuobiTypeTwoTF *quantityTF;

@property(nonatomic,strong)UILabel *amountLb;

@property(nonatomic,strong)UILabel *symbolLb;
@property(nonatomic,strong)UIButton *showSelectSymbolViewBtn;
-(void)loadLeftView;
/*
 right
 */


@end

NS_ASSUME_NONNULL_END
