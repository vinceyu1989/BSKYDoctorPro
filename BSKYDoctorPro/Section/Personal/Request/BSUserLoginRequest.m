//
//  BSUserLoginRequest.m
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/8/18.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "BSUserLoginRequest.h"
#import "IMAccTokenRequest.h"

@implementation BSUserLoginRequest

- (NSString*)bs_requestUrl {
    
//    return [NSString stringWithFormat:@"/doctor/v1/doctorPwdLogin?phone=%@&password=%@&randomCek=%@", [[self.phone encryptCBCStr] urlencode], [[self.password encryptCBCStr] urlencode],[[NSString enctryptCBCKeyWithRSA] urlencode]];
    return @"/doctor/v1/doctorPwdLogin";
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
    NSDictionary *dic = @{
                          @"phone":[self.phone encryptCBCStr],
                          @"password":[self.password encryptCBCStr],
                          @"randomCek":[NSString enctryptCBCKeyWithRSA],
                          };
//    return [dic mj_JSONString];
    return dic;
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    
    NSDictionary* data = self.ret;
    [BSClientManager sharedInstance].loginMark = data[@"loginMark"];
    [BSClientManager sharedInstance].regCode = [data[@"regCode"] decryptCBCStr];
    [BSClientManager sharedInstance].tokenId = data[@"token"];
    [BSClientManager sharedInstance].lastUsername = self.phone;
    [BSAppManager sharedInstance].currentUser = [BSUser mj_objectWithKeyValues:data];
    [[BSAppManager sharedInstance].currentUser decryptModel];
    // 登录网易云信
    NSString* account = [BSClientManager sharedInstance].lastUsername;
    NSString* token = [BSAppManager sharedInstance].currentUser.accToken;
    [[[NIMSDK sharedSDK] loginManager] login:account token:token completion:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error);
            if (error.code == 302) {
                [[[IMAccTokenRequest alloc]init] startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                }];
            }
        }else {
            NSLog(@"登录成功");
        }
    }];
    if (self.code == 200) {
        [self postNotification:LoginSuccessNotification];
    }
    
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
    
}

@end
