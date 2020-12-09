//
//  CreateMnemonicVC.m
//  TaiYiToken
//
//  Created by Frued on 2018/8/20.
//  Copyright © 2018年 Frued. All rights reserved.
//

#import "CreateMnemonicVC.h"
#import "NYMnemonic.h"

#import "VerifyMnemonicVC.h"
@interface CreateMnemonicVC ()
@property(nonatomic,strong)UILabel *headlabel;
@property(nonatomic,strong) UIButton *backBtn;

@property(nonatomic,strong) UIButton *nextBtn;
@property(nonatomic,copy)NSString *mnemonic;

@end

@implementation CreateMnemonicVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
//    self.tabBarController.tabBar.hidden = YES;
//    self.navigationController.navigationBar.hidden = YES;
//    self.navigationController.hidesBottomBarWhenPushed = YES;
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
    self.title = NSLocalizedString(@"备份助记词", nil);
    /*
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.backgroundColor = [UIColor clearColor];
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
    
 
    _headlabel = [[UILabel alloc] init];
    _headlabel.textColor = [UIColor blackColor];
    _headlabel.font = [UIFont systemFontOfSize:16];
    _headlabel.text = NSLocalizedString(@"备份助记词", nil);
    _headlabel.textAlignment = NSTextAlignmentLeft;
    _headlabel.numberOfLines = 1;
    [self.view addSubview:_headlabel];
    [_headlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(50);
        make.top.equalTo(SafeAreaTopHeight - 34);
        make.right.equalTo(-16);
        make.height.equalTo(25);
    }];
    */
    UILabel *remindlabel = [[UILabel alloc] init];
    remindlabel.textColor = [UIColor textGrayColor];
    remindlabel.font = [UIFont systemFontOfSize:13];
    remindlabel.text = NSLocalizedString(@"请仔细抄写下方助记词，我们将在下一步验证", nil);
    remindlabel.textAlignment = NSTextAlignmentLeft;
    remindlabel.numberOfLines = 0;
    [self.view addSubview:remindlabel];
    [remindlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(10);
        make.right.equalTo(-10);
        make.height.equalTo(40);
    }];
    
    _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextBtn.backgroundColor = [UIColor textBlueColor];
    [_nextBtn gradientButtonWithSize:CGSizeMake(ScreenWidth, 49) colorArray:@[RGB(150, 160, 240),RGB(170, 170, 240)] percentageArray:@[@(0.3),@(1)] gradientType:GradientFromLeftTopToRightBottom];
    [_nextBtn setTitle:NSLocalizedString(@"下一步", nil) forState:UIControlStateNormal];
    [_nextBtn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextBtn];
    _nextBtn.userInteractionEnabled = YES;
    [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(-SafeAreaBottomHeight);
        make.height.equalTo(49);
        make.left.equalTo(0);
        make.right.equalTo(0);
    }];
    
    [self CreateMnemonic];
    
}
-(void)CreateMnemonic{
    self.mnemonic = [NYMnemonic generateMnemonicString:@128 language:@"english"];
    UIView *shadowView = [UIView new];
    shadowView.layer.shadowColor = [UIColor grayColor].CGColor;
    shadowView.layer.shadowOffset = CGSizeMake(0, 0);
    shadowView.layer.shadowOpacity = 1;
    shadowView.layer.shadowRadius = 3.0;
    shadowView.layer.cornerRadius = 3.0;
    shadowView.clipsToBounds = NO;
    [self.view addSubview:shadowView];
    [shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(20);
        make.top.equalTo(56);
        make.right.equalTo(-20);
        make.height.equalTo(100);
    }];
    
    
    UITextView *mnemonicTextView = [UITextView new];
    mnemonicTextView.textColor = [UIColor textBlackColor];
    mnemonicTextView.font = [UIFont systemFontOfSize:17];
    mnemonicTextView.text = self.mnemonic;
    mnemonicTextView.textAlignment = NSTextAlignmentNatural;
    mnemonicTextView.userInteractionEnabled = NO;
    [shadowView addSubview:mnemonicTextView];
    [mnemonicTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
    NSLog(@"%@---",self.mnemonic);
}
-(void)nextAction{
    VerifyMnemonicVC *vmvc = [VerifyMnemonicVC new];
    vmvc.mnemonic = self.mnemonic;
    vmvc.password = self.password;
    vmvc.coinType = self.coinType;
    [self.navigationController pushViewController:vmvc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
