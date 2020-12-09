//
//  LHViewRulesViewController.m
//  TaiYiToken
//
//  Created by mac on 2020/11/29.
//  Copyright © 2020 admin. All rights reserved.
//

#import "LHViewRulesViewController.h"

@interface LHViewRulesViewController ()

@property (weak, nonatomic) IBOutlet UITextView *rules;


@end

@implementation LHViewRulesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"规则描述", nil);

    [[MGPHttpRequest shareManager]post:@"/voteNode/rule" paramters:nil completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
        if ([responseObj[@"code"]intValue] == 0) {

            NSString *htmlString =responseObj[@"data"];
            
            NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            self.rules.attributedText = attributedString;
            
        }
                                
    }];
    
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
