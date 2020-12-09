//
//  DCStateItemCell.m
//  CDDStoreDemo
//
//  Created by 陈甸甸 on 2017/12/13.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import "DCStateItemCell.h"
#import "DCStateItem.h"

@interface DCStateItemCell()

@property (weak, nonatomic) IBOutlet UIButton *stateButton;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *stateBgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *pageLabel;

@end

@implementation DCStateItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor whiteColor];
    
}

#pragma mark - 赋值
- (void)setStateItem:(DCStateItem *)stateItem
{
    _stateItem = stateItem;
    
    self.stateBgImageView.backgroundColor = (stateItem.bgColor) ? RGB(240, 240, 240) : [UIColor whiteColor];
    if (stateItem.showImage) {
        [self.stateButton setImage:[UIImage imageNamed:stateItem.imageContent] forState:0];
    }else{
        [self.stateButton setTitle:stateItem.imageContent forState:0];
    }
    _iconImage.image = [UIImage imageNamed:stateItem.imageContent];
    
    self.stateLabel.text = NSLocalizedString(stateItem.stateTitle, nil);;

    self.pageLabel.text = stateItem.num;

    self.pageLabel.hidden = [stateItem.num intValue] <= 0 ? YES : NO;
    
}


@end
