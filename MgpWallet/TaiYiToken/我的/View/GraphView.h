//
//  GraphView.h
//  TaiYiToken
//
//  Created by 张元一 on 2018/12/7.
//  Copyright © 2018 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GraphView : UIView
@property(nonatomic,strong)NSDictionary *dataDic;// 接收数据信息
@property(nonatomic,assign)NSInteger maxvalue;
@property(nonatomic,strong)NSArray *nameArr;
@end

NS_ASSUME_NONNULL_END
