//
//  ExportPrivateKeyOrMnemonicVC.m
//  TaiYiToken
//
//  Created by admin on 2018/9/5.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "ExportPrivateKeyOrMnemonicVC.h"
#import "AnnounceView.h"
@interface ExportPrivateKeyOrMnemonicVC ()
@property(nonatomic,strong) UIButton *backBtn;
@property(nonatomic)UILabel *titleLabel;
@property(nonatomic)AnnounceView *announceView;
@property(nonatomic)UITextView *detailTextView;
@property(nonatomic)UIButton *prikeyCopyBtn;
@end

@implementation ExportPrivateKeyOrMnemonicVC
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
    [self initUI];
    self.title = self.isExportPrivateKey == YES? NSLocalizedString(@"导出私钥", nil):NSLocalizedString(@"导出助记词", nil);
    
    
    
}
-(void)initHeadView{
    UIView *headBackView = [UIView new];
    headBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headBackView];
    [headBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(0);
        make.height.equalTo(SafeAreaTopHeight);
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
    
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont boldSystemFontOfSize:17];
    _titleLabel.textColor = [UIColor textBlackColor];
    [_titleLabel setText:self.isExportPrivateKey == YES? NSLocalizedString(@"导出私钥", nil):NSLocalizedString(@"导出助记词", nil)];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(SafeAreaTopHeight - 30);
        make.left.equalTo(45);
        make.width.equalTo(200);
        make.height.equalTo(20);
    }];
    
    
}

-(void)initUI{
    _announceView = [AnnounceView new];
    [_announceView initAnnounceView];
    if (self.isExportPrivateKey == YES) {
       _announceView.textView.text = NSLocalizedString(@"温馨提示：私钥相当于您的银行卡密码，请妥善保管！(切勿截图、存储到网络硬盘、微信等传输！)", nil);
    }else{
       _announceView.textView.text = NSLocalizedString(@"温馨提示：助记词相当于您的银行卡密码，请妥善保管！(切勿截图、存储到网络硬盘、微信等传输！)", nil);
    }
   
    [self.view addSubview:_announceView];
    [_announceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.top.equalTo(0);
        make.right.equalTo(-16);
        make.height.equalTo(100);
    }];
    
    UILabel *leftlabel = [UILabel new];
    leftlabel.font = [UIFont boldSystemFontOfSize:15];
    leftlabel.textColor = [UIColor textBlackColor];
    [leftlabel setText:self.isExportPrivateKey == YES? NSLocalizedString(@"私钥", nil):NSLocalizedString(@"助记词", nil)];
    leftlabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:leftlabel];
    [leftlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(210-84);
        make.left.equalTo(16);
        make.width.equalTo(100);
        make.height.equalTo(20);
    }];

    _detailTextView = [UITextView new];
    _detailTextView.layer.borderWidth = 1;
    _detailTextView.layer.borderColor = [UIColor blackColor].CGColor;
    _detailTextView.backgroundColor = [UIColor whiteColor];
    _detailTextView.font = [UIFont systemFontOfSize:12];
    _detailTextView.text = self.isExportPrivateKey == YES ? self.privateKey :self.mnemonic;
    _detailTextView.textAlignment = NSTextAlignmentLeft;
    _detailTextView.editable = NO;
    [self.view addSubview:_detailTextView];
    [_detailTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(250-84);
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.height.equalTo(50);
    }];
    NSLog(@"%@",self.mnemonic);
    if (self.isExportPrivateKey) {
        _prikeyCopyBtn = [UIButton buttonWithType: UIButtonTypeSystem];
        _prikeyCopyBtn.titleLabel.textColor = [UIColor textBlackColor];
        _prikeyCopyBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _prikeyCopyBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [_prikeyCopyBtn gradientButtonWithSize:CGSizeMake(ScreenWidth, 44) colorArray:@[[UIColor colorWithHexString:@"#4090F7"],[UIColor colorWithHexString:@"#57A8FF"]] percentageArray:@[@(0.3),@(1)] gradientType:GradientFromLeftTopToRightBottom];
        _prikeyCopyBtn.tintColor = [UIColor textWhiteColor];
        _prikeyCopyBtn.userInteractionEnabled = YES;
        [_prikeyCopyBtn setTitle:NSLocalizedString(@"复制私钥", nil) forState:UIControlStateNormal];
        [_prikeyCopyBtn addTarget:self action:@selector(copyPrivateKey) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_prikeyCopyBtn];
        [_prikeyCopyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.bottom.equalTo(-SafeAreaBottomHeight);
            make.height.equalTo(44);
        }];
    }
    
}

-(void)copyPrivateKey{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.privateKey;
    [self.view showMsg:NSLocalizedString(@"私钥已复制", nil)];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
