//
//  ScanViewController.h
//  BSKYDoctorPro
//
//  Created by kykj on 2017/11/29.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScanViewController;
typedef void(^ScanBlock)(ScanViewController *vc,NSString *scanCode);

@interface ScanViewController : UIViewController

@property (nonatomic, copy) ScanBlock block;

@end
