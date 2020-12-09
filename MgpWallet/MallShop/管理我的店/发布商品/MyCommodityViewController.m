//
//  MyCommodityViewController.m
//  TaiYiToken
//
//  Created by mac on 2020/8/3.
//  Copyright © 2020 admin. All rights reserved.
//

#import "MyCommodityViewController.h"
#import "Masonry.h"
#import "CCPActionSheetView.h"
#import "CCPMultipleChoiceView.h"

#import "JPAlertView.h"
#import "JPAlertViewOptionalItem.h"



@interface MyCommodityViewController ()<JPAlertViewDelegate,STPickerSingleDelegate>
{
    BOOL isLoad;
    BOOL payType;
    NSString *payId;

}
@property (strong,nonatomic)NSArray *image;
@property (strong,nonatomic)NSArray *sliderImage;
@property (strong,nonatomic)NSMutableArray *categoryArr;
@property (strong,nonatomic)NSMutableArray *cellArr0;
@property (strong,nonatomic)NSMutableArray *countyArr;
@property (strong,nonatomic)NSArray *payConfigArr;
@property (strong,nonatomic)NSMutableArray *payConfigTempArr;



@end

@implementation MyCommodityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//
    isLoad = YES;
    payType = YES;
    self.Jh_navTitle = self.model == nil ? NSLocalizedString(@"商品上传", nil) : NSLocalizedString(@"修改商品", nil);

