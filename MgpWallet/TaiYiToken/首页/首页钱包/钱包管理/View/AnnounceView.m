//
//  AnnounceView.m
//  TaiYiToken
//
//  Created by admin on 2018/9/5.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "AnnounceView.h"

@implementation AnnounceView

-(void)initAnnounceView{
    self.backgroundColor = [UIColor ExportAnnounceBackgroundColor];
    
    UIImageView *iv = [UIImageView new];
    iv.image = [UIImage imageNamed:@"ico_warming"];
    [self addSubview:iv];
    [iv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(12);
        make.top.equalTo(22);
        make.width.equalTo(23);
        make.height.equalTo(24);
    }];
    
    _textView = [UITextView new];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.font = [UIFont systemFontOfSize:12];
    _textView.textAlignment = NSTextAlignmentLeft;
    _textView.editable = NO;
    [self addSubview:_textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(47);
        make.top.equalTo(22);
        make.right.equalTo(-22);
        make.bottom.equalTo(-22);
    }];
   
    
}

@end
