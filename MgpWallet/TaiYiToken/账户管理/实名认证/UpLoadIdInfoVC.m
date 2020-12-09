//
//  UpLoadIdInfoVC.m
//  TaiYiToken
//
//  Created by Frued on 2018/10/19.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "UpLoadIdInfoVC.h"
#import "TakePictureView.h"

#import <Photos/Photos.h>
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
@interface UpLoadIdInfoVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate,UIScrollViewAccessibilityDelegate>
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIView *bridgeContentView;

@property(nonatomic,strong)UILabel *titlelabel;
@property(nonatomic,strong)UIButton *backBtn;

@property(nonatomic,strong)TakePictureView *view0;
@property(nonatomic,strong)TakePictureView *view1;
@property(nonatomic,strong)TakePictureView *view2;

@property(nonatomic,strong)UIImageView *headbackiv0;
@property(nonatomic,strong)UIImageView *headbackiv1;
@property(nonatomic,strong)UIImageView *headbackiv2;
@property(nonatomic,assign)NSInteger currentIndex;
@property(nonatomic,strong)NSMutableArray *pictureArray;
@property (nonatomic,strong) UIAlertController *actionController;
@property (nonatomic,strong) UIImagePickerController *imagePickerController;


@property(nonatomic,strong)UIButton *commitBtn;
@end

@implementation UpLoadIdInfoVC


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    self.navigationController.hidesBottomBarWhenPushed = YES;
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.hidesBottomBarWhenPushed = NO;
}
- (void)popAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.currentIndex = -1;
    [self scrollView];
    _bridgeContentView = [UIView new];
    _bridgeContentView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:_bridgeContentView];
    [_bridgeContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.height.equalTo(self.scrollView.contentSize);
    }];
    [self initHeadView];
}

-(void)initHeadView{
    UIView *headBackView = [UIView new];
    headBackView.backgroundColor = RGB(80, 145, 255);
    [self.view addSubview:headBackView];
    [headBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(0);
        make.height.equalTo(SafeAreaTopHeight);
    }];
    _titlelabel = [[UILabel alloc] init];
    _titlelabel.textColor = [UIColor textWhiteColor];
    _titlelabel.font = [UIFont boldSystemFontOfSize:18];
    _titlelabel.text = NSLocalizedString(@"上传认证信息", nil);
    _titlelabel.textAlignment = NSTextAlignmentLeft;
    _titlelabel.numberOfLines = 1;
    [headBackView addSubview:_titlelabel];
    [_titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(50);
        make.top.equalTo(SafeAreaTopHeight - 32);
        make.width.equalTo(200);
        make.height.equalTo(20);
    }];
    
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.backgroundColor = [UIColor clearColor];
    _backBtn.tintColor = [UIColor whiteColor];
    [_backBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [_backBtn setImage:[UIImage imageNamed:@"ico_right_arrow1"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backBtn];
    _backBtn.userInteractionEnabled = YES;
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(SafeAreaTopHeight - 34);
        make.height.equalTo(25);
        make.left.equalTo(10);
        make.width.equalTo(30);
    }];
    
   
    
    CGFloat viewHeight = 50;
    _view0 = [TakePictureView new];
    _view0.titlelabel.text = NSLocalizedString(@"身份证人脸面", nil);
    _view0.detaillabel.text = NSLocalizedString(@"未上传", nil);
    _view0.photoBtn.tag = 0;
    [_view0.photoBtn addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
    [self.bridgeContentView addSubview:_view0];
    [_view0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.right.equalTo(0);
        make.height.equalTo(viewHeight);
    }];
    
    _headbackiv0 = [UIImageView new];
    _headbackiv0.contentMode = UIViewContentModeScaleAspectFit;
    _headbackiv0.image = [UIImage imageNamed:@"rtsb"];
    [self.bridgeContentView addSubview:_headbackiv0];
    [_headbackiv0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewHeight);
        make.left.equalTo(16);
        make.right.equalTo(-16);
        make.height.equalTo(185);
    }];
    
    
    
    _view1 = [TakePictureView new];
    _view1.titlelabel.text = NSLocalizedString(@"身份证国徽面", nil);
    _view1.detaillabel.text = NSLocalizedString(@"未上传", nil);
    _view1.photoBtn.tag = 1;
    [_view1.photoBtn addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
    [self.bridgeContentView addSubview:_view1];
    [_view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(185 + viewHeight);
        make.left.right.equalTo(0);
        make.height.equalTo(viewHeight);
    }];
    
    _headbackiv1 = [UIImageView new];
    _headbackiv1.image = [UIImage imageNamed:@"ghsb"];
    _headbackiv1.contentMode = UIViewContentModeScaleAspectFit;
    [self.bridgeContentView addSubview:_headbackiv1];
    [_headbackiv1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(185 + 2*viewHeight);
        make.left.equalTo(16);
        make.right.equalTo(-16);
        make.height.equalTo(185);
    }];
    
    _view2 = [TakePictureView new];
    _view2.titlelabel.text = NSLocalizedString(@"手持身份证人脸面", nil);
    _view2.detaillabel.text = NSLocalizedString(@"未上传", nil);
    _view2.photoBtn.tag = 2;
    [_view2.photoBtn addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
    [self.bridgeContentView addSubview:_view2];
    [_view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(2*viewHeight + 2*185 );
        make.left.right.equalTo(0);
        make.height.equalTo(viewHeight);
    }];
    
    _headbackiv2 = [UIImageView new];
    _headbackiv2.image = [UIImage imageNamed:@"scsb"];
    _headbackiv2.contentMode = UIViewContentModeScaleAspectFit;
    [self.bridgeContentView addSubview:_headbackiv2];
    [_headbackiv2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(3*viewHeight + 2*185);
        make.left.equalTo(16);
        make.right.equalTo(-16);
        make.height.equalTo(185);
    }];
    
    _commitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _commitBtn.backgroundColor = RGB(100, 100, 255);
    _commitBtn.tintColor = [UIColor whiteColor];
    _commitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    _commitBtn.layer.cornerRadius = 5;
