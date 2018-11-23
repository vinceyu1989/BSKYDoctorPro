//
//  BSGeTuiRequest.m
//  BSKYDoctorPro
//
//  Created by vince on 2018/10/8.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "BSGeTuiRequest.h"

@implementation BSGeTuiRequest
- (NSString*)bs_requestUrl {
//    NSString *urlStr = [NSString stringWithFormat:@"/user/v1/getui?clientid=%@",[[[BSAppManager sharedInstance].getuiClientId encryptCBCStr] urlencode]];
    return @"/user/v1/getui";
//    return urlStr;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}
- (YTKRequestSerializerType )requestSerializerType{
    return YTKRequestSerializerTypeHTTP;
}
- (NSDictionary*)requestHeaderFieldValueDictionary {
    return @{@"Content-Type": @"application/x-www-form-urlencoded",
             @"headMode": [[BSClientManager sharedInstance] headMode],
             @"token": [BSClientManager sharedInstance].tokenId};
}
- (id)requestArgument {
    return @{@"clientid":[[BSAppManager sharedInstance].getuiClientId encryptCBCStr],
             };
}
- (void)requestCompleteFilter {
    [super requestCompleteFilter];
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}
@end
