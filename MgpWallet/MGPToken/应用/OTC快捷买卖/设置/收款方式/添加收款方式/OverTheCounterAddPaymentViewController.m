//
//  OverTheCounterAddPaymentViewController.m
//  TaiYiToken
//
//  Created by mac on 2020/12/30.
//  Copyright © 2020 admin. All rights reserved.
//

#import "OverTheCounterAddPaymentViewController.h"

@interface OverTheCounterAddPaymentViewController ()
@property (strong,nonatomic)NSMutableArray *cellArr0;
@property (strong,nonatomic)NSString *imageUrl;
@property (nonatomic, weak) XFDialogFrame *dialogView;

@end

@implementation OverTheCounterAddPaymentViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.payType == 1) {
        self.Jh_navTitle = NSLocalizedString(@"银行卡", nil);
    }else if (self.payType == 2){
        self.Jh_navTitle = NSLocalizedString(@"微信", nil);
    }else{
        self.Jh_navTitle = NSLocalizedString(@"支付宝", nil);
    }
    if (self.model) {
        self.Jh_navRightTitle =@"删除";
        self.JhClickNavRightItemBlock = ^{
            
            WEAKSELF; //
            NSDictionary *attrs = @{XFDialogNoticeText:NSLocalizedString(@"您确定要删除联系方式吗?", nil), XFDialogCancelButtonTitle: NSLocalizedString(@"取消", nil), XFDialogCommitButtonTitle: NSLocalizedString(@"确定", nil),XFDialogTitleViewBackgroundColor:[UIColor orangeColor]};
            
            self.dialogView = [[[XFDialogNotice dialogWithTitle:NSLocalizedString(@"删除联系方式", nil) attrs:attrs commitCallBack:^(NSString *inputText) {
                            
                [weakSelf.dialogView hideWithAnimationBlock:nil];
                [[MGPHttpRequest shareManager]post:@"/moPayInfo/del" isNewPath:YES paramters:@{@"payInfoId":self.model[@"payInfoId"]} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
                    if ([responseObj[@"code"]intValue] == 0) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    
                }];
                
                
            }] showWithAnimationBlock:nil]setCancelCallBack:nil];
            
            

        };
    }
    [self initModel];
}
#pragma mark - initModel
-(void)initModel{
    __weak typeof(self) weakSelf = self;
    NSArray *arr = @[
        @{@"key":NSLocalizedString(@"姓名", nil),@"value":NSLocalizedString(@"请输入", nil),@"idStr":VALIDATE_STRING(self.model[@"username"])},
        @{@"key":NSLocalizedString(@"账号", nil),@"value":NSLocalizedString(@"请输入", nil),@"idStr":VALIDATE_STRING(self.model[@"cardNum"])},
    ];
    if (self.payType == 1) {
        arr = @[
            @{@"key":NSLocalizedString(@"姓名", nil),@"value":NSLocalizedString(@"请输入", nil),@"idStr":VALIDATE_STRING(self.model[@"username"])},
            @{@"key":NSLocalizedString(@"银行卡号", nil),@"value":NSLocalizedString(@"请输入", nil),@"idStr":VALIDATE_STRING(self.model[@"cardNum"])},
            @{@"key":NSLocalizedString(@"银行名称", nil),@"value":NSLocalizedString(@"请输入", nil),@"idStr":VALIDATE_STRING(self.model[@"name"])},
            @{@"key":NSLocalizedString(@"开户支行", nil),@"value":NSLocalizedString(@"请输入", nil),@"idStr":VALIDATE_STRING(self.model[@"branch"])},
        ];
    }
    
    
    _cellArr0 = [NSMutableArray array];
    for (int i = 0; i<arr.count; i++) {
        NSDictionary *dic = arr[i];
        //默认文本居左可编辑
        JhFormCellModel *cell = JhFormCellModel_AddInputCell(dic[@"key"], @"", YES, UIKeyboardTypeDefault);
        cell.Jh_placeholder = dic[@"value"];
        cell.Jh_InfoTextAlignment = JhFormCellInfoTextAlignmentRight;
        cell.Jh_info = self.model != nil ? dic[@"idStr"] : @"";
        [_cellArr0 addObject:cell];
    }
    
    if (self.payType != 1) {
        JhFormCellModel *cell7 = JhFormCellModel_AddImageCell(NSLocalizedString(@"添加收款二维码", nil), NO);
        cell7.Jh_maxImageCount = 1;
        cell7.Jh_required = YES;
        if (self.model){
            cell7.Jh_imageArr = @[[NSURL URLWithString:self.model[@"qrCode"]]];
        }
        
        [_cellArr0 addObject:cell7];
    }
    
    JhFormSectionModel *section0 = JhSectionModel_Add(_cellArr0);
    [self.Jh_formModelArr addObject:section0];
    self.Jh_submitStr = self.model == nil ? NSLocalizedString(@"提 交", nil) : NSLocalizedString(@"修 改", nil);

    
     self.Jh_formSubmitBlock = ^{
         NSLog(@" 点击提交按钮 ");
         // 这里只是简单描述校验逻辑，可根据自身需求封装数据校验逻辑
         [JhFormHandler Jh_checkFormNullDataWithWithDatas:weakSelf.Jh_formModelArr success:^{
             
             if (self.payType == 1) {
                 [self.view showHUD];
                 JhFormSectionModel *temp = self.Jh_formModelArr.firstObject;
                 JhFormCellModel *cell0 = temp.Jh_sectionModelArr[0];
                 JhFormCellModel *cell1 = temp.Jh_sectionModelArr[1];
                 JhFormCellModel *cell2 = temp.Jh_sectionModelArr[2];
                 JhFormCellModel *cell3 = temp.Jh_sectionModelArr[3];
                 
                 NSDictionary *p = @{@"payId":@"1",
                                     @"mgpName":[MGPHttpRequest shareManager].curretWallet.address,
                                     @"payInfoId":VALIDATE_STRING(self.model[@"payInfoId"]),
                                     @"username":cell0.Jh_info,
                                     @"cardNum":cell1.Jh_info,
                                     @"name":cell2.Jh_info,
                                     @"branch":cell3.Jh_info
                                     
                 };
                 
                 [[MGPHttpRequest shareManager]post:@"/moPayInfo/save" isNewPath:YES paramters:p completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
                     [self.view hideHUD];
                     if ([responseObj[@"code"]intValue] == 0) {
                         NSString *msg = self.model == nil ? NSLocalizedString(@"提交成功", nil) : NSLocalizedString(@"修改成功", nil);
                         [weakSelf.view showMsg:msg];
                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                             [weakSelf.navigationController popViewControllerAnimated:YES];
                         });
                     }

                 }];
             }else{
                 [self SubmitRequest];
             }
             
             
             
         } failure:^(NSString *error) {
             NSLog(@"error====%@",error);
             [weakSelf.view showMsg:error];
         }];
         
     };
    
}
#pragma mark - 提交请求
-(void)SubmitRequest{
    [self.view showHUD];
    WEAKSELF
    JhFormSectionModel *temp = self.Jh_formModelArr.firstObject;
    JhFormCellModel *cell0 = temp.Jh_sectionModelArr[0];
    JhFormCellModel *cell1 = temp.Jh_sectionModelArr[1];

    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);//
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        JhFormCellModel *cell8 = temp.Jh_sectionModelArr[2];
        [[MGPHttpRequest shareManager]post:@"/file/uploadFile" isNew:YES andImages:cell8.Jh_selectImageArr completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
            dispatch_group_leave(group);
            if ([responseObj[@"code"]intValue] == 0) {
                weakSelf.imageUrl = [responseObj[@"data"]objectForKey:@"url"];
            }
        }];
        
    });
    
    //二个网络请求都完成统一处理
    dispatch_group_notify(group, queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{

            NSString *payTypeStr = weakSelf.payType == 2 ? @"微信支付" : @"支付宝";
            NSMutableDictionary *parm = [NSMutableDictionary dictionaryWithDictionary:@{
                @"mgpName":[MGPHttpRequest shareManager].curretWallet.address,
                @"payInfoId":VALIDATE_STRING(self.model[@"payInfoId"]),
                @"username":cell0.Jh_info,
                @"cardNum":cell1.Jh_info,
                @"name":payTypeStr,
                @"payId":@(weakSelf.payType),
                @"qrCode":self.imageUrl,
            }];
            
           NSString *urlStr =  @"/moPayInfo/save";
           [[MGPHttpRequest shareManager]post:urlStr isNewPath:YES paramters:parm completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
               [MBProgressHUD hideHUDForView:self.view animated:YES];
               [self.view showHUD];

               if ([responseObj[@"code"]intValue] == 0) {
                   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                       [self.navigationController popViewControllerAnimated:YES];

                   });
               }else{
                   [weakSelf.view showMsg:responseObj[@"msg"]];
               }
           }];
            
        });

    });
        
    
    
   
    
    
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