//    _commitBtn.clipsToBounds = YES;
    [_commitBtn gradientButtonWithSize:CGSizeMake(ScreenWidth, 44) colorArray:@[[UIColor colorWithHexString:@"#4090F7"],[UIColor colorWithHexString:@"#BBA8FF"],[UIColor colorWithHexString:@"#4090F7"]] percentageArray:@[@(0.3),@(0.7),@(0.3)] gradientType:GradientFromLeftToRight];
    [_commitBtn setTitle:NSLocalizedString(@"提交", nil) forState:UIControlStateNormal];
    [_commitBtn addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_commitBtn];
    _commitBtn.userInteractionEnabled = YES;
    [_commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-SafeAreaBottomHeight);
        make.height.equalTo(44);
        make.left.equalTo(0);
        make.right.equalTo(0);
    }];
    
//    UILabel *infolb = [[UILabel alloc] init];
//    infolb.textColor = RGB(250, 133, 20);
//    infolb.font = [UIFont systemFontOfSize:12];
//    infolb.text = NSLocalizedString(@"手持证件需满足上述图例中条件\n拍照前请在设置-隐私中修改拍照可访问", nil);
//    infolb.textAlignment = NSTextAlignmentLeft;
//    infolb.numberOfLines = 0;
//    [self.view addSubview:infolb];
//    [infolb mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(64 + 3*viewHeight + 10 + 195);
//        make.left.right.equalTo(16);
//        make.height.equalTo(50);
//    }];
    
}

-(void)commit{
    if (self.view0.imagebase64 == nil) {
        [self.view showMsg:NSLocalizedString(@"请拍摄身份证正面", nil)];
    }else if (self.view1.imagebase64 == nil){
        [self.view showMsg:NSLocalizedString(@"请拍摄身份证反面", nil)];
    }else if (self.view2.imagebase64 == nil){
        [self.view showMsg:NSLocalizedString(@"请拍摄手持身份证", nil)];
    }else{
//        UIImage *base0 = self.view0.image;
//        UIImage *base1 = self.view1.image;
//        UIImage *base2 = self.view2.image;
        [self.view showHUD];
        MJWeakSelf
        [NetManager FaceCompareDataWithIdFront:self.view1.imagebase64 IdRevers:self.view0.imagebase64 Face:self.view2.imagebase64 CompletionHandler:^(id responseObj, NSError *error) {
            if (!error) {
                if (![[NSString stringWithFormat:@"%@",responseObj[@"resultCode"]] isEqualToString:@"20000"]) {
                    dispatch_async_on_main_queue(^{
                        [weakSelf.view showAlert:[NSString stringWithFormat:@"Error:%ld",error.code] DetailMsg:responseObj[@"resultMsg"]];
                    });
                    return ;
                }else{//请求成功
                    dispatch_async_on_main_queue(^{
                        [weakSelf.view showMsg:NSLocalizedString(@"上传成功", nil)];
                    });
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                    });
                }
            }else{
                dispatch_async_on_main_queue(^{
                    [weakSelf.view showAlert:[NSString stringWithFormat:@"Error:%ld",error.code] DetailMsg:error.localizedDescription];
                });
            }
        }];
        
