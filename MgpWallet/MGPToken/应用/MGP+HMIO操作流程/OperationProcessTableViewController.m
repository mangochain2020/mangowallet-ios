//
//  OperationProcessTableViewController.m
//  TaiYiToken
//
//  Created by mac on 2020/9/23.
//  Copyright © 2020 admin. All rights reserved.
//

#import "OperationProcessTableViewController.h"

@interface OperationProcessTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *payNum;
@property (weak, nonatomic) IBOutlet UILabel *payCoinType;

@property (weak, nonatomic) IBOutlet UILabel *msg;

@property (weak, nonatomic) IBOutlet UILabel *msg1;
@property (weak, nonatomic) IBOutlet UILabel *submsg1;

@property (weak, nonatomic) IBOutlet UILabel *msg2;
@property (weak, nonatomic) IBOutlet UILabel *submsg2;

@property (weak, nonatomic) IBOutlet UILabel *msg3;
@property (weak, nonatomic) IBOutlet UILabel *submsg3;

@property (weak, nonatomic) IBOutlet UILabel *msg4;
@property (weak, nonatomic) IBOutlet UILabel *submsg4;

@property (weak, nonatomic) IBOutlet UILabel *msg5;


@property (weak, nonatomic) IBOutlet UILabel *msg6;

@property (weak, nonatomic) IBOutlet UILabel *hashMsg;
@property (weak, nonatomic) IBOutlet UITextView *hashTextView;

@end

@implementation OperationProcessTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"操作步骤", nil);

    self.msg.text = NSLocalizedString(@"待转账", nil);
    self.payNum.text = self.num;
    
    switch (self.transferType) {
        case transferHMIO_First:
        case transferHMIO_Two:
            self.payCoinType.text = @"HMIO";
            self.submsg2.text = @"0x155697df0d39e18f719fa58e25a53a65ccb4864e";
            self.submsg4.text = @"0xDA79e4a8839CB8EAF9BeCe5DB71feAA4565347B2";
            
            self.msg2.text = NSLocalizedString(@"点击复制HMIO代币合约地址", nil);
            self.submsg3.text = NSLocalizedString(@"搜索添加HMIO代币", nil);

            
            break;
        case transferHMIO_USDT:
            self.payCoinType.text = @"USDT";
            self.submsg2.text = @"0xdAC17F958D2ee523a2206206994597C13D831ec7";
            self.submsg4.text = self.usdtAdd;
            
            self.msg2.text = NSLocalizedString(@"点击复制USDT代币合约地址", nil);
            self.submsg3.text = NSLocalizedString(@"搜索添加USDT代币", nil);

            break;
        default:
            break;
    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return [super numberOfSectionsInTableView:tableView];;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return [super tableView:tableView numberOfRowsInSection:section];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    if (indexPath.section == 1) {
        if (indexPath.row == 0 || indexPath.row == 2) {
            [self.view showMsg:NSLocalizedString(@"地址已复制", nil)];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [UIPasteboard generalPasteboard].string = VALIDATE_STRING(cell.detailTextLabel.text);
        }
    }
    
}


- (IBAction)submitClick:(id)sender {
    switch (self.transferType) {
        case transferHMIO_First:
        case transferHMIO_Two:
            
                [self transferHMIO];
            break;
        case transferHMIO_USDT:
            
                [self transferUSDT];
            break;
        default:
            break;
    }
    
    
}

- (void)transferHMIO{
    NSString *url = @"";
    NSDictionary *dic = @{};
    if (self.payId) {
        url = @"/api/userOrder/blend/editHash";
        dic = @{@"address":[MGPHttpRequest shareManager].curretWallet.address,@"moneyType":VALIDATE_STRING(self.moneyType),@"hash":VALIDATE_STRING(self.hashTextView.text),@"id":VALIDATE_STRING(self.payId)};
        
    }else{
        url = @"/api/userOrder/blend/uploadHash";
        dic = @{@"address":[MGPHttpRequest shareManager].curretWallet.address,@"moneyType":@"4",@"hash":VALIDATE_STRING(self.hashTextView.text),@"num":VALIDATE_STRING(self.num)};
    }
    
    
    [[MGPHttpRequest shareManager]post:url paramters:dic completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
        if ([responseObj[@"code"] intValue] == 0) {
            [self.view showMsg:responseObj[@"msg"]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }];
    
}

- (void)transferUSDT{
    
    NSString *url = @"/appStorePayUsdt/addRecord";
    NSDictionary *dic = @{@"mgpName":[MGPHttpRequest shareManager].curretWallet.address,@"orderId":VALIDATE_STRING(self.orderId),@"hash":VALIDATE_STRING(self.hashTextView.text)};
        
    
    [[MGPHttpRequest shareManager]post:url paramters:dic completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
        if ([responseObj[@"code"] intValue] == 0) {
            [self.view showMsg:responseObj[@"msg"]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }];
    
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

@end
