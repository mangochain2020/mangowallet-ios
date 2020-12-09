//
//  ExportKeyStoreVC.m
//  TaiYiToken
//
//  Created by admin on 2018/9/4.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "ExportKeyStoreVC.h"
#import "SelectButtonView.h"
@interface ExportKeyStoreVC ()
@property(nonatomic)SelectButtonView *selectButtonView;
@property(nonatomic,strong) UIButton *backBtn;
@property(nonatomic)UILabel *titleLabel;
@property(nonatomic)UITextView *detailTextView;
@property(nonatomic)NSMutableAttributedString *attributeStrKeyStore;
@property(nonatomic)NSMutableAttributedString *attributeStrQRCode;
@property(nonatomic)UITextView *keyStoreTextView;
@property(nonatomic)UIImageView *QRCodeImageView;
@property(nonatomic)UIView *bottomBackView;
@property(nonatomic)UIButton *keystoreCopyBtn;
@end

@implementation ExportKeyStoreVC
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
    self.view.backgroundColor = [UIColor ExportBackgroundColor];
//    [self initHeadView];
    [self initUI];
    self.title = NSLocalizedString(@"导出Keystore", nil);
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
    NSString *title = @"";
    title = [NSString stringWithFormat:NSLocalizedString(@"导出Keystore", nil)];
    [_titleLabel setText:title];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(SafeAreaTopHeight - 30);
        make.left.equalTo(45);
        make.width.equalTo(200);
        make.height.equalTo(20);
    }];
    
}

-(void)changeView:(UIButton *)button{
    [self.selectButtonView setBtnSelected:button];
    if(button.tag == 1){
        [self ShowKeyStoreView];
    }else{
        [self ShowQRCodeView];
    }
}

-(void)initUI{
    _selectButtonView = [SelectButtonView new];
    [_selectButtonView initButtonsViewWidth:ScreenWidth Height:44];
    [_selectButtonView.KeystoreBtn setSelected:YES];
    [_selectButtonView.QRCodeBtn setSelected:NO];
    [self changeView:_selectButtonView.KeystoreBtn];
    [_selectButtonView.KeystoreBtn addTarget:self action:@selector(changeView:) forControlEvents:UIControlEventTouchUpInside];
    [_selectButtonView.QRCodeBtn addTarget:self action:@selector(changeView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_selectButtonView];
    [_selectButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(0);
        make.height.equalTo(44);
    }];
    
    
    UIView *backView = [UIView new];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(130);
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.height.equalTo(177);
    }];
    
    
    _detailTextView = [UITextView new];
    _detailTextView.font = [UIFont systemFontOfSize:12];
    _detailTextView.textAlignment = NSTextAlignmentLeft;
    NSString *text = NSLocalizedString(@"离线保存\n切勿保存至邮箱、记事本、网盘、聊天工具等，非常危险\n", nil);
    NSString *text1 = NSLocalizedString(@"请勿通过网络工具传输\n请勿通过网络工具传输，一旦被黑客获取将造成不可挽回的资产损失。建议离线设备通过二维码方式传输。\n", nil);
    NSString *text2 = NSLocalizedString(@"密码管理工具保存\n建议使用密码管理工具管理\n", nil);
    _attributeStrKeyStore = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@%@",text,text1,text2]];
    [_attributeStrKeyStore addAttribute:NSForegroundColorAttributeName value:[UIColor textBlueColor] range:NSMakeRange(0, 4)];
    [_attributeStrKeyStore addAttribute:NSForegroundColorAttributeName value:[UIColor textBlueColor] range:NSMakeRange(text.length, 10)];
    [_attributeStrKeyStore addAttribute:NSForegroundColorAttributeName value:[UIColor textBlueColor] range:NSMakeRange(text.length + text1.length, 8)];
    
    [_attributeStrKeyStore addAttribute:NSForegroundColorAttributeName value:[UIColor textGrayColor] range:NSMakeRange(4, text.length - 4)];
    [_attributeStrKeyStore addAttribute:NSForegroundColorAttributeName value:[UIColor textGrayColor] range:NSMakeRange(text.length + 10, text1.length -10)];
    [_attributeStrKeyStore addAttribute:NSForegroundColorAttributeName value:[UIColor textGrayColor] range:NSMakeRange(text.length+text1.length + 8, text2.length - 8)];
    self.detailTextView.attributedText = _attributeStrKeyStore;
    [backView addSubview:_detailTextView];
    [_detailTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(20);
        make.bottom.right.equalTo(-20);
    }];
   
    _bottomBackView = [UIView new];
    _bottomBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomBackView];
    [_bottomBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(330);
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.height.equalTo(260);
    }];
    
    _keyStoreTextView = [UITextView new];
    _keyStoreTextView.backgroundColor = [UIColor whiteColor];
    _keyStoreTextView.font = [UIFont systemFontOfSize:12];
    _keyStoreTextView.text = self.keystore;
    _keyStoreTextView.textAlignment = NSTextAlignmentLeft;
    _keyStoreTextView.editable = NO;
    [self.view addSubview:_keyStoreTextView];
    [_keyStoreTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(340);
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.height.equalTo(250);
    }];

    _QRCodeImageView = [UIImageView new];
    _QRCodeImageView.alpha = 0;
    [_QRCodeImageView setImage:[CreateAll CreateQRCodeForAddress:self.keystore]];
    [self.view addSubview:_QRCodeImageView];
    [_QRCodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.top.equalTo(350);
        make.width.height.equalTo(220);
    }];
    [self ShowKeyStoreView];
    
    _keystoreCopyBtn = [UIButton buttonWithType: UIButtonTypeSystem];
    _keystoreCopyBtn.titleLabel.textColor = [UIColor textBlackColor];
    _keystoreCopyBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _keystoreCopyBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [_keystoreCopyBtn gradientButtonWithSize:CGSizeMake(ScreenWidth, 44) colorArray:@[[UIColor colorWithHexString:@"#4090F7"],[UIColor colorWithHexString:@"#57A8FF"]] percentageArray:@[@(0.3),@(1)] gradientType:GradientFromLeftTopToRightBottom];
    _keystoreCopyBtn.tintColor = [UIColor textWhiteColor];
    _keystoreCopyBtn.userInteractionEnabled = YES;
    [_keystoreCopyBtn setTitle:NSLocalizedString(@"复制Keystore", nil) forState:UIControlStateNormal];
    [_keystoreCopyBtn addTarget:self action:@selector(copyKeyStore) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_keystoreCopyBtn];
    [_keystoreCopyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.bottom.equalTo(-SafeAreaBottomHeight);
        make.height.equalTo(44);
    }];
}
-(void)copyKeyStore{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.keystore;
    [self.view showMsg:NSLocalizedString(@"Keystore已复制", nil)];
}


-(void)ShowKeyStoreView{
    MJWeakSelf
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.keyStoreTextView.alpha = 1;
        weakSelf.QRCodeImageView.alpha = 0;
        weakSelf.keystoreCopyBtn.alpha = 1;
    }];
}
-(void)ShowQRCodeView{
    MJWeakSelf
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.keyStoreTextView.alpha = 0;
        weakSelf.QRCodeImageView.alpha = 1;
        weakSelf.keystoreCopyBtn.alpha = 0;
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
