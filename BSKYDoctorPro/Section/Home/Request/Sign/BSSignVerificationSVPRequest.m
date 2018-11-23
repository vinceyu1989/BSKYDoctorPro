//
//  BSSignVerificationSVPRequest.m
//  BSKYDoctorPro
//
//  Created by kykj on 2018/4/24.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "BSSignVerificationSVPRequest.h"

@implementation BSSignVerificationSVPRequest

- (NSString*)bs_requestUrl {
    return @"/doctor/sign/verificationServicePack";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return @{@"personId":self.personId,
             @"teamId":self.teamId,
             @"servicesId":self.servicesId,
             @"startTime":self.startTime,
             @"endTime":self.endTime,
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
