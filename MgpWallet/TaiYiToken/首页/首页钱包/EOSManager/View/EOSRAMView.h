//
//  EOSRAMView.h
//  TaiYiToken
//
//  Created by 张元一 on 2018/12/24.
//  Copyright © 2018 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EOSRAMView : UIView
@property(nonatomic,assign)CGFloat ramtotal;
@property(nonatomic,assign)CGFloat ram;
@property(nonatomic,copy)NSString *eosbalance;
@property(nonatomic,copy)NSString *ramprice;
@property(nonatomic,strong)UILabel *balanceLabel;
@property(nonatomic,strong)UILabel *rampriceLabel;
@property(nonatomic,strong)UILabel *manageTitleLabel;
@property(nonatomic,strong)UIButton *buyBtn;
@property(nonatomic,strong)UIButton *saleBtn;
@property(nonatomic,strong)UITextField *manageTextField;
@property(nonatomic,strong)UITextField *reveiverTextField;
@property(nonatomic,strong)UILabel *amountLabel;
@property(nonatomic,assign)CoinType coinType;

@end

NS_ASSUME_NONNULL_END
