//
//  HuobiExchangeView.m
//  TaiYiToken
//
//  Created by 张元一 on 2019/3/14.
//  Copyright © 2019 admin. All rights reserved.
//

#import "HuobiExchangeView.h"

@implementation HuobiExchangeView

//@property(nonatomic,strong)UIButton *buyBtn;
//@property(nonatomic,strong)UIButton *saleBtn;
//@property(nonatomic,strong)UIButton *operationBtn;
////限价
//@property(nonatomic,strong)UIButton *buychooseBtn;
//
//@property(nonatomic,strong)HuobiTypeOneTF *priceTF;
//@property(nonatomic,strong)HuobiTypeTwoTF *quantityTF;

-(void)loadLeftView{
    _symbolLb = [UILabel new];
    _symbolLb.font = [UIFont boldSystemFontOfSize:18];
    _symbolLb.textAlignment = NSTextAlignmentLeft;
    _symbolLb.textColor = [UIColor darkGrayColor];
    
    _showSelectSymbolViewBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_showSelectSymbolViewBtn setImage:[[UIImage imageNamed:@"bbb"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [_showSelectSymbolViewBtn setTintColor:[UIColor darkappGreenColor]];
   
    
    _buyBtn = [HuobiBtn HuobiTypeOneBtnBGColor:YES isOperationBtn:NO Title:NSLocalizedString(@"买入", nil)];
    _saleBtn = [HuobiBtn HuobiTypeOneBtnBGColor:NO isOperationBtn:NO  Title:NSLocalizedString(@"卖出", nil)];
    _operationBtn = [HuobiBtn HuobiTypeOneBtnBGColor:NO isOperationBtn:YES Title:NSLocalizedString(@"买入", nil)];
    [_buyBtn setSelected:YES];
    [_saleBtn setSelected:NO];
    [_operationBtn setSelected:NO];
    
    
    _buychooseBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_buychooseBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [_buychooseBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    //ico_down_select
    
    NSTextAttachment *attchment = [[NSTextAttachment alloc]init];
    attchment.bounds = CGRectMake(0, 0, 8, 8);//设置frame
    attchment.image = [UIImage imageNamed:@"ico_down_select"];//设置图片
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attchment];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"限价", nil)];
    [attributedString appendAttributedString:string];
    [attributedString addAttribute:NSForegroundColorAttributeName
                  value:[UIColor grayColor]
                  range:NSMakeRange(0, attributedString.length)];

    [_buychooseBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [_buychooseBtn setAttributedTitle:attributedString forState:UIControlStateNormal];
    
    _priceTF = [HuobiTypeOneTF new];
    [_priceTF HuobiPriceTF];
    [_priceTF.huobiTF setPlaceholder:NSLocalizedString(@"价格", nil)];
    _amountLb = [UILabel new];
    _amountLb.font = [UIFont systemFontOfSize:16];
    _amountLb.textAlignment = NSTextAlignmentLeft;
    _amountLb.textColor = [UIColor darkGrayColor];
    [_amountLb setText:NSLocalizedString(@"交易额2", nil)];
    [_amountLb setFont:[UIFont systemFontOfSize:12]];
    
    _quantityTF = [HuobiTypeTwoTF new];
    [_quantityTF HuobiQuantityTF];
    [_quantityTF.huobiTF setPlaceholder:NSLocalizedString(@"数量", nil)];
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:_showSelectSymbolViewBtn];
    [_showSelectSymbolViewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.width.height.equalTo(18);
        make.top.equalTo(4);
    }];
    
    [self addSubview:_symbolLb];
    [_symbolLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(34);
        make.width.equalTo(150);
        make.top.equalTo(0);
        make.height.equalTo(26);
    }];
    
    [self addSubview:_buyBtn];
    [_buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.right.equalTo(self.mas_centerX).equalTo(-2);
        make.top.equalTo(40);
        make.height.equalTo(38);
    }];
    [self addSubview:_saleBtn];
    [_saleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-10);
        make.left.equalTo(self.mas_centerX).equalTo(2);
        make.top.equalTo(40);
        make.height.equalTo(38);
    }];
    [self addSubview:_buychooseBtn];
    [_buychooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.width.equalTo(70);
        make.top.equalTo(self.buyBtn.mas_bottom).equalTo(5);
        make.height.equalTo(30);
    }];
    [self addSubview:_priceTF];
    [_priceTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.right.equalTo(-10);
        make.top.equalTo(self.buychooseBtn.mas_bottom).equalTo(10);
        make.height.equalTo(70);
    }];
    [self addSubview:_quantityTF];
    [_quantityTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.right.equalTo(-10);
        make.top.equalTo(self.priceTF.mas_bottom).equalTo(10);
        make.height.equalTo(70);
    }];
    
    [self addSubview:_amountLb];
    [_amountLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.right.equalTo(-10);
        make.top.equalTo(self.quantityTF.mas_bottom).equalTo(10);
        make.height.equalTo(30);
    }];
    
    [self addSubview:_operationBtn];
    [_operationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.right.equalTo(-10);
        make.top.equalTo(self.amountLb.mas_bottom).equalTo(10);
        make.height.equalTo(40);
    }];
    
//    //test
//    _priceTF.remindLb.text = @"wsdefr";
//    _quantityTF.remindLb.text = @"defr";
    
}

@end
