//
//  MBProgressHUD+BSKY.m
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/9/21.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "MBProgressHUD+BSKY.h"

BOOL animated;

@implementation MBProgressHUD (BSKY)

+ (void)showHud {
    UIView* view = [UIApplication sharedApplication].keyWindow;
    [MBProgressHUD showHudInView:view];
}

+ (void)showHudInView:(UIView*)view {
    for (UIView *hudView in view.subviews) {
        if ([hudView isKindOfClass:[MBProgressHUD class]]) {
            for (UIView *subView in hudView.subviews) {
                [subView removeFromSuperview];
            }
            [hudView removeFromSuperview];
        }
    }
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    hud.mode = MBProgressHUDModeCustomView;
    hud.bezelView.backgroundColor = [UIColor redColor];
    hud.square = YES;
    hud.bezelView.layer.cornerRadius = 15;
    hud.bezelView.color = RGBA(0, 0, 0, 0.3);
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.margin = 15;
    
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading_bg"]];
    UIImageView* rotateImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading_rotate"]];
    rotateImageView.frame = imageView.bounds;
    rotateImageView.contentMode = UIViewContentModeCenter;
    [imageView addSubview:rotateImageView];
    
    hud.customView = imageView;
    
    animated = YES;
    [MBProgressHUD rotate:rotateImageView];
    
    [view addSubview:hud];
    [hud showAnimated:YES];
}
+ (void)hideHudInView:(UIView*)view{
    [MBProgressHUD hideHUDForView:view animated:YES];
}
+ (void)hideHud {
    UIView* view = [UIApplication sharedApplication].keyWindow;
    animated = NO;
    [MBProgressHUD hideHUDForView:view animated:YES];
}

+ (void)rotate:(UIView*)view {
    [UIView animateWithDuration:.3f
                          delay:0
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionRepeat
                     animations:^{
                         view.transform = CGAffineTransformRotate(view.transform, M_PI_2);
                     }
                     completion:^(BOOL finished){
                         if (finished) {
                             if (animated) {
                                 [MBProgressHUD rotate:view];
                             }
                         }
                     }];
}
@end
