//
//  EOSStakeView.h
//  TaiYiToken
//
//  Created by 张元一 on 2018/12/21.
//  Copyright © 2018 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EOSStakeView : UIView
@property(nonatomic,copy)NSString *balance;
@property(nonatomic,strong)UITextField *cnTextField;
@property(nonatomic,strong)UILabel *cnLabel;
@property(nonatomic,strong)UITextField *accountTextField;
@property(nonatomic,copy)NSString *reveiveAccount;
@property(nonatomic,assign)CoinType coinType;

@end

NS_ASSUME_NONNULL_END
