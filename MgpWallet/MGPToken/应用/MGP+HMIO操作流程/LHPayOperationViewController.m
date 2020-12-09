//
//  LHPayOperationViewController.m
//  TaiYiToken
//
//  Created by mac on 2020/9/23.
//  Copyright © 2020 admin. All rights reserved.
//

#import "LHPayOperationViewController.h"
#import "LHMyExcitationTableViewCell.h"
#import "OperationProcessTableViewController.h"

@interface LHPayOperationViewController ()

@property(weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong, nonatomic) NSMutableArray *listArray;
@property (nonatomic, weak) XFDialogFrame *dialogView;




@end

@implementation LHPayOperationViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"MGP支付", nil);
     self.tableView.tableFooterView = [UIView new];
    
    self.tableView.mj_header = [DCHomeRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(upRecData)];
    [self.tableView.mj_header beginRefreshing];
    
}

/// 加载数据
- (void)upRecData{
    self.listArray = [NSMutableArray array];
    [[MGPHttpRequest shareManager]post:@"/api/userOrder/blend/list" paramters:@{@"address":[MGPHttpRequest shareManager].curretWallet.address} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
        if ([responseObj[@"code"] intValue] == 0) {
            
            for (NSDictionary *dic in responseObj[@"data"]) {
                [self.listArray addObject:dic];
            }
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.listArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LHMyExcitationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LHPayOperationViewControllerIndex" forIndexPath:indexPath];
    
    NSDictionary *dic = self.listArray[indexPath.row];
    
    cell.money.text = [NSString stringWithFormat:@"%@%@",dic[@"num"],dic[@"payMoneyType"]];
    NSString *createStr = NSLocalizedString(@"扫描中", nil);
    switch ([dic[@"num"] intValue]) {
        case 0:
            createStr = NSLocalizedString(@"地址已复制", nil);
            break;
        default:
            break;
    }
    cell.createTime.text = dic[@"statusName"];
    cell.channelName.text = @"混合抵押进度";
    cell.channelImage.image = [dic[@"moneyType"] intValue] == 1 ? [UIImage imageNamed:@"MGP_coin"] : [UIImage imageNamed:@"ETH_coin"];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = self.listArray[indexPath.row];
    if ([dic[@"status"] intValue] == 2 || [dic[@"status"] intValue] == 3){
        if ([dic[@"moneyType"] intValue] == 1) {
            [self inputPassWorldSubmit:dic];
            
        }else{
            UIStoryboard* secondStoryboard = [UIStoryboard storyboardWithName:@"ExchangeHome" bundle:[NSBundle mainBundle]];
            OperationProcessTableViewController *vc = [secondStoryboard instantiateViewControllerWithIdentifier:@"OperationProcessTableViewController"];
            vc.transferType = transferHMIO_Two;
            vc.num = dic[@"num"];
            vc.payId = dic[@"id"];
            vc.moneyType = dic[@"moneyType"];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
    }
    
    
    
    
}


- (void)inputPassWorldSubmit:(NSDictionary *)dic{
    WEAKSELF
    self.dialogView =
    [[XFDialogInput dialogWithTitle:NSLocalizedString(@"请输入密码", nil)
                                 attrs:@{
                                         XFDialogTitleViewBackgroundColor : [UIColor orangeColor],
                                         XFDialogTitleColor: [UIColor whiteColor],
                                         XFDialogLineColor: [UIColor orangeColor],
                                         XFDialogInputFields:@[
                                                 @{
                                                     XFDialogInputPlaceholderKey : NSLocalizedString(@"输入8位数以上密码", nil),
                                                     XFDialogInputTypeKey : @(UIKeyboardTypeDefault),
                                                     XFDialogInputIsPasswordKey : @(YES),
                                                     XFDialogInputPasswordEye : @{
                                                             XFDialogInputEyeOpenImage : @"ic_eye",
                                                             XFDialogInputEyeCloseImage : @"ic_eye_close"
                                                             }
                                                     },
                                                 ],
                                         XFDialogInputHintColor : [UIColor purpleColor],
                                         XFDialogInputTextColor: [UIColor orangeColor],
                                         XFDialogCommitButtonTitleColor: [UIColor orangeColor]
                                         }
                        commitCallBack:^(NSString *inputText) {
                            [weakSelf.dialogView hideWithAnimationBlock:nil];

        NSArray *arr = (NSArray *)inputText;
        NSString *pwd = arr.firstObject;

        
        
        [[DCMGPWalletTool shareManager]transferAmount:dic[@"num"] andFrom:[MGPHttpRequest shareManager].curretWallet.address andTo:@"mgpchainhalf" andMemo:@"" andPassWord:pwd completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
            
            if (responseObj) {
                NSLog(@"responseObj -- %@",responseObj);
                [[MGPHttpRequest shareManager]post:@"/api/userOrder/blend/editHash" paramters:@{@"address":[MGPHttpRequest shareManager].curretWallet.address,@"moneyType":VALIDATE_STRING(dic[@"moneyType"]),@"hash":VALIDATE_STRING(responseObj),@"id":VALIDATE_STRING(dic[@"id"])} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
                    if ([responseObj[@"code"] intValue] == 0) {
                        [self.view showMsg:NSLocalizedString(@"提交完成", nil)];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self.navigationController popToRootViewControllerAnimated:YES];
                        });
                    }
                    [self.tableView reloadData];
                    [self.tableView.mj_header endRefreshing];
                }];
            }
        }];
        
        } errorCallBack:^(NSString *errorMessage) {
            NSLog(@"error -- %@",errorMessage);
            
        }] showWithAnimationBlock:nil];
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
