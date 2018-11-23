//
//  BSSignSVPacksRequest.m
//  BSKYDoctorPro
//
//  Created by kykj on 2018/1/13.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "BSSignSVPacksRequest.h"
#import "SignSVPackModel.h"

@implementation BSSignSVPacksRequest

- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/doctor/sign/serverPacks"];
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
        self.packsData = [SignSVPackModel mj_objectArrayWithKeyValuesArray:self.ret];
    }
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}

@end
