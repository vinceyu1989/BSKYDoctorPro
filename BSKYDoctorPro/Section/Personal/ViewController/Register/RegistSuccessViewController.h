//
//  RegistSuccessViewController.h
//  BSKYDoctorPro
//
//  Created by kykj on 2017/11/27.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RegistSuccessViewController;
typedef void(^HomeBlock)(RegistSuccessViewController *vc);

@interface RegistSuccessViewController : UIViewController

@property (nonatomic, copy) HomeBlock blocks;

@end
