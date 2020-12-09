//
//  ExportEOSPriKeyVC.m
//  TaiYiToken
//
//  Created by 张元一 on 2018/11/30.
//  Copyright © 2018 admin. All rights reserved.
//

#import "ExportEOSPriKeyVC.h"
#import "AnnounceView.h"
@interface ExportEOSPriKeyVC ()
@property(nonatomic,strong) UIButton *backBtn;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)AnnounceView *announceView;
@property(nonatomic,strong)UITextView *detailTextView;
@property(nonatomic,strong)UIButton *prikeyCopyBtn;
@property(nonatomic,strong)UIButton *qrcodeBtn;
@end

@implementation ExportEOSPriKeyVC
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
    self.title = NSLocalizedString(@"导出私钥", nil);
    [self initUI];
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
    [_titleLabel setText:NSLocalizedString(@"导出私钥", nil)];
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
    _announceView.textView.text = NSLocalizedString(@"温馨提示：私钥相当于您的银行卡密码，请妥善保管！(切勿截图、存储到网络硬盘、微信等传输！)", nil);
    [self.view addSubview:_announceView];
    [_announceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.top.equalTo(0);
        make.right.equalTo(-16);
        make.height.equalTo(100);
    }];
    
    
    
    _detailTextView = [UITextView new];
    _detailTextView.layer.borderColor = [UIColor blackColor].CGColor;
    _detailTextView.layer.borderWidth = 0.3;
    _detailTextView.layer.cornerRadius = 10;
    _detailTextView.layer.masksToBounds = YES;
    _detailTextView.backgroundColor = [UIColor whiteColor];
    _detailTextView.font = [UIFont systemFontOfSize:12];
    _detailTextView.text = [NSString stringWithFormat:@"\n\n%@", self.publicKey];
    _detailTextView.textAlignment = NSTextAlignmentLeft;
    _detailTextView.editable = NO;
    [self.view addSubview:_detailTextView];
    [_detailTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(210-84);
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.height.equalTo(80);
    }];

    
    
    NSTextAttachment * attach = [[NSTextAttachment alloc] init];
    attach.image = [UIImage imageNamed:@"ico_password"];
    attach.bounds = CGRectMake(0, 0, 10, 10);
    NSAttributedString * imageStr = [NSAttributedString attributedStringWithAttachment:attach];
    
    NSMutableAttributedString *title =  [[NSMutableAttributedString alloc] initWithString:VALIDATE_STRING(self.privateKey) attributes:@{NSForegroundColorAttributeName:[UIColor textBlackColor], NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    [title appendAttributedString:imageStr];
    
     _prikeyCopyBtn = [UIButton buttonWithType: UIButtonTypeCustom];
     _prikeyCopyBtn.titleLabel.textColor = [UIColor textBlackColor];
     _prikeyCopyBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
     _prikeyCopyBtn.contentEdgeInsets = UIEdgeInsetsMake(10, 3, 5, 5);
     _prikeyCopyBtn.titleLabel.font = [UIFont systemFontOfSize:12];
     _prikeyCopyBtn.titleLabel.numberOfLines = 0;
     _prikeyCopyBtn.layer.borderWidth = 0.3;
     _prikeyCopyBtn.layer.cornerRadius = 10;
     _prikeyCopyBtn.layer.masksToBounds = YES;
     _prikeyCopyBtn.layer.borderColor = [UIColor blackColor].CGColor;
     _prikeyCopyBtn.tintColor = [UIColor textWhiteColor];
     _prikeyCopyBtn.userInteractionEnabled = YES;
     [_prikeyCopyBtn setAttributedTitle:title forState:UIControlStateNormal];
     [_prikeyCopyBtn addTarget:self action:@selector(copyPrivateKey) forControlEvents:UIControlEventTouchUpInside];
     [self.view addSubview:_prikeyCopyBtn];
     [_prikeyCopyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.equalTo(340-84);
         make.left.equalTo(15);
         make.right.equalTo(-15);
         make.height.equalTo(100);
    }];
    
    UIButton *qrcodebtn = [UIButton buttonWithType:UIButtonTypeSystem];
    qrcodebtn.backgroundColor = [UIColor appBlueColor];
    qrcodebtn.titleLabel.textColor = [UIColor textBlackColor];
    qrcodebtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    qrcodebtn.titleLabel.font = [UIFont systemFontOfSize:13];
    qrcodebtn.titleLabel.numberOfLines = 0;
    qrcodebtn.layer.cornerRadius = 2;
    qrcodebtn.layer.masksToBounds = YES;
    qrcodebtn.tintColor = [UIColor textWhiteColor];
    qrcodebtn.userInteractionEnabled = YES;
    [qrcodebtn setTitle:NSLocalizedString(@"二维码", nil) forState:UIControlStateNormal];
    [qrcodebtn addTarget:self action:@selector(showQRCode) forControlEvents:UIControlEventTouchUpInside];
    [self.prikeyCopyBtn addSubview:qrcodebtn];
    [qrcodebtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(-10);
        make.right.equalTo(-10);
        make.width.equalTo(80);
        make.height.equalTo(25);
    }];
    
    
    UILabel *leftlabel = [UILabel new];
    leftlabel.font = [UIFont boldSystemFontOfSize:15];
    leftlabel.textColor = [UIColor textBlackColor];
    [leftlabel setText:NSLocalizedString(@"公钥", nil)];
    leftlabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:leftlabel];
    [leftlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(215-84);
        make.left.equalTo(20);
        make.width.equalTo(100);
        make.height.equalTo(20);
    }];
    
    UILabel *leftlabel2 = [UILabel new];
    leftlabel2.font = [UIFont boldSystemFontOfSize:15];
    leftlabel2.textColor = [UIColor textBlackColor];
    [leftlabel2 setText:NSLocalizedString(@"私钥", nil)];
    leftlabel2.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:leftlabel2];
    [leftlabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(345-84);
        make.left.equalTo(20);
        make.width.equalTo(100);
        make.height.equalTo(20);
    }];
}

