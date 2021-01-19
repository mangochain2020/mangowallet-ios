//
//  OverTheCounterBuyViewController.m
//  TaiYiToken
//
//  Created by mac on 2020/12/29.
//  Copyright © 2020 admin. All rights reserved.
//

#import "OverTheCounterBuyViewController.h"
#import "OverTheCounterOrderDetailMangeViewController.h"

@interface OverTheCounterBuyViewController ()
{
    double price;
    double quantity;
    double min_accept_quantity;
}
@property (weak, nonatomic) IBOutlet UILabel *min_accept_quantityLabelL;
@property (weak, nonatomic) IBOutlet UITextField *buyNumberTF;
@property (weak, nonatomic) IBOutlet UIButton *allBtn;

@property (weak, nonatomic) IBOutlet UILabel *buyNumberLabelL;
@property (weak, nonatomic) IBOutlet UILabel *buyNumberLabelR;

@property (weak, nonatomic) IBOutlet UILabel *buyPriceLabelL;
@property (weak, nonatomic) IBOutlet UILabel *buyPriceLabelR;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;


@end

@implementation OverTheCounterBuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //限额
    price = [[self.dic[@"price"] componentsSeparatedByString:@" "].firstObject doubleValue];
    double quantity_str = [[self.dic[@"quantity"] componentsSeparatedByString:@" "].firstObject doubleValue];
    double frozen_quantity_str = [[self.dic[@"frozen_quantity"] componentsSeparatedByString:@" "].firstObject doubleValue];
    double fufilled_quantity_str = [[self.dic[@"fulfilled_quantity"] componentsSeparatedByString:@" "].firstObject doubleValue];
    quantity = quantity_str - fufilled_quantity_str - frozen_quantity_str;
    
    
    min_accept_quantity = [[self.dic[@"min_accept_quantity"] componentsSeparatedByString:@" "].firstObject doubleValue];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.buyNumberTF];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidEnd) name:UITextFieldTextDidEndEditingNotification object:self.buyNumberTF];

    self.buyNumberTF.placeholder = self.isBuy ? @"CNY" : @"MGP";
    if (self.isBuy) {
        self.min_accept_quantityLabelL.text = [NSString stringWithFormat:@"%@￥%.2f-￥%.2f",NSLocalizedString(@"限额", nil),min_accept_quantity,quantity * price];

        
    }else{
        
        self.min_accept_quantityLabelL.text = [NSString stringWithFormat:@"%@%.4f-%.4f MGP",NSLocalizedString(@"限额", nil),min_accept_quantity/price,quantity];

        
    }
    
    
}
/**
 *  文本框的文字发生改变的时候调用
 */
- (void)textChange
{

    if (self.isBuy) {
        if ([self.buyNumberTF.text doubleValue] > (quantity*price)) {
            [self.view endEditing:YES];
        }
    }else{
        if ([self.buyNumberTF.text doubleValue] > quantity) {
            [self.view endEditing:YES];
        }
    }
}

/**
 *  文本框的文字结束编辑
 */
- (void)textDidEnd
{

    if (self.isBuy) {
        if ([self.buyNumberTF.text doubleValue] <= (quantity*price) && [self.buyNumberTF.text doubleValue] >= min_accept_quantity) {
            [self calculation:([self.buyNumberTF.text doubleValue]/price)];
        }else{
            [self.view showMsg:NSLocalizedString(@"限额", nil)];
            self.buyNumberTF.text = @"";
            [self calculation:[self.buyNumberTF.text doubleValue]];
            
        }
        
    }else{
        if ([self.buyNumberTF.text doubleValue] <= quantity && [self.buyNumberTF.text doubleValue] >= (min_accept_quantity/price)) {
            [self calculation:[self.buyNumberTF.text doubleValue]];
        }else{
            [self.view showMsg:NSLocalizedString(@"限额", nil)];
            self.buyNumberTF.text = @"";
            [self calculation:[self.buyNumberTF.text doubleValue]];

        }
    }
    
}

- (IBAction)allBuyClick:(id)sender {
    if (self.isBuy) {
        self.buyNumberTF.text = [NSString stringWithFormat:@"%.4f",quantity*price];
        [self calculation:quantity];

    }else{
        self.buyNumberTF.text = [NSString stringWithFormat:@"%.4f",quantity];
        [self calculation:([self.buyNumberTF.text doubleValue])];

    }
}
- (IBAction)buyClick:(id)sender {
    
    double buyNum = [[self.buyNumberLabelR.text componentsSeparatedByString:@" "].firstObject doubleValue];
    NSString *buyNumStr = [[self.buyNumberLabelR.text componentsSeparatedByString:@" "].firstObject stringByReplacingOccurrencesOfString:@"." withString:@""];//替换字符
    
    if (buyNum > 0) {
        NSString *mgp_otcstore = [[DomainConfigManager share]getCurrentEvnDict][otcstore];
        NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
        NSInteger time = interval;
        NSString *order_sn = [NSString stringWithFormat:@"%zd",(long)time];
        
        NSDictionary *p = @{@"taker":[MGPHttpRequest shareManager].curretWallet.address,
                            @"order_id":self.dic[@"id"],
                            @"deal_quantity":self.buyNumberLabelR.text,
                            @"order_sn":order_sn
                            
        };
        [[DCMGPWalletTool shareManager]contractCode:mgp_otcstore andAction:@"opendeal" andParameters:p andPassWord:VALIDATE_STRING([[NSUserDefaults standardUserDefaults]objectForKey:PassWordText]) completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
                 
            if (responseObj) {
                [self.view showMsg:NSLocalizedString(@"下单成功", nil)];
                
                NSDictionary *dic = @{
                    @"json": @1,
                    @"code": mgp_otcstore,
                    @"scope":mgp_otcstore,
                    @"index_position":@"6",
                    @"table":@"deals",
                    @"key_type":@"i64",
                    @"limit":@"500",
                    @"lower_bound":order_sn,
                    @"upper_bound":order_sn
                };
                
                [[HTTPRequestManager shareMgpManager] post:eos_get_table_rows paramters:dic success:^(BOOL isSuccess, id responseObject) {

                    if (isSuccess) {
                        NSArray *arr = (NSArray *)responseObject[@"rows"];
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            
                            [self dismissViewControllerAnimated:YES completion:nil];
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"OverTheCounterBuyNotification" object:arr.firstObject];
                            
                        });
                        
                    }
                    NSLog(@"%@",responseObject);

                } failure:^(NSError *error) {

                } superView:self.view showFaliureDescription:YES];
                
                
                
            }
        }];
        
    }
    
}

- (void)calculation:(double)mgpNumber{
    
    self.buyNumberLabelR.text = [NSString stringWithFormat:@"%.4f MGP",mgpNumber];
    self.buyPriceLabelR.text = [NSString stringWithFormat:@"￥%.2f",mgpNumber*price];
    [self.buyButton setEnabled:(mgpNumber > 0 ? YES : NO)];
    self.buyButton.backgroundColor = (mgpNumber > 0 ? RGB(0, 141, 237) : RGB(194, 194, 194));
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
