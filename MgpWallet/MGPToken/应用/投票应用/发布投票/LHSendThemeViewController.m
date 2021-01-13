//
//  LHSendThemeViewController.m
//  TaiYiToken
//
//  Created by mac on 2020/10/19.
//  Copyright © 2020 admin. All rights reserved.
//

#import "LHSendThemeViewController.h"

@interface LHSendThemeViewController ()

@property (strong,nonatomic)NSMutableArray *cellArr0;
@property (nonatomic, weak) XFDialogFrame *dialogView;
@property (copy,nonatomic)NSString *themeMoney;
@property(strong, nonatomic) NSNumber *currencyBalance; //当前余额


@end

@implementation LHSendThemeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.Jh_navTitle = self.dic == nil ? NSLocalizedString(@"发布方案", nil) : NSLocalizedString(@"修改方案", nil);

    self.Jh_formTableView.rowHeight = 55;
    [self initModel];

    
    MJWeakSelf
    //创建组队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_group_t group = dispatch_group_create();
    if (![[MGPHttpRequest shareManager].curretWallet.walletName isEqualToString:@"MGP_"]) {
       //组任务1
        dispatch_group_enter(group);//
        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *name = [[MGPHttpRequest shareManager].curretWallet.walletName componentsSeparatedByString:@"_"].lastObject;
            NSDictionary *dic = @{@"account_name":name};
            [[HTTPRequestManager shareMgpManager] post:eos_get_account paramters:dic success:^(BOOL isSuccess, id responseObject) {
                dispatch_group_leave(group);

                if (isSuccess) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSString *balancestr = [(NSDictionary *)responseObject objectForKey:@"core_liquid_balance"];
                        NSString *valuestring = [balancestr componentsSeparatedByString:@" "].firstObject;
                        double balance = valuestring.doubleValue;
                        self.currencyBalance = @(balance);
                        
                    });
                    
                }
            } failure:^(NSError *error) {
                
            } superView:self.view showFaliureDescription:YES];
        });
        //组任务2
        dispatch_group_enter(group);//
        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[MGPHttpRequest shareManager]post:@"/voteTheme/getSchemeMoney" paramters:@{@"address":[MGPHttpRequest shareManager].curretWallet.address} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
                dispatch_group_leave(group);

                if ([responseObj[@"code"]intValue] == 0) {
                    self.themeMoney = [NSString stringWithFormat:@"%.f",[responseObj[@"data"]doubleValue]];
                    
                }
            }];
            
        });
        
        //二个网络请求都完成统一处理
        dispatch_group_notify(group, queue, ^{
            dispatch_async(dispatch_get_main_queue(), ^{

                if (self.currencyBalance.doubleValue < self.themeMoney.doubleValue) {
                    [self.view showMsg:NSLocalizedString(@"账户余额不足，无法发布方案", nil)];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }
            });
            
        });
        
    }
    
    
}

-(void)dealloc{
    NSLog(@" FormDemo1VC - dealloc ");
}

#pragma mark - initModel
-(void)initModel{
    __weak typeof(self) weakSelf = self;
    _cellArr0 = [NSMutableArray array];
    //默认文本居左可编辑
    JhFormCellModel *cell = JhFormCellModel_AddInputCell(@"方案名称", @"", YES, UIKeyboardTypeDefault);
    cell.Jh_placeholder = @"请输入方案名称";
    cell.Jh_InfoTextAlignment = JhFormCellInfoTextAlignmentRight;
    cell.Jh_info = self.dic != nil ? self.dic[@"voteTitle"] : @"";
    [_cellArr0 addObject:cell];
    
    JhFormCellModel *cell1 = JhFormCellModel_Add(NSLocalizedString(@"方案描述", nil), @"", JhFormCellTypeTextViewInput, YES, YES, UIKeyboardTypeDefault);
    cell1.Jh_placeholder = NSLocalizedString(@"请输入方案描述(字数不限)", nil);
    cell1.Jh_info = self.dic != nil ? self.dic[@"voteContent"] : @"";
    [_cellArr0 addObject:cell1];
    
    
    JhFormSectionModel *section0 = JhSectionModel_Add(_cellArr0);
    [self.Jh_formModelArr addObject:section0];
    self.Jh_submitStr = self.dic == nil ? NSLocalizedString(@"提 交", nil) : NSLocalizedString(@"修 改", nil);

    
     self.Jh_formSubmitBlock = ^{
         // 这里只是简单描述校验逻辑，可根据自身需求封装数据校验逻辑
         [JhFormHandler Jh_checkFormNullDataWithWithDatas:weakSelf.Jh_formModelArr success:^{
             
             [weakSelf SubmitRequest];
             
         } failure:^(NSString *error) {
             [weakSelf.view showMsg:error];
         }];
         
     };
    
    
}
-(void)SubmitRequest{
    
    JhFormSectionModel *temp = self.Jh_formModelArr.firstObject;
    JhFormCellModel *cell0 = temp.Jh_sectionModelArr[0];
    JhFormCellModel *cell1 = temp.Jh_sectionModelArr[1];

    NSDictionary *p = @{
        @"address":[MGPHttpRequest shareManager].curretWallet.address,
        @"voteTitle":cell0.Jh_info,
        @"voteContent":cell1.Jh_info,
        @"schemeContent":@"",
    };
    NSMutableDictionary *parm = [NSMutableDictionary dictionaryWithDictionary:p];
    if (self.dic != nil) {
        [parm setValue:self.dic[@"voteId"] forKey:@"voteId"];
    }
    NSString *urlStr = self.dic == nil ? @"/voteTheme/addTheme" : @"/voteTheme/update";

    [[MGPHttpRequest shareManager]post:urlStr paramters:parm completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
        
        if (self.dic) {
            if ([responseObj[@"code"]intValue] == 0) {
                [self.view showMsg:NSLocalizedString(@"编辑成功", nil)];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
        }else{
            if ([responseObj[@"code"]intValue] == 0) {
                [self inputPassWorldSubmit:[responseObj[@"data"]objectForKey:@"voteId"]];
            }
        }
        
    }];
    
    
}

- (void)inputPassWorldSubmit:(NSString *)voteId{
    WEAKSELF
    self.dialogView =
    [[XFDialogInput dialogWithTitle:[NSString stringWithFormat:@"支付【%@】MGP",self.themeMoney]
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
        
        NSString *amount = self.themeMoney;
        
        [[DCMGPWalletTool shareManager]transferAmount:amount andFrom:[MGPHttpRequest shareManager].curretWallet.address andTo:@"mgpchainvote" andMemo:[NSString stringWithFormat:@"%@,0",voteId] andPassWord:pwd completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
            
            if (responseObj) {
                NSDictionary *p = @{
                    @"hash":responseObj,
                    @"voteId":voteId,
                    @"money":amount
                };
                [[MGPHttpRequest shareManager]post:@"/voteTheme/upHash" paramters:p completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {

                    if ([responseObj[@"code"]intValue] == 0) {
                        [weakSelf.view showMsg:NSLocalizedString(@"发布成功", nil)];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [weakSelf.navigationController popViewControllerAnimated:YES];
                        });
                    }
                }];
                
            }
        }];
        
        } errorCallBack:nil] showWithAnimationBlock:nil];
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
