//
//  TwoBtnView.h
//  TaiYiToken
//
//  Created by 张元一 on 2019/3/14.
//  Copyright © 2019 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ToolViewBorderWidth 0.4
NS_ASSUME_NONNULL_BEGIN

@interface HuobiToolView : UIView
//+,-
@property(nonatomic,strong)UIButton *addBtn;
@property(nonatomic,strong)UIButton *subBtn;

-(void)HuobiTwoBtnView;






@end

NS_ASSUME_NONNULL_END
