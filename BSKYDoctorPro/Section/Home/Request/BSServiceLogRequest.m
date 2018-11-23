//
//  BSServiceLogRequest.m
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/9/22.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "BSServiceLogRequest.h"

@implementation BSServiceLogRequest

- (instancetype)init {
    self = [super init];
    if (self) {
        self.pageNo = @"1";
        self.pageSize = @"100";
    }
    
    return self;
}

- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/doctor/servicelog/list"];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return @{@"pageNo": self.pageNo,
             @"pageSize": self.pageSize};
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    
    NSMutableArray* temp = [NSMutableArray array];
    NSDictionary* data = self.ret;
    for (NSDictionary* item in data) {
        BSServiceLog* model = [BSServiceLog mj_objectWithKeyValues:item];
        [temp addObject:model];
    }
    
    self.serviceLogList = [NSArray arrayWithArray:temp];
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}

@end
