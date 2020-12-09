//
//  DataPointView.h
//  TaiYiToken
//
//  Created by Frued on 2018/8/20.
//  Copyright © 2018年 Frued. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataPointView : UIView
@property(nonatomic)UILabel *highLabel;
@property(nonatomic)UILabel *lowLabel;
@property(nonatomic)UILabel *openLabel;
@property(nonatomic)UILabel *closeLabel;
@property(nonatomic)UILabel *volumeLabel;

-(void)initDataPointView;
@end
