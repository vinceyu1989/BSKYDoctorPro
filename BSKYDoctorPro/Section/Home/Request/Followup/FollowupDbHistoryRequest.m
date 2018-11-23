//
//  FollowupDbHistoryRequest.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/10/31.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "FollowupDbHistoryRequest.h"

@implementation FollowupDbHistoryRequest

- (NSString*)bs_requestUrl {
    
    return @"/doctor/followup/diabFollowUp";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    
    return @{
        @"personId":self.personId,
        @"pageSize":self.pageSize,
        @"pageIndex":self.pageIndex,
        };
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    self.dataList = [FollowupHistoryModel mj_objectArrayWithKeyValuesArray:self.ret];
}
- (void)requestFailedFilter
{
    [super requestFailedFilter];
}


@end