//    self.Jh_navRightTitle =@"添加"; //也可以设置图片
//    self.JhClickNavRightItemBlock = ^{
//        NSLog(@" 点击跳转 ");
//
//    };
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
        @{@"key":NSLocalizedString(@"商品名称", nil),@"value":NSLocalizedString(@"请输入", nil),@"idStr":self.model.storeName},
        @{@"key":NSLocalizedString(@"规格", nil),@"value":NSLocalizedString(@"请输入", nil),@"idStr":self.model.storeType},
        @{@"key":NSLocalizedString(@"单位", nil),@"value":NSLocalizedString(@"请输入", nil),@"idStr":self.model.storeUnit},
        @{@"key":NSLocalizedString(@"库存", nil),@"value":NSLocalizedString(@"请输入", nil),@"idStr":@(self.model.stock)},
        @{@"key":NSLocalizedString(@"价格($)", nil),@"value":NSLocalizedString(@"请输入", nil),@"idStr":@(self.model.price)},
        @{@"key":NSLocalizedString(@"邮费($)", nil),@"value":NSLocalizedString(@"请输入", nil),@"idStr":@(self.model.postage)},
        @{@"key":NSLocalizedString(@"卖家实际收取(%)", nil),@"value":NSLocalizedString(@"请输入", nil),@"idStr":@(self.model.givePro / 100)},
        @{@"key":NSLocalizedString(@"奖金激励(%)", nil),@"value":NSLocalizedString(@"请输入", nil),@"idStr":@(self.model.bonusPro / 100)},
        @{@"key":NSLocalizedString(@"抵押赠送(%)", nil),@"value":NSLocalizedString(@"请输入", nil),@"idStr":@(self.model.buyerPro / 100)},
    ];


    _cellArr0 = [NSMutableArray array];
    for (int i = 0; i<arr.count; i++) {
        NSDictionary *dic = arr[i];
        //默认文本居左可编辑
        JhFormCellModel *cell = JhFormCellModel_AddInputCell(dic[@"key"], @"", YES, i <= 2 ? UIKeyboardTypeDefault : UIKeyboardTypeDecimalPad);
        cell.Jh_placeholder = dic[@"value"];
        cell.Jh_InfoTextAlignment = JhFormCellInfoTextAlignmentRight;
        cell.Jh_info = self.model != nil ? [NSString stringWithFormat:@"%@",dic[@"idStr"]] : @"";
        [_cellArr0 addObject:cell];

        if (i == 4 || i == 5) {
            cell.Jh_unit = @"$";
        }else if (i == 6 || i == 8 || i == 7){
            cell.Jh_unit = @"%";
        }
    }
    
    JhFormCellModel *cell5 = JhFormCellModel_AddRightArrowCell(NSLocalizedString(@"类型", nil), NSLocalizedString(@"请选择", nil));
    cell5.Jh_required = YES;
    cell5.Jh_CellSelectCellBlock = ^(JhFormCellModel *cellModel) {
        //1.使用自己熟悉的选择弹框 ,选择完成对 Jh_info 赋值 (需要对应ID的话对Jh_info_idStr 赋值 )
        //2. 刷新 [weakSelf.Jh_formTableView reloadData];
        if (isLoad) {
            [[MGPHttpRequest shareManager]post:@"/appStoreCategory/allCategory" paramters:nil completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
                isLoad = YES;
                if ([responseObj[@"code"]intValue] == 0) {
                    
                    NSMutableArray *temp = [NSMutableArray array];
                    self.categoryArr = [NSMutableArray array];
                    for (NSDictionary *dic in responseObj[@"data"]) {
                        [temp addObject:dic[@"cateName"]];
                        [self.categoryArr addObject:dic];
                    }
                    if (self.categoryArr.count > 0) {
                        STPickerSingle *single = [[STPickerSingle alloc]init];
                        [single setArrayData:temp];
                        [single setTitle:NSLocalizedString(@"请选择", nil)];
                        [single setTitleUnit:@""];
                        [single setBtntag:2020082001];
                        [single setDelegate:self];
                        [single show];
                    }
                    
                }
            }];
        }
        isLoad = NO;
        
        
    };
    [_cellArr0 insertObject:cell5 atIndex:1];

    JhFormCellModel *cell501 = JhFormCellModel_AddRightArrowCell(NSLocalizedString(@"销售地区", nil), NSLocalizedString(@"请选择", nil));
    cell501.Jh_required = YES;
    cell501.Jh_CellSelectCellBlock = ^(JhFormCellModel *cellModel) {
        //1.使用自己熟悉的选择弹框 ,选择完成对 Jh_info 赋值 (需要对应ID的话对Jh_info_idStr 赋值 )
        //2. 刷新 [weakSelf.Jh_formTableView reloadData];
        if (isLoad) {
            [[MGPHttpRequest shareManager]post:@"/appCountry/getCountry" paramters:nil completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
                isLoad = YES;
                if ([responseObj[@"code"]intValue] == 0) {
                    
                    NSMutableArray *temp = [NSMutableArray array];
                    self.countyArr = [NSMutableArray array];
                    for (NSDictionary *dic in responseObj[@"data"]) {
                        [temp addObject:dic[@"countyName"]];
                        [self.countyArr addObject:dic];
                    }
                    if (self.countyArr.count > 0) {
                        STPickerSingle *single = [[STPickerSingle alloc]init];
                        [single setArrayData:temp];
                        [single setTitle:NSLocalizedString(@"请选择", nil)];
                        [single setTitleUnit:@""];
                        [single setBtntag:2020082003];
                        [single setDelegate:self];
                        [single show];
                    }
                    
                }
            }];
        }
        isLoad = NO;
        
        
    };
    [_cellArr0 addObject:cell501];

    JhFormCellModel *cell502 = JhFormCellModel_AddRightArrowCell(NSLocalizedString(@"支付方式", nil), NSLocalizedString(@"请选择", nil));
    cell502.Jh_required = YES;
    cell502.Jh_CellSelectCellBlock = ^(JhFormCellModel *cellModel) {
        [[MGPHttpRequest shareManager]post:@"/appStorePayConfig/getPayConfig" paramters:nil completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {

            if ([responseObj[@"code"]intValue] == 0) {
                weakSelf.payConfigTempArr = [NSMutableArray array];
                weakSelf.payConfigArr = responseObj[@"data"];
                NSMutableArray *tempArr = [NSMutableArray array];
                for (NSDictionary *dic in weakSelf.payConfigArr) {
                    [tempArr addObject:dic[@"name"]];
                }
                JPAlertView *alertView = [[JPAlertView alloc] initWithTitle:NSLocalizedString(@"支付方式", nil) message:nil delegate:self optionalItems:tempArr cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
                alertView.message = NSLocalizedString(@"请选择该商品所支持的交易支付方式", nil);
                [alertView show:nil];
                
                
            }
        }];
        
        
    };
    [_cellArr0 addObject:cell502];
    

    
    JhFormCellModel *cell6 = JhFormCellModel_Add(NSLocalizedString(@"简介", nil), @"", JhFormCellTypeTextViewInput, YES, YES, UIKeyboardTypeDefault);
    cell6.Jh_placeholder = NSLocalizedString(@"请输入商品简介(最多150字)", nil);
    cell6.Jh_showLength = YES;//默认不显示
    cell6.Jh_maxInputLength = 150;
    cell6.Jh_info = self.model.storeInfo;
    [_cellArr0 addObject:cell6];

    
    JhFormCellModel *cell7 = JhFormCellModel_AddImageCell(NSLocalizedString(@"商品封面", nil), NO);
    cell7.Jh_maxImageCount = 1;
    cell7.Jh_required = YES;
    cell7.Jh_imageArr = self.model.image_url;
    [_cellArr0 addObject:cell7];

    JhFormCellModel *picture = JhFormCellModel_AddImageCell(NSLocalizedString(@"商品轮播图", nil), NO);
    picture.Jh_maxImageCount = 9;
    picture.Jh_required = YES;
    picture.Jh_tipsInfo = NSLocalizedString(@"最多可上传9张", nil);
    picture.Jh_imageArr = self.model.sliderImages;
    [_cellArr0 addObject:picture];

    
    
    JhFormSectionModel *section0 = JhSectionModel_Add(_cellArr0);
    [self.Jh_formModelArr addObject:section0];
    self.Jh_submitStr = self.model == nil ? NSLocalizedString(@"提 交", nil) : NSLocalizedString(@"修 改", nil);

    
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
    

    [[MGPHttpRequest shareManager]post:@"/appStore/saleModel/defaultModel" paramters:@{@"id":@"1"} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
        if ([responseObj[@"code"]intValue] == 0) {
 
            
            JhFormCellModel *cellMode8 = _cellArr0[7];
            cellMode8.Jh_editable = [[responseObj[@"data"]objectForKey:@"sellerGainEditFlag"] boolValue];
            cellMode8.Jh_placeholder = NSLocalizedString(@"输入0-100之间的值", nil);
            cellMode8.Jh_info = [NSString stringWithFormat:@"%.2f",[[responseObj[@"data"]objectForKey:@"sellerGainPro"]doubleValue]];

            cellMode8.JhInputBlock = ^(NSString *text, BOOL isInputCompletion) {
                NSLog(@" 监听输入的文字7 %@ ",text);
                JhFormSectionModel *sectionModel = self.Jh_formModelArr.firstObject;
                JhFormCellModel *cellModel8 = sectionModel.Jh_sectionModelArr[8];
                JhFormCellModel *cellModel9 = sectionModel.Jh_sectionModelArr[9];
                cellModel8.Jh_info = [NSString stringWithFormat:@"%.2f",100.0 - [cellModel9.Jh_info doubleValue] - [text doubleValue]];
                
                [self.Jh_formTableView reloadRowAtIndexPath:[NSIndexPath indexPathForRow:8 inSection:0] withRowAnimation:UITableViewRowAnimationFade];

                
                if (isInputCompletion) {
                    if ([text doubleValue] <= 100) {
                        
                    }else{
                        [self.view showMsg:NSLocalizedString(@"输入0-100之间的值", nil)];
                    }
                }
            };
            
            JhFormCellModel *cellMode9 = _cellArr0[8];
            cellMode9.Jh_editable = [[responseObj[@"data"]objectForKey:@"orderGainEditFlag"] boolValue];
            cellMode9.Jh_placeholder = NSLocalizedString(@"输入0-100之间的值", nil);
            cellMode9.Jh_info = [NSString stringWithFormat:@"%.2f",[[responseObj[@"data"]objectForKey:@"orderGainPro"]doubleValue]];

            cellMode9.JhInputBlock = ^(NSString *text, BOOL isInputCompletion) {
                NSLog(@" 监听输入的文字8 %@ ",text);
                if (isInputCompletion) {
                    if ([text doubleValue] <= 100) {

                    }else{
                        [self.view showMsg:NSLocalizedString(@"输入0-100之间的值", nil)];
                    }
                }
                
            };
            
            if ([[responseObj[@"data"]objectForKey:@"buyerGainEditFlag"] intValue]==1) {
                JhFormCellModel *cellMode9 = _cellArr0[9];
                cellMode9.Jh_editable = [[responseObj[@"data"]objectForKey:@"orderGainEditFlag"] boolValue];
                cellMode9.Jh_placeholder = NSLocalizedString(@"输入0-100之间的值", nil);
                cellMode9.Jh_info = [NSString stringWithFormat:@"%.2f",[[responseObj[@"data"]objectForKey:@"buyerGainPro"]doubleValue]];

                cellMode9.JhInputBlock = ^(NSString *text, BOOL isInputCompletion) {
                    if (isInputCompletion) {
                        if ([text doubleValue] <= 100) {

                        }else{
                            [self.view showMsg:NSLocalizedString(@"输入0-100之间的值", nil)];
                        }
                    }
                    
                };
            }else if(([[responseObj[@"data"]objectForKey:@"buyerGainEditFlag"] intValue]==2)){
                [_cellArr0 removeObjectAtIndex:9];
                JhFormCellModel *cell5 = JhFormCellModel_AddRightArrowCell(NSLocalizedString(@"抵押赠送(%)", nil), NSLocalizedString(@"请选择", nil));
                cell5.Jh_required = YES;
                cell5.Jh_unit = @"%";
                cell5.Jh_CellSelectCellBlock = ^(JhFormCellModel *cellModel) {
                    //1.使用自己熟悉的选择弹框 ,选择完成对 Jh_info 赋值 (需要对应ID的话对Jh_info_idStr 赋值 )

                    STPickerSingle *single = [[STPickerSingle alloc]init];
                    [single setArrayData:[responseObj[@"data"]objectForKey:@"buyerGainPros"]];
                    [single setTitle:NSLocalizedString(@"请选择", nil)];
                    [single setTitleUnit:@""];
                    [single setBtntag:2020082002];
                    [single setDelegate:self];
                    [single show];
                    
                    
                };
                [_cellArr0 insertObject:cell5 atIndex:9];
                
            }else{
                JhFormCellModel *mode = _cellArr0[9];
                mode.Jh_editable = NO;
                mode.Jh_info = [NSString stringWithFormat:@"%.2f",[[responseObj[@"data"]objectForKey:@"buyerGainPro"]doubleValue]*100];
            }
            
            
            
            [self.Jh_formTableView reloadData];
        }
    }];
    
    
    
    
    
    /*
    //居右
    JhFormCellModel *cell0 = JhFormCellModel_AddRightTextCell(@"左标题:", @"右信息(不可编辑,居右)");
    JhFormCellModel *cell1 = JhFormCellModel_AddRightArrowCell(@"左标题:", @"右信息(居右,带箭头)");
    
    
    JhFormCellModel *cell2 = JhFormCellModel_AddSwitchBtnCell(@"左标题:", YES);
    cell2.Jh_switchTintColor = [UIColor orangeColor];
    
    //可以不通过block获取开关状态
    __weak typeof(cell2) weakCell2 = cell2;
    cell2.Jh_switchBtnBlock = ^(BOOL switchBtn_on, UISwitch *switchBtn) {
        NSLog(@"switchBtn_on %@", switchBtn_on ? @"YES" : @"NO");
//        weakCell2.Jh_switchOnTintColor = JhRandomColor;
        [weakSelf.Jh_formTableView reloadData];
    };
    
    //默认文本居左可编辑
//    JhFormCellModel *cell3 = JhFormCellModel_Add(@"姓名:", @"", JhFormCellTypeInput, YES, YES, UIKeyboardTypeDefault);
    
    //默认文本居左可编辑
    JhFormCellModel *cell3 = JhFormCellModel_AddInputCell(@"姓名:", @"", YES, UIKeyboardTypeDefault);
    cell3.Jh_placeholder = @"请输入姓名(必选)";
    cell3.JhInputBlock = ^(NSString *text, BOOL isInputCompletion) {
        NSLog(@" 监听输入的文字 %@ ",text);
        BOOL boolValue = isInputCompletion;
        NSLog(@"是否输入完成%@", boolValue ? @"YES" : @"NO");
    };
    
    JhFormCellModel *pwd = JhFormCellModel_AddCustumRightCell(@"密码:");
//    pwd.Jh_custumRightViewBlock = ^(UIView *RightView) {
//        [RightView addSubview:weakSelf.passWordTextField];
//        [weakSelf.passWordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.mas_equalTo(RightView);
//            make.right.mas_equalTo(-40);
//            make.left.mas_equalTo(0);
//        }];
//    };
   NSString *redStr =@"*密码:";
    NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc]initWithString:redStr attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20], NSForegroundColorAttributeName:Jh_titleColor}];
    [attributedTitle addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 1)];
    pwd.Jh_attributedTitle = attributedTitle;
    
    
    JhFormCellModel *cell4 = JhFormCellModel_AddInputCell(@"手机号:", @"XXX(可编辑)", YES, UIKeyboardTypePhonePad);
    cell4.Jh_placeholder = @"请输入手机号(最长11位,必选)";
    cell4.Jh_maxInputLength = 11;
    
    
    JhFormCellModel *cell5 = JhFormCellModel_AddSelectCell(@"性别:", @"文本居左(可选择)", YES);
    cell5.Jh_placeholder = @"请选择性别";
    
    __weak typeof(cell5) weakCell5 = cell5;
    cell5.Jh_CellSelectCellBlock = ^(JhFormCellModel *cellModel) {
        
        //1.使用自己熟悉的选择弹框 ,选择完成对 Jh_info 赋值 (需要对应ID的话对Jh_info_idStr 赋值 )
        //2. 刷新 [weakSelf.Jh_formTableView reloadData];
        
        
    };
    
    JhFormCellModel *cell6 = JhFormCellModel_Add(@"备注:", @"默认备注", JhFormCellTypeTextViewInput, YES, YES, UIKeyboardTypeDefault);
    cell6.Jh_placeholder = @"请输入备注(最多50字)";
    cell6.Jh_showLength = YES;//默认不显示
    cell6.Jh_maxInputLength = 50;
    
    JhFormCellModel *cell7 = JhFormCellModel_AddImageCell(@"选择图片:", NO);
    cell7.Jh_tipsInfo =@"这是一条默认颜色的提示信息(不设置不显示)";
    
    JhFormCellModel *picture = JhFormCellModel_AddImageCell(@"选择图片2:", NO);
    picture.Jh_maxImageCount = 2;
    picture.Jh_tipsInfo =@"这是一条可设置颜色的提示信息";
    picture.Jh_tipsInfoColor = [UIColor redColor];
    
    JhFormCellModel *urlPicture = JhFormCellModel_AddImageCell(@"加载网络图片:", NO);
//    urlPicture.Jh_noShowAddImgBtn=YES;
//    urlPicture.Jh_hideDeleteButton = YES;
    urlPicture.Jh_imageArr =@[@"https://gitee.com/iotjh/Picture/raw/master/FormDemo/form_demo_00.png",
                              @"https://gitee.com/iotjh/Picture/raw/master/FormDemo/form_demo_05.png",
                              @"https://gitee.com/iotjh/Picture/raw/master/FormDemo/form_demo_06.png"];
    
    JhFormCellModel *picture_noTitle = JhFormCellModel_AddImageCell(@"", NO);
    picture_noTitle.Jh_maxImageCount = 2;

    
    [cellArr0 addObjectsFromArray: @[cell0,cell1,cell2,cell3,pwd,cell4,cell5,cell6,cell7,picture,urlPicture,picture_noTitle]];
    
    JhFormSectionModel *section0 = JhSectionModel_Add(cellArr0);
    
    [self.Jh_formModelArr addObject:section0];
    
    self.Jh_submitStr = @"提 交";
    self.Jh_formSubmitBlock = ^{
        NSLog(@" 点击提交按钮 ");
        
        NSLog(@" cell0.Jh_info - %@", cell0.Jh_info);
        NSLog(@" cell1.Jh_info - %@", cell1.Jh_info);
        NSLog(@" cell2.开关的状态 - %@", cell2.Jh_switchBtn_on ? @"YES" : @"NO");
        NSLog(@" cell3.Jh_info - %@", cell3.Jh_info);
        NSLog(@" cell4.Jh_info - %@", cell4.Jh_info);
        NSLog(@" cell5.Jh_info - %@", cell5.Jh_info);
        NSLog(@" cell6.Jh_info - %@", cell6.Jh_info);
        NSLog(@" 选择图片类 - Jh_selectImageArr: %@ ",cell7.Jh_selectImageArr);
        NSLog(@" 选择图片类 - urlPicture- Jh_selectImageArr: %@ ",urlPicture.Jh_selectImageArr);
        
        // 这里只是简单描述校验逻辑，可根据自身需求封装数据校验逻辑
        [JhFormHandler Jh_checkFormNullDataWithWithDatas:weakSelf.Jh_formModelArr success:^{
            
            [weakSelf SubmitRequest];
            
        } failure:^(NSString *error) {
            NSLog(@"error====%@",error);
//            [JhProgressHUD showText:error];
        }];
        
    };*/
    
}
- (void)alertView:(JPAlertView *)alertView selectOptionalItemAtIndex:(NSInteger)itemIndex
{
    [self.payConfigTempArr addObject:self.payConfigArr[itemIndex]];
}
- (void)alertView:(JPAlertView *)alertView deselectOptionalItemAtIndex:(NSInteger)itemIndex
{
    [self.payConfigTempArr removeObjectAtIndex:itemIndex];
}
- (void)alertView:(JPAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    JhFormSectionModel *sectionModel = self.Jh_formModelArr.firstObject;
    JhFormCellModel *cellModel = sectionModel.Jh_sectionModelArr[11];
    NSMutableString *payName = [NSMutableString string];
    payId = [NSString new];
    for (NSDictionary *dic in self.payConfigTempArr) {
        [payName appendString:dic[@"name"]];
        [payName appendString:@","];
        payId = [NSString stringWithFormat:@"%@,%@",dic[@"payId"],VALIDATE_STRING(payId)];
        
    }
    cellModel.Jh_info = payName;
    [self.Jh_formTableView reloadData];

}

