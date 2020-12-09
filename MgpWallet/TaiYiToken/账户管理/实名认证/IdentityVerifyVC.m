//
//  IdentityVerifyVC.m
//  TaiYiToken
//
//  Created by Frued on 2018/10/19.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "IdentityVerifyVC.h"
#import "UpLoadIdInfoVC.h"
#import "GraphView.h"
@interface IdentityVerifyVC ()
@property(nonatomic,strong)UILabel *titlelabel;
@property(nonatomic,strong)UIButton *backBtn;

@property(nonatomic,strong)UIImageView *iconIV;

@property(nonatomic,strong)UIButton *verifyBtn;

@property(nonatomic,strong)UILabel *usernamelb;
@property(nonatomic,strong)UILabel *idCardNumlb;
@property(nonatomic,strong)UILabel *statuslb;
@end

@implementation IdentityVerifyVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    self.navigationController.hidesBottomBarWhenPushed = YES;
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.hidesBottomBarWhenPushed = NO;
}
- (void)popAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initHeadView];
}

-(void)initHeadView{
    UIView *headBackView = [UIView new];
    headBackView.backgroundColor = RGB(80, 145, 255);
    [self.view addSubview:headBackView];
    [headBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(0);
        make.height.equalTo(150);
    }];
    _titlelabel = [[UILabel alloc] init];
    _titlelabel.textColor = [UIColor textWhiteColor];
    _titlelabel.font = [UIFont boldSystemFontOfSize:18];
    _titlelabel.text = NSLocalizedString(@"我的实名信息", nil);
    _titlelabel.textAlignment = NSTextAlignmentCenter;
    _titlelabel.numberOfLines = 1;
    [headBackView addSubview:_titlelabel];
    [_titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.top.equalTo(SafeAreaTopHeight - 34);
        make.width.equalTo(200);
        make.height.equalTo(20);
    }];
    
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.backgroundColor = [UIColor clearColor];
    _backBtn.tintColor = [UIColor whiteColor];
    [_backBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [_backBtn setImage:[UIImage imageNamed:@"ico_right_arrow1"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backBtn];
    _backBtn.userInteractionEnabled = YES;
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(SafeAreaTopHeight - 34);
        make.height.equalTo(25);
        make.left.equalTo(10);
        make.width.equalTo(30);
    }];
    
    UIImageView *headbackiv = [UIImageView new];
    headbackiv.image = [UIImage imageNamed:@"idverback"];
    [self.view addSubview:headbackiv];
    [headbackiv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(SafeAreaTopHeight);
        make.left.right.equalTo(0);
        make.height.equalTo(195);
    }];
    
    _iconIV = [UIImageView new];
    _iconIV.image = [UIImage imageNamed:@"yklh"];
    [headbackiv addSubview:_iconIV];
    [_iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(20);
        make.centerX.equalTo(0);
        make.width.height.equalTo(68);
    }];
    
    UILabel *lb0 = [[UILabel alloc] init];
    lb0.textColor = [UIColor textWhiteColor];
    lb0.font = [UIFont systemFontOfSize:13];
    lb0.text = NSLocalizedString(@"姓名", nil);
    lb0.textAlignment = NSTextAlignmentLeft;
    lb0.numberOfLines = 1;
    [headbackiv addSubview:lb0];
    [lb0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(20);
        make.top.equalTo(110);
        make.width.equalTo(50);
        make.height.equalTo(20);
    }];
    
    UILabel *lb1 = [[UILabel alloc] init];
    lb1.textColor = [UIColor textWhiteColor];
    lb1.font = [UIFont systemFontOfSize:13];
    lb1.text = NSLocalizedString(@"身份证号", nil);
    lb1.textAlignment = NSTextAlignmentLeft;
    lb1.numberOfLines = 1;
    [headbackiv addSubview:lb1];
    [lb1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(20);
        make.top.equalTo(150);
        make.width.equalTo(80);
        make.height.equalTo(20);
    }];
    
    _usernamelb = [[UILabel alloc] init];
    _usernamelb.textColor = [UIColor textWhiteColor];
    _usernamelb.font = [UIFont systemFontOfSize:13];
    _usernamelb.textAlignment = NSTextAlignmentRight;
    _usernamelb.numberOfLines = 1;
    [headbackiv addSubview:_usernamelb];
    [_usernamelb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-20);
        make.top.equalTo(110);
        make.width.equalTo(200);
        make.height.equalTo(20);
    }];
    
    _idCardNumlb = [[UILabel alloc] init];
    _idCardNumlb.textColor = [UIColor textWhiteColor];
    _idCardNumlb.font = [UIFont systemFontOfSize:13];
    _idCardNumlb.textAlignment = NSTextAlignmentRight;
    _idCardNumlb.numberOfLines = 1;
    [headbackiv addSubview:_idCardNumlb];
    [_idCardNumlb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-20);
        make.top.equalTo(150);
        make.width.equalTo(300);
        make.height.equalTo(20);
    }];
    
    _verifyBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _verifyBtn.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_verifyBtn];
    [_verifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headbackiv.mas_bottom);
        make.left.right.equalTo(0);
        make.height.equalTo(110);
    }];
    
    UILabel *lb2 = [[UILabel alloc] init];
    lb2.textColor = [UIColor textDarkColor];
    lb2.font = [UIFont systemFontOfSize:13];
    lb2.text = NSLocalizedString(@"验证以下信息享更高的数据权限", nil);
    lb2.textAlignment = NSTextAlignmentLeft;
    lb2.numberOfLines = 0;
    [_verifyBtn addSubview:lb2];
    [lb2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(18);
        make.left.equalTo(20);
        make.right.equalTo(-10);
        make.height.equalTo(35);
    }];
    
    UILabel *lb3 = [[UILabel alloc] init];
    lb3.textColor = [UIColor textDarkColor];
    lb3.font = [UIFont systemFontOfSize:15];
    lb3.text = NSLocalizedString(@"身份认证", nil);
    lb3.textAlignment = NSTextAlignmentLeft;
    lb3.numberOfLines = 0;
    [_verifyBtn addSubview:lb3];
    [lb3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(65);
        make.left.equalTo(20);
        make.right.equalTo(-10);
        make.height.equalTo(20);
    }];
    
    _statuslb = [[UILabel alloc] init];
    _statuslb.textColor = [UIColor textDarkColor];
    _statuslb.font = [UIFont systemFontOfSize:15];
    _statuslb.textAlignment = NSTextAlignmentRight;
    _statuslb.numberOfLines = 1;
    [_verifyBtn addSubview:_statuslb];
    [_statuslb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(65);
        make.right.equalTo(-50);
        make.width.equalTo(90);
        make.height.equalTo(20);
    }];
    
    UIImageView *iv = [UIImageView new];
    iv.image = [UIImage imageNamed:@"ggf"];
    iv.hidden = YES;
    [_statuslb addSubview:iv];
    [iv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.centerY.equalTo(0);
        make.width.height.equalTo(15);
    }];
    
    UIImageView *riv = [UIImageView new];
    riv.image = [UIImage imageNamed:@"ico_left_arrow-z"];
    [_verifyBtn addSubview:riv];
    [riv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(67);
        make.right.equalTo(-20);
        make.width.equalTo(10);
        make.height.equalTo(15);
    }];
    
    //data
