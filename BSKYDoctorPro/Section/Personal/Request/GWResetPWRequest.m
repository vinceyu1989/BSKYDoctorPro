//
//  GWResetPWRequest.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/11/21.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "GWResetPWRequest.h"

@implementation GWResetPWRequest

- (NSString*)bs_requestUrl {
    
//    return [NSString stringWithFormat:@"/phis/phis/pswd?password=%@", [[self.password encryptCBCStr] urlencode]];
    return @"/phis/phis/pswd";
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
    return @{@"password":[self.password encryptCBCStr]};
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}

@end