- (void)pickerSingle:(STPickerSingle *)pickerSingle selectedTitle:(NSString *)selectedTitle
{

    if (pickerSingle.btntag == 2020082001) {
        JhFormSectionModel *sectionModel = self.Jh_formModelArr.firstObject;
        JhFormCellModel *cellModel = sectionModel.Jh_sectionModelArr[1];
        cellModel.Jh_info = selectedTitle;
    }else if(pickerSingle.btntag == 2020082002) {
        JhFormSectionModel *sectionModel = self.Jh_formModelArr.firstObject;
        JhFormCellModel *cellModel = sectionModel.Jh_sectionModelArr[9];
        cellModel.Jh_info = selectedTitle;
    }else if(pickerSingle.btntag == 2020082003) {
        JhFormSectionModel *sectionModel = self.Jh_formModelArr.firstObject;
        JhFormCellModel *cellModel = sectionModel.Jh_sectionModelArr[10];
        cellModel.Jh_info = selectedTitle;
    }
    [self.Jh_formTableView reloadData];

}
#pragma mark - 提交请求
-(void)SubmitRequest{
    
    
    WEAKSELF
    JhFormSectionModel *temp = self.Jh_formModelArr.firstObject;
    JhFormCellModel *cell90 = temp.Jh_sectionModelArr[14];
    [[MGPHttpRequest shareManager]post:@"/file/upload" andImages:cell90.Jh_selectImageArr completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {

        if ([responseObj[@"code"]intValue] == 0) {

            NSLog(@"222");
        }
    }];
    return;
    
    JhFormCellModel *cell7 = temp.Jh_sectionModelArr[7];
    JhFormCellModel *cell8 = temp.Jh_sectionModelArr[8];
    JhFormCellModel *cell9 = temp.Jh_sectionModelArr[9];
    if ([cell7.Jh_info doubleValue] + [cell8.Jh_info doubleValue] + [cell9.Jh_info doubleValue] != 100.0) {
        [self.view showMsg:NSLocalizedString(@"销售模式累加必须等于100", nil)];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);//
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        JhFormCellModel *cell8 = temp.Jh_sectionModelArr[13];
        [[MGPHttpRequest shareManager]post:@"/file/upload" andImages:cell8.Jh_selectImageArr completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
            dispatch_group_leave(group);
            if ([responseObj[@"code"]intValue] == 0) {
                weakSelf.image = responseObj[@"data"];
            }
        }];
        
    });
    dispatch_group_enter(group);//
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        JhFormCellModel *cell9 = temp.Jh_sectionModelArr[14];
        [[MGPHttpRequest shareManager]post:@"/file/upload" andImages:cell9.Jh_selectImageArr completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
            dispatch_group_leave(group);
            if ([responseObj[@"code"]intValue] == 0) {
                weakSelf.sliderImage = responseObj[@"data"];
            }
        }];
        
    });
    //二个网络请求都完成统一处理
    dispatch_group_notify(group, queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{

           JhFormCellModel *cell0 = temp.Jh_sectionModelArr[0];
           JhFormCellModel *cell1 = temp.Jh_sectionModelArr[1];
           JhFormCellModel *cell2 = temp.Jh_sectionModelArr[2];
           JhFormCellModel *cell3 = temp.Jh_sectionModelArr[3];
           JhFormCellModel *cell4 = temp.Jh_sectionModelArr[4];
           JhFormCellModel *cell5 = temp.Jh_sectionModelArr[5];
           JhFormCellModel *cell6 = temp.Jh_sectionModelArr[6];
           JhFormCellModel *cell7 = temp.Jh_sectionModelArr[7];
           JhFormCellModel *cell8 = temp.Jh_sectionModelArr[8];
           JhFormCellModel *cell9 = temp.Jh_sectionModelArr[9];
           JhFormCellModel *cell10 = temp.Jh_sectionModelArr[10];
           JhFormCellModel *cell11 = temp.Jh_sectionModelArr[12];

            NSString *cateId = @"";
            for (NSDictionary *dic in self.categoryArr) {
                if ([dic[@"cateName"] isEqualToString:cell1.Jh_info]) {
                    cateId = dic[@"id"];
                }
            }
            NSString *countryNum = @"";
            for (NSDictionary *dic in self.countyArr) {
                if ([dic[@"countyName"] isEqualToString:cell10.Jh_info]) {
                    countryNum = dic[@"id"];
                }
            }
            
            NSMutableDictionary *parm = [NSMutableDictionary dictionaryWithDictionary:@{
                @"address":[MGPHttpRequest shareManager].curretWallet.address,
                @"cateId":cateId,
                @"payIds":payId,
                @"postage":cell6.Jh_info,
                @"storeType":cell2.Jh_info,
                @"price":cell5.Jh_info,
                @"stock":cell4.Jh_info,
                @"storeInfo":cell11.Jh_info,
                @"storeName":cell0.Jh_info,
                @"storeUnit":cell3.Jh_info,
                @"image":[[MGPHttpRequest shareManager]arrayToJSONString:weakSelf.image],
                @"countryNum":countryNum,
                @"sliderImage":[[MGPHttpRequest shareManager]arrayToJSONString:weakSelf.sliderImage],
                @"givePro":[NSString stringWithFormat:@"%.2f",[cell7.Jh_info doubleValue]/100.0],
                @"bonusPro":[NSString stringWithFormat:@"%.2f",[cell8.Jh_info doubleValue]/100.0],
                @"buyerPro":[NSString stringWithFormat:@"%.2f",[cell9.Jh_info doubleValue]/100.0],
                
            }];
            
            if (self.model != nil) {
                [parm setValue:@(self.model.proID) forKey:@"id"];
            }
            NSString *urlStr = self.model == nil ? @"/appStoreProduct/addPro" : @"/appStoreProduct/upPro";
           [[MGPHttpRequest shareManager]post:urlStr paramters:parm completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
               [MBProgressHUD hideHUDForView:self.view animated:YES];
               if ([responseObj[@"code"]intValue] == 0) {
                   [weakSelf.view showMsg:responseObj[@"msg"]];
                   !_collectionBlock ? : _collectionBlock();

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
