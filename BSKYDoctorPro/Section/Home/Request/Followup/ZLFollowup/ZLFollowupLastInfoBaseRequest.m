//
//  ZLFollowupLastInfoBaseRequest.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/2/27.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ZLFollowupLastInfoBaseRequest.h"

@implementation ZLFollowupLastInfoBaseRequest

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}
- (id)requestArgument {
    return @{@"personId":self.personId,
             @"followUpDate": self.lastfollowdate};
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    self.lastModel = [ZLFollowupLastModel mj_objectWithKeyValues:self.ret];
}
- (void)requestFailedFilter {
    [super requestFailedFilter];
}

@end

@implementation ZLFollowupLastInfoHyRequest

- (NSString*)bs_requestUrl {
    
    return @"/doctor/sczl/followUp/hyFollowUp";
}

@end

@implementation ZLFollowupLastInfoDbRequest

- (NSString*)bs_requestUrl {
    
    return @"/doctor/sczl/followUp/dbFollowUp";
}


@end
