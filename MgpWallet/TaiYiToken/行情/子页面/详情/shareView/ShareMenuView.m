//
//  ShareMenuView.m
//  TaiYiToken
//
//  Created by Frued on 2018/8/31.
//  Copyright © 2018年 Frued. All rights reserved.
//

#import "ShareMenuView.h"
#import "ShareItemCollectionViewCell.h"
#import "Customlayout.h"
#define share_wechat @"share_wechat"
#define share_circle @"share_circle"
#define share_qq @"share_qq"
#define share_message @"share_message"
#define share_weibo @"share_weibo"
#define share_qzone @"share_qzone"
#define CollectionViewHeight 220

@interface ShareMenuView ()

@property (strong, nonatomic) UICollectionView *menuCollectionView;
    
@property (nonatomic, strong)NSMutableArray * imageNameList; //分享菜单图片名字
@property (nonatomic, strong)NSMutableArray * titleNameList; //分享菜单title

@end

@implementation ShareMenuView
-(void)loadShareMenuView{
    self.backgroundColor = kRGBA(240, 240, 240, 1);
    Customlayout *layout = [Customlayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _menuCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    _menuCollectionView.dataSource = self;
    _menuCollectionView.delegate = self;
    _menuCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _menuCollectionView.backgroundColor = kRGBA(240, 240, 240, 1);
    _menuCollectionView.showsVerticalScrollIndicator = NO;
    _menuCollectionView.showsHorizontalScrollIndicator = NO;
    
    [self addSubview:_menuCollectionView];
    [_menuCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.top.equalTo(0);
        make.bottom.equalTo(-51);
    }];
    
    [_menuCollectionView registerClass:[ShareItemCollectionViewCell class] forCellWithReuseIdentifier:@"ShareItemCollectionViewCell"];
   
    //图片名字
    _imageNameList =[[NSMutableArray alloc] initWithArray:@[share_wechat,
                                                            share_circle,
                                                            share_weibo,]];
    //平台名字
    _titleNameList = [[NSMutableArray alloc] initWithArray: @[@"微信好友",
                                                              @"微信朋友圈",
                                                              @"微博"]];
    _dataSource = [[NSMutableArray alloc] init];
    
    _hideBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _hideBtn.backgroundColor = [UIColor whiteColor];
    [_hideBtn setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
    [self addSubview:_hideBtn];
    _hideBtn.userInteractionEnabled = YES;
    [_hideBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
        make.height.equalTo(51);
    }];
}


- (void)setDataSource:(NSMutableArray *)dataSource
{
    _dataSource = dataSource;
    for (NSString * imageName in _dataSource) {
        if ([_imageNameList containsObject:imageName]) {
            NSInteger index = [_imageNameList indexOfObject:imageName];
            [_imageNameList removeObject:imageName];
            [_titleNameList removeObjectAtIndex:index];

        }
    }
    [_menuCollectionView reloadData];
}

#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource


-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
        return 10;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 20;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    NSInteger numberOfItems = _imageNameList.count;
    CGFloat combinedItemWidth = (numberOfItems * 60) + ((numberOfItems - 1) * 20);
    CGFloat padding = (ScreenWidth - combinedItemWidth)/2;
    padding = padding>0 ? padding : 0 ;
    return UIEdgeInsetsMake(0, padding,0, padding);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(1, 1);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(1, 1);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
        return CGSizeMake(60, 80);
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _imageNameList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ShareItemCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ShareItemCollectionViewCell" forIndexPath:indexPath];
    [cell setCellRelationDataTitle:_titleNameList[indexPath.row] imageTitle:_imageNameList[indexPath.row]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString * imageName = _imageNameList[indexPath.row];
    if ([imageName isEqualToString:share_wechat]) {
        //微信
        NSLog(@"微信");
    } else if ([imageName isEqualToString:share_circle]) {
        //微信朋友圈
        NSLog(@"微信朋友圈");
    } else if ([imageName isEqualToString:share_qq]) {
        //QQ
        NSLog(@"QQ");
    } else if ([imageName isEqualToString:share_message]) {
        //信息
        NSLog(@"信息");
    } else if ([imageName isEqualToString:share_weibo]) {
        //微博
        NSLog(@"微博");
    }else if ([imageName isEqualToString:share_qzone]) {
        //QQ空间
        NSLog(@"QQ空间");
    }
}



@end
