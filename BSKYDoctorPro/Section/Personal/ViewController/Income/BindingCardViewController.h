//
//  BindingCardViewController.h
//  BSKYDoctorPro
//
//  Created by kykj on 2018/4/9.
//  Copyright © 2018年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSBankInfoModel.h"

@class BindingCardViewController;
typedef void(^BindingBCardBlock)(BindingCardViewController *vc);

@interface BindingCardViewController : UIViewController

@property (nonatomic, strong) BSBankInfoModel *model;
@property (nonatomic, copy) BindingBCardBlock blcok;

@end
