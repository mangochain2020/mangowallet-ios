//
//  DCCenterBeaShopCell.h
//  CDDStoreDemo
//
//  Created by 陈甸甸 on 2017/12/13.
//Copyright © 2017年 RocketsChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCMyCenterModel.h"

@interface DCCenterBeaShopCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIButton *orderBtn;

@property (weak, nonatomic) IBOutlet UIButton *shopBtn;
@property (weak, nonatomic) IBOutlet UIButton *mgpButton;
@property (weak, nonatomic) IBOutlet UIButton *bondBtn;

@property (weak, nonatomic) IBOutlet UIButton *controlButton;

@property (strong, nonatomic) DCMyCenterModel *myCenterModel;

@property (assign, nonatomic) BOOL isShop;


@end
