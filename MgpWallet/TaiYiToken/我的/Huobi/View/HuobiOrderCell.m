//
//  HuobiOrderCell.m
//  TaiYiToken
//
//  Created by 张元一 on 2019/3/18.
//  Copyright © 2019 admin. All rights reserved.
//

#import "HuobiOrderCell.h"
#define SubViewWidth (ScreenWidth-20)/3.0
#define SubViewHeight 50
@implementation HuobiOrderCell
-(UILabel *)leftlb{
    if (!_leftlb) {
        self.backgroundColor = [UIColor whiteColor];
        _leftlb = [UILabel new];
        _leftlb.textColor = [UIColor textBlackColor];
        _leftlb.font = [UIFont boldSystemFontOfSize:17];
        _leftlb.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_leftlb];
        [_leftlb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(10);
            make.top.equalTo(0);
            make.width.equalTo(150);
            make.height.equalTo(30);
        }];
    }
    return _leftlb;
}

-(UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitleColor:[UIColor appBlueColor] forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor appBlueColor] forState:UIControlStateSelected];
        _cancelBtn.backgroundColor = kRGBA(240, 243, 250, 1.0);
        [_cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:11]];
        [_cancelBtn setTitle:NSLocalizedString(@"撤销", nil) forState:UIControlStateNormal];
        [self.contentView addSubview:_cancelBtn];
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-10);
            make.top.equalTo(5);
            make.width.equalTo(70);
            make.height.equalTo(20);
        }];
    }
    return _cancelBtn;
}

-(HuobiTwolbView *)bottomA{
    if (!_bottomA) {
        _bottomA = [HuobiTwolbView new];
        [_bottomA toplb];
        [_bottomA bottomlb];
        [self.contentView addSubview:_bottomA];
        [_bottomA mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(10);
            make.bottom.equalTo(0);
            make.width.equalTo(SubViewWidth);
            make.height.equalTo(SubViewHeight);
        }];
    }
    return _bottomA;
}

-(HuobiTwolbView *)bottomB{
    if (!_bottomB) {
        _bottomB = [HuobiTwolbView new];
        [_bottomB toplb];
        [_bottomB bottomlb];
        [self.contentView addSubview:_bottomB];
        [_bottomB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(10 + SubViewWidth);
            make.bottom.equalTo(0);
            make.width.equalTo(SubViewWidth);
            make.height.equalTo(SubViewHeight);
        }];
    }
    return _bottomB;
}

-(HuobiTwolbView *)bottomC{
    if (!_bottomC) {
        _bottomC = [HuobiTwolbView new];
        [_bottomC toplb];
        _bottomC.toplb.textAlignment = NSTextAlignmentRight;
        [_bottomC bottomlb];
        _bottomC.bottomlb.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_bottomC];
        [_bottomC mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(10 + 2*SubViewWidth);
            make.bottom.equalTo(0);
            make.width.equalTo(SubViewWidth);
            make.height.equalTo(SubViewHeight);
        }];
    }
    return _bottomC;
}
@end
