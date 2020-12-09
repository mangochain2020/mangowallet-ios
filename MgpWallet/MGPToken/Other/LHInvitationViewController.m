//
//  LHInvitationViewController.m
//  TaiYiToken
//
//  Created by mac on 2020/9/4.
//  Copyright © 2020 admin. All rights reserved.
//

#import "LHInvitationViewController.h"

@interface LHInvitationViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *invitationTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *invitationLabel;
@property (weak, nonatomic) IBOutlet UILabel *invitationNum;

@property (weak, nonatomic) IBOutlet UIImageView *qrCodeView;
@property (weak, nonatomic) IBOutlet UILabel *invitationMsg;

@property (weak, nonatomic) IBOutlet UIButton *invitationCopyBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareCopyBtn;

@property (copy,nonatomic)NSString *download;


@end

@implementation LHInvitationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [FIRAnalytics logEventWithName:FIR_PageSwitchEvent parameters:@{FIR_PageSwitchVCName:@"LHInvitationViewController",FIR_PageSwitchVCUser:[MGPHttpRequest shareManager].curretWallet.address,FIR_TypeKey:FIR_TypeValue}];

    
    self.invitationTitleLabel.text = NSLocalizedString(@"邀请码", nil);
    self.title = NSLocalizedString(@"我的邀请码", nil);
    [self.invitationCopyBtn setTitle:NSLocalizedString(@"复制邀请码", nil) forState:UIControlStateNormal];
    [self.shareCopyBtn setTitle:NSLocalizedString(@"安装分享链接", nil) forState:UIControlStateNormal];

    for (UIButton *btn in @[self.invitationCopyBtn,self.shareCopyBtn]) {
        btn.layer.cornerRadius = btn.frame.size.height/2;
        btn.layer.masksToBounds = YES;
        btn.layer.borderColor = btn.titleLabel.textColor.CGColor;
        
    }
    
    
    [[MGPHttpRequest shareManager]post:@"/user/findMgp" paramters:@{@"mgpName":[MGPHttpRequest shareManager].curretWallet.address} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {

        if ([responseObj[@"code"]intValue] == 0) {
            self.invitationLabel.text = [responseObj[@"data"]objectForKey:@"lnvitationCode"];
            self.download = [responseObj[@"data"]objectForKey:@"download"];
            self.qrCodeView.image = [CreateAll CreateQRCodeForAddress:self.download];

            self.invitationNum.text = [NSString stringWithFormat:@"%@%@%@",NSLocalizedString(@"已成功邀请", nil),[responseObj[@"data"]objectForKey:@"shareCount"],NSLocalizedString(@"人", nil)];
            
            self.invitationMsg.text = [NSString stringWithFormat:@"%@\n%@",[responseObj[@"data"]objectForKey:@"shareTitle"],[responseObj[@"data"]objectForKey:@"shareContent"]];


            
        }else{
            self.invitationLabel.text = NSLocalizedString(@"未生成", nil);
        }
        
        
    }];
    
}
- (IBAction)copylnvitationCode:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.invitationLabel.text;
    [self.view showMsg:[NSString stringWithFormat:@"\"%@\" %@",pasteboard.string, NSLocalizedString(@"已复制", nil)]];
}
- (IBAction)shareClick:(id)sender {
//    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//    pasteboard.string = self.download;
//    [self.view showMsg:[NSString stringWithFormat:@"\"%@\" %@",pasteboard.string, NSLocalizedString(@"已复制", nil)]];
    NSString *textToShare = @"MangoWallet去中心化APP，现在就下载安装";

    UIImage *imageToShare = [UIImage imageNamed:@"MGP_coin"];
    
    NSURL *urlToShare = [NSURL URLWithString:self.download];
    
    NSArray *activityItemsArray = @[textToShare,imageToShare,urlToShare];
    
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItemsArray applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypePostToFacebook,
                                         UIActivityTypePostToTwitter,
                                         UIActivityTypePostToWeibo,
                                         UIActivityTypeMail,
                                         UIActivityTypePrint,
                                         UIActivityTypeCopyToPasteboard,
                                         UIActivityTypeAssignToContact,
                                         UIActivityTypeSaveToCameraRoll,
                                         UIActivityTypeAddToReadingList,
                                         UIActivityTypePostToFlickr,
                                         UIActivityTypePostToVimeo,
                                         UIActivityTypePostToTencentWeibo,
                                         UIActivityTypeAirDrop,
                                         UIActivityTypeMessage,
                                         UIActivityTypeOpenInIBooks];
                                         
    activityVC.completionWithItemsHandler = ^(NSString *activityType,BOOL completed,NSArray *returnedItems,NSError *activityError)
    {
        NSLog(@"%@", activityType);
        
        if (completed) { // 确定分享
            NSLog(@"分享成功");
        }
        else {
            NSLog(@"分享失败");
        }
    };
    
    [self presentViewController:activityVC animated:YES completion:nil];
    
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
