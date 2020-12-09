//
//  EOSProView.m
//  TaiYiToken
//
//  Created by 张元一 on 2018/12/19.
//  Copyright © 2018 admin. All rights reserved.
//

#import "EOSProView.h"
#define RectIconWidth 11

@implementation EOSProView

-(void)drawRect:(CGRect)rect{
    UIFont *font = [UIFont systemFontOfSize:13];
    
    NSString *texttotal = [NSString stringWithFormat:@"%@ %.4f %@",NSLocalizedString(@"总资产", nil),_total,self.coinType == EOS ? @"EOS" : @"MGP"];
    CGFloat width = [texttotal sizeWithAttributes:@{NSFontAttributeName:font}].width;
    [texttotal drawInRect:CGRectMake(ScreenWidth/2 - width/2, rect.origin.y, width, 15) withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor textBlackColor]}];
    
    [kRGBA(122, 197, 254, 1) setFill];
    UIRectFill(CGRectMake(rect.origin.x+15, rect.origin.y + 32, RectIconWidth, RectIconWidth));

    [kRGBA(37, 99, 180, 1) setFill];
    UIRectFill(CGRectMake(rect.origin.x+15, rect.origin.y + 62, RectIconWidth, RectIconWidth));

    [kRGBA(62, 143, 251, 1) setFill];
    UIRectFill(CGRectMake(rect.origin.x+15, rect.origin.y + 92, RectIconWidth, RectIconWidth));
    
   
    NSString *text = NSLocalizedString(@"余额", nil);
    [text drawInRect:CGRectMake(rect.origin.x+30, rect.origin.y + 30, 100, 15) withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor textBlackColor]}];
    NSString *text1 = NSLocalizedString(@"赎回", nil);
    [text1 drawInRect:CGRectMake(rect.origin.x+30, rect.origin.y + 60, 100, 15) withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor textBlackColor]}];
    NSString *text2 = NSLocalizedString(@"抵押", nil);
    [text2 drawInRect:CGRectMake(rect.origin.x+30, rect.origin.y + 90, 100, 15) withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor textBlackColor]}];

    NSString *text00 = [NSString stringWithFormat:@"%.4f %@",_balance,self.coinType == EOS ? @"EOS" : @"MGP"];
    [text00 drawInRect:CGRectMake(ScreenWidth - [text00 sizeWithAttributes:@{NSFontAttributeName:font}].width - 10, rect.origin.y + 30, text00.length * 12, 15) withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor textBlackColor]}];
    NSString *text01 = [NSString stringWithFormat:@"%.4f %@",_reclaiming,self.coinType == EOS ? @"EOS" : @"MGP"];
    [text01 drawInRect:CGRectMake(ScreenWidth - [text01 sizeWithAttributes:@{NSFontAttributeName:font}].width - 10, rect.origin.y + 60, text00.length * 12, 15) withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor textBlackColor]}];
    NSString *text02 = [NSString stringWithFormat:@"%.4f %@",_staked,self.coinType == EOS ? @"EOS" : @"MGP"];
    [text02 drawInRect:CGRectMake(ScreenWidth - [text02 sizeWithAttributes:@{NSFontAttributeName:font}].width - 10, rect.origin.y + 90, text00.length * 12, 15) withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor textBlackColor]}];
}
@end
