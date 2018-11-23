//
//  BSDoctorPhisRequest.m
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/9/19.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "BSDoctorPhisRequest.h"

@implementation BSDoctorPhisRequest

- (NSString*)bs_requestUrl {
    return @"/phis/register";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    
    NSDictionary* data = self.ret;
    BSPhisInfo* model = [BSPhisInfo mj_objectWithKeyValues:data];
    [BSAppManager sharedInstance].currentUser.phisInfo = model;
    [[NSNotificationCenter defaultCenter] postNotificationName:kPhisInfoUpdate object:nil];
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}

@end
