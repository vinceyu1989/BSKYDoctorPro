//
//  BSSignCheckSignature.m
//  BSKYDoctorPro
//
//  Created by kykj on 2018/7/27.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "BSSignCheckSignature.h"

@implementation BSSignCheckSignature

- (NSString*)bs_requestUrl {
    return @"/face/sign/check";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return nil;
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
}

@end
