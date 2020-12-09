//
//  WalletDetailView.h
//  TaiYiToken
//
//  Created by Frued on 2018/10/22.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WalletDetailView : UIView
@property(nonatomic,strong)UIImageView *iconImageView;
@property(nonatomic,strong)UILabel *symbolNamelb;//MIS
@property(nonatomic,strong)UILabel *symboldetaillb;//mistoken
@property(nonatomic,strong)UIButton *addressBtn;//0x88DS73214...7f4B5Y468
@property(nonatomic,strong)UILabel *amountlb;//0.02
@property(nonatomic,strong)UILabel *balancelb;//0.02
@property(nonatomic,strong)UITextView *infotextView;
@property(nonatomic,assign)WALLET_TYPE wallettype;
@property(nonatomic,assign)CoinType cointype;
@end

NS_ASSUME_NONNULL_END
