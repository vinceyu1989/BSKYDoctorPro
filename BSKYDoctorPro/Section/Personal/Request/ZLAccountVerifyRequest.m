//
//  ZLAccountVerifyRequest.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/3/13.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ZLAccountVerifyRequest.h"

@implementation ZLAccountVerifyRequest

- (NSString*)bs_requestUrl {
    return @"/doctor/sczl/registry/verify";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return @{};
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    ZLAccountInfo *zlInfo = [ZLAccountInfo mj_objectWithKeyValues:self.ret];
    if (zlInfo.account.length >= 1) {
        [BSAppManager sharedInstance].currentUser.zlAccountInfo = zlInfo;
    }
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
}

@end
