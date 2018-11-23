//
//  BSSignSuccessViewController.h
//  BSKYDoctorPro
//
//  Created by kykj on 2017/12/28.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BSSignSuccessViewController;
typedef void(^SignSuccessVCBlock)(BSSignSuccessViewController *vc);

@interface BSSignSuccessViewController : UIViewController

@property (nonatomic, copy) SignSuccessVCBlock block;

@end
