//
//  EditSelfChooseVC.m
//  TaiYiToken
//
//  Created by admin on 2018/10/12.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "EditSelfChooseVC.h"
#import "EditSelfChooseCell.h"
#import "MarketThreeBtnView.h"
@interface EditSelfChooseVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UIButton *backBtn;
@property(nonatomic)UILabel *titleLabel;
@property(nonatomic)NSString *mysymbol;
@property(nonatomic)UITableView *tableView;
@property(nonatomic)UIButton *allChooseBtn;
@property(nonatomic)UIButton *deleteBtn;
@property(nonatomic,strong)MarketThreeBtnView *tableheaderBtnView;
@property(nonatomic,strong)NSMutableArray <MarketTicketModel *> *dataArrayCopy;
@property(nonatomic,strong)NSMutableDictionary <NSIndexPath *,MarketTicketModel *> *deleteDic;//
@property(nonatomic,strong)NSMutableArray <NSIndexPath *> *deleteIndexPathArray;//
@property(nonatomic,assign)BOOL ifSelectAllModel;//
@end

@implementation EditSelfChooseVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    self.navigationController.hidesBottomBarWhenPushed = YES;
    self.tabBarController.tabBar.hidden = YES;
    [self initBottomView];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.hidesBottomBarWhenPushed = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initHeadView];
   
    self.ifSelectAllModel = 0;
    self.dataArrayCopy = [NSMutableArray new];
    self.dataArrayCopy = [self.dataArray mutableCopy];
    self.deleteDic = [NSMutableDictionary new];
    self.deleteIndexPathArray = [NSMutableArray new];
    if (self.dataArray) {
        [self.tableView registerClass:[EditSelfChooseCell class] forCellReuseIdentifier:@"EditSelfChooseCell"];
    }else{
        [self.view showMsg:NSLocalizedString(@"请先添加自选", nil)];
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}
-(void)dismissAction{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
-(void)initHeadView{
    
    UIView *headBackView = [UIView new];
    headBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headBackView];
    [headBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(0);
        make.height.equalTo(SafeAreaTopHeight);
    }];
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _backBtn.backgroundColor = [UIColor clearColor];
    _backBtn.tintColor = [UIColor textBlueColor];
    _backBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [_backBtn setTitle:NSLocalizedString(@"完成", nil) forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backBtn];
    _backBtn.userInteractionEnabled = YES;
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(SafeAreaTopHeight - 34);
        make.height.equalTo(25);
        make.right.equalTo(-10);
        make.width.equalTo(80);
    }];
    
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont boldSystemFontOfSize:17];
    _titleLabel.textColor = [UIColor textBlackColor];
    [_titleLabel setText:[NSString stringWithFormat:NSLocalizedString(@"编辑自选", nil)]];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(SafeAreaTopHeight - 30);
        make.centerX.equalTo(0);
        make.width.equalTo(80);
        make.height.equalTo(20);
    }];
    
    _tableheaderBtnView = [MarketThreeBtnView new];
    [self.view addSubview:_tableheaderBtnView];
    [_tableheaderBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(SafeAreaTopHeight);
        make.height.equalTo(30);
    }];
    _tableheaderBtnView.backgroundColor = [UIColor colorWithHexString:@"#F5FAFC"];
    [_tableheaderBtnView firstBtnWithTitile:NSLocalizedString(@"名称", nil) ifHasImages:NO];
    [_tableheaderBtnView secondBtnWithTitle:NSLocalizedString(@"置顶", nil) ifHasImages:NO SelectTYpe:-1];
    [_tableheaderBtnView thirdBtnWithTitle:NSLocalizedString(@"拖动", nil) ifHasImages:NO SelectTYpe:-1];
    _tableheaderBtnView.firstBtn.userInteractionEnabled = NO;
    _tableheaderBtnView.userInteractionEnabled = NO;
    _tableheaderBtnView.userInteractionEnabled = NO;
    
}

-(void)deleteModel{
    if (self.deleteIndexPathArray.count == 0) {
        return;
    }
   
    __block NSString *mysymbol = [[NSUserDefaults standardUserDefaults] objectForKey:@"MySymbol"];
    if (mysymbol == nil) {
        mysymbol = @"";
    }
    [self.deleteDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, MarketTicketModel *model, BOOL * _Nonnull stop) {
        if([mysymbol containsString:model.coinCode]){
            NSString *str = [NSString stringWithFormat:@"%@,",model.coinCode];
            NSString *forestr = [mysymbol componentsSeparatedByString:str].firstObject;
            NSString *laststr = [mysymbol componentsSeparatedByString:str].lastObject;
            mysymbol = [NSString stringWithFormat:@"%@%@",forestr,laststr];
        }
    }];
    
    [[NSUserDefaults standardUserDefaults] setObject:mysymbol forKey:@"MySymbol"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.deleteIndexPathArray removeAllObjects];
    [self.deleteDic removeAllObjects];
    self.dataArrayCopy = [self.dataArray mutableCopy];
    for (NSInteger i = 0; i < self.dataArrayCopy.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        EditSelfChooseCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell.chooseBtn setSelected:NO];
    }
    [self.tableView reloadData];
    [self.view showMsg:NSLocalizedString(@"删除成功", mil)];
}

