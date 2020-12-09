//
//  MangoDefiAddViewController.m
//  TaiYiToken
//
//  Created by mac on 2020/9/1.
//  Copyright © 2020 admin. All rights reserved.
//

#import "MangoDefiAddViewController.h"

@interface MangoDefiAddViewController ()<STPickerSingleDelegate,CLLocationManagerDelegate>
{
    BOOL isLoad;
    
    CLLocationManager*locationmanager;//定位服务

    NSString*strlatitude;//经度

    NSString*strlongitude;//纬度
    
}
@property (strong,nonatomic)NSArray *image;
@property (strong,nonatomic)NSArray *sliderImage;

@property (strong,nonatomic)NSMutableArray *categoryArr;
@property (strong,nonatomic)NSMutableArray *cellArr0;
@property (strong,nonatomic)NSMutableArray *countyArr;




@end

@implementation MangoDefiAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self startLocation];
    isLoad = YES;
    self.Jh_navTitle = self.model.shop == nil ? NSLocalizedString(@"添加店铺", nil) : NSLocalizedString(@"编辑店铺", nil);
    if (self.model.shop.status == 3) {
        [self.view showMsg:self.model.shop.failMsg];
    }
    [self initModel];
    self.Jh_formTableView.rowHeight = 55;
        
}

