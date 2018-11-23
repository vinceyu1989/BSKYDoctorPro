//
//  UIView+BSToast.m
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/8/18.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "UIView+BSToast.h"

@implementation UIView (BSToast)

+ (void)makeToast:(NSString*)message {
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    
    CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
    
    style.messageColor = [UIColor whiteColor];
    style.backgroundColor = RGBA(0, 0, 0, .6);
    style.cornerRadius = 5;
    style.messageFont = [UIFont systemFontOfSize:14. weight:UIFontWeightRegular];
    
    [window hideToasts];
    [window makeToast:message
             duration:2.
             position:[NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH / 2., SCREEN_HEIGHT / 2. - 40)]];
    
    [CSToastManager setSharedStyle:style];
    [CSToastManager setTapToDismissEnabled:YES];
    [CSToastManager setQueueEnabled:YES];}

@end
