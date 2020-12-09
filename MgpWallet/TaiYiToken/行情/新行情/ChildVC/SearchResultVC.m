//
//  SearchResultVC.m
//  TaiYiToken
//
//  Created by 张元一 on 2018/11/13.
//  Copyright © 2018 admin. All rights reserved.
//

#import "SearchResultVC.h"
#import "SearchResultCell.h"

#import "VTwoMarketDetailVC.h"
@interface SearchResultVC ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation SearchResultVC
-(void)viewWillAppear:(BOOL)animated{
    self.mysymbol = @"";
    if (_mysymbol == nil || [_mysymbol isEqualToString:@""]) {
        _mysymbol = [[NSUserDefaults standardUserDefaults] objectForKey:@"MySymbol"];
    }
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma tableView

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchdataarray == nil?0:self.searchdataarray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    VTwoMarketDetailVC *devc = [VTwoMarketDetailVC new];
//    devc.RMBDollarCurrency = self.RMBDollarCurrency <= 0?6.8:self.RMBDollarCurrency;
//    devc.marketModel = self.dataArray[indexPath.row];
//    [self.navigationController pushViewController:devc animated:YES];
}

-(void)editMySymbol:(UIButton *)btn{
    [btn setSelected:!btn.isSelected];
    
//    NSString *symbolselect = self.dataArray[btn.tag].coinCode;
    NSString *symbolselect = self.searchdataarray[btn.tag];
    if (symbolselect == nil || [symbolselect isEqualToString:@""]) {
        return;
    }
    _mysymbol = [[NSUserDefaults standardUserDefaults] objectForKey:@"MySymbol"];
    if (_mysymbol == nil) {
        _mysymbol = @"";
    }
    
    if (btn.selected == NO) {
        //yes : @"btc/eth,eos/bch,...," 最后一位加上“,”
        _mysymbol = [NSString stringWithFormat:@"%@,%@",symbolselect,_mysymbol];
    }else if(btn.selected == YES && [_mysymbol containsString:symbolselect]){
        //no : @"btc/eth,eos/bch,...," 最后一位加上“,”
        NSString *str = [NSString stringWithFormat:@"%@,",symbolselect];
        NSString *forestr = [_mysymbol componentsSeparatedByString:str].firstObject;
        NSString *laststr = [_mysymbol componentsSeparatedByString:str].lastObject;
        _mysymbol = [NSString stringWithFormat:@"%@%@",forestr,laststr];
    }
    [[NSUserDefaults standardUserDefaults] setObject:_mysymbol forKey:@"MySymbol"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchResultCell"];
    if (cell == nil) {
        cell = [SearchResultCell new];
    }
    if(indexPath.row>self.searchdataarray.count - 1||indexPath.row<0){
        return cell;
    }
  //  MarketTicketModel *model = self.dataArray[indexPath.row];
    NSString *str = self.searchdataarray[indexPath.row];
    [cell.symbollb setText:str];
    if ([self.mysymbol containsString:str]) {
        [cell.controlBtn setSelected:NO];//自选已经添加，显示减号
    }else{
        [cell.controlBtn setSelected:YES];
    }
    cell.controlBtn.tag = indexPath.row;
    [cell.controlBtn addTarget:self action:@selector(editMySymbol:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins  = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        UIView *view = [[UIView alloc] init];
        _tableView.tableFooterView = view;
        [_tableView registerClass:[SearchResultCell class] forCellReuseIdentifier:@"SearchResultCell"];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(0);
            make.left.right.equalTo(0);
            make.bottom.equalTo(0);
        }];
    }
    return _tableView;
}
@end
