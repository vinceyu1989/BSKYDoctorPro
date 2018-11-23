//
//  BSNeedEncryption.m
//  BskyResidents
//
//  Created by vince on 2018/8/7.
//  Copyright © 2018年 罗林轩. All rights reserved.
//

#import "BSNeedEncryption.h"

@implementation BSNeedEncryption
- (NSString*)bs_requestUrl {
    return @"/auth/needEncryption";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (NSDictionary*)requestHeaderFieldValueDictionary {
    return @{@"Content-Type": @"application/json",
             @"headMode": [[BSClientManager sharedInstance] headMode],
             };
}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
    
    NSString* data = self.responseObject[@"data"];
    if ([data isKindOfClass:[NSString class]]) {
        [BSAppManager sharedInstance].needEncryption = data;
//        [BSAppManager sharedInstance].needEncryption = @"0";
    }else{
        NSLog(@"%@ error",self);
    }
}

- (void)requestFailedFilter {
    [super requestFailedFilter];
}
@end
