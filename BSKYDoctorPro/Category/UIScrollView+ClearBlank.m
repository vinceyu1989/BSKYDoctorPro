//
//  UIScrollView+ClearBlank.m
//  BSKYDoctorPro
//
//  Created by kykj on 2017/11/17.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "UIScrollView+ClearBlank.h"

@implementation UIScrollView (ClearBlank)

+ (void)load {
    static dispatch_once_t oncetoken;
    _dispatch_once(&oncetoken, ^{
        
        SEL originalSelector = NSSelectorFromString(@"init");
        SEL swizzledSelector = @selector(swiz_init);
        
        SEL originalSelector1 = NSSelectorFromString(@"initWithFrame:");
        SEL swizzledSelector1 = @selector(swiz_initWithFrame:);
        
        SEL originalSelector2 = NSSelectorFromString(@"awakeFromNib");
        SEL swizzledSelector2 = @selector(swiz_awakeFromNib);
        
        [UIScrollView swizzleInstanceMethod:originalSelector with:swizzledSelector];
        [UIScrollView swizzleInstanceMethod:originalSelector1 with:swizzledSelector1];
        [UIScrollView swizzleInstanceMethod:originalSelector2 with:swizzledSelector2];
    });
}

- (instancetype)swiz_init
{
    id __self = [self swiz_init];
    [self clearBlank];
    return __self;
}
- (instancetype)swiz_initWithFrame:(CGRect)frame
{
    id __self = [self swiz_initWithFrame:frame];
    [self clearBlank];
    return __self;
}

- (void)swiz_awakeFromNib{
    [self swiz_awakeFromNib];
    [self clearBlank];
}
- (void)clearBlank {

//    if (@available(iOS 11.0, *)) {
//        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    } else {
//
//    }
}

@end