#pragma mark - 定位
//开始定位
-(void) startLocation
{
    //判断定位功能是否打开
    if ([CLLocationManager locationServicesEnabled]) {
        locationmanager = [[CLLocationManager alloc]init];
        locationmanager.delegate = self;
        [locationmanager requestAlwaysAuthorization];
        [locationmanager requestWhenInUseAuthorization];
        
        //设置寻址精度
        locationmanager.desiredAccuracy = kCLLocationAccuracyBest;
        locationmanager.distanceFilter = 5.0;
        [locationmanager startUpdatingLocation];
    }
}
#pragma mark CoreLocation delegate (定位失败)
//定位失败后调用此代理方法
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //设置提示提醒用户打开定位服务
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"允许定位提示" message:@"请在设置中打开定位" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"打开定位" style:UIAlertActionStyleDefault handler:nil];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark 定位成功后则执行此代理方法
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    [locationmanager stopUpdatingHeading];
    //旧址
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    //打印当前的经度与纬度
    NSLog(@"%f,%f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
    strlatitude = [NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
    strlongitude = [NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
    
//    [self upRecDataForLongitude:strlongitude andLatitude:strlatitude andKey:key];
    
}


-(void)dealloc{
    NSLog(@" FormDemo1VC - dealloc ");
}
#pragma mark - initModel
-(void)initModel{

    
    __weak typeof(self) weakSelf = self;
    NSArray *arr = @[
        @{@"key":NSLocalizedString(@"店铺名称", nil),@"value":NSLocalizedString(@"请输入", nil),@"idStr":self.model.shop.name},
        @{@"key":NSLocalizedString(@"收取比例", nil),@"value":NSLocalizedString(@"请输入", nil),@"idStr":@(self.model.shop.storePro)},
        @{@"key":NSLocalizedString(@"赠送比例", nil),@"value":NSLocalizedString(@"请输入", nil),@"idStr":@(self.model.shop.rewardPro)},
        @{@"key":NSLocalizedString(@"营业时间", nil),@"value":NSLocalizedString(@"请输入", nil),@"idStr":self.model.shop.bankTime},

    ];


    _cellArr0 = [NSMutableArray array];
    for (int i = 0; i<arr.count; i++) {
        NSDictionary *dic = arr[i];
        //默认文本居左可编辑
        
        JhFormCellModel *cell = JhFormCellModel_AddInputCell(dic[@"key"], @"", YES, (i <= 0 || (i == arr.count-1))? UIKeyboardTypeDefault : UIKeyboardTypeDecimalPad);
        cell.Jh_placeholder = dic[@"value"];
        cell.Jh_info = self.model != nil ? VALIDATE_STRING(dic[@"idStr"]) : @"";
        cell.Jh_InfoTextAlignment = JhFormCellInfoTextAlignmentRight;
        [_cellArr0 addObject:cell];
    }
    
    JhFormCellModel *cell5 = JhFormCellModel_AddRightArrowCell(NSLocalizedString(@"分类", nil), NSLocalizedString(@"请选择", nil));
    cell5.Jh_required = YES;
    cell5.Jh_CellSelectCellBlock = ^(JhFormCellModel *cellModel) {
        //1.使用自己熟悉的选择弹框 ,选择完成对 Jh_info 赋值 (需要对应ID的话对Jh_info_idStr 赋值 )
        //2. 刷新 [weakSelf.Jh_formTableView reloadData];
        if (isLoad) {
            [[MGPHttpRequest shareManager]post:@"/api/appStoreLife/category" paramters:@{@"type":@"2"} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
                isLoad = YES;
                if ([responseObj[@"code"]intValue] == 0) {
                    
                    NSMutableArray *temp = [NSMutableArray array];
                    self.categoryArr = [NSMutableArray array];
                    for (NSDictionary *dic in responseObj[@"data"]) {
                        [temp addObject:dic[@"name"]];
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

    JhFormCellModel *cell501 = JhFormCellModel_AddRightArrowCell(NSLocalizedString(@"营销地区", nil), NSLocalizedString(@"请选择", nil));
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

    
    JhFormCellModel *cell6 = JhFormCellModel_Add(NSLocalizedString(@"详细地址", nil), @"", JhFormCellTypeTextViewInput, YES, YES, UIKeyboardTypeDefault);
    cell6.Jh_placeholder = NSLocalizedString(@"请输入详细地址", nil);
    cell6.Jh_showLength = YES;//默认不显示
    cell6.Jh_maxInputLength = 150;
    cell6.Jh_info = self.model != nil ? self.model.shop.storeAddress : @"";
    [_cellArr0 addObject:cell6];

    
    JhFormCellModel *cell7 = JhFormCellModel_AddImageCell(NSLocalizedString(@"店铺封面", nil), NO);
    cell7.Jh_maxImageCount = 1;
    cell7.Jh_required = YES;
    cell7.Jh_imageArr = self.model.shop.imgs;
    [_cellArr0 addObject:cell7];

    JhFormCellModel *picture = JhFormCellModel_AddImageCell(NSLocalizedString(@"店铺轮播图", nil), NO);
    picture.Jh_maxImageCount = 9;
    picture.Jh_required = YES;
    picture.Jh_imageArr = self.model.shop.detailImgs;
    picture.Jh_tipsInfo = NSLocalizedString(@"最多可上传9张", nil);
    [_cellArr0 addObject:picture];

    
    
    JhFormSectionModel *section0 = JhSectionModel_Add(_cellArr0);
    [self.Jh_formModelArr addObject:section0];
    self.Jh_submitStr = self.model.shop == nil ? NSLocalizedString(@"提 交", nil) : NSLocalizedString(@"修 改", nil);

    
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
    [[MGPHttpRequest shareManager]post:@"/appStore/saleModel/defaultModel" paramters:@{@"id":@"2"} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
           if ([responseObj[@"code"]intValue] == 0) {
    
               
               JhFormCellModel *cellMode8 = _cellArr0[2];
               cellMode8.Jh_editable = [[responseObj[@"data"]objectForKey:@"sellerGainEditFlag"] boolValue];
               cellMode8.Jh_placeholder = NSLocalizedString(@"输入0-100之间的值", nil);
               cellMode8.Jh_info = [NSString stringWithFormat:@"%.2f",[[responseObj[@"data"]objectForKey:@"sellerGainPro"]doubleValue]];

               cellMode8.JhInputBlock = ^(NSString *text, BOOL isInputCompletion) {
                   NSLog(@" 监听输入的文字7 %@ ",text);
                   JhFormSectionModel *sectionModel = self.Jh_formModelArr.firstObject;
                   JhFormCellModel *cellModel8 = sectionModel.Jh_sectionModelArr[2];
                   JhFormCellModel *cellModel9 = sectionModel.Jh_sectionModelArr[3];
                   cellModel8.Jh_info = [NSString stringWithFormat:@"%.2f",100.0 - [cellModel9.Jh_info doubleValue] - [text doubleValue]];
                   
                   [self.Jh_formTableView reloadRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0] withRowAnimation:UITableViewRowAnimationFade];

                   
                   if (isInputCompletion) {
                       if ([text doubleValue] <= 100) {
                           
                       }else{
                           [self.view showMsg:NSLocalizedString(@"输入0-100之间的值", nil)];
                       }
                   }
               };
               
               JhFormCellModel *cellMode9 = _cellArr0[3];
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
                   JhFormCellModel *cellMode9 = _cellArr0[3];
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
                   [_cellArr0 removeObjectAtIndex:3];
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
                   [_cellArr0 insertObject:cell5 atIndex:3];
                   
               }else{
                   JhFormCellModel *mode = _cellArr0[3];
                   mode.Jh_editable = NO;
                   mode.Jh_info = [NSString stringWithFormat:@"%.2f",[[responseObj[@"data"]objectForKey:@"buyerGainPro"]doubleValue]*100];
               }
               
               
               
               [self.Jh_formTableView reloadData];
           }
    }];
    
 
}

- (void)pickerSingle:(STPickerSingle *)pickerSingle selectedTitle:(NSString *)selectedTitle
{

    if (pickerSingle.btntag == 2020082001) {
        JhFormSectionModel *sectionModel = self.Jh_formModelArr.firstObject;
        JhFormCellModel *cellModel = sectionModel.Jh_sectionModelArr[1];
        cellModel.Jh_info = selectedTitle;
    }else if(pickerSingle.btntag == 2020082002) {
        JhFormSectionModel *sectionModel = self.Jh_formModelArr.firstObject;
        JhFormCellModel *cellModel = sectionModel.Jh_sectionModelArr[3];
        cellModel.Jh_info = selectedTitle;
        
        JhFormCellModel *cellModel2 = sectionModel.Jh_sectionModelArr[2];
        cellModel2.Jh_info = [NSString stringWithFormat:@"%.2f",100.0 - [cellModel.Jh_info doubleValue]];
        
    }else if(pickerSingle.btntag == 2020082003) {
        JhFormSectionModel *sectionModel = self.Jh_formModelArr.firstObject;
        JhFormCellModel *cellModel = sectionModel.Jh_sectionModelArr[5];
        cellModel.Jh_info = selectedTitle;
    }
    [self.Jh_formTableView reloadData];

}
#pragma mark - 提交请求
-(void)SubmitRequest{
    WEAKSELF
    JhFormSectionModel *temp = self.Jh_formModelArr.firstObject;
    JhFormCellModel *cell2 = temp.Jh_sectionModelArr[2];
    JhFormCellModel *cell4 = temp.Jh_sectionModelArr[3];
//    if ([cell2.Jh_info doubleValue] + [cell3.Jh_info doubleValue] + [cell4.Jh_info doubleValue] != 100.0) {
//        [self.view showMsg:NSLocalizedString(@"销售模式累加必须等于100", nil)];
//        return;
//    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);//
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        JhFormCellModel *cell8 = temp.Jh_sectionModelArr[7];
        [[MGPHttpRequest shareManager]post:@"/file/upload" andImages:cell8.Jh_selectImageArr completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
            dispatch_group_leave(group);
            if ([responseObj[@"code"]intValue] == 0) {
                weakSelf.image = responseObj[@"data"];
            }
        }];
    });
    dispatch_group_enter(group);//
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        JhFormCellModel *cell9 = temp.Jh_sectionModelArr[8];
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
           JhFormCellModel *cell5 = temp.Jh_sectionModelArr[4];
           JhFormCellModel *cell6 = temp.Jh_sectionModelArr[5];
           JhFormCellModel *cell7 = temp.Jh_sectionModelArr[6];
           

            NSString *cateId = @"";
            for (NSDictionary *dic in self.categoryArr) {
                if ([dic[@"name"] isEqualToString:cell1.Jh_info]) {
                    cateId = dic[@"id"];
                }
            }
            NSString *countryNum = @"";
            for (NSDictionary *dic in self.countyArr) {
                if ([dic[@"countyName"] isEqualToString:cell6.Jh_info]) {
                    countryNum = dic[@"id"];
                }
            }
            
            NSMutableDictionary *parm = [NSMutableDictionary dictionaryWithDictionary:@{
                @"address":[MGPHttpRequest shareManager].curretWallet.address,
                @"categoryId":cateId,
                @"name":cell0.Jh_info,
                @"bankTime":cell5.Jh_info,
                @"storeAddress":cell7.Jh_info,
                @"homeImg":[[MGPHttpRequest shareManager]arrayToJSONString:weakSelf.image],
                @"country":countryNum,
                @"detailImg":[[MGPHttpRequest shareManager]arrayToJSONString:weakSelf.sliderImage],
                @"longitude":strlongitude,
                @"latitude":strlatitude,
                @"storePro":[NSString stringWithFormat:@"%.2f",[cell2.Jh_info doubleValue]/100.0],
                @"buyerPro":[NSString stringWithFormat:@"%.2f",[cell4.Jh_info doubleValue]/100.0],

            }];
            
            if (self.model.shop != nil) {
                [parm setValue:@(self.model.shop.lifeID) forKey:@"id"];
             }
            NSString *urlStr = self.model.shop == nil ? @"/api/appStoreLife/addStore" : @"/api/appStoreLife/editStore";
            
           [[MGPHttpRequest shareManager]post:urlStr paramters:parm completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
               [MBProgressHUD hideHUDForView:self.view animated:YES];
               if ([responseObj[@"code"]intValue] == 0) {
                   [weakSelf.view showMsg:responseObj[@"msg"]];
                   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                       [self.navigationController popToRootViewControllerAnimated:YES];
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
