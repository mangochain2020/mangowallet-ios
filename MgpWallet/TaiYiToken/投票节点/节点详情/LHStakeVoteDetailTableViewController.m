//
//  LHStakeVoteDetailTableViewController.m
//  TaiYiToken
//
//  Created by mac on 2020/11/17.
//  Copyright © 2020 admin. All rights reserved.
//

#import "LHStakeVoteDetailTableViewController.h"
#import "LHStakeVoteSendTableViewController.h"
#import "LHStakeVoteRecordTableViewController.h"
#import "LHStakeVoteAddTableViewController.h"

@interface LHStakeVoteDetailTableViewController ()

@property(strong, nonatomic) NSDictionary *dataDictionary;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIImageView *voteImage;

@property (weak, nonatomic) IBOutlet UILabel *nodeName;
@property (weak, nonatomic) IBOutlet UILabel *mgpAddress;
@property (weak, nonatomic) IBOutlet UILabel *nodeContent;

@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIButton *centBtn;

@property (weak, nonatomic) IBOutlet UILabel *voteTitle;
@property (weak, nonatomic) IBOutlet UILabel *voteNum;

@property (weak, nonatomic) IBOutlet UILabel *nodeUrlTitle;
@property (weak, nonatomic) IBOutlet UILabel *nodeUrl;

@property (weak, nonatomic) IBOutlet UILabel *nodeShareRatioTitle;
@property (weak, nonatomic) IBOutlet UILabel *nodeShareRatio;

@property (weak, nonatomic) IBOutlet UILabel *nodeRewardRuleTitle;
@property (weak, nonatomic) IBOutlet UILabel *nodeRewardRule;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;

@end

@implementation LHStakeVoteDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"StakeVote", nil);
    [self.centBtn setTitle:NSLocalizedString(@"直接投票", nil) forState:UIControlStateNormal];
    self.voteTitle.text = NSLocalizedString(@"票数", nil);
    self.nodeUrlTitle.text = NSLocalizedString(@"节点", nil);
    self.nodeShareRatioTitle.text = NSLocalizedString(@"比率", nil);
    self.nodeRewardRuleTitle.text = NSLocalizedString(@"社群介绍", nil);

    self.tableView.tableFooterView = [UIView new];
    if (self.isSelfPush) {
        [self.rightBtn setHidden:NO];
        [self.editBtn setHidden:NO];
        [self.rightBtn setTitle:NSLocalizedString(@"账户", nil) forState:UIControlStateNormal];
        [self.editBtn setTitle:NSLocalizedString(@"编辑节点", nil) forState:UIControlStateNormal];
    }
    NSDictionary *dict = self.listArray.firstObject;
    [[MGPHttpRequest shareManager]post:@"/voteNode/nodeDetail" paramters:@{@"address":dict[@"owner"]} completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
        
        if ([responseObj[@"code"]intValue] == 0) {
            self.centBtn.hidden = NO;
            NSDictionary *dic = responseObj[@"data"];
            if ([dic isKindOfClass:[NSDictionary class]]) {
                self.dataDictionary = dic;
                [self.voteImage sd_setImageWithURL:[NSURL URLWithString:VALIDATE_STRING([dic objectForKey:@"nodeHeadImg"])] placeholderImage:[UIImage imageNamed:@"MGP_coin"]];
                
                self.nodeName.text = [dic objectForKey:@"nodeName"];
                self.mgpAddress.text = [NSString stringWithFormat:@"@%@",[dic objectForKey:@"mgpAddress"]];
                self.nodeContent.text = [dic objectForKey:@"nodeContent"];
                
                self.voteNum.text = VALIDATE_STRING(dict[@"received_votes"]);
                
                self.nodeUrl.text = VALIDATE_STRING([dic objectForKey:@"nodeUrl"]);
                
                self.nodeShareRatio.text = [NSString stringWithFormat:@"%.f%%",(10000-[[dic objectForKey:@"nodeShareRatio"]doubleValue]) / 100];
                
                self.nodeRewardRule.text = VALIDATE_STRING([dic objectForKey:@"nodeRewardRule"]);
                

                CGSize baseSize = CGSizeMake(kScreenWidth-30, CGFLOAT_MAX);
                CGSize labelsize = [self.nodeContent sizeThatFits:baseSize];
                
                CGRect headerFrame = _bgView.frame;
                headerFrame.size.height = labelsize.height + 400;
                _bgView.frame = headerFrame;
                self.tableView.tableHeaderView = _bgView;
            }
            
            
        }
                                
    }];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (IBAction)editClick:(id)sender {
    LHStakeVoteAddTableViewController *vc = [LHStakeVoteAddTableViewController new];
    vc.min_bp_list_quantity = 0;
    [self.navigationController pushViewController:vc animated:YES];
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.destinationViewController isKindOfClass:[LHStakeVoteSendTableViewController class]]) {
        LHStakeVoteSendTableViewController *vc = segue.destinationViewController;
        vc.listArray = self.listArray;
        vc.listDictionary = @[self.dataDictionary];


    }
    
}


@end
