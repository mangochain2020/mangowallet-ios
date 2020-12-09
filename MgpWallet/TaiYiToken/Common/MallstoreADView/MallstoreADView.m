//
//  MallstoreADView.m
//  TaiYiToken
//
//  Created by mac on 2020/9/16.
//  Copyright © 2020 admin. All rights reserved.
//

#import "MallstoreADView.h"
#import "HomeWalletViewController.h"
#import "DCGoodDetailViewController.h"

#define kADViewHeight 405/667.0 * [UIScreen mainScreen].bounds.size.height
#define kADViewWidth 320/375.0 * [UIScreen mainScreen].bounds.size.width

#define kADHeight 335/667.0 * [UIScreen mainScreen].bounds.size.height
#define kADWidth 300/375.0 * [UIScreen mainScreen].bounds.size.width

#define kOffsetY 0//广告插件离Y轴中心的偏移量


@interface MallstoreADView()

@property (weak, nonatomic) IBOutlet UIView *bgAdView;

@property (weak, nonatomic) IBOutlet SDCycleScrollView *cycleScrollView;
@property (weak, nonatomic) IBOutlet UILabel *nameDesLabel;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *storePriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;

@property(strong, nonatomic) UIButton *goNextButton;

/**
 是否需要动画显示和隐藏（动画方向为从上往下）
 */
@property(assign, nonatomic) BOOL animated;

@end

@implementation MallstoreADView
- (void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];;
    
    self.nameDesLabel.text = NSLocalizedString(@"给你分享了", nil);
    self.desLabel.text = NSLocalizedString(@"这不是我复制的口令，点击下方取消按钮", nil);
    [self.button setTitle:NSLocalizedString(@"查看详情", nil) forState:UIControlStateNormal];
    
}

- (void)setModel:(ProListItem *)model{
    _model = model;
    
    self.storeNameLabel.text = [NSString stringWithFormat:@"%@ %@",model.storeName,model.storeInfo];
    self.storePriceLabel.text = [NSString stringWithFormat:@"%@%.2f",[CreateAll GetCurrentCurrency].symbol,([[CreateAll GetCurrentCurrency].price doubleValue] * model.price)];
    self.cycleScrollView.imageURLStringsGroup = model.sliderImages;

}

- (IBAction)buttonClick:(id)sender {
    [self closeADWithAnimated:self.animated];
    [UIPasteboard generalPasteboard].string = @"";

    HomeWalletViewController *vc = (HomeWalletViewController *)[[MGPHttpRequest shareManager]jsd_findVisibleViewController];
    
    ProListItem *proModel = self.model;
    DCGoodDetailViewController *dcVc = [[DCGoodDetailViewController alloc] init];
    dcVc.proModel = proModel;
    dcVc.goodTitle = proModel.storeName;
    dcVc.goodPrice = [NSString stringWithFormat:@"%.2f",proModel.price];
    dcVc.goodSubtitle = proModel.storeInfo;
    dcVc.shufflingArray = proModel.sliderImages;
    dcVc.goodImageView = proModel.image_url.firstObject;
    dcVc.postage = [NSString stringWithFormat:@"%ld",proModel.postage];
    dcVc.storeUnit = [NSString stringWithFormat:@"%@",proModel.storeType];
    dcVc.goodId = [NSString stringWithFormat:@"%ld",proModel.proID];
    [vc.navigationController pushViewController:dcVc animated:YES];
    
    
    
}

- (IBAction)cancelClick:(id)sender {
    [self closeADWithAnimated:self.animated];
}
/**
 初始化页面约束
 */
- (void)makeViewContraints{
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.superview).insets(UIEdgeInsetsZero);
    }];
    
    [self.bgAdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(-CGRectGetHeight([UIScreen mainScreen].bounds)/2.0 - kADViewHeight/2.0 - kOffsetY-30);
        make.centerX.equalTo(self).offset(30);
        make.width.mas_equalTo(kADViewWidth);
//        make.height.equalTo(300);
    }];
    
    
    
}

/**
 弹窗广告插件

 @param animated 是否需要动画
 */
- (void)popADWithAnimated:(BOOL)animated{

    self.animated = animated;
    
    [[[UIApplication sharedApplication].delegate window]addSubview:self];
    
    //初始化约束，并及时刷新约束
    [self makeViewContraints];
    [self layoutIfNeeded];
    
    //更新约束
    [self.bgAdView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(- kOffsetY);
    }];
    
    if(self.animated){
        //添加弹簧动画
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:100 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self layoutIfNeeded];
        } completion:nil];
    }
}



/**
 关闭弹窗广告插件
 
 @param animated 是否需要动画
 */
- (void)closeADWithAnimated:(BOOL)animated{
    
    //更新约束
    [self.bgAdView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(CGRectGetHeight([UIScreen mainScreen].bounds)/2.0 + kADViewHeight + kOffsetY);
    }];
    
    if(animated){
        [UIView animateWithDuration:0.5 animations:^{
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
    else{
        [self removeFromSuperview];
    }
}




@end
