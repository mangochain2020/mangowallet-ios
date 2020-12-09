//
//  WalletManagerCell.m
//  TaiYiToken
//
//  Created by admin on 2018/9/4.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "WalletManagerCell.h"

@implementation WalletManagerCell
-(UILabel *)namelb{
    if (!_namelb) {
        _namelb = [UILabel new];
        _namelb.textColor = [UIColor textWhiteColor];
        _namelb.font = [UIFont boldSystemFontOfSize:18];
        _namelb.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_namelb];
        [_namelb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(26);
            make.top.equalTo(22);
            make.right.equalTo(-30);
            make.height.equalTo(20);
        }];
    }
    return _namelb;
}

-(UIButton *)shortaddressBtn{
    if (!_shortaddressBtn) {
        
        _shortaddressBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        _shortaddressBtn.userInteractionEnabled = YES;
        _shortaddressBtn.titleLabel.textColor = [UIColor textWhiteColor];
        _shortaddressBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        _shortaddressBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        [self.contentView  addSubview:_shortaddressBtn];
        [_shortaddressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(16);
            make.top.equalTo(self.namelb.mas_bottom).equalTo(5);
            make.width.equalTo(90);
            make.height.equalTo(15);
        }];
        UIImageView *iv = [UIImageView new];
        iv.image = [UIImage imageNamed:@"ico_backups"];
        [_shortaddressBtn addSubview:iv];
        [iv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(0);
            make.width.equalTo(8);
            make.height.equalTo(8);
            make.centerY.equalTo(0);
        }];
    }
   
    return _shortaddressBtn;
}

-(UIButton *)deleteBtn{
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        _deleteBtn.userInteractionEnabled = YES;
        _deleteBtn.backgroundColor = [UIColor clearColor];
        _deleteBtn.tintColor = [UIColor whiteColor];
        [_deleteBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [_deleteBtn setImage:[UIImage imageNamed:@"del"] forState:UIControlStateNormal];
        [self.contentView  addSubview:_deleteBtn];
        [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-16);
            make.top.equalTo(16);
            make.width.equalTo(17);
            make.height.equalTo(17);
        }];
    }
    return _deleteBtn;
}



-(UIButton *)addressBtn{
    
    if (!_addressBtn) {
        _addressBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        _addressBtn.userInteractionEnabled = YES;
        _addressBtn.titleLabel.textColor = [UIColor textWhiteColor];
        _addressBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        _addressBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        [self.contentView  addSubview:_addressBtn];
        [_addressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(16);
            make.top.equalTo(self.namelb.mas_bottom).equalTo(5);
            make.width.equalTo(150);
            make.height.equalTo(15);
        }];
        UIImageView *iv = [UIImageView new];
        iv.image = [UIImage imageNamed:@"ico_backups"];
        [_addressBtn addSubview:iv];
        [iv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(0);
            make.width.equalTo(8);
            make.height.equalTo(8);
            make.centerY.equalTo(0);
        }];
    }
    
    return _addressBtn;
}


-(UIButton *)exportBtn{
    if (!_exportBtn) {
        _exportBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        _exportBtn.titleLabel.textColor = [UIColor textWhiteColor];
        _exportBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        _exportBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _exportBtn.userInteractionEnabled = YES;
        [_exportBtn setTitle:NSLocalizedString(@"导出", nil) forState:UIControlStateNormal];
        [self.contentView addSubview:_exportBtn];
        [_exportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(20);
            make.top.equalTo(self.addressBtn.mas_bottom).equalTo(20);
            make.width.equalTo(40);
            make.height.equalTo(20);
        }];
    }
    return _exportBtn;
}
-(UIImageView *)backImageViewLeft{
    if (!_backImageViewLeft) {
        self.contentView.backgroundColor = [UIColor clearColor];
        _backImageViewLeft = [UIImageView new];
        _backImageViewLeft.layer.cornerRadius = 5;
        _backImageViewLeft.layer.masksToBounds = YES;
        [self.contentView addSubview:_backImageViewLeft];
        [_backImageViewLeft mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(0);
        }];
        _backImageViewRight = [UIImageView new];
        [self.contentView addSubview:_backImageViewRight];
        [_backImageViewRight mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(0);
            make.width.equalTo(136);
        }];
    }
    return _backImageViewLeft;
}
@end
