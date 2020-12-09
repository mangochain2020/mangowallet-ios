//
//  DCCustionHeadView.m
//  CDDMall
//
//  Created by apple on 2017/6/12.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#define AuxiliaryNum 100
#import "LrdSuperMenu.h"

#import "DCCustionHeadView.h"
// Controllers

// Models

// Views
#import "DCCustionButton.h"
// Vendors

// Categories

// Others

@interface DCCustionHeadView ()<LrdSuperMenuDataSource, LrdSuperMenuDelegate>

@property (nonatomic, strong) LrdSuperMenu *menu;


@end

@implementation DCCustionHeadView

#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
    _menu = [[LrdSuperMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:44];
    _menu.delegate = self;
    _menu.dataSource = self;
    [self addSubview:_menu];
    
    [_menu selectDeafultIndexPath];
}

- (NSInteger)numberOfColumnsInMenu:(LrdSuperMenu *)menu {
    return 3;
}
//每个column有多少行
- (NSInteger)menu:(LrdSuperMenu *)menu numberOfRowsInColumn:(NSInteger)column{
    return 4;
}
//每个column中每行的title
- (NSString *)menu:(LrdSuperMenu *)menu titleForRowAtIndexPath:(LrdIndexPath *)indexPath{
    
    return @"erw";
}


@end
