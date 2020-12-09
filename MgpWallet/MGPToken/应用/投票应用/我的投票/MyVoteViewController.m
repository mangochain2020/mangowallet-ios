//
//  MyVoteViewController.m
//  TaiYiToken
//
//  Created by mac on 2020/10/23.
//  Copyright © 2020 admin. All rights reserved.
//

#import "MyVoteViewController.h"
#import "ControlBtnsView.h"
#import "MyThemeTableViewController.h"


@interface MyVoteViewController ()<UIScrollViewDelegate>
@property(nonatomic,strong)UILabel *titlelabel;
@property(nonatomic,strong)UIButton *backBtn;
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIView *bridgeContentView;
@property(nonatomic)ControlBtnsView *buttonView;

@property(nonatomic,strong)MyThemeTableViewController *leftVC;
@property(nonatomic,strong)MyThemeTableViewController *rightVC;
@property(nonatomic,strong)UIScrollView *mainScrollView;

@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@end

@implementation MyVoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"我的方案", nil);
    [self.rightBtn setTitle:NSLocalizedString(@"记录", nil) forState:UIControlStateNormal];

    [self initUI];
    [self setMainSrollView];

    
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
    [_buttonView initButtonsViewWithTitles:@[NSLocalizedString(@"我的投票", nil),NSLocalizedString(@"我的发布", nil)] Width:ScreenWidth Height:44];

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

-(MyThemeTableViewController *)leftVC{
    if (!_leftVC) {
        UIStoryboard* secondStoryboard = [UIStoryboard storyboardWithName:@"ExchangeHome" bundle:[NSBundle mainBundle]];
        _leftVC = [secondStoryboard instantiateViewControllerWithIdentifier:@"MyThemeTableViewControllerIndex"];
        _leftVC.type = YES;
        [self addChildViewController:_leftVC];
    }
    return _leftVC;
}

-(MyThemeTableViewController *)rightVC{
    if (!_rightVC) {
        UIStoryboard* secondStoryboard = [UIStoryboard storyboardWithName:@"ExchangeHome" bundle:[NSBundle mainBundle]];
        _rightVC = [secondStoryboard instantiateViewControllerWithIdentifier:@"MyThemeTableViewControllerIndex"];
        _leftVC.type = YES;
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
