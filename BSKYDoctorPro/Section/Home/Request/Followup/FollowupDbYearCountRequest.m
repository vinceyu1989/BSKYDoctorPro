//
//  FollowupDbYearCountRequest.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/9/21.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "FollowupDbYearCountRequest.h"

@implementation FollowupDbYearCountRequest

- (NSString*)bs_requestUrl {
    
    return [NSString stringWithFormat:@"/doctor/followup/userYearDbFollowUpCount/%@/%@",self.personId,self.doctorId];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return nil;
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    if (self.ret && [self.ret isKindOfClass:[NSNumber class]]) {
        self.count = ((NSNumber *)self.ret).integerValue;
    }
}
- (void)requestFailedFilter
{
    [super requestFailedFilter];
}

@end
