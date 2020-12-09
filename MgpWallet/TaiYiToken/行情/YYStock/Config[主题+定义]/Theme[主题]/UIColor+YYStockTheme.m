/*
 作者：  WillkYang
 文件：  UIColor+YYStockTheme.m
 版本：  1.0 <2016.10.05>
 */

#import "UIColor+YYStockTheme.h"

@implementation UIColor (YYStockTheme)

//+ (UIColor *)colorWithHex:(UInt32)hex {
//    return [UIColor colorWithHex:hex alpha:1.f];
//}

+ (UIColor *)colorWithHex:(UInt32)hex alpha:(CGFloat)alpha {
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:alpha];
}

/************************************K线颜色配置***************************************/

/**
 *  整体背景颜色
 */
+(UIColor *)YYStock_bgColor {
    return [UIColor colorWithRGBHex:0xffffff];
}

/**
 *  K线图背景辅助线颜色
 */
+(UIColor *)YYStock_bgLineColor {
    return [UIColor colorWithRGBHex:0xEDEDED];
}

/**
 *  主文字颜色
 */
+(UIColor *)YYStock_textColor {
    return [UIColor colorWithRGBHex:0xAFAFB3];
}


/**
 *  MA5线颜色
 */
+(UIColor *)YYStock_MA5LineColor {
    return [UIColor colorWithRGBHex:0xFEB911];
}

/**
 *  MA10线颜色
 */
+(UIColor *)YYStock_MA10LineColor {
    return [UIColor colorWithRGBHex:0x60CFFF];
}

/**
 *  MA20线颜色
 */
+(UIColor *)YYStock_MA20LineColor {
    return [UIColor colorWithRGBHex:0xF184F5];
}

/**
 *  长按线颜色
 */
+(UIColor *)YYStock_selectedLineColor {
    return [UIColor colorWithRGBHex:0xACAAA9];
}

/**
 *  长按出现的圆点的颜色
 */
+(UIColor *)YYStock_selectedPointColor {
    return [UIColor YYStock_increaseColor                                                                                  ];
}

/**
 *  长按出现的方块背景颜色
 */
+(UIColor *)YYStock_selectedRectBgColor {
    return [UIColor colorWithRGBHex:0x659EE0];
}

/**
 *  长按出现的方块文字颜色
 */
+(UIColor *)YYStock_selectedRectTextColor {
    return [UIColor colorWithRGBHex:0xffffff];
}

/**
 *  分时线颜色
 */
+(UIColor *)YYStock_TimeLineColor {
    return [UIColor colorWithRGBHex:0x60CFFF];
}

/**
 *  分时均线颜色
 */
+(UIColor *)YYStock_averageTimeLineColor {
    return [UIColor colorWithRGBHex:0x60CFFF];
}

/**
 *  分时线下方背景色
 */
+(UIColor *)YYStock_timeLineBgColor {
    return [UIColor colorWithHex:0x60CFFF alpha:0.1f];
}

/**
 *  涨的颜色
 */
+(UIColor *)YYStock_increaseColor {
    BOOL colorConfig = [[NSUserDefaults standardUserDefaults] boolForKey:@"RiseColorConfig"];
    if (colorConfig == YES) {
        return BTNFALLCOLOR;
    }else{
        return BTNRISECOLOR;
    }
//    return [UIColor colorWithRGBHex:0xE74C3C];
}

/**
 *  跌的颜色
 */
+(UIColor *)YYStock_decreaseColor {
    BOOL colorConfig = [[NSUserDefaults standardUserDefaults] boolForKey:@"RiseColorConfig"];
    if (colorConfig == YES) {
        return BTNRISECOLOR;
    }else{
        return BTNFALLCOLOR;
    }
   // return [UIColor colorWithRGBHex:0x41CB47];
}

/************************************TopBar颜色配置***************************************/

/**
 *  顶部TopBar文字默认颜色
 */
+(UIColor *)YYStock_topBarNormalTextColor {
    return RGB(255, 180, 180);
}

/**
 *  顶部TopBar文字选中颜色
 */
+(UIColor *)YYStock_topBarSelectedTextColor {
    return RGB(100, 100, 100);
}

/**
 *  顶部TopBar选中块辅助线颜色
 */
+(UIColor *)YYStock_topBarSelectedLineColor {
    return RGB(190, 190, 190);
}

@end