//    NSInteger verstatus = [CreateAll GetUserIDVerifyStatusForCurrentUser];
    UserInfoModel *user = [CreateAll GetCurrentUser];
    if (user.idCardNo != nil && user.idCardNo.length > 1 && user.realName != nil && user.realName.length > 1) {
        _usernamelb.text = VALIDATE_STRING(user.realName);
        _idCardNumlb.text = VALIDATE_STRING(user.idCardNo);
        iv.hidden = NO;
        _statuslb.text = NSLocalizedString(@"验证通过", nil);
    }else{
        _usernamelb.text = NSLocalizedString(@"未知", nil);
        _idCardNumlb.text = NSLocalizedString(@"未知", nil);
        iv.hidden = YES;
        _statuslb.text = NSLocalizedString(@"未验证", nil);
        [_verifyBtn addTarget:self action:@selector(uploadPhotos) forControlEvents:UIControlEventTouchUpInside];
    }
//    if (verstatus == -1) {
//        [self.view showMsg:NSLocalizedString(@"未登录", nil)];
//        [self.navigationController popViewControllerAnimated:YES];
//        iv.hidden = YES;
//        _statuslb.text = NSLocalizedString(@"未验证", nil);
//    }else if (verstatus == USERIDENTITY_VERIFY_NONE){
//        _usernamelb.text = NSLocalizedString(@"未知", nil);
//        _idCardNumlb.text = NSLocalizedString(@"未知", nil);
//        iv.hidden = YES;
//        _statuslb.text = NSLocalizedString(@"未验证", nil);
//    }else if (verstatus == USERIDENTITY_VERIFY_FAILD){
//        _usernamelb.text = NSLocalizedString(@"未知", nil);
//        _idCardNumlb.text = NSLocalizedString(@"未知", nil);
//        iv.hidden = YES;
//        _statuslb.text = NSLocalizedString(@"失败", nil);
//    }else if (verstatus == USERIDENTITY_VERIFY_SUCCESS){
//        _usernamelb.text = VALIDATE_STRING(user.realName);
//        _idCardNumlb.text = VALIDATE_STRING(user.idCardNo);
//        iv.hidden = NO;
//        _statuslb.text = NSLocalizedString(@"验证通过", nil);
//    }
    [self RequestUserTagData];
}

