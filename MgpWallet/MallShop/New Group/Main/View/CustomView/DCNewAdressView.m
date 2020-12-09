

//
//  DCNewAdressView.m
//  CDDStoreDemo
//
//  Created by 陈甸甸 on 2017/12/19.
//Copyright © 2017年 RocketsChen. All rights reserved.
//

#import "DCNewAdressView.h"

// Controllers

// Models

// Views
#import "DCPlaceholderTextView.h"
// Vendors

// Categories

// Others

@interface DCNewAdressView ()

@property (weak, nonatomic) IBOutlet UILabel *rePersonLabel;

@property (weak, nonatomic) IBOutlet UILabel *rePhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIButton *button;


@property (weak, nonatomic) IBOutlet UILabel *countryLabel;
@property (weak, nonatomic) IBOutlet UIButton *countryButton;


@end

@implementation DCNewAdressView

#pragma mark - Intial
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.rePersonField.placeholder = NSLocalizedString(@"姓名", nil);
    self.rePhoneField.placeholder = NSLocalizedString(@"联系方式", nil);
    [self.button setTitle:NSLocalizedString(@"请选择", nil) forState:UIControlStateNormal];
    self.rePersonLabel.text = NSLocalizedString(@"收货人", nil);
    self.rePhoneLabel.text = NSLocalizedString(@"手机号码", nil);
    self.address.text = NSLocalizedString(@"选择地区", nil);
    self.detailLabel.text = NSLocalizedString(@"详细地址", nil);
    self.countryLabel.text = NSLocalizedString(@"国家地区", nil);
    self.address.text = NSLocalizedString(@"选择地区", nil);
    [self.countryButton setTitle:NSLocalizedString(@"请选择", nil) forState:UIControlStateNormal];

    
    
    [self setUpBase];
}

- (void)setUpBase
{
    
}

- (IBAction)countryClick:(id)sender {
    !_countryBlock ? : _countryBlock();
}

#pragma mark - 选择地址
- (IBAction)addressButtonClick {
    !_selectAdBlock ? : _selectAdBlock();
}
#pragma mark - Setter Getter Methods

@end
