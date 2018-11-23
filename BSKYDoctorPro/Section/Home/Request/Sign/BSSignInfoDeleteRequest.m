//
//  BSSignInfoDeleteRequest.m
//  BSKYDoctorPro
//
//  Created by kykj on 2018/1/12.
//  Copyright © 2018年 ky. All rights reserved.
//

#import "BSSignInfoDeleteRequest.h"
#import <AFNetworking.h>

@implementation BSSignInfoDeleteRequest

- (NSString*)bs_requestUrl {
    return @"/face/sign/delinfo";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSURLRequest *)buildCustomUrlRequest {

    NSString *baseUrl = [YTKNetworkConfig sharedConfig].baseUrl;
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",baseUrl,[self requestUrl]];
    //创建请求
    NSMutableURLRequest *requst = [[AFJSONRequestSerializer serializer]
                                   requestWithMethod:@"POST"
                                   URLString:requestUrl
                                   parameters:nil
                                   error:nil];
    requst.timeoutInterval = 30;

    //设置请求头，根据自己后台情况而定
    [requst setValue:@"text/plain;encoding=utf-8" forHTTPHeaderField:@"Content-Type"];
    [requst setValue:@"text/plain" forHTTPHeaderField:@"Accept"];
    [requst setValue:[[BSClientManager sharedInstance] headMode] forHTTPHeaderField:@"headMode"];
    [requst setValue:[BSClientManager sharedInstance].tokenId forHTTPHeaderField:@"token"];
    //设置请求体
    [requst setHTTPBody:[[self.signIds encryptCBCStr] dataUsingEncoding:NSUTF8StringEncoding]];

    return requst;

}

//- (NSDictionary*)requestHeaderFieldValueDictionary {
//    return @{@"Content-Type": @"text/plain",
//             @"Accept": @"text/plain",
//             @"headMode": [[BSClientManager sharedInstance] headMode],
//             @"token" : [BSClientManager sharedInstance].tokenId};
//}

//- (id)requestArgument {
//    return self.signIds;//@{@"signIds":self.signIds};
//}

- (void)requestCompleteFilter {
    [super requestCompleteFilter];
}

@end
