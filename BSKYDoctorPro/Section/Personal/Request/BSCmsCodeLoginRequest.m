//
//  BSCmsCodeLoginRequest.m
//  BSKYDoctorPro
//
//  Created by LinfengYU on 2017/8/17.
//  Copyright © 2017年 ky. All rights reserved.
//

#import "BSCmsCodeLoginRequest.h"
#import "IMAccTokenRequest.h"

@implementation BSCmsCodeLoginRequest

- (NSString*)bs_requestUrl {
    NSString *cmsCode = self.cmsCode.length ? [[self.cmsCode encryptCBCStr] urlencode] : @"";
//    return [NSString stringWithFormat:@"/doctor/v1/doctorCmsLogin?phone=%@&cmsCode=%@&randomCek=%@",[[self.phone encryptCBCStr] urlencode], cmsCode,[[NSString enctryptCBCKeyWithRSA] urlencode]];
    return @"/doctor/v1/doctorCmsLogin";
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
    NSString *cmsCode = self.cmsCode.length ? [self.cmsCode encryptCBCStr] : @"";
    return @{
             @"phone":[self.phone encryptCBCStr],
             @"cmsCode":cmsCode,
             @"randomCek":[NSString enctryptCBCKeyWithRSA],
             };
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
 
    NSDictionary* data = self.ret;
    [BSClientManager sharedInstance].userId = data[@"userId"];
    [BSClientManager sharedInstance].loginMark = data[@"loginMark"];
    [BSClientManager sharedInstance].regCode = data[@"regCode"];
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
            if (error.code == 302) {   // 用户在app端登录IM失败时如果返回码是302(token错误)
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
