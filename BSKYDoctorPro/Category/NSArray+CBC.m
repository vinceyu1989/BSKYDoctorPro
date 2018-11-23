//
//  NSArray+CBC.m
//  BSKYDoctorPro
//
//  Created by vince on 2018/8/15.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "NSArray+CBC.h"

@implementation NSArray (CBC)
- (void)decryptArray{
    for (id model in self) {
        if ([model respondsToSelector:@selector(decryptModel)]) {
            [model performSelector:@selector(decryptModel)];
        }
    }
}
- (void)encryptArray{
    for (id model in self) {
        if ([model respondsToSelector:@selector(encryptModel)]) {
            [model performSelector:@selector(encryptModel)];
        }
    }
}
@end
