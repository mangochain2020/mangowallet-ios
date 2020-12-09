//
//  DCNewAdressViewController.m
//  CDDStoreDemo
//
//  Created by 陈甸甸 on 2017/12/19.
//Copyright © 2017年 RocketsChen. All rights reserved.
//

#import "DCNewAdressViewController.h"

// Controllers

// Models
#import "DCAdressDateBase.h"
#import "DCAdressItem.h"
// Views
#import "DCNewAdressView.h"
// Vendors
#import "UIView+Toast.h"
#import <SVProgressHUD.h>
#import "ChooseLocationView.h"
#import "CitiesDataTool.h"
// Categories
//#import "ZHFAddTitleAddressView.h"

// Others
#import "DCCheckRegular.h"

@interface DCNewAdressViewController ()<UITableViewDelegate,UITableViewDataSource,NSURLSessionDelegate,UIGestureRecognizerDelegate,STPickerSingleDelegate>
{
    
    BOOL isLoad;
    
}
/* tableView */
@property (strong , nonatomic)UITableView *tableView;
@property (nonatomic,strong) ChooseLocationView *chooseLocationView;
//@property(nonatomic,strong)ZHFAddTitleAddressView * addTitleAddressView;

@property (nonatomic,strong) UIView  *cover;
/* headView */
@property (strong , nonatomic)DCNewAdressView *adressHeadView;
@property (weak, nonatomic) IBOutlet UIButton *saveChangeButton;
@property (strong,nonatomic)NSMutableArray *countyArr;

@end

@implementation DCNewAdressViewController

#pragma mark - LazyLoad
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.frame = CGRectMake(0, DCTopNavH + 20, ScreenW, ScreenH - (DCTopNavH + 20 + 45));
        [self.view addSubview:_tableView];
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        
    }
    return _tableView;
}


#pragma mark - LifeCyle
- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setUI];
    isLoad = YES;
    [self setUpBase];
    
    [self setUpHeadView];
}/*
-(void)setUI{
    self.addTitleAddressView.title = @"选择地址";
    self.addTitleAddressView.delegate1 = self;
    self.addTitleAddressView.defaultHeight = 350;
    self.addTitleAddressView.titleScrollViewH = 37;
    if (self.addTitleAddressView.titleIDMarr.count > 0) {
        self.addTitleAddressView.isChangeAddress = true;
    }
    else{
        self.addTitleAddressView.isChangeAddress = false;
    }
   
    [self.view addSubview:[self.addTitleAddressView initAddressView]];
}
-(void)cancelBtnClick:(NSString *)titleAddress titleID:(NSString *)titleID{

    NSLog( @"%@--%@", titleAddress,[NSString stringWithFormat:@"打印的对应省市县的id=%@",titleID]);
}*/
- (void)setUpBase
{
    
    self.title = (_saveType == DCSaveAdressNewType) ? NSLocalizedString(@"新增收货人地址", nil) : NSLocalizedString(@"编辑收货人地址", nil);
    self.view.backgroundColor = DCBGColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.backgroundColor = self.view.backgroundColor;

    [[CitiesDataTool sharedManager] requestGetData];
    [self.view addSubview:self.cover];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -15;
    
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:NSLocalizedString(@"保存", nil) forState:0];
    button.frame = CGRectMake(0, 0, 44, 44);
    button.titleLabel.font = PFR16Font;
    [button setTitleColor:[UIColor blackColor] forState:0];
    [button addTarget:self action:@selector(saveButtonBarItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, backButton];
}


