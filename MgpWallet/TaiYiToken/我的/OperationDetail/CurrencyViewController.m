//
//  CurrencyViewController.m
//  TaiYiToken
//
//  Created by mac on 2020/8/26.
//  Copyright © 2020 admin. All rights reserved.
//

#import "CurrencyViewController.h"
#import "UserConfigCell.h"
#import "LHCurrencyModel.h"

#import "AppDelegate.h"
#import "CYLMainRootViewController.h"

@interface CurrencyViewController ()<UITableViewDelegate,UITableViewDataSource,STPickerSingleDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *titleArray;
@property(nonatomic,strong)LHCurrencyModel *selectModel;




@end

@implementation CurrencyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleArray = [NSMutableArray array];
    self.title = NSLocalizedString(@"货币设置", nil);
    [self.view addSubview:self.tableView];
    self.selectModel = [CreateAll GetCurrentCurrency];
    
    [[MGPHttpRequest shareManager]post:@"/api/coin_symbol" paramters:nil completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
        if ([responseObj[@"code"]intValue] == 0) {
            for (NSDictionary *dic in responseObj[@"data"]) {
                [self.titleArray addObject:[LHCurrencyModel mj_objectWithKeyValues:dic]];
            }
        }
        [self.tableView reloadData];

    }];
    UIButton *_scanBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    [_scanBtn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchDragExit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_scanBtn];

    
    
}
- (void)btnAction{
    NSMutableArray *array = [NSMutableArray array];
    NSArray *serversArray = [DomainConfigManager share].allServers;
    for (NSDictionary *dic in serversArray) {
        [array addObject:dic[kserveName]];
    }
    
    STPickerSingle *single = [[STPickerSingle alloc]init];
    [single setArrayData:array];
    [single setTitle:[NSString stringWithFormat:@"当前:%@",[[DomainConfigManager share]getCurrentEvnDict][kserveName]]];
    [single setTitleUnit:@""];
    [single setDelegate:self];
    [single show];
    
}
- (void)pickerSingle:(STPickerSingle *)pickerSingle selectedTitle:(NSString *)selectedTitle
{
    NSInteger index = [pickerSingle.arrayData indexOfObject:selectedTitle];
    [[DomainConfigManager share] changeEvnTo:index];
    [self.view showMsg:@"环境切换成功"];
    [HTTPRequestManager deallocManager];
    UIWindow *window = ((AppDelegate*)([UIApplication sharedApplication].delegate)).window;
    CYLMainRootViewController *csVC = [[CYLMainRootViewController alloc] init];
    window.rootViewController = csVC;
    
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
    return self.titleArray.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LHCurrencyModel *model = self.titleArray[indexPath.row];
    [CreateAll SaveCurrentCurrency:model];
    
    UIWindow *window = ((AppDelegate*)([UIApplication sharedApplication].delegate)).window;
    CYLMainRootViewController *csVC = [[CYLMainRootViewController alloc] init];
    window.rootViewController = csVC;
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserConfigCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserConfigCell" forIndexPath:indexPath];
    LHCurrencyModel *model = self.titleArray[indexPath.row];
    
    cell.textlb.text = [NSString stringWithFormat:@"%@[%@]",model.name,model.symbolName];
    
    if ([self.selectModel.name isEqualToString:model.name]) {
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
