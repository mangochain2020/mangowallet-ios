//
//  OverTheCounterOrderDetail1TableViewCell.m
//  TaiYiToken
//
//  Created by mac on 2020/12/30.
//  Copyright © 2020 admin. All rights reserved.
//

#import "OverTheCounterOrderDetail1TableViewCell.h"
#import "CollectionCodeView.h"

@interface OverTheCounterOrderDetail1TableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *titleImage;
;
@property (weak, nonatomic) IBOutlet UILabel *userNameL;
@property (weak, nonatomic) IBOutlet UILabel *userNameR;

@property (weak, nonatomic) IBOutlet UILabel *cardNumL;
@property (weak, nonatomic) IBOutlet UILabel *cardNumR;

@property (weak, nonatomic) IBOutlet UIButton *thumbnailL;
@property (weak, nonatomic) IBOutlet UIButton *thumbnailR;


@property (weak, nonatomic) IBOutlet UILabel *destLabel;




@end

@implementation OverTheCounterOrderDetail1TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)copyClick:(UIButton *)sender {
    //2021010805-2021010806
    switch (sender.tag) {
        case 2021010805:
            [UIPasteboard generalPasteboard].string = _userNameR.text;
            [[[MGPHttpRequest shareManager]jsd_findVisibleViewController].view showMsg:[NSString stringWithFormat:@"%@%@",_userNameL.text,NSLocalizedString(@"已复制", nil)]];

            break;
        case 2021010806:
            [UIPasteboard generalPasteboard].string = _cardNumR.text;
            [[[MGPHttpRequest shareManager]jsd_findVisibleViewController].view showMsg:[NSString stringWithFormat:@"%@%@",_cardNumL.text,NSLocalizedString(@"已复制", nil)]];

            break;
            
        default:
            break;
    }
}
- (IBAction)thumbnailClick:(id)sender {

    NSString *payType = self.dicData[@"qrCode"];
    CollectionCodeView *mallstoreADView = [CollectionCodeView dc_viewFromXib];
    [mallstoreADView.imageView sd_setImageWithURL:[NSURL URLWithString:payType]];
    [mallstoreADView popADWithAnimated:YES];
    
   
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [_thumbnailR setTitle:NSLocalizedString(@"点击查看大图", nil) forState:UIControlStateNormal];
    
    _titleLabel.text = [self.dicData[@"payId"]intValue] == 2 ? NSLocalizedString(@"微信支付", nil) : NSLocalizedString(@"支付宝", nil);
    _titleImage.image = [self.dicData[@"payId"]intValue] == 2 ? [UIImage imageNamed:@"wx_"] : [UIImage imageNamed:@"zfb_"];
    
    
    _userNameL.text = NSLocalizedString(@"姓名", nil);
    
    _cardNumL.text = [self.dicData[@"payId"]intValue] == 2 ? NSLocalizedString(@"微信账号", nil) : NSLocalizedString(@"支付宝账号", nil);

    
    _destLabel.text = NSLocalizedString(@"转账时，请使用您本人的交易方式，向对方转账，请勿备注，防止汇款被拦截，付款账户被冻结等问题", nil);

    _userNameR.text = self.dicData[@"username"];
    _cardNumR.text = self.dicData[@"cardNum"];
    

    
    
}

@end
