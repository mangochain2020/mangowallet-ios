//
//  DomainConfigConst.h
//  DomainSwitchDemo
//
//  Created by 推凯 on 2020/6/26.
//  Copyright © 2020 asf. All rights reserved.
//

#ifndef DomainConfigConst_h
#define DomainConfigConst_h
static  NSString * const kPlistName = @"domainList";
static  NSString * const kLocalServers = @"localServers";
static  NSString * const kDefaultServer = @"defaultServer";
static  NSString * const kserveName = @"kserveName";

static  NSString * const kCurrentIndex = @"CurrentIndex";

//可修改的字段
static  NSString * const kserveApi = @"kserveApi";
static  NSString * const nodeBtc = @"nodeBtc";
static  NSString * const nodeEth = @"nodeEth";
static  NSString * const nodeEos = @"nodeEos";
static  NSString * const nodeMgp = @"nodeMgp";
static  NSString * const bpvoting = @"bpvoting";


#define kfilePath [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/customDomains.plist"]


#endif /* DomainConfigConst_h */
