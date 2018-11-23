//
//  ResidentZhongYiRequest.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/1/22.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ResidentZhongYiRequest.h"

@implementation ResidentZhongYiRequest

- (NSString*)bs_requestUrl {
    return @"/doctor/zy/findLastZhongYiFollowUp";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return @{@"personId":self.personId};
}
- (void)startWithCompletionBlockWithSuccess:(YTKRequestCompletionBlock)success failure:(YTKRequestCompletionBlock)failure
{
    [super startWithCompletionBlockWithSuccess:success failure:failure];
    self.refreshStatus = ResidentRefreshStatusRuning;
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    self.data = [ResidentZhongYiModel mj_objectWithKeyValues:self.ret];
    self.refreshStatus = ResidentRefreshStatusSuccess;
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    self.refreshStatus = ResidentRefreshStatusFailure;
}


@end
