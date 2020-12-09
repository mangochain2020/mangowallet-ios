//
//  DCParticularsShowViewController.m
//  CDDStoreDemo
//
//  Created by apple on 2017/9/7.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import "DCParticularsShowViewController.h"

// Controllers

// Models

// Views

// Vendors
#import <WebKit/WebKit.h>
// Categories

// Others

@interface DCParticularsShowViewController ()

@property (strong, nonatomic) WKWebView *webView;
@property (strong, nonatomic) UITextView *label;

@end

@implementation DCParticularsShowViewController

#pragma mark - LazyLoad

- (WKWebView *)webView
{
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero];
        _webView.frame = self.view.bounds;
        [self.view addSubview:_webView];
    }
    return _webView;
}
- (UITextView *)label
{
    if (!_label) {
        _label = [[UITextView alloc] initWithFrame:CGRectZero];
        _label.frame = self.view.bounds;
        _label.editable = NO;
        _label.font = [UIFont systemFontOfSize:17];
        [self.view addSubview:_label];
    }
    return _label;
}

#pragma mark - LifeCyle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpBase];
    
    [self setUpGoodsParticularsWKWebView];
}

- (void)setUpBase
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.webView.backgroundColor = self.view.backgroundColor;
    self.label.text = [NSString stringWithFormat:@"%@",self.particularUrl];
}

- (void)setUpGoodsParticularsWKWebView
{
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_particularUrl]];
//    [self.webView loadRequest:request];
}

@end
