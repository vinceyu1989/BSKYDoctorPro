//
//  ResidentPhotoRequest.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/1/23.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ResidentPhotoRequest.h"

@implementation ResidentPhotoRequest

- (NSString*)bs_requestUrl {
    return @"/doctor/putonrecord/photo";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return @{@"personId":self.personId};
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    self.data = self.responseObject[@"data"];
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
}


@end
