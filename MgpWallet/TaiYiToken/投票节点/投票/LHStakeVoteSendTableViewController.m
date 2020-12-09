//
//  LHStakeVoteSendTableViewController.m
//  TaiYiToken
//
//  Created by mac on 2020/11/17.
//  Copyright © 2020 admin. All rights reserved.
//

#import "LHStakeVoteSendTableViewController.h"
#import "LHStakeVoteMainTableViewCell.h"

@interface LHStakeVoteSendTableViewController ()
{
    int buttonY;
}
@property(strong, nonatomic) UIButton *flowButton;
@property(assign, nonatomic) int refund_delay_sec;


@property (weak, nonatomic) IBOutlet UILabel *walletNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *walletAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *tokenBalanceLabel;

@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UIButton *vokeBtn;


@end

@implementation LHStakeVoteSendTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"StakeVote", nil);
    [self.vokeBtn setTitle:[NSString stringWithFormat:@"%@(0) MGP",NSLocalizedString(@"投票", nil)] forState:UIControlStateNormal];

    self.amountTextField.placeholder = NSLocalizedString(@"请输入抵押金额", nil);
    self.tableView.rowHeight = 110;

    self.walletNameLabel.text = [MGPHttpRequest shareManager].curretWallet.walletName;
    self.walletAddressLabel.text = [MGPHttpRequest shareManager].curretWallet.address;
    [[HTTPRequestManager shareMgpManager] post:eos_get_currency_balance paramters:@{@"json": @1,@"code": @"eosio.token",@"account":[MGPHttpRequest shareManager].curretWallet.address,@"symbol":@"MGP"} success:^(BOOL isSuccess, id responseObject) {

        NSLog(@"%@",responseObject);
        
        if (isSuccess) {
            NSArray *temp = (NSArray *)responseObject;
            self.tokenBalanceLabel.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"余额", nil),temp.firstObject];
        }
    } failure:^(NSError *error) {
        
    } superView:self.view showFaliureDescription:YES];
    
    NSString *mgp_bpvoting = [[DomainConfigManager share]getCurrentEvnDict][bpvoting];
    [[HTTPRequestManager shareMgpManager] post:eos_get_table_rows paramters:@{@"json": @1,@"code": mgp_bpvoting,@"scope":mgp_bpvoting,@"table":@"global"} success:^(BOOL isSuccess, id responseObject) {

        NSLog(@"%@",responseObject);

        if (isSuccess) {
            NSArray *arr = (NSArray *)responseObject[@"rows"];
            NSDictionary *dic = arr.firstObject;
            _refund_delay_sec = [[dic[@"min_bp_vote_quantity"] componentsSeparatedByString:@" "].firstObject intValue];

        }
    } failure:^(NSError *error) {
        
    } superView:self.view showFaliureDescription:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.amountTextField];
    
}
/**
 *  文本框的文字发生改变的时候调用
 */
- (void)textChange
{
    [self.vokeBtn setTitle:[NSString stringWithFormat:@"%@(%@) MGP",NSLocalizedString(@"投票", nil),self.amountTextField.text] forState:UIControlStateNormal];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.listArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LHStakeVoteMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LHStakeVoteMainTableViewCellIndex" forIndexPath:indexPath];

    
    if (self.listDictionary.count > 0) {
        NSDictionary *dic = self.listDictionary[indexPath.row];
        cell.address.text = [dic objectForKey:@"nodeName"];
        cell.reward_share.text = [NSString stringWithFormat:@"%@%.f%%",NSLocalizedString(@"获得比率", nil),(10000-[[dic objectForKey:@"nodeShareRatio"]doubleValue])/100];
        cell.url_votes.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"节点", nil),VALIDATE_STRING([dic objectForKey:@"nodeUrl"])];
    }else{
        NSDictionary *dic = self.listArray[indexPath.row];
        cell.address.text = dic[@"owner"];
        cell.reward_share.text = @"";
        cell.url_votes.text = @"";
    }
    
    cell.rank.text = @"";
    cell.received_votes.text = @"";

    return cell;
}
- (IBAction)sendClick:(id)sender {
    if ([self.amountTextField.text doubleValue] < _refund_delay_sec) {
        [self.view showMsg:[NSString stringWithFormat:@"%@:%d",NSLocalizedString(@"最低投票数", nil),_refund_delay_sec]];
        return;;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"请输入密码！", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = NSLocalizedString(@"密码(8-18位字符)", nil);
        textField.secureTextEntry = YES;
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *pass = alertController.textFields.firstObject;

        NSString *owner = @"";
        if (self.listDictionary.count > 0) {
            NSDictionary *p = self.listDictionary.firstObject;
            owner = p[@"mgpAddress"];
        }else{
            NSDictionary *p = self.listArray.firstObject;
            owner = p[@"owner"];
        }
        NSString *mgp_bpvoting = [[DomainConfigManager share]getCurrentEvnDict][bpvoting];
        [[DCMGPWalletTool shareManager]transferAmount:VALIDATE_STRING(self.amountTextField.text) andFrom:[MGPHttpRequest shareManager].curretWallet.address andTo:mgp_bpvoting andMemo:[NSString stringWithFormat:@"vote:%@",owner] andPassWord:VALIDATE_STRING(pass.text) completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
            
            if (responseObj) {
                [FIRAnalytics logEventWithName:@"StakeVote" parameters:@{FIR_PageSwitchVCUser:[MGPHttpRequest shareManager].curretWallet.address}];

                [self.view showMsg:NSLocalizedString(@"投票成功", nil)];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
            
        }];
        
        
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)setup
{
    
//  添加悬浮按钮
    _flowButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _flowButton.frame = CGRectMake(0, 0, ScreenW, 60);
    _flowButton.center = CGPointMake(ScreenW/2, ScreenH - 120);
    [_flowButton setTitle:NSLocalizedString(@"投票(0 MGP)", nil) forState:UIControlStateNormal];
//    _flowButton.titleLabel.textColor = [UIColor whiteColor];
    [_flowButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_flowButton addTarget:self action:@selector(sendClick:) forControlEvents:UIControlEventTouchUpInside];
    _flowButton.backgroundColor = [UIColor cyanColor];


    [self.tableView addSubview:_flowButton];
    [self.tableView bringSubviewToFront:_flowButton];
    buttonY=(int)_flowButton.frame.origin.y;

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
   _flowButton.frame = CGRectMake(_flowButton.frame.origin.x, buttonY+self.tableView.contentOffset.y , _flowButton.frame.size.width, _flowButton.frame.size.height);
}
- (void)sendClick11:(UIButton *)btn {
    
    
    

}

@end
