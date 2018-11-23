//
//  BSFollowupListRequest.m
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/8/29.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "BSFollowupListRequest.h"
#import "BSFollowup.h"

@implementation BSFollowupListRequest

- (instancetype)init {
    self = [super init];
    if (self) {
        self.pageNo = @"1";
        self.pageSize = @"10";
    }
    
    return self;
}

- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/doctor/followup/list/%@", self.followDate];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return @{@"pageNo": self.pageNo,
             @"pageSize": self.pageSize};
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    self.followupList = [BSFollowup mj_objectArrayWithKeyValuesArray:self.ret];
    [self.followupList decryptArray];
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}

@end
