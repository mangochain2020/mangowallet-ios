//
//  NSString+URLString.h
//  AdMoProduct
//
//  Created by Frued on 2018/7/27.
//  Copyright © 2018年 Frued. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URLString)
- (NSURL *)STR_URLString;

// Base64编码方法2
- (NSString *)base64EncodingString;

// Base64解码方法2
- (NSString *)base64DecodingString;


@end