-(void)chooseAll:(UIButton *)btn{
    [btn setSelected:!btn.selected];
    if (btn.selected == YES) {
        self.ifSelectAllModel = YES;
        [self.deleteDic removeAllObjects];
        [self.deleteIndexPathArray removeAllObjects];
        for (NSInteger i = 0; i < self.dataArrayCopy.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.deleteIndexPathArray addObject:indexPath];
            [self.deleteDic setObject:self.dataArrayCopy[indexPath.row] forKey:indexPath];
            EditSelfChooseCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            [cell.chooseBtn setSelected:YES];
        }
        [self.dataArray removeAllObjects];
    }else{
        self.ifSelectAllModel = NO;
        [self.deleteDic removeAllObjects];
        [self.deleteIndexPathArray removeAllObjects];
        self.dataArray = [self.dataArrayCopy mutableCopy];
        for (NSInteger i = 0; i < self.dataArrayCopy.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            EditSelfChooseCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            [cell.chooseBtn setSelected:NO];
        }
    }
    [self.tableView reloadData];
}

-(void)initBottomView{
    UIView *BottomBackView = [UIView new];
    BottomBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:BottomBackView];
    [BottomBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.bottom.equalTo(-SafeAreaBottomHeight);
        make.height.equalTo(44);
    }];
    
    
    _allChooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_allChooseBtn setImage:[UIImage imageNamed:@"wxz"] forState:UIControlStateNormal];
    [_allChooseBtn setImage:[UIImage imageNamed:@"yxz"] forState:UIControlStateSelected];
    [_allChooseBtn addTarget:self action:@selector(chooseAll:) forControlEvents:UIControlEventTouchUpInside];
    [BottomBackView addSubview:_allChooseBtn];
    [_allChooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.centerY.equalTo(0);
        make.width.equalTo(20);
        make.height.equalTo(20);
    }];
    UILabel *allchooseLabel = [[UILabel alloc] init];
    allchooseLabel.textColor = [UIColor grayColor];
    [allchooseLabel setText:NSLocalizedString(@"全选", nil)];
    allchooseLabel.font = [UIFont boldSystemFontOfSize:15];
    allchooseLabel.textAlignment = NSTextAlignmentLeft;
    allchooseLabel.numberOfLines = 1;
    [BottomBackView addSubview:allchooseLabel];
    [allchooseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(50);
        make.centerY.equalTo(0);
        make.width.equalTo(100);
        make.height.equalTo(20);
    }];
    
    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleteBtn setImage:[UIImage imageNamed:@"del"] forState:UIControlStateNormal];
    [_deleteBtn addTarget:self action:@selector(deleteModel) forControlEvents:UIControlEventTouchUpInside];
    [BottomBackView addSubview:_deleteBtn];
    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-70);
        make.centerY.equalTo(0);
        make.width.equalTo(20);
        make.height.equalTo(20);
    }];
    UILabel *deleteLabel = [[UILabel alloc] init];
    deleteLabel.textColor = [UIColor grayColor];
    [deleteLabel setText:NSLocalizedString(@"删除", nil)];
    deleteLabel.font = [UIFont boldSystemFontOfSize:15];
    deleteLabel.textAlignment = NSTextAlignmentLeft;
    deleteLabel.numberOfLines = 1;
    [BottomBackView addSubview:deleteLabel];
    [deleteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-16);
        make.centerY.equalTo(0);
        make.width.equalTo(50);
        make.height.equalTo(20);
    }];
}


