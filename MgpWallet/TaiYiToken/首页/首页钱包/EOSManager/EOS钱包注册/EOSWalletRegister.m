//
//  EOSWalletRegister.m
//  TaiYiToken
//
//  Created by 张元一 on 2018/12/11.
//  Copyright © 2018 admin. All rights reserved.
//

#import "EOSWalletRegister.h"
#import "ControlBtnsView.h"
#import "RegisterEOSAccountVC.h"
#import "SelectEOSAccountVC.h"
@interface EOSWalletRegister ()<UIScrollViewDelegate>
@property(nonatomic,strong)UILabel *titlelabel;
@property(nonatomic,strong)UIButton *backBtn;
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIView *bridgeContentView;
@property(nonatomic)ControlBtnsView *buttonView;

@property(nonatomic,strong)SelectEOSAccountVC *leftVC;
@property(nonatomic,strong)RegisterEOSAccountVC *rightVC;
@property(nonatomic,strong)UIScrollView *mainScrollView;
@end

@implementation EOSWalletRegister

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
    self.title = self.wallet.coinType == EOS ? NSLocalizedString(@"EOS账户", nil) : NSLocalizedString(@"MGP账户", nil);

    [self initUI];
    [self setMainSrollView];
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
    _titlelabel.text = self.wallet.coinType == EOS ? NSLocalizedString(@"EOS账户", nil) : NSLocalizedString(@"MGP账户", nil);
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


-(void)selectImportWay:(UIButton *)btn{
    [_buttonView setBtnSelected:btn];
    [UIView animateWithDuration:0.3 animations:^{
        self.mainScrollView.contentOffset = CGPointMake(ScreenWidth*btn.tag, 0);
    } completion:^(BOOL finished) {
        
    }];
}


-(void)initUI{
    _buttonView = [ControlBtnsView new];
    if (self.wallet.coinType == EOS) {
        [_buttonView initButtonsViewWithTitles:@[NSLocalizedString(@"选择EOS账户", nil),NSLocalizedString(@"注册EOS账户", nil)] Width:ScreenWidth Height:44];

    }else{
        [_buttonView initButtonsViewWithTitles:@[NSLocalizedString(@"选择MGP账户", nil),NSLocalizedString(@"注册MGP账户", nil)] Width:ScreenWidth Height:44];

    }
    _buttonView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    for (UIButton *btn in _buttonView.btnArray) {
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [btn addTarget:self action:@selector(selectImportWay:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.view addSubview:_buttonView];
    [_buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.right.equalTo(0);
        make.height.equalTo(44);
    }];
    
}

-(SelectEOSAccountVC *)leftVC{
    if (!_leftVC) {
        _leftVC = [SelectEOSAccountVC new];
        _leftVC.wallet = self.wallet;
        [self addChildViewController:_leftVC];
    }
    return _leftVC;
}

-(RegisterEOSAccountVC *)rightVC{
    if (!_rightVC) {
        _rightVC = [RegisterEOSAccountVC new];
        _rightVC.wallet = self.wallet;
        [self addChildViewController:_rightVC];
    }
    return _rightVC;
}
#pragma mark 初始化srollView
-(void)setMainSrollView{
    _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 44, ScreenWidth, self.view.frame.size.height)];
    _mainScrollView.delegate = self;
    _mainScrollView.backgroundColor = [UIColor whiteColor];
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.scrollEnabled = NO;
    [self.view addSubview:_mainScrollView];
    
    NSArray *views = @[self.leftVC.view,self.rightVC.view];
    for (NSInteger i = 0; i<views.count; i++) {
        //把vc的view依次贴到_mainScrollView上面
        UIView *pageView = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth*i, 0, _mainScrollView.frame.size.width, _mainScrollView.frame.size.height-100)];
        [pageView addSubview:views[i]];
        [_mainScrollView addSubview:pageView];
    }
    _mainScrollView.contentSize = CGSizeMake(ScreenWidth*(views.count), 0);
    //滚动到_currentIndex对应的tab
    [_mainScrollView setContentOffset:CGPointMake((_mainScrollView.frame.size.width)*0, 0) animated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end