//        [NetManager FaceCompareWithIdFront:base1 IdRevers:base0 Face:base2 CompletionHandler:^(id responseObj, NSError *error) {
//            if (!error) {
//                if (![[NSString stringWithFormat:@"%@",responseObj[@"resultCode"]] isEqualToString:@"20000"]) {
//                    dispatch_async_on_main_queue(^{
//                        [weakSelf.view showMsg:responseObj[@"resultMsg"]];
//                    });
//                    return ;
//                }else{//请求成功
//
//                    dispatch_async_on_main_queue(^{
//                        [weakSelf.view showMsg:NSLocalizedString(@"上传成功", nil)];
//                    });
//                }
//            }else{
//                dispatch_async_on_main_queue(^{
//                    [weakSelf.view showAlert:[NSString stringWithFormat:@"Error:%ld",error.code] DetailMsg:error.localizedDescription];
//                });
//            }
//        }];
    }
}
-(void)takePhoto:(UIButton *)btn{
    self.currentIndex = btn.tag;
    [self presentViewController:self.actionController animated:YES completion:nil];
}

#pragma mark - alert controller
//从相册选择图片
- (UIAlertController *)actionController {
    MJWeakSelf
    if (!_actionController) {
        _actionController = [UIAlertController alertControllerWithTitle:nil
                                                                message:nil
                                                         preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"拍照", nil)
                                                                  style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction * _Nonnull action) {
                                                                    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ) {
                                                                        weakSelf.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                                                                        [weakSelf presentViewController:weakSelf.imagePickerController animated:YES completion:nil];
                                                                    }
                                                                }];
        
        //        UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"从相册中选择"
        //                                                              style:UIAlertActionStyleDefault
        //                                                            handler:^(UIAlertAction * _Nonnull action) {
        //                                                                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        //                                                                    weakSelf.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //                                                                    [weakSelf presentViewController:weakSelf.imagePickerController animated:YES completion:nil];
        //                                                                }
        //                                                            }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
        
        [_actionController addAction:takePhotoAction];
        // [_actionController addAction:albumAction];
        [_actionController addAction:cancelAction];
    }
    return _actionController;
}

//压缩图片
-(NSData *)compressImage:(UIImage*)image BySizeWithMaxLength:(NSUInteger)maxLength{
    UIImage *resultImage = image;
    NSData *data = UIImageJPEGRepresentation(resultImage, 1);
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        // Use image to draw (drawInRect:), image is larger but more compression time
        // Use result image to draw, image is smaller but less compression time
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, 1);
    }
    NSLog(@"%ld",data.length);
    return data;
}


#pragma mark - UIImagePickerControllerDelegate
//选择完成回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    if (image) {
        
        NSData *data =[self compressImage:image BySizeWithMaxLength:400000];
        UIImage *smallimage = [UIImage imageWithData:data];
       
        NSString *imageBase64 = [UIImage imageToDataURL:smallimage];
        NSString *imageBase64big = [UIImage imageToDataURL:image];
        imageBase64 = [imageBase64 componentsSeparatedByString:@"base64,"].lastObject;
        if (self.currentIndex == 0) {
            self.view0.image = smallimage;
            self.view0.imagebase64 = imageBase64;
            NSLog(@"&&& %ld \n %ld",imageBase64.length,imageBase64big.length);
            [self.view0.detaillabel setText:NSLocalizedString(@"已选择", nil)];
            [self.headbackiv0 setImage:image];
        }else if (self.currentIndex == 1){
            self.view1.image = smallimage;
            self.view1.imagebase64 = imageBase64;
            [self.view1.detaillabel setText:NSLocalizedString(@"已选择", nil)];
            [self.headbackiv1 setImage:image];
        }else if (self.currentIndex == 2){
            self.view2.image = smallimage;
            self.view2.imagebase64 = imageBase64;
            [self.view2.detaillabel setText:NSLocalizedString(@"已选择", nil)];
            [self.headbackiv2 setImage:image];
        }else{
            
        }
       
       
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImagePickerController *)imagePickerController {
    if (!_imagePickerController) {
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self;
        //判断数据来源为相册
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    return _imagePickerController;
}


//用户取消选择
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _scrollView.backgroundColor = RGB(255, 255, 255);
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.scrollEnabled = YES;
        _scrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight + 200);
        _scrollView.delegate =self;
        _scrollView.scrollsToTop = YES;
        [self.view addSubview:_scrollView];
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.top.equalTo(SafeAreaTopHeight);
            make.bottom.equalTo(-44 - SafeAreaBottomHeight);
        }];
        
    }
    
    return _scrollView;
}
@end
