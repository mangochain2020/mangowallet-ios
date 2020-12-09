

//
//  DCCenterBeaShopCell.m
//  CDDStoreDemo
//
//  Created by 陈甸甸 on 2017/12/13.
//Copyright © 2017年 RocketsChen. All rights reserved.
//

#import "DCCenterBeaShopCell.h"

// Controllers

// Models

// Views

// Vendors

// Categories

// Others

@interface DCCenterBeaShopCell ()

@property (weak, nonatomic) IBOutlet UIView *bottomView;



@property (weak, nonatomic) IBOutlet UILabel *orderIncome;
@property (weak, nonatomic) IBOutlet UILabel *orderIncomeTitle;

@property (weak, nonatomic) IBOutlet UILabel *orderNum;
@property (weak, nonatomic) IBOutlet UILabel *orderNumTitle;

@property (weak, nonatomic) IBOutlet UILabel *proNum;
@property (weak, nonatomic) IBOutlet UILabel *proNumTitle;

@property (weak, nonatomic) IBOutlet UILabel *totalMoney;
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyTitle;

@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;

@end

@implementation DCCenterBeaShopCell

#pragma mark - Intial
- (void)awakeFromNib {
    [super awakeFromNib];

    _bottomView.backgroundColor = DCBGColor;
    
    [DCSpeedy dc_chageControlCircularWith:_controlButton AndSetCornerRadius:15 SetBorderWidth:1 SetBorderColor:RGB(227, 107, 97) canMasksToBounds:YES];
}

#pragma mark - Setter Getter Methods

- (void)layoutSubviews{
    [super layoutSubviews];
    
    

    if (self.isShop) {
        self.orderIncomeTitle.text = NSLocalizedString(@"商家比例", nil);
        self.orderNumTitle.text = NSLocalizedString(@"买家比例", nil);
        self.proNumTitle.text = NSLocalizedString(@"奖励比例", nil);
        self.totalMoneyTitle.text = NSLocalizedString(@"商铺状态", nil);
        [self.controlButton setTitle:NSLocalizedString(@"我的MGP店铺", nil) forState:UIControlStateNormal];
        
        NSString *tempStr = @"";
        switch (self.myCenterModel.shop.status) {
            case 0:
                tempStr = NSLocalizedString(@"未开通", nil);
                break;
            
            case 1:
                tempStr = NSLocalizedString(@"运营中", nil);
                break;
                
            case 2:
                tempStr = NSLocalizedString(@"待审核", nil);
                break;
            
            case 3:
                tempStr = NSLocalizedString(@"审核失败", nil);
                break;
            default:
                break;
        }
        self.orderIncome.text = [NSString stringWithFormat:@"%.f%%",self.myCenterModel.shop.storePro*100.0];
        self.orderNum.text = [NSString stringWithFormat:@"%.f%%",self.myCenterModel.shop.buyerPro*100.0];
        self.proNum.text = [NSString stringWithFormat:@"%.f%%",self.myCenterModel.shop.rewardPro*100.0];
        self.totalMoney.text = tempStr;
        [self.userImage sd_setImageWithURL:[NSURL URLWithString:self.myCenterModel.shop.imgs.firstObject] placeholderImage:[UIImage imageNamed:@"icon"]];
        self.userName.text = self.myCenterModel.shop ? self.myCenterModel.shop.name : [MGPHttpRequest shareManager].curretWallet.address;

        self.unitLabel.text = @"";
        self.controlButton.hidden = NO;

    }else{
        self.orderIncomeTitle.text = self.myCenterModel.top.isBindUsdt == 0 ? NSLocalizedString(@"申请开通", nil) : NSLocalizedString(@"订单总价值", nil);
        switch (self.myCenterModel.top.isBindUsdt) {
            case 0:
                self.orderIncomeTitle.text = NSLocalizedString(@"申请开通", nil);
                break;
            case 1:
                self.orderIncomeTitle.text = NSLocalizedString(@"订单总价值", nil);
                break;
            case 2:
                self.orderIncomeTitle.text = NSLocalizedString(@"注销中", nil);
                break;
                
            default:
                break;
        }
        self.orderNumTitle.text = NSLocalizedString(@"卖家订单中心", nil);
        self.proNumTitle.text = NSLocalizedString(@"商品管理", nil);
        self.totalMoneyTitle.text = NSLocalizedString(@"余额", nil);
        
        self.orderIncome.text = [NSString stringWithFormat:@"%ld",self.myCenterModel.top.orderIncome];
        self.orderNum.text = [NSString stringWithFormat:@"%ld",self.myCenterModel.top.orderNum];
        self.proNum.text = [NSString stringWithFormat:@"%ld",self.myCenterModel.top.proNum];
        self.totalMoney.text = [NSString stringWithFormat:@"%ld",self.myCenterModel.top.totalMoney];
        self.userName.text = [MGPHttpRequest shareManager].curretWallet.address;
        self.unitLabel.text = @"MGP";
        self.controlButton.hidden = YES;

    }
    
    
}


@end
