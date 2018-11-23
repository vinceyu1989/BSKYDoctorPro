//
//  BSCMSCodeRequest.m
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/8/17.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "BSCmsCodeRequest.h"

@implementation BSCmsCodeRequest

- (NSString*)bs_requestUrl {
    
    return @"/user/v1/cmsCode";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return @{@"phone": self.phone};
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}

@end
