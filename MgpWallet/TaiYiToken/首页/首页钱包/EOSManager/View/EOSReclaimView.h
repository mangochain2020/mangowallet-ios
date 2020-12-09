//
//  EOSReclaimView.h
//  TaiYiToken
//
//  Created by 张元一 on 2018/12/21.
//  Copyright © 2018 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EOSReclaimView : UIView
@property(nonatomic,copy)NSString *cpureclaim;
@property(nonatomic,copy)NSString *netreclaim;
@property(nonatomic,copy)NSString *reveiver;

@property(nonatomic,strong)UITextField *cpuTextField;
@property(nonatomic,strong)UITextField *netTextField;
@property(nonatomic,strong)UILabel *reveiverLabel;

@property(nonatomic,assign)CoinType coinType;

@end

NS_ASSUME_NONNULL_END
