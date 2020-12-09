//
//  LHStakeVoteManageCenterViewController.m
//  TaiYiToken
//
//  Created by mac on 2020/11/17.
//  Copyright © 2020 admin. All rights reserved.
//

#import "LHStakeVoteManageCenterViewController.h"
#import "LHStakeVoteManageTableViewController.h"

@interface LHStakeVoteManageCenterViewController ()

@end

@implementation LHStakeVoteManageCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpAllChildViewController];
    self.title = NSLocalizedString(@"管理中心", nil);

    [self setUpDisplayStyle:^(UIColor *__autoreleasing *titleScrollViewBgColor, UIColor *__autoreleasing *norColor, UIColor *__autoreleasing *selColor, UIColor *__autoreleasing *proColor, UIFont *__autoreleasing *titleFont, CGFloat *titleButtonWidth, BOOL *isShowPregressView, BOOL *isOpenStretch, BOOL *isOpenShade) {
        
        *titleFont = PFR16Font;      //字体尺寸 (默认fontSize为15)
        *norColor = [UIColor darkGrayColor];
        
        /*
         以下BOOL值默认都为NO
         */
        *isShowPregressView = YES;                      //是否开启标题下部Pregress指示器
        *isOpenStretch = YES;                           //是否开启指示器拉伸效果
        *isOpenShade = YES;                             //是否开启字体渐变
    }];
}
#pragma mark - 添加所有子控制器
- (void)setUpAllChildViewController
{
    
    UIStoryboard* secondStoryboard = [UIStoryboard storyboardWithName:@"StakeVote" bundle:[NSBundle mainBundle]];
    
    LHStakeVoteManageTableViewController *vc00 = [secondStoryboard instantiateViewControllerWithIdentifier:@"LHStakeVoteManageTableViewControllerIndex"];
    vc00.title = NSLocalizedString(@"我的投票", nil);
    vc00.isNoteVC = NO;
    [self addChildViewController:vc00];
    
    LHStakeVoteManageTableViewController *vc01 = [secondStoryboard instantiateViewControllerWithIdentifier:@"LHStakeVoteManageTableViewControllerIndex"];
    vc01.title = NSLocalizedString(@"我的节点", nil);
    vc01.isNoteVC = YES;
    [self addChildViewController:vc01];
    

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
