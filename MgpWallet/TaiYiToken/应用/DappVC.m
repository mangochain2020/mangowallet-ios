//
//  DappVC.m
//  TaiYiToken
//
//  Created by admin on 2018/9/25.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "DappVC.h"
#import "Customlayout.h"
#import "WebVC.h"
#import "DappViewCell.h"
@interface DappVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic)UICollectionView *collectionview;
@property(nonatomic,strong)NSArray *titleArray1;
@property(nonatomic,strong)NSArray *imageNameArray1;
@property(nonatomic,strong)WKWebView *webView;
@end

@implementation DappVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.hidesBottomBarWhenPushed = NO;
    self.titleArray1 = @[NSLocalizedString(@"misBrowser", nil)];
    [self.collectionview reloadData];
    SystemInitModel *sysinfo = [CreateAll GetSystemData];
    if (sysinfo) {
        NSString *url = VALIDATE_STRING(sysinfo.aboutUs.website);
        [self.webView loadRequest:[NSURLRequest requestWithURL:url.STR_URLString]];
    }
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleArray1 = @[NSLocalizedString(@"misBrowser", nil)];
    self.imageNameArray1 = @[@"ico_logo_ad"];
    [self.collectionview registerClass:[DappViewCell class] forCellWithReuseIdentifier:@"DappViewCell"];
   
}

#pragma collectionview *****************************

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 25, 5, 25);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(1, 1);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(1, 1);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(75 , 90);//CGSizeMake(width, 300);
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.titleArray1.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DappViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DappViewCell" forIndexPath:indexPath];
    [cell.iconImageView setImage:[UIImage imageNamed:self.imageNameArray1[indexPath.row]]];
    [cell.namelb setText:self.titleArray1[indexPath.row]];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SystemInitModel *model = [CreateAll GetSystemData];
    if (model && model.misChainBrowser.length > 0) {
        WebVC *vc = [WebVC new];
        vc.urlstring = model.misChainBrowser;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(UICollectionView *)collectionview{
    if (!_collectionview) {
        Customlayout *layout = [Customlayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionview = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionview.dataSource = self;
        _collectionview.delegate = self;
        _collectionview.contentInset = UIEdgeInsetsMake(5, 5, -5, -5);
        _collectionview.backgroundColor = kRGBA(255, 255, 255, 1);
        _collectionview.showsVerticalScrollIndicator = NO;
        _collectionview.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_collectionview];
        [_collectionview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.top.equalTo(0);
            make.height.equalTo(130);
        }];
    }
    return _collectionview;
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
            make.top.equalTo(130);
            make.left.right.equalTo(0);
            make.bottom.equalTo(0);
        }];
    }
    return _webView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
