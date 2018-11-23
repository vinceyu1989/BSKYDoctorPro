//
//  ZLFollowupUpRequest.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/3/5.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ZLFollowupUpRequest.h"

@implementation ZLFollowupUpRequest

- (YTKRequestMethod )requestMethod{
    return YTKRequestMethodPOST;
}
- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}

- (void)requestCompleteFilter{
    [super requestCompleteFilter];
}
- (void)requestFailedFilter{
    [super requestFailedFilter];
}


@end

@implementation ZLFollowupHyUpRequest

- (NSString *)bs_requestUrl{
    
    return @"/doctor/sczl/followUp/hyFollowUp";
}
- (id )requestArgument {
    return self.hyForm;
}

@end

@implementation ZLFollowupDbUpRequest

- (NSString *)bs_requestUrl{
    
    return @"/doctor/sczl/followUp/dbFollowUp";
}
- (id )requestArgument {
    return self.dbForm;
}

@end
