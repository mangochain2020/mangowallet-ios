//
//  MangoDefiListViewController.h
//  TaiYiToken
//
//  Created by mac on 2020/8/31.
//  Copyright © 2020 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MangoDefiListViewController : UIViewController

@property (nonatomic, copy) NSString *defiID;
@property (copy,nonatomic)NSString *countryID;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

NS_ASSUME_NONNULL_END
