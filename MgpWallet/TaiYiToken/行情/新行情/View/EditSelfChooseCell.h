//
//  EditSelfChooseCell.h
//  TaiYiToken
//
//  Created by admin on 2018/10/12.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditSelfChooseCell : UITableViewCell
@property(nonatomic)UIButton *chooseBtn;
@property(nonatomic,strong)UILabel *coinNamelabel;//ETH
@property(nonatomic,strong)UILabel *coinNameDetaillabel;//BTC

@property(nonatomic,strong)UILabel *namelabel;//火币pro,以太坊

@property(nonatomic)UIButton *moveToTopBtn;
@property(nonatomic)UIButton *moveBtn;
-(void)initBtns;
@end
