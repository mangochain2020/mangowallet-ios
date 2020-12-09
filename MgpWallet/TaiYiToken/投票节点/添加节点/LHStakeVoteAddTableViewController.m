//
//  LHStakeVoteAddTableViewController.m
//  TaiYiToken
//
//  Created by mac on 2020/11/17.
//  Copyright © 2020 admin. All rights reserved.
//

#import "LHStakeVoteAddTableViewController.h"

@interface LHStakeVoteAddTableViewController ()

@property (strong,nonatomic)NSMutableArray *cellArr0;

@end

@implementation LHStakeVoteAddTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self initModel];
    self.Jh_formTableView.rowHeight = 55;
    
    
    
}

-(void)dealloc{
    NSLog(@" FormDemo1VC - dealloc ");
}
#pragma mark - initModel
-(void)initModel{

    
    __weak typeof(self) weakSelf = self;
    NSArray *arr = @[
        @{@"key":NSLocalizedString(@"名称", nil),@"value":NSLocalizedString(@"请输入节点名称", nil),@"idStr":@""},
        @{@"key":NSLocalizedString(@"奖励比例", nil),@"value":NSLocalizedString(@"分配给投票者的比率(1-100)", nil),@"idStr":@(0)},
        @{@"key":NSLocalizedString(@"节点", nil),@"value":NSLocalizedString(@"请输入节点", nil),@"idStr":@(0)},
    ];


    _cellArr0 = [NSMutableArray array];
    for (int i = 0; i<arr.count; i++) {
        NSDictionary *dic = arr[i];
        //默认文本居左可编辑
        
        JhFormCellModel *cell = JhFormCellModel_AddInputCell(dic[@"key"], @"", YES, (i <= 0 || (i == arr.count-1))? UIKeyboardTypeDefault : UIKeyboardTypeDecimalPad);
        cell.Jh_placeholder = dic[@"value"];
        if (i == 1) {
            cell.Jh_maxInputLength = 3;
        }
        cell.Jh_InfoTextAlignment = JhFormCellInfoTextAlignmentRight;
        [_cellArr0 addObject:cell];
    }

    JhFormCellModel *cell6 = JhFormCellModel_Add(NSLocalizedString(@"节点奖励规则", nil), @"", JhFormCellTypeTextViewInput, YES, YES, UIKeyboardTypeDefault);
    cell6.Jh_placeholder = NSLocalizedString(@"请输入节点奖励规则", nil);
    cell6.Jh_maxInputLength = 150;
    cell6.Jh_showLength = YES;//默认不显示
    [_cellArr0 addObject:cell6];
    
    
    JhFormCellModel *cell8 = JhFormCellModel_Add(NSLocalizedString(@"社群介绍", nil), @"", JhFormCellTypeTextViewInput, YES, YES, UIKeyboardTypeDefault);
    cell8.Jh_placeholder = NSLocalizedString(@"请输入社群介绍(可选)", nil);
    cell8.Jh_maxInputLength = 150;
    cell8.Jh_showLength = YES;//默认不显示
    cell8.Jh_required = NO;
    [_cellArr0 addObject:cell8];

    
    JhFormCellModel *cell7 = JhFormCellModel_AddImageCell(NSLocalizedString(@"节点封面", nil), NO);
    cell7.Jh_maxImageCount = 1;
    cell7.Jh_required = YES;
    [_cellArr0 addObject:cell7];

    
    JhFormSectionModel *section0 = JhSectionModel_Add(_cellArr0);
    [self.Jh_formModelArr addObject:section0];
    self.Jh_submitStr = [NSString stringWithFormat:@"%@(%d)MGP",NSLocalizedString(@"支付", nil),_min_bp_list_quantity];
    self.Jh_navTitle = NSLocalizedString(@"添加节点", nil);

    if (_min_bp_list_quantity <= 0) {
        self.Jh_submitStr = NSLocalizedString(@"提交", nil);
        self.Jh_navTitle = NSLocalizedString(@"编辑节点", nil);

    }
    
     self.Jh_formSubmitBlock = ^{
         NSLog(@" 点击提交按钮 ");
         // 这里只是简单描述校验逻辑，可根据自身需求封装数据校验逻辑
         [JhFormHandler Jh_checkFormNullDataWithWithDatas:weakSelf.Jh_formModelArr success:^{
             
             [weakSelf SubmitRequest];
             
         } failure:^(NSString *error) {
             NSLog(@"error====%@",error);
             [weakSelf.view showMsg:error];
         }];
         
     };
    
    
 
}
- (void)SubmitRequest{
    if (_min_bp_list_quantity <= 0) {
        [self uploadNodeMsg:@"0x"];

    }else{
        JhFormSectionModel *temp = self.Jh_formModelArr.firstObject;
        JhFormCellModel *cell1 = temp.Jh_sectionModelArr[1];
        NSString *nodeShareRatio = [NSString stringWithFormat:@"%.f",[cell1.Jh_info doubleValue] * 100];

        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"请输入密码！", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
            textField.placeholder = NSLocalizedString(@"密码(8-18位字符)", nil);
            textField.secureTextEntry = YES;
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            UITextField *pass = alertController.textFields.firstObject;
            NSString *mgp_bpvoting = [[DomainConfigManager share]getCurrentEvnDict][bpvoting];

            
            [[DCMGPWalletTool shareManager]transferAmount:[NSString stringWithFormat:@"%d",self.min_bp_list_quantity] andFrom:[MGPHttpRequest shareManager].curretWallet.address andTo:mgp_bpvoting andMemo:[NSString stringWithFormat:@"list:%@",nodeShareRatio] andPassWord:VALIDATE_STRING(pass.text) completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
                
                if (responseObj) {
                    NSString *hash = responseObj;
                    [self uploadNodeMsg:hash];
                }
                
            }];
            
            
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    
    
    
}
- (void)uploadNodeMsg:(NSString *)hash{
    JhFormSectionModel *temp = self.Jh_formModelArr.firstObject;
    JhFormCellModel *cell0 = temp.Jh_sectionModelArr[0];
    JhFormCellModel *cell1 = temp.Jh_sectionModelArr[1];
    JhFormCellModel *cell2 = temp.Jh_sectionModelArr[2];
    JhFormCellModel *cell3 = temp.Jh_sectionModelArr[3];
    JhFormCellModel *cell4 = temp.Jh_sectionModelArr[4];
    if ([cell1.Jh_info doubleValue] < 0 || [cell1.Jh_info doubleValue] > 100) {
        [self.view showMsg:NSLocalizedString(@"请输入正确的比率", nil)];
        return;
    }
    NSString *nodeShareRatio = [NSString stringWithFormat:@"%.f",[cell1.Jh_info doubleValue] * 100];

    JhFormCellModel *cell8 = temp.Jh_sectionModelArr[5];
    [[MGPHttpRequest shareManager]post:@"/file/upload" andImages:cell8.Jh_selectImageArr completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {

        if ([responseObj[@"code"]intValue] == 0) {
            NSArray *temp = responseObj[@"data"];
            NSDictionary *dic = @{
                @"nodeName":cell0.Jh_info,
                @"nodeShareRatio":nodeShareRatio,
                @"nodeUrl":cell2.Jh_info,
                @"nodeRewardRule":cell4.Jh_info,
                @"nodeContent":cell3.Jh_info,
                @"nodeHeadImg":temp.firstObject,
                @"mgpAddress":[MGPHttpRequest shareManager].curretWallet.address,
                @"hash":hash
            };
            
            [[MGPHttpRequest shareManager]post:@"/voteNode/uploadNodeMsg" paramters:dic completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {

                if ([responseObj[@"code"]intValue] == 0) {
                    [self.view showMsg:responseObj[@"msg"]];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    });
                    
                }
                                        
            }];


        }
    }];
    
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
