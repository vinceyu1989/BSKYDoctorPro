//
//  ZLDoctorListRequest.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/3/7.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ZLDoctorListRequest.h"

@implementation ZLDoctorListRequest

- (NSString*)bs_requestUrl {
    
    return @"/doctor/sczl/followUp/findMedicalStaffList";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return @{@"doctorInfo":self.key,
             @"pageIndex": self.pageIndex,
             @"pageSize": self.pageSize};
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    self.dataList = [ZLDoctorModel mj_objectArrayWithKeyValuesArray:self.ret];
}

@end
