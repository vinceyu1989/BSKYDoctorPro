//
//  BSAuthLicenseRequest.m
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/8/17.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "BSAuthPublicKeyRequest.h"

@implementation BSAuthPublicKeyRequest

- (NSString*)bs_requestUrl {
    return @"/auth/publicKey";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (NSDictionary*)requestHeaderFieldValueDictionary {
    return @{@"Content-Type": @"application/json",
             @"headMode": [[BSClientManager sharedInstance] headMode],
             };
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    
    NSString* data = self.responseObject[@"data"];
    if ([data isKindOfClass:[NSString class]]) {
//        NSString* cek = [AES128Helper AES128DecryptText:data key:[BSClientManager sharedInstance].rek];
//        [BSClientManager sharedInstance].cek = cek;
        [BSAppManager sharedInstance].publicKey = data;
        [BSAppManager sharedInstance].cbcKey = [NSString randomStringWithLength:16 String:nil];
//        [BSAppManager sharedInstance].cbcKey = @"1234567890123456";
    }else{
        NSLog(@"%@ error",self);
    }
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}

@end
