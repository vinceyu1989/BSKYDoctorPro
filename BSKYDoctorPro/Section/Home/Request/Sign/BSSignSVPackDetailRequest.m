//
//  BSSignSVPackRequest.m
//  BSKYDoctorPro
//
//  Created by kykj on 2018/1/12.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "BSSignSVPackDetailRequest.h"
#import "SignSVPackContentModel.h"

@implementation BSSignSVPackDetailRequest
//GET
- (instancetype)init {
    self = [super init];
    if (self) {
        self.pageSize = @30;
        self.pageIndex = @1;
    }
    return self;
}

- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/doctor/sign/servicePackContent"];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return @{@"servicePackId":self.servicePackId,
             @"pageSize":self.pageSize,
             @"pageIndex":self.pageIndex,};
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    if (self.ret != nil) {
        self.SVPackData = [SignSVPackContentModel mj_objectArrayWithKeyValuesArray:self.ret];
    }
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}

@end
