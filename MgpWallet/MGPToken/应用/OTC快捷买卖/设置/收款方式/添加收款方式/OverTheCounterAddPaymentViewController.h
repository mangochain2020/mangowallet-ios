//
//  OverTheCounterAddPaymentViewController.h
//  TaiYiToken
//
//  Created by mac on 2020/12/30.
//  Copyright © 2020 admin. All rights reserved.
//

#import "JhFormTableViewVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface OverTheCounterAddPaymentViewController : JhFormTableViewVC

@property (assign, nonatomic) int payType;
@property (strong, nonatomic) NSDictionary *model;

@end

NS_ASSUME_NONNULL_END
