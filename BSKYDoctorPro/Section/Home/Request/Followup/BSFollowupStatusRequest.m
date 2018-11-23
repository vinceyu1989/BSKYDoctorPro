//
//  BSFollowupStatusRequest.m
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/9/19.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "BSFollowupStatusRequest.h"

@implementation BSFollowupStatusRequest

- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/doctor/followup/updatestatus/%@", self.date];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    
}
- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}

@end
