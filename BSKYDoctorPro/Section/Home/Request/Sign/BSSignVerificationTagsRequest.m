//
//  BSSignVerificationTagsRequest.m
//  BSKYDoctorPro
//
//  Created by kykj on 2018/4/24.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "BSSignVerificationTagsRequest.h"

@implementation BSSignVerificationTagsRequest

- (NSString*)bs_requestUrl {
    return @"/doctor/sign/verificationTags";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return @{@"personId":self.personId,
             @"tags":self.tags,
             };
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    if (self.ret != nil) {
//        self.teamsData = [SignTeamsInfoModel mj_objectArrayWithKeyValuesArray:self.ret];
    }
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}

@end
