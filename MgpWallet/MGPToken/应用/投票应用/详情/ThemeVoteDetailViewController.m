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

@end

@implementation ThemeVoteDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"方案详情", nil);
    self.tableView.tableFooterView = [UIView new];
    self.voteTitle.text = self.dic[@"voteTitle"];
    self.voteAddress.text = self.dic[@"address"];
    self.voteNum.text = [NSString stringWithFormat:@"🔥%@票",VALIDATE_STRING(self.dic[@"voteCount"])];
    self.voteContent.text = self.dic[@"voteContent"];
    self.voteTime.text = self.dic[@"voteStartTime"];
    if ([self.dic[@"type"]intValue] == 4) {
        self.button.hidden = YES;
    }

    
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
