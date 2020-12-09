//
//  SelectHuobiSymbolsVC.m
//  TaiYiToken
//
//  Created by 张元一 on 2019/3/11.
//  Copyright © 2019 admin. All rights reserved.
//

#import "SelectHuobiSymbolsVC.h"
#import "HuobisymbolCell.h"

@interface SelectHuobiSymbolsVC ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic ,strong)UIView *bgView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)ScrollBtnsView *symbolBtnsView;
@property(nonatomic,strong)HuobiSymbolsData *symbolsdata;
@property(nonatomic,strong)NSMutableArray <HuobiSymbolsDetail *>*currentsymbolArray;
@property(nonatomic,strong)NSArray<NSString *> *symbolTagArr;
@property(nonatomic,assign)NSInteger currentIndex;
@property(nonatomic,strong) UISearchBar *searchBar;
@end

@implementation SelectHuobiSymbolsVC
-(void)viewWillAppear:(BOOL)animated{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.currentsymbolArray = [NSMutableArray new];
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    self.symbolTagArr = @[@"USDT",@"BTC",@"ETH",@"HT"];
    _bgView = [UIView new];
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.alpha = 1;
    self.currentIndex = 0;
    [self.view addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(0);
        make.width.equalTo(ScreenWidth/2 *1.5);
    }];
    
   
    MJWeakSelf
    [HuobiManager HuobiGetSymbolsCompletionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
        if (!error) {
            HuobiSymbolsModel *model = [HuobiSymbolsModel parse:responseObj];
            if (model.resultCode != 20000) {
                [weakSelf.view showMsg:model.resultMsg];
            }else{
                weakSelf.symbolsdata = model.data;
                weakSelf.currentsymbolArray = [model.data.usdt mutableCopy];
                [weakSelf.tableView reloadData];
            }
        }else{
            [weakSelf.view showMsg:error.userInfo.description];
        }
    }];
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont boldSystemFontOfSize:20];
    _titleLabel.textColor = [UIColor textBlackColor];
    _titleLabel.text = NSLocalizedString(@"币币", nil);
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.bgView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(10);
        make.height.equalTo(25);
        make.left.equalTo(30);
        make.width.equalTo(100);
    }];
    [self loadBtns];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth/2 *1.5, 40)];
    _searchBar.barStyle = UISearchBarStyleDefault;
    _searchBar.layer.borderColor = [UIColor lineGrayColor].CGColor;
    _searchBar.translucent = YES;
    _searchBar.delegate = self;
    _searchBar.tintColor = [UIColor grayColor];
    _searchBar.barTintColor = [UIColor whiteColor];
    [_searchBar setPlaceholder:NSLocalizedString(@"搜索币种", nil)];
    [self.bgView addSubview:_searchBar];
    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(80);
        make.height.equalTo(40);
        make.left.equalTo(0);
        make.right.equalTo(0);
    }];
}

-(NSString *)checkFloatToStr:(CGFloat)num{
    if ([[NSString stringWithFormat:@"%.8f",num] isEqualToString:@"0.00000000"]) {
        return @"--";
    }
    if (num < 0.001) {
        return [NSString stringWithFormat:@"%.8f",num];
    }else if (num < 1.0){
        return [NSString stringWithFormat:@"%.6f",num];
    }else if (num < 10.0){
        return [NSString stringWithFormat:@"%.4f",num];
    }else if (num < 1000.0){
        return [NSString stringWithFormat:@"%.2f",num];
    }else if(num < 10000){
        return [NSString stringWithFormat:@"%.2fK",num/1000.0];
    }else if(num < 1000000){
        return [NSString stringWithFormat:@"%.0fK",num/1000.0];
    }else if(num < 10000000){
        return [NSString stringWithFormat:@"%.0fM",num/1000000.0];
    }else{
        return [NSString stringWithFormat:@"%.0fB",num/1000000000.0];
    }
}

- (void)closeController{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ToolViewShouldHide" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectNewPrice" object:nil userInfo:nil];
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    [self.view endEditing:YES];
    return YES;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"%@",searchText);
    NSMutableArray *temparray = [NSMutableArray new];
    NSMutableArray *fullarray = [NSMutableArray new];
    switch (self.currentIndex) {
        case 0:
            fullarray = [self.symbolsdata.usdt mutableCopy];
            break;
        case 1:
            fullarray = [self.symbolsdata.btc mutableCopy];
            break;
        case 2:
            fullarray = [self.symbolsdata.eth mutableCopy];
            break;
        case 3:
            fullarray = [self.symbolsdata.ht mutableCopy];
            break;
        default:
            break;
    }
    for (HuobiSymbolsDetail *obj in fullarray) {
        if ([obj.symbol containsString:[searchText uppercaseString]]) {
            [temparray addObject:obj];
        }
    }
    if ([VALIDATE_STRING(searchText) isEqualToString:@""]) {
        temparray = [fullarray mutableCopy];
    }
    [self.currentsymbolArray removeAllObjects];
    self.currentsymbolArray = [temparray mutableCopy];
    [self.tableView reloadData];
}

