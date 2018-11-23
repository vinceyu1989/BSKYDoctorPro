//
//  GWBindingRequest.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/9/22.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "GWBindingRequest.h"

@implementation GWBindingRequest

- (NSString*)bs_requestUrl {
//    return [NSString stringWithFormat:@"/phis/registry?registryInVM=%@", [[self.registryInVM encryptCBCStr] urlencode]];
    return @"/phis/registry";
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
    return @{@"registryInVM":[self.registryInVM encryptCBCStr]};
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}
@end

