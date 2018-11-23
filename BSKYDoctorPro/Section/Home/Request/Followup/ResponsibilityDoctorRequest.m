//
//  ResponsibilityDoctorRequest.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/9/13.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "ResponsibilityDoctorRequest.h"

@implementation ResponsibilityDoctorRequest

- (NSString*)bs_requestUrl {
//    return @"/doctor/followup/responsibilitydoctor";
    return @"/doctor/putonrecord/orgInDoctor";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return @{@"medWorkerName":self.medWorkerName,
             @"pageSize":self.pageSize,
             @"pageIndex":self.pageIndex
             };
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    self.dataList = [FollowupDoctorModel mj_objectArrayWithKeyValuesArray:self.ret];
    [self.dataList decryptArray];
}
- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}

@end
