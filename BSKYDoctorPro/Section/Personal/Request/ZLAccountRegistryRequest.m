//
//  ZLAccountRegistryRequest.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/3/13.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "ZLAccountRegistryRequest.h"

@implementation ZLAccountRegistryRequest

- (NSString*)bs_requestUrl {
    return @"/doctor/sczl/registry";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return self.account;
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
}

@end
