//
//  UserInfoModel.m
//  TaiYiToken
//
//  Created by Frued on 2018/10/18.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel
-(void)vailidateUserInfo{
    self.userId = self.userId;
    self.loginName = VALIDATE_STRING(self.loginName);
    self.userToken = VALIDATE_STRING(self.userToken);
    self.nickName = VALIDATE_STRING(self.nickName);
    self.mobile = VALIDATE_STRING(self.mobile);
    //self.mobileStatus = self.mobileStatus;
    self.mail = VALIDATE_STRING(self.mail);
   // self.mailStatus = self.mailStatus;
    self.avatar = VALIDATE_STRING(self.avatar);
    //self.isLocked = self.isLocked;
    self.idCardNo = VALIDATE_STRING(self.idCardNo);
   // self.idCardStatus = self.idCardStatus;
    self.realName = VALIDATE_STRING(self.realName);
}
- (void)encodeWithCoder:(NSCoder *)coder
{
    //告诉系统归档的属性是哪些
    unsigned int count = 0;//表示对象的属性个数
    Ivar *ivars = class_copyIvarList([UserInfoModel class], &count);
    for (int i = 0; i<count; i++) {
        //拿到Ivar
        Ivar ivar = ivars[i];
        const char *name = ivar_getName(ivar);//获取到属性的C字符串名称
        NSString *key = [NSString stringWithUTF8String:name];//转成对应的OC名称
        //归档 -- 利用KVC
        [coder encodeObject:[self valueForKey:key] forKey:key];
    }
    free(ivars);//在OC中使用了Copy、Creat、New类型的函数，需要释放指针！！（注：ARC管不了C函数）
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        //解档
        unsigned int count = 0;
        Ivar *ivars = class_copyIvarList([UserInfoModel class], &count);
        for (int i = 0; i<count; i++) {
            //拿到Ivar
            Ivar ivar = ivars[i];
            const char *name = ivar_getName(ivar);
            NSString *key = [NSString stringWithUTF8String:name];
            //解档
            id value = [coder decodeObjectForKey:key];
            // 利用KVC赋值
            [self setValue:value forKey:key];
        }
        free(ivars);
    }
    return self;
}
@end
