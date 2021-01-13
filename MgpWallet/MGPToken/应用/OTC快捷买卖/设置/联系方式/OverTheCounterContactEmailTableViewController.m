//
//  OverTheCounterContactEmailTableViewController.m
//  TaiYiToken
//
//  Created by mac on 2021/1/7.
//  Copyright © 2021 admin. All rights reserved.
//

#import "OverTheCounterContactEmailTableViewController.h"

@interface OverTheCounterContactEmailTableViewController ()

@property (weak, nonatomic) IBOutlet UILabel *emailLabelL;
@property (weak, nonatomic) IBOutlet UILabel *codeLabelL;

@property (weak, nonatomic) IBOutlet UITextField *emailLabelR;
@property (weak, nonatomic) IBOutlet UITextField *codeLabelR;

@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UIButton *submit;

@end

@implementation OverTheCounterContactEmailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"邮箱验证", nil);

    [self.submit setEnabled:NO];
    self.submit.backgroundColor = RGB(194, 194, 194);
    
}

- (IBAction)sendEmail:(id)sender {
    
    [[MGPHttpRequest shareManager]post:@"/email/send" isNewPath:YES paramters:@{@"mgpName":[MGPHttpRequest shareManager].curretWallet.address,@"mail":self.emailLabelR.text,@"type":@"0"} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
        if ([responseObj[@"code"]intValue] == 0) {
            [self.view showMsg:NSLocalizedString(@"验证码发送成功", nil)];
            [self setupGCD];
            [self.submit setEnabled:YES];
            self.submit.backgroundColor = RGB(0, 141, 237);
        }
        
    }];
    
    
}
- (IBAction)submitClick:(id)sender {
    
    [[MGPHttpRequest shareManager]post:@"/moUsers/save" isNewPath:YES paramters:@{@"mgpName":[MGPHttpRequest shareManager].curretWallet.address,@"mail":self.emailLabelR.text,@"type":@"0",@"code":self.codeLabelR.text} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
        if ([responseObj[@"code"]intValue] == 0) {
            [self.view showMsg:NSLocalizedString(@"保存成功", nil)];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }];
    
}
- (void)setupGCD {
    [self.sendBtn setEnabled:NO];

    __block NSInteger bottomCount = 59;
    [self.sendBtn setTitle:[NSString stringWithFormat:@"%lds",bottomCount] forState:UIControlStateNormal];

    //获取全局队列
    dispatch_queue_t global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //创建一个定时器，并将定时器的任务交给全局队列执行
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, global);
    
    // 设置触发的间隔时间 1.0秒执行一次 0秒误差
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);

    __weak typeof(self)weakSelf = self;

    dispatch_source_set_event_handler(timer, ^{

        if (bottomCount <= 0) {
            //关闭定时器
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.sendBtn setTitle:NSLocalizedString(@"重新发送", nil) forState:UIControlStateNormal];
                [weakSelf.sendBtn setEnabled:YES];
            });

        }else {
            bottomCount -= 1;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.sendBtn setTitle:[NSString stringWithFormat:@"%lds",bottomCount] forState:UIControlStateNormal];

            });
        }
    });
    
    dispatch_resume(timer);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return [super numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return [super tableView:tableView numberOfRowsInSection:section];
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