-(void)showQRCode{
    self.qrcodeBtn.frame = CGRectMake(ScreenWidth/2, ScreenHeight/2, 0, 0);
    [UIView animateWithDuration:0.4 animations:^{
        self.qrcodeBtn.frame = CGRectMake(ScreenWidth/2 - 75, ScreenHeight/2 - 75, 150, 150);
    } completion:^(BOOL finished) {
        
    }];
   
}

-(UIButton *)qrcodeBtn{
    if (!_qrcodeBtn) {
        UIImage *qrcode = [CreateAll CreateQRCodeForAddress:self.privateKey];
        _qrcodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_qrcodeBtn addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
        [_qrcodeBtn setImage:qrcode forState:UIControlStateNormal];
        [self.view addSubview:_qrcodeBtn];
    }
    return _qrcodeBtn;
}
-(void)shareAction{
    
    UIImage *shareImage = [CreateAll CreateQRCodeForAddress:self.privateKey];
    NSArray *activityItemsArray = @[shareImage];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItemsArray applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypePostToWeibo,UIActivityTypeMessage,UIActivityTypeMail,UIActivityTypePostToTencentWeibo,UIActivityTypeAirDrop];
    activityVC.completionWithItemsHandler = ^(NSString *activityType,BOOL completed,NSArray *returnedItems,NSError *activityError)
    {
        NSLog(@"%@", activityType);
        
        if (completed) { // 确定分享
            NSLog(@"分享成功");
        }
        else {
            NSLog(@"分享失败");
        }
    };
    
    [self presentViewController:activityVC animated:YES completion:nil];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [UIView animateWithDuration:0.4 animations:^{
        self.qrcodeBtn.frame = CGRectMake(ScreenWidth/2, ScreenHeight/2, 0, 0);
    } completion:^(BOOL finished) {
        [self.qrcodeBtn removeFromSuperview];
        self.qrcodeBtn = nil;
    }];
   
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
