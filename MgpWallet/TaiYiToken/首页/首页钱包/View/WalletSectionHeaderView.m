//
//  WalletSectionHeaderView.m
//  TaiYiToken
//
//  Created by 张元一 on 2018/11/9.
//  Copyright © 2018 admin. All rights reserved.
//

#import "WalletSectionHeaderView.h"

@implementation WalletSectionHeaderView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        self.backgroundColor = [UIColor colorWithHexString:@"#F8F8FF"];
    }
    return self;
}
-(UILabel *)remindlb{
    if (_remindlb == nil) {
        
        _remindlb = [UILabel new];
        _remindlb.textColor = [UIColor textGrayColor];
        _remindlb.font = [UIFont boldSystemFontOfSize:12];
        _remindlb.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_remindlb];
        [_remindlb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(20);
            make.centerY.equalTo(0);
            make.right.equalTo(-20);
            make.height.equalTo(20);
        }];
    }
    return _remindlb;
}
@end
