//
//  ZLHistoryBaseRequest.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/3/5.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ZLHistoryBaseRequest.h"

@implementation ZLHistoryBaseRequest

- (YTKRequestMethod)requestMethod {
    
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    
    return @{
             @"personId":self.personId,
             @"doctorId":self.doctorId,
             @"pageSize":self.pageSize,
             @"pageIndex":self.pageIndex,
             };
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    self.dataList = [ZLFollowupHistoryModel mj_objectArrayWithKeyValuesArray:self.ret];
}

@end
@implementation ZLHyHistoryRequest

- (NSString*)bs_requestUrl {
    
    return @"/doctor/sczl/followUp/hyperbFollowUp";
}

@end

@implementation ZLDbHistoryRequest

- (NSString*)bs_requestUrl {
    
    return @"/doctor/sczl/followUp/diabFollowUp";
}

@end
