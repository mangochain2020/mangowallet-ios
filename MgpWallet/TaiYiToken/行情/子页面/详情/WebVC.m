//
//  WebVC.m
//  TaiYiToken
//
//  Created by Frued on 2018/8/31.
//  Copyright © 2018年 Frued. All rights reserved.
//

#import "WebVC.h"

@interface WebVC ()
@property(nonatomic,strong) UIButton *backBtn;
@property(nonatomic,strong)WKWebView *webView;
@property(nonatomic,strong)UIView *headBackgroundView;
@end

@implementation WebVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
//    self.navigationController.navigationBar.hidden = YES;
//    self.navigationController.hidesBottomBarWhenPushed = YES;
//    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
//    self.navigationController.navigationBar.hidden = YES;
//    self.navigationController.hidesBottomBarWhenPushed = YES;
//    self.tabBarController.tabBar.hidden = NO;
}
- (void)popAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view showHUD];

    
    //头部背景
    _headBackgroundView = [UIView new];
//    _headBackgroundView.backgroundColor = _headcolor? _headcolor: [UIColor colorWithHexString:@"#5091FF"];
    _headBackgroundView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_headBackgroundView];
    [_headBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(0);
        make.height.equalTo(SafeAreaTopHeight);
    }];
    
    
    if (!([self.urlstring isEqualToString:@""] || self.urlstring == nil)) {
         [self.webView loadRequest:[NSURLRequest requestWithURL:self.urlstring.STR_URLString]];
    }
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    /*
    _backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _backBtn.backgroundColor = [UIColor clearColor];
    [_backBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [_backBtn setImage:[[UIImage imageNamed:@"ico_right_arrow"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
   // _backBtn.tintColor = _backBtnTintColor?_backBtnTintColor : RGB(255, 255, 255);
    _backBtn.tintColor = [UIColor blackColor];
    [_backBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backBtn];
    _backBtn.userInteractionEnabled = YES;
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(SafeAreaTopHeight - 34);
        make.height.equalTo(25);
        make.left.equalTo(10);
        make.width.equalTo(30);
    }];*/
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// 根据监听 实时修改title
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"title"]) {
        if (object == self.webView)
        {
            self.title = self.webView.title;
            [self.view hideHUD];

        }
        else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
        
    }
    
}

//移除监听  9831 87
- (void)dealloc{
    [self.webView removeObserver:self forKeyPath:@"title" context:nil];
}
- (WKWebView *)webView {
    if(_webView == nil) {
        _webView = [[WKWebView alloc] init];
        //_webView.delegate = self;
        _webView.scrollView.bounces = NO;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        _webView.scrollView.scrollEnabled = YES;
        [_webView sizeToFit];
        _webView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_webView];
        [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(0);
        }];
    }
    return _webView;
}

@end
