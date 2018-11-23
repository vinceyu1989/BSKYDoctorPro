//
//  RegistViewController.h
//  BSKYDoctorPro
//
//  Created by kykj on 2017/11/22.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RegistViewController;
typedef void(^RegistBlock)(RegistViewController *vc,NSString *phone,NSString *pw);

@interface RegistViewController : UIViewController

@property (nonatomic, copy) RegistBlock block;

@end
