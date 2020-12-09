//
//  EOSProView.h
//  TaiYiToken
//
//  Created by 张元一 on 2018/12/19.
//  Copyright © 2018 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EOSProView : UIView
@property(nonatomic,assign)CGFloat total;
@property(nonatomic,assign)CGFloat balance;
@property(nonatomic,assign)CGFloat staked;
@property(nonatomic,assign)CGFloat reclaiming;

@property(nonatomic,assign)CoinType coinType;


@end

NS_ASSUME_NONNULL_END
