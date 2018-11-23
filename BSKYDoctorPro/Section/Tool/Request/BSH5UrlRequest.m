//
//  BSZhiQuRequest.m
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/8/30.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "BSH5UrlRequest.h"

@implementation BSH5UrlRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.needToken = YES;
    }
    return self;
}

- (NSString*)bs_requestUrl{
    
    return @"/user/v1/toH5";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    
    NSString *str = self.needToken ? @"true" : @"false";
    
    return @{@"needToken":str,
             @"type":self.type,
             @"otherParam":self.otherParam};
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    
    self.urlString = self.responseObject[@"data"];
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}

@end
