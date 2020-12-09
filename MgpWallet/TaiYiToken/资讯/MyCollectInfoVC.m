//
//  MyCollectInfoVC.m
//  TaiYiToken
//
//  Created by 张元一 on 2019/4/2.
//  Copyright © 2019 admin. All rights reserved.
//

#import "MyCollectInfoVC.h"
#import "NewsListCell.h"
#import "InfoModels.h"
#import "InfoWebVC.h"
@interface MyCollectInfoVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UIButton *backBtn;
@property(nonatomic)UILabel *titleLabel;
@property(nonatomic)UITableView *tableView;
@property(nonatomic,strong)UIButton *editBtn;
@property(nonatomic,strong)NSMutableArray <InfoListModel *> *dataArray;
@property(nonatomic,assign)NSInteger currentPage;
@property (strong, nonatomic) UIView   *editingView;
@end

@implementation MyCollectInfoVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    self.navigationController.hidesBottomBarWhenPushed = YES;
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.hidesBottomBarWhenPushed = NO;
    self.tabBarController.tabBar.hidden = NO;
}
- (void)popAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSMutableArray new];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initHeadView];
    
    MJWeakSelf
    [self.tableView addHeaderRefresh:^{
        weakSelf.currentPage = 1;
        NSString *username = [CreateAll GetCurrentUser].userId;
        [NetManager GetInfoCollectionListUserID:username CurrentPage:weakSelf.currentPage CompletionHandler:^(id responseObj, NSError *error) {
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
        NSString *username = [CreateAll GetCurrentUser].userId;
        [NetManager GetInfoCollectionListUserID:username CurrentPage:weakSelf.currentPage CompletionHandler:^(id responseObj, NSError *error) {
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
//    [self.tableView beginHeaderRefresh];
    [self.view addSubview:self.editingView];
    [self.editingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@45);
        make.bottom.equalTo(self.view).offset(45);
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
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.backgroundColor = [UIColor clearColor];
    _backBtn.tintColor = [UIColor whiteColor];
    [_backBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [_backBtn setImage:[UIImage imageNamed:@"ico_right_arrow"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backBtn];
    _backBtn.userInteractionEnabled = YES;
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(SafeAreaTopHeight - 34);
        make.height.equalTo(25);
        make.left.equalTo(10);
        make.width.equalTo(30);
    }];
    
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont boldSystemFontOfSize:17];
    _titleLabel.textColor = [UIColor textBlackColor];
    [_titleLabel setText:[NSString stringWithFormat:NSLocalizedString(@"我的收藏", nil)]];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(SafeAreaTopHeight - 30);
        make.centerX.equalTo(0);
        make.width.equalTo(150);
        make.height.equalTo(20);
    }];
    
    _editBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _editBtn.tintColor = [UIColor darkGrayColor];
    _editBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_editBtn setTitle:NSLocalizedString(@"编辑", nil) forState:UIControlStateNormal];
    [_editBtn addTarget:self action:@selector(editCollections:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_editBtn];
    [_editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(SafeAreaTopHeight - 30);
        make.right.equalTo(-10);
        make.width.equalTo(50);
        make.height.equalTo(20);
    }];
}

-(void)editCollections:(UIButton *)btn{
    [btn setSelected:!btn.isSelected];
    [self.tableView setEditing:btn.isSelected animated:YES];
    [self showEitingView:btn.isSelected];
}


- (void)showEitingView:(BOOL)isShow{
    [self.editingView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(isShow?0:45);
    }];
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)p__buttonClick:(UIButton *)sender{
    if ([[sender titleForState:UIControlStateNormal] isEqualToString:NSLocalizedString(@"删除", nil)]) {
        NSMutableIndexSet *insets = [[NSMutableIndexSet alloc] init];
        __block NSString *IDsToDelete = @"";
        MJWeakSelf
        [[self.tableView indexPathsForSelectedRows] enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([IDsToDelete isEqualToString:@""]) {
                IDsToDelete = [IDsToDelete stringByAppendingString:[NSString stringWithFormat:@"%@",weakSelf.dataArray[obj.row].ID]];
            }else{
                IDsToDelete = [IDsToDelete stringByAppendingString:[NSString stringWithFormat:@",%@",weakSelf.dataArray[obj.row].ID]];
            }
            [insets addIndex:obj.row];
        }];
        NSLog(@"%@",IDsToDelete);
        NSString *username = [CreateAll GetCurrentUser].userId;
        [NetManager GetInfoDelBatchCollectionUserID:username NewsID:IDsToDelete CompletionHandler:^(id responseObj, NSError *error) {
            if (!error) {
                InfoBaseModel *model = [InfoBaseModel parse:responseObj];
                if (model.resultCode != 20000) {
                    [weakSelf.view showMsg:model.resultMsg];
                }else{
                    [weakSelf.view showMsg:NSLocalizedString(@"取消收藏成功", nil)];
                }
            }else{
                [weakSelf.view showMsg:error.userInfo.description];
            }
        }];
        [self.dataArray removeObjectsAtIndexes:insets];
        [self.tableView deleteRowsAtIndexPaths:[self.tableView indexPathsForSelectedRows] withRowAnimation:UITableViewRowAnimationFade];
        
        /** 数据清空情况下取消编辑状态*/
        if (self.dataArray.count == 0) {
            self.navigationItem.rightBarButtonItem.title = NSLocalizedString(@"编辑", nil);
            [self.tableView setEditing:NO animated:YES];
            [self showEitingView:NO];
            /** 带MJ刷新控件重置状态
             [self.tableView.footer resetNoMoreData];
             [self.tableView reloadData];
             */
            
        }
        
    }else if ([[sender titleForState:UIControlStateNormal] isEqualToString:NSLocalizedString(@"全选", nil)]) {
        [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        }];
        
        [sender setTitle:NSLocalizedString(@"全不选", nil) forState:UIControlStateNormal];
    }else if ([[sender titleForState:UIControlStateNormal] isEqualToString:NSLocalizedString(@"全不选", nil)]){
        [self.tableView reloadData];
        /** 遍历反选
         [[self.tableView indexPathsForSelectedRows] enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         [self.tableView deselectRowAtIndexPath:obj animated:NO];
         }];
         */
        
        [sender setTitle:NSLocalizedString(@"全选", nil) forState:UIControlStateNormal];
        
    }
}



#pragma tableView
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.tableView deleteRow:indexPath.row inSection:indexPath.section withRowAnimation:UITableViewRowAnimationFade];
    }
}

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
    if (self.tableView.isEditing) {
        return;
    }
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
        //        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
      
        UIView *view = [[UIView alloc] init];
        _tableView.tableFooterView = view;
        [_tableView registerClass:[NewsListCell class] forCellReuseIdentifier:@"NewsListCell"];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(SafeAreaTopHeight);
            make.left.right.equalTo(0);
            make.bottom.equalTo(0);
        }];
    }
    return _tableView;
}


- (UIView *)editingView{
    if (!_editingView) {
        _editingView = [[UIView alloc] init];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor redColor];
        [button setTitle:NSLocalizedString(@"删除", nil) forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(p__buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_editingView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(self.editingView);
            make.width.equalTo(self.editingView).multipliedBy(0.5);
        }];
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor darkGrayColor];
        [button setTitle:NSLocalizedString(@"全选", nil) forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(p__buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_editingView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.equalTo(self.editingView);
            make.width.equalTo(self.editingView).multipliedBy(0.5);
        }];
    }
    return _editingView;
}

@end
