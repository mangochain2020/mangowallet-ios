//
//  LHRecordTableViewController.h
//  TaiYiToken
//
//  Created by mac on 2020/10/10.
//  Copyright © 2020 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
//定义枚举类型
typedef enum _NewLHPayOperationType {
    def  = 0,//默认普通交易
    appStoreLifeOrderList,// 本地生活交易记录
  

} LHPayOperationType;



NS_ASSUME_NONNULL_BEGIN

@interface LHRecordTableViewController : UITableViewController

@property (nonatomic,assign) LHPayOperationType type; //操作类型

@end

NS_ASSUME_NONNULL_END
