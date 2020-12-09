//
//  ScanSuccessJumpVC.m
//  SGQRCodeExample
//
//  Created by kingsic on 16/8/29.
//  Copyright © 2016年 kingsic. All rights reserved.
//

#import "ScanSuccessJumpVC.h"
#import "SGWebView.h"

@interface ScanSuccessJumpVC () <SGWebViewDelegate>
@property (nonatomic , strong) SGWebView *webView;
@end

@implementation ScanSuccessJumpVC

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.hidesBottomBarWhenPushed = NO;
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.hidesBottomBarWhenPushed = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNavigationItem];
   
    if (self.jump_bar_code) {
        [self setupLabel];
    } else {
        [self setupWebView];
    }
}

- (void)setupNavigationItem {
    UIButton *left_Button = [[UIButton alloc] init];
    [left_Button setTitle:@"back" forState:UIControlStateNormal];
    [left_Button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [left_Button sizeToFit];
    [left_Button addTarget:self action:@selector(left_BarButtonItemAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left_BarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left_Button];
    self.navigationItem.leftBarButtonItem = left_BarButtonItem;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemRefresh) target:self action:@selector(right_BarButtonItemAction)];
}

- (void)left_BarButtonItemAction {
    if (self.comeFromVC == ScanSuccessJumpComeFromWB) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (self.comeFromVC == ScanSuccessJumpComeFromWC) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)right_BarButtonItemAction {
    [self.webView reloadData];
}

// 添加Label，加载扫描过来的内容
- (void)setupLabel {
    // 提示文字
    UILabel *prompt_message = [[UILabel alloc] init];
    prompt_message.frame = CGRectMake(0, 200, self.view.frame.size.width, 30);
    prompt_message.text = NSLocalizedString(@"您扫描的条形码结果如下： ", nil);
    prompt_message.textColor = [UIColor redColor];
    prompt_message.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:prompt_message];
    
    // 扫描结果
    CGFloat label_Y = CGRectGetMaxY(prompt_message.frame);
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, label_Y, self.view.frame.size.width, 30);
    label.text = self.jump_bar_code;
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
}

// 添加webView，加载扫描过来的内容
- (void)setupWebView {
    CGFloat webViewX = 0;
    CGFloat webViewY = 0;
    CGFloat webViewW = [UIScreen mainScreen].bounds.size.width;
    CGFloat webViewH = [UIScreen mainScreen].bounds.size.height;
    self.webView = [SGWebView webViewWithFrame:CGRectMake(webViewX, webViewY, webViewW, webViewH)];
    if (self.comeFromVC == ScanSuccessJumpComeFromWB) {
        _webView.progressViewColor = [UIColor orangeColor];
    };
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.jump_URL]]];
    _webView.SGQRCodeDelegate = self;
    [self.view addSubview:_webView];
}

- (void)webView:(SGWebView *)webView didFinishLoadWithURL:(NSURL *)url {
    NSLog(@"didFinishLoad");
    self.title = webView.navigationItemTitle;
}


@end

