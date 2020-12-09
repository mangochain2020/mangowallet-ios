//
//  AuthorView.h
//  TaiYiToken
//
//  Created by 张元一 on 2018/12/17.
//  Copyright © 2018 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AuthorView : UIView
@property(nonatomic,copy)NSString *keystr;
@property(nonatomic,copy)NSString *authority;
@property(nonatomic,assign)NSInteger weight;

@property(nonatomic,strong)UIView *backView;
-(void)initUI;
@end

NS_ASSUME_NONNULL_END
