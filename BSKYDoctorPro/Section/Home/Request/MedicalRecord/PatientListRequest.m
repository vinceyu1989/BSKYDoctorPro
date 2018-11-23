//
//  PatientListRequest.m
//  BSKYDoctorPro
//
//  Created by vince on 2018/9/5.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "PatientListRequest.h"
#import "PatientListModel.h"

@implementation PatientListRequest
- (instancetype)init
{
    self = [super init];
    if (self) {
        _pageSize = @"20";
        _pageIndex = @"1";
        _key = @"";
    }
    return self;
}
- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/doctor/visit/patientlist"];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return @{
             @"pageSize" : self.pageSize,
             @"pageIndex" : self.pageIndex,
             @"key" : self.key,
             };
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    
    NSDictionary* data = self.ret;
    self.listArray = [PatientListModel mj_objectArrayWithKeyValuesArray:data];
    [self.listArray decryptArray];
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}

@end
