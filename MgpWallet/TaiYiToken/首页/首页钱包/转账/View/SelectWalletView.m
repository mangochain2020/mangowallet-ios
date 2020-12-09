//
//  SelectWalletView.m
//  TaiYiToken
//
//  Created by 张元一 on 2018/11/15.
//  Copyright © 2018 admin. All rights reserved.
//

#import "SelectWalletView.h"

@interface SelectWalletView ()<UITableViewDelegate,UITableViewDataSource>


@end

@implementation SelectWalletView
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.view.backgroundColor = [UIColor backBlueColorA];
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Table view data source
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.selectwalletArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedwallet = self.selectwalletArray[indexPath.row];
    [self.tableView reloadData];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserConfigCell *cell = [tableView dequeueReusableCellWithIdentifier:@"normalcell"];
    MissionWallet *wallet = self.selectwalletArray[indexPath.row];
    if (wallet) {
        [cell.textlb setText:wallet.address];
        if ([wallet.address isEqualToString:self.selectedwallet.address]) {
            cell.checkIv.alpha = 1;
        }else{
            cell.checkIv.alpha = 0;
        }
    }
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
        _tableView.userInteractionEnabled = YES;
        _tableView.backgroundColor = RGB(250, 250, 250);
        UIView *view = [[UIView alloc] init];
        _tableView.tableFooterView = view;
        _tableView.separatorStyle =NO;
        [_tableView registerClass:[UserConfigCell class] forCellReuseIdentifier:@"normalcell"];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(30);
            make.left.right.bottom.equalTo(0);
        }];
    }
    return _tableView;
}
-(UIButton *)cofirmBtn{
    if (!_cofirmBtn) {
        _cofirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _cofirmBtn.backgroundColor = [UIColor clearColor];
        _cofirmBtn.tintColor = [UIColor textWhiteColor];
        _cofirmBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        [_cofirmBtn setTitle:NSLocalizedString(@"完成", nil) forState:UIControlStateNormal];
        [self.view addSubview:_cofirmBtn];
        _cofirmBtn.userInteractionEnabled = YES;
        [_cofirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(0);
            make.height.equalTo(30);
            make.right.equalTo(-10);
            make.width.equalTo(80);
        }];
    }
    return _cofirmBtn;
}
-(UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _cancelBtn.backgroundColor = [UIColor clearColor];
        _cancelBtn.tintColor = [UIColor textWhiteColor];
        _cancelBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_cancelBtn setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
        [self.view addSubview:_cancelBtn];
        _cancelBtn.userInteractionEnabled = YES;
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(0);
            make.height.equalTo(30);
            make.left.equalTo(10);
            make.width.equalTo(80);
        }];
    }
    return _cancelBtn;
}
@end
