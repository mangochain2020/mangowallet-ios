//
//  SettlementViewController.m
//  TaiYiToken
//
//  Created by mac on 2020/9/7.
//  Copyright © 2020 admin. All rights reserved.
//

#import "SettlementViewController.h"
#import "MangoDefiAddViewController.h"

@interface SettlementViewController ()

@property (strong,nonatomic)NSMutableArray *cellArr0;

@property (strong,nonatomic)NSArray *image;
@property (strong,nonatomic)NSArray *image6;
@property (strong,nonatomic)NSArray *sliderImage;



@end

@implementation SettlementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.Jh_navTitle = NSLocalizedString(@"商家入驻", nil);
     self.Jh_formTableView.rowHeight = 55;
     [self initModel];

}

#pragma mark - initModel
-(void)initModel{

    __weak typeof(self) weakSelf = self;
    NSArray *arr = @[
        @{@"key":NSLocalizedString(@"真实姓名", nil),@"value":NSLocalizedString(@"请输入", nil)},
        @{@"key":NSLocalizedString(@"电话号码", nil),@"value":NSLocalizedString(@"请输入", nil)},
        @{@"key":NSLocalizedString(@"身份证号", nil),@"value":NSLocalizedString(@"请输入", nil)},
        @{@"key":NSLocalizedString(@"社会信用代码", nil),@"value":NSLocalizedString(@"请输入", nil)},
    ];


    _cellArr0 = [NSMutableArray array];
    for (int i = 0; i<arr.count; i++) {
        NSDictionary *dic = arr[i];
        //默认文本居左可编辑
        JhFormCellModel *cell = JhFormCellModel_AddInputCell(dic[@"key"], @"", YES, i != 1 ? UIKeyboardTypeDefault : UIKeyboardTypeDecimalPad);
        cell.Jh_placeholder = dic[@"value"];
        cell.Jh_InfoTextAlignment = JhFormCellInfoTextAlignmentRight;
        [_cellArr0 addObject:cell];

        
    }
    JhFormCellModel *cell7 = JhFormCellModel_AddImageCell(NSLocalizedString(@"身份证正反面", nil), NO);
    cell7.Jh_maxImageCount = 2;
    cell7.Jh_required = YES;
    [_cellArr0 insertObject:cell7 atIndex:3];
    
    JhFormCellModel *picture = JhFormCellModel_AddImageCell(NSLocalizedString(@"手持身份证", nil), NO);
    picture.Jh_maxImageCount = 1;
    picture.Jh_required = YES;
    [_cellArr0 insertObject:picture atIndex:4];

    
    JhFormCellModel *cell8 = JhFormCellModel_AddImageCell(NSLocalizedString(@"营业执照照片", nil), NO);
    cell8.Jh_maxImageCount = 1;
    cell8.Jh_required = YES;
    [_cellArr0 addObject:cell8];

    
    JhFormSectionModel *section0 = JhSectionModel_Add(_cellArr0);
    [self.Jh_formModelArr addObject:section0];
    self.Jh_submitStr = NSLocalizedString(@"下一步", nil);
    
    self.Jh_formSubmitBlock = ^{
        // 这里只是简单描述校验逻辑，可根据自身需求封装数据校验逻辑
        [JhFormHandler Jh_checkFormNullDataWithWithDatas:weakSelf.Jh_formModelArr success:^{
            
            [self SubmitRequest];
            
        } failure:^(NSString *error) {
            [weakSelf.view showMsg:error];
        }];
        
    };
    
    
}
#pragma mark - 提交请求
-(void)SubmitRequest{
    WEAKSELF
    JhFormSectionModel *temp = self.Jh_formModelArr.firstObject;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);//
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        JhFormCellModel *cell8 = temp.Jh_sectionModelArr[3];
        [[MGPHttpRequest shareManager]post:@"/file/upload" andImages:cell8.Jh_selectImageArr completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
            dispatch_group_leave(group);
            if ([responseObj[@"code"]intValue] == 0) {
                weakSelf.image = responseObj[@"data"];
            }
        }];
        
    });
    dispatch_group_enter(group);//
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        JhFormCellModel *cell9 = temp.Jh_sectionModelArr[4];
        [[MGPHttpRequest shareManager]post:@"/file/upload" andImages:cell9.Jh_selectImageArr completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
            dispatch_group_leave(group);
            if ([responseObj[@"code"]intValue] == 0) {
                weakSelf.sliderImage = responseObj[@"data"];
            }
        }];
        
    });
    dispatch_group_enter(group);//
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        JhFormCellModel *cell9 = temp.Jh_sectionModelArr[6];
        [[MGPHttpRequest shareManager]post:@"/file/upload" andImages:cell9.Jh_selectImageArr completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
            dispatch_group_leave(group);
            if ([responseObj[@"code"]intValue] == 0) {
                weakSelf.image6 = responseObj[@"data"];
            }
        }];
        
    });
    //二个网络请求都完成统一处理
    dispatch_group_notify(group, queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{

           JhFormCellModel *cell0 = temp.Jh_sectionModelArr[0];
           JhFormCellModel *cell1 = temp.Jh_sectionModelArr[1];
           JhFormCellModel *cell2 = temp.Jh_sectionModelArr[2];
           JhFormCellModel *cell5 = temp.Jh_sectionModelArr[5];
            
            NSMutableDictionary *parm = [NSMutableDictionary dictionaryWithDictionary:@{
                @"address":[MGPHttpRequest shareManager].curretWallet.address,
                @"userName":cell0.Jh_info,
                @"phone":cell1.Jh_info,
                @"identityCard":cell2.Jh_info,
                @"socialCode":cell5.Jh_info,
                @"businessLicense":[[MGPHttpRequest shareManager]arrayToJSONString:weakSelf.image6],
                @"identityCardPhoto":[[MGPHttpRequest shareManager]arrayToJSONString:weakSelf.sliderImage],
                @"handCardPhoto":[[MGPHttpRequest shareManager]arrayToJSONString:weakSelf.image],
            }];
            
            
            
           [[MGPHttpRequest shareManager]post:@"/appStoreUser/addUserInfo" paramters:parm completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
               [MBProgressHUD hideHUDForView:self.view animated:YES];
               if ([responseObj[@"code"]intValue] == 0) {
                   [weakSelf.view showMsg:responseObj[@"msg"]];
                   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                       [self.navigationController pushViewController:[MangoDefiAddViewController new] animated:YES];
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
