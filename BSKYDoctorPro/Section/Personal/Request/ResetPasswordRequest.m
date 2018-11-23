//
//  ResetPasswordRequest.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/8/23.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "ResetPasswordRequest.h"

@implementation ResetPasswordRequest

- (NSString*)bs_requestUrl {
    return @"/user/v1/userResetPassword";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    
    return @{@"randomCek": [NSString enctryptCBCKeyWithRSA],
             @"phone": [self.phone encryptCBCStr],
             @"cmsCode": [self.cmsCode encryptCBCStr],
             @"password": [self.password encryptCBCStr]};
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
}

@end
