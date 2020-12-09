//
//  EOSCNDetailView.h
//  TaiYiToken
//
//  Created by 张元一 on 2018/12/20.
//  Copyright © 2018 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EOSCNDetailView : UIView
@property(nonatomic,copy)NSString *cpuStakeEOS;
@property(nonatomic,assign)CGFloat cpu;
@property(nonatomic,assign)CGFloat cputotal;
@property(nonatomic,copy)NSString *netStakeEOS;
@property(nonatomic,assign)CGFloat net;
@property(nonatomic,assign)CGFloat nettotal;

@property(nonatomic,copy)NSString *balance;

@property(nonatomic,strong)UIButton *stakeBtn;
@property(nonatomic,strong)UIButton *reclaimBtn;


@end

NS_ASSUME_NONNULL_END
