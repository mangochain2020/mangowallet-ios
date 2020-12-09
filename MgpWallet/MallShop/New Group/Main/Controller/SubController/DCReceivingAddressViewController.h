//
//  DCReceivingAddressViewController.h
//  CDDStoreDemo
//
//  Created by 陈甸甸 on 2017/12/18.
//Copyright © 2017年 RocketsChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCAdressItem.h"

@protocol DCReceivingAddressDelegate <NSObject>
  
-(void)receivingAddressValue:(DCAdressItem *)value;
  
@end

@interface DCReceivingAddressViewController : UIViewController

     
@property(nonatomic,assign) NSObject<DCReceivingAddressDelegate> *delegate;

@end
