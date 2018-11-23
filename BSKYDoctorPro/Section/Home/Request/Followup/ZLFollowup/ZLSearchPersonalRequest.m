//
//  ZLSearchPersonalRequest.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/3/9.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ZLSearchPersonalRequest.h"

@implementation ZLSearchPersonalRequest

- (NSString*)bs_requestUrl {
    
    return @"/doctor/sczl/followUp/personalRcords";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return @{@"personalParam":self.personalParam,
             @"pageIndex": self.pageIndex,
             @"pageSize": self.pageSize};
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    self.dataList = [ZLSearchPersonalModel mj_objectArrayWithKeyValuesArray:self.ret];
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}

@end