#pragma mark - 头部View
- (void)setUpHeadView
{
    _adressHeadView = [DCNewAdressView dc_viewFromXib];
    _adressHeadView.frame = CGRectMake(0, 0, ScreenW, 240);
    
    self.tableView.tableHeaderView = _adressHeadView;
    self.tableView.tableFooterView = [UIView new];
    
    if (_saveType == DCSaveAdressChangeType) { //编辑
        _adressHeadView.rePersonField.text = _adressItem.userName;
        _adressHeadView.addressLabel.text = _adressItem.chooseAdress;
        _adressHeadView.rePhoneField.text = _adressItem.userPhone;
        _adressHeadView.detailTextView.text = _adressItem.userAdress;
        [_adressHeadView.countryBtn setTitle:_adressItem.countyName forState:UIControlStateNormal];

    }
    
    WEAKSELF
    _adressHeadView.selectAdBlock = ^{
        [weakSelf.view endEditing:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakSelf.cover.hidden = !weakSelf.cover.hidden;
            weakSelf.chooseLocationView.hidden = weakSelf.cover.hidden;
        });
    };
    _adressHeadView.countryBlock = ^{
        [weakSelf.view endEditing:YES];
        isLoad = NO;
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
    };
    
}
- (void)pickerSingle:(STPickerSingle *)pickerSingle selectedTitle:(NSString *)selectedTitle
{

    [_adressHeadView.countryBtn setTitle:selectedTitle forState:UIControlStateNormal];
  
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


#pragma mark - 保存新地址
- (IBAction)saveNewAdressClick {
    
    if (_adressHeadView.rePersonField.text.length == 0 || _adressHeadView.rePhoneField.text.length == 0 || _adressHeadView.detailTextView.text.length == 0 || _adressHeadView.addressLabel.text.length == 0) {
        [self.view makeToast:NSLocalizedString(@"请填写完整地址信息", nil) duration:0.5 position:CSToastPositionCenter];
        [DCSpeedy dc_callFeedback]; //触动
        return;
    }
/*
    if (![DCCheckRegular dc_checkTelNumber:_adressHeadView.rePhoneField.text]) {
        [self.view makeToast:@"手机号码格式错误" duration:0.5 position:CSToastPositionCenter];
        
        return;
    }*/
   
    
    NSString *countryNum = @"";
    for (NSDictionary *dic in self.countyArr) {
        if ([dic[@"countyName"] isEqualToString:_adressHeadView.countryBtn.titleLabel.text]) {
            countryNum = dic[@"id"];
        }
    }
    if (countryNum.length <= 0) {
        [self.view makeToast:NSLocalizedString(@"请选择国家", nil) duration:0.5 position:CSToastPositionCenter];
        return;
    }
    
    DCAdressItem *adressItem =  (_saveType == DCSaveAdressNewType) ? [DCAdressItem new] : _adressItem;
    adressItem.userName = _adressHeadView.rePersonField.text;
    adressItem.userPhone = _adressHeadView.rePhoneField.text;
    adressItem.userAdress = VALIDATE_STRING(_adressHeadView.detailTextView.text);
    adressItem.chooseAdress = VALIDATE_STRING(_adressHeadView.addressLabel.text);
    adressItem.isDefault = @"1"; // 默认不选择
    if (_saveType == DCSaveAdressNewType) { //新建
        [[DCAdressDateBase sharedDataBase]addNewAdress:adressItem];
        
    }else if (_saveType == DCSaveAdressChangeType){ //更新
        
        [[DCAdressDateBase sharedDataBase]updateAdress:adressItem];
    }

    WEAKSELF
    [SVProgressHUD show];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        [weakSelf.view makeToast:NSLocalizedString(@"保存成功", nil) duration:0.5 position:CSToastPositionCenter];
//        [DCObjManager dc_removeUserDataForkey:@"StoreAddress"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpDateUI" object:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        });
    });
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    CGPoint point = [gestureRecognizer locationInView:gestureRecognizer.view];
    if (CGRectContainsPoint(_chooseLocationView.frame, point)){
        return NO;
    }
    return YES;
}


- (void)tapCover:(UITapGestureRecognizer *)tap{
    
    if (_chooseLocationView.chooseFinish) {
        _chooseLocationView.chooseFinish();
    }
}

- (ChooseLocationView *)chooseLocationView{
    
    if (!_chooseLocationView) {
        _chooseLocationView = [[ChooseLocationView alloc]initWithFrame:CGRectMake(0, ScreenH - 300, ScreenW, 300)];
        
    }
    return _chooseLocationView;
}

- (UIView *)cover{
    
    if (!_cover) {
        _cover = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _cover.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        [_cover addSubview:self.chooseLocationView];
        __weak typeof (self) weakSelf = self;
        _chooseLocationView.chooseFinish = ^{
            [UIView animateWithDuration:0.25 animations:^{
                weakSelf.adressHeadView.addressLabel.text = weakSelf.chooseLocationView.address;
                weakSelf.cover.hidden = YES;
            }];
        };
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCover:)];
        [_cover addGestureRecognizer:tap];
        tap.delegate = self;
        _cover.hidden = YES;
    }
    return _cover;
}