-(void)RequestUserTagData{
    MJWeakSelf
    [NetManager GETUserTagCompletionHandler:^(id responseObj, NSError *error) {
        if (!error) {
            if (![[NSString stringWithFormat:@"%@",responseObj[@"resultCode"]] isEqualToString:@"20000"]) {
                [weakSelf.view showAlert:[NSString stringWithFormat:@"Error:%ld",error.code] DetailMsg:responseObj[@"resultMsg"]];
                return ;
            }
            NSArray *arr;
            arr = responseObj[@"data"];
            if([arr isEqual:[NSNull null]] || arr ==  nil || arr.count < 1){
                return;
            }
            NSMutableDictionary *dataDic = [NSMutableDictionary new];
            NSMutableArray *namearr = [NSMutableArray new];
            // 多线的， 可以根据需求进行调整
            NSString *maxvalue;
            NSString *score;
            NSString *name;
            for (NSDictionary *dic in arr) {
                if (dic == nil) {
                    break;
                }
                name = [dic objectForKey:@"name"];
                score = [dic objectForKey:@"score"];
                maxvalue = [dic objectForKey:@"max"];
                if (name == nil) {
                    break;
                }
                [dataDic setObject:VALIDATE_STRING(score) forKey:VALIDATE_STRING(name)];
                [namearr addObject:name];
            }
           
            GraphView *grapview = [[GraphView alloc]initWithFrame:weakSelf.view.bounds];
            grapview.maxvalue = maxvalue.integerValue;
            grapview.nameArr = namearr;
            grapview.dataDic = dataDic;// 传值到 UIView界面
            grapview.backgroundColor = [UIColor clearColor];
            dispatch_sync_on_main_queue(^{
                [weakSelf.view addSubview:grapview];
                [grapview mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.equalTo(0);
                    make.top.equalTo(weakSelf.verifyBtn.mas_bottom).equalTo(5);
                    make.width.equalTo(ScreenWidth);
                    make.height.equalTo(ScreenHeight);
                }];
            });
        }else{
            [weakSelf.view showAlert:[NSString stringWithFormat:@"Error:%ld",error.code] DetailMsg:error.localizedDescription];
        }
    }];
    
    
}


-(void)uploadPhotos{
    UpLoadIdInfoVC *vc = [UpLoadIdInfoVC new];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
