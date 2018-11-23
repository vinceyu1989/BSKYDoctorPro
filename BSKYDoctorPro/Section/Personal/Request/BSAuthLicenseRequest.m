//
//  BSAuthLicenseRequest.m
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/8/17.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "BSAuthLicenseRequest.h"

@implementation BSAuthLicenseRequest

- (NSString*)bs_requestUrl {
    return @"/auth/license";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSDictionary*)requestHeaderFieldValueDictionary {
    return @{@"Content-Type": @"application/json",
             @"headMode": [[BSClientManager sharedInstance] headMode],
             @"token" : [BSClientManager sharedInstance].tokenId};
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    
//    NSString* data = self.responseObject[@"data"];
    //以前用以获取cbc加密的key值，现已废弃
//    if ([BSClientManager sharedInstance].rek.length) {
//        NSString* cek = [AES128Helper AES128DecryptText:data key:[BSClientManager sharedInstance].rek];
//        [BSClientManager sharedInstance].cek = cek;
//    }
    
    BSVerifyStatusRequest* request = [BSVerifyStatusRequest new];
    [request startWithCompletionBlockWithSuccess:^(__kindof BSVerifyStatusRequest * _Nonnull request) {
        if (request.verifyStatus == 3) {
            BSDoctorPhisRequest* request = [BSDoctorPhisRequest new];
            [request startWithCompletionBlockWithSuccess:^(BSDoctorPhisRequest* request) {
            } failure:^(BSDoctorPhisRequest* request) {
            }];
        }else {
        }
    } failure:^(__kindof BSVerifyStatusRequest * _Nonnull request) {
    }];
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}

@end
