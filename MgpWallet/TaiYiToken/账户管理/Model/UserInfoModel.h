//
//  UserInfoModel.h
//  TaiYiToken
//
//  Created by Frued on 2018/10/18.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserInfoModel : NSObject<NSCoding>
/*userId    int    用户id
 loginName    string    账号名
 userToken    string    登录token
 nickName    string    昵称
 mobile    string    手机号
 mobileStatus    int    手机绑定状态
 mail    string    邮箱
 mailStatus    int    邮箱绑定状态
 avatar    string    头像
 isLocked    int    是否锁定
 idCardNo    string    身份证号
 idCardStatus    int    身份证认证状态
 realName    string    姓名*/
@property (nonatomic, strong) NSString * userId;
@property (nonatomic, strong) NSString * loginName;
@property (nonatomic, strong) NSString * userToken;
@property (nonatomic, strong) NSString * nickName;
@property (nonatomic, strong) NSString * mobile;
@property (nonatomic, assign) NSInteger mobileStatus;
@property (nonatomic, strong) NSString * mail;
@property (nonatomic, assign) NSInteger mailStatus;
@property (nonatomic, strong) NSString * avatar;
@property (nonatomic, assign) NSInteger isLocked;
@property (nonatomic, strong) NSString * idCardNo;
@property (nonatomic, assign) NSInteger idCardStatus;
@property (nonatomic, strong) NSString * realName;

-(void)vailidateUserInfo;
@end

NS_ASSUME_NONNULL_END
