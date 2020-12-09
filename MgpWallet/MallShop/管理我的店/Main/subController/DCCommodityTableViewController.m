//
//  DCCommodityTableViewController.m
//  TaiYiToken
//
//  Created by mac on 2020/8/7.
//  Copyright © 2020 admin. All rights reserved.
//

#import "DCCommodityTableViewController.h"
#import "DCCommodityTableViewCell.h"
#import "DCCommodityModel.h"
#import "MyCommodityViewController.h"

static NSString *const DCCommodityTableViewCellID = @"DCCommodityTableViewCell";

@interface DCCommodityTableViewController ()

@property(strong, nonatomic)NSMutableArray *listArray;
@property (nonatomic, weak) XFDialogFrame *dialogView;

@end

@implementation DCCommodityTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DCCommodityTableViewCell class]) bundle:nil] forCellReuseIdentifier:DCCommodityTableViewCellID];
   self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = 100;
   self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
   self.tableView.showsVerticalScrollIndicator = NO;
   [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 65, 0)];

   self.tableView.mj_header = [DCHomeRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(setUpData)];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
    
}

#pragma mark - 获取数据
- (void)setUpData
{
    _listArray = [NSMutableArray array];
    [[MGPHttpRequest shareManager]post:@"/appStoreProduct/merPro" paramters:@{@"address":[MGPHttpRequest shareManager].curretWallet.address,@"type":@(_type)} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
        if ([responseObj[@"code"]intValue] == 0) {
            for (NSDictionary *dic in responseObj[@"data"]) {
                DCCommodityModel *model = [DCCommodityModel mj_objectWithKeyValues:dic];
                [self.listArray addObject:model];
            }
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }];

    
    
    
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return self.listArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DCCommodityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DCCommodityTableViewCellID forIndexPath:indexPath];
    cell.model = self.listArray[indexPath.section];
    cell.button1.hidden = NO;
    cell.button2.hidden = YES;

    switch (_type) {
        case DCCommodityOnSale: //销售中
            [cell.button1 setTitle:NSLocalizedString(@"下架", nil) forState:UIControlStateNormal];
            break;
        case DCCommoditySoldEmpty://已售空
            cell.button1.hidden = YES;
            cell.button2.hidden = NO;
            break;
        case DCCommodityExamine://审核中
            [cell.button1 setTitle:NSLocalizedString(@"审核中", nil) forState:UIControlStateNormal];
            cell.button1.layer.borderColor = [UIColor clearColor].CGColor;
            break;
        case DCCommodityInWarehouse://仓库中
            [cell.button1 setTitle:NSLocalizedString(@"上架", nil) forState:UIControlStateNormal];
            cell.button2.hidden = NO;
            break;
        default:
            break;
    }
    
    cell.button1.tag = indexPath.section;
    [cell.button1 addTarget:self action:@selector(upDownClick:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.button2.tag = indexPath.section;
    [cell.button2 addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MyCommodityViewController *vc = [MyCommodityViewController new];
    vc.model = self.listArray[indexPath.section];
    vc.collectionBlock = ^{
        [self.tableView.mj_header beginRefreshing];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}
- (void)upDownClick:(UIButton *)btn{
    if (self.type == DCCommodityExamine) {return;}
    DCCommodityModel *model = self.listArray[btn.tag];
    [[MGPHttpRequest shareManager]post:@"/appStoreProduct/upDown" paramters:@{@"address":[MGPHttpRequest shareManager].curretWallet.address,@"type":_type == DCCommodityOnSale ? @(NO) : @(YES),@"proID":@(model.proID)} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
        if ([responseObj[@"code"]intValue] == 0) {
            [self.tableView.mj_header beginRefreshing];
            [self.view showMsg:self.type == DCCommodityOnSale ? NSLocalizedString(@"下架成功", nil) : NSLocalizedString(@"上架成功", nil)];
            [self.tableView.mj_header beginRefreshing];

        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }];
}
- (void)deleteClick:(UIButton *)btn{
WEAKSELF
   self.dialogView = [[XFDialogNotice dialogWithTitle:NSLocalizedString(@"温馨提示", nil)
            attrs:@{
                    XFDialogMaskViewAlpha:@(0.f),
                    XFDialogEnableBlurEffect:@YES,
                    XFDialogTitleColor: [UIColor blackColor],
                    XFDialogNoticeText: NSLocalizedString(@"删除", nil),
                    }
   commitCallBack:^(NSString *inputText) {
       [weakSelf.dialogView hideWithAnimationBlock:nil];
       DCCommodityModel *model = self.listArray[btn.tag];
       [[MGPHttpRequest shareManager]post:@"appStoreProduct/delPro" paramters:@{@"address":[MGPHttpRequest shareManager].curretWallet.address,@"proID":@(model.proID)} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
           if ([responseObj[@"code"]intValue] == 0) {
               [self.tableView.mj_header beginRefreshing];
               [self.view showMsg:NSLocalizedString(@"删除成功", nil)];
               [self.tableView.mj_header beginRefreshing];

           }
           [self.tableView.mj_header endRefreshing];
           [self.tableView reloadData];
       }];
       
   }] showWithAnimationBlock:nil];
    
    
}

//
////
//- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
//return UITableViewCellEditingStyleDelete;
//  }
 //然后是添加多个操作：
//设置滑动时显示多个按钮
//- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    UITableViewRowAction *action2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"action2" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//
//
//
//    }];
//    return @[action2];
//
//
//
//}
//使用系统默认的删除按钮
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete){

 }
}
//自定义系统默认的删除按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"自定义按钮";
}



/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
