//
//  ZLFollowupLastInfoDbRequest.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/2/27.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ZLFollowupLastInfoDbRequest.h"

@implementation ZLFollowupLastInfoDbRequest

- (NSString*)bs_requestUrl {
    
    return [NSString stringWithFormat:@"/doctor/sczl/followUp/dbFollowUp/%@/%@",self.personId,self.lastfollowdate];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}
- (id)requestArgument {
    return nil;
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    self.lastModel = [ZLFollowupDetailModel mj_objectWithKeyValues:self.ret];
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
}

@end
