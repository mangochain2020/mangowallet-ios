//
//  EOSHelpRegisterView.h
//  TaiYiToken
//
//  Created by 张元一 on 2018/12/27.
//  Copyright © 2018 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EOSHelpRegisterView : UIView
@property(nonatomic,copy)NSString *totaleos;
@property(nonatomic,copy)NSString *ramamount;
@property(nonatomic,copy)NSString *rameos;
@property(nonatomic,copy)NSString *cpuamount;
@property(nonatomic,copy)NSString *cpueos;
@property(nonatomic,copy)NSString *netamount;
@property(nonatomic,copy)NSString *neteos;
@property(nonatomic,copy)NSString *eosAccount;
@property(nonatomic,copy)NSString *eosAccountActiveKey;
@property(nonatomic,copy)NSString *eosAccountOwnerKey;
@property(nonatomic,copy)NSString *payerAccount;
@property(nonatomic,strong)UITextField *accountTextField;
@property(nonatomic,strong)UIButton *selectPayerBtn;
@end

NS_ASSUME_NONNULL_END
