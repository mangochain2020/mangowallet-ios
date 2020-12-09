//
//  NSObject+Parse.h
//  Day10_PodDemo
//
//  Created by tarena on 16/9/12.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSObject (Parse)<YYModel>
+ (id)parse:(id)json;
@end












