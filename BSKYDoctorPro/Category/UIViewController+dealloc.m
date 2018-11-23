//
//  UIViewController+dealloc.m
//  OneLive
//
//  Created by 高 on 2016/12/27.
//  Copyright © 2016年 forcetech. All rights reserved.
//

#import "UIViewController+dealloc.h"
#import <objc/runtime.h>

@implementation UIViewController (dealloc)

+ (void)load {
    static dispatch_once_t oncetoken;
    _dispatch_once(&oncetoken, ^{
        SEL originalSelector = NSSelectorFromString(@"dealloc");
        SEL swizzldSelector = @selector(swiz_dealloc);
        
        [UIViewController swizzleInstanceMethod:originalSelector with:swizzldSelector];
    });
}

+ (BOOL)swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel {
    Method originalMethod = class_getInstanceMethod(self, originalSel);
    Method newMethod = class_getInstanceMethod(self, newSel);
    if (!originalMethod || !newMethod) return NO;
    
    class_addMethod(self,
                    originalSel,
                    class_getMethodImplementation(self, originalSel),
                    method_getTypeEncoding(originalMethod));
    class_addMethod(self,
                    newSel,
                    class_getMethodImplementation(self, newSel),
                    method_getTypeEncoding(newMethod));
    
    method_exchangeImplementations(class_getInstanceMethod(self, originalSel),
                                   class_getInstanceMethod(self, newSel));
    return YES;
}

- (void)swiz_dealloc{
    NSString *clazzName = NSStringFromClass([self class]);
    NSLog(@"================%@页面被释放=========",clazzName);
    [self swiz_dealloc];
}

@end
