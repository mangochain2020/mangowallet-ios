//
//  AuthorView.m
//  TaiYiToken
//
//  Created by 张元一 on 2018/12/17.
//  Copyright © 2018 admin. All rights reserved.
//

#import "AuthorView.h"

@implementation AuthorView

//@property(nonatomic,strong)UILabel *keylb;
//@property(nonatomic,strong)UILabel *authoritylb;
//@property(nonatomic,strong)UILabel *weightlb;
-(void)initUI{
    self.backgroundColor = [UIColor whiteColor];
    
    UILabel *namelb = [UILabel new];
    namelb.textColor = [UIColor textBlackColor];
    namelb.font = [UIFont boldSystemFontOfSize:16];
    namelb.textAlignment = NSTextAlignmentLeft;
    namelb.text = _authority;
    [self addSubview:namelb];
    [namelb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.top.equalTo(0);
        make.width.equalTo(100);
        make.height.equalTo(20);
    }];
    
    UILabel *maxweightlb = [UILabel new];
    maxweightlb.textColor = [UIColor textGrayColor];
    maxweightlb.font = [UIFont systemFontOfSize:12];
    maxweightlb.textAlignment = NSTextAlignmentRight;
    maxweightlb.text = NSLocalizedString(@"权重阈值：1", nil);
    [self addSubview:maxweightlb];
    [maxweightlb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-16);
        make.top.equalTo(0);
        make.width.equalTo(200);
        make.height.equalTo(20);
    }];
    
    if (!_backView) {
        _backView = [UIView new];
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.layer.cornerRadius = 5;
        _backView.layer.masksToBounds = YES;
        _backView.layer.borderColor = [UIColor lineGrayColor].CGColor;
        _backView.layer.borderWidth = 0.5;
        [self addSubview:_backView];
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(16);
            make.right.equalTo(-16);
            make.bottom.equalTo(0);
            make.top.equalTo(30);
            
        }];
    }
    
    NSTextAttachment * attach = [[NSTextAttachment alloc] init];
    attach.image = [UIImage imageNamed:@"yhjk"];
    attach.bounds = CGRectMake(0, 0, 10, 10);
    NSAttributedString * imageStr = [NSAttributedString attributedStringWithAttachment:attach];
    
    UILabel *keylb = [UILabel new];
    NSMutableAttributedString * a0 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ", NSLocalizedString(@"公钥", nil)] attributes:@{NSForegroundColorAttributeName:[UIColor textBlackColor], NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    NSMutableAttributedString * a1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@\n", VALIDATE_STRING(_keystr)] attributes:@{NSForegroundColorAttributeName:[UIColor textGrayColor], NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    [a0 appendAttributedString:imageStr];
    [a0 appendAttributedString:a1];
    
    keylb.textColor = [UIColor textBlackColor];
    keylb.font = [UIFont boldSystemFontOfSize:12];
    keylb.textAlignment = NSTextAlignmentLeft;
    keylb.numberOfLines = 0;
    keylb.attributedText = a0;
    [self.backView addSubview:keylb];
    [keylb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.top.equalTo(0);
        make.right.equalTo(-16);
        make.height.equalTo(90);
    }];
    
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor lineGrayColor];
    [self.backView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(90);
        make.height.equalTo(1);
    }];
    
    UILabel *weightlb = [UILabel new];
    NSMutableAttributedString * b0 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n", NSLocalizedString(@"权重", nil)] attributes:@{NSForegroundColorAttributeName:[UIColor textBlackColor], NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    NSMutableAttributedString * b1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld\n", _weight] attributes:@{NSForegroundColorAttributeName:[UIColor textGrayColor], NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    [b0 appendAttributedString:b1];
    weightlb.textColor = [UIColor textBlackColor];
    weightlb.font = [UIFont boldSystemFontOfSize:12];
    weightlb.textAlignment = NSTextAlignmentLeft;
    weightlb.numberOfLines = 0;
    weightlb.attributedText = b0;
    [self.backView addSubview:weightlb];
    [weightlb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.top.equalTo(91);
        make.right.equalTo(-16);
        make.bottom.equalTo(0);
    }];
    
   
}



@end