-(void)loadBtns{
    if (!_symbolBtnsView) {
        _symbolBtnsView = [ScrollBtnsView new];
        _symbolBtnsView.lineView.hidden = NO;
        [_symbolBtnsView initButtonsViewWithTitles:self.symbolTagArr Width:ScreenWidth/2 *1.5 Height:40];
        NSInteger index = 100;
        for (UIButton *btn in _symbolBtnsView.btnArray) {
            if(index == 100){
                [_symbolBtnsView setBtnSelected:btn];
            }
            btn.tag = index;
            index++;
            [btn addTarget:self action:@selector(selectSymbols:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [self.bgView addSubview:_symbolBtnsView];
        [_symbolBtnsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(45);
            make.left.right.equalTo(0);
            make.height.equalTo(33);
        }];
    }
}

-(void)selectSymbols:(UIButton *)btn{
    [_symbolBtnsView setBtnSelected:btn];
    self.currentIndex = btn.tag - 100;
    [self.currentsymbolArray removeAllObjects];
    switch (self.currentIndex) {
        case 0:
            self.currentsymbolArray = [self.symbolsdata.usdt mutableCopy];
            break;
        case 1:
            self.currentsymbolArray = [self.symbolsdata.btc mutableCopy];
            break;
        case 2:
            self.currentsymbolArray = [self.symbolsdata.eth mutableCopy];
            break;
        case 3:
            self.currentsymbolArray = [self.symbolsdata.ht mutableCopy];
            break;
        default:
            break;
    }
    [self.tableView reloadData];
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
    if (self.currentIndex >0 || self.currentIndex<self.symbolTagArr.count) {
        return self.currentsymbolArray.count;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //noti
    HuobiSymbolsDetail *datamodel;
    if (self.currentIndex >0 || self.currentIndex<self.symbolTagArr.count) {
        datamodel = [self.currentsymbolArray objectAtIndex:indexPath.row];
        if (datamodel) {
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@/%@",datamodel.symbol,self.symbolTagArr[self.currentIndex]] forKey:CurrentHuobiSymbols];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self closeController];
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HuobisymbolCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HuobisymbolCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    HuobiSymbolsDetail *datamodel;
    if ((self.currentIndex >0 || self.currentIndex<self.symbolTagArr.count )&& indexPath.row < self.currentsymbolArray.count) {
        datamodel = [self.currentsymbolArray objectAtIndex:indexPath.row];
        if (datamodel) {
            NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString: datamodel.symbol];
            [attributedStr addAttribute: NSFontAttributeName value:[UIFont  boldSystemFontOfSize:14] range: NSMakeRange(0, datamodel.symbol.length)];
            [attributedStr addAttribute: NSForegroundColorAttributeName value: [UIColor blackColor] range: NSMakeRange(0, datamodel.symbol.length)];
            NSString *basesymbol = [NSString stringWithFormat:@"/%@", self.symbolTagArr[self.currentIndex]];
            NSMutableAttributedString *attributedStr2 = [[NSMutableAttributedString alloc] initWithString: basesymbol];
            [attributedStr2 addAttribute: NSFontAttributeName value:[UIFont  systemFontOfSize:13] range: NSMakeRange(0, basesymbol.length)];
            [attributedStr2 addAttribute: NSForegroundColorAttributeName value: [UIColor grayColor] range: NSMakeRange(0, basesymbol.length)];
            [attributedStr appendAttributedString:attributedStr2];
            cell.leftlb.attributedText = attributedStr;
            cell.rightlb.text = [NSString stringWithFormat:@"%@",datamodel.close.stringValue];
        }
    }
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
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        UIView *view = [[UIView alloc] init];
        _tableView.tableFooterView = view;
        [_tableView registerClass:[HuobisymbolCell class] forCellReuseIdentifier:@"HuobisymbolCell"];
        [self.bgView addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(120);
            make.left.right.equalTo(0);
            make.bottom.equalTo(0);
        }];
    }
    return _tableView;
}
@end
