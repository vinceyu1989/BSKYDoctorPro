//
//  BSEduHealthSaveRequest.m
//  BSKYDoctorPro
//
//  Created by jangry on 2018/7/13.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "BSEduHealthSaveRequest.h"

@implementation BSEduHealthSaveRequest

- (NSString*)bs_requestUrl {
    return @"/doctor/education/addeduperson";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}

- (id)requestArgument {
    return self.from;
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
}
- (void)requestFailedFilter {
    
    [super requestFailedFilter];
}
@end
