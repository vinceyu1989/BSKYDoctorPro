//
//  MBProgressHUD+BSKY.h
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/9/21.
//  Copyright © 2017年 ky. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (BSKY)

+ (void)showHud;

+ (void)showHudInView:(UIView*)view;

+ (void)hideHud;

+ (void)hideHudInView:(UIView*)view;
@end
