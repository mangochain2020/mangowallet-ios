//
//  OverTheCounterOrderDetail0TableViewCell.m
//  TaiYiToken
//
//  Created by mac on 2021/1/6.
//  Copyright © 2021 admin. All rights reserved.
//

#import "OverTheCounterOrderDetail0TableViewCell.h"
@interface OverTheCounterOrderDetail0TableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *titleImage;
;
@property (weak, nonatomic) IBOutlet UILabel *userNameL;
@property (weak, nonatomic) IBOutlet UILabel *userNameR;

@property (weak, nonatomic) IBOutlet UILabel *cardNumL;
@property (weak, nonatomic) IBOutlet UILabel *cardNumR;

@property (weak, nonatomic) IBOutlet UILabel *bankNameL;
@property (weak, nonatomic) IBOutlet UILabel *bankNameR;

@property (weak, nonatomic) IBOutlet UILabel *branchL;
@property (weak, nonatomic) IBOutlet UILabel *branchR;

@property (weak, nonatomic) IBOutlet UILabel *destLabel;




@end

@implementation OverTheCounterOrderDetail0TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)copyClick:(UIButton *)sender {
    //2021010801-2021010804
    switch (sender.tag) {
        case 2021010801:
            [UIPasteboard generalPasteboard].string = _userNameR.text;
            [[[MGPHttpRequest shareManager]jsd_findVisibleViewController].view showMsg:[NSString stringWithFormat:@"%@%@",_userNameL.text,NSLocalizedString(@"已复制", nil)]];

            break;
        case 2021010802:
            [UIPasteboard generalPasteboard].string = _cardNumR.text;
            [[[MGPHttpRequest shareManager]jsd_findVisibleViewController].view showMsg:[NSString stringWithFormat:@"%@%@",_cardNumL.text,NSLocalizedString(@"已复制", nil)]];

            break;
        case 2021010803:
            [UIPasteboard generalPasteboard].string = _bankNameR.text;
            [[[MGPHttpRequest shareManager]jsd_findVisibleViewController].view showMsg:[NSString stringWithFormat:@"%@%@",_bankNameL.text,NSLocalizedString(@"已复制", nil)]];

            break;
        case 2021010804:
            [UIPasteboard generalPasteboard].string = _branchR.text;
            [[[MGPHttpRequest shareManager]jsd_findVisibleViewController].view showMsg:[NSString stringWithFormat:@"%@%@",_branchL.text,NSLocalizedString(@"已复制", nil)]];

            break;
            
        default:
            break;
    }

}
- (void)layoutSubviews{
    [super layoutSubviews];
    _titleLabel.text = NSLocalizedString(@"银行卡", nil);
    _userNameL.text = NSLocalizedString(@"姓名", nil);
    _cardNumL.text = NSLocalizedString(@"银行卡号", nil);
    _bankNameL.text = NSLocalizedString(@"银行名称", nil);
    _branchL.text = NSLocalizedString(@"开户卡号", nil);
    _destLabel.text = NSLocalizedString(@"转账时，请使用您本人的交易方式，向对方转账，请勿备注，防止汇款被拦截，付款账户被冻结等问题", nil);

    _userNameR.text = self.dicData[@"username"];
    _cardNumR.text = self.dicData[@"cardNum"];
    _bankNameR.text = self.dicData[@"name"];
    _branchR.text = self.dicData[@"branch"];

    
    
}

@end
