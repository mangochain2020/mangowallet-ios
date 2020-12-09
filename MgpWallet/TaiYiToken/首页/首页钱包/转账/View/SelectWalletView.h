//
//  SelectWalletView.h
//  TaiYiToken
//
//  Created by 张元一 on 2018/11/15.
//  Copyright © 2018 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserConfigCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface SelectWalletView : UIViewController
@property(nonatomic,strong)NSMutableArray <MissionWallet *> *selectwalletArray;
@property(nonatomic,strong)MissionWallet *selectedwallet;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic)BOOL isshowed;

@property(nonatomic,strong)UIButton *cofirmBtn;
@property(nonatomic,strong)UIButton *cancelBtn;
@end

NS_ASSUME_NONNULL_END
