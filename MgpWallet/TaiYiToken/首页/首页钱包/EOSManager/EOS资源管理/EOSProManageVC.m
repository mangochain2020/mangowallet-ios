//
//  EOSProManageVC.m
//  TaiYiToken
//
//  Created by 张元一 on 2018/12/19.
//  Copyright © 2018 admin. All rights reserved.
//

#import "EOSProManageVC.h"
#import "JWProgressView.h"
#import "EOSProView.h"
#import "EOSCNView.h"
#import "EOSCNVC.h"
#import "EOSRAMVC.h"

@interface EOSProManageVC ()<JWProgressViewDelegate>

@property(nonatomic,strong)JWProgressView *progressView;
@property(nonatomic,strong)UILabel *titlelabel;
@property(nonatomic,strong)UIButton *backBtn;
@property(nonatomic,strong)AccountInfo *eosAccountInfo;
@property(nonatomic,strong)EOSProView *pro;
@property(nonatomic,strong)EOSCNView *detailView;
@end

@implementation EOSProManageVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
//    self.navigationController.navigationBar.hidden = YES;
//    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
//    self.navigationController.hidesBottomBarWhenPushed = YES;
//    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
//    self.tabBarController.tabBar.hidden = NO;
//    self.navigationController.navigationBar.hidden = NO;
//    self.navigationController.hidesBottomBarWhenPushed = NO;
}
- (void)popAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    [self initHeadView];
    self.title = NSLocalizedString(@"资源管理", nil);
    [self.view showHUD];
    MJWeakSelf
    [self getEOSAccount:self.wallet.address Success:^(id response) {
        [weakSelf.view hideHUD];
        if (response) {
//            NSLog(@"res\n\n%@",response);
            AccountInfo *info = [AccountInfo parse:response];
            weakSelf.eosAccountInfo = info;
            NSString *valuestring = [info.core_liquid_balance componentsSeparatedByString:@" "].firstObject;
            CGFloat balance = valuestring.doubleValue;
            CGFloat stake = info.voter_info.staked*1.0/pow(10, 4);
            CGFloat cpureclaiming = self.wallet.coinType == EOS ? [info.refund_request.cpu_amount componentsSeparatedByString:@" EOS"].firstObject.doubleValue : [info.refund_request.cpu_amount componentsSeparatedByString:@" MGP"].firstObject.doubleValue;
            CGFloat netreclaiming = self.wallet.coinType == EOS ? [info.refund_request.net_amount componentsSeparatedByString:@" EOS"].firstObject.doubleValue : [info.refund_request.net_amount componentsSeparatedByString:@" MGP"].firstObject.doubleValue;
            CGFloat reclaiming = cpureclaiming + netreclaiming;
            CGFloat total = balance + stake + reclaiming;
            weakSelf.progressView = [[JWProgressView alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 40, 20, 100, 100)];
            weakSelf.progressView.delegate = weakSelf;
            weakSelf.progressView.stakeValue = stake*1.0/total;
            weakSelf.progressView.reclaimingValue = reclaiming*1.0/total;
            [weakSelf.view addSubview:weakSelf.progressView];
//            [NSTimer scheduledTimerWithTimeInterval:0.05 target:weakSelf selector:@selector(changeProgressValue) userInfo:nil repeats:YES];
            
            
            weakSelf.pro = [EOSProView new];
            weakSelf.pro.coinType = self.wallet.coinType;
            weakSelf.pro.backgroundColor = [UIColor whiteColor];
            weakSelf.pro.staked = stake;
            weakSelf.pro.reclaiming = reclaiming;
            weakSelf.pro.balance = balance;
            weakSelf.pro.total = total;
            [weakSelf.view addSubview:weakSelf.pro];
            [weakSelf.pro mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(0);
                make.top.equalTo(130);
                make.height.equalTo(120);
            }];
         
            
            weakSelf.detailView = [EOSCNView new];
            weakSelf.detailView.coinType = self.wallet.coinType;
            weakSelf.detailView.backgroundColor = [UIColor whiteColor];
            weakSelf.detailView.cpu = info.cpu_limit.available;
            weakSelf.detailView.cputotal = info.cpu_limit.max;
            weakSelf.detailView.ram = (info.ram_quota - info.ram_usage)/1.024;
            weakSelf.detailView.ramtotal = info.ram_quota/1.024;
            weakSelf.detailView.net = info.net_limit.available;
            weakSelf.detailView.nettotal = info.net_limit.max;
            weakSelf.detailView.userInteractionEnabled = YES;
            [weakSelf.detailView.ramBtn addTarget:weakSelf action:@selector(ramManage) forControlEvents:UIControlEventTouchUpInside];
            [weakSelf.detailView.cnBtn addTarget:weakSelf action:@selector(cnManage) forControlEvents:UIControlEventTouchUpInside];
            [weakSelf.view addSubview:weakSelf.detailView];
            [weakSelf.detailView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(0);
                make.top.equalTo(260);
                make.height.equalTo(250);
            }];
            
        }else{
            [weakSelf.view showMsg:@"Get account failed"];
        }
    }];
}

-(void)ramManage{
    EOSRAMVC *vc = [EOSRAMVC new];
    vc.wallet = self.wallet;
    vc.eosAccountInfo = self.eosAccountInfo;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)cnManage{
    EOSCNVC *vc = [EOSCNVC new];
    vc.wallet = self.wallet;
    vc.eosAccountInfo = self.eosAccountInfo;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)getEOSAccount:(NSString *)account Success:(void(^)(id response))handler{
    NSDictionary *dic = @{@"account_name":account};

    if (self.wallet.coinType == EOS){
        [[HTTPRequestManager shareEosManager] post:eos_get_account paramters:dic success:^(BOOL isSuccess, id responseObject) {
            
            if (isSuccess) {
                handler(responseObject);
            }else{
                handler(nil);
            }
        } failure:^(NSError *error) {
            
        } superView:self.view showFaliureDescription:YES];
    }else{
        [[HTTPRequestManager shareMgpManager] post:eos_get_account paramters:dic success:^(BOOL isSuccess, id responseObject) {
            
            if (isSuccess) {
                handler(responseObject);
            }else{
                handler(nil);
            }
        } failure:^(NSError *error) {
            
        } superView:self.view showFaliureDescription:YES];
    }
    
    
    
}


-(void)initHeadView{
    UIView *headBackView = [UIView new];
    headBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headBackView];
    [headBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(SafeAreaTopHeight);
        make.height.equalTo(150);
    }];
    _titlelabel = [[UILabel alloc] init];
    _titlelabel.textColor = [UIColor textBlackColor];
    _titlelabel.font = [UIFont boldSystemFontOfSize:18];
    _titlelabel.text = NSLocalizedString(@"资源管理", nil);
    _titlelabel.textAlignment = NSTextAlignmentLeft;
    _titlelabel.numberOfLines = 1;
    [self.view addSubview:_titlelabel];
    [_titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(SafeAreaTopHeight - 34);
        make.left.equalTo(45);
        make.width.equalTo(200);
        make.height.equalTo(20);
    }];
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.backgroundColor = [UIColor clearColor];
    _backBtn.tintColor = [UIColor whiteColor];
    [_backBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [_backBtn setImage:[UIImage imageNamed:@"ico_right_arrow"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backBtn];
    _backBtn.userInteractionEnabled = YES;
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(SafeAreaTopHeight - 34);
        make.height.equalTo(25);
        make.left.equalTo(10);
        make.width.equalTo(30);
    }];
    
}

-(void)progressViewOver:(JWProgressView *)progressView{
    
}
@end
