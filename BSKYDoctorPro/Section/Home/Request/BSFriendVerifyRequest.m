//
//  BSFriendVerifyRequest.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2017/11/13.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "BSFriendVerifyRequest.h"

@implementation BSFriendVerifyRequest

- (NSString*)bs_requestUrl {
    
    self.realname = [self.realname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
//    return [NSString stringWithFormat:@"/user/v1/verify/realname/auth?idcard=%@&realname=%@",[[self.idcard encryptCBCStr] urlencode],[[self.realname encryptCBCStr] urlencode]];
    return @"/user/v1/verify/realname/auth";
}
- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeHTTP;
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}
- (NSDictionary*)requestHeaderFieldValueDictionary {
    return @{@"Content-Type": @"application/x-www-form-urlencoded",
             @"headMode": [[BSClientManager sharedInstance] headMode],
             @"token": [BSClientManager sharedInstance].tokenId};
}
- (id)requestArgument {
    return @{
             @"idcard":[self.idcard encryptCBCStr],
             @"realname":[self.realname encryptCBCStr],
            };
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    self.model = [BSFriendVerifyModel mj_objectWithKeyValues:self.ret];
    [self.model decryptModel];
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}

@end
