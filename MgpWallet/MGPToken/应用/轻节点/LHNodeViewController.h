//
//  LHNodeViewController.h
//  TaiYiToken
//
//  Created by mac on 2020/7/24.
//  Copyright © 2020 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LHNodeViewController : UIViewController

@end

@interface LHNodeModel : NSObject

@property (nonatomic, copy) NSString *nodeLevel;
@property (nonatomic, copy) NSString *nodeNum;
@property (nonatomic, copy) NSString *teamMoney;
@property (nonatomic, copy) NSString *teamValue;
@property (nonatomic, copy) NSString *yesterdayMoney;

@end

NS_ASSUME_NONNULL_END
