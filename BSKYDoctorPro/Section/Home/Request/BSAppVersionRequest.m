//
//  BSAppVersionRequest.m
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/9/22.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "BSAppVersionRequest.h"

@implementation BSAppVersionRequest

- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/user/v1/appversion/v20171207"];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return @{@"clientType" : @"1"};
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    self.versionModel = [VersionModel mj_objectWithKeyValues:self.ret];
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentAppVersion = infoDic[@"CFBundleShortVersionString"];
    NSInteger currentAppVersionInteger = [currentAppVersion getNumText].integerValue;
    self.isAudit = currentAppVersionInteger == [self.versionModel.auditStatusNum getNumText].integerValue;
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
}

@end

@implementation VersionModel

@end
