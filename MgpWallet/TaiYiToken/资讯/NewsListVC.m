//
//  NewsListVC.m
//  TaiYiToken
//
//  Created by 张元一 on 2019/4/1.
//  Copyright © 2019 admin. All rights reserved.
//

#import "NewsListVC.h"
#import "ScrollBtnsView.h"
#import "NewsListCell.h"
#import "InfoModels.h"
#import "InfoWebVC.h"
#import "MyCollectInfoVC.h"
@interface NewsListVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic)UILabel *titleLabel;
@property(nonatomic,strong)ScrollBtnsView *infoTypesView;
@property(nonatomic,strong)NSMutableArray <InfoListModel *> *dataArray;
@property(nonatomic,assign)NSInteger currentIndex;//0,1,2,3,4
@property(nonatomic,assign)NSInteger currentPage;
@property(nonatomic,strong)UIButton *collectBtn;
@end

@implementation NewsListVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    self.navigationController.hidesBottomBarWhenPushed = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.hidesBottomBarWhenPushed = NO;
}
- (void)popAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSMutableArray new];
    [self loadBtns];
    self.currentIndex = 1;
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont boldSystemFontOfSize:17];
    _titleLabel.textColor = [UIColor textBlackColor];
    [_titleLabel setText:NSLocalizedString(@"资讯", nil)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(SafeAreaTopHeight - 30);
        make.centerX.equalTo(0);
        make.width.equalTo(150);
        make.height.equalTo(20);
    }];
    _collectBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _collectBtn.tintColor = [UIColor darkGrayColor];
    _collectBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_collectBtn setTitle:NSLocalizedString(@"收藏", nil) forState:UIControlStateNormal];
    [_collectBtn addTarget:self action:@selector(mycollections) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_collectBtn];
    [_collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(SafeAreaTopHeight - 30);
        make.right.equalTo(-10);
        make.width.equalTo(80);
        make.height.equalTo(20);
    }];
    MJWeakSelf
    [self.tableView addHeaderRefresh:^{
        weakSelf.currentPage = 1;
        [NetManager GetInfoListType:weakSelf.currentIndex CurrentPage:weakSelf.currentPage CompletionHandler:^(id responseObj, NSError *error) {
            [weakSelf.tableView endHeaderRefresh];
            if (!error) {
                InfoBaseModel *model = [InfoBaseModel parse:responseObj];
                if (model.resultCode != 20000) {
                    [weakSelf.view showMsg:model.resultMsg];
                }else{
                    weakSelf.currentPage ++;
                    [weakSelf.dataArray removeAllObjects];
                    weakSelf.dataArray = [[InfoListModel parse:model.data]mutableCopy];
                    dispatch_async_on_main_queue(^{
                        [weakSelf.tableView reloadData];
                    });
                }
            }else{
                [weakSelf.view showMsg:error.userInfo.description];
            }
        }];
    }];
    [self.tableView addFooterRefresh:^{
        [NetManager GetInfoListType:weakSelf.currentIndex CurrentPage:weakSelf.currentPage CompletionHandler:^(id responseObj, NSError *error) {
            [weakSelf.tableView endFooterRefresh];
            if (!error) {
                InfoBaseModel *model = [InfoBaseModel parse:responseObj];
                if (model.resultCode != 20000) {
                    [weakSelf.view showMsg:model.resultMsg];
                }else{
                    weakSelf.currentPage ++;
                    [weakSelf.dataArray addObjectsFromArray:[InfoListModel parse:model.data]];
                    dispatch_async_on_main_queue(^{
                        [weakSelf.tableView reloadData];
                    });
                }
            }else{
                [weakSelf.view showMsg:error.userInfo.description];
            }
        }];
    }];
    [self.tableView beginHeaderRefresh];
}

-(void)mycollections{
    MyCollectInfoVC *vc = [MyCollectInfoVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)loadBtns{
    if (!_infoTypesView) {
        _infoTypesView = [ScrollBtnsView new];
        _infoTypesView.lineView.hidden = NO;
        /*
         （1-最新 2-政策 3-币圈 4-链圈 5-矿圈）
         */
        NSArray *types = @[NSLocalizedString(@"最新", nil),NSLocalizedString(@"政策", nil),NSLocalizedString(@"币圈", nil),NSLocalizedString(@"链圈", nil),NSLocalizedString(@"矿圈", nil)];
        [_infoTypesView initButtonsViewWithTitles:types Width:ScreenWidth Height:40];
        _infoTypesView.layer.borderColor = [UIColor lineGrayColor].CGColor;
        _infoTypesView.layer.borderWidth = 0.5;
        NSInteger index = 100;
        for (UIButton *btn in _infoTypesView.btnArray) {
            if(index == 100){
                [_infoTypesView setBtnSelected:btn];
            }
            
            btn.tag = index;
            index++;
            [btn addTarget:self action:@selector(selectType:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [self.view addSubview:_infoTypesView];
        [_infoTypesView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(SafeAreaTopHeight);
            make.left.right.equalTo(0);
            make.height.equalTo(40);
        }];
    }
}
-(void)selectType:(UIButton *)btn{
    [_infoTypesView setBtnSelected:btn];
    self.currentIndex = btn.tag - 100 + 1;
    [self.tableView beginHeaderRefresh];
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
    return 150;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([CreateAll isLogin]) {
        InfoListModel *datamodel = [self.dataArray objectAtIndex:indexPath.row];
        NSString *username = [CreateAll GetCurrentUser].userId;
        __block NSString * dataid = datamodel.ID;
        MJWeakSelf
        [NetManager GetInfoDetailUserID:username NewsID:dataid CompletionHandler:^(id responseObj, NSError *error) {
            if (!error) {
                InfoBaseModel *model = [InfoBaseModel parse:responseObj];
                if (model.resultCode != 20000) {
                    [weakSelf.view showMsg:model.resultMsg];
                }else{
                    IndoDetailModel *data = [IndoDetailModel parse:model.data];
                    dispatch_async_on_main_queue(^{
                        InfoWebVC *vc = [InfoWebVC new];
                        vc.urlstring = data.url;
                        vc.iscollected = data.collect;
                        vc.newsid = dataid;
                        [self.navigationController pushViewController:vc animated:YES];
                    });
                }
            }else{
                [weakSelf.view showMsg:error.userInfo.description];
            }
        }];
        
    }else{
        
    }
   
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsListCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row < self.dataArray.count) {
        InfoListModel *datamodel = [self.dataArray objectAtIndex:indexPath.row];
        [cell.titlelb setText:VALIDATE_STRING(datamodel.title)];
        [cell.contentlb setText:VALIDATE_STRING(datamodel.descNew)];
        [cell.timelb setText:VALIDATE_STRING(datamodel.postDate)];
        [cell.cellImageView sd_setImageWithURL:datamodel.image.STR_URLString];
        [cell.iconImageView sd_setImageWithURL:datamodel.avatar.STR_URLString];
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
        UIView *view = [[UIView alloc] init];
        _tableView.tableFooterView = view;
        [_tableView registerClass:[NewsListCell class] forCellReuseIdentifier:@"NewsListCell"];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.infoTypesView.mas_bottom).equalTo(0);
            make.left.right.equalTo(0);
            make.bottom.equalTo(0);
        }];
    }
    return _tableView;
}
@end
