//
//  BSLogoutRequest.m
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/8/24.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "BSLogoutRequest.h"

@implementation BSLogoutRequest

- (NSString*)bs_requestUrl {
    return @"/user/v1/logout";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}

@end
