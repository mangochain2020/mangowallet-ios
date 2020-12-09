//
//  HuobiRightExchangeVC.h
//  TaiYiToken
//
//  Created by 张元一 on 2019/3/15.
//  Copyright © 2019 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HuobiRightExchangeVC : UIViewController
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *titleArray0;
@property (nonatomic, copy)NSString *currentPrice;
@property (nonatomic, copy)NSString *selectedPrice;

//
@property(nonatomic,assign)NSInteger currentDepth;//0,1,2..
@property(nonatomic,assign)HUOBI_PriceDataShowType showType;
//
@property (nonatomic, strong)UIButton *depthBtn;
@property (nonatomic, strong)UIButton *typeBtn;
-(void)NetRequest;
@end

NS_ASSUME_NONNULL_END
