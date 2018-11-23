//
//  BSSignChannelRequest.m
//  BSKYDoctorPro
//
//  Created by kykj on 2018/6/5.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "BSSignChannelRequest.h"
#import "BSSignLabelModel.h"

@implementation BSSignChannelRequest

- (NSString*)bs_requestUrl {
    return @"/allreq/archives/signChannel";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return nil;
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    if (self.ret != nil) {
        self.channelData = [BSSignLabelModel mj_objectArrayWithKeyValuesArray:self.ret];
    }
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}

@end
