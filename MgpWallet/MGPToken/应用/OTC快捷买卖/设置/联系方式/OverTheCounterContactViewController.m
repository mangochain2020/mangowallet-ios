//
//  OverTheCounterContactViewController.m
//  TaiYiToken
//
//  Created by mac on 2020/12/30.
//  Copyright © 2020 admin. All rights reserved.
//

#import "OverTheCounterContactViewController.h"

@interface OverTheCounterContactViewController ()

@property (weak, nonatomic) IBOutlet UILabel *emailLabelL;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabelL;
@property (weak, nonatomic) IBOutlet UILabel *wechatLabelL;

@property (weak, nonatomic) IBOutlet UITextField *emailLabelR;
@property (weak, nonatomic) IBOutlet UITextField *phoneLabelR;
@property (weak, nonatomic) IBOutlet UITextField *wechatLabelR;
@property (strong, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation OverTheCounterContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"联系方式", nil);
    self.tableView.tableFooterView = [UIView new];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(phoneTextDidEnd) name:UITextFieldTextDidEndEditingNotification object:self.phoneLabelR];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatTextDidEnd) name:UITextFieldTextDidEndEditingNotification object:self.wechatLabelR];

    
}
- (void)phoneTextDidEnd{
    if (self.phoneLabelR.text.length > 0) {
        [self saveUserData:YES];
    }
}
- (void)wechatTextDidEnd{
    if (self.wechatLabelR.text.length > 0) {
        [self saveUserData:NO];
    }
}

- (void)saveUserData:(BOOL)isPhone{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"mgpName":[MGPHttpRequest shareManager].curretWallet.address}];
    if (isPhone) {
        [dic setValue:self.phoneLabelR.text forKey:@"phone"];
        [dic setValue:@"1" forKey:@"type"];

    }else{
        [dic setValue:self.wechatLabelR.text forKey:@"weixin"];
        [dic setValue:@"2" forKey:@"type"];
    }
    
    
    [[MGPHttpRequest shareManager]post:@"/moUsers/save" isNewPath:YES paramters:dic completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
        if ([responseObj[@"code"]intValue] == 0) {
            [self.view showMsg:NSLocalizedString(@"保存成功", nil)];
        }
        
    }];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[MGPHttpRequest shareManager]post:@"/moUsers/find" isNewPath:YES paramters:@{@"mgpName":[MGPHttpRequest shareManager].curretWallet.address} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
        if ([responseObj[@"code"]intValue] == 0 && responseObj[@"data"] != nil) {
            
            NSDictionary *parm = responseObj[@"data"];
            self.emailLabelR.text = VALIDATE_STRING(parm[@"mail"]);
            self.phoneLabelR.text = VALIDATE_STRING(parm[@"phone"]);
            self.wechatLabelR.text = VALIDATE_STRING(parm[@"weixin"]);
        }
        
    }];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return [super numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return [super tableView:tableView numberOfRowsInSection:section];
}

/*
#pragma mark - initModel
-(void)initModel:(NSString *)phone andMail:(NSString *)mail andWeixin:(NSString *)weixin{
    __weak typeof(self) weakSelf = self;
    NSArray *arr = @[
        @{@"key":NSLocalizedString(@"手机号码", nil),@"value":NSLocalizedString(@"请输入", nil),@"idStr":phone},
        @{@"key":NSLocalizedString(@"微信号", nil),@"value":NSLocalizedString(@"请输入", nil),@"idStr":weixin},
        @{@"key":NSLocalizedString(@"邮箱号", nil),@"value":NSLocalizedString(@"请输入", nil),@"idStr":mail},
    ];
    
    _cellArr0 = [NSMutableArray array];
    for (int i = 0; i<arr.count; i++) {
        NSDictionary *dic = arr[i];
        //默认文本居左可编辑
        JhFormCellModel *cell = JhFormCellModel_AddInputCell(dic[@"key"], @"", YES, i == 0 ? UIKeyboardTypeNumberPad : UIKeyboardTypeDefault);
        cell.Jh_placeholder = dic[@"value"];
        cell.Jh_InfoTextAlignment = JhFormCellInfoTextAlignmentRight;
        cell.Jh_info = dic[@"idStr"];
        [_cellArr0 addObject:cell];
    }
    JhFormSectionModel *section0 = JhSectionModel_Add(_cellArr0);
    [self.Jh_formModelArr addObject:section0];
    self.Jh_submitStr = phone.length <= 0 ? NSLocalizedString(@"提 交", nil) : NSLocalizedString(@"修 改", nil);

    
     self.Jh_formSubmitBlock = ^{
         NSLog(@" 点击提交按钮 ");
         [JhFormHandler Jh_checkFormNullDataWithWithDatas:weakSelf.Jh_formModelArr success:^{
             
             JhFormSectionModel *temp = weakSelf.Jh_formModelArr.firstObject;
             JhFormCellModel *cell0 = temp.Jh_sectionModelArr[0];
             JhFormCellModel *cell1 = temp.Jh_sectionModelArr[1];
             JhFormCellModel *cell2 = temp.Jh_sectionModelArr[2];

             [[MGPHttpRequest shareManager]post:@"/moUsers/save" isNewPath:YES paramters:@{@"mgpName":[MGPHttpRequest shareManager].curretWallet.address,@"mail":cell2.Jh_info,@"phone":cell0.Jh_info,@"weixin":cell1.Jh_info} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
                 if ([responseObj[@"code"]intValue] == 0) {
                     NSString *msg = phone.length <= 0 ? NSLocalizedString(@"提交成功", nil) : NSLocalizedString(@"修改成功", nil);
                     [weakSelf.view showMsg:msg];
                     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                         [weakSelf.navigationController popToRootViewControllerAnimated:YES];

                     });
                 }
                 
             }];
             
         } failure:^(NSString *error) {
             NSLog(@"error====%@",error);
             [weakSelf.view showMsg:error];
         }];
         
     };
    
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
