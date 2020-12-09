//
//  SystemInitModel.h
//  TaiYiToken
//
//  Created by Frued on 2018/10/19.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class IosVersion,AboutUs;
@interface SystemInitModel : NSObject
-(void)datacheck;
/*
 nodeEthList    string    eth节点
 nodeBtcList    string    btc节点
 nodeEosList    string    eos节点
 nodeMisList    string    mis节点
 androidVersion    object    android版本信息
 iosVersion    object    ios版本信息
 misChainBrowser    String    区块链浏览器URL
 mlSiteUrl    String    魔力试用网址
 */
@property (nonatomic, strong) NSString *mlSiteUrl;
@property (nonatomic, strong) NSString * misChainBrowser;
@property (nonatomic, strong) NSArray <NSString *>* nodeBtcList;
@property (nonatomic, strong) NSArray <NSString *>* nodeEosList;
@property (nonatomic, strong) NSArray <NSString *>* nodeEthList;
@property (nonatomic, strong) NSArray <NSString *>* nodeMisList;
@property (nonatomic, strong) IosVersion *iosversion;
@property(nonatomic,strong)AboutUs *aboutUs;
@end

@interface IosVersion : NSObject
/*
 version    string    版本号
 forceUpdate    int    是否强制更新
 intro    string    简介
 link    string    链接
 length    long    字节大小
 md5    string    文件md5值
 */

@property (nonatomic, assign) NSInteger forceUpdate;
@property (nonatomic, strong) NSString * intro;
@property (nonatomic, assign) NSInteger length;
@property (nonatomic, strong) NSString * link;
@property (nonatomic, strong) NSString * md5;
@property (nonatomic, strong) NSString * version;

@end


@interface AboutUs : NSObject

@property (nonatomic, strong) NSString * telegram;
@property (nonatomic, strong) NSString * twitter;
@property (nonatomic, strong) NSString * website;
@property (nonatomic, strong) NSString * wechat;
@property (nonatomic, strong) NSString * fb;
@property (nonatomic, strong) NSString * weibo;
@end
NS_ASSUME_NONNULL_END
