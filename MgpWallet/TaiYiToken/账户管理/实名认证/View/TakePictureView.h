//
//  TakePictureView.h
//  TaiYiToken
//
//  Created by Frued on 2018/10/19.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TakePictureView : UIView
@property(nonatomic,strong)UILabel *titlelabel;
@property(nonatomic,strong)UILabel *detaillabel;
@property(nonatomic,strong)UIButton *photoBtn;
@property(nonatomic,strong)UIImage *image;
@property(nonatomic,copy)NSString *imagebase64;
@end

NS_ASSUME_NONNULL_END
