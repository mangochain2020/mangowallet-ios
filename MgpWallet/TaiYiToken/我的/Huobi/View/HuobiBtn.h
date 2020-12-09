//
//  HuobiBtn.h
//  TaiYiToken
//
//  Created by 张元一 on 2019/3/14.
//  Copyright © 2019 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HuobiBtn : UIButton
//登录，买入 卖出
+(UIButton *)HuobiTypeOneBtnBGColor:(BOOL)isGreen isOperationBtn:(BOOL)isOperBtn Title:(NSString *)title;
//深度
+(UIButton *)HuobiTypeTwoBtn;
//买盘卖盘
+(UIButton *)HuobiTypeThreeBtn;
//个人资产
+(UIButton *)HuobiMyAssetsBtn;
//取消授权
+(UIButton *)HuobiUnAuthBtn;
@end

NS_ASSUME_NONNULL_END
