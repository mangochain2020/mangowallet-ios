//
//  UIColor+AppConfigColor.m
//  Giivv
//
//  Created by Xiong, Zijun on 16/4/16.
//  Copyright © 2016 Youdar . All rights reserved.
//

#import "UIColor+AppConfigColor.h"

@implementation UIColor (AppConfigColor)

#pragma mark - The default view background
+(UIColor *)viewBackgroundColor{
    return HEX_RGB(0xf5f6f7);
}

+(UIColor *)backgroundGrayColor{
//    return HEX_RGB(0xe6e6e6);
    return RGB(240, 241, 241);
}

#pragma mark - app blue color
+(UIColor *)appBlueColor{
    return RGB(27, 191, 247);
//    return HEX_RGB(0x46c9f7);
}

#pragma mark - app yellow color
+(UIColor *)appYellowColor{
    return HEX_RGB(0xf88d38);
}

#pragma mark - app green color

+(UIColor *)appGreenColor{
//    return RGB(0, 221, 140);
    return HEX_RGB(0x46c9f7);
}

+(UIColor *)darkappGreenColor{
    //    return RGB(0, 221, 140);
//    return HEX_RGB(0x26c9b7);
    return RGB(76, 169, 144);
}

+(UIColor *)darkappRedColor{
    //    return RGB(0, 221, 140);
    return RGB(211, 114, 78);
}

#pragma mark - app green color
+(UIColor *)appGoldColor{
    return HEX_RGB(0xece000);
}

#pragma mark - app alpha white color
+(UIColor *)appAlphaWhiteColor{
    return [[UIColor alloc] initWithWhite: 1.0 alpha: 0.2f];
}

#pragma mark - theme color
+(UIColor *)themeColor{
    return HEX_RGB(0x00d79d);
}

#pragma mark - The default font black
+(UIColor *)textBlackColor{
    return HEX_RGB(0x4f5051);
}

#pragma mark - The default font light black
+(UIColor *)textLightBlackColor{
    return HEX_RGB(0x686868);
}

#pragma mark - The default font gray
+(UIColor *)textGrayColor{
    return HEX_RGB(0xa9a9a9);
    
    
}
// 黑色, 0.3 alpha
+(UIColor *)textBlackColorWithAlpha3{
    return kRGBA(0, 0, 0, 0.3);
    
}


+(UIColor *)textOrangeColor{
    return HEX_RGB(0xff9c00);
}


#pragma mark - The default font light gray
+(UIColor *)textLightGrayColor{
   // return HEX_RGB(0xafb0b1);
    return RGB(199, 199, 200);
}

#pragma mark - 白色字体
+(UIColor *)textWhiteColor{
    return [[UIColor alloc] initWithWhite: 1.0f alpha: 0.9f];
}

+ (UIColor *)textGreenColor{
    return RGB(0, 221, 140);
//   return RGB(71, 201, 246);
    
}

+ (UIColor *)textDarkColor{
    //    return RGB(0, 221, 140);
    return [UIColor colorWithHexString:@"#2B3041"];
}


+ (UIColor *)textBlueColor{
    return RGB(71, 170, 256);
}

+ (UIColor *)backBlueColorA{
    return RGB(200, 200, 256);
}
+ (UIColor *)backBlueColorB{
    return RGB(190, 170, 256);
}
+ (UIColor *)darkBlueColor{
    return RGB(160, 140, 216);
}

+ (UIColor *)huobilightbgColor{
    return RGB(245, 245, 250);
}
#pragma mark - The default line gray color
+ (UIColor *)lineGrayColor{
    return HEX_RGB(0xE0E0E0);
}

+ (UIColor *)ExportBackgroundColor{
   return [UIColor colorWithHexString:@"#F8F8F8"];
}
+ (UIColor *)ExportAnnounceBackgroundColor{
    return [UIColor colorWithHexString:@"#FFFBED"];
}


@end
