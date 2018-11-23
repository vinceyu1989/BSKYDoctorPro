//
//  UIViewController+UMeng.m
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/9/25.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "UIViewController+UMeng.h"

@implementation UIViewController (UMeng)

+ (void)load {
    Method viewWillAppear = class_getInstanceMethod(self, @selector(viewWillAppear:));
    Method new_viewWillAppear = class_getInstanceMethod(self, @selector(new_viewWillAppear:));
    method_exchangeImplementations(viewWillAppear, new_viewWillAppear);
    
    Method viewWillDisappear = class_getInstanceMethod(self, @selector(viewWillDisappear:));
    Method new_viewWillDisappear = class_getInstanceMethod(self, @selector(new_viewWillDisappear:));
    method_exchangeImplementations(viewWillDisappear, new_viewWillDisappear);
}

- (void)new_viewWillAppear:(BOOL)animated{
    if ([NSStringFromClass(self.superclass) isEqualToString:@"UIViewController"]) {
        [MobClick beginLogPageView:NSStringFromClass(self.class)];
    }
    [self new_viewWillAppear:animated];
}

- (void)new_viewWillDisappear:(BOOL)animated{
    if ([NSStringFromClass(self.superclass) isEqualToString:@"UIViewController"]) {
        [MobClick endLogPageView:NSStringFromClass(self.class)];
    }
    [self new_viewWillDisappear:animated];
}

@end
