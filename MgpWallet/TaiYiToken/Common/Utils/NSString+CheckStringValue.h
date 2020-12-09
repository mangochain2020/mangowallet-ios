//
//  NSString+CheckStringValue.h
//  TaiYiToken
//
//  Created by Frued on 2018/10/18.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (CheckStringValue)
#pragma 十进制字符串转换显示
-(NSString *)convertedstr;
#pragma 正则匹配数字
+(BOOL)checkNumber:(NSString *)num;
#pragma 正则匹配邮箱
+(BOOL)checkEmail:(NSString *)email;
#pragma 正则匹配手机号
+ (BOOL)checkTelNumber:(NSString *) telNumber;
#pragma 正则匹配用户密码8-18位数字和字母组合
+ (BOOL)checkPassword:(NSString *) password;
#pragma 正则匹配用户姓名,20位的中文或英文
+ (BOOL)checkUserName : (NSString *) userName;
#pragma 正则匹配用户身份证号
+ (BOOL)checkUserIdCard: (NSString *) idCard;
#pragma 正则匹配URL
+ (BOOL)checkURL : (NSString *) url;
#pragma 正则匹配EOS
+ (BOOL)checkEOSAccount : (NSString *) userName;
#pragma 将数字转成货币格式字符串
+ (NSString *)getMoneyStringWithMoneyNumber:(double)money;

@end

NS_ASSUME_NONNULL_END
