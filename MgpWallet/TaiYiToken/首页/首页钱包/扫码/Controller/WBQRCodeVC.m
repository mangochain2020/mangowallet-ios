//
//  WBQRCodeVC.m
//  SGQRCodeExample
//
//  Created by kingsic on 2018/2/8.
//  Copyright © 2018年 kingsic. All rights reserved.
//

#import "WBQRCodeVC.h"
#import "SGQRCode.h"
#import "ScanSuccessJumpVC.h"
#import "SGQRCodeScanView.h"
#import "MBProgressHUD+SGQRCode.h"

@interface WBQRCodeVC () {
    SGQRCodeObtain *obtain;
}
@property (nonatomic, strong) SGQRCodeScanView *scanView;
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, assign) BOOL stop;
@property(nonatomic)UILabel *titlelb;
@end

@implementation WBQRCodeVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_stop) {
        [obtain startRunningWithBefore:^{
            // 在此可添加 HUD
        
        } completion:^{
            // 在此可移除 HUD
        }];
    }
}

- (void)viewDidAppear:(BOOL)animated {
//    self.navigationController.navigationBar.hidden = NO;
//    self.navigationController.hidesBottomBarWhenPushed = NO;
    [super viewDidAppear:animated];
    [self.scanView addTimer];
}

- (void)viewWillDisappear:(BOOL)animated {
//    self.navigationController.navigationBar.hidden = YES;
//    self.navigationController.hidesBottomBarWhenPushed = YES;
    [super viewWillDisappear:animated];
    [self.scanView removeTimer];
}

- (void)dealloc {
    NSLog(@"WBQRCodeVC - dealloc");
    [self removeScanningView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor blackColor];
    obtain = [SGQRCodeObtain QRCodeObtain];
    
    [self setupQRCodeScan];
    [self setupNavigationBar];
    [self.view addSubview:self.scanView];
    [self.view addSubview:self.promptLabel];
}

- (void)setupQRCodeScan {
    __weak typeof(self) weakSelf = self;

    SGQRCodeObtainConfigure *configure = [SGQRCodeObtainConfigure QRCodeObtainConfigure];
    configure.openLog = YES;
    configure.rectOfInterest = CGRectMake(0.05, 0.2, 0.7, 0.6);
    // 这里只是提供了几种作为参考（共：13）；需什么类型添加什么类型即可
    NSArray *arr = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    configure.metadataObjectTypes = arr;
    
    [obtain establishQRCodeObtainScanWithController:self configure:configure];
    [obtain startRunningWithBefore:^{
        [MBProgressHUD SG_showMBProgressHUDWithModifyStyleMessage:NSLocalizedString(@"正在加载...", nil) toView:weakSelf.view];
    } completion:^{
        [MBProgressHUD SG_hideHUDForView:weakSelf.view];
    }];
    [obtain setBlockWithQRCodeObtainScanResult:^(SGQRCodeObtain *obtain, NSString *result) {
        if (result) {
            [obtain stopRunning];
            weakSelf.stop = YES;
            [obtain playSoundName:@"SGQRCode.bundle/sound.caf"];

            if (weakSelf.GetQRCodeResult) {
                weakSelf.GetQRCodeResult(result);
            }
           // [weakSelf.navigationController popViewControllerAnimated:YES];
            [weakSelf dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
    }];
}

- (void)setupNavigationBar {
    
    _titlelb = [UILabel new];
//    _titlelb.textColor = [UIColor whiteColor];
    _titlelb.textAlignment = NSTextAlignmentCenter;
    _titlelb.font = [UIFont systemFontOfSize:20 weight:0];
    _titlelb.text = NSLocalizedString(@"扫一扫", nil);
    [self.navigationController.navigationBar addSubview:_titlelb];
    [_titlelb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.top.equalTo(7);
        make.height.equalTo(28);
        make.width.equalTo(100);
    }];
//    self.navigationController.navigationBar.translucent = NO;
//    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
    
    UIButton *scanBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    [scanBtn setBackgroundImage:[UIImage imageNamed:@"photo-b-vv"] forState:UIControlStateNormal];
    [scanBtn addTarget:self action:@selector(rightBarButtonItenAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:scanBtn];

    UIButton *backBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"ico_dw_arrow-z"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(leftBarButtonItenAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];

    
    
}
-(void)leftBarButtonItenAction{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)rightBarButtonItenAction {
    __weak typeof(self) weakSelf = self;

    [obtain establishAuthorizationQRCodeObtainAlbumWithController:nil];
    if (obtain.isPHAuthorization == YES) {
        [self.scanView removeTimer];
    }
    [obtain setBlockWithQRCodeObtainAlbumDidCancelImagePickerController:^(SGQRCodeObtain *obtain) {
        [weakSelf.view addSubview:weakSelf.scanView];
    }];
    [obtain setBlockWithQRCodeObtainAlbumResult:^(SGQRCodeObtain *obtain, NSString *result) {
        if (result == nil) {
            NSLog(NSLocalizedString(@"暂未识别出二维码", nil));
        } else {
            if ([result hasPrefix:@"http"]) {
                ScanSuccessJumpVC *jumpVC = [[ScanSuccessJumpVC alloc] init];
                jumpVC.comeFromVC = ScanSuccessJumpComeFromWB;
                jumpVC.jump_URL = result;
                [weakSelf.navigationController pushViewController:jumpVC animated:YES];
            } else {
                if (weakSelf.GetQRCodeResult) {
                    weakSelf.GetQRCodeResult(result);
                }
               // [weakSelf.navigationController popViewControllerAnimated:YES];
                [weakSelf dismissViewControllerAnimated:YES completion:^{
                    
                }];
            }
        }
    }];
}

- (SGQRCodeScanView *)scanView {
    if (!_scanView) {
        _scanView = [[SGQRCodeScanView alloc] initWithFrame:CGRectMake(0, -50, self.view.frame.size.width, self.view.frame.size.height)];
        // 静态库加载 bundle 里面的资源使用 SGQRCode.bundle/QRCodeScanLineGrid
        // 动态库加载直接使用 QRCodeScanLineGrid
        _scanView.scanImageName = @"SGQRCode.bundle/QRCodeScanLineGrid";
        _scanView.scanAnimationStyle = ScanAnimationStyleGrid;
        _scanView.cornerLocation = CornerLoactionOutside;
        _scanView.cornerColor = [UIColor orangeColor];
    }
    return _scanView;
}
- (void)removeScanningView {
    [self.scanView removeTimer];
    [self.scanView removeFromSuperview];
    self.scanView = nil;
}

- (UILabel *)promptLabel {
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.backgroundColor = [UIColor clearColor];
        CGFloat promptLabelX = 0;
        CGFloat promptLabelY = 0.73 * self.view.frame.size.height;
        CGFloat promptLabelW = self.view.frame.size.width;
        CGFloat promptLabelH = 25;
        _promptLabel.frame = CGRectMake(promptLabelX, promptLabelY, promptLabelW, promptLabelH);
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        _promptLabel.font = [UIFont boldSystemFontOfSize:13.0];
        _promptLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
        _promptLabel.text = NSLocalizedString(@"将二维码/条码放入框内, 即可自动扫描", nil);
    }
    return _promptLabel;
}


@end
