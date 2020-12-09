//
//  DomainConfigManager.m
//  DomainSwitchDemo
//
//  Created by 推凯 on 2020/6/26.
//  Copyright © 2020 asf. All rights reserved.
//

#import "DomainConfigManager.h"
#import "DomainConfigConst.h"
@interface DomainConfigManager()
@property(strong,nonatomic)NSDictionary*locaolDict;
@property(strong,nonatomic)NSArray*locaolArr;
@property(strong,nonatomic)NSUserDefaults*userDefault;

@end
@implementation DomainConfigManager
+(instancetype)share{
    static DomainConfigManager*manager=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager=[[self alloc]init];
    });
    return manager;
}
-(instancetype)init{
    if (self=[super init]) {
        NSString*file=[[NSBundle mainBundle]pathForResource:kPlistName ofType:@"plist"];
       _locaolDict =[NSDictionary dictionaryWithContentsOfFile:file];
       _locaolArr=_locaolDict[kLocalServers];
        _userDefault=[NSUserDefaults standardUserDefaults];
        if (![_userDefault objectForKey:kCurrentIndex]) {
            [_userDefault setValue:_locaolDict[@"defaultServer"] forKey:kCurrentIndex];
        }
        [self allServers];
    }
    return self;
}
-(NSDictionary*)getCurrentEvnDict{
  static  NSDictionary*dict=nil;
    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
        NSNumber*num=[_userDefault objectForKey:kCurrentIndex];
        dict= _allServers[num.integerValue];
//    });
    return dict;
}

-(NSMutableArray *)allServers{
    _allServers=[NSMutableArray arrayWithArray:_locaolArr];
    if ([self getCustomServers]) {
       [_allServers addObjectsFromArray:[self getCustomServers]];
    }
    return _allServers;
}

-(NSArray*)getLocalServers{
    return _locaolArr;;
}
-(NSArray*)getCustomServers{
    if ([[NSFileManager defaultManager] fileExistsAtPath:kfilePath]) {
       return [NSArray arrayWithContentsOfFile:kfilePath];
    }
    return nil;
}
-(NSDictionary *)getEvnDictWithName:(NSString *)name{
    
   __block NSDictionary*dictResult;
    [_allServers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary*dict=(NSDictionary*)obj;
        if ([obj[kserveName] isEqualToString:name]) {
            dictResult=dict;
        }
    }];
    return dictResult;;
}
-(void)changeEvnTo:(NSInteger)index{
    [_userDefault setValue:[NSNumber numberWithInteger:index] forKey:kCurrentIndex];
    [_userDefault synchronize];
//    exit(0);
}

-(void)addCustomEvnWithName:(NSString *)name domains:(NSDictionary *)dict{
    
    if (!dict||!dict[kserveName]) {
        NSLog(@"不合法的输入");
        return;
    }
    
    
   NSString *filePath = kfilePath;
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSMutableArray*arr=[NSMutableArray arrayWithContentsOfFile:filePath];
        [arr addObject:dict];
        [arr writeToFile:filePath atomically:YES];
    }else{
        NSMutableArray*arr=[[NSMutableArray alloc]init];
        [arr addObject:dict];
        [arr writeToFile:filePath atomically:YES];
    }
}
-(void)removeCustomEvnWithName:(NSString *)name{
    
}
-(void)updateCustomEvnWithName:(NSString *)name{
    
}
@end
