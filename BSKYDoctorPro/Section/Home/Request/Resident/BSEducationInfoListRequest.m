//
//  BSEducationInfoListRequest.m
//  BSKYDoctorPro
//
//  Created by jangry on 2018/7/13.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "BSEducationInfoListRequest.h"
#import "BSEducationModel.h"
@implementation BSEducationInfoListRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.pageIndex = @(1);
        self.pageSize = @(10);
        self.searchParam = @"";
        self.regionCode = @"";
        self.businessType = @"";
        self.startDate = @"";
        self.endDate = @"";
    }
    return self;
}

- (NSString*)bs_requestUrl {
    return @"/doctor/education/educationlist";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return @{@"pageSize":self.pageSize,
             @"pageIndex":self.pageIndex,
             @"regionCode":self.regionCode,
             @"searchParam":self.searchParam,
             @"businessType":self.businessType,
             @"startDate":self.startDate,
             @"endDate":self.endDate,
             };
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    self.infoListData = [BSEducationModel mj_objectArrayWithKeyValuesArray:self.ret];
    [self.infoListData decryptArray];
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
}
@end
