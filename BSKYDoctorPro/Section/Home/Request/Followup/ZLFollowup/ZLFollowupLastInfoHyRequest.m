//
//  ZLFollowupLastInfoHyRequest.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/2/27.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ZLFollowupLastInfoHyRequest.h"

@implementation ZLFollowupLastInfoHyRequest

- (NSString*)bs_requestUrl {
    switch (self.method) {
        case YTKRequestMethodGET:
            return [NSString stringWithFormat:@"/doctor/sczl/followUp/hyFollowUp/%@/%@",self.personId,self.lastfollowdate];
            break;
        case YTKRequestMethodPOST:
            return @"/doctor/sczl/followUp/hyFollowUp";
            break;
        default:
            return nil;
            break;
    }
    
}

- (YTKRequestMethod)requestMethod {
    return self.method;
}
- (id)requestArgument {
    
    switch (self.method) {
        case YTKRequestMethodPOST:
            return @"/doctor/sczl/followUp/hyFollowUp";
            break;
        default:
            return nil;
            break;
    }
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    self.lastModel = [ZLFollowupDetailModel mj_objectWithKeyValues:self.ret];
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}

@end
