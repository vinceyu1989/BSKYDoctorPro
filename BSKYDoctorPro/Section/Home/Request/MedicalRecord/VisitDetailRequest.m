//
//  VisitDetailRequest.m
//  BSKYDoctorPro
//
//  Created by vince on 2018/9/5.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "VisitDetailRequest.h"
#import "VisitDetailModel.h"

@implementation VisitDetailRequest
- (instancetype)init
{
    self = [super init];
    if (self) {
        _mzId = @"";
    }
    return self;
}
- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/doctor/visit/visitdetails"];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return @{
             @"mzId" : self.mzId,
             };
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    
    NSDictionary* data = self.ret;
    self.model = [VisitDetailModel mj_objectWithKeyValues:data];
    [self.model decryptModel];
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}
@end
