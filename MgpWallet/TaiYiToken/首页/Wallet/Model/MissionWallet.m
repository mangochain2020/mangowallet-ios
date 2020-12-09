//
//  MissionWallet.m
//  TaiYiToken
//
//  Created by Frued on 2018/8/27.
//  Copyright © 2018年 Frued. All rights reserved.
//

#import "MissionWallet.h"

@implementation MissionWallet
-(void)dataCheck{
    self.xprv = VALIDATE_STRING(self.xprv);
    self.AccountExtendedPrivateKey = VALIDATE_STRING(self.AccountExtendedPrivateKey);
    self.AccountExtendedPublicKey = VALIDATE_STRING(self.AccountExtendedPublicKey);
    self.BIP32ExtendedPrivateKey = VALIDATE_STRING(self.BIP32ExtendedPrivateKey);
    self.BIP32ExtendedPublicKey = VALIDATE_STRING(self.BIP32ExtendedPublicKey);
    self.privateKey = VALIDATE_STRING(self.privateKey);
    self.publicKey = VALIDATE_STRING(self.publicKey);
    self.address = VALIDATE_STRING(self.address);
    self.walletName = VALIDATE_STRING(self.walletName);
    self.addressarray = VALIDATE_MUTABLEARRAY(self.addressarray);
    self.changeAddressArray = VALIDATE_MUTABLEARRAY(self.changeAddressArray);
    self.selectedBTCAddress = VALIDATE_STRING(self.selectedBTCAddress);
    self.passwordHint = VALIDATE_STRING(self.passwordHint);
    self.changeAddressStr = VALIDATE_STRING(self.changeAddressStr);
    self.ifEOSAccountRegistered = NO;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    //告诉系统归档的属性是哪些
    unsigned int count = 0;//表示对象的属性个数
    Ivar *ivars = class_copyIvarList([MissionWallet class], &count);
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
        Ivar *ivars = class_copyIvarList([MissionWallet class], &count);
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
