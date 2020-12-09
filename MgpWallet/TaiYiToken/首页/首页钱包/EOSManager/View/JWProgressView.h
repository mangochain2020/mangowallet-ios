//
//  JWProgressView.h
//  TaiYiToken
//
//  Created by 张元一 on 2018/12/19.
//  Copyright © 2018 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JWProgressView;

@protocol JWProgressViewDelegate <NSObject>

-(void)progressViewOver:(JWProgressView *)progressView;

@end

@interface JWProgressView : UIView

//进度值0-1.0之间
@property (nonatomic,assign)CGFloat stakeValue;
@property (nonatomic,assign)CGFloat reclaimingValue;

//内部label文字
@property(nonatomic,strong)NSString *contentText;

//value等于1的时候的代理
@property(nonatomic,weak)id<JWProgressViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
