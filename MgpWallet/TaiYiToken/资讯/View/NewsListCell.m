//
//  NewsListCell.m
//  TaiYiToken
//
//  Created by 张元一 on 2019/4/1.
//  Copyright © 2019 admin. All rights reserved.
//

#import "NewsListCell.h"

@implementation NewsListCell
/*
 @property(nonatomic,strong)UILabel *titlelb;
 @property(nonatomic,strong)UILabel *contentlb;
 @property(nonatomic,strong)UILabel *timelb;
 @property(nonatomic,strong)UIImageView *imageView;
 */
-(UILabel *)titlelb{
    if (!_titlelb) {
        self.backgroundColor = [UIColor whiteColor];
        _titlelb = [UILabel new];
        _titlelb.textColor = [UIColor textBlackColor];
        _titlelb.font = [UIFont systemFontOfSize:14];
        _titlelb.textAlignment = NSTextAlignmentLeft;
        _titlelb.numberOfLines = 2;
        [self.contentView addSubview:_titlelb];
        [_titlelb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(10);
            make.right.equalTo(-10);
            make.top.equalTo(5);
            make.height.equalTo(30);
        }];
    }
    return _titlelb;
}

-(UILabel *)contentlb{
    if (!_contentlb) {
        _contentlb = [UILabel new];
        _contentlb.textColor = [UIColor lightGrayColor];
        _contentlb.font = [UIFont systemFontOfSize:11];
        _contentlb.textAlignment = NSTextAlignmentRight;
        _contentlb.numberOfLines = 0;
        [self.contentView addSubview:_contentlb];
        [_contentlb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(10);
            make.top.equalTo(self.titlelb.mas_bottom).equalTo(5);
            make.width.equalTo(200);
            make.bottom.equalTo(-20);
        }];
    }
    return _contentlb;
}


-(UILabel *)timelb{
    if (!_timelb) {
        _timelb = [UILabel new];
        _timelb.textColor = [UIColor lightGrayColor];
        _timelb.font = [UIFont systemFontOfSize:13];
        _timelb.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_timelb];
        [_timelb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(40);
            make.height.equalTo(20);
            make.width.equalTo(200);
            make.bottom.equalTo(0);
        }];
    }
    return _timelb;
}

-(UIImageView *)cellImageView{
    if (!_cellImageView) {
        _cellImageView = [UIImageView new];
        _cellImageView.backgroundColor = [UIColor whiteColor];
        _cellImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_cellImageView];
        [_cellImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-10);
            make.top.equalTo(self.titlelb.mas_bottom).equalTo(0);
            make.left.equalTo(self.contentlb.mas_right).equalTo(10);
            make.bottom.equalTo(-20);
        }];
    }
    return _cellImageView;
}

-(UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
        _iconImageView.backgroundColor = [UIColor whiteColor];
        _iconImageView.layer.cornerRadius = 8;
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_iconImageView];
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(10);
            make.height.equalTo(16);
            make.width.equalTo(16);
            make.bottom.equalTo(-2);
        }];
    }
    return _iconImageView;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.multipleSelectionBackgroundView = [UIView new];
        
        self.tintColor = [UIColor redColor];
        
    }
    return self;
}


-(void)layoutSubviews
{
    for (UIControl *control in self.subviews){
        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
            for (UIView *v in control.subviews)
            {
                if ([v isKindOfClass: [UIImageView class]]) {
                    UIImageView *img=(UIImageView *)v;
                    if (self.selected) {
                        img.image=[UIImage imageNamed:@"xuanzhong_icon"];
                    }else
                    {
                        img.image=[UIImage imageNamed:@"weixuanzhong_icon"];
                    }
                }
            }
        }
    }
    [super layoutSubviews];
}


//适配第一次图片为空的情况
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    for (UIControl *control in self.subviews){
        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
            for (UIView *v in control.subviews)
            {
                if ([v isKindOfClass: [UIImageView class]]) {
                    UIImageView *img=(UIImageView *)v;
                    if (!self.selected) {
                        img.image=[UIImage imageNamed:@"weixuanzhong_icon"];
                    }
                }
            }
        }
    }
    
}

@end
