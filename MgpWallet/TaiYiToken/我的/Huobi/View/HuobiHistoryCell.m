//
//  HuobiHistoryCell.m
//  TaiYiToken
//
//  Created by 张元一 on 2019/3/18.
//  Copyright © 2019 admin. All rights reserved.
//

#import "HuobiHistoryCell.h"
#define SubViewWidth (ScreenWidth-20)/3.0
#define SubViewHeight 50
//110
@implementation HuobiHistoryCell
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

-(UILabel *)rightlb{
    if (!_rightlb) {
        _rightlb = [UILabel new];
        _rightlb.textColor = [UIColor textGrayColor];
        _rightlb.font = [UIFont systemFontOfSize:13];
        _rightlb.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_rightlb];
        [_rightlb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-10);
            make.top.equalTo(0);
            make.width.equalTo(100);
            make.height.equalTo(30);
        }];
    }
    return _rightlb;
}


-(HuobiTwolbView *)topA{
    if (!_topA) {
        _topA = [HuobiTwolbView new];
        [_topA toplb];
        [_topA bottomlb];
        [self.contentView addSubview:_topA];
        [_topA mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(10);
            make.top.equalTo(40);
            make.width.equalTo(SubViewWidth);
            make.height.equalTo(SubViewHeight);
        }];
    }
    return _topA;
}

-(HuobiTwolbView *)topB{
    if (!_topB) {
        _topB = [HuobiTwolbView new];
        [_topB toplb];
        [_topB bottomlb];
        [self.contentView addSubview:_topB];
        [_topB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(10 + SubViewWidth);
            make.top.equalTo(40);
            make.width.equalTo(SubViewWidth);
            make.height.equalTo(SubViewHeight);
        }];
    }
    return _topB;
}

-(HuobiTwolbView *)topC{
    if (!_topC) {
        _topC = [HuobiTwolbView new];
        [_topC toplb];
        [_topC bottomlb];
        _topC.toplb.textAlignment = NSTextAlignmentRight;
        _topC.bottomlb.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_topC];
        [_topC mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(10 + 2*SubViewWidth);
            make.top.equalTo(40);
            make.width.equalTo(SubViewWidth);
            make.height.equalTo(SubViewHeight);
        }];
    }
    return _topC;
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
