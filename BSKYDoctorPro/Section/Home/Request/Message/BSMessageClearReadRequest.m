//
//  BSMessageContentRequest.m
//  BSKYDoctorPro
//
//  Created by kykj on 2018/4/10.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "BSMessageClearReadRequest.h"

@implementation BSMessageClearReadRequest

- (NSString*)bs_requestUrl {
    return [NSString stringWithFormat:@"/doctor/news/update"];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}
- (NSDictionary*)requestHeaderFieldValueDictionary {
    return @{@"Content-Type": @"application/x-www-form-urlencoded",
             @"headMode": [[BSClientManager sharedInstance] headMode],
             @"token": [BSClientManager sharedInstance].tokenId};
}
- (YTKRequestSerializerType )requestSerializerType{
    return YTKRequestSerializerTypeHTTP;
}
- (id)requestArgument {
    return @{@"type":self.type,
             };
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
}

@end
