//
//  LHDAppModel.h
//  TaiYiToken
//
//  Created by mac on 2020/8/11.
//  Copyright © 2020 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LHDAppModel : NSObject

@property (nonatomic , copy) NSString              * tab;
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , copy) NSString              * childTitle;
@property (nonatomic , assign) NSInteger              type;
@property (nonatomic , copy) NSString              * lang;
@property (nonatomic , assign) NSInteger              sort;
@property (nonatomic , assign) BOOL              isDel;

@property (nonatomic , copy) NSString              * img;
@property (nonatomic , copy) NSString              * tabImg;


@end

NS_ASSUME_NONNULL_END
