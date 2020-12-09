//
//  LangViewController.m
//  TaiYiToken
//
//  Created by mac on 2020/8/24.
//  Copyright © 2020 admin. All rights reserved.
//

#import "LangViewController.h"
#import "UserConfigCell.h"
#import "NTVLocalized.h"

#import "AppDelegate.h"
#import "CYLMainRootViewController.h"


@interface LangViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *titleArray;

@end

@implementation LangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleArray = @[@{@"title":@"中文",@"subTitle":@"zh-Hans",@"severLang":@"zh_CN"},@{@"title":@"English",@"subTitle":@"en",@"severLang":@"en_US"},@{@"title":@"日本語",@"subTitle":@"ja",@"severLang":@"ja_JP"},@{@"title":@"한글",@"subTitle":@"ko",@"severLang":@"ko_KR"}];
    self.title = NSLocalizedString(@"多语言", nil);
    [self.view addSubview:self.tableView];

    
    
}




#pragma mark - Table view data source
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *lang = [self.titleArray[indexPath.row]objectForKey:@"subTitle"];
    [[NTVLocalized sharedInstance] setLanguage:lang];
        
    [[NSUserDefaults standardUserDefaults] setObject:[self.titleArray[indexPath.row]objectForKey:@"severLang"] forKey:@"CurrentLanguageSelected"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    UIWindow *window = ((AppDelegate*)([UIApplication sharedApplication].delegate)).window;
    CYLMainRootViewController *csVC = [[CYLMainRootViewController alloc] init];
    window.rootViewController = csVC;
    
    
  
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserConfigCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserConfigCell" forIndexPath:indexPath];
    cell.textlb.text = [self.titleArray[indexPath.row]objectForKey:@"title"];
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"CurrentLanguageSelected"]isEqualToString:[self.titleArray[indexPath.row]objectForKey:@"severLang"]]) {
        [cell checkIv];

    }else{
        [cell rightIconIv];

    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins  = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
}

#pragma lazy
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        UIView *view = [[UIView alloc] init];
        _tableView.tableFooterView = view;
        [_tableView registerClass:[UserConfigCell class] forCellReuseIdentifier:@"UserConfigCell"];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(0);
        }];
    }
    return _tableView;
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
