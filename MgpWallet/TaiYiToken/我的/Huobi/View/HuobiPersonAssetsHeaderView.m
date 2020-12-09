//
//  HuobiPersonAssetsHeaderView.m
//  TaiYiToken
//
//  Created by 张元一 on 2019/3/20.
//  Copyright © 2019 admin. All rights reserved.
//

#import "HuobiPersonAssetsHeaderView.h"

@implementation HuobiPersonAssetsHeaderView
-(UILabel *)toplb{
    if (!_toplb) {
        _backView = [UIView new];
        _backView.backgroundColor = kRGBA(59, 130, 208, 1);
        [self addSubview:_backView];
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
        
        
        _toplb = [UILabel new];
        _toplb.textColor = [UIColor lightGrayColor];
        _toplb.font = [UIFont boldSystemFontOfSize:15];
        NSMutableAttributedString *text1 = [[NSMutableAttributedString alloc]initWithString:NSLocalizedString(@"币币账号", nil)];
        NSMutableAttributedString *text2 = [[NSMutableAttributedString alloc]initWithString:NSLocalizedString(@"总资产整合(BTC)", nil)];
        [text1 addAttribute:NSFontAttributeName
                      value:[UIFont boldSystemFontOfSize:17]
                      range:NSMakeRange(0, text1.length)];
        [text1 addAttribute:NSForegroundColorAttributeName
                      value:[UIColor whiteColor]
                      range:NSMakeRange(0, text1.length)];
        
        [text2 addAttribute:NSFontAttributeName
                      value:[UIFont systemFontOfSize:12]
                      range:NSMakeRange(0, text2.length)];
        [text2 addAttribute:NSForegroundColorAttributeName
                      value:[UIColor whiteColor]
                      range:NSMakeRange(0, text2.length)];
        [text1 appendAttributedString:text2];
        [_toplb setAttributedText:text1];
        _toplb.textAlignment = NSTextAlignmentLeft;
        [_backView addSubview:_toplb];
        [_toplb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(20);
            make.top.equalTo(40);
            make.right.equalTo(0);
            make.height.equalTo(20);
        }];
    }
    return _toplb;
}

-(UILabel *)meduimlb{
    if (!_meduimlb) {
        _meduimlb = [UILabel new];
        _meduimlb.textColor = [UIColor whiteColor];
        _meduimlb.font = [UIFont boldSystemFontOfSize:20];
        _meduimlb.textAlignment = NSTextAlignmentLeft;
        [_backView addSubview:_meduimlb];
        [_meduimlb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(20);
            make.top.equalTo(60);
            make.right.equalTo(0);
            make.height.equalTo(40);
        }];
    }
    return _meduimlb;
}

-(UILabel *)bottomlb{
    if (!_bottomlb) {
        _bottomlb = [UILabel new];
        _bottomlb.textColor = [UIColor whiteColor];
        _bottomlb.font = [UIFont systemFontOfSize:11];
        _bottomlb.textAlignment = NSTextAlignmentLeft;
        [_backView addSubview:_bottomlb];
        [_bottomlb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(20);
            make.top.equalTo(100);
            make.right.equalTo(0);
            make.height.equalTo(20);
        }];
    }
    return _bottomlb;
}

-(UIButton *)hideBtn{
    if (!_hideBtn) {
        _hideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _hideBtn.imageEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8);
        [_hideBtn setImage:[UIImage imageNamed:@"show"] forState:UIControlStateNormal];
        [_hideBtn setImage:[UIImage imageNamed:@"hide"] forState:UIControlStateSelected];
        [_backView addSubview:_hideBtn];
        [_hideBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-10);
            make.top.equalTo(5);
            make.width.equalTo(40);
            make.height.equalTo(40);
        }];
    }
    return _hideBtn;
}

-(UISearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
        _searchBar.barStyle = UISearchBarStyleDefault;
        _searchBar.translucent = YES;
        _searchBar.tintColor = [UIColor grayColor];
        _searchBar.barTintColor = [UIColor whiteColor];
        [_searchBar setPlaceholder:NSLocalizedString(@"搜索币种", nil)];
        [self addSubview:_searchBar];
        [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(15);
            make.height.equalTo(40);
            make.left.equalTo(0);
            make.right.equalTo(0);
        }];
    }
    return _searchBar;
}

@end
