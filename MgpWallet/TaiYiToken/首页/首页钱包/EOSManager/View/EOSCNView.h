//
//  EOSCNView.h
//  TaiYiToken
//
//  Created by 张元一 on 2018/12/19.
//  Copyright © 2018 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EOSCNView : UIView
@property(nonatomic,assign)CGFloat ramtotal;
@property(nonatomic,assign)CGFloat ram;
@property(nonatomic,assign)CGFloat cputotal;
@property(nonatomic,assign)CGFloat cpu;
@property(nonatomic,assign)CGFloat nettotal;
@property(nonatomic,assign)CGFloat net;

@property(nonatomic,strong)UIButton *ramBtn;
@property(nonatomic,strong)UIButton *cnBtn;
@property(nonatomic,assign)CoinType coinType;

@end

NS_ASSUME_NONNULL_END
