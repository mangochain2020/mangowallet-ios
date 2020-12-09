//
//  NSString+URLString.m
//  AdMoProduct
//
//  Created by Frued on 2018/7/27.
//  Copyright © 2018年 Frued. All rights reserved.
//

#import "NSString+URLString.h"

@implementation NSString (URLString)
- (NSURL *)STR_URLString{
    return [NSURL URLWithString:self];
}


// Base64编码方法2
- (NSString *)base64EncodingString {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    return [data base64EncodedStringWithOptions:0];;
}

// Base64解码方法2
- (NSString *)base64DecodingString {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:self options:0];
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
