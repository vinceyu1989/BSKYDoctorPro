//
//  UILabel+Font.m
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/9/20.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "UILabel+Font.h"

@implementation UILabel (Font)

+ (void)load {
    Method imp = class_getInstanceMethod([self class], @selector(initWithCoder:));
    Method myImp = class_getInstanceMethod([self class], @selector(myInitWithCoder:));
    method_exchangeImplementations(imp, myImp);
}

- (instancetype)myInitWithCoder:(NSCoder*)aDecoder {
    [self myInitWithCoder:aDecoder];
    if (self) {
        CGFloat size = 0;
        if (Screen55) {
            size += 1;
        }else if (Screen40) {
            size -= 1;
        }
        
        self.font = [UIFont systemFontOfSize:self.font.pointSize + size];
    }
    
    return self;
}

@end
