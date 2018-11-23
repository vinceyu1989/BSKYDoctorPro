//
//  BSFamilySignPushRequest.m
//  BSKYDoctorPro
//
//  Created by kykj on 2018/4/24.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "BSFamilySignPushRequest.h"

@implementation BSFamilySignPushRequest

- (NSTimeInterval)requestTimeoutInterval {
    return 300;
}

- (NSString*)bs_requestUrl {
    return @"/allreq/archives/family";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}

- (id)requestArgument {
    return self.contractInVM;
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
}

@end

