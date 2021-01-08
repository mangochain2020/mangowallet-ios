//
//  OverTheCounterTitleView.h
//  TaiYiToken
//
//  Created by mac on 2021/1/4.
//  Copyright © 2021 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OverTheCounterTitleView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLabelL;
@property (weak, nonatomic) IBOutlet UILabel *titleLabelR;


@property (weak, nonatomic) IBOutlet UILabel *subTitleLabelL;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabelR;

@property (weak, nonatomic) IBOutlet UIImageView *rightIamge;

@end

NS_ASSUME_NONNULL_END
