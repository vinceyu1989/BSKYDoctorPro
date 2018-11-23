//
//  BSSignTeamsRequest.m
//  BSKYDoctorPro
//
//  Created by kykj on 2018/1/12.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "BSSignTeamsRequest.h"
#import "SignTeamsInfoModel.h"

@implementation BSSignTeamsRequest

- (NSString*)bs_requestUrl {
    return @"/doctor/sign/signTeams";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return nil;
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    if (self.ret != nil) {
        self.teamsData = [SignTeamsInfoModel mj_objectArrayWithKeyValuesArray:self.ret];
    }
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}

@end

