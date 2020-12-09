//
//  WalletManagerCell.h
//  TaiYiToken
//
//  Created by admin on 2018/9/4.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WalletManagerCell : UICollectionViewCell
@property(nonatomic,strong)UILabel *namelb;
@property(nonatomic,strong)UIButton *addressBtn;
@property(nonatomic,strong)UIButton *shortaddressBtn;
@property(nonatomic,strong)UIButton *exportBtn;
@property(nonatomic,strong)UIImageView *backImageViewLeft;
@property(nonatomic,strong)UIImageView *backImageViewRight;

@property(nonatomic,strong)UIButton *deleteBtn;
@end
