//
//  CurrentNodes.h
//  TaiYiToken
//
//  Created by Frued on 2018/10/23.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CurrentNodes : NSObject
@property (nonatomic, strong) NSString * nodeBtc;
@property (nonatomic, strong) NSString * nodeEos;
@property (nonatomic, strong) NSString * nodeEth;
@property (nonatomic, strong) NSString * nodeMis;
@property (nonatomic, strong) NSString * nodeMgp;

-(void)datacheck;
@end

NS_ASSUME_NONNULL_END
