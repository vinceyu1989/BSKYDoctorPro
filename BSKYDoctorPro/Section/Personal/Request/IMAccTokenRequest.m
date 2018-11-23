//
//  IMAccTokenRequest.m
//  BSKYDoctorPro
//
//  Created by 何雷 on 2018/5/31.
//  Copyright © 2018年 ky. All rights reserved.
//


#import "IMAccTokenRequest.h"

@implementation IMAccTokenRequest

- (NSString*)bs_requestUrl {
    return @"/user/v1/refreshAccToken";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}
- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    if (self.responseObject && [self.responseObject isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = (NSDictionary *)self.responseObject;
        [BSAppManager sharedInstance].currentUser.accToken = dic[@"data"];
    }
    NSString* account = [BSClientManager sharedInstance].lastUsername;
    NSString* token = [BSAppManager sharedInstance].currentUser.accToken;
    [[[NIMSDK sharedSDK] loginManager] login:account token:token completion:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error);
        }else {
            NSLog(@"登录成功");
        }
    }];
}

@end
