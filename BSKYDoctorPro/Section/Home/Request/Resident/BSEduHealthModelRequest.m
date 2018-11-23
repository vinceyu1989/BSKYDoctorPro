//
//  BSEduHealthModelRequest.m
//  BSKYDoctorPro
//
//  Created by jangry on 2018/7/13.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "BSEduHealthModelRequest.h"
#import "BSEduHealthContentModel.h"

@implementation BSEduHealthModelRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.pageIndex = @(1);
        self.pageSize = @(20);
    }
    return self;
}

- (NSString*)bs_requestUrl {
    return @"/doctor/education/templatelist";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return @{@"pageSize":self.pageSize,
             @"pageIndex":self.pageIndex,
             @"title":self.title,
             };
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    self.healthModelData = [BSEduHealthContentModel mj_objectArrayWithKeyValuesArray:self.ret];
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
}

@end
