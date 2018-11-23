//
//  BSHomeStatisticRequest.m
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/9/12.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "BSHomeStatisticRequest.h"

@implementation BSHomeStatisticRequest

- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/doctor/v1/statistics"];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{};
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    
    NSDictionary* data = self.ret;
    self.putOnRecordCount = [NSString stringWithFormat:@"%@",data[@"putOnRecordCount"]];
    self.signedCount = [NSString stringWithFormat:@"%@",data[@"signedCount"]];
    self.followUpCount = [NSString stringWithFormat:@"%@",data[@"followUpCount"]];
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}

@end
