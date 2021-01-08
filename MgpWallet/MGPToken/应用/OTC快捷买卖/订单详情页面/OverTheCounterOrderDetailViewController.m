//
//  OverTheCounterOrderDetailViewController.m
//  TaiYiToken
//
//  Created by mac on 2020/12/29.
//  Copyright © 2020 admin. All rights reserved.
//

#import "OverTheCounterOrderDetailViewController.h"
#import "OverTheCounterOrderDetail0TableViewCell.h"
#import "OverTheCounterOrderDetail1TableViewCell.h"
#import "OverTheCounterOrderDetail2TableViewCell.h"

@interface OverTheCounterOrderDetailViewController ()<UITableViewDelegate>
{
    NSString *mgp_otcstore;
    
}
@property(strong, nonatomic)NSMutableArray *listArray;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeight;

@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@property (weak, nonatomic) IBOutlet UIButton *footerButton;

@property (nonatomic, weak) XFDialogFrame *dialogView;

@end

@implementation OverTheCounterOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    mgp_otcstore = [[DomainConfigManager share]getCurrentEvnDict][otcstore];

    // Do any additional setup after loading the view.
    self.tableView.mj_header = [DCHomeRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(setUpData)];
    [self.tableView.mj_header beginRefreshing];

    
}
#pragma mark - 获取数据
- (void)setUpData
{
    _titleView.titleLabelR.text = @"0";
    _titleView.titleLabelL.text = @"0";
    _titleView.subTitleLabelL.text = @"";
    _titleView.subTitleLabelR.text = @"";
    self.listArray = [NSMutableArray array];
    
    
    self.bottomHeight.constant = 0;
    switch (self.orderDetailType) {
        case OrderDetailType_PaymentSeller://向卖家付款
        {
            
            self.tableView.tableFooterView = [UIView new];
            self.bottomHeight.constant = 60;

            [self.leftButton setTitle:NSLocalizedString(@"取消订单", nil) forState:UIControlStateNormal];
            [self.rightButton setTitle:NSLocalizedString(@"已付款,请放币", nil) forState:UIControlStateNormal];
            
            NSString *order_price_string = [self.dicData[@"order_price"] componentsSeparatedByString:@" "].firstObject;
            NSString *deal_quantity_string = [self.dicData[@"deal_quantity"] componentsSeparatedByString:@" "].firstObject;
            
            NSString *price = [NSString stringWithFormat:@"￥%@",order_price_string];
            NSString *totalPrice = [NSString stringWithFormat:@"￥%.2f",order_price_string.doubleValue * deal_quantity_string.doubleValue];

            _titleView.titleLabelL.text = NSLocalizedString(@"向卖家付款", nil);
            _titleView.titleLabelR.text = totalPrice;
            
            _titleView.subTitleLabelL.text = NSLocalizedString(@"付款剩余时间", nil);
            [self setupGCDTime:125];
            
            NSArray *temp1 = @[
                @{@"leftTitle":NSLocalizedString(@"卖家联系方式", nil),@"isTitle":@(1),@"rightTitle":@"",@"isCopy":@(0),@"isBold":@(0)},
                @{@"leftTitle":NSLocalizedString(@"MGP账户", nil),@"isTitle":@(0),@"rightTitle":self.dicData[@"order_maker"],@"isCopy":@(1),@"isBold":@(0)},
                @{@"leftTitle":NSLocalizedString(@"邮箱", nil),@"isTitle":@(0),@"rightTitle":self.sellUserInfo[@"mail"],@"isCopy":@(1),@"isBold":@(0)},
                @{@"leftTitle":NSLocalizedString(@"电话", nil),@"isTitle":@(0),@"rightTitle":self.sellUserInfo[@"phone"],@"isCopy":@(1),@"isBold":@(0)},
                @{@"leftTitle":NSLocalizedString(@"微信号", nil),@"isTitle":@(0),@"rightTitle":self.sellUserInfo[@"weixin"],@"isCopy":@(1),@"isBold":@(0)},

            ];
            
            
            NSArray *temp2 = @[
                @{@"leftTitle":NSLocalizedString(@"交易明细", nil),@"isTitle":@(1),@"rightTitle":@"",@"isCopy":@(0),@"isBold":@(0)},
                @{@"leftTitle":NSLocalizedString(@"总价", nil),@"isTitle":@(0),@"rightTitle":totalPrice,@"isCopy":@(0),@"isBold":@(1)},
                @{@"leftTitle":NSLocalizedString(@"价格", nil),@"isTitle":@(0),@"rightTitle":price,@"isCopy":@(0),@"isBold":@(1)},
                @{@"leftTitle":NSLocalizedString(@"数量", nil),@"isTitle":@(0),@"rightTitle":self.dicData[@"deal_quantity"],@"isCopy":@(0),@"isBold":@(0)},
                @{@"leftTitle":NSLocalizedString(@"订单号", nil),@"isTitle":@(0),@"rightTitle":self.dicData[@"order_sn"],@"isCopy":@(1),@"isBold":@(0)},
            ];
            
            NSArray *temp3 = @[
                @{@"leftTitle":NSLocalizedString(@"如有疑问或与卖家发生纠纷，请联系客服", nil),@"isTitle":@(1),@"rightTitle":@"",@"isCopy":@(0),@"isBold":@(0)},
                @{@"leftTitle":NSLocalizedString(@"微信号", nil),@"isTitle":@(0),@"rightTitle":wechatName,@"isCopy":@(1),@"isBold":@(0)},
            ];
            [self.listArray addObject:@[]];
            [self.listArray addObject:temp1];
            [self.listArray addObject:temp2];
            [self.listArray addObject:temp3];

            
            
        }
            break;
        case OrderDetailType_WaitingSellerPass://等待卖家放行
        {
            
            self.tableView.tableFooterView = [UIView new];

            NSString *order_price_string = [self.dicData[@"order_price"] componentsSeparatedByString:@" "].firstObject;
            NSString *deal_quantity_string = [self.dicData[@"deal_quantity"] componentsSeparatedByString:@" "].firstObject;
            
            NSString *price = [NSString stringWithFormat:@"￥%@",order_price_string];
            NSString *totalPrice = [NSString stringWithFormat:@"￥%.2f",order_price_string.doubleValue * deal_quantity_string.doubleValue];

            _titleView.titleLabelL.text = @" ";
            _titleView.titleLabelR.text = NSLocalizedString(@"等待卖家放行", nil);
            
            _titleView.subTitleLabelL.text = NSLocalizedString(@"放行剩余时间", nil);
            _titleView.subTitleLabelR.text = @"14:59";
            
            NSArray *temp1 = @[
                @{@"leftTitle":NSLocalizedString(@"卖家联系方式", nil),@"isTitle":@(1),@"rightTitle":@"",@"isCopy":@(0),@"isBold":@(0)},
                @{@"leftTitle":NSLocalizedString(@"MGP账户", nil),@"isTitle":@(0),@"rightTitle":self.dicData[@"order_maker"],@"isCopy":@(1),@"isBold":@(0)},
                @{@"leftTitle":NSLocalizedString(@"邮箱", nil),@"isTitle":@(0),@"rightTitle":self.sellUserInfo[@"email"],@"isCopy":@(1),@"isBold":@(0)},
                @{@"leftTitle":NSLocalizedString(@"电话", nil),@"isTitle":@(0),@"rightTitle":self.sellUserInfo[@"order_maker"],@"isCopy":@(1),@"isBold":@(0)},
                @{@"leftTitle":NSLocalizedString(@"微信号", nil),@"isTitle":@(0),@"rightTitle":self.sellUserInfo[@"memo"],@"isCopy":@(1),@"isBold":@(0)},

            ];
            
            
            NSArray *temp2 = @[
                @{@"leftTitle":NSLocalizedString(@"交易明细", nil),@"isTitle":@(1),@"rightTitle":@"",@"isCopy":@(0),@"isBold":@(0)},
                @{@"leftTitle":NSLocalizedString(@"总价", nil),@"isTitle":@(0),@"rightTitle":totalPrice,@"isCopy":@(0),@"isBold":@(1)},
                @{@"leftTitle":NSLocalizedString(@"价格", nil),@"isTitle":@(0),@"rightTitle":price,@"isCopy":@(0),@"isBold":@(1)},
                @{@"leftTitle":NSLocalizedString(@"数量", nil),@"isTitle":@(0),@"rightTitle":self.dicData[@"deal_quantity"],@"isCopy":@(0),@"isBold":@(0)},
                @{@"leftTitle":NSLocalizedString(@"订单号", nil),@"isTitle":@(0),@"rightTitle":self.dicData[@"order_sn"],@"isCopy":@(1),@"isBold":@(0)},
            ];
            
            NSArray *temp3 = @[
                @{@"leftTitle":NSLocalizedString(@"如有疑问或与卖家发生纠纷，请联系客服", nil),@"isTitle":@(1),@"rightTitle":@"",@"isCopy":@(0),@"isBold":@(0)},
                @{@"leftTitle":NSLocalizedString(@"微信号", nil),@"isTitle":@(0),@"rightTitle":wechatName,@"isCopy":@(1),@"isBold":@(0)},
            ];
            [self.listArray addObject:@[]];
            [self.listArray addObject:temp1];
            [self.listArray addObject:temp2];
            [self.listArray addObject:temp3];

            
            
        }

            break;
        case OrderDetailType_TransactionSuccessful://交易成功
        {
            _titleView.titleLabelR.text = NSLocalizedString(@"交易成功", nil);
            _titleView.titleLabelL.text = @"";
            
            self.tableView.tableFooterView = [UIView new];
         
            NSString *order_price_string = [self.dicData[@"order_price"] componentsSeparatedByString:@" "].firstObject;
            NSString *price = [NSString stringWithFormat:@"￥%@",order_price_string];
            
            NSString *deal_quantity_string = [self.dicData[@"deal_quantity"] componentsSeparatedByString:@" "].firstObject;
            NSString *totalPrice = [NSString stringWithFormat:@"￥%.2f",order_price_string.doubleValue * deal_quantity_string.doubleValue];
            
            
            NSString *subTitle = [self.dicData[@"order_maker"]isEqualToString:[MGPHttpRequest shareManager].curretWallet.address] ? NSLocalizedString(@"您已成功出售", nil):NSLocalizedString(@"您已成功购买", nil);
            _titleView.subTitleLabelL.text = [NSString stringWithFormat:@"%@%@",subTitle,self.dicData[@"deal_quantity"]];
            _titleView.subTitleLabelR.text = @"";
            
            NSString *leftTitle = [self.dicData[@"order_maker"]isEqualToString:[MGPHttpRequest shareManager].curretWallet.address] ? NSLocalizedString(@"买家联系方式", nil):NSLocalizedString(@"卖家联系方式", nil);

            NSString *mgpName = [self.dicData[@"order_maker"]isEqualToString:[MGPHttpRequest shareManager].curretWallet.address] ? self.dicData[@"order_taker"]:self.dicData[@"order_maker"];

            
            NSArray *temp1 = @[
                @{@"leftTitle":leftTitle,@"isTitle":@(1),@"rightTitle":@"",@"isCopy":@(0),@"isBold":@(0)},
                @{@"leftTitle":NSLocalizedString(@"MGP账户", nil),@"isTitle":@(0),@"rightTitle":mgpName,@"isCopy":@(1),@"isBold":@(0)},
                @{@"leftTitle":NSLocalizedString(@"邮箱", nil),@"isTitle":@(0),@"rightTitle":self.sellUserInfo[@"email"],@"isCopy":@(1),@"isBold":@(0)},
                @{@"leftTitle":NSLocalizedString(@"电话", nil),@"isTitle":@(0),@"rightTitle":self.sellUserInfo[@"order_maker"],@"isCopy":@(1),@"isBold":@(0)},
                @{@"leftTitle":NSLocalizedString(@"微信号", nil),@"isTitle":@(0),@"rightTitle":self.sellUserInfo[@"memo"],@"isCopy":@(1),@"isBold":@(0)},

            ];
            
            

            NSArray *temp2 = @[
                @{@"leftTitle":NSLocalizedString(@"交易明细", nil),@"isTitle":@(1),@"rightTitle":@"",@"isCopy":@(0),@"isBold":@(0)},
                @{@"leftTitle":NSLocalizedString(@"总价", nil),@"isTitle":@(0),@"rightTitle":totalPrice,@"isCopy":@(0),@"isBold":@(1)},
                @{@"leftTitle":NSLocalizedString(@"价格", nil),@"isTitle":@(0),@"rightTitle":price,@"isCopy":@(0),@"isBold":@(1)},
                @{@"leftTitle":NSLocalizedString(@"数量", nil),@"isTitle":@(0),@"rightTitle":self.dicData[@"deal_quantity"],@"isCopy":@(0),@"isBold":@(0)},
                @{@"leftTitle":NSLocalizedString(@"订单号", nil),@"isTitle":@(0),@"rightTitle":self.dicData[@"order_sn"],@"isCopy":@(0),@"isBold":@(0)},
                @{@"leftTitle":NSLocalizedString(@"付款方式", nil),@"isTitle":@(0),@"rightTitle":@"银行卡",@"isCopy":@(0),@"isBold":@(0)},
            ];
            
            NSArray *temp3 = @[
                @{@"leftTitle":NSLocalizedString(@"如有疑问或与卖家发生纠纷，请联系客服", nil),@"isTitle":@(1),@"rightTitle":@"",@"isCopy":@(0),@"isBold":@(0)},
                @{@"leftTitle":NSLocalizedString(@"微信号", nil),@"isTitle":@(0),@"rightTitle":wechatName,@"isCopy":@(1),@"isBold":@(0)},
            ];
            [self.listArray addObject:temp2];
            [self.listArray addObject:temp1];
            [self.listArray addObject:temp3];

            
            
        }
            break;
        case OrderDetailType_TransactionCancel://交易取消
            {
                
                _titleView.titleLabelR.text = NSLocalizedString(@"交易取消", nil);
            

                self.tableView.tableFooterView = [UIView new];
             
                NSString *order_price_string = [self.dicData[@"order_price"] componentsSeparatedByString:@" "].firstObject;
                NSString *price = [NSString stringWithFormat:@"￥%@",order_price_string];

                
                NSString *deal_quantity_string = [self.dicData[@"deal_quantity"] componentsSeparatedByString:@" "].firstObject;
                NSString *totalPrice = [NSString stringWithFormat:@"￥%.2f",order_price_string.doubleValue * deal_quantity_string.doubleValue];
                
                NSArray *temp1 = @[
                    @{@"leftTitle":NSLocalizedString(@"交易明细", nil),@"isTitle":@(1),@"rightTitle":@"",@"isCopy":@(0),@"isBold":@(0)},
                    @{@"leftTitle":NSLocalizedString(@"总价", nil),@"isTitle":@(0),@"rightTitle":totalPrice,@"isCopy":@(0),@"isBold":@(1)},
                    @{@"leftTitle":NSLocalizedString(@"价格", nil),@"isTitle":@(0),@"rightTitle":price,@"isCopy":@(0),@"isBold":@(1)},
                    @{@"leftTitle":NSLocalizedString(@"数量", nil),@"isTitle":@(0),@"rightTitle":self.dicData[@"deal_quantity"],@"isCopy":@(0),@"isBold":@(0)},
                    
                ];
                
                NSArray *temp2 = @[
                    @{@"leftTitle":NSLocalizedString(@"如有疑问或与卖家发生纠纷，请联系客服", nil),@"isTitle":@(1),@"rightTitle":@"",@"isCopy":@(0),@"isBold":@(0)},
                    @{@"leftTitle":NSLocalizedString(@"微信号", nil),@"isTitle":@(0),@"rightTitle":wechatName,@"isCopy":@(1),@"isBold":@(0)},
                ];
                [self.listArray addObject:temp1];
                [self.listArray addObject:temp2];

                
                
            }
            
            break;
        case OrderDetailType_OnCommissionSale://委托出售中
            {
                
                _titleView.titleLabelR.text = NSLocalizedString(@"委托出售中", nil);
                _titleView.subTitleLabelL.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"您已委托出售", nil),self.dicData[@"quantity"]];
                
                NSString *pricestring = [self.dicData[@"price"] componentsSeparatedByString:@" "].firstObject;
                NSString *price = [NSString stringWithFormat:@"￥%@",pricestring];

                NSArray *temp1 = @[
                    @{@"leftTitle":NSLocalizedString(@"交易明细", nil),@"isTitle":@(1),@"rightTitle":@"",@"isCopy":@(0),@"isBold":@(0)},
                    @{@"leftTitle":NSLocalizedString(@"价格", nil),@"isTitle":@(0),@"rightTitle":price,@"isCopy":@(0),@"isBold":@(1)},
                    @{@"leftTitle":NSLocalizedString(@"数量", nil),@"isTitle":@(0),@"rightTitle":self.dicData[@"quantity"],@"isCopy":@(0),@"isBold":@(0)},
                    @{@"leftTitle":NSLocalizedString(@"交易哈希", nil),@"isTitle":@(0),@"rightTitle":@"0x000000000",@"isCopy":@(1),@"isBold":@(0)},
                ];
                NSArray *temp2 = @[
                    @{@"leftTitle":NSLocalizedString(@"已成功出售", nil),@"isTitle":@(0),@"rightTitle":self.dicData[@"fulfilled_quantity"],@"isCopy":@(0),@"isBold":@(0)},
                    @{@"leftTitle":NSLocalizedString(@"已冻结", nil),@"isTitle":@(0),@"rightTitle":self.dicData[@"frozen_quantity"],@"isCopy":@(0),@"isBold":@(0)},
                ];
                [self.listArray addObject:temp1];
                [self.listArray addObject:temp2];

            }
            break;
        case OrderDetailType_Revoke://撤销
            {
                _titleView.titleLabelR.text = NSLocalizedString(@"已撤销", nil);
                _titleView.subTitleLabelL.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"您已委托出售", nil),self.dicData[@"quantity"]];
                self.tableView.tableFooterView = [UIView new];
                NSString *pricestring = [self.dicData[@"price"] componentsSeparatedByString:@" "].firstObject;
                NSString *price = [NSString stringWithFormat:@"￥%@",pricestring];

                NSArray *temp1 = @[
                    @{@"leftTitle":NSLocalizedString(@"交易明细", nil),@"isTitle":@(1),@"rightTitle":@"",@"isCopy":@(0),@"isBold":@(0)},
                    @{@"leftTitle":NSLocalizedString(@"价格", nil),@"isTitle":@(0),@"rightTitle":price,@"isCopy":@(0),@"isBold":@(1)},
                    @{@"leftTitle":NSLocalizedString(@"数量", nil),@"isTitle":@(0),@"rightTitle":self.dicData[@"quantity"],@"isCopy":@(0),@"isBold":@(0)},
                    @{@"leftTitle":NSLocalizedString(@"交易哈希", nil),@"isTitle":@(0),@"rightTitle":@"0x000000000",@"isCopy":@(1),@"isBold":@(0)},
                ];
                NSArray *temp2 = @[
                    @{@"leftTitle":NSLocalizedString(@"已成功出售", nil),@"isTitle":@(0),@"rightTitle":self.dicData[@"fulfilled_quantity"],@"isCopy":@(0),@"isBold":@(0)},
                    @{@"leftTitle":NSLocalizedString(@"已冻结", nil),@"isTitle":@(0),@"rightTitle":self.dicData[@"frozen_quantity"],@"isCopy":@(0),@"isBold":@(0)},
                ];
                [self.listArray addObject:temp1];
                [self.listArray addObject:temp2];

            }
            break;
        case OrderDetailType_Completed://已完成
            {
                
                _titleView.titleLabelR.text = NSLocalizedString(@"已完成", nil);
                _titleView.subTitleLabelL.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"您已委托出售", nil),self.dicData[@"quantity"]];
                
                self.tableView.tableFooterView = [UIView new];
                NSString *pricestring = [self.dicData[@"price"] componentsSeparatedByString:@" "].firstObject;
                NSString *price = [NSString stringWithFormat:@"￥%@",pricestring];

                NSArray *temp1 = @[
                    @{@"leftTitle":NSLocalizedString(@"交易明细", nil),@"isTitle":@(1),@"rightTitle":@"",@"isCopy":@(0),@"isBold":@(0)},
                    @{@"leftTitle":NSLocalizedString(@"价格", nil),@"isTitle":@(0),@"rightTitle":price,@"isCopy":@(0),@"isBold":@(1)},
                    @{@"leftTitle":NSLocalizedString(@"数量", nil),@"isTitle":@(0),@"rightTitle":self.dicData[@"quantity"],@"isCopy":@(0),@"isBold":@(0)},
                    @{@"leftTitle":NSLocalizedString(@"交易哈希", nil),@"isTitle":@(0),@"rightTitle":@"0x000000000",@"isCopy":@(1),@"isBold":@(0)},
                ];
                NSArray *temp2 = @[
                    @{@"leftTitle":NSLocalizedString(@"已成功出售", nil),@"isTitle":@(0),@"rightTitle":self.dicData[@"fulfilled_quantity"],@"isCopy":@(0),@"isBold":@(0)},
                    @{@"leftTitle":NSLocalizedString(@"已冻结", nil),@"isTitle":@(0),@"rightTitle":self.dicData[@"frozen_quantity"],@"isCopy":@(0),@"isBold":@(0)},
                ];
                [self.listArray addObject:temp1];
                [self.listArray addObject:temp2];

            }
            break;

        case OrderDetailType_BuyerPayment://待买家付款
        {
            
            self.tableView.tableFooterView = [UIView new];
      
            NSString *order_price_string = [self.dicData[@"order_price"] componentsSeparatedByString:@" "].firstObject;
            NSString *deal_quantity_string = [self.dicData[@"deal_quantity"] componentsSeparatedByString:@" "].firstObject;
            
            NSString *price = [NSString stringWithFormat:@"￥%@",order_price_string];
            NSString *totalPrice = [NSString stringWithFormat:@"￥%.2f",order_price_string.doubleValue * deal_quantity_string.doubleValue];

            _titleView.titleLabelL.text = NSLocalizedString(@"待买家付款", nil);
            _titleView.titleLabelR.text = totalPrice;
            
            _titleView.subTitleLabelL.text = NSLocalizedString(@"付款剩余时间", nil);
            _titleView.subTitleLabelR.text = @"14:59";
            
            NSArray *temp1 = @[
                @{@"leftTitle":NSLocalizedString(@"买家联系方式", nil),@"isTitle":@(1),@"rightTitle":@"",@"isCopy":@(0),@"isBold":@(0)},
                @{@"leftTitle":NSLocalizedString(@"MGP账户", nil),@"isTitle":@(0),@"rightTitle":self.dicData[@"order_taker"],@"isCopy":@(1),@"isBold":@(0)},
                @{@"leftTitle":NSLocalizedString(@"邮箱", nil),@"isTitle":@(0),@"rightTitle":self.sellUserInfo[@"email"],@"isCopy":@(1),@"isBold":@(0)},
                @{@"leftTitle":NSLocalizedString(@"电话", nil),@"isTitle":@(0),@"rightTitle":self.sellUserInfo[@"order_maker"],@"isCopy":@(1),@"isBold":@(0)},
                @{@"leftTitle":NSLocalizedString(@"微信号", nil),@"isTitle":@(0),@"rightTitle":self.sellUserInfo[@"memo"],@"isCopy":@(1),@"isBold":@(0)},

            ];
            
            
            NSArray *temp2 = @[
                @{@"leftTitle":NSLocalizedString(@"交易明细", nil),@"isTitle":@(1),@"rightTitle":@"",@"isCopy":@(0),@"isBold":@(0)},
                @{@"leftTitle":NSLocalizedString(@"总价", nil),@"isTitle":@(0),@"rightTitle":totalPrice,@"isCopy":@(0),@"isBold":@(1)},
                @{@"leftTitle":NSLocalizedString(@"价格", nil),@"isTitle":@(0),@"rightTitle":price,@"isCopy":@(0),@"isBold":@(1)},
                @{@"leftTitle":NSLocalizedString(@"数量", nil),@"isTitle":@(0),@"rightTitle":self.dicData[@"deal_quantity"],@"isCopy":@(0),@"isBold":@(0)},
                @{@"leftTitle":NSLocalizedString(@"订单号", nil),@"isTitle":@(0),@"rightTitle":self.dicData[@"order_sn"],@"isCopy":@(1),@"isBold":@(0)},
            ];
            
            NSArray *temp3 = @[
                @{@"leftTitle":NSLocalizedString(@"如有疑问或与卖家发生纠纷，请联系客服", nil),@"isTitle":@(1),@"rightTitle":@"",@"isCopy":@(0),@"isBold":@(0)},
                @{@"leftTitle":NSLocalizedString(@"微信号", nil),@"isTitle":@(0),@"rightTitle":wechatName,@"isCopy":@(1),@"isBold":@(0)},
            ];
            [self.listArray addObject:temp1];
            [self.listArray addObject:temp2];
            [self.listArray addObject:temp3];

            
            
        }

            break;
        case OrderDetailType_BuyerPaid://买家已付款
        {
            
            self.tableView.tableFooterView = [UIView new];
            self.bottomHeight.constant = 60;
            [self.leftButton setTitle:NSLocalizedString(@"申请仲裁", nil) forState:UIControlStateNormal];
            [self.rightButton setTitle:NSLocalizedString(@"已确认收款", nil) forState:UIControlStateNormal];
            
            
            NSString *order_price_string = [self.dicData[@"order_price"] componentsSeparatedByString:@" "].firstObject;
            NSString *deal_quantity_string = [self.dicData[@"deal_quantity"] componentsSeparatedByString:@" "].firstObject;
            
            NSString *price = [NSString stringWithFormat:@"￥%@",order_price_string];
            NSString *totalPrice = [NSString stringWithFormat:@"￥%.2f",order_price_string.doubleValue * deal_quantity_string.doubleValue];

            _titleView.titleLabelL.text = NSLocalizedString(@"买家已付款", nil);
            _titleView.titleLabelR.text = totalPrice;
            
            _titleView.subTitleLabelL.text = NSLocalizedString(@"确认付款剩余时间", nil);
            _titleView.subTitleLabelR.text = @"14:59";
            
            NSArray *temp1 = @[
                @{@"leftTitle":NSLocalizedString(@"买家联系方式", nil),@"isTitle":@(1),@"rightTitle":@"",@"isCopy":@(0),@"isBold":@(0)},
                @{@"leftTitle":NSLocalizedString(@"MGP账户", nil),@"isTitle":@(0),@"rightTitle":self.dicData[@"order_taker"],@"isCopy":@(1),@"isBold":@(0)},
                @{@"leftTitle":NSLocalizedString(@"邮箱", nil),@"isTitle":@(0),@"rightTitle":self.sellUserInfo[@"email"],@"isCopy":@(1),@"isBold":@(0)},
                @{@"leftTitle":NSLocalizedString(@"电话", nil),@"isTitle":@(0),@"rightTitle":self.sellUserInfo[@"order_maker"],@"isCopy":@(1),@"isBold":@(0)},
                @{@"leftTitle":NSLocalizedString(@"微信号", nil),@"isTitle":@(0),@"rightTitle":self.sellUserInfo[@"memo"],@"isCopy":@(1),@"isBold":@(0)},

            ];
            
            
            NSArray *temp2 = @[
                @{@"leftTitle":NSLocalizedString(@"交易明细", nil),@"isTitle":@(1),@"rightTitle":@"",@"isCopy":@(0),@"isBold":@(0)},
                @{@"leftTitle":NSLocalizedString(@"总价", nil),@"isTitle":@(0),@"rightTitle":totalPrice,@"isCopy":@(0),@"isBold":@(1)},
                @{@"leftTitle":NSLocalizedString(@"价格", nil),@"isTitle":@(0),@"rightTitle":price,@"isCopy":@(0),@"isBold":@(1)},
                @{@"leftTitle":NSLocalizedString(@"数量", nil),@"isTitle":@(0),@"rightTitle":self.dicData[@"deal_quantity"],@"isCopy":@(0),@"isBold":@(0)},
                @{@"leftTitle":NSLocalizedString(@"订单号", nil),@"isTitle":@(0),@"rightTitle":self.dicData[@"order_sn"],@"isCopy":@(1),@"isBold":@(0)},
            ];
            
            NSArray *temp3 = @[
                @{@"leftTitle":NSLocalizedString(@"如有疑问或与卖家发生纠纷，请联系客服", nil),@"isTitle":@(1),@"rightTitle":@"",@"isCopy":@(0),@"isBold":@(0)},
                @{@"leftTitle":NSLocalizedString(@"微信号", nil),@"isTitle":@(0),@"rightTitle":wechatName,@"isCopy":@(1),@"isBold":@(0)},
            ];
            [self.listArray addObject:temp1];
            [self.listArray addObject:temp2];
            [self.listArray addObject:temp3];

            
            
        }
            break;
        default:
            break;
    }
    

    [self.tableView.mj_header endRefreshing];
    [self.tableView reloadData];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return self.listArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    NSArray *temp = self.listArray[section];
    
    return section == 0 && (self.orderDetailType == OrderDetailType_PaymentSeller || self.orderDetailType == OrderDetailType_WaitingSellerPass) ? 1 : temp.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && (self.orderDetailType == OrderDetailType_PaymentSeller || self.orderDetailType == OrderDetailType_WaitingSellerPass)) {
        if ([self.sellPayInfo[@"payId"]intValue] == 1) {
            OverTheCounterOrderDetail0TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OverTheCounterOrderDetail0TableViewCellIndex" forIndexPath:indexPath];
            cell.dicData = self.sellPayInfo;
            return cell;

        }else{
            OverTheCounterOrderDetail1TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OverTheCounterOrderDetail1TableViewCellIndex" forIndexPath:indexPath];
            cell.dicData = self.sellPayInfo;
            return cell;
        }

    }else{
        OverTheCounterOrderDetail2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OverTheCounterOrderDetail2TableViewCellIndex" forIndexPath:indexPath];
        NSDictionary *dic = self.listArray[indexPath.section][indexPath.row];

        cell.leftLabel.text = dic[@"leftTitle"];
        cell.rightLabel.text = dic[@"rightTitle"];
        cell.imageWidth.constant = [dic[@"isCopy"]boolValue] ? 18 : 0;
        [dic[@"isTitle"]boolValue] ? [cell.leftLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]] : [cell.leftLabel setFont:[UIFont fontWithName:@"Helvetica" size:15]];
        
        cell.rightLabel.textColor = [dic[@"isBold"]boolValue] ? [UIColor orangeColor] : [UIColor blackColor];
        
        
        return cell;

    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = self.listArray[indexPath.section][indexPath.row];
    if ([dic[@"isCopy"]boolValue]) {
        [self.view showMsg:[NSString stringWithFormat:@"%@%@",dic[@"leftTitle"],NSLocalizedString(@"已复制", nil)]];
        [UIPasteboard generalPasteboard].string = dic[@"rightTitle"];
        
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && (self.orderDetailType == OrderDetailType_PaymentSeller || self.orderDetailType == OrderDetailType_WaitingSellerPass)) {
        return 280;
    }
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

