//
//  NSString+CheckStringValue.m
//  TaiYiToken
//
//  Created by Frued on 2018/10/18.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "NSString+CheckStringValue.h"

@implementation NSString (CheckStringValue)
#pragma 十进制字符串转换显示

-(NSString *)convertedstr{
    NSString *currentLanguage = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLanguageSelected"];
    if(currentLanguage == nil){
//        currentLanguage = @"english";
        [[NSUserDefaults standardUserDefaults] setObject:@"chinese" forKey:@"CurrentLanguageSelected"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
//    LangeuageType currentLanguageType = [currentLanguage isEqualToString:@"english"]?USD_TYPE:CHY_TYPE;
    
    CGFloat floatvalue = self.floatValue;
    NSString *str1 = [self componentsSeparatedByString:@"."].firstObject;
    if (str1.length < 1) {
        return [NSString stringWithFormat:@"%.4f",floatvalue];
    }else if(str1.length <= 4){
        return [NSString stringWithFormat:@"%.2f",floatvalue];
    }else if(str1.length <= 7){
       // return [NSString stringWithFormat:@"%.1f%@",floatvalue/1000,currentLanguageType == USD_TYPE? NSLocalizedString(@"K", nil):NSLocalizedString(@"千", nil)];
        return [NSString stringWithFormat:@"%.3f%@",floatvalue/1000.0,@"K"];
    }else if(str1.length <= 9){
        return [NSString stringWithFormat:@"%.2f%@",floatvalue/1000000.0,@"M"];
    }else if(str1.length <= 12){
        return [NSString stringWithFormat:@"%.2f%@",floatvalue/1000000000.0,@"B"];
    }else{
        return [NSString stringWithFormat:@"%.2f%@",floatvalue/1000000000000.0,@"T"];
    }
}

#pragma 正则匹配数字
+(BOOL)checkNumber:(NSString *)num{
    NSString *numRegex = @"^[0-9.]{0,100}";
    NSPredicate *numTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numRegex];
    return [numTest evaluateWithObject:num];
}

#pragma 正则匹配邮箱
+(BOOL)checkEmail:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
#pragma 正则匹配手机号
+ (BOOL)checkTelNumber:(NSString *) telNumber {
    NSString *pattern = @"^1+[3578]+\\d{9}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:telNumber];
    return isMatch;
}
#pragma 正则匹配用户密码8-18位数字和字母组合 8位以上任意字符
+ (BOOL)checkPassword:(NSString *) password {
   // NSString *pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{8,18}";
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
//    BOOL isMatch = [pred evaluateWithObject:password];
    BOOL isMatch = password.length > 7 && password.length < 18;
    return isMatch;
}
#pragma 正则匹配用户姓名,20位的中文或英文
+ (BOOL)checkUserName : (NSString *) userName {
    NSString *pattern = @"^[a-z1-5]{6,12}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:userName];
    return isMatch;
}

#pragma 正则匹配EOS
+ (BOOL)checkEOSAccount : (NSString *) userName {
    NSString *pattern = @"^[1-5a-z]{12}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:userName];
    return isMatch;
}

#pragma 正则匹配用户身份证号15或18位
+ (BOOL)checkUserIdCard: (NSString *) idCard {
    NSString *pattern = @"(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:idCard];
    return isMatch;
}
#pragma 正则匹员工号,12位的数字
+ (BOOL)checkEmployeeNumber : (NSString *) number {
    NSString *pattern = @"^[0-9]{12}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:number];
    return isMatch;
}
#pragma 正则匹配URL
+ (BOOL)checkURL : (NSString *) url {
    NSString *pattern = @"^[0-9A-Za-z]{1,50}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:url];
    return isMatch;
}
#pragma 将数字转成货币格式字符串
+ (NSString *)getMoneyStringWithMoneyNumber:(double)money{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    // 设置格式
    [numberFormatter setPositiveFormat:@"###,##0.0000;"];
    NSString *formattedNumberString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:money]];
    return formattedNumberString;
}

@end
