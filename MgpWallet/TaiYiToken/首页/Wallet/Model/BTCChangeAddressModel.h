//
//  BTCChangeAddressModel.h
//  TaiYiToken
//
//  Created by 张元一 on 2018/11/5.
//  Copyright © 2018 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTCChangeAddressModel : NSObject

//钱包主地址
@property(nonatomic,strong)NSString *walletaddress;
@property(nonatomic,strong)NSString *privatekey;
@property(nonatomic,strong)NSString *publickey;
//找零地址
@property(nonatomic,strong)NSString *changeaddress;
//找零地址索引
@property(nonatomic,assign)NSInteger index;
//找零地址状态
@property(nonatomic,assign)NSInteger changeaddressstatus;
@end

NS_ASSUME_NONNULL_END