#pragma mark - 点击保存
- (void)saveButtonBarItemClick1
{
    [self.view endEditing:YES];
    
    if (_adressHeadView.rePersonField.text.length == 0 && _adressHeadView.rePhoneField.text.length == 0 && _adressHeadView.addressLabel.text.length == 0 && _adressHeadView.detailTextView.text.length == 0) {
        [self.view makeToast:NSLocalizedString(@"当前编辑为空", nil) duration:0.5 position:CSToastPositionCenter];
        return;
    }
    NSString *adress = (_adressHeadView.addressLabel.text == nil) ? @"" : _adressHeadView.addressLabel.text; //取空
    NSArray *storeAddress = @[_adressHeadView.rePersonField.text,_adressHeadView.rePhoneField.text,adress,_adressHeadView.detailTextView.text];
//    [DCObjManager dc_saveUserData:storeAddress forKey:@"StoreAddress"];
    [self.view makeToast:NSLocalizedString(@"保存成功", nil) duration:0.5 position:CSToastPositionCenter];
}
- (void)saveButtonBarItemClick{
    
    if (_adressHeadView.rePersonField.text.length == 0 || _adressHeadView.rePhoneField.text.length == 0 || _adressHeadView.detailTextView.text.length == 0) {
        [self.view makeToast:NSLocalizedString(@"请填写完整地址信息", nil) duration:0.5 position:CSToastPositionCenter];
        [DCSpeedy dc_callFeedback]; //触动
        return;
    }
/*
    if (![DCCheckRegular dc_checkTelNumber:_adressHeadView.rePhoneField.text]) {
        [self.view makeToast:@"手机号码格式错误" duration:0.5 position:CSToastPositionCenter];
        
        return;
    }*/
    NSString *countryNum = @"";
    for (NSDictionary *dic in self.countyArr) {
        if ([dic[@"countyName"] isEqualToString:_adressHeadView.countryBtn.titleLabel.text]) {
            countryNum = dic[@"id"];
        }
    }
    if ([countryNum isEqualToString:@""]) {
        [self.view makeToast:NSLocalizedString(@"请选择国家", nil) duration:0.5 position:CSToastPositionCenter];
        return;
    }
    
    DCAdressItem *adressItem =  (_saveType == DCSaveAdressNewType) ? [DCAdressItem new] : _adressItem;
    adressItem.userName = _adressHeadView.rePersonField.text;
    adressItem.userPhone = _adressHeadView.rePhoneField.text;
    adressItem.userAdress = _adressHeadView.detailTextView.text;
    adressItem.chooseAdress = _adressHeadView.addressLabel.text;
//    adressItem.isDefault = @"1"; // 默认不选择
//    if (_saveType == DCSaveAdressNewType) { //新建
//        [[DCAdressDateBase sharedDataBase]addNewAdress:adressItem];
//
//    }else if (_saveType == DCSaveAdressChangeType){ //更新
//
//        [[DCAdressDateBase sharedDataBase]updateAdress:adressItem];
//    }
    
    
    [SVProgressHUD show];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    NSDictionary *p = [NSDictionary new];
    if (_saveType == DCSaveAdressNewType) {
        p = @{
            @"address":[MGPHttpRequest shareManager].curretWallet.address,
            @"phone":adressItem.userPhone,
            @"userName":adressItem.userName,
            @"city":adressItem.chooseAdress,
            @"detailedAddress":adressItem.userAdress,
            @"country":countryNum,
            @"isDefault":@YES,
        };
    }else{
        p = @{
            @"address":[MGPHttpRequest shareManager].curretWallet.address,
            @"phone":adressItem.userPhone,
            @"userName":adressItem.userName,
            @"city":adressItem.chooseAdress,
            @"detailedAddress":adressItem.userAdress,
            @"isDefault":[adressItem.isDefault isEqualToString:@"1"]?@YES:@NO,
            @"id":adressItem.ID,
            @"country":countryNum,
            @"userId":adressItem.userId,

        };
    }
    
    
    WEAKSELF
    [[MGPHttpRequest shareManager]post:(_saveType == DCSaveAdressNewType) ? @"/appStoreUserAddr/addUserAddr" : @"/appStoreUserAddr/updateAddr" paramters:p completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];

        if ([responseObj[@"code"]intValue] == 0) {
            [SVProgressHUD dismiss];
            [weakSelf.view makeToast:NSLocalizedString(@"保存成功", nil) duration:0.5 position:CSToastPositionCenter];
            [weakSelf.navigationController popViewControllerAnimated:YES];

        }
    }];
    

}
@end
