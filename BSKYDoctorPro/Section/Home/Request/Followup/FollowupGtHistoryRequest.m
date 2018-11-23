//
//  FollowupGtHistoryRequest.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/12/11.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "FollowupGtHistoryRequest.h"

@implementation FollowupGtHistoryRequest

- (NSString*)bs_requestUrl {
    
    return @"/doctor/hydbfollowup/personList";
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
