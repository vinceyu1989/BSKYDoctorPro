//
//  BSFollowupCountRequest.m
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/8/29.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "BSFollowupCountRequest.h"

@implementation BSFollowupCountRequest

- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/doctor/followup/count/%@", self.month];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return @{};
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    
    self.eventsByDayList = [FollowupMonthCountModel mj_objectArrayWithKeyValuesArray:self.ret];
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}

@end