-(void)moveFromIndex:(NSInteger)fromindex ToIndex:(NSInteger)toindex{
   // [self.tableView moveRowAtIndexPath:[NSIndexPath indexPathForRow:fromindex inSection:0] toIndexPath:[NSIndexPath indexPathForRow:toindex inSection:0]];
    __block NSString *mysymbol = [[NSUserDefaults standardUserDefaults] objectForKey:@"MySymbol"];
    if (mysymbol == nil) {
        mysymbol = @"";
    }
    
    //更新本地存储的mysymbol顺序
    MarketTicketModel *frommodel = self.dataArrayCopy[fromindex];
   
    NSMutableArray *symbolArr = [[mysymbol componentsSeparatedByString:@","] mutableCopy];
    [symbolArr removeLastObject];
    if([mysymbol containsString:frommodel.coinCode]){
        [symbolArr removeObject:frommodel.coinCode];
        [symbolArr insertObject:frommodel.coinCode atIndex:toindex];
        mysymbol = @"";
        for (NSString *obj in symbolArr) {
            mysymbol = [mysymbol stringByAppendingString:[NSString stringWithFormat:@"%@,",obj]];
        }
        [[NSUserDefaults standardUserDefaults] setObject:mysymbol forKey:@"MySymbol"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //更新数组顺序
        NSMutableArray *tempArr = [NSMutableArray new];
        for (NSInteger i = 0; i < symbolArr.count; i++) {
            for (NSInteger j = 0; j < self.dataArrayCopy.count; j++) {
                MarketTicketModel *temp = self.dataArrayCopy[j];
                if ([temp.coinCode isEqualToString:(NSString *)symbolArr[i]]) {
                    [tempArr addObject:temp];
                }
            }
        }
        self.dataArrayCopy = [tempArr mutableCopy];
    }
}

-(void)moveToTop:(UIButton *)btn{
    [self moveFromIndex:btn.tag ToIndex:0];
    [self.tableView reloadData];
}
-(void)chooseCell:(UIButton *)btn{
    self.ifSelectAllModel = NO;
    [self.allChooseBtn setSelected:NO];
    [btn setSelected:!btn.selected];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:btn.tag inSection:0];
    if (btn.selected == YES) {
        //没有的才加入
        if(![self.deleteIndexPathArray containsObject:indexPath]){
            [self.deleteDic setObject:self.dataArrayCopy[indexPath.row] forKey:indexPath];
            [self.deleteIndexPathArray addObject:indexPath];
            [self.dataArray removeObject:self.dataArrayCopy[indexPath.row]];
        }
    }else{
        //有才删除
        if([self.deleteIndexPathArray containsObject:indexPath]){
            [self.dataArray addObject:self.dataArrayCopy[indexPath.row]];
            [self.deleteIndexPathArray removeObject:indexPath];
            [self.deleteDic removeObjectForKey:indexPath];
        }
    }
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
    return 65;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArrayCopy.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    EditSelfChooseCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell.chooseBtn setSelected:YES];
    //没有的才加入
    if(![self.deleteIndexPathArray containsObject:indexPath]){
        [self.deleteDic setObject:self.dataArrayCopy[indexPath.row] forKey:indexPath];
        [self.deleteIndexPathArray addObject:indexPath];
        [self.dataArray removeObject:self.dataArrayCopy[indexPath.row]];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EditSelfChooseCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell.chooseBtn setSelected:NO];
    //有才删除
    if([self.deleteIndexPathArray containsObject:indexPath]){
        [self.dataArray addObject:self.dataArrayCopy[indexPath.row]];
        [self.deleteIndexPathArray removeObject:indexPath];
        [self.deleteDic removeObjectForKey:indexPath];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EditSelfChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditSelfChooseCell"];
    if (cell == nil) {
        cell = [EditSelfChooseCell new];
    }
    if(indexPath.row>self.dataArrayCopy.count - 1||indexPath.row<0){
        return cell;
    }
    MarketTicketModel *model = self.dataArrayCopy[indexPath.row];
    
    [cell.coinNamelabel setText:model.coinCode];
    
    [cell initBtns];
    [cell.moveToTopBtn addTarget:self action:@selector(moveToTop:) forControlEvents:UIControlEventTouchUpInside];
    [cell.chooseBtn addTarget:self action:@selector(chooseCell:) forControlEvents:UIControlEventTouchUpInside];
    cell.moveToTopBtn.tag = indexPath.row;
    cell.chooseBtn.tag = indexPath.row;
    
    NSString *name = [NSString stringWithFormat:@"%@",model.coinName];
    [cell.namelabel setText:name];
    UIView *bcView = [UIView new];
    bcView.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = bcView;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins  = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    [self moveFromIndex:sourceIndexPath.row ToIndex:destinationIndexPath.row];
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        UIView *view = [[UIView alloc] init];
        _tableView.tableFooterView = view;
        _tableView.allowsSelection = YES;
        _tableView.allowsMultipleSelection = YES;
        [_tableView setEditing:YES animated:YES];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(94);
            make.left.right.equalTo(0);
            make.bottom.equalTo(-SafeAreaBottomHeight - 44);
        }];
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
