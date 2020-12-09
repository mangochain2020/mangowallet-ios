//
//  EOSAuthorityVC.m
//  TaiYiToken
//
//  Created by 张元一 on 2018/12/17.
//  Copyright © 2018 admin. All rights reserved.
//

#import "EOSAuthorityVC.h"
#import "AuthorView.h"
@interface EOSAuthorityVC ()<UIScrollViewDelegate>
@property(nonatomic,strong)UILabel *titlelabel;
@property(nonatomic,strong)UIButton *backBtn;
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIView *bridgeContentView;
@property(nonatomic,strong)AuthorView *ownerView;
@property(nonatomic,strong)AuthorView *activeView;
@end

@implementation EOSAuthorityVC
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
    self.title = NSLocalizedString(@"权限查看", nil);

    [self scrollView];
    
    if (!_ownerView) {
        _ownerView = [AuthorView new];
        _ownerView.keystr = self.wallet.publicKey;
        _ownerView.weight = 1;
        _ownerView.authority = @"Owner";
        [_ownerView initUI];
        [self.bridgeContentView addSubview:_ownerView];
        [_ownerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.top.equalTo(0);
            make.height.equalTo(180);
        }];
    }
    if (!_activeView) {
        _activeView = [AuthorView new];
        _activeView.keystr = self.wallet.publicKey;
        _activeView.weight = 1;
        _activeView.authority = @"Active";
        [_activeView initUI];
        [self.bridgeContentView addSubview:_activeView];
        [_activeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.top.equalTo(self.ownerView.mas_bottom).equalTo(15);
            make.height.equalTo(180);
        }];
    }
    
    UILabel *lb = [UILabel new];
    NSTextAttachment * attach = [[NSTextAttachment alloc] init];
    attach.image = [UIImage imageNamed:@"yhjk"];
    attach.bounds = CGRectMake(0, 0, 10, 10);
    NSAttributedString * imageStr = [NSAttributedString attributedStringWithAttachment:attach];
    
    NSMutableAttributedString * t0 = [[NSMutableAttributedString alloc] initWithString:@"owner" attributes:@{NSForegroundColorAttributeName:[UIColor textBlackColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:13]}];
    NSMutableAttributedString * t1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@\n\n", NSLocalizedString(@"owner角色拥有账户所有权，用于权限设置，以及管理其 他角色。", nil)] attributes:@{NSForegroundColorAttributeName:[UIColor textGrayColor], NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    NSMutableAttributedString * t2 = [[NSMutableAttributedString alloc] initWithString:@"active" attributes:@{NSForegroundColorAttributeName:[UIColor textBlackColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:13]}];
    NSMutableAttributedString * t3 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@\n", NSLocalizedString(@"active角色用于日常转账、股票等操作。", nil)] attributes:@{NSForegroundColorAttributeName:[UIColor textGrayColor], NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    NSMutableAttributedString * t4 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@\n", NSLocalizedString(@"权重阈值", nil)] attributes:@{NSForegroundColorAttributeName:[UIColor textBlackColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:13]}];
    NSMutableAttributedString * t5 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n", NSLocalizedString(@"权重阈值，代表该角色操作所需的最低权重。", nil)] attributes:@{NSForegroundColorAttributeName:[UIColor textGrayColor], NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    NSMutableAttributedString * t6 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@ ", NSLocalizedString(@"图标", nil)] attributes:@{NSForegroundColorAttributeName:[UIColor textBlackColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:13]}];
    [t6 appendAttributedString:imageStr];
    NSMutableAttributedString * t7 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@\n", NSLocalizedString(@"该符号代表公钥对应的私钥存在于当前钱包。", nil)] attributes:@{NSForegroundColorAttributeName:[UIColor textGrayColor], NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    [t0 appendAttributedString:t1];
    [t0 appendAttributedString:t2];
    [t0 appendAttributedString:t3];
    [t0 appendAttributedString:t4];
    [t0 appendAttributedString:t5];
    [t0 appendAttributedString:t6];
    [t0 appendAttributedString:t7];
    lb.textColor = [UIColor textBlackColor];
    lb.textAlignment = NSTextAlignmentLeft;
    lb.numberOfLines = 0;
    lb.attributedText = t0;
    [self.bridgeContentView addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.top.equalTo(self.activeView.mas_bottom).equalTo(20);
        make.right.equalTo(-16);
        make.height.equalTo(260);
    }];
    

}

-(void)initHeadView{
    UIView *headBackView = [UIView new];
    headBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headBackView];
    [headBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(0);
        make.height.equalTo(150);
    }];
    _titlelabel = [[UILabel alloc] init];
    _titlelabel.textColor = [UIColor textBlackColor];
    _titlelabel.font = [UIFont boldSystemFontOfSize:18];
    _titlelabel.text = NSLocalizedString(@"权限查看", nil);
    _titlelabel.textAlignment = NSTextAlignmentLeft;
    _titlelabel.numberOfLines = 1;
    [headBackView addSubview:_titlelabel];
    [_titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
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

-(UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.scrollEnabled = YES;
        _scrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight + 100);
        _scrollView.delegate =self;
        _scrollView.scrollsToTop = YES;
        [self.view addSubview:_scrollView];
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.top.equalTo(SafeAreaTopHeight);
            make.bottom.equalTo(-SafeAreaBottomHeight);
        }];
        _bridgeContentView = [UIView new];
        _bridgeContentView.backgroundColor = [UIColor whiteColor];
        [self.scrollView addSubview:_bridgeContentView];
        [_bridgeContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.scrollView);
            make.width.height.equalTo(self.scrollView.contentSize);
        }];
    }
    
    return _scrollView;
}
@end
