//
//  ThemeVoteDetailViewController.m
//  TaiYiToken
//
//  Created by mac on 2020/10/19.
//  Copyright © 2020 admin. All rights reserved.
//

#import "ThemeVoteDetailViewController.h"
#import "LHSendTransactionViewController.h"

@interface ThemeVoteDetailViewController ()
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UILabel *voteTitle;
@property (weak, nonatomic) IBOutlet UILabel *voteAddress;
@property (weak, nonatomic) IBOutlet UILabel *voteNum;
@property (weak, nonatomic) IBOutlet UILabel *voteContent;
@property (weak, nonatomic) IBOutlet UILabel *voteTime;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@property (copy,nonatomic)NSString *nodeMoney;
@property (nonatomic, weak) XFDialogFrame *dialogView;

@end

@implementation ThemeVoteDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"方案详情", nil);
    [self.rightBtn setTitle:NSLocalizedString(@"节点投票", nil) forState:UIControlStateNormal];
    self.rightBtn.hidden = YES;
    self.tableView.tableFooterView = [UIView new];
    self.voteTitle.text = self.dic[@"voteTitle"];
    self.voteAddress.text = self.dic[@"address"];
    self.voteNum.text = [NSString stringWithFormat:@"🔥%@票",VALIDATE_STRING(self.dic[@"voteCount"])];
    self.voteContent.text = self.dic[@"voteContent"];
    self.voteTime.text = self.dic[@"voteStartTime"];
    if ([self.dic[@"type"]intValue] == 4) {
        self.button.hidden = YES;
    }
    [[MGPHttpRequest shareManager]post:@"/voteTheme/checkSuperNode" paramters:@{@"mgpName":[MGPHttpRequest shareManager].curretWallet.address} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {

        if ([responseObj[@"code"]intValue] == 0) {
            NSDictionary *dic = responseObj[@"data"];

            self.rightBtn.hidden = ([dic[@"isSuperNode"]intValue] == 1 && [dic[@"isVote"]intValue] == 0 && [self.dic[@"type"]intValue] != 4) ? NO : YES;
            self.nodeMoney = dic[@"money"];
        }
        
    }];
    

    
}
- (IBAction)rightButtonClick:(id)sender {
    NSString *titleName = [NSString stringWithFormat:@"%@(%@)%@",NSLocalizedString(@"您是否将超级节点票数", nil),self.nodeMoney,NSLocalizedString(@"投递给该方案", nil)];
    
    WEAKSELF; //
    NSDictionary *attrs = @{XFDialogNoticeText:titleName, XFDialogCancelButtonTitle: NSLocalizedString(@"取消", nil), XFDialogCommitButtonTitle: NSLocalizedString(@"投票", nil),XFDialogTitleViewBackgroundColor:[UIColor orangeColor]};
    
    self.dialogView = [[[XFDialogNotice dialogWithTitle:NSLocalizedString(@"超级节点投票", nil) attrs:attrs commitCallBack:^(NSString *inputText) {
                    
        [weakSelf.dialogView hideWithAnimationBlock:nil];
        [[MGPHttpRequest shareManager]post:@"/voteTheme/addSuperVote" paramters:@{@"address":[MGPHttpRequest shareManager].curretWallet.address,@"voteId":self.dic[@"voteId"],@"money":self.nodeMoney} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {

            if ([responseObj[@"code"]intValue] == 0) {
                [self.view showMsg:NSLocalizedString(@"节点投票成功", nil)];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
            
        }];
        
        
    }] showWithAnimationBlock:nil]setCancelCallBack:nil];
    
    
}
- (IBAction)buttonClick:(id)sender {
    
    if ([self.dic[@"type"]intValue] == 3) {
        [[MGPHttpRequest shareManager]post:@"/voteTheme/isVote" paramters:@{@"address":[MGPHttpRequest shareManager].curretWallet.address} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {

            if ([responseObj[@"code"]intValue] == 0) {

                UIStoryboard* secondStoryboard = [UIStoryboard storyboardWithName:@"ExchangeHome" bundle:[NSBundle mainBundle]];
                LHSendTransactionViewController *secondNavigationController = [secondStoryboard instantiateViewControllerWithIdentifier:@"LHSendTransactionViewController"];
                secondNavigationController.sendType = vote;
                secondNavigationController.remaining = self.dic[@"voteId"];
                [self.navigationController pushViewController:secondNavigationController animated:YES];
                
            }
            
        }];
    }else{
        [self.view showMsg:NSLocalizedString(@"暂未开启", nil)];
    }
    
    
    
    
    
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
