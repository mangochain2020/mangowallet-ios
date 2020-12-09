//
//  DCGridItem.h
//  CDDMall
//
//  Created by apple on 2017/6/6.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "ProListItem.h"

@interface ProList :NSObject
@property (nonatomic , strong) NSArray <ProListItem *>              * list;
@property (nonatomic , assign) NSInteger              part;
@property (nonatomic , copy) NSString              * pic;

@end

@interface Hot :NSObject
@property (nonatomic , strong) NSArray <ProListItem *>              * list;
@property (nonatomic , copy) NSString              * pic;

@end


@interface CateListItem :NSObject
@property (nonatomic , copy) NSString              * cateName;
@property (nonatomic , assign) NSInteger              sort;
@property (nonatomic , copy) NSString              * pic;
@property (nonatomic , copy) NSString              * addTime;
@property (nonatomic , assign) BOOL              isDel;
@property (nonatomic , assign) NSInteger              id;
@property (nonatomic , assign) NSInteger              cateID;

@end


@interface DCHandModel :NSObject
@property (nonatomic , strong) NSArray <NSString *>              * sysSlider;
@property (nonatomic , copy) NSString              * homeImg;
@property (nonatomic , strong) NSArray <ProList *>              * proList;
@property (nonatomic , strong) NSArray <CateListItem *>              * cateList;
@property (nonatomic , strong) Hot             *hot;

@end




