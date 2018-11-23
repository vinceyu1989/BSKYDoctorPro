//
//  FollowupUpdateDateRequest.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/10/31.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "FollowupUpdateDateRequest.h"

@implementation FollowupUpdateDateRequest

- (NSString*)bs_requestUrl {
    
    return [NSString stringWithFormat:@"/doctor/followup/updatedate/%@/%@",self.planId,self.followdate];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return nil;
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}

@end
