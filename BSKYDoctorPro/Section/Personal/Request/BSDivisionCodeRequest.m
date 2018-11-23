//
//  BSDivisionCodeRequest.m
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/9/30.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "BSDivisionCodeRequest.h"

@implementation BSDivisionCodeRequest

- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"  %@", self.divisionCode];
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
