//
//  NSError+MisError.m
//  TaiYiToken
//
//  Created by 张元一 on 2018/11/7.
//  Copyright © 2018 admin. All rights reserved.
//

#import "NSError+MisError.h"

@implementation NSError (MisError)
+(NSError *)ErrorWithTitle:(NSString *)descstr Code:(NSInteger)errcode{
    NSString *domain = @"";
    NSString *desc = NSLocalizedString(descstr, nil);
    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : desc };
    NSError *error = [NSError errorWithDomain:domain
                                         code:errcode
                                     userInfo:userInfo];
    return error;
}



@end
