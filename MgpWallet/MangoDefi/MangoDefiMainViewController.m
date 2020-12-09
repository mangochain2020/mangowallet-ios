//
//  MangoDefiMainViewController.m
//  TaiYiToken
//
//  Created by mac on 2020/8/31.
//  Copyright © 2020 admin. All rights reserved.
//

#import "MangoDefiMainViewController.h"
#import "MangoDefiListViewController.h"

@interface MangoDefiMainViewController ()<STPickerSingleDelegate>

@property (strong,nonatomic)NSArray *countryData;


@end

@implementation MangoDefiMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"MangoDefi", nil);

    [self setUpAllChildViewController];

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
    
    UIButton *_scanBtn = [UIButton buttonWithType: UIButtonTypeRoundedRect];
    _scanBtn.frame = CGRectMake(0, 0, 100, 60);
    _scanBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_scanBtn addTarget:self action:@selector(getCountry) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_scanBtn];
    [self getCountry];
    
}

#pragma mark - 添加所有子控制器
- (void)setUpAllChildViewController
{
    
    [[MGPHttpRequest shareManager]post:@"/api/appStoreLife/category" paramters:@{@"type":@"1"} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {

        if ([responseObj[@"code"]intValue] == 0) {
    
            for (NSDictionary *dic in responseObj[@"data"]) {
                MangoDefiListViewController *vc = [MangoDefiListViewController new];
                vc.title = NSLocalizedString(dic[@"name"], nil);
                vc.defiID = dic[@"id"];
                vc.countryID = @"1";
                [self addChildViewController:vc];
            }
            [self setUpRefreshDisplay]; //刷新
        }
        
        
    }];
    
}



- (void)btnAction{
    
    NSMutableArray *array = [NSMutableArray array];
    NSArray *serversArray = self.countryData;
    for (NSDictionary *dic in serversArray) {
        [array addObject:dic[@"countyName"]];
    }
    STPickerSingle *single = [[STPickerSingle alloc]init];
    [single setArrayData:array];
    [single setTitle:@""];
    [single setTitleUnit:@""];
    [single setDelegate:self];
    [single show];
    
}
- (void)pickerSingle:(STPickerSingle *)pickerSingle selectedTitle:(NSString *)selectedTitle
{
    NSInteger index = [pickerSingle.arrayData indexOfObject:selectedTitle];
    UIButton *btn = (UIButton *)self.navigationItem.rightBarButtonItem.customView;
    [btn setTitle:[self.countryData[index]objectForKey:@"countyName"] forState:UIControlStateNormal];
    for (MangoDefiListViewController *vc in self.childViewControllers) {
        vc.countryID = [self.countryData[index]objectForKey:@"id"];
        [vc.tableView.mj_header beginRefreshing];
    }
    
    

}
- (void)getCountry{
    if (self.countryData) {
        [self btnAction];

    }else{
        [[MGPHttpRequest shareManager]post:@"/appCountry/getCountry" paramters:nil completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {

            if ([responseObj[@"code"]intValue] == 0) {
                self.countryData = responseObj[@"data"];
                UIButton *btn = (UIButton *)self.navigationItem.rightBarButtonItem.customView;
                [btn setTitle:[self.countryData[0]objectForKey:@"countyName"] forState:UIControlStateNormal];
            }
        }];
    }
    
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
