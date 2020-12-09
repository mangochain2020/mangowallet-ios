//
//  ExportWalletCell.m
//  TaiYiToken
//
//  Created by admin on 2018/9/4.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "ExportWalletCell.h"

@implementation ExportWalletCell
-(UILabel *)namelb{
    if (!_namelb) {
        _namelb = [UILabel new];
        _namelb.textColor = [UIColor textDarkColor];
        _namelb.font = [UIFont boldSystemFontOfSize:15];
        _namelb.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_namelb];
        [_namelb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(57);
            make.centerY.equalTo(0);
            make.right.equalTo(-30);
            make.height.equalTo(20);
        }];
    }
    return _namelb;
}

-(UIImageView *)imageViewLeft{
    if (!_imageViewLeft) {
        self.contentView.backgroundColor = [UIColor clearColor];
        _imageViewLeft = [UIImageView new];
        [self.contentView addSubview:_imageViewLeft];
        [_imageViewLeft mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(26);
            make.centerY.equalTo(0);
            make.width.equalTo(19);
            make.height.equalTo(19);
        }];
    }
    return _imageViewLeft;
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
