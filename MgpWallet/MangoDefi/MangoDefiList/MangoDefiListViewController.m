//
//  MangoDefiListViewController.m
//  TaiYiToken
//
//  Created by mac on 2020/8/31.
//  Copyright © 2020 admin. All rights reserved.
//

#import "MangoDefiListViewController.h"
#import "MangoDefiListTableViewCell.h"
#import "CoreLocation/CoreLocation.h"
#import "MangoDefiPayViewController.h"

static NSString *const MangoDefiListCellID = @"DCOrderListTableViewCell";

@interface MangoDefiListViewController ()<CLLocationManagerDelegate>
{
    CLLocationManager*locationmanager;//定位服务

    NSString*strlatitude;//经度

    NSString*strlongitude;//纬度

    NSString*key;//搜索关键字

}
@property (strong,nonatomic)NSArray *listArray;



@end

@implementation MangoDefiListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MangoDefiListTableViewCell class]) bundle:nil] forCellReuseIdentifier:MangoDefiListCellID];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.rowHeight = 235;
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 65, 0)];

            
    self.tableView.mj_header = [DCHomeRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(startLocation)];
    [self.tableView.mj_header beginRefreshing];
    
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
    key = @"";
    
    [self upRecDataForLongitude:strlongitude andLatitude:strlatitude andKey:key];
/*
    //反地理编码
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error)
    {
        NSLog(@"反地理编码");
        NSLog(@"反地理编码%ld",placemarks.count);
        if (placemarks.count > 0) {
            CLPlacemark *placeMark = placemarks[0];
//            self.label_city.text = placeMark.locality;
//            if (!self.label_city.text) {
//                self.label_city.text = @"无法定位当前城市";
//            }
            NSLog(@"城市----%@",placeMark.country);//当前国家
            NSLog(@"城市%@",placeMark.locality);//当前的城市
            NSLog(@"%@",placeMark.subLocality);//当前的位置
            NSLog(@"%@",placeMark.thoroughfare);//当前街道
            NSLog(@"%@",placeMark.name);//具体地址
            
        }
    }];*/
    
}


- (void)upRecDataForLongitude:(NSString *)longitude andLatitude:(NSString *)latitude andKey:(NSString *)key{

    [[MGPHttpRequest shareManager]post:@"/api/appStoreLife" paramters:@{@"countryId":self.countryID,@"type":self.defiID,@"page":@"1",@"size":@"100",@"longitude":longitude,@"latitude":latitude,@"key":key} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {

        if ([responseObj[@"code"]intValue] == 0) {
            self.listArray = responseObj[@"data"];
        }
        dispatch_async(dispatch_get_main_queue(), ^{

            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];

        });
        
    }];
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.listArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MangoDefiListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MangoDefiListCellID forIndexPath:indexPath];
    
    cell.address.text = [NSString stringWithFormat:@"%@ %@",[self.listArray[indexPath.row]objectForKey:@"name"],[self.listArray[indexPath.row]objectForKey:@"address"]];
    cell.bankTime.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"营业时间", nil),[self.listArray[indexPath.row]objectForKey:@"bankTime"]];

    NSArray *arr = [self.listArray[indexPath.row]objectForKey:@"img"];
    [cell.img sd_setImageWithURL:[NSURL URLWithString:arr.firstObject]];

    [cell.buyBtn setTitle:NSLocalizedString(@"买单", nil) forState:UIControlStateNormal];
    cell.buyBtn.tag = indexPath.row;
    [cell.buyBtn addTarget:self action:@selector(pushPayViewController:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    return cell;
}
- (void)pushPayViewController:(UIButton *)btn{
    
    MangoDefiPayViewController *VC = [MangoDefiPayViewController new];
    VC.dataDic = self.listArray[btn.tag];
    [self.navigationController pushViewController:VC animated:YES];
    
    
    
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
