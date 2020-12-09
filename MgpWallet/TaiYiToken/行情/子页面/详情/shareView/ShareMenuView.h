//
//  ShareMenuView.h
//  TaiYiToken
//
//  Created by Frued on 2018/8/31.
//  Copyright © 2018年 Frued. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface ShareMenuView : UIView<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
/*
 如果配置好各个分享平台的 URL Scheme 之后，分享功能仍然无法正常使用，经检查是因为 iOS 9 的白名单问题。加入后解决。
 由于是自定义的分享面板，在调用时需要判断当前设备中是否安装了相应的平台的应用，如 QQ、Wechat等。如果当前设备中没有安装某个应用而面板中带有该平台的分享图标，在 App 审核时可能不会被通过。友盟自带的分享面板已经做过这层判断。
 */
@property (nonatomic, strong)NSMutableArray * dataSource; //配置数据，例如没有微信，隐藏微信按钮，在这个数组中配置(无论在外部还是内部配置都是可以的)
@property(nonatomic,strong)UIButton *hideBtn;
-(void)loadShareMenuView;
@end
