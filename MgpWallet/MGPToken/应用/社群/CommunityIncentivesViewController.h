//
//  CommunityIncentivesViewController.h
//  TaiYiToken
//
//  Created by mac on 2020/7/24.
//  Copyright © 2020 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommunityIncentivesViewController : UIViewController

@end

@interface CommunityIncentiveModel : NSObject

@property (nonatomic, copy) NSString *yesterdayMoney;
@property (nonatomic, copy) NSString *yesterdayPushMoney;
@property (nonatomic, copy) NSString *yesterdayTeamMoney;
@property (nonatomic, copy) NSString *yesterdayLightNodeMoney;
@property (nonatomic, copy) NSString *myPushPro;
@property (nonatomic, copy) NSString *myFloor;
@property (nonatomic, copy) NSString *lightNodeFlag;
@property (nonatomic, copy) NSString *teamNum;
@property (nonatomic, copy) NSString *teamValue;
@property (nonatomic, copy) NSArray *teamList;

@end
NS_ASSUME_NONNULL_END
