//
//  EOSTranDetail.h
//  TaiYiToken
//
//  Created by Frued on 2018/10/24.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EOSTranDetailView : UIView
@property(nonatomic,strong)UILabel *titlelb;
@property(nonatomic,strong)UILabel *amountlb;
@property(nonatomic,strong)UILabel *infolb;
@property(nonatomic,strong)UILabel *fromlb;
@property(nonatomic,strong)UILabel *tolb;
@property(nonatomic,strong)UIButton *closeBtn;
@property(nonatomic,strong)UIButton *nextBtn;

@property(nonatomic,strong)UITextField *passTextField;

@end

NS_ASSUME_NONNULL_END