- (IBAction)footerClick:(id)sender {
    if (self.orderDetailType == OrderDetailType_OnCommissionSale) {
        
        NSString *frozen_quantity_str = [self.dicData[@"frozen_quantity"] componentsSeparatedByString:@" "].firstObject;
        if ([frozen_quantity_str doubleValue] <= 0) {
            WEAKSELF;

            NSString *quantity_str = [self.dicData[@"quantity"] componentsSeparatedByString:@" "].firstObject;
            NSString *fufilled_quantity_str = [self.dicData[@"fulfilled_quantity"] componentsSeparatedByString:@" "].firstObject;
            
            NSString *noticeText = [NSString stringWithFormat:@"%@%.4f MGP",NSLocalizedString(@"撤销委托订单后，将自动从合约赎回", nil),([quantity_str doubleValue] - [fufilled_quantity_str doubleValue])];
            
            NSDictionary *attrs = @{XFDialogNoticeText:noticeText, XFDialogCancelButtonTitle: NSLocalizedString(@"取消", nil), XFDialogCommitButtonTitle: NSLocalizedString(@"确认", nil),XFDialogTitleViewBackgroundColor:[UIColor orangeColor]};
            
            self.dialogView = [[[XFDialogNotice dialogWithTitle:NSLocalizedString(@"撤销委托", nil) attrs:attrs commitCallBack:^(NSString *inputText) {
                            
                [weakSelf.dialogView hideWithAnimationBlock:nil];
                NSString *mgp_otcstore = [[DomainConfigManager share]getCurrentEvnDict][otcstore];
                NSDictionary *p = @{@"owner":self.dicData[@"owner"],@"order_id":self.dicData[@"id"]};
                [[DCMGPWalletTool shareManager]contractCode:mgp_otcstore andAction:@"closeorder" andParameters:p andPassWord:VALIDATE_STRING([[NSUserDefaults standardUserDefaults]objectForKey:PassWordText]) completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
                    if (responseObj) {

                        [self.view showMsg:NSLocalizedString(@"撤销成功", nil)];
                        self.orderDetailType = OrderDetailType_Revoke;
                        [self.tableView.mj_header beginRefreshing];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                            [self.navigationController popViewControllerAnimated:YES];
                            
                        });
                        
                    }
                }];
                
                
            }] showWithAnimationBlock:nil]setCancelCallBack:nil];
            
            
            
        }else{
            [self.view showMsg:NSLocalizedString(@"您还有冻结金额，无法进行撤销操作", nil)];
        }

    }
}
- (IBAction)leftClick:(id)sender {

    if (self.orderDetailType == OrderDetailType_PaymentSeller) {
        
        WEAKSELF; //
        NSDictionary *attrs = @{XFDialogNoticeText:NSLocalizedString(@"如果您已经向卖家付款，请不要取消交易", nil), XFDialogCancelButtonTitle: NSLocalizedString(@"我再想想", nil), XFDialogCommitButtonTitle: NSLocalizedString(@"确认", nil),XFDialogTitleViewBackgroundColor:[UIColor orangeColor]};
        
        self.dialogView = [[[XFDialogNotice dialogWithTitle:NSLocalizedString(@"确认取消交易", nil) attrs:attrs commitCallBack:^(NSString *inputText) {
                        
            [weakSelf.dialogView hideWithAnimationBlock:nil];
            NSDictionary *p = @{@"taker":self.dicData[@"order_taker"],@"deal_id":self.dicData[@"id"]};
            [[DCMGPWalletTool shareManager]contractCode:mgp_otcstore andAction:@"closedeal" andParameters:p andPassWord:VALIDATE_STRING([[NSUserDefaults standardUserDefaults]objectForKey:PassWordText]) completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
                if (responseObj) {
                    self.orderDetailType = OrderDetailType_TransactionCancel;
                    [self.tableView.mj_header beginRefreshing];
                    
                }
            }];
            
            
        }] showWithAnimationBlock:nil]setCancelCallBack:nil];
        
    }else if(self.orderDetailType == OrderDetailType_BuyerPaid){
        [self.view showMsg:NSLocalizedString(@"请添加客服微信号，联系客服", nil)];
    }
    
}
- (IBAction)rightClick:(id)sender {
    if (self.orderDetailType == OrderDetailType_PaymentSeller) {
        NSDictionary *p = @{@"owner":self.dicData[@"order_taker"],@"deal_id":self.dicData[@"id"],@"pass":@"1",@"user_type":@"1"};
        [[DCMGPWalletTool shareManager]contractCode:mgp_otcstore andAction:@"passdeal" andParameters:p andPassWord:VALIDATE_STRING([[NSUserDefaults standardUserDefaults]objectForKey:PassWordText]) completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
            if (responseObj) {
                self.orderDetailType = OrderDetailType_WaitingSellerPass;
                [self.tableView.mj_header beginRefreshing];
                
            }
        }];
        
    }else if(self.orderDetailType == OrderDetailType_BuyerPaid){
        WEAKSELF; //
        NSDictionary *attrs = @{XFDialogNoticeText:NSLocalizedString(@"如果您未收款或者收到金额不得，请联系客服处理", nil), XFDialogCancelButtonTitle: NSLocalizedString(@"取消", nil), XFDialogCommitButtonTitle: NSLocalizedString(@"确认", nil),XFDialogTitleViewBackgroundColor:[UIColor orangeColor]};
        
        self.dialogView = [[[XFDialogNotice dialogWithTitle:NSLocalizedString(@"确认收款", nil) attrs:attrs commitCallBack:^(NSString *inputText) {
                        
            [weakSelf.dialogView hideWithAnimationBlock:nil];
            NSDictionary *p = @{@"owner":self.dicData[@"order_maker"],@"deal_id":self.dicData[@"id"],@"pass":@"1",@"user_type":@"0"};
            [[DCMGPWalletTool shareManager]contractCode:mgp_otcstore andAction:@"passdeal" andParameters:p andPassWord:VALIDATE_STRING([[NSUserDefaults standardUserDefaults]objectForKey:PassWordText]) completionHandler:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
                if (responseObj) {
                    self.orderDetailType = OrderDetailType_TransactionSuccessful;
                    [self.tableView.mj_header beginRefreshing];
                    
                }
            }];
            
            
            
            
        }] showWithAnimationBlock:nil]setCancelCallBack:nil];
    }
}


- (void)setupGCDTime:(NSInteger)secondsCountDown {

    __block NSInteger bottomCount = secondsCountDown;
    
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
        }else {
            bottomCount -= 1;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSString *str_minute = [NSString stringWithFormat:@"%02ld",(secondsCountDown%3600)/60];
                NSString *str_second = [NSString stringWithFormat:@"%02ld",secondsCountDown%60];
                NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
                weakSelf.titleView.subTitleLabelR.text = format_time;

            });
        }
    });
    
    dispatch_resume(timer);
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
