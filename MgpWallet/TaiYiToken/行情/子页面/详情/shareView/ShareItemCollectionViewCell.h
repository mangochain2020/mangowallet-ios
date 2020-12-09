//
//  ShareItemCollectionViewCell.h
//  TaiYiToken
//
//  Created by Frued on 2018/8/31.
//  Copyright © 2018年 Frued. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareItemCollectionViewCell : UICollectionViewCell


@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UILabel *titleLabel;

- (void)setCellRelationDataTitle:(NSString *)title imageTitle:(NSString *)imageName;

@end
