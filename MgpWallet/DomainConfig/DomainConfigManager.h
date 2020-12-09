//
//  DomainConfigManager.h
//  DomainSwitchDemo
//
//  Created by 推凯 on 2020/6/26.
//  Copyright © 2020 asf. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DomainConfigManager : NSObject
@property(strong,nonatomic)NSMutableArray*allServers;

+(instancetype)share;
-(NSDictionary*)getCurrentEvnDict;
-(NSDictionary*)getEvnDictWithName:(NSString*)name;
-(void)changeEvnTo:(NSInteger)index;

-(void)addCustomEvnWithName:(NSString*)name domains:(NSDictionary*)dict;
-(void)removeCustomEvnWithName:(NSString*)name;
-(void)updateCustomEvnWithName:(NSString*)name;

@end

NS_ASSUME_NONNULL_END
