//
//  InfoWebVC.m
//  TaiYiToken
//
//  Created by 张元一 on 2019/4/2.
//  Copyright © 2019 admin. All rights reserved.
//

#import "InfoWebVC.h"
#import "InfoModels.h"
@interface InfoWebVC ()
@property(nonatomic,strong) UIButton *backBtn;
@property(nonatomic,strong)WKWebView *webView;
@property(nonatomic,strong)UIView *headBackgroundView;
@property(nonatomic,strong)UIButton *collectBtn;
@end

@implementation InfoWebVC
//ico_focus_default 
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.hidesBottomBarWhenPushed = YES;
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.hidesBottomBarWhenPushed = YES;
    self.tabBarController.tabBar.hidden = NO;
}
- (void)popAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
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
    }];
    
    _collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _collectBtn.tintColor = [UIColor appBlueColor];
    UIImage *image = [UIImage imageNamed:@"ico_focus_default"];
    image = [image imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
    UIImage *imagesel = [UIImage imageNamed:@"ico_focus_select"];
    imagesel = [imagesel imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
    [_collectBtn setImage:image forState:UIControlStateNormal];
    [_collectBtn setImage:imagesel forState:UIControlStateSelected];
    if (_iscollected == YES) {
        [self.collectBtn setSelected:YES];
    }else{
        [self.collectBtn setSelected:NO];
    }
    [_collectBtn addTarget:self action:@selector(collectInfo:) forControlEvents:UIControlEventTouchUpInside];
    [self.headBackgroundView addSubview:_collectBtn];
    [_collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(SafeAreaTopHeight - 34);
        make.right.equalTo(-10);
        make.width.height.equalTo(30);
    }];
}

-(void)collectInfo:(UIButton *)btn{
    [btn setSelected:!btn.isSelected];
    NSString *username = [CreateAll GetCurrentUser].userId;
    MJWeakSelf
    if(btn.selected == YES){
        [NetManager GetInfoAddCollectionUserID:VALIDATE_STRING(username) NewsID:self.newsid CompletionHandler:^(id responseObj, NSError *error) {
            if (!error) {
                InfoBaseModel *model = [InfoBaseModel parse:responseObj];
                if (model.resultCode != 20000) {
                    [weakSelf.view showMsg:model.resultMsg];
                }else{
                    [weakSelf.view showMsg:NSLocalizedString(@"收藏成功", nil)];
                }
            }else{
                [weakSelf.view showMsg:error.userInfo.description];
            }
        }];
    }else{
        [NetManager GetInfoDeleteCollectionUserID:VALIDATE_STRING(username) NewsID:self.newsid CompletionHandler:^(id responseObj, NSError *error) {
            if (!error) {
                InfoBaseModel *model = [InfoBaseModel parse:responseObj];
                if (model.resultCode != 20000) {
                    [weakSelf.view showMsg:model.resultMsg];
                }else{
                    [weakSelf.view showMsg:NSLocalizedString(@"取消收藏成功", nil)];
                }
            }else{
                [weakSelf.view showMsg:error.userInfo.description];
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            make.top.equalTo(SafeAreaTopHeight);
            make.left.right.equalTo(0);
            make.bottom.equalTo(0);
        }];
    }
    return _webView;
}

@end
