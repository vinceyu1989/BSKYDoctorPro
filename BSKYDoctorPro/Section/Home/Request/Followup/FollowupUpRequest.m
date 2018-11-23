//
//  FollowupUpRequest.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/9/14.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "FollowupUpRequest.h"

@implementation FollowupUpRequest

- (NSString*)bs_requestUrl {
    
//    return [NSString stringWithFormat:@"/doctor/followup/plan?followUp=%@&followUpPlan=%@", [self.followUp urlencode],[self.followupPlan urlencode]];
    return @"/doctor/followup/planV2";
}
- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    NSDictionary *dic = @{
                          @"followUp":self.followUp,
                          @"followUpPlan":[self.followupPlan mj_JSONObject],
                          };
    NSString *str = [dic mj_JSONString];
    self.followUpPlanForm = dic;
    return self.followUpPlanForm;
//    return nil;
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
}

@end
