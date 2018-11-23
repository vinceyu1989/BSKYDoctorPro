//
//  BSFollowup.m
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/9/11.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "BSFollowup.h"

@implementation BSFollowup
- (void)decryptModel{
    self.address = [self.address decryptCBCStr];
    self.phone = [self.phone decryptCBCStr];
    self.username = [self.username decryptCBCStr];
    self.userIdCard = [self.userIdCard decryptCBCStr];
}
- (void)encryptModel{
    self.address = [self.address encryptCBCStr];
    self.phone = [self.phone encryptCBCStr];
    self.username = [self.username encryptCBCStr];
    self.userIdCard = [self.userIdCard encryptCBCStr];
}
@end
